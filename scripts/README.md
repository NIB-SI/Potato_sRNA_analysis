# 📚 run scripts on Ubuntu based Linux distribution

## prior to running scripts

```
apt install r-base

apt-get install libssl-dev libxml2-dev libcurl4-openssl-dev libcurl4-gnutls-dev curl

apt-get install pandoc

git clone https://github.com/NIB-SI/Potato_sRNA_analysis.git

apt-get install moreutils

```

## In case of non-unique FASTA IDs -> make them unique
### 🏷 one possible way as follows:
```
# changing the existing fasta file
INP="test.fasta"
awk '/^>/ {$0=$0".Seq"++count[$0]}1' $INP | sponge $INP
# or without sponge, using input/output files
awk '/^>/ {$0=$0"_Seq"++count[$0]}1' input.fasta > output.fasta
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

# run script
Rscript -e "rmarkdown::render('./Potato_sRNA_analysis/scripts/group_miRNA_sequences.Rmd')"
```
Expecting input from Potato_sRNA_analysis/input/MIRNAs/

Writing output to Potato_sRNA_analysis/output/

## 📓 Bash script: combine_sequences.sh
```
sh combine_sequences.sh
```
Expecting input from Potato_sRNA_analysis/input/MIRNAs/

Writing output to Potato_sRNA_analysis/output/


## 📓 Bash script: FASTA_unique_sequences_all_IDs.sh
```
# pip install biopython
sh FASTA_unique_sequences_all_IDs.sh pathTo/input.fasta outputDirectory 1
```
Check python and pip version using ```pip --version;  python --version```. If version 3 are not your default versions use ```pip3 install biopython```.
Provide path to the input fasta file (e.g. ../input/input.fasta), output directory (e.g. ../output) and number of threads (e.g. 1).


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

# 📝 Useful links 

## convert line breaks from DOS to Unix format (dos2unix) and vice versa (unix2dos)
```
apt-get install dos2unix

$ dos2unix --help
dos2unix 6.0.4 (2013-12-30)
Usage: dos2unix [options] [file ...] [-n infile outfile ...]
...
```
<https://en.wikipedia.org/wiki/Unix2dos>

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
