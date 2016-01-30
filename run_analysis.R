# SCRIPT: run_analysis.R
#
# OVERVIEW:
# This script was written as an assignment for the Coursera & John Hopkins data science course named
# Getting and Cleaning Data
# 
# It reads several files related to an experiment and combines them together into a single tidy
# data set and then summarizes the data.  The combined data set and summary are written to files.
# 
# Read the Readme.md and CodeBook.md files for further details 
# 

# load tidyr and dplyr
library(tidyr); library(dplyr)

# read the subject data
trainSubject <- read.table("./train/subject_train.txt", sep = "", col.names = c("subject"))
testSubject <- read.table("./test/subject_test.txt", sep = "", col.names = c("subject"))

# prepare the subject data before joining it with X and Y
trainSubject <- trainSubject %>%
  # add id columns to easily join
  mutate(id = rownames(trainSubject))
testSubject <- testSubject %>%
  # add id columns to easily join
  mutate(id = rownames(testSubject))

# read the mapping of activity numbers to names
activityNames <- read.table("activity_labels.txt", sep = "", col.names = c("activitynumber", "activity"))

# read the training and test activity numbers for each observation
trainActivity <- read.table("./train/Y_train.txt", sep = "", col.names = c("activitynumber"))
testActivity <- read.table("./test/Y_test.txt", sep = "", col.names = c("activitynumber"))

# prepare the activity data before joining it with subject and measure data
trainActivity <- trainActivity %>%
  # add activity label to make it more clear
  inner_join(activityNames, by = c("activitynumber" = "activitynumber")) %>%
  # add id columns to easily join
  mutate(id = rownames(trainActivity)) %>%
  # select only the columns to keep for join or final data set
  select(matches("id|activity"))
testActivity <- testActivity %>%
  # add activity label to make it more clear
  inner_join(activityNames, by = c("activitynumber" = "activitynumber")) %>%
  # add id columns to easily join
  mutate(id = rownames(testActivity)) %>%
  # select only the columns to keep before joining
  select(matches("id|activity"))

# read in the feature names
features <- read.table("features.txt", sep = " ")

# clean up feature names removing non alpha numeric characters and making lower case
features$V2  <- gsub("\\(", "", features$V2)
features$V2  <- gsub(")", "", features$V2)
features$V2  <- gsub(",", "", features$V2)
features$V2  <- gsub("-", "", features$V2)
features$V2 <- tolower(features$V2)

# read the training and test measure data with the column names equal to clean features
trainMeasure <- read.table("./train/X_train.txt", sep = "", col.names = features$V2)
testMeasure <- read.table("./test/X_test.txt", sep = "", col.names = features$V2)

# prepare the measure data before joining it with subject and activity data 
trainMeasure <- trainMeasure %>% 
        # add id columns easily join
        mutate(id = rownames(trainMeasure)) %>%
        # select the subset of columns to keep before joining
        select(matches("id|mean|std"))
testMeasure <- testMeasure %>% 
        # add id columns easily join
        mutate(id = rownames(testMeasure)) %>%
        # select the subset of columns to keep before joining
        select(matches("id|mean|std"))

# join subject, activity, and measurement data together for training and test
trainData <- trainSubject %>%
        inner_join(trainActivity, by = c("id" = "id")) %>%
        inner_join(trainMeasure, by = c("id" = "id"))
testData <- testSubject %>%
        inner_join(testActivity, by = c("id" = "id")) %>%
        inner_join(testMeasure, by = c("id" = "id"))
        
# Combine the training and test data, first remove id and activitynumber used for joining
allData <- rbind(select(trainData,-id, -activitynumber), select(testData,-id, -activitynumber))
  
# summarize the data, showing the average grouped by activity and subject
groupedData <- allData %>% group_by(activity, subject) %>% summarise_each(funs(mean))

# write the results to files
write.table(allData,"allData.txt", row.names = FALSE)
write.table(groupedData,"groupedData.txt", row.names = FALSE)
