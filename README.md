# Getting-and-Cleaning-Data-Course-Project

Hello and thanks for taking the time to review my project.

The script reads into R all of the necessary files, merges them, names variables, subsets means and standard deviations and calculates means of subject activities and writes a table to this tidied data.

The script begins with the assumption that the "UCI HAR Dataset" directory has been downloaded and unzipped in the working directory.

First all of the data, (subject_test, subject_train, y_test, y_train, X_test and X_train) is read into R using the read.table function. Next the test and train sets are merged together. Wherever large objects could be removed after having been merged I went ahead and merged them as keeping multiple large objects in my working environment in R (maybe with the View function in particular) tended to throttle memory and performance.

Before binding subject, activity and measurement tables together I went and labeled variables and activities. In particular it was easier to name variables for measurements before binding because the features document where the variable names came from was 561 values wide and the measurements was 561 values wide as well. It meant not having to offset and also deal with three "V1" columns.

I created a look-up vector as per the Getting and Cleaning Data Project Help Guide pdf I found on the forum. I found a nice guide for creating a key-value look-up vector here:

https://www.infoworld.com/article/3323006/do-more-with-r-quick-lookup-tables-using-named

After changing variable names and activities, I bound the subject, activity and measurement data into one table. I subset the table by using a vector created by searching the variable names for "mean" an d "stddev". From what I could tell the "MeanFreq" was a whole different measurement than the means of other measurements, so I removed it.

After subsetting, I calculated the means of each subject-activity by using the reshape package, first "melting"" the data using subject and activity as ids and everything else as a variable and then recasting with the mean function for the variables.

The data can be read using read.table("tidydata.txt", header = TRUE).