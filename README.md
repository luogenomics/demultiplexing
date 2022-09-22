### Luo Lab Demultiplexing Scripts

**Basic Operation:**

```
python fastq_demultiplex.py
qsub -l h_mem=24G,h_rt=2:00:00 fastq_demultiplex.sh
```

**About:**

This repository contains tools to demultiplex reads from the Luo lab's single-nucleus sequencing assays, including [snmCAT-seq](https://www.cell.com/cell-genomics/fulltext/S2666-979X(22)00027-1), [sn-m3C-seq](https://www.ncbi.nlm.nih.gov/pubmed/31501549), and [snmC-seq2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6147798/).

The scripts allow an analyst to go from sequencing reads pooled across a given 384-well plate to well-specific reads.

That is, PlateABC_R1.fastq.gz output from BaseSpace --> PlateABC_A01_indexed_R1.fastq.gz, PlateABC_A02_indexed_R1.fastq.gz, ..., PlateABC_P24_indexed_R1.fastq.gz (and its paired Read 2 PlateABC_R2.fastq.gz --> PlateABC_A01_indexed_R2.fastq.gz, ..., assumed to be in the same folder). Demultiplexing is usually the first step in our lab's read processing pipelines.

For more details on the structure of reads/demultiplexing barcodes, please see diagrams previously documented with the [Ecker Lab](https://hq-1.gitbook.io/mc/tech-background/barcoding) and the aforementioned assay papers.

### File Contents

**Scripts:** (by Chongyuan Luo)
* fastq_demultiplex.pl : core perl script for demultiplexing barcodes
* fastq_demultiplex.py : identifies .fastq files in a directory to apply to .pl script; ultimately generates a wrapper script (.sh) applying the perl script to each file. the resulting wrapper script is then submitted to the cluster job manager (`qsub fastq_demultiplex.sh`)

**Fasta Files:** reference files containing the barcode sequences
(split into two .fa files to run jobs with lower memory requirements)
* barcodes/random_index_v2.multiplex_group_1.fa
* barcodes/random_index_v2.multiplex_group_2.fa

**Note on File Paths:**
the .py script assumes that .fastqs are stored in subdirectory "fastq/". edit paths in line 8 and line 16 of fastq_demultiplex.py accordingly if the location of input .fastq files or barcode locations are respectively moved.
