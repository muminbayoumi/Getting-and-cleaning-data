if(!file.exists("data.zip")) {
        download.file(
                "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "data.zip",
                method = "curl"
        )
}
if (!file.exists("UCI HAR Dataset")) {
        unzip("data.zip", overwrite = T, exdir = "../Quiz4/")
}

library(tidyverse)
library(magrittr)
library(data.table)
### STEP 0
### This initial step (not a formal quiz step)is about reading in all the files that will be needed for
### further steps

## Reading Acitvity labels
activity.labels<- fread("UCI HAR Dataset/activity_labels.txt")
## Reading Meaninful Feature Names
feature.names <- fread(input = "UCI HAR Dataset/features.txt")



## Reading Train Dataset
        train.x <- fread("UCI HAR Dataset/train/X_train.txt")
        # Checking no. of columns on train data set matches number number of feature names
        # this makes it  future proof if  more features are added
        if (length(feature.names$V1) != length(colnames(train.x)))  {
        warning("No. of feature names loaded doesnt match no. of columns on dataset")
        }
        # Loading corresponding activity codes for train data set
        train.act.code <- fread(input = "UCI HAR Dataset/train/y_train.txt")
        #Loading Corresponding Subject Dataset
        train.subject.code <-fread(input = "UCI HAR Dataset/train/subject_train.txt")
        #Adding activity code and subject code to data set
        train.x %<>%
        #and creating another column called Train to maintain the information that this a train dataset on binding
        mutate(Activity = train.act.code$V1,
               Subject = train.subject.code$V1,
               Train = TRUE) %>%
        #this step bring last two columns to the beginnig of dataset for readablity
        select(Activity, Train, Subject, V1:V561)


## Reading Test Dataset
        test.x <- fread("UCI HAR Dataset/test/X_test.txt")
        # Checking no. of columns on test data set matches number number of feature names
        # Again to make future proof
        if (length(feature.names$V1) != length(colnames(test.x)))  {
        warning("No. of feature names loaded doesnt match no. of columns on dataset")
        }
        # Loading corresponding activity codes  and subject codes for test data set
        test.act.code <-  fread("UCI HAR Dataset/test/y_test.txt")
        test.subject.code <-fread(input = "UCI HAR Dataset/test/subject_test.txt")


        #Adding activity code and subject code to data set
        test.x %<>%
        #and creating another column called Train to maintain information on binding
        mutate(Activity = test.act.code$V1,
               Subject = test.subject.code$V1,
               Train = FALSE) %>%
        #this step brings last two columns to begging of data set for readablity
        select(Activity, Train, Subject, V1:V561)




## Merging the training and the test sets to create one data set. (STEP 1)
        full <- rbind(train.x, test.x)

## Giving Meaningful names to variables using feature names file (STEP 4)
        colnames(full)[4:564] <- make.names(feature.names$V2
                                    # this makes some duplicate column names unique to avoid error with dplyr
                                    , unique = T)
        #Setting activity column to categorical variable with levels corresponding to activity.labels  (STEP 3 - merged data set)
        full$Activity %<>% factor(level = activity.labels$V1,
                          label = activity.labels$V2,
                          ordered = F)

## Extracting mean and sd only from available variables (STEP 2)
        subsetData <-  full %>% select(Activity, Train,Subject, contains("mean."), contains("std."))


## Summarising Data per subject and activity and making column names clean
library(janitor)#used  for the  clean_names  function

## Using dplyr to group by activity then by subject and then summarising all
## columns  by taking means of respective groups
SummarisedSubset <- subsetData %>%
        group_by(Activity,Subject) %>%
        summarise(across(.col=everything(),.fns=mean)) %>% clean_names(case='small_camel')

write.table(SummarisedSubset,file = "tidydata.txt",row.names = F)


