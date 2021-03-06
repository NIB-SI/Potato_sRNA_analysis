#!/bin/sh
# zagor

# sh FASTA_unique_sequences_all_IDs.sh ../input/input.fasta ../output 4

# remove duplicates by sequence
# write IDs of duplicates to a file
# $1 relative (or absolute) path to the input fasta: ../input/input.fasta
# $2 relative (or absolute) path to the output folder: ../output
# $4 number of threads: 4

if [[ $# -lt 3 ]]; then
    echo "Arguments not supplied."
    echo "Provide path to the input fasta, output folder and number of threads."
    echo "e.g.     sh FASTA_unique_sequences_all_IDs.sh ../input/input.fasta ../output 4"
    exit 1
fi

thr=$(grep -c processor /proc/cpuinfo)
# echo $thr
# echo $3
if echo "$3" | egrep -q '^\-?[0-9]+$'; then
    if [ $3 -gt $thr ]; then
        echo $3 ": invalid number of threads --" $thr "available".
        exit 1
    fi
else 
    echo $3 ": invalid number of threads."
    exit 1
fi


in=${1%/}
out=${2%/}
# echo $in
# echo $out

fout=$(basename $in)
# echo $fout


seqkit rmdup --ignore-case --id-ncbi --by-seq \
--dup-num-file $out"/number_and_list_of_duplicated_seqs.txt" \
--line-width 0 --out-file $out"/tmp_output.fasta" \
--threads $3 $in


# ignore the number of duplicates, keep only IDs
cut -f2 $out"/number_and_list_of_duplicated_seqs.txt" > $out"/list_of_duplicated_seqs.txt"
# list of kept sequences, ID to be extended
sed 's/,/\t/g' $out"/list_of_duplicated_seqs.txt" | cut -d ' ' -f1 > $out"/first_occurence.txt"
# replace with concatenated IDs
sed 's/, /|/g' $out"/list_of_duplicated_seqs.txt" > $out"/combinedID.txt"

# replace IDs using python script
# replace IDs using python script
### python3 keep_all_IDs.py $out"/first_occurence.txt" $out"/combinedID.txt" $out"/tmp_output.fasta" $out"/output.fasta"
python3 -c "\
try:
    import Bio
    import subprocess
    subprocess.call('python3 FASTA_unique_sequences_all_IDs.py $out"/first_occurence.txt" $out"/combinedID.txt" $out"/tmp_output.fasta" $out"/unique_"$fout', shell=True)
except ImportError:
    print('\ninstall biopython using     pip install biopython     command')"

rm $out"/first_occurence.txt"
rm $out"/list_of_duplicated_seqs.txt"
rm $out"/tmp_output.fasta"
rm $out"/combinedID.txt"

echo "Your output file is:" $out"/unique_"$fout
