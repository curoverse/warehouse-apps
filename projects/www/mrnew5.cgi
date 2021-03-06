#!/usr/bin/perl

use strict;
use DBI;
use CGI ':standard';

do '/etc/polony-tools/config.pl';

my $q = new CGI;

my $knobs = $q->param('knobs');
$knobs =~ s/^\#.*\n//gm;

my $dbh = DBI->connect($main::mapreduce_dsn,
		       $main::mrwebgui_mysql_username,
		       $main::mrwebgui_mysql_password) or die DBI->errstr;
$dbh->do ("insert into mrjob
 (jobmanager_id, submittime, nodes, revision, mrfunction, input0, knobs)
 values (-1, now(), ?, ?, ?, ?, ?)",
	  undef,
	  $q->param('nodelist'),
	  $q->param('revision'),
	  $q->param('mrfunction'),
	  nocr($q->param('input')),
	  nocr($knobs))
    or die $dbh->errstr;
my $jobid = $dbh->last_insert_id (undef, undef, undef, undef);
$dbh->do ("insert into mrjobstep
 (jobid, level, input, submittime)
 values (?, 0, ?, now())",
	  undef,
	  $jobid,
	  nocr($q->param('input')))
    or die $dbh->errstr;
$dbh->do ("update mrjob set jobmanager_id=null where id=?", undef, $jobid)
    or die $dbh->errstr;

print $q->redirect("mrindex.cgi");

sub nocr
{
  local ($_) = shift;
  s/\r//g;
  $_;
}
