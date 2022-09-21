#!/usr/bin/perl -w
use strict;

my %index_seq; my %index; my $index_seq; my $index_str; my @index=();
open index_file, "$ARGV[2]" or die $!;
while (<index_file>)
{
	chop $_; $index_str=substr($_,1,length($_)-1);
	$_=<index_file>; 
	chop $_; $index_seq{substr($_,1,length($_)-1)}=$index_str; $index{$index_str}=substr($_,1,length($_)-1);
	push (@index,$index_str);
}	
close index_file;

my $l_fastq=@ARGV;
my @r1_list; my @r2_list; my @r1_name; my @r2_name; my $r1_name; my $r2_name;
if ($l_fastq==2) { push (@r1_list,$ARGV[0]); }
elsif ($l_fastq==3) { push (@r1_list,$ARGV[0]); push (@r2_list,$ARGV[1]); }

my $count; my %index_count; my $eight; my @r1_tmp; my @r2_tmp; 
my $r1; my $r2; my $percentage; my $command; my $return;
for (my $sample=0; $sample<=@r1_list-1; $sample++)
{
	if (@r2_list>0)
	{
		@r1_name=split(/_R1/,$r1_list[$sample]);
		@r2_name=split(/_R2/,$r2_list[$sample]);
	
		my %r1_out; my %r2_out;
		for (my $index=0; $index<=@index-1; $index++)
		{
			local *FILE;
			open FILE, " | gzip -c > $r1_name[0]\_$index[$index]\_indexed_R1$r1_name[1]" or die $!;
			$r1_out{$index[$index]}=*FILE;
			local *FILE;
			open FILE, " | gzip -c > $r2_name[0]\_$index[$index]\_indexed_R2$r2_name[1]" or die $!;
			$r2_out{$index[$index]}=*FILE;
		}	


		my $count; my %index_count; my $six;
		open r1_fastq_in, "gzip -cd $r1_list[$sample] | " or die $!;
		open r2_fastq_in, "gzip -cd $r2_list[$sample] | " or die $!;
		$count=0; @r1_tmp=(); @r2_tmp=();
		while (<r1_fastq_in>)
		{
			chop $_; $count++;
			$r1=$_; $r2=<r2_fastq_in>; chop $r2;
			push (@r1_tmp, $r1); push (@r2_tmp,$r2);
			if (!($count%4))
			{
				$eight=substr($r1_tmp[1],0,8);
				if (exists $index_seq{$eight})
				{
					if (!exists $index_count{$index_seq{$eight}}) { $index_count{$index_seq{$eight}}=0; }
					$index_count{$index_seq{$eight}}++;
					print {$r1_out{$index_seq{$eight}}} "$r1_tmp[0]\n$r1_tmp[1]\n$r1_tmp[2]\n$r1_tmp[3]\n";
					print {$r2_out{$index_seq{$eight}}} "$r2_tmp[0]\n$r2_tmp[1]\n$r2_tmp[2]\n$r2_tmp[3]\n";
				}
				else
				{
					if (!exists $index_count{0}) { $index_count{0}=0; }
					$index_count{0}++;
				}
				@r1_tmp=(); @r2_tmp=();
			}
		}
		for (my $index=0; $index<=@index-1; $index++)
		{
			close $r1_out{$index[$index]};
			close $r2_out{$index[$index]};
			if (!exists $index_count{$index[$index]}) 
			{
				$command="rm $r1_name[0]\_$index[$index]\_indexed_R1$r1_name[1]";
				print "$command\n"; $return=system($command);
				$command="rm $r2_name[0]\_$index[$index]\_indexed_R2$r2_name[1]";
				print "$command\n"; $return=system($command);
			}
		}
		close r1_fastq_in;
		close r2_fastq_in;

		open summary_out, ">$r1_name[0]\_summary.txt" or die $!;
		$count=int($count/4);
		print summary_out "total reads - $count\n";
		for (sort {$a cmp $b} keys %index_count) 
		{
			$percentage=sprintf('%.1f',100*($index_count{$_}/$count)); $percentage="$percentage%";
			if (!$_) { print summary_out "undertermined index\t\t$index_count{$_}\t$percentage\n"; }
			else { print summary_out "index $_\t$index{$_}\t$index_count{$_}\t$percentage\n"; }
		}
		close summary_out;
	}
} 

