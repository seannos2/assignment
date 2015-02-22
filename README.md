==================================================================
Coursera Getting and Cleaning Data Assignment
Version 1.0
==================================================================

BACKGROUND:

The course assignment involves reading in smartphone activity data, filtering cleaning up the data, combining datasets, and creating a new
a new dataset with summarized data.

Information on the source data is located here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The wording of the assignment is as follows:

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following:
 
1.   Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject


OUTPUT

The code is saved as run_analysis.R

PRELIMINARY NOTES ON LOGIC

This code uses the dplyr package. Also, the code contains logic to create a local directory, unzip and store the files locally,
making it portable to any user. This was not specifically called out in the instructions, but I assumed that it would be useful.

Also, the code does not follow steps 1-5 sequentially. The flow is as follows:

 -  Download and unzip files, create data sets and merge into one dataset (Task 1)
 -  Rename the variable columns (Task 4)
 -  Change Activity codes to names (Task 3)
 -  Extract selected measures (mean and STD) (Task 2)
 -  Create independent, tidy dataset (Task 5).
 
 LOGIC
 
 **PREPARING DATA**
 - A local directory 'courseraproject' is created for the data under the working dir (if it does not already exist)
 - The zipped file is downloaded using the given url
 - The file is unzipped on the local machine and the following files loaded into dataframes:
       activity_labels.txt
       features.txt
       subject_test.txt (subjects involved)
       X_test.txt (variables collected)
       y_test.txt (activities involved)
       subject_train.txt (subjects involved)
       X_train.txt (variables collected)
       y_train.txt (activities involved)
- A composite file of training data is created using cbind() with the y_train, subject_train and X_train files.
-  A composite file of test data is created using cbind() with the y_test, subject_test and X_test files.
- Of these two composite datasets, one master dataset was compiled, called 'alldata'

**RENAMING COLUMNS**
The columns of the 'alldata' dataframe are replaced by the contents of the 'features' dataset plus 'Activity' and 'Subject'.
The names() function is used to accomplish this.

**LABEL ACTIVITIES**
The merge() function is used to link activity labels on the activity_labels dataframe with the activities in the 'alldata' dataset.
The activity key column (1,2,..) is then replaced with the appropriate label (RUNNING, WALKING, etc.)

**SELECT ONLY CERTAIN VARIABLES**
The wording of the assignment implied to me to select -mean() and -std() type variables, so this is what I did.
The grep() function was used on the variable names to select subsetted datasets containing only variable names
containing -std() or -mean() and a new composite dataset was formed (leandata).

**CREATING A NEW DATASET WITH AVERAGES OF EACH VARIABLE BY SUBJECT AND ACTIVITY**
Used the dplyr package and in particular:
tidy_data <-leandata %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))
to create a new dataframe tidy_data, which contained the data needed.
 
CODEBOOK:

The original codebook, describing the variables is contained here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The activities captured in this summarized and edited output are LAYING, SITTING, STANDING, WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS.
The subjects are (unnamed) persons 1-30
The variables capture the average result of all entries in the original test and train files for the following variables:

tBodyAcc-mean()-Y
tBodyAcc-mean()-Z
tGravityAcc-mean()-X
tGravityAcc-mean()-Y
tGravityAcc-mean()-Z
tBodyAccJerk-mean()-X
tBodyAccJerk-mean()-Y
tBodyAccJerk-mean()-Z
tBodyGyro-mean()-X
tBodyGyro-mean()-Y
tBodyGyro-mean()-Z
tBodyGyroJerk-mean()-X
tBodyGyroJerk-mean()-Y
tBodyGyroJerk-mean()-Z
tBodyAccMag-mean()
tGravityAccMag-mean()
tBodyAccJerkMag-mean()
tBodyGyroMag-mean()
tBodyGyroJerkMag-mean()
fBodyAcc-mean()-X
fBodyAcc-mean()-Y
fBodyAcc-mean()-Z
fBodyAccJerk-mean()-X
fBodyAccJerk-mean()-Y
fBodyAccJerk-mean()-Z
fBodyGyro-mean()-X
fBodyGyro-mean()-Y
fBodyGyro-mean()-Z
fBodyAccMag-mean()
fBodyBodyAccJerkMag-mean()
fBodyBodyGyroMag-mean()
fBodyBodyGyroJerkMag-mean()


