# 📚 run scripts on Ubuntu based Linux distribution

## prior to running scripts

```
$ apt update # to install Git with Apt

$ apt install git

$ apt install r-base

$ apt-get install libssl-dev libxml2-dev libcurl4-openssl-dev libcurl4-gnutls-dev curl

$ apt-get install pandoc

$ git clone https://github.com/NIB-SI/Potato_sRNA_analysis.git

$ apt-get install moreutils

```

## In case of non-unique FASTA IDs -> make them unique
### 🏷 one possible way as follows:
```
# changing the existing fasta file
$ INP="test.fasta"
$ awk '/^>/ {$0=$0".Seq"++count[$0]}1' $INP | sponge $INP
# or without sponge, using input/output files
$ awk '/^>/ {$0=$0"_Seq"++count[$0]}1' input.fasta > output.fasta
```

## 📓 Shiny script: MIR_loci_overlaps.R

```
R -e 'install.packages(c("Rcpp", "httpuv"))'

R -e 'install.packages("shiny")'

R -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'

R -e 'devtools::install_github("AnalytixWare/ShinySky")'

# run app
R -e "shiny::runApp('./Potato_sRNA_analysis/scripts/MIR_loci_overlaps.R')"
```
or use 🍂 https://nib-si.shinyapps.io/MIR_loci_overlaps/

Input/Output interactive, however is suggested to use ../input/ ../output/ directories

## 📓 Markdown script: group_miRNA_sequences.Rmd
```
R -e 'install.packages("rmarkdown", repos="https://cran.rstudio.com/")'
R -e 'install.packages("tictoc", repos="https://cran.rstudio.com/")'

# run script
Rscript -e "rmarkdown::render('./Potato_sRNA_analysis/scripts/group_miRNA_sequences.Rmd')"
```
Expecting input from Potato_sRNA_analysis/input/MIRNAs/

Writing output to Potato_sRNA_analysis/output/

## 📓 Bash script: combine_sequences.sh
```
$ bash ./Potato_sRNA_analysis/scripts/combine_sequences.sh \
./Potato_sRNA_analysis/input/MIRNAs/ \
./Potato_sRNA_analysis/output/

```
Expecting input from Potato_sRNA_analysis/input/MIRNAs/

Writing output to Potato_sRNA_analysis/output/


## 📓 Bash script: FASTA_unique_sequences_all_IDs.sh
```
$ pip install biopython
$ bash FASTA_unique_sequences_all_IDs.sh ../input/input.fasta ../output/ 1
```
Check python and pip version using ```pip --version;  python --version```. If version 3 is not your default versions, use ```pip3 install biopython```.

Provide path to the input fasta file (e.g. ../input/input.fasta), output directory (e.g. ../output) and number of threads (e.g. 1).

-  ```rmdup``` removes duplicated sequences by id/name/sequence
-  ```--id-ncbi``` denotes that FASTA header is NCBI-style, e.g. >NC_003071.7:16108235-16110766 Arabidopsis thaliana chromosome 2 sequence
-  command ```cut -d "delimiter" -f``` cuts object by fields; uses tab as a default field delimiter; work with other delimiter defined using -d option
- If you don't want ncbi-styled IDs (i.e. only 'pure' IDs without any additional text/marks post first space) remove ```--id-ncbi``` from the ```seqkit rmdup --ignore-case --id-ncbi --by-seq \``` line and optionally ``` -d ' '```  from the ``` sed 's/,/\t/g' $out"/list_of_duplicated_seqs.txt" | cut -d ' ' -f1 > $out"/first_occurence.txt"```  line.

-  ```sed```, a stream editor, used here to substitute text; pattern matching based upon regular expression
- If you wish to change | ID separator (e.g. stT-miR156a MIMAT0031296|stT-miR156b MIMAT0031297) with e.g. \_> (or other character combination), replace | with \_> (or other character combination) in ``` sed 's/, /|/g' $out"/list_of_duplicated_seqs.txt" > $out"/combinedID.txt" ``` line.


## 📓 Perl scipt: sRNA_counts.pl
```
$ ./sRNA_counts.pl
Usage: sRNA_counts options files ...
Options:
  -seqtab=inpseq.fasta      - sequence selection file (fasta format)
  -output=outfn.csv         - tab separated output file (D=stdin)
  -partial                  - also match as a subsequence (D=exact match)
  inpfn.fasta               - input file (fasta format)
```

# 📝 Useful links and code lines

## convert line breaks from DOS to Unix format (dos2unix) and vice versa (unix2dos)
```
$ apt-get install dos2unix

$ dos2unix --help
dos2unix 6.0.4 (2013-12-30)
Usage: dos2unix [options] [file ...] [-n infile outfile ...]
...
```
<https://en.wikipedia.org/wiki/Unix2dos>

## convert .fasta to tab delimited file
```
$ python3
>>> from Bio import SeqIO
>>> myFasta = SeqIO.parse("stu_mature.fasta", "fasta")
>>> myTSV = SeqIO.write(myFasta, "stu_mature.tsv", "tab")
>>> exit()
```
e.g. for converting stu_mature.fasta to stu_mature.tsv using biopython.org/wiki/SeqIO

## replace Uracil with Thymine using sed and sponge (soaks up standard input and writes to a file)
```
# apt-get install moreutils
$ sed '/^[^>]/ y/uU/tT/' pathTo/myFasta.fasta | pathTo/myFasta.fasta
```

## filter table by column, extract IDs and create subsetted fasta
```
# get IDs for which (sums of) counts in sequential columns are > 0 
$ awk -F "\t" '{
      count=0;
      for(i=2;i<=NF;i++){
          if($i==0)++count;
      }
      if(count<(NF-1))print
      }' \
      ../output/known_miRNAs_counts.txt | cut -d ' ' -f1 | sed '1d' > \
      ../output/IDs.txt

$ awk -F "\t" '{
      count=0;
      for(i=2;i<=NF;i++){
          if($i==0)++count;
      }
      if(count<(NF-1))print
      }' \
      ../output/count_table.txt | cut -f1 | sed '1d' > \
      ../output/longIDs.txt

$ paste -d "\t" ../output/IDs.txt ../output/longIDs.txt > ../output/alias.txt
$ rm ../output/longIDs.txt

# create subset fasta using those IDs
$ xargs samtools faidx  ../output/unique_stu_mature.fasta < ../output/IDs.txt > ../output/known_miRNAs.fasta
$ rm ../output/IDs.txt

# return extended IDs using alias translation table
$ awk 'NR==FNR{a[$1]=$2;next}
NF==2{$2=a[$2]; print ">" $2;next}
1' FS='\t' ../output/alias.txt FS='>' ../output/known_miRNAs.fasta | sponge ../output/known_miRNAs.fasta
$ rm ../output/alias.txt
```

## Bash on Ubuntu on Windows

Described at [How to Install and Use the Linux Bash Shell on Windows 10](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)

## Cygwin

[Cygwin User's Guide](https://cygwin.com/cygwin-ug-net.html)

## Wine

[Wine](https://www.winehq.org/)


## Shiny and R Markdown

[How to launch a Shiny app](https://shiny.rstudio.com/articles/running.html/)

[Welcome to Shiny](https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/)

[R Markdown introduction](https://rmarkdown.rstudio.com/lesson-1.html)

## FAIR data

[The FAIR Guiding Principles for scientific data management and stewardship](https://www.nature.com/articles/sdata201618)

[pISA](https://github.com/NIB-SI/pISA)

[pISAR](https://github.com/NIB-SI/pisar)

[SEEK](https://seek4science.org/)
