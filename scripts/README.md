# 



Bash script: combine_sequences.sh

Markdown script: group_miRNA_sequences.Rmd

Perl scipt: sRNA_counts.pl

# Shiny script: MIR_loci_overlaps.R 

## run on Linux

apt install r-base
apt-get install libssl-dev
apt-get install libxml2-dev
apt-get install libcurl4-openssl-dev
apt-get install libcurl4-gnutls-dev
apt-get install curl
R -e 'install.packages(c("Rcpp", "httpuv"))'
R -e 'install.packages("shiny")'
R -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'
R -e 'devtools::install_github("AnalytixWare/ShinySky")'

git clone https://github.com/NIB-SI/Potato_sRNA_analysis.git
R -e "shiny::runApp('./Potato_sRNA_analysis/scripts/MIR_loci_overlaps.R')"
