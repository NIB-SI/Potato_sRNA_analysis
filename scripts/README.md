# run scripts on Ubuntu based Linux distribution 

```
apt install r-base

apt-get install libssl-dev libxml2-dev libcurl4-openssl-dev libcurl4-gnutls-dev curl

apt-get install pandoc

git clone https://github.com/NIB-SI/Potato_sRNA_analysis.git

```

## Shiny script: MIR_loci_overlaps.R 

```
R -e 'install.packages(c("Rcpp", "httpuv"))'

R -e 'install.packages("shiny")'

R -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'

R -e 'devtools::install_github("AnalytixWare/ShinySky")'

# run app
R -e "shiny::runApp('./Potato_sRNA_analysis/scripts/MIR_loci_overlaps.R')"
```

## Markdown script: group_miRNA_sequences.Rmd
```
R -e 'install.packages("rmarkdown", repos="https://cran.rstudio.com/")'

# run script
Rscript -e "rmarkdown::render('./Potato_sRNA_analysis/scripts/group_miRNA_sequences.Rmd')"
```

## Bash script: combine_sequences.sh

## Perl scipt: sRNA_counts.pl
