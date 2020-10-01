# 

Minimal test and example files
<br />

- TestFile_Results.txt - as output from **ShortStack**’s 
- TestFile_unique_stu_mature.fasta - as output from **FASTA_unique_sequences_all_IDs.sh** (and input for **sRNA_counts.pl**)
- TestFile_number_and_list_of_duplicated_seqs.txt - as output from **FASTA_unique_sequences_all_IDs.sh**
- TestFile_miRNA_5p-3p_grouping.txt - as output from **group_miRNA_sequences.Rmd**
- TestFile_isomiRs.txt - as output from **group_miRNA_sequences.Rmd**
- TestFile_known_miRNAs_counts.txt - as output from **sRNA_counts.pl** when using one analyzed sRNA sequencing sample
- TestFile-known_miRNAs.fasta - as output from chunk: _filter table by column, extract IDs and create subsetted fasta_
- TestFile_mature_miRNAs.fasta - as output from **combine_sequences.sh**
- TestFile_pre-miRNAs.fasta - as output from **combine_sequences.sh**
- TestFile_star_miRNAs.fasta - as output from **combine_sequences.sh**
- TestFile_r0-Cutoff.txt - as output from [isomiRID.py](https://github.com/lfelipedeoliveira/isomiRID)
- TestFile_count_table.txt - as output from **sRNA_counts.pl** when using multiple analyzed sRNA sequencing samples; also as input for differential expression analysis
<br />

- EXAMPLE_sRNAs_unmapped_uniqueIDs.fasta - as output from code chunk: _non-unique to unique FASTA IDs_
- EXAMPLE_stu_mature.tsv - as output from code chunk: _convert .fasta to tab delimited file_
- EXAMPLE_fas.1.clstr.sorted - as output from [cd-hit-est](http://weizhong-lab.ucsd.edu/cdhit_suite/cgi-bin/index.cgi?cmd=cd-hit-est)
- EXAMPLE_alias.txt - an example of a translation table for FASTA header replacement (tab-separted); here from short IDs to extended IDs (IDs + additional description)
- EXAMPLE_isomiRs.fasta - an example of a file, including strict ID definition
- EXAMPLE_novel_miRNAs.fasta - an example of a file, including strict ID definition
