#################################################################################
## Coursera Getting and Cleaning Data Course Project
## Katy Sloan
## 04-24-2015

# run_analysis.R File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded
# from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# These steps will be solved out of order for efficiency and clarity.
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for 
#    each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 

#################################################################################

# read in data from extracted zip file
setwd("C:/Users/KATY/Google Drive/Coursera/03-GettingData/courseproject")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# remove disallowed characters in feature names
features <- make.names(names=features[,2], unique=TRUE, allow_ = TRUE)

# 2. Extract only the measurements on the mean and standard deviation for 
#    each measurement. 
# MeanFreq will be removed later
keptColumns <- grep("mean|std", features, value = FALSE, ignore.case=FALSE)
keptColumnNames <- grep("mean|std", features, value = TRUE, ignore.case=FALSE)
library(dplyr)
test_x <- select(test_x,keptColumns)
train_x <- select(train_x,keptColumns)

# Data is still messy. Further refining columns to eliminate variables that were
# not measured on 3 axes so that table only has one kind of observation.
keptColumns <- grep("X$|Y$|Z$", keptColumnNames, value = FALSE, ignore.case=FALSE)
keptColumnNames <- grep("X$|Y$|Z$", keptColumnNames, value = TRUE, ignore.case=FALSE)
test_x <- select(test_x,keptColumns)
train_x <- select(train_x,keptColumns)

# 4. Appropriately label the data set with descriptive activity names.
# If this is moved to after the join, the for loop must go through many more 
# iterations than doing it now.
for (i in 1:length(keptColumnNames)) 
{
        keptColumnNames[i] = gsub("\\()","",keptColumnNames[i])
        keptColumnNames[i] = gsub("\\.std",".StdDev",keptColumnNames[i])
        keptColumnNames[i] = gsub("\\.mean",".Mean",keptColumnNames[i])
        keptColumnNames[i] = gsub("^(t)","time.",keptColumnNames[i])
        keptColumnNames[i] = gsub("^(f)","freq.",keptColumnNames[i])
        keptColumnNames[i] = gsub("([Gg]ravity)","Gravity",keptColumnNames[i])
        keptColumnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",
                                  keptColumnNames[i])
        keptColumnNames[i] = gsub("[Gg]yro","Gyro",keptColumnNames[i])
        keptColumnNames[i] = gsub("AccMag","AccMagnitude",keptColumnNames[i])
        keptColumnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",
                                  keptColumnNames[i])
        keptColumnNames[i] = gsub("JerkMag","JerkMagnitude",keptColumnNames[i])
        keptColumnNames[i] = gsub("GyroMag","GyroMagnitude",keptColumnNames[i])
};

# combining test and training data sets row-wise
tidy_x <- rbind(test_x, train_x)
tidy_y <- rbind(test_y, train_y)
tidy_sub <- rbind(test_sub, train_sub)

# assigning friendly column names
colnames(tidy_x) <- keptColumnNames
colnames(tidy_y) <- "activity"
colnames(tidy_sub) <- "subject"

# 1. Merge the training and the test sets to create one data set.
tidy <- tbl_df(cbind(tidy_sub,tidy_y,tidy_x))

# 3. Use descriptive activity names to name the activities in the data set
tidy$activity <- activity_labels[tidy$activity, 2]

#clean up workspace
rm(activity_labels, test_sub, test_x, test_y, tidy_sub, tidy_x, tidy_y,
   train_sub, train_x, train_y)

# tidy first data set:
# only one variable per column
# only one observation per row
# only one kind of observation in the table
library(tidyr)
tidy <- tidy %>%
        gather(measure_combo, value, 3:59, -subject, -activity) %>%
        separate(measure_combo, c("timefreq","type","stat","blank1","blank2",
                                  "axis"), "\\.") %>%
        select(subject, activity, timefreq, type, stat, axis, value) %>%
        # removing MeanFreq (which got selected along with Mean earlier)
        filter(stat!="MeanFreq") %>% 
        arrange(stat, type, axis) %>%
        print

# 5. Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 
tidy2 <- tidy %>% 
        group_by(subject, activity, timefreq, type, stat, axis) %>% 
        summarise_each(funs(mean))

# outputs second tidy data set into a .txt file for submission
write.table(tidy2, "tidy_data.txt", row.name=FALSE)
