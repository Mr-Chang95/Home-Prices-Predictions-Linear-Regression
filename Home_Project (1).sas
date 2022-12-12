proc import datafile='/home/u61718019/DS6371 Project/train.csv'
			out= train
			dbms=csv replace;
run;

proc print data = train;
run;


/*Question 1*/
/*Filter our dataset and Log Transform*/
data train2;
set train;
where Neighborhood contains "Edwards" 
	or Neighborhood contains"NAmes" 
	or Neighborhood contains "BrkSide";
run; 

data train2;
set train2;
lPrice = log(SalePrice);
lLivArea = log(GrLivArea);
run;

/*Plot with Outliers*/
proc sgplot data=train2;
 scatter x=GrLivArea y=SalePrice / group=Neighborhood;
run;

/* Build Model1 with outliers*/
proc reg data= train2;
model SalePrice = GrLIvArea / vif clb cli clm; 
run;

/* Build Model2 with outliers*/
proc glm data = train2 plots = all;
where Neighborhood;
class Neighborhood (REF = "BrkSide");
model SalePrice = Neighborhood|GrLivArea/solution clparm;
run; 


/* Identify Cook's D Outliers */
proc glm data=train2 alpha=0.05;
class Neighborhood;
model SalePrice = GrLivArea/ solution clparm;
output out=outliers1 P=Fitted PRESS=PRESS H=HAT
RSTUDENT=SRESID R=RESID DFFITS=DFFITS COOKD=COOKD;
run ;
proc print data=outliers1;

data outliers1;
set outliers1;
where abs(SRESID) > 3 or COOKD > 5;
run;
proc print data=outliers1;

/* Find outlier for SalePrice*/
ods output sgplot=boxplot_data;
proc sgplot data=train2;
    vbox SalePrice;
run;

proc print data=boxplot_data;

/* Find outlier for GrLivArea*/
ods output sgplot=boxplot_data;
proc sgplot data=train2;
    vbox GrLivArea;
run;

proc print data=boxplot_data;

/* Remove Outliers */
data train3;
set train2;
keep Id Neighborhood GrLivArea SalePrice;
where Id ~= 524 and Id ~= 643 and Id~= 725 and Id~= 1299 and Id~= 1424;  
run;

/*Plot without Outliers*/
proc sgplot data=train3;
 scatter x=GrLivArea y=SalePrice / group=Neighborhood;
run;

/* Run Model Without Outliers */
proc glm data=train3 alpha=0.05 plots = All;
class Neighborhood;
model SalePrice = GrLivArea / solution;
run;

/* Plot the scatter plot without outliers */
title ‘Scatter plot without outliers: SalePrice v. GrLIvArea’;
PROC sgplot DATA=train3;
scatter x=GrLIvArea y=SalePrice;
run;

proc glm data= train3 plots = all;
class neighborhood (REF = "BrkSide");
model SalePrice = GrLIvArea|Neighborhood / solution clparm cli;
run;

/* Comparing Competing Models*/
proc glmselect data = train3 plots = all;
where Neighborhood;
class Neighborhood (REF = "BrkSide");
model SalePrice = Neighborhood|GrLivArea @2/ selection = Stepwise(stop = cv) 
cvmethod = random(5) stats = adjrsq;;
run;






/* QUESTION 2 */
proc import datafile='/home/u61718019/DS6371 Project/train.csv'
			out= train
			dbms=csv replace;
run;

proc print data = train;
run;


/* Remove Outliers */
data train;
set train;
where Id ~= 524 AND Id ~= 643 AND Id ~= 725 AND Id ~= 1299 AND Id ~= 1424;
run;

/* Create new dataset with interested variables*/
data train4;
set train;
keep MSSubClass MSZoning LotArea LotShape LandContour LotConfig	LandSlope	Neighborhood	
Condition1	Condition2	BldgType	HouseStyle	OverallQual	OverallCond	YearBuilt	YearRemodAdd	
RoofStyle	RoofMatl	Exterior1st	Exterior2nd	MasVnrType	ExterQual	ExterCond	Foundation	BsmtQual	
BsmtCond	BsmtExposure	BsmtFinType1	BsmtFinSF1	BsmtFinType2	BsmtFinSF2	BsmtUnfSF	TotalBsmtSF	
Heating	HeatingQC	CentralAir	Electrical	LowQualFinSF	GrLivArea	BsmtFullBath	BsmtHalfBath	FullBath	
HalfBath	BedroomAbvGr	KitchenAbvGr	KitchenQual	TotRmsAbvGrd	Fireplaces GarageType	
GarageFinish	GarageCars	GarageArea	GarageQual	GarageCond	PavedDrive	WoodDeckSF	OpenPorchSF	EnclosedPorch 
ScreenPorch PoolArea Fence	MiscFeature	MiscVal	MoSold	YrSold	SaleType SaleCondition	SalePrice;
run;


