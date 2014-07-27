#TO EDIT: variables with the files paths #####################
features_path       <-"./UCI HAR Dataset/features.txt"
activity_labels_path<-"./UCI HAR Dataset/activity_labels.txt"
X_train_path        <-"./UCI HAR Dataset/train/X_train.txt"
subject_train_path  <-"./UCI HAR Dataset/train/subject_train.txt"
y_train_path        <-"./UCI HAR Dataset/train/y_train.txt"
X_test_path         <-"./UCI HAR Dataset/test/X_test.txt"
subject_test_path   <-"./UCI HAR Dataset/test/subject_test.txt"
y_test_path         <-"./UCI HAR Dataset/test/y_test.txt"
##############################################################

source('./functions.R')
library(reshape2)

#create vector with dataset column names
cnames<-getColumnNames(features_path)

#create table with activities description
activitylabels<-getActivities(activity_labels_path)

#read train set
trainset<-getDataSet(X_train_path, cnames, subject_train_path, y_train_path, activitylabels)

#read test set
testset<-getDataSet(X_test_path, cnames, subject_test_path, y_test_path, activitylabels)

#my merged dataset
completeset<-rbind(testset,trainset)

#clean the environment
rm(testset)
rm(trainset)

#extract just means and stds
completeset<-completeset[,c("subject","activity",cnames[grep("*std*|*mean*", cnames)])]

#creating a second, independent tidy data set with the average of 
#each variable for each activity and each subject. 
completesetmelt<-melt(completeset,id=c("subject","activity"))
completesetavg<-dcast(completesetmelt,subject+activity~variable,mean)

#clean the environment
rm(completesetmelt)
rm(activitylabels)
rm(cnames)

#writes the final tidy dataset
write.table(completesetavg, "./mydata.txt", sep="\t",row.names = FALSE)