---
title: "Getting and Cleaning Data Course Project Codebook"
author: "Katy Sloan"
date: "Saturday, April 25, 2015"
output: html_document
---

See README.md in this repository for more background information on the dataset.

Reading in the Raw Data
-----------------------
The raw data can be downloaded at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.
I read in the following files:

- 'features.txt': Lists of all features (561).
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training activity labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test activity labels.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

The names in features.txt are used to label the columns in the X_train and X_test datasets. The subject_train and subject_test datasets are merged with the "X" datasets to create the subject variable. The y_train and y_test datasets are also merged with the "X" datasets, but they create the activity columns. The activity_labels dataset is used to label the activities (numbered 1-6) with their actual names (i.e. WALKING, LAYING, etc.).

Eliminating Features
--------------------
The assignment instructed us to extract only the variables that measure mean and standard deviation. I further limited the variables to only include the measures that carried an X, Y, or Z label so that the resulting "tidy" data set would only have one kind of observation in the resulting table. I dropped the unnecessary columns from the X_train and X_test datasets first in order to limit the size of the data before manipulation.

Updating Naming Conventions
-----------------------------------------------------------------------
The features data set included names such as "tBodyAcc-mean()-X". The characters used in features include disallowed characters in R. I used the make.names function to first replace those disallowed characters with ".", resulting in variable names such as "tBodyAcc.mean...X". I then used a for loop with gsub routines to "find and replace" abbreviations with full English words in order to make the data more readable. The resulting variables have names such as "time.BodyAcc.Mean...X".

Merging the Data
----------------
First, I combined the test and train data sets row-wise for the "X", "y" and "subject" data separately. Second, I updated the variable names for each of the 3 pieces -- the X dataset with the features names, the y dataset with "activity" and the subject dataset with "subject". Then, I merged the subject, y and X datasets column-wise in that order using dplyr. Last, I updated the numbers in the activity columns with their English names from the activity_labels dataset.

Creating the Tidy Dataset
-------------------------
I used dplyr and tidyr packages to tidy the merged dataset. First, I gathered the data from the 57 feature name variables into 2 variables -- measure_combo and value. Then, I separated the components of the measure_combo variable into different columns in order to make the final data set more useful and easy to filter on statistic type or axis. The final measures have names such as "time" "BodyAcc" "Mean" "X" split into different variables. I also realized at this stage that the statistic variable included "MeanFreq" in addition to "Mean" and "Std Dev", so I filtered the data to exclude "MeanFreq" observations. The resulting data set is a sorted, long dataset of 7 variables and 494,352 observations. The variables are:

* subject - contains the subject ID
* activity - contains the activity type (i.e. WALKING)
* timefreq - contains an indicator on whether the measure was "time" or "freq"
* type - contains the feature type (i.e. "BodyAcc")
* stat - contains an indicator on whether the measure is a mean or a standard deviation
* axis - contains the axis on which the feature was measured
* value - contains the value for that measure

Summarizing the Tidy Dataset & Exporting the Result
----------------------------------------------------
I created a second dataset which summarizes the 494,352 observations in the previous tidy data set down to 8,640 observations by grouping by all of the label variables -- subject, activity, timefreq, type, stat, and axis -- and then taking the mean of the values for the grouped observations. The summary data is then output to a .txt file called tidy_data.txt.

