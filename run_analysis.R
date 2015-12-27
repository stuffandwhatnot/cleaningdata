## Data URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
library(dplyr)

if(!file.exists("./Data")){dir.create("./Data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Data/Dataset.zip")

unzip(zipfile="./Data/Dataset.zip",exdir="./Data")

##Merges the training and the test sets to create one data set.
# read training data files into R
xtrain <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
ytrain <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", header=FALSE)
strain <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)

# read test data files into R 
xtest <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", header=FALSE)
ytest <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", header=FALSE)
stest <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# merge data between the training and the test files
xmerge <- rbind(xtrain, xtest)
ymerge <- rbind(ytrain, ytest)
smerge <- rbind(strain, stest)

# create a combined data set with subject, activity, and observations together to create one data set
fullDataSet <- cbind(smerge, ymerge, xmerge)

# name the columns using the features names provided in the text file
features <- read.table("./Data/UCI HAR Dataset/features.txt", header=FALSE, stringsAsFactors=FALSE)
names(fullDataSet) <- c("subject", "activity", make.unique(features$V2))

# select only the subject, activity, mean, and std columns 
data <- tbl_df(fullDataSet)
mean_std_data <- select(data, subject, activity, contains("mean()"),contains("std()"))

# replace activity ids with more readable names
activity_labels <- read.table("./Data/UCI HAR Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
activity_names <- activity_labels$V2
mean_std_data <- mutate(mean_std_data, activity = activity_names[activity])

# calculate the mean for each (subj,activity) group
by_subject_activity <- group_by(mean_std_data, subject, activity)
summary <- summarize_each(by_subject_activity, funs(mean), contains("mean()"),contains("std()"))

write.table(summary, "./Data/UCI_tidy.txt", row.name=FALSE)



