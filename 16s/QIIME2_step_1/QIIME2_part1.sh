# Activate the Qiime2 environment in Conda
conda activate qiime2-2022.8

# Set the input directory path
INP_DIR="/Users/davide/Desktop/metagenomics/16s/PRJNA818796"

# Unzip compressed files
gunzip $INP_DIR/*.gz

# Create folders for outputs
mkdir $INP_DIR/dada2_output
mkdir $INP_DIR/table
mkdir $INP_DIR/classification 
mkdir $INP_DIR/final_output 

# Create metadata and manifest files
mv $INP_DIR/files/SraR* $INP_DIR/files/SraRunInfo.csv
python scripts/create_metadata_and_manifest.py


# Import paired-end sequences and quality data as a Qiime2 artifact
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $INP_DIR/files/manifest.tsv  \
  --output-path $INP_DIR/files/paired-end-demux.qza \
  --input-format PairedEndFastqManifestPhred33V2

# Generate a summary of the demultiplexed sequences
qiime demux summarize \
  --i-data $INP_DIR/files/paired-end-demux.qza \
  --o-visualization $INP_DIR/files/paired-end-demux.qzv

# Choose parameters for DADA2 based on the demultiplexing summary visualization
