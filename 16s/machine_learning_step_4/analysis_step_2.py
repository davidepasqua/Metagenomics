#!/usr/bin/env python
# coding: utf-8

# Import necessary libraries
import pandas as pd 
import h2o
import seaborn as sns 
import matplotlib.pyplot as plt

# Import and prepare data
otu_table = pd.read_csv("otu_table.tsv", sep="\t")
tax_table = pd.read_csv("tax_table.tsv", sep="\t")
metadata = pd.read_csv("metadata.tsv", sep="\t")

# Transpose the OTU table
otu_table = otu_table.transpose() 

# Add a new column from metadata to the OTU table
otu_table.insert(0, "variable.phenotype", list(metadata["variable.phenotype"]))

# Make a copy of the OTU table before converting to h2o frame
otu_table_copy = otu_table 

# Exploratory analysis
# Print info on the OTU table
otu_table_copy.info()
# Print the shape of the OTU table
otu_table_copy.shape
# Print summary statistics of the OTU table
otu_table_copy.describe()

# Extract the genera information from the tax table and calculate their mean abundance
otu_table_1 = otu_table_copy.drop("variable.phenotype", axis=1)
generi = pd.DataFrame({"Genus": list(tax_table["Genus"]), "Mean": list(otu_table_1.mean())})

# Sort the genera by their mean abundance
generi_sorted = generi.sort_values("Mean", ascending=False)

# Plot the top 30 genera by mean abundance
df_plot = generi_sorted.iloc[0:30,:]
p=sns.barplot(data=df_plot, x="Genus", y="Mean", palette="Set2", errorbar="sd")
p.set_xticklabels(p.get_xticklabels(), rotation=90)
plt.title("Top 30 Genus")
plt.show()

# Plot the bottom 30 genera by mean abundance
df_plot = generi_sorted.iloc[195:,:]
p=sns.barplot(data=df_plot, x="Genus", y="Mean", palette="Set2", errorbar="sd")
p.set_xticklabels(p.get_xticklabels(), rotation=90)
plt.title("Bottom 30 Genus")
plt.show()

# Calculate the correlation matrix for the OTU table
correlazione = otu_table_1.corr()

# Plot a heatmap of the correlation matrix
# sns.heatmap(correlazione, cmap='coolwarm', annot=True)

# Initialize h2o and convert the OTU table to an h2o frame
h2o.init()
otu_table = h2o.H2OFrame(otu_table)

# Split the data into training and testing sets
train, test = otu_table.split_frame(ratios=[0.7], seed=19)

# Set the response variable and the predictor variables
y = "variable.phenotype"
x = otu_table.columns

# Train a gradient boosting machine (GBM) model with default hyperparameters
from h2o.estimators.gbm import H2OGradientBoostingEstimator
m = H2OGradientBoostingEstimator(ntrees=10, max_depth=5)
m.train(x=x, y=y, training_frame=train)

# Make predictions on the test set using the trained model
preds = m.predict(test)

# Print the predictions
preds

# Print the model parameters
m.params

# Calculate and print the model performance on the test set
perf = m.model_performance(test_data=test)
perf

# Perform a grid search to find the best hyperparameters for the GBM model
# Import the necessary libraries
from h2o.grid.grid_search import H2OGridSearch

# Define the hyperparameters to search over
hyper_params = {'ntrees': [50, 100, 200, 300],
                'learn_rate': [i * 0.01 for i in range(1, 11)],
                'max_depth': list(range(2, 11)),
                'sample_rate': [i * 0.1 for i in range(5, 11)],
                'col_sample_rate': [i * 0.1 for i in range(1, 11)]}

# Define the search criteria for the grid search
search_criteria = {'strategy': 'RandomDiscrete', 'max_models': 80}

# Instantiate a GBM model
gbm = H2OGradientBoostingEstimator()

# Create a grid search object with the model, hyperparameters, and search criteria
grid = H2OGridSearch(model=gbm, hyper_params=hyper_params, search_criteria=search_criteria)

# Train the grid search with the specified dataset, target variable, and number of folds
grid.train(x=x, y=y, training_frame=train, nfolds = 5, seed = 42)

# Get the best model according to AUC metric
best_model = grid.get_grid(sort_by='AUC', decreasing=True)[0]

# Evaluate the performance of the best model on the test dataset
best_model_performance = best_model.model_performance(test_data=test)
print(best_model_performance)

# Use the best model to make predictions on the test dataset
predictions = best_model.predict(test)
print(predictions)

# Print out the parameters of the best model
print(best_model.params)

