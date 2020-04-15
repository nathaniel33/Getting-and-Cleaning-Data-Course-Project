# read all of the test and train files in to R

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# start binding data
subject_all <- rbind(subject_test, subject_train)
X_all <- rbind(X_test, X_train)
y_all <- rbind(y_test, y_train)

# go ahead and remove some of these huge objects

rm(list = c("subject_test", "subject_train", "y_test", "y_train", "X_test", "X_train"))

# read in features for variable names and assign them to columns of training and test set

features <- read.table("UCI HAR Dataset/features.txt")
variables_names <- as.vector(features$V2)
variables_names <- gsub("-", "_", variables_names)
variables_names <- gsub("\\()", "", variables_names)
colnames(X_all) <- variables_names

# create vectors for subsetting means and standard deviations

means_vector <- grep("mean", features$V2)
meanFreqs_vector <- grep("meanFreq", features$V2)
means_vector <- setdiff(means_vector, meanFreqs_vector)
stddevs_vector <- grep("std", features$V2)
means_and_stddevs_vector <- append(means_vector, stddevs_vector)
means_and_stddevs_vector <- sort(means_and_stddevs_vector)
X_all_means_and_stddevs <- X_all[,means_and_stddevs_vector]

# remove that huge X file and temporary vector variables
rm(list = c("X_all", "means_vector", "meanFreqs_vector", "stddevs_vector", "means_and_stddevs_vector"))

# read in activity labels 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses = "character")

# create lookup vector for activity labels
# https://www.infoworld.com/article/3323006/do-more-with-r-quick-lookup-tables-using-named-vectors.html

getactivitylabel <- activity_labels$V2
names(getactivitylabel) <- activity_labels$V1

# lookup activity labels and reassign values, change variable name

y_all$V1 <- getactivitylabel[y_all$V1]
colnames(y_all) <- "Activity"

# change variable name for subjects
colnames(subject_all) <- "Subject"

# bind subjects, activities and X values
all_bound <- cbind(subject_all, y_all, X_all_means_and_stddevs)

# keep removing those big files
rm(list = c("subject_all", "X_all_means_and_stddevs", "y_all"))

library(reshape2)
all_bound_melt <- melt(all_bound, id = c("Subject", "Activity"), measure.vars = colnames(all_bound[,3:68]))
means <- dcast(all_bound_melt, Subject + Activity ~ variable, mean)

rm(all_bound_melt)