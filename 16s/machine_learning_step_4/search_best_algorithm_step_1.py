# Import necessary libraries
import pandas as pd
import h2o
import seaborn as sns
import matplotlib.pyplot as plt

# Set path to data directory
path = "/g100_scratch/userexternal/dpasquan/machine_learning/"

# Load OTU table
otu_table = pd.read_csv(path + "otu_table.tsv", sep="\t")

# Display OTU table
otu_table

# Load taxonomic table
tax_table = pd.read_csv(path + "tax_table.tsv", sep="\t")

# Display taxonomic table
tax_table

# Load metadata table
metadata = pd.read_csv(path + "metadata.tsv", sep="\t")

# Display metadata table
metadata

# Transpose OTU table and add metadata column as first column
otu_table = otu_table.transpose()
otu_table.insert(0, "variable.phenotype", list(metadata["variable.phenotype"]))

# Display transposed OTU table
otu_table

# Get information about the OTU table
otu_table.info()

# Get dimensions of the OTU table
otu_table.shape

# Get summary statistics of the OTU table
otu_table.describe()

# Make a copy of the OTU table before converting to H2O frame
otu_table_copy = otu_table

# Initialize H2O and load H2OAutoML library
h2o.init()
from h2o.automl import H2OAutoML

# Convert OTU table to H2O frame
otu_table = h2o.H2OFrame(otu_table)

# Split the data into training and testing sets
train, test = otu_table.split_frame(ratios=[0.7], seed=1234)

# Set the response variable
y = "variable.phenotype"

# Set the predictor variables
x = otu_table.columns
x.remove(y)

# Initialize H2OAutoML and specify the models to include
aml = H2OAutoML(max_runtime_secs=43000, seed=1, include_algos=["GLM", "DeepLearning", "DRF", "XGBoost", "GBM"], sort_metric="AUC", nfolds=5, verbosity="info")

# Train the H2OAutoML model on the training data
aml.train(x=x, y=y, training_frame=train)

# Get the leaderboard for the trained models
lb = aml.leaderboard

# Display the leaderboard
print("*" * 40 + "\n" + "\n")
print(lb)
print("*" * 40 + "\n" + "\n")

# Write the leaderboard to a file
h2o.export_file(lb, path + "leaderboard.txt", force=True)

# Get the best model from the leaderboard
m = aml.leader

# Make predictions on the test set using the best model
preds = m.predict(test)

# Write the predictions to a file
h2o.export_file(preds, path + "predictions.txt", force=True)

# Get the parameters of the best model
params = m.params
print(params)

# Write the parameters to a file
h2o.export_file(params, path + "params.txt", force=True)

# Write the parameters to a text file
par = open(path + "params_2.txt", "w")
par.write(params)
par.close()

