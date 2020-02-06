# optional: merging multiple files with a clear pattern in the name
# cat pre-miRNAs*.xx > pre-miRNAs.xx
# cat mature-miRNAs*.xx > mature-miRNAs.xx
# cat star_miRNAs*.xx > star_miRNAs.xx

touch ../output/pre-miRNAs.fasta
touch ../output/mature_miRNAs.fasta
touch ../output/star_miRNAs.fasta


for file in ../input/MIRNAs/*.txt # for all files with .txt extension in folder
do  
    line0=">"
    line0+=$(head -1 "$file" | tail -1)
    line01=${line0// /_}
    str2=$(head -3 "$file" | tail -1)
    echo $line01 >> ../output/pre-miRNAs.fasta # write string to a file
    echo $str2 >> ../output/pre-miRNAs.fasta

    line=$(head -5 "$file" | tail -1) # read fifth line to a string
    str1=${line%% *} # split string by space
    str2="${str1//.}" # remove dots
    echo $line01 >> ../output/mature_miRNAs.fasta # write string to a file
    echo $str2 >> ../output/mature_miRNAs.fasta

    line=$(head -6 "$file" | tail -1)
    str1=${line%% *}
    str2="${str1//.}"
    echo $line01 >> ../output/star_miRNAs.fasta # write string to a file
    echo $str2 >> ../output/star_miRNAs.fasta
done

