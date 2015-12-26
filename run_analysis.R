## Data URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
library(plyr)

if(!file.exists("./Data")){dir.create("./Data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Data/Dataset.zip")

unzip(zipfile="./Data/Dataset.zip",exdir="./Data")

##Merges the training and the test sets to create one data set.
# read training data files into R
xtrain <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", header=F)
ytrain <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", header=F)
strain <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt", header=F)

# read test data files into R 
xtest <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", header=F)
ytest <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", header=F)
stest <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", header=F)

# merge data between the training and the test files
xmerge <- rbind(xtrain, xtest)
ymerge <- rbind(ytrain, ytest)
smerge <- rbind(strain, stest)

# create a combined data set with subject, activity, and observations together
fullDataSet <- cbind(smerge, ymerge, xmerge)
