# zagor

# pip install biopython

import sys
from Bio import SeqIO

param1 = sys.argv[1] # ./path/first_occurence.txt
param2 = sys.argv[2] # ./path/combinedID.txt
param3 = sys.argv[3] # ./path/tmp_output.fasta
param4 = sys.argv[4] # ./path/output.fasta

with open(param1, "r") as f1:
    a1 = f1.readlines()
    f2 = open(param2, "r")
    a2 = f2.readlines()
f2.close()
record_ids1 = []
record_ids2 = []
record_ids1 = list(map(str.strip, a1))
record_ids2 = list(map(str.strip, a2))

with open(param4, 'w') as outFile:
    for record in SeqIO.parse(param3, 'fasta'):
        # print(record.id)
        if record.id in record_ids1:
            pos = [i for i,x in enumerate(record_ids1) if x == record.id]
            # print(record.id)
            record.id = record_ids2[pos[0]]
            # print(record.id)
            record.name = record.id
            # print("---")
            # print(record.name)
            record.description = None
            record.description = ""
        SeqIO.write(record, outFile, 'fasta')
