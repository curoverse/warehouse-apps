#!/usr/bin/perl

use strict;
use Warehouse;
use Warehouse::Stream;

my %opt;
while ($ARGV[0] =~ /^--(\S+)(?:=(.*))?/)
{
    $opt{$1} = defined($2) ? $2 : 1;
    shift @ARGV;
}

if (@ARGV != 1)
{
    die <<EOF;
usage: whence [options] {key|jobid}[\@warehouse]
options:
       --skip-thawed     don\'t follow freeze/thaw cycles
       --node-seconds    show total #nodes * seconds allocated to each job
       --slots           show number of slots (maximum concurrent job steps)
       --slot-seconds    show number of slots * job duration
       --failure-seconds show total slot seconds for failed job steps
       --success-seconds show total slot seconds for successful job steps
       --idle-seconds    show total slot seconds not accounted for by job steps
       --recovery-route  show list of jobs to rerun to recover key|jobid
EOF
}

my %opts;
$opts{warehouse_name} = $1 if $ARGV[0] =~ s/\@(.+)//;
my $whc = new Warehouse (%opts);

my $joblist = $whc->job_list;
my %did;
my %id_to_job;
for my $job (@$joblist)
{
    $id_to_job{$job->{id}} = $job;
}

my %inputdata;
my @todo;
my %depends;

map { /^\d{1,31}$/ ? push (@todo, $id_to_job{$_}) : &enqueue (/([0-9a-f]{32})/g) } @ARGV;

while (@todo)
{
    my $targetjob = shift @todo;
    next if ++$did{$targetjob->{id}} != 1;

    printf "#%d\@%s\n", $targetjob->{id}, $whc->{warehouse_name};
    print_times ($whc->job_stats ($targetjob->{id}));
    printf "  mrfunction = %s r%d\n", $targetjob->{mrfunction}, $targetjob->{revision};

    if (($opt{"skip-thawed"} && $targetjob->{revision} != -1)
	|| !$targetjob->{thawedfromkey})
    {
	printf "  output = %s\n", $targetjob->{outputkey};
	printf "  input = %s\n", $targetjob->{inputkey};
	my $knobs = $targetjob->{knobs};
	my %unescape = ("n" => "\n", "\\" => "\\");
	$knobs =~ s/\\(.)/$unescape{$1}/ge;
	map { printf "  %s\n", $_ } split (/\n/, $knobs);
	print "\n";

	&enqueue ($targetjob->{inputkey},
		  $targetjob->{knobs});
    }
    else
    {
	printf "  output = %s\n", $targetjob->{outputkey};
	printf ("  thawedfromkey = %s\n", $targetjob->{thawedfromkey});
	unshift @todo, $whc->job_follow_thawedfrom ($targetjob);
    }
}

sub enqueue
{
    my @hashes = map { /([0-9a-f]{32})/g } @_;
    while (@hashes)
    {
	my $upto;
	for ($upto = $#hashes; $upto >= 0; $upto--)
	{
	    my $targethash = join (",", @hashes[0..$upto]);
	    my $jobmade = $whc->job_follow_input ({ inputkey => $targethash });
	    if ($jobmade)
	    {
		unshift @todo, $jobmade;
		splice @hashes, 0, $upto + 1;
		last;
	    }
	}
	if ($upto < 0)
	{
	    ++$upto;
	    $inputdata{shift @hashes} = 1;
	}
    }
}

my %loop_detected;
map {
    if (!$loop_detected{$_} &&
	&check_loop($_, {}))
    {
	warn "$_ is part of a cycle; assuming it is not buildable\n";
	$inputdata{$_} = 1;
    }
} sort keys %depends;

print "\nInputs:\n";
print map { "$_\n" } sort keys %inputdata;


sub check_loop
{
    my $out = shift;
    my $loop_checked = shift;
    return 1 if 1 != ++$loop_checked->{$out};
    for my $in (keys %{$depends{$out}})
    {
	return 1 if &check_loop ($in, $loop_checked);
    }
    return 0;
}

sub print_times
{
    my $job = shift;
    my $metastats = $job->{meta_stats};
    if ($job)
    {
	printf ("  --node-seconds = %d = %d nodes * %d seconds\n",
		$job->{nodeseconds},
		$job->{nnodes},
		$job->{elapsed});
	printf ("  --slot-seconds = %d = %d slots * %d seconds\n",
		$metastats->{slot_seconds},
		$metastats->{slots},
		$job->{elapsed});
	foreach (qw(success failure idle))
	{
	    printf ("  --$_-seconds = %d%s\n",
		    $metastats->{$_."_seconds"},
		    $metastats->{$_."_percent"}
		    ? " = ".$metastats->{$_."_percent"}."%" : "");
	}
    }
}
