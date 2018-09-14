## run_analysis.R
##
## Project work for Coursera course on "Getting and Cleaning Data"

## Objectives:
##  1. Merge the training and the test sets to create one data set.
##  2. Extract only the measurements on the mean and standard deviation for 
##     each measurement.
##  3. Use descriptive activity names to name the activities in the data set
##  4. Labels the data set with descriptive variable names.
##  5. From the data set in step 4, create a second, independent tidy data set 
##     with the average of each variable for each activity and each subject.

library(data.table)
library(plyr)

zip <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(zip)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(url, zip, method="curl")
  unzip(zip) 
}

# Load the data
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Lead Training Set
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Load Test Set
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Objective 1. Merge the training and the test sets to create one data set.
subjects <- rbind(subjectTrain, subjectTest)
colnames(subjects) <- "Subject"

activities <- rbind(activityTrain, activityTest)
colnames(activities) <- "Activity"

features <- rbind(featuresTrain, featuresTest)
colnames(features) <- t(featureNames[2])

dt <- cbind(features,activities,subjects)

## Objective 2. Extract only the measurements on the mean and standard deviation for
## each measurement
dtSubset <- dt[,grep("mean|std|subject|activity", names(dt), ignore.case=TRUE)]

## Objective 3. Use descriptive activity names to name the activities in the data set

dtSubset$Activity <- as.character(dtSubset$Activity)
for (i in 1:6) dtSubset$Activity[dtSubset$Activity == i] <- as.character(activityLabels[i,2])
dtSubset$Activity <- as.factor(dtSubset$Activity)

##  Objective 4. Labels the data set with descriptive variable names.
names(dtSubset)<-gsub("-std()", "STD", names(dtSubset), ignore.case = TRUE)
names(dtSubset)<-gsub("-freq()", "Frequency", names(dtSubset), ignore.case = TRUE)
names(dtSubset)<-gsub("angle", "Angle", names(dtSubset))
names(dtSubset)<-gsub("gravity", "Gravity", names(dtSubset))
names(dtSubset)<-gsub("Acc", "Accelerometer", names(dtSubset))
names(dtSubset)<-gsub("Gyro", "Gyroscope", names(dtSubset))
names(dtSubset)<-gsub("BodyBody", "Body", names(dtSubset))
names(dtSubset)<-gsub("Mag", "Magnitude", names(dtSubset))
names(dtSubset)<-gsub("^t", "Time", names(dtSubset))
names(dtSubset)<-gsub("^f", "Frequency", names(dtSubset))
names(dtSubset)<-gsub("tBody", "TimeBody", names(dtSubset))
names(dtSubset)<-gsub("-mean()", "Mean", names(dtSubset), ignore.case = TRUE)

## Objective 5. From the data set in step 4, create a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

dtSubset$Subject <- as.factor(dtSubset$Subject)
dtSubset <- data.table(dtSubset)

tidy = ddply(dtSubset, c("Subject","Activity"), numcolwise(mean))
write.table(tidy, file = "tidy.txt")

