# optional: merging multiple files with a clear pattern in the name
# cat pre-miRNAs*.xx > pre-miRNAs.xx
# cat mature-miRNAs*.xx > mature-miRNAs.xx
# cat star_miRNAs*.xx > star_miRNAs.xx


if [[ $# -lt 2 ]]; then
    echo "Arguments not supplied."
    echo "Provide path to the input and output folder."
    echo "e.g.     sh combine_sequences.sh ../input/MIRNAs/ ../output/"
    exit 1
fi

in=${1%/}
out=${2%/}

touch $out/pre-miRNAs.fasta
touch $out/mature_miRNAs.fasta
touch $out/star_miRNAs.fasta


for file in $in/*.txt # for all files with .txt extension in folder
do  
    line0=">"
    line0+=$(head -1 "$file" | tail -1)
    line01=${line0// /_}
    str2=$(head -3 "$file" | tail -1)
    echo $line01 >> $out/pre-miRNAs.fasta # write string to a file
    echo $str2 >> $out/pre-miRNAs.fasta

    line=$(head -5 "$file" | tail -1) # read fifth line to a string
    str1=${line%% *} # split string by space
    str2="${str1//.}" # remove dots
    echo $line01 >> $out/mature_miRNAs.fasta # write string to a file
    echo $str2 >> $out/mature_miRNAs.fasta

    line=$(head -6 "$file" | tail -1)
    str1=${line%% *}
    str2="${str1//.}"
    echo $line01 >> $out/star_miRNAs.fasta # write string to a file
    echo $str2 >> $out/star_miRNAs.fasta
done

