#/usr/bin/env python
import os
import sys
import pipes
import re

fastq_ls=pipes.Template()
fastq_ls.append('ls fastq/*_R1*.fastq.gz ','--')

demultiplex_script=open('fastq_demultiplex.sh','w')
fastq_list=fastq_ls.open('','r')
fastq=fastq_list.readline().rstrip()
while fastq:
	fastq_r2=fastq.replace("_R1","_R2")
	for batch in range(1,3):
		demultiplex_script.write("perl fastq_demultiplex.pl "+fastq+" "+fastq_r2+" barcodes/random_index_v2.multiplex_group_"+str(batch)+".fa"+"\n");
	fastq=fastq_list.readline().rstrip()


