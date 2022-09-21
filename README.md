This repository contains tools to demultiplex reads from the Luo lab's single-nucleus sequencing assays, including ([snmCAT-seq](https://www.cell.com/cell-genomics/fulltext/S2666-979X(22)00027-1), [sn-m3C-seq](https://www.ncbi.nlm.nih.gov/pubmed/31501549), [snmC-seq2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6147798/)). The below scripts allow an analyst to go from sequencing reads pooled across a given 384-well plate to well-specific reads (e.g., PlateABC.fastq.gz output from BaseSpace --> PlateABC_A01_indexed_R1.fastq.gz & PlateABC_A01_indexed_R2.fastq.gz, ..., PlateABC_P24_indexed_R1.fastq.gz, PlateABC_P24_indexed_R2.fastq.gz).

For more details on demultiplexing barcode structure, please see read diagrams previously documented with the [Ecker Lab](https://hq-1.gitbook.io/mc/tech-background/barcoding) and the aforementioned assay papers.

**Scripts:** (by Chongyuan Luo)
* fastq_demultiplex.pl : core perl script for demultiplexing barcodes
* fastq_demultiplex.py : identifies .fastq files in a directory to apply to .pl script; ultimately generates a wrapper script (.sh) that is then submitted to cluster job manager (`qsub fastq_demultiplex.sh`)

**Fasta Files:** reference files containing the barcode sequences
* barcodes/random_index_v2.multiplex_group_1.fa
* barcodes/random_index_v2.multiplex_group_2.fa

**Note on File Paths:**
the .py script assumes that .fastqs are stored in subdirectory "fastq/". edit paths in line 8 and line 16 of fastq_demultiplex.py accordingly if the location of input .fastq files or barcode locations are respectively moved.