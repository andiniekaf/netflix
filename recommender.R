## SETTING UP A WORKING DIRECTORY ##
setwd("insert your working directory here")

## LOADING THE NECESSARY PACKAGES
library(dplyr)
library(zoo)
library(recosystem)

## DATA PREPARATION -- TRAINING DATA
nf <- read.table("C:/Users/Andini Eka F/Documents/R/Business Analytics EDX Course/combined_data_1.txt",sep=",",header=FALSE,fill=TRUE)
head(nf)

# this is how the data looks like - In this preview, "1:" is the movie ID, and the rows that come after ("1488844", "822109", etc) are the user ID. 
# generally, the indicator of rows which contain the movie ID lies in the presence of ":". 
# V2 is the rating data
# V3 is the date on which the rating was given for a certain movie ID

##       V1 V2         V3
## 1      1: NA           
## 2 1488844  3 2005-09-06
## 3  822109  5 2005-05-13
## 4  885013  4 2005-10-19
## 5   30878  4 2005-12-26
## 6  823519  3 2004-05-03

# in order to be interpretable, the above format has to be transformed into the data frame which contains these rows: Movie ID, User ID, Rating, and Date

nf$V4 <- nf$V1 #creating 2 separate columns, V1 will be dedicated for Movie ID, while V4 will be dedicated for User ID
nf$V1[!grepl(":",nf$V1)] <- NA #if the V1 column does NOT contain ":", it will be changed into NA
nf$V1 <- gsub(":","",nf$V1) #replacing the ":" with "" -- this function is basically aimed at removing the ":" character in the movie ID
nf$V1 <- na.locf(nf$V1) #Replaces each missing value (the NAs) with the most recent present value prior to it (Last Observation Carried Forward) -- that is, the most recent "Movie ID" prior to it
nf <- filter(nf,!grepl(":",nf$V4)) #removing the rows containing ":" in the V4 column from the observation
nf <- nf[,c("V1","V4","V2","V3")] #restructuring the order of the columns
names(nf) <- c("movie_id", "user_id","rating","date")

# this is how the cleaned data looks like

##  movie_id user_id rating       date
## 1        1 1488844      3 2005-09-06
## 2        1  822109      5 2005-05-13
## 3        1  885013      4 2005-10-19
## 4        1   30878      4 2005-12-26
## 5        1  823519      3 2004-05-03
## 6        1  893988      3 2005-11-17

str(nf) #checking the data type of each column
nf$movie_id <- as.numeric(nf$movie_id)
nf$user_id <- as.numeric(nf$user_id)
nf$rating <- as.numeric(nf$rating)
summary(nf)

## DATA PREPARATION - TESTING DATA
test <- read.table("C:/Users/Andini Eka F/Documents/R/Business Analytics EDX Course/probe.txt",sep=",",header=FALSE,fill=TRUE)
test$V2 <- test$V1
test$V1[!grepl(":",test$V1)] <- NA
test$V1 <- gsub(":","",test$V1)
head(test)
##    V1      V2
## 1    1      1:
## 2 <NA>   30878
## 3 <NA> 2647871
## 4 <NA> 1283744
## 5 <NA> 2488120
## 6 <NA>  317050

test$V1 <- na.locf(test$V1)
test <- filter(test,!grepl(":",test$V2))
names(test) <- c("movie_id","user_id")
test$rating <- NA


## TUNING THE MATRIX FACTORIZATION ALGORITHM TO FIND OUT THE BEST 
set.seed(145)
r=Reco()
opts <- r$tune(data_memory(nf$user_id,nf$movie_id, rating=nf$rating, index1=TRUE), opts=list(dim=c(5,10), lrate=c(0.05,0.1, 0.15),  niter=5, nfold=5, verbose=FALSE)) 
# NOTE: The  tuning is done over a set of parameter values: two settings of latent vector dimensionality, dim=5, or dim=10, three different values of the learning rate (lrate) and for 5 iterations, involving 5 fold cross validation.
# Due to limited processing power, the tuning is only iterated 5 times in my case. However, it'd be preferable to have it iterated many times if you are equipped with sufficient processing power

opts$min #to look at the best option attained during the tuning process
r$train(data_memory(nf_3$user_id, nf_3$movie_id, rating=nf_3$rating, index1=TRUE), opts=c(opts$min, nthread=1, niter=50) #use the best option to train the the training data model
res <- r$output(out_memory(), out_memory()) #storing the latent vectors
pred <- r$predict(data_memory(test$user_id,test$movie_id, rating=NULL, index1=TRUE),out_memory()) #predict the ratings in the testing data
test$pred_rating <- pred
test$pred_rating <- round(test$pred_rating,0)
test <- left_join(test, nf, by= c("movie_id", "user_id")) #retrieving the actual rating of the test data for further comparison with the predicted rating
str(test)
test$movie_id <- as.numeric(test$movie_id)
test$user_id <- as.numeric(test$movie_id)
test$compare <- ifelse(test$rating == test$pred_rating,1,0)
mean(test$compare)
## the mean is 0.5339242 -- 53.4% of the predicted ratings are accurate

# calculating the RMSE
sqrt(mean((join$pred_rating-join$rating)^2))
# the RMSE is 0.8200581. As a benchmark, based on https://www.netflixprize.com/faq.html, Cinematch's algorithm on the same data scored a 0.9474 of RMSE