/* Log Sale Price to account for normality/linearity*/
data train4;
set train4;
logSalePrice = log(SalePrice);
run;


/* Check for Linear Relationships for Numerical Variables */
proc corr data = train; *check correlations first;
run;

PROC sgscatter DATA=train4;
matrix logSalePrice MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF;
run;

PROC sgscatter DATA=train4;
matrix logSalePrice LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath
BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea;
run;

PROC sgscatter DATA=train4;
matrix logSalePrice WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal MoSold YrSold;
run;

/* Forward Selection Model*/
/*Agjusted R-Squared: .885 after 14 steps, CV Press: 20.8470, Kaggle*/ 
proc glmselect data = train4;
class Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle RoofStyle 
BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType GarageFinish SaleType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF GrLivArea 
FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch 
ScreenPorch PoolArea YrSold Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle 
RoofStyle BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType 
GarageFinish SaleType 
/selection = Forward(stop = cv) cvmethod = random(5) CVDETAILS stats = adjrsq;
store ForwardTrainModel;
run;

/*Run Linear Regression Model for Forward Model: Numeric Only*/
proc glm data = train4 plots=all;
class Neighborhood MSZoning BldgType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF GrLivArea 
GarageArea Fireplaces /solution;
run;

/* Backward Selection Model*/
/*Agjusted R-Squared: .8932 after 3 steps, CV Press: 20.6768, Kaggle: 0.14206*/ 
proc glmselect data = train4;
class Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle RoofStyle 
BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType GarageFinish SaleType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF GrLivArea 
FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch 
ScreenPorch PoolArea YrSold Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle 
RoofStyle BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType 
GarageFinish SaleType 
/ selection = Backward(stop = cv) cvmethod = random(5) CVDETAILS stats = adjrsq;
store BackwardTrainModel;
run;

/*Run Linear Regression Model for Backward Model: Numeric Only*/
proc glm data = train4 plots=all;
class Neighborhood MSZoning BldgType LotShape CentralAir Electrical LotConfig Condition1 BsmtFinType1 
HeatingQC KitchenQual GarageType GarageFinish SaleType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF GrLivArea
FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF OpenPorchSF 
EnclosedPorch ScreenPorch PoolArea YrSold/solution;
run;

/* Stepwise Selection Model*/
/*Adjusted R-Squared: .8907 after 13 steps, CV Press: 20.8527, Kaggle: 0.14272*/
proc glmselect data = train4;
class Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle RoofStyle 
BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType GarageFinish SaleType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF GrLivArea 
FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch 
ScreenPorch PoolArea YrSold Neighborhood MSZoning LotShape LotConfig Condition1 Condition2 BldgType HouseStyle 
RoofStyle BsmtFinType1 HeatingQc CentralAir Electrical KitchenQual GarageType 
GarageFinish SaleType 
/ selection = Stepwise(stop = cv) cvmethod = random(5) CVDETAILS stats = adjrsq;
store StepwiseTrainModel;
run;

/*Run Linear Regression Model for Stepwise Model: Numeric Only*/
proc glm data = train4 plots=all;
class Neighborhood MSZoning BldgType;
model logSalePrice = OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF 
GrLivArea Fireplaces GarageArea/solution;
run;

/* Custom Selection Model*/
proc glmselect data = train4;
class Neighborhood MSZoning LotShape BldgType HeatingQC CentralAir  KitchenQual GarageType;
model logSalePrice = OverallQual OverallCond Yearbuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF 
GrLivArea FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF 
OpenPorchSF EnclosedPorch ScreenPorch PoolArea YrSold Neighborhood MSZoning LotShape
BldgType HeatingQC CentralAir KitchenQual GarageType/ selection = Backward(stop = cv) cvmethod = random(5) CVDETAILS stats = adjrsq;
store BackwardTrainModel;
run;

/*Run Linear Regression Model for Custom Model: Numeric Only*/
proc glm data = train4 plots=all;
class Neighborhood MSZoning LotShape  BldgType  HeatingQC CentralAir KitchenQual LotConfig;
model logSalePrice = OverallQual OverallCond Yearbuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF 
GrLivArea FullBath HalfBath BedroomAbvGr TotRmsAbvGrd Fireplaces GarageCars GarageArea WoodDeckSF 
OpenPorchSF EnclosedPorch ScreenPorch PoolArea YrSold Neighborhood MSZoning LotShape LotConfig
BldgType HeatingQC CentralAir  KitchenQual/solution;
run;