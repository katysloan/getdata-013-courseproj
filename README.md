---
title: "Getting and Cleaning Data Course Project README"
author: "Katy Sloan"
date: "Saturday, April 25, 2015"
output: html_document
---

Introduction
------------
This repository contains my course project for Coursera's "Getting and Cleaning Data" course.

Raw Data
--------
This project was about cleaning up wearable computing data. The raw data can be downloaded at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. A full description of the data is available at the site <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

From the README.txt in the original dataset:
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units are rad/seg.

I used the following files:

- 'features.txt': Lists of all features (561).
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training activity labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test activity labels.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

R Script Creates Tidy Dataset
-----------------------------
run_analysis.R is an R Script that merges and cleans the data above after downloading and extracting the necessary files from the zip file into a directory called UCI HAR Dataset. Two final data sets are created -- one tidy dataset and one summary of that tidy dataset.

Code Book
---------
codebook.md describes how the raw data was processed in order to generate the tidy dataset and describes the resulting variables.
