library(phyloseq)
library(ggplot2)
library(qiime2R)
library(plyr)
library(dplyr)
library(tidyr)
library(vegan)
library(sva)
library(caret)
theme_set(theme_bw())

# filtra i taxa di interesse in base a una soglia percentuale
# prende i taxa di interesse
take_taxa = function(phy, badTaxa){
  allTaxa = taxa_names(phy)
  myTaxa <- allTaxa[(allTaxa %in% badTaxa)]
  return(prune_taxa(myTaxa, phy))
}

filter_taxa_perc = function(phy , percentuale ){
  
  # rimuove quelle con una determinata percentuale
  
  P = percentuale
  
  taxa_somme <- taxa_sums(phy)
  
  num_tot_reads <- sum(taxa_sums( phy))
  
  percentuali_taxa <- ( taxa_somme / num_tot_reads ) * 100
  
  # prende soltanto le ASV con una percentuale superiore
  
  T <- percentuali_taxa[ percentuali_taxa > P ]
  
  T <- names( T )
  
  final <- take_taxa( phy , T )
  
  return(final)
  
}



####### variabile 


positivi_controlli ="variable.phenotype"

# setta la directory di lavoro
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA636824/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"


phy1 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

colnames(sample_data(phy1))
##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA700830/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy2 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA703303/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy3 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA726205/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy4 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA732427/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy5 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA747262/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy6 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA751478/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy7 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA777915/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy8 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA751478/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy9 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

############################################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA777915/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy10 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

###########################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA787810/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy11 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

###########################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA817437/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy12 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

###########################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA818796/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy13 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")



###########################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA739539/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy14 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")
######
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA767939/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy15 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")



######
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA678695/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy17 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")



######
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA684070/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy18 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

phy18

##################

setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA902495/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy19 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

##################
setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJDB14457/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy20 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")


setwd("/Users/davide/Desktop/tirocinio/dati/processati/PRJNA744351/output_finale")

# inserire path  o nomedei dati
Tab <- "table.qza"
Map <- "metadata.tsv"
Tax <- "taxonomy.qza"

phy21 <- qza_to_phyloseq( features = Tab , taxonomy = Tax , metadata = Map, tmp="Temp")

# unire diversi oggetti phyloseq
phy <- merge_phyloseq(phy1,phy2)
phy <- merge_phyloseq(phy,phy3)
phy <- merge_phyloseq(phy,phy4)
phy <- merge_phyloseq(phy,phy5)
phy <- merge_phyloseq(phy,phy6)
phy <- merge_phyloseq(phy,phy7)
phy <- merge_phyloseq(phy,phy8)
phy <- merge_phyloseq(phy,phy9)
phy <- merge_phyloseq(phy,phy10)
phy <- merge_phyloseq(phy,phy11)
phy <- merge_phyloseq(phy,phy12)
phy <- merge_phyloseq(phy,phy13)
phy <- merge_phyloseq(phy,phy14)
phy <- merge_phyloseq(phy,phy15)
phy <- merge_phyloseq(phy,phy17)
phy <- merge_phyloseq(phy,phy18)
phy <- merge_phyloseq(phy,phy19)
phy <- merge_phyloseq(phy,phy20)
phy <- merge_phyloseq(phy,phy21)

phy <- subset_samples(phy, variable.phenotype != "altro")
#CHECK
phy_naso = subset_samples(phy, source == "Nasopharyngeal")
table(sample_data(phy_naso)$source,sample_data(phy_naso)$variable.phenotype) 
table(sample_data(phy_naso)$BioProject)

# Rimuovi i campioni strani
#phy_naso <- subset_samples(phy_naso, !is.nan(sample_data(phy_naso)$BioProject))

# ridurre le analisi ai soli batteri
phy_naso <- subset_taxa(phy_naso,Kingdom=="d__Bacteria")
otu_table(phy_naso)

# sommare le read in funzione di un livello tassonomico (i generi)
phy_naso <- tax_glom(phy_naso, "Genus", NArm=TRUE)
##### FILTRI
phy_naso = filter_taxa_perc(phy_naso, 0.005) 
phy_naso <- prune_samples(sample_sums(phy_naso) > 100 ,phy_naso) #removing the samples that have 0 taxa
otu_table(phy_naso)

