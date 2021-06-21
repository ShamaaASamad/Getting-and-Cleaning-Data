# Getting and Cleaning Data


## Downloading the data

fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Smartphone Data.zip', method = "curl")
  unzip("UCI HAR Smartphone Data.zip", exdir = getwd())
}


## Reading the data

features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

data.training.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.training.y <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.training.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

data.training <-  data.frame(data.training.subject, data.training.y, data.train.x)
names(data.training) <- c(c('subject', 'activity'), features)

data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.y <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(data.test.subject, data.test.y, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)



## 1. Merges the training and the test sets to create one data set.

merged_data <- rbind(data.training, data.test)



## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)
TidyData <- merged_data %>% select(subject, activity, all_of(features), contains("mean"), contains("std"))



## 3. Uses descriptive activity names to name the activities in the data set

activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
TidyData$activity <- activity.labels[TidyData$activity]



# 4. Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


## 5. Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Final_TidyData <- aggregate(TidyData[,3:81], by = list(activity = TidyData$activity, subject = TidyData$subject),FUN = mean)
write.table(x = Final_TidyData, file = "Final_TidyData.txt", row.names = FALSE)

