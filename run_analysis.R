library(reshape2)
#Download and unzip the file if it hasn't already been done
filename <- "dataset.zip"
if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, filename)
}
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

#Read the activity and feature labels in
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activities[,2] <- as.character(activities[,2])
features[,2] <- as.character(features[,2])

#Regex out the desired features
ffeatures <- grep("mean|std", features[,2])
ffeatures.names <- features[ffeatures,2]

#Read Training Data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[ffeatures]
trainA <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainS <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainS, trainA, train)

#Read Test Data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[ffeatures]
testA <- read.table("UCI HAR Dataset/test/Y_test.txt")
testS <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testS, testA, test)

data <- rbind(train, test)
colnames(data) <- c("Subject.Number", "Activity.Name", ffeatures.names)

#recasts the Activiy.Name
data$Activity.Name <- factor(data$Activity.Name, levels = activities[,1], labels = activities[,2])
data$Subject.Number <- as.factor(data$Subject.Number)

#melts and recasts the data into a tidy data set with the average of each variable for each activity and each subject.
mdata <- dcast(melt(data, id = c("Subject.Number", "Activity.Name")), Subject.Number + Activity.Name ~ variable, mean)

#writes the data set to a text file
write.table(mdata, "tidy.txt", row.names = FALSE, quote = FALSE)