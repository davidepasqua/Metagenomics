# Activate the QIIME2 environment
conda activate qiime2-2022.8

# Set the input directory path
INP_DIR="/Users/davide/Desktop/metagenomics/16s/PRJNA818796"

# DADA2 pipeline for denoising and feature table generation
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $INP_DIR/files/paired-end-demux.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 190 \
  --o-table $INP_DIR/table/table.qza \
  --o-representative-sequences $INP_DIR/out_dada2/rep-seqs.qza \
  --o-denoising-stats $INP_DIR/out_dada2/denoising-stats.qza \
  --verbose

# Generate metadata table for representative sequences
qiime metadata tabulate \
  --m-input-file $INP_DIR/out_dada2/rep-seqs.qza \
  --o-visualization $INP_DIR/out_dada2/statistics.qzv

# Generate feature table summary
qiime feature-table summarize \
  --i-table $INP_DIR/table/table.qza \
  --o-visualization $INP_DIR/table/table.qzv

# Generate metadata table for representative sequences
qiime feature-table tabulate-seqs \
  --i-data $INP_DIR/out_dada2/rep-seqs.qza \
  --o-visualization $INP_DIR/out_dada2/rep_seqs.qzv

# Taxonomic classification using the SILVA database
qiime feature-classifier classify-sklearn \
  --i-classifier classificators/silva-138-99-nb-classifier.qza \
  --i-reads $INP_DIR/out_dada2/rep-seqs.qza \
  --o-classification $INP_DIR/classification/taxonomy.qza

# Generate metadata table for taxonomic classification
qiime metadata tabulate \
  --m-input-file $INP_DIR/classification/taxonomy.qza \
  --o-visualization $INP_DIR/classification/taxonomy.qzv

# Generate taxonomic bar plots
mkdir $INP_DIR/barplots
qiime taxa barplot \
  --i-table $INP_DIR/table/table.qza \
  --i-taxonomy $INP_DIR/classification/taxonomy.qza \
  --m-metadata-file $INP_DIR/files/metadata.tsv \
  --o-visualization $INP_DIR/barplots/taxa-bar-plots.qzv

# Move outputs to the final output directory
mv $INP_DIR/files/metadata* $INP_DIR/final_output
mv $INP_DIR/barplots/taxa-bar-plots.qzv $INP_DIR/final_output
mv $INP_DIR/classification/taxonomy.qza $INP_DIR/final_output
mv $INP_DIR/table/table.qza $INP_DIR/final_output
mv $INP_DIR/out_dada2/statistics.qzv $INP_DIR/final_output
mv $INP_DIR/out_dada2/rep_seqs.qzv $INP_DIR/final_output