table(sample_data(phy_naso)$BioProject)
data_otu_filt = data.frame(otu_table(phy_naso))
table(sample_data(phy_naso)$BioProject)
dim(data_otu_filt)


## NORMALIZZAZIONE  
phy_naso_1 <- phy_naso




########################################## PCoA PRE-Combat #############################

DistancePhyl="bray"
Variable1= positivi_controlli
Variable2= "BioProject"
Title="PCoA :: Bray-Curtis pre-combat"

Distance <- distance(phy_naso,method =DistancePhyl) #matrice distanze campioni 
Ord <- ordinate(phy_naso,method="PCoA",distance=DistancePhyl) #analisi coordinate principale 

Graph_BC <-  plot_ordination(phy_naso,Ord,shape=Variable1,color=Variable2)+ggtitle(Title)+geom_point(size=3,alpha=0.60)#+scale_shape_manual(values=c(15, 16, 17, 18, 3, 4))
Graph_BC

#################################### Pcoa post-combat #####################################

# Rimozione dei campioni senza variazione
phy_naso <- prune_samples(sample_sums(otu_table(phy_naso)) > 0, phy_naso)
#phy_naso <- subset_samples(phy_naso, !is.na(sample_data(phy_naso)$BioProject))
samples_to_remove <- c("SRS8802478", "SRS9667790", "SRS15820341", "SRS15820480")
phy_naso <- prune_samples(!sample_names(phy_naso) %in% samples_to_remove, phy_naso)


# Applicazione del filtro OTU e conversione in data frame
data_otu_filt_naso <- data.frame(otu_table(phy_naso))
T <- data_otu_filt_naso + 1
K <- log(T, 10)

# Correzione batch effect con ComBat
combat_data <- ComBat(dat = as.matrix(K), batch = sample_data(phy_naso)$BioProject, mod = NULL, par.prior = FALSE, mean.only = TRUE)
preproc <- preProcess(combat_data, method = c("range"), rangeBounds = c(0,1))
norm_data <- predict(preproc, combat_data)
norm_data[is.nan(norm_data)] <- 0

# Normalizzazione dei dati e creazione della matrice delle distanze
phy_naso_normalized <- phy_naso
otu_table(phy_naso_normalized) <- otu_table(norm_data, taxa_are_rows = TRUE)


# Calcolo della distanza
DistancePhy <- "bray"
Distance <- distance(phy_naso_normalized, method = DistancePhy)

# Analisi delle coordinate principali e creazione del grafico
Variable1 <- positivi_controlli
Variable2 <- "BioProject"
Title <- "PCoA :: Bray-Curtis post-combat"
Ord <- ordinate(phy_naso_normalized, method = "PCoA", distance = DistancePhy)
Graph_BC_2 <- plot_ordination(phy_naso_normalized, Ord, shape = Variable1, color = Variable2) + 
  ggtitle(Title) + geom_point(size = 3, alpha = 0.60)
Graph_BC_2

PLOT_2 <- ggarrange(Graph_BC,Graph_BC_2,nrow=1,ncol=2,common.legend = TRUE,legend="right",labels="AUTO")
#############################
# Salva grafico in formato TIFF

Save.graph_ligth<- function( Graph , OutDir , Name , Name_prefix="" ){
  out_file_name <- paste( Name_prefix,Name,sep="_")
  out_path_name <- paste( OutDir, out_file_name ,  sep="//" )
  print(out_path_name)
  tiff( paste(out_path_name, ".jpeg") , height=30, width=25, units="cm", res=150)
  print(Graph)
  dev.off()
  return()
}

path_outdir ="/Users/davide/Desktop/tirocinio/tesi/immagini"

Save.graph_ligth(PLOT_2,path_outdir, "PCoA nasoPharyngeal")
phy_naso <- transform_sample_counts(phy_naso, function(ASV) ASV/sum(ASV) *100) 

setwd("/Users/davide/Desktop/tirocinio/dati/machine_learning/naso")


otu = as.data.frame(otu_table(phy_naso))

tax = as.data.frame(tax_table(phy_naso))

meta = as.data.frame(sample_data(phy_naso))

write.table(otu, "otu_table.tsv", sep="\t", quote=FALSE)
write.table(tax, "tax_table.tsv", sep="\t", quote=FALSE)
write.table(meta, "metadata.tsv", sep="\t", quote=FALSE)



