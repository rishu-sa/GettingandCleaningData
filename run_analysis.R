### Getting and Cleaning Data Course Project
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Install required packages
install.packages('data.table', dependencies = TRUE)
install.packages('reshape2', dependencies = TRUE)

library(data.table)
library(reshape2)

## Load activity labels
activity_labels <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/activity_labels.txt")[,2]

# Load data column names
features <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load and process x_testData & y_testData data.
x_testData <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/test/x_test.txt")
y_testData <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/test/subject_test.txt")

names(x_testData) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
x_testData = x_testData[,extract_features]

# Load activity labels
y_testData[,2] = activity_labels[y_testData[,1]]
names(y_testData) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_Dataset <- cbind(as.data.table(subject_test), y_testData, x_testData)

# Load and process x_trainData & y_trainData data.
x_trainData <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/train/x_train.txt")
y_trainData <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("D:/Coursera/DataCleaning/Assignment/UCI HAR Dataset/train/subject_train.txt")

names(x_trainData) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
x_trainData = x_trainData[,extract_features]

# Load activity data
y_trainData[,2] = activity_labels[y_trainData[,1]]
names(y_trainData) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_Dataset <- cbind(as.data.table(subject_train), y_trainData, x_trainData)

# Merge test and train data
data = rbind(test_Dataset, train_Dataset)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "D:/Coursera/DataCleaning/Assignment/tidyDataSet.txt")
