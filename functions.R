# - Function getColumnNames
# - Purpose: This function gets the column names from the specified file and 
# returns the vector with arranged column names
# - Parameters: the file path
getColumnNames <- function (filePath){
    #reads the specified file to a table
    tablenames<-read.table(filePath, header=FALSE, sep="\t")
    
    #creates the vector
    cnames<-c()
    
    #arranges column names and put them in a vector
    for(i in tablenames$V1){
        i<-gsub("[-]|[.]|[,]","_",gsub("([0-9]?[0-9]?[0-9] )|([(])|([)])","",i))
        cnames<-c(cnames,i)
    }
    
    #cleans the environment
    rm(i)
    rm(tablenames)
    
    #returns the vector
    return(cnames)
}

# - Function getActivities
# - Purpose: This function gets the activities names from the specified file and 
# splits their fullname in ID + Description. Then it returns the table with 
# the activites.
# - Parameters: the file path
getActivities <- function (filePath){
    #reads the specified file to a table
    activitylabels<-read.table(filePath, header=FALSE, sep="\t")
    #splits the values
    activitylabels$id<-substr(as.character(activitylabels$V1), 1, 1)
    activitylabels$activity<-substr(as.character(activitylabels$V1), 3, nchar(as.character(activitylabels$V1)))
    
    #returns the table
    return(activitylabels)
}

# - Function getDataSet
# - Purpose: This function gets the dataset from the specified file and 
# combines it with the subjects set, labels set and the activities set. 
# Then returns the data set.
# - Parameters: the dataset (file) path, the vector with the columns names,
# the subjects (file) path, the labels (file) path and the activities labels table
getDataSet<-function(datasetPath, cnames, subjectsPath, labelsPath, activitylabels){
    # reads the data set
    dataset<-read.table(datasetPath, header=FALSE, col.names=cnames)  
    # reads the subject set
    subjectset<-read.table(subjectsPath, header=FALSE, col.names="subject")  
    #adds subjects column to dataset
    dataset <- cbind(subjectset,dataset)    
    #adds labels set
    labelset<-read.table(labelsPath, header=FALSE, col.names="label")    
    #adds labels column to trainset
    dataset <- cbind(labelset,dataset)    
    dataset<-merge(activitylabels,dataset, by.x="id", by.y="label")
    
    #removes unused columns
    dataset <- dataset[, which(!grepl("V1", colnames(dataset)))]
    dataset <- dataset[, which(!grepl("id", colnames(dataset)))]
    
    #returns the dataset
    return(dataset)
}