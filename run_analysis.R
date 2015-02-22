## Getting and Cleaning Data - Course Project

##***********************************************************************************************##
## The objectives are to create an R script called run_analysis.R that:

## 1. Merges the training and the test sets to create one data set
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.

##    The end result will achieve all 5, albeit not in the sequence given.

##***********************************************************************************************##


##    A.  READING THE DATA AND SAVING TO A DEDICATED DIRECTORY (Step 0 - preparing data)

##        Create a directory for the zipped data and download it

      if(!file.exists("./courseraproject"))
          {dir.create("./courseraproject")}
      
      projecturl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      
      download.file(projecturl,destfile="./courseraproject/download.zip")

##       Unzip the downloaded file (download.zip) to its constituent files.

        setwd("courseraproject")
        unzip("download.zip")

##      Read the data into dataframes in R.
          
##      Reading the activity labels and feaure labels.
    
        setwd("UCI HAR Dataset")
      
        activity_labels <- read.table(file="activity_labels.txt")
        features <- read.table(file="features.txt")

##      Reading the test data    
      
        setwd("test")
      
        subject_test <- read.table(file ="subject_test.txt")
        X_test <- read.table(file="X_test.txt")
        y_test <- read.table(file="y_test.txt")

##      Reading the train data
      
        setwd("..")
        setwd("train")

        subject_train <- read.table(file ="subject_train.txt")
        X_train <- read.table(file="X_train.txt")
        y_train <- read.table(file="y_train.txt")    

##    B MERGING THE DATAFRAMES TO CREATE ONE LARGE DATA SET (Step 1)      
      
##      Add the subjects and the activities to the datasets by appending y_test, subject_test
##      and y_train, subject_train to X_test and X_train respectively.      
##      Build a composite dataframe (alldata)
    
      train <- cbind(y_train,subject_train,X_train)
      test <- cbind(y_test,subject_test,X_test)   
      alldata <-rbind(test,train)

##***************************************************************************************##
##    This accomplishes Step 1 - a single dataset 'alldata' has been created             ##
##***************************************************************************************##
      
##    C RENAME THE COLUMNS (Step 4)
      
##      We will replace the column names with the names from the features.txt file as well as "Activity" and "Subject"

      labels <- c("Activity","Subject",as.character(features[,2]))

      names(alldata) <- labels

##***************************************************************************************##
##    This accomplishes Step 4 - all variables have been renamed                         ##
##***************************************************************************************##     

##    D CHANGE ACTIVITY CODES TO ACTIVITY NAMES (Step 3)

##      Replace Activity labels with Activity Names

##      Merges the Activity Labels dataset with the dataset to read the activity label as a column
##      Then deletes the column with the activity key.

        alldata <-merge(alldata,activity_labels,by.x="Activity",by.y="V1",all="TRUE")
        alldata[,1] <- alldata[,564]
        alldata[,564] <- NULL

##***************************************************************************************##
##    This accomplishes Step 3 - The activity names are used instead of the keys         ##
##***************************************************************************************##         
      
##    E EXTRACT ONLY THE MEAN AND STANDARD DEVIATION MEASURES (Step 2)

##      Note - only variable names featuring "-mean()" and "-std()" will be used.
      
##      The approach is to use 'grep' and wildcards on the variable names to read
##      in the variables needed into two datasets.
##      In addition, the two leading columns are retained in a separate dataset.
##      The result is concatenated into a dataset using cbind.
      
##      '\\' must be used as an escape character as '()' are special characters in grep.
      
        std <- alldata[,grep("*-std\\(\\)",names(alldata))]
        mean <- alldata[,grep("*-mean\\(\\)",names(alldata))]
        leading = alldata[,1:2]
        leandata <- cbind(alldata[,1:2],std,mean)
      
##***************************************************************************************##
##    This accomplishes Step 2 - Only STD and MEAN VARIABLES ARE SELECTED                ##
##***************************************************************************************## 

##    F CREATE AN INDEPENDENT TIDY DATASET WITH THE AVERAGE OF EACH VARIABLE BY ACTIVITY AND SUBJECT
      
##      As hinted in the course, the dplyr package is useful for this.
      
##      (perhaps not needed: 'install.packages("dplyr")'
      
      library(dplyr)
        
      tidy_data <-leandata %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))
      
##***************************************************************************************##
##    This accomplishes Step 5 - A dataset called tidy_data is created                   ##
##***************************************************************************************##
