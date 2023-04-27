
# folder where we need the .fastq files 

INP_DIR="/Users/davide/Desktop/metagenomics/16s/PRJNA818796"

mkdir -p $INP_DIR/SRA

# bin folder of the sra tool-kit 

BIN_DIR="/Users/davide/Desktop/SRA_ToolKit/3.0.0/bin/"

# in the INP_DIR we need another folder I called "files" with the SraRunInfo,csv and biosample-result.txt files we downloaded from the SRA website

FILE=$INP_DIR"/files/SraRunInfo.csv"
chmod 755 $FILE

# save the "Run" column into an array 

arr=($(awk -F "," '{print $1}' $FILE))
unset arr[0]

for ID in "${arr[@]}"; do
        echo "Run : $ID"
done

# download .sra files

for ID in "${arr[@]}"; do
        $BIN_DIR/./prefetch $ID -O $INP_DIR/SRA
        echo "downloaded"
done

# convert .sra files in .fastq

for file in $INP_DIR/SRA/SRR*/*.sra
do
    $BIN_DIR/./fastq-dump --gzip --split-files "$file" -O $INP_DIR
done

rm -rf $INP_DIR/SRA



