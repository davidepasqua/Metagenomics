Metagenomics Analysis Pipeline

This repository contains a pipeline for 16s metagenomics analysis of fecal and nasopharyngeal samples using QIIME2, R, and Python. The pipeline is organized into four subfolders, each containing the scripts and data necessary for a specific step of the analysis.

Installation

To use this pipeline, you will need to have QIIME2, R, and Python installed on your computer. For installation instructions, please refer to the official documentation of each software.

Usage

To use the pipeline, follow the steps outlined in the README files located in each subfolder. The pipeline consists of the following steps:

Step 1: Quality control and trimming of raw reads using QIIME2 ,Taxonomic classification of reads and generation of feature tables. 
Step 2: This step creates a metadata file with common columns for downstream analyses.
Step 3: Statistical analysis of feature tables and generation of visualizations using R. This step combines all bioprojects into a single object and performs PCoA analysis using the "combat" algorithm.
Step 4: Artificial Intelligence (AI) analysis using Python. 

Contributions

Contributions to this pipeline are welcome! If you have suggestions for improvements or would like to report a bug, please create an issue on this repository.
