#!/usr/bin/perl
# -*- mode: perl; perl-indent-level: 2; -*-

use strict;
use Warehouse;
use Warehouse::Stream;
use Warehouse::Manifest;

my $whc = new Warehouse;
my $m = new Warehouse::Manifest (whc => $whc,
				 key => $ARGV[0]);
my %sum;
while (my $s = $m->subdir_next)
{
  $s->rewind;
  while (my ($pos, $size, $filename) = $s->file_next)
  {
    last if !defined $pos;
    $s->seek ($pos);    
    while (my $dataref = $s->read_until (undef, "\n"))
    {
      if ($$dataref =~ /^m=(\d+) n=(\d+) (..)=(\d+)$/)
      {
	$sum{"$1,$2,$3"} += $4;
      }
    }
  }
}

my @xy = qw(ac ag at ca cg ct ga gc gt ta tc tg);
my %m;
my %n;

print (join ("\t", qw(m n), @xy), "\n");

foreach (sort keys %sum)
{
  my ($m, $n, $xy) = split (/,/);
  $m{$m} = 1;
  $n{$n} = 1;
}
for my $m (sort { $a <=> $b } keys %m)
{
  for my $n (sort { $a <=> $b } keys %n)
  {
    my @N = map { $sum{"$m,$n,$_"} + 0 } @xy;
    print (join ("\t", $m, $n, @N), "\n");
  }
}