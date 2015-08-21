
see what my current directory is

getwd()

[1] "C:/Users/skhan/Documents"

clear my current working environment start fresh

rm(list=ls())

I am setting the working directory to where i downloaded and unzipped the project files

setwd('C:/Users/skhan/Documents/Saj/Data Science/Getting Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/')

check if my command worked to set directory getwd() [1] "C:/Users/skhan/Documents/Saj/Data Science/Getting Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"

inspect element in the folder

list.files(getwd()) [1] "activity_labels.txt" "features.txt" "features_info.txt" "README.txt" "test" "train"

Lets us read the data from the files in the working directory

features = read.table('./features.txt',header=FALSE)
continue reading all the tables from the wokring directory

activityType = read.table('./activity_labels.txt',header=FALSE) subjectTrain = read.table('./train/subject_train.txt',header=FALSE) xTrain = read.table('./train/x_train.txt',header=FALSE) yTrain = read.table('./train/y_train.txt',header=FALSE)
Assign column names to the data that I read using read.table function above

colnames(activityType) = c('activityId','activityType') colnames(subjectTrain) = "subjectId" colnames(xTrain) = features[,2]

colnames(xTrain) = features[,2] colnames(yTrain) = features[,2] Error in colnames<-(*tmp*, value = c(243L, 244L, 245L, 250L, 251L, : 'names' attribute [561] must be the same length as the vector [1]

colnames(yTrain) = "activityId"
Here I am creating the final training set by merging the three (yTrain, subjectTrain, and xTrain)

trainingData = cbind(yTrain,subjectTrain,xTrain)
I need to Read the test data from subject_text

subjectTest = read.table('./test/subject_test.txt',header=FALSE)

xTest = read.table('./test/x_test.txt',header=FALSE) yTest = read.table('./test/y_test.txt',header=FALSE)
Assign column names to the data that I read using read.table function above

colnames(subjectTest) = "subjectId" colnames(xTest) = features[,2] colnames(yTest) = "activityId"
Here I am creating the final test set by merging the three (xTest, yTest and subjectTest data)

testData = cbind(yTest,subjectTest,xTest)
here I will use rbind to combine the two (training and test data) to create a combined data set and name it final data

finalData = rbind(trainingData,testData)
I need to create a vector for the col names from the combined data set I just created that will be used to select the desired mean() & stddev() columns

colNames = colnames(finalData)
Now for the step 2 of the project I would create a vector for the column names from the finalData, which will be used to select the desired mean() & stddev() columns

logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))
The following is a Subset of finalData table based on the logicalVector to keep only desired columns as required

finalData = finalData[logicalVector==TRUE]
For Step3 I would Merge the finalData set with the acitivityType table to include descriptive activity names

finalData = merge(finalData,activityType,by='activityId',all.x=TRUE)
After merge there are new column names so we need to update

colNames = colnames(finalData)
For Step 4 I need to clean up the variable names

for (i in 1:length(colNames))

{
colNames[i] = gsub("\()","",colNames[i])
colNames[i] = gsub("-std$","StdDev",colNames[i])
colNames[i] = gsub("-mean","Mean",colNames[i])
colNames[i] = gsub("^(t)","time",colNames[i])
colNames[i] = gsub("^(f)","freq",colNames[i])
colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
}
I need to add the new descriptive column names to the finalData set

colnames(finalData) = colNames
For Step 5 I need to create a new table, finalDataNoActivityType without the activityType column != does the job

finalDataNoActivityType = finalData[,names(finalData) != 'activityType']
here I use the aggregate function to summarize the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject and name it tidydata

tidyData = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean)
Let me merge the shiny new :) tidyData with activityType to include descriptive acitvity names

tidyData = merge(tidyData,activityType,by='activityId',all.x=TRUE)
the final step I will use write.table to create a txt file in my working directory and upload the txt file to coursera

write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')
