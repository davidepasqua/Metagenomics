# Import libraries
library(phyloseq)     # for working with microbiome data
library(ggplot2)      # for creating visualizations
library(qiime2R)      # for importing data from QIIME2 format
library(plyr)         # for data manipulation
library(dplyr)        # for data manipulation
library(tidyr)        # for data manipulation
library(vegan)        # for ecological analysis
library(sva)          # for batch effect correction
library(caret)        # for statistical modeling
library(ggpubr)       # for publication-quality plots
theme_set(theme_bw())  # Set plot theme to black and white


# Define function to filter taxa based on a percentage threshold
take_taxa = function(phy, badTaxa) {
  allTaxa = taxa_names(phy)
  myTaxa <- allTaxa[(allTaxa %in% badTaxa)]
  return(prune_taxa(myTaxa, phy))
}

filter_taxa_perc = function(phy , percentuale) {
  
  # Remove taxa with a percentage below the threshold
  
  P = percentuale
  
  taxa_somme <- taxa_sums(phy)
  
  num_tot_reads <- sum(taxa_sums(phy))
  
  percentuali_taxa <- (taxa_somme / num_tot_reads) * 100
  
  # Select ASVs above the percentage threshold
  
  T <- percentuali_taxa[percentuali_taxa > P]
  
  T <- names(T)
  
  final <- take_taxa(phy, T)
  
  return(final)
}


####### Define variables
print(list.files("/Users/davide/Desktop/tirocinio/dati/processati"))
positivi_controlli ="variable.phenotype"

# Set working directory
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA636824/final_output")

# Define file names
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

# Convert QIIME2 artifacts to phyloseq object
phy1 <- qza_to_phyloseq(features = Tab, taxonomy = Tax, metadata = Map, tmp = "Temp")

colnames(sample_data(phy1))  # Print column names


# Repeat the same procedure for the remaining datasets
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA700830/output_finale")
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"
phy2 <- qza_to_phyloseq(features = Tab, taxonomy = Tax, metadata = Map, tmp = "Temp")

setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA703303/output_finale")
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"
phy3 <- qza_to_phyloseq(features = Tab, taxonomy = Tax, metadata = Map, tmp = "Temp")

# Merge in one object 
phy <- merge_phyloseq(phy1,phy2)
phy <- merge_phyloseq(phy,phy3)

#Subset the samples with phenotype variable not equal to "other"
phy <- subset_samples(phy, variable.phenotype != "other")

#CHECK
#Subset the samples from stool source
phy_stool = subset_samples(phy, source == "Stool")

#Print the table of source and phenotype variables of the samples
table(sample_data(phy_stool)$source,sample_data(phy_stool)$variable.phenotype)

#Print the table of BioProject variable of the samples
table(sample_data(phy_stool)$BioProject)

#Subset the taxa to only bacteria
phy_stool <- subset_taxa(phy_stool,Kingdom=="d__Bacteria")

#Subset the samples with BioProject not equal to "PRJNA684070" and "PRJNA700830"
phy_stool = subset_samples(phy_stool, BioProject != "PRJNA684070")
phy_stool = subset_samples(phy_stool, BioProject != "PRJNA700830")

#Glom the taxa at the genus level and normalize the data
phy_stool <- tax_glom(phy_stool, "Genus", NArm=TRUE)

#Filter the taxa present in less than 0.005% of the samples
phy_stool= filter_taxa_perc(phy_stool, 0.005)

#Prune the samples that have a sum of taxa less than 100
phy_stool <- prune_samples(sample_sums(phy_stool) > 100 ,phy_stool)

#Print the table of BioProject variable of the samples
table(sample_data(phy_stool)$BioProject)

#Create a dataframe of the OTU table
data_otu_filt = data.frame(otu_table(phy_stool))

#Print the table of samples with sum of taxa greater than 100
table(sample_sums(phy_stool)>100)

#Print the dimension of the OTU table dataframe
dim(data_otu_filt)

########################################## PCoA PRE-Combat #############################

#Set the distance to Bray-Curtis
DistancePhyl="bray"

#Set the Variable1 to "positivi_controlli" and Variable2 to "BioProject"
Variable1= positivi_controlli
Variable2= "BioProject"

#Set the Title to "PCoA :: Bray-Curtis pre-combat"
Title="PCoA :: Bray-Curtis pre-combat"

#Calculate the distance matrix of the samples
Distance <- distance(phy_stool,method =DistancePhyl)

#Calculate the principal coordinate analysis of the distance matrix
Ord <- ordinate(phy_stool,method="PCoA",distance=DistancePhyl)

#Create the plot of the principal coordinate analysis
Graph_BC <- plot_ordination(phy_stool,Ord,shape=Variable1,color=Variable2)+ggtitle(Title)+geom_point(size=3,alpha=0.60)

#Print the plot
Graph_BC

#################################### Pcoa post-combat #####################################

data_otu_filt_stool = data.frame(otu_table(phy_stool))
#logaritmization

T <- data_otu_filt_stool+ 1

K <- log(T,10)

combat_data <- ComBat(dat=as.matrix(K), batch=sample_data(phy_stool)$BioProject, mod=NULL, par.prior=FALSE, mean.only = TRUE)

preproc <- preProcess(combat_data, method=c("range"), rangeBounds=c(0,1))
norm_data <- predict(preproc, combat_data) #normalized combat data - bias removed

phy_stool_normalized <- phy_stool
otu_table(phy_stool_normalized) <- otu_table(norm_data, taxa_are_rows=TRUE)

DistancePhy="bray"
Variable1= positivi_controlli
Variable2= "BioProject"
Title="PCoA :: Bray-Curtis post-combat"

Distance <- distance(phy_stool_normalized,method = DistancePhyl) #sample distance matrix
Ord <- ordinate(phy_stool_normalized,method="PCoA",distance=DistancePhyl) #Principal Coordinate Analysis

Graph_BC_2 <-  plot_ordination(phy_stool_normalized,Ord,shape=Variable1,color=Variable2)+ggtitle(Title)+geom_point(size=3,alpha=0.60)#+scale_shape_manual(values=c(15, 16, 17, 18, 3, 4))
Graph_BC_2

############

PLOT_2 <- ggarrange(Graph_BC,Graph_BC_2,nrow=1,ncol=2,common.legend = TRUE,legend="right",labels="AUTO")

# save a plot in tiff format
Save.graph_ligth<- function(Graph, OutDir, Name, Name_prefix=""){
  out_file_name <- paste(Name_prefix, Name, sep="_")
  out_path_name <- paste(OutDir, out_file_name, sep="//")
  print(out_path_name)
  tiff(paste(out_path_name, ".tiff"), height=30, width=25, units="cm", res=150)
  print(Graph)
  dev.off()
  return()
}

path_outdir = "/Users/davide/Desktop/tirocinio/tesi/immagini"

Save.graph_ligth(PLOT_2, path_outdir, "PCoA stool")

# normalization of the dataset and  save a frame for machine learning

phy_stool <- transform_sample_counts(phy_stool, function(ASV) ASV/sum(ASV) *100) 

setwd("/Users/davide/Desktop/tirocinio/dati/machine_learning/stool")

otu = as.data.frame(otu_table(phy_stool))
tax = as.data.frame(tax_table(phy_stool))
meta = as.data.frame(sample_data(phy_stool))

write.table(otu, "otu_table.tsv", sep="\t", quote=FALSE)
write.table(tax, "tax_table.tsv", sep="\t", quote=FALSE)
write.table(meta, "metadata.tsv", sep="\t", quote=FALSE)

