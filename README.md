### Final Assignment QUIZ 4

This readme  accompanies and  clarifies an already annotated  run_analsysis .R  file. 

In order to comfortabley do this  assingment  I had to depart from the provided  step order 
with an  identical final result. 

I created a  Step 0 - 
This  focuses on reading in the  data
It seems the data is in 4 seperate files that had to be smashed together somehow. 
4 seperate files for each of the train and test data sets. 
I had to duplicate the process for train and test datasets  then merge them. I imagine
there will be a simple way of  lapplying or forlooping this but for sake of simplicity 
and clarity i seperated the 2. 

Hear is an explanation the variables i read in and how i labelled them: 

**Activity.labels** - This a reference  used later to replace numbers with their corresponding activities.(1=Walking ...etc)

**feature.names** - This is a reference used later to replace V1..etc with a meaningful corresponding variable names. Variables
are essentially measurement from different sensors. 

**test.x** and **train.x** are the  actual measurements - not yet labelled by corresponding  subjects and activities
**train**/**test** **.act.code** & **train**/**test** **.subject.code** where used to labell the  previous mentioned test.x and train.x 
with subjects and  activities.


essentially by binding **train.x** + **train.act.code** + **train.subject.code** columnwise and  then repeating for the  test dataset i got 2  datasets 





###### **STEP 1 - merge Train and Test Datasets**
which i then joined  by row to form the  **full** dataset

###### **STEP 3&4 -**
###### **-Appropriately Name data set columns with meaningful names(instead of  V1..etc) &**
###### **-Use descriptive activity names to name the activities in the data set (1=Walking .. etc)**
This  step made more sense to add this stage since i will be suing those to extraxt  specific columns
I did this by using the the provided  feature names and acivity labels.


###### **STEP 2 Extracting only the measurements on the mean and standard deviation for each measurement.**
For this i used **dplyr** *select* function with the  *contains()*  option to select only  variables(columns) which contain
'mean' or 'std' and assigned  it to **SubsetData**

In **SubsetData** - each row is a seperate set of  measurments of  a subject  during an activity . It seems there is  more than one set of measurement for each subject during each activity which is  why it makes sense to summarise in the next  step using the  mean function.(**Tidy  Dataset!**)

###### **STEP 5**
Again Used  **Dplyr** to group  the  data set by Activity then by Subject to Summarise the  different repeated measurements to get
their corresponding means. This  was  done using the *summarize* functions using the *across*  option.
Finally - USed **Janitor**  *clean_names* to clean up  the variable names. Which will be further  explained in the codebook .rmd file.





