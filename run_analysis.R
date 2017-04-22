library(reshape2)

file <- "getdata_dataset.zip"
if (!file.exists(file)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, file, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(file) 
}

Alabels <- read.table("UCI HAR Dataset/activity_labels.txt")

Alabels[,2] <- as.character(Alabels[,2])

features <- read.table("UCI HAR Dataset/features.txt")

features[,2] <- as.character(features[,2])


featuresWanted <- grep(".*mean.*|.*std.*", features[,2])

featuresWantednames <- features[featuresWanted,2]

featuresWantednames = gsub('-mean', 'Mean', featuresWantednames)

featuresWantednames = gsub('-std', 'Std', featuresWantednames)

featuresWantednames <- gsub('[-()]', '', featuresWantednames)



train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]

trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")

trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

train <- cbind(trainSubjects, trainActivities, train)


test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]

testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")

testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

test <- cbind(testSubjects, testActivities, test)



allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWantednames)


allData$activity <- factor(allData$activity, levels = Alabels[,1], labels = Alabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)