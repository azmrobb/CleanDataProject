---
title: "CodeBook"
author: "Mike Robb"
date: "January 30, 2016"
output: html_document
---

### Overview
This file describes how the _CleanData.R_ script works.  
The script was wirtten as part of an assignment for the Coursera & John Hopkins data science course named **Getting and Cleaning Data**

It reads several files related to an experiment and combines them together into a single tidy
data set and then summarizes the data.  The combined data set and summary are written to files.

### Input
The _CleanData.R_ script reads the following files into the following variables.
The script script assumes the files are located as iisted below (~ = current working directory).
The data in these files that were collected for two types of observations (training and test)

File  | Location  | Variable  | Description   
---   | ---     | ---   | ---   
subjects_train.txt  | ~/train   | trainSubject | 1 column integers representing subject for each training observation  
y_train.txt   | ~/train   | trainActivity   | 1 column integers representing activity for each training observation  
x_train.txt   | ~/train   | trainMeasure    | 561 columns of numbers representing measurments for each training observation  
subjects_test.txt   | ~/test    | testSubject   | 1 column of integers representing subject for each test observation   
y_test.txt    | ~/test    | testActivity    | 1 column of integers representing activity for each test observation  
x_test.txt  | ~/test  | testMeasure   | 561 columns of numbers representing measurments for each test observation  
activity_labels.txt   | ~   | activityNames   | 2 column mapping activity numbers to names   
features.txt  | ~   | features  | 1 column of 561 names of measurements   

_Notes_   
 * There are no column headings in the files  
 * The original source of the files is [Link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 

### Processing
The _Cleandata.R_ script does the following, but necessarily in the order listed

1. Reads each of the file listed above into the variables listed above 
2. Adds an activity column containing the activity name to each row of the activityTrain and activity test data frames 
3. Adds cleans up the measurement names listed in features to only include alpha numeric character in lower case characters 
4. Adds the cleaned up feature names as column heading trainMeasure and testmeasure 
5. Removes columns the measure data sets that are not mean or standard deviations 
6. Assigns ids to the subject, activity, and measure data sets so they can be easily joined. 
7. Joins the subject, activty, and measure data for training and test observations to form two data frames: one for training and one for test 
8. Unions together the training and test data into a single data called allData 
9. Creates a summarized data frame called groupedData showing the mean of each measure grouped by activity and subject 

The follwog data frames are created as a result of this processing:

Data Frame  | Description
---   | ---   
trainData   | combined measurements, activity, and subject for each training observation With clean column headings and activity column contain activity name   
testData  | combined measurements, activity, and subject for each test observation With clean column heading  and activity column contain activity names  
allData   | Union of trainData and testData excluding columns used to join subjects, activites, and measurements  
groupedData | Average all measurements in allData grouped by activity and subject   

### Output  
This script the follwing comma separated value files to the present working directory (~).
 
File  | Location  | Description   
---   | ---   | ---
allData.csv   | ~   | Data from allData including column headings. The subject, activity, mean, and standard deviation measurements for every observation.  
groupData.csv | ~   | Data from groupedData including column headings.  The average of each measurment in allData grouped by activity and subject.  
