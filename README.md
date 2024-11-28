# Description of how scripts in run_analysis.R works
This document explains how the scripts in the file "run_analysis.R" works. At the start, assume that the file "run_analysis.R" and the folder "UCI HAR Dataset" that contains all the data files are already in the working directory.

##1.Loading the data files into variables
For each of the files "subject_test.txt", "X_test.txt" and "y_test.txt" in the "test" folder, the contained data is loaded into a variable of the same name as the file. The same is done for the three files "subject_train.txt", "X_train.txt" and "y_train.txt" in the "train" folder. 


```r
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
```


##2.Merging the training and the test sets to create one data set
First combine the rows of the variables "subject_test" (2947\*1) and "subject_train" (7352\*1) to create the variable "subject" (10299\*1). The same is done for variables "y_test" (2947\*1) and "y_train" (7352\*1) to create the variable "y" (10299\*1), and for variables "X_test" (2947\*561) and "X_train" (7352\*561) to create the variable "X" (10299\*561).


```r
subject <- rbind(subject_test,subject_train)
y <- rbind(y_test, y_train)
X <- rbind(X_test, X_train)
```

Then combine the columns of the variables "subject", "y" and "X" to create one data set "df" (10299\*563).


```r
df <- cbind(subject, y,X)
```

##3.Extracting only the measurements on the mean and standard deviation for each measurement.
Looking at the file "features.txt" and select the indices of those features that has "-mean()" or "-std()" in them. Store these  indices into variable "indices" (1\* 66).


```r
indices <- c(1:6,41:46, 81:86, 121:126, 161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543)
```

The columns that we need from the data frame "df" are the first two (subject and y) and the columns in "X" suggested by the entries in "indices". (The "+2" is there to shift the indices to indices in "df".)


```r
columns <- c(1,2,indices + 2)
df <- df[,columns]
```

##4.Using descriptive activity names to name the activities in the data set
The table in the file "activity_labels.txt" gives the names of the activities that the numbers in the second column of the data frame "df" represent. The folloing code translate the numbers into the activity names.


```r
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
df[[2]] <- activity_labels[df[[2]],2]
```

##5.Appropriately labeling the data set with descriptive variable names
The variable names in the file "features.txt" with indices given in the variable "indices" (see above) are transformed into syntactically valid names acceptable by R. A syntactically valid name consists of letters, numbers and the dot or underline characters and starts with a letter or the dot not followed by a number. 

The first variable of "df" has name "subject" and the second "activity". The remaining 66 variables are assigned the syntactically valid names just created. 

Note: For description of a syntactically valid name, see the document for "make.names()". Here we apply make.names() to the vector "indices" and remove excessive dots.

```r
features_revised <- c("subject","activity","tBodyAcc.mean.X","tBodyAcc.mean.Y","tBodyAcc.mean.Z","tBodyAcc.std.X","tBodyAcc.std.Y","tBodyAcc.std.Z","tGravityAcc.mean.X","tGravityAcc.mean.Y","tGravityAcc.mean.Z","tGravityAcc.std.X","tGravityAcc.std.Y","tGravityAcc.std.Z","tBodyAccJerk.mean.X","tBodyAccJerk.mean.Y","tBodyAccJerk.mean.Z","tBodyAccJerk.std.X","tBodyAccJerk.std.Y","tBodyAccJerk.std.Z","tBodyGyro.mean.X","tBodyGyro.mean.Y","tBodyGyro.mean.Z",
"tBodyGyro.std.X","tBodyGyro.std.Y","tBodyGyro.std.Z","tBodyGyroJerk.mean.X","tBodyGyroJerk.mean.Y","tBodyGyroJerk.mean.Z","tBodyGyroJerk.std.X","tBodyGyroJerk.std.Y","tBodyGyroJerk.std.Z","tBodyAccMag.mean","tBodyAccMag.std","tGravityAccMag.mean","tGravityAccMag.std","tBodyAccJerkMag.mean","tBodyAccJerkMag.std","tBodyGyroMag.mean","tBodyGyroMag.std","tBodyGyroJerkMag.mean","tBodyGyroJerkMag.std",
"fBodyAcc.mean.X","fBodyAcc.mean.Y","fBodyAcc.mean.Z","fBodyAcc.std.X","fBodyAcc.std.Y","fBodyAcc.std.Z","fBodyAccJerk.mean.X","fBodyAccJerk.mean.Y","fBodyAccJerk.mean.Z","fBodyAccJerk.std.X","fBodyAccJerk.std.Y","fBodyAccJerk.std.Z","fBodyGyro.mean.X","fBodyGyro.mean.Y","fBodyGyro.mean.Z","fBodyGyro.std.X","fBodyGyro.std.Y","fBodyGyro.std.Z","fBodyAccMag.mean","fBodyAccMag.std","fBodyAccJerkMag.mean","fBodyAccJerkMag.std","fBodyGyroMag.mean", "fBodyGyroMag.std", "fBodyGyroJerkMag.mean", "fBodyGyroJerkMag.std")

names(df) <- features_revised 
```

##6.Creating a second, independent tidy data set
From the data set in previous step, we create a second, independent tidy data set with the average of each variable for each activity and each subject.

To take the means within groups given by the two variables "subject" and "activity", we use the "data.table"
library. First convert data frame "df" into data table "dt", and use the "lapply" function on columns 3 to 68 to take the means. The 'by="subject,activity"' suggests that the grouping is with respect to "subject" and "activity".

The result is stored in the data table "mean_result" (180\*68). 


```r
library(data.table)
dt <- data.table(df)
mean_result <- dt[ ,lapply( .SD, mean),by="subject,activity",.SDcols = 3:68]
mean_result <- mean_result[with(mean_result, order(subject, activity)), ]
```

##7.Saving the tidy data set
The tidy data set "mean_result" created from the previous step is saved in the file "tidy_data.txt". 


```r
write.table(mean_result,file = "tidy_data.txt",row.names = FALSE )
```
