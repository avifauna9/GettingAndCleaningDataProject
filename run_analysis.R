## merge the training and test sets to create one dataset
X <- rbind(x_train, x_test)    ## combine the training & test sets. add subjects from both, can combine bc same number of columns.
Y <- rbind(y_train, y_test)    ## combine the training and test labels. same as above
Subject <- rbind(subject_train, subject_test)  ## combine data that identifies the subjects
Merged_Data <- cbind(Subject, Y, X)   ## combine sets, labels, and ID info into one data frame 

## extract only mean and std. dev. for each measurement
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))  ## use pipe operator to select only sub./code/mean/std.dev.

## use descriptive activity names to name the activities in the data set
TidyData$code <- activities[TidyData$code, 2]  ## subset only col2 with the descriptive names 

## label the data set with descriptive variables 
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

## create second dataset w/ avg of each variable for each activity and subject
FinalData <- TidyData %>%                       ## pass through pipeline operator
        group_by(subject, activity) %>%         ## group first by subject, then activity
        summarise_all(list(mean))               ## find average
write.table(FinalData, "FinalData.txt", row.name=FALSE)  ## write the table of FinalData, no row labels

FinalData

