# Kaggle Project(Home Sale Price Prediction)
## By Daniel Chang & Garrett Drake
![DS 6371 - Kaggle Project(Home Sale Price Prediction)](https://user-images.githubusercontent.com/92649864/206943028-d76ff8e4-3774-4e0c-9e77-ea5e87522a9a.jpg)

## Project Description
Ask a home buyer to describe their dream house, and they probably won't begin with the height of the basement ceiling or the proximity to an east-west railroad. But this Kaggle competition's dataset proves that much more influences price negotiations than the number of bedrooms or the presence of a white-picket fence!

With 79 explanatory variables describing (almost) every aspect of residential homes in Ames, Iowa, this competition challenges you to predict the final price of each home.

The entire process will be done in R and SAS. SAS is used for the first analysis question and variable selection.

## Goals
There are two goals for this project:
1. Century 21 Ames only sells houses in the NAmes, Edwards and BrkSide neighborhoods and would like to simply get an estimate of how the SalePrice of the house is related to the square footage of the living area of the house (GrLIvArea) and if the SalesPrice (and its relationship to square footage) depends on which neighborhood the house is located in. Build and fit a model that will answer this question, keeping in mind that realtors prefer to talk about living area in increments of 100 sq. ft. Provide your client with the estimate (or estimates if it varies by neighborhood) as well as confidence intervals for any estimate(s

For this analysis, we also want to create to make an RShiny app that will display at least display a scatterplot of price of the home v. square footage (GrLivArea) and allow for the plot to be displayed for at least the NAmes, Edwards and BrkSide neighborhoods separately.

2. Build the most predictive model for sales prices of homes in all of Ames Iowa.  This includes all neighborhoods. Your group is limited to only the techniques we have learned in 6371 (no random forests or other methods we have not yet covered).  Specifically, you should produce 4 models: one from forward selection, one from backwards elimination, one from stepwise selection, and one that you build custom.  The custom model could be one of the three preceding models or one that you build by adding or subtracting variables at your will.  Generate an adjusted R-Squared, CV Press and Kaggle Score for each of these models and clearly describe which model you feel is the best in terms of being able to predict future sale prices of homes in Ames, Iowa. We will use all 4 our models to predict the Saleprice on a test dataset(test.csv).

In the end, we want to write a 7 page report discussing our findings along with an appendix that includes all of our codes.

## Variables Selection Methods
- Forward
- Backward
- Stepwise

## Variables Selection Methods
- Forward Model Kaggle Score: 0.14255
- Backward Model Kaggle Score: 0.14206
- Stepwise Model Kaggle Score: 0.14272
- Custom Model Kaggle Score: 0.14137

## RShiny app
Please click to access [RShiny App](https://x0s00e-danny-chang.shinyapps.io/Home_Price_Shiny/?_ga=2.124718090.1268003529.1670802137-241624307.1669589829)

## Licensing and Acknowledgements
This was done as a project for Data Science 6371 at Southern Methodist University,
