subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
 

subject <- rbind(subject_test,subject_train)
y <- rbind(y_test, y_train)
X <- rbind(X_test, X_train)

df <- cbind(subject, y,X)
 

indices <- c(1:6,41:46, 81:86, 121:126, 161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543)
 
columns <- c(1,2,indices + 2)
df <- df[,columns]

 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
df[[2]] <- activity_labels[df[[2]],2]


features_revised <- c("subject","activity","tBodyAcc.mean.X","tBodyAcc.mean.Y","tBodyAcc.mean.Z","tBodyAcc.std.X","tBodyAcc.std.Y","tBodyAcc.std.Z","tGravityAcc.mean.X","tGravityAcc.mean.Y","tGravityAcc.mean.Z","tGravityAcc.std.X","tGravityAcc.std.Y","tGravityAcc.std.Z","tBodyAccJerk.mean.X","tBodyAccJerk.mean.Y","tBodyAccJerk.mean.Z","tBodyAccJerk.std.X","tBodyAccJerk.std.Y","tBodyAccJerk.std.Z","tBodyGyro.mean.X","tBodyGyro.mean.Y","tBodyGyro.mean.Z",
                      "tBodyGyro.std.X","tBodyGyro.std.Y","tBodyGyro.std.Z","tBodyGyroJerk.mean.X","tBodyGyroJerk.mean.Y","tBodyGyroJerk.mean.Z","tBodyGyroJerk.std.X","tBodyGyroJerk.std.Y","tBodyGyroJerk.std.Z","tBodyAccMag.mean","tBodyAccMag.std","tGravityAccMag.mean","tGravityAccMag.std","tBodyAccJerkMag.mean","tBodyAccJerkMag.std","tBodyGyroMag.mean","tBodyGyroMag.std","tBodyGyroJerkMag.mean","tBodyGyroJerkMag.std",
                      "fBodyAcc.mean.X","fBodyAcc.mean.Y","fBodyAcc.mean.Z","fBodyAcc.std.X","fBodyAcc.std.Y","fBodyAcc.std.Z","fBodyAccJerk.mean.X","fBodyAccJerk.mean.Y","fBodyAccJerk.mean.Z","fBodyAccJerk.std.X","fBodyAccJerk.std.Y","fBodyAccJerk.std.Z","fBodyGyro.mean.X","fBodyGyro.mean.Y","fBodyGyro.mean.Z","fBodyGyro.std.X","fBodyGyro.std.Y","fBodyGyro.std.Z","fBodyAccMag.mean","fBodyAccMag.std","fBodyAccJerkMag.mean","fBodyAccJerkMag.std","fBodyGyroMag.mean", "fBodyGyroMag.std", "fBodyGyroJerkMag.mean", "fBodyGyroJerkMag.std")

names(df) <- features_revised 


library(data.table)
dt <- data.table(df)
mean_result <- dt[ ,lapply( .SD, mean),by="subject,activity",.SDcols = 3:68]
mean_result <- mean_result[with(mean_result, order(subject, activity)), ]

write.table(mean_result,file = "tidy_data.txt",row.names = FALSE )