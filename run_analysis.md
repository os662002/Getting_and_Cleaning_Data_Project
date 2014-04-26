Peer assessment - Getting and cleaning data
========================================================

The **purpose** of this project is to demonstrate your **ability to collect, work with, and clean a data set**. 
The goal is to **prepare tidy data** that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. 

You will be required to submit: 
1) a tidy data set as described below,
2) a link to a Github repository with your script for performing the analysis, 
and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 

You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1. Downloading and extracting data
-----------------------------------

```r
setwd("E:/Olivier/Getting and Cleaning Data/assessment")

dir.create("./Data")
```

```
## Warning: '.\Data' already exists
```

```r

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setInternet2(use = TRUE)
download.file(fileUrl, destfile = "./Data/getdata_projectfiles_UCI HAR Dataset.zip")

unzip("./Data/getdata_projectfiles_UCI HAR Dataset.zip", exdir = "./Data")

date_download = date()
date_download
```

```
## [1] "Sun Apr 27 01:37:57 2014"
```

2. Merging train and test data
-----------------------------------
**- Reading list of features**

```r
setwd("E:/Olivier/Getting and Cleaning Data/assessment")
# Merging train and test data
liste_features <- read.table("./Data/UCI HAR Dataset/features.txt", sep = " ")
nfeatures <- nrow(liste_features)
```

**- Reading activity names**

```r
# List of activity names
setwd("E:/Olivier/Getting and Cleaning Data/assessment")
activity_names <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")
names(activity_names) <- c("activity_id", "ACTIVITY_name")
```

**- Treatment of training data**

```r
setwd("E:/Olivier/Getting and Cleaning Data/assessment")
# Treatment of training data
list.files("./Data/UCI HAR Dataset/train")
```

```
## [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"      
## [4] "y_train.txt"
```

```r
# Training data set
train_set <- read.table("./Data/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./Data/UCI HAR Dataset/train/Y_train.txt")
train_subject <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt")
train_total_acc_x_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
train_total_acc_y_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
train_total_acc_z_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
train_body_acc_x_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
train_body_acc_y_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
train_body_acc_z_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
train_gyro_acc_x_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
train_gyro_acc_y_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
train_gyro_acc_z_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
```

**- Treatment of test data**

```r
setwd("E:/Olivier/Getting and Cleaning Data/assessment")
# Treatment of test data
list.files("./Data/UCI HAR Dataset/test")
```

```
## [1] "Inertial Signals" "subject_test.txt" "X_test.txt"      
## [4] "y_test.txt"
```

```r
test_set <- read.table("./Data/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./Data/UCI HAR Dataset/test/Y_test.txt")
test_subject <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt")
test_total_acc_x_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
test_total_acc_y_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
test_total_acc_z_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")
test_body_acc_x_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
test_body_acc_y_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
test_body_acc_z_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
test_body_gyro_x_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
test_body_gyro_y_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
test_body_gyro_z_train <- read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")
```

**- adding subject and activity column to train/test set**

```r
# adding subject column to train/test set
train_set$activity <- train_labels[, 1]
train_set$subject <- train_subject[, 1]
names(train_set$activity) <- "activity"
names(train_set$subject) <- "subject"
test_set$activity <- test_labels[, 1]
test_set$subject <- test_subject[, 1]
names(test_set$subject) <- "subject"
```

**- adding column names to the 2 data sets using feature list**

```r
# adding column names to the 2 data sets using feature list
names(train_set)[1:nfeatures] <- as.character(liste_features[, 2])
names(test_set)[1:nfeatures] <- as.character(liste_features[, 2])
```

**- Merging of the 2 data sets**

```r
# Merge the 2 data sets
data_set <- rbind(train_set, test_set)
```

3. Extraction the measurements on the mean and standard deviation for each measurement. 
---------------------------------------------------------------------------------------
**- Conversion of names to upper case**

```r
# Conversion of names to upper case
names(data_set) <- toupper(names(data_set))
```

**- Extraction of variable means and std**

```r
# Extraction of variable means and std.
index_newnames <- grep("MEAN|STD", names(data_set))
index_activity <- which(names(data_set) == "ACTIVITY")
index_subject <- which(names(data_set) == "SUBJECT")
newdata_set <- data_set[, c(index_newnames, index_activity, index_subject)]
```

4. Uses descriptive activity names to name the activities in the data set 
-------------------------------------------------------------------------
**- merging activity names table with data set**

```r
# merging activity names table with data set
mergedData_set <- merge(newdata_set, activity_names, by.x = "ACTIVITY", by.y = "activity_id", 
    all = TRUE)
```

5. Appropriately labels the data set with descriptive activity names
-------------------------------------------------------------------------
**- changing order of columns**

```r
# changing order of columns
index_activity <- which(names(mergedData_set) == "ACTIVITY")
index_activity_name <- which(names(mergedData_set) == "ACTIVITY_name")
index_subject <- which(names(mergedData_set) == "SUBJECT")
mergedData_set <- mergedData_set[c(2:87, index_subject, index_activity, index_activity_name)]
names(mergedData_set)
```

```
##  [1] "TBODYACC-MEAN()-X"                   
##  [2] "TBODYACC-MEAN()-Y"                   
##  [3] "TBODYACC-MEAN()-Z"                   
##  [4] "TBODYACC-STD()-X"                    
##  [5] "TBODYACC-STD()-Y"                    
##  [6] "TBODYACC-STD()-Z"                    
##  [7] "TGRAVITYACC-MEAN()-X"                
##  [8] "TGRAVITYACC-MEAN()-Y"                
##  [9] "TGRAVITYACC-MEAN()-Z"                
## [10] "TGRAVITYACC-STD()-X"                 
## [11] "TGRAVITYACC-STD()-Y"                 
## [12] "TGRAVITYACC-STD()-Z"                 
## [13] "TBODYACCJERK-MEAN()-X"               
## [14] "TBODYACCJERK-MEAN()-Y"               
## [15] "TBODYACCJERK-MEAN()-Z"               
## [16] "TBODYACCJERK-STD()-X"                
## [17] "TBODYACCJERK-STD()-Y"                
## [18] "TBODYACCJERK-STD()-Z"                
## [19] "TBODYGYRO-MEAN()-X"                  
## [20] "TBODYGYRO-MEAN()-Y"                  
## [21] "TBODYGYRO-MEAN()-Z"                  
## [22] "TBODYGYRO-STD()-X"                   
## [23] "TBODYGYRO-STD()-Y"                   
## [24] "TBODYGYRO-STD()-Z"                   
## [25] "TBODYGYROJERK-MEAN()-X"              
## [26] "TBODYGYROJERK-MEAN()-Y"              
## [27] "TBODYGYROJERK-MEAN()-Z"              
## [28] "TBODYGYROJERK-STD()-X"               
## [29] "TBODYGYROJERK-STD()-Y"               
## [30] "TBODYGYROJERK-STD()-Z"               
## [31] "TBODYACCMAG-MEAN()"                  
## [32] "TBODYACCMAG-STD()"                   
## [33] "TGRAVITYACCMAG-MEAN()"               
## [34] "TGRAVITYACCMAG-STD()"                
## [35] "TBODYACCJERKMAG-MEAN()"              
## [36] "TBODYACCJERKMAG-STD()"               
## [37] "TBODYGYROMAG-MEAN()"                 
## [38] "TBODYGYROMAG-STD()"                  
## [39] "TBODYGYROJERKMAG-MEAN()"             
## [40] "TBODYGYROJERKMAG-STD()"              
## [41] "FBODYACC-MEAN()-X"                   
## [42] "FBODYACC-MEAN()-Y"                   
## [43] "FBODYACC-MEAN()-Z"                   
## [44] "FBODYACC-STD()-X"                    
## [45] "FBODYACC-STD()-Y"                    
## [46] "FBODYACC-STD()-Z"                    
## [47] "FBODYACC-MEANFREQ()-X"               
## [48] "FBODYACC-MEANFREQ()-Y"               
## [49] "FBODYACC-MEANFREQ()-Z"               
## [50] "FBODYACCJERK-MEAN()-X"               
## [51] "FBODYACCJERK-MEAN()-Y"               
## [52] "FBODYACCJERK-MEAN()-Z"               
## [53] "FBODYACCJERK-STD()-X"                
## [54] "FBODYACCJERK-STD()-Y"                
## [55] "FBODYACCJERK-STD()-Z"                
## [56] "FBODYACCJERK-MEANFREQ()-X"           
## [57] "FBODYACCJERK-MEANFREQ()-Y"           
## [58] "FBODYACCJERK-MEANFREQ()-Z"           
## [59] "FBODYGYRO-MEAN()-X"                  
## [60] "FBODYGYRO-MEAN()-Y"                  
## [61] "FBODYGYRO-MEAN()-Z"                  
## [62] "FBODYGYRO-STD()-X"                   
## [63] "FBODYGYRO-STD()-Y"                   
## [64] "FBODYGYRO-STD()-Z"                   
## [65] "FBODYGYRO-MEANFREQ()-X"              
## [66] "FBODYGYRO-MEANFREQ()-Y"              
## [67] "FBODYGYRO-MEANFREQ()-Z"              
## [68] "FBODYACCMAG-MEAN()"                  
## [69] "FBODYACCMAG-STD()"                   
## [70] "FBODYACCMAG-MEANFREQ()"              
## [71] "FBODYBODYACCJERKMAG-MEAN()"          
## [72] "FBODYBODYACCJERKMAG-STD()"           
## [73] "FBODYBODYACCJERKMAG-MEANFREQ()"      
## [74] "FBODYBODYGYROMAG-MEAN()"             
## [75] "FBODYBODYGYROMAG-STD()"              
## [76] "FBODYBODYGYROMAG-MEANFREQ()"         
## [77] "FBODYBODYGYROJERKMAG-MEAN()"         
## [78] "FBODYBODYGYROJERKMAG-STD()"          
## [79] "FBODYBODYGYROJERKMAG-MEANFREQ()"     
## [80] "ANGLE(TBODYACCMEAN,GRAVITY)"         
## [81] "ANGLE(TBODYACCJERKMEAN),GRAVITYMEAN)"
## [82] "ANGLE(TBODYGYROMEAN,GRAVITYMEAN)"    
## [83] "ANGLE(TBODYGYROJERKMEAN,GRAVITYMEAN)"
## [84] "ANGLE(X,GRAVITYMEAN)"                
## [85] "ANGLE(Y,GRAVITYMEAN)"                
## [86] "ANGLE(Z,GRAVITYMEAN)"                
## [87] "SUBJECT"                             
## [88] "ACTIVITY"                            
## [89] "ACTIVITY_name"
```

6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
--------------------------------------------------------------------------------------------------------------------
**- Averaging variables by activity and subject**

```r
class(mergedData_set$ACTIVITY_name)
```

```
## [1] "factor"
```

```r
class(mergedData_set$SUBJECT)
```

```
## [1] "integer"
```

```r
# Splitting of the dataframe with Activity name and subject
s <- split(mergedData_set[, 1:86], list(mergedData_set$ACTIVITY_name, mergedData_set$SUBJECT), 
    drop = TRUE)
# sapply to the resulting list and converison to dataframe
AVEmergedData_set <- as.data.frame(sapply(s, function(x) colMeans(x[, 1:86], 
    na.rm = TRUE)))
tAVEmergedData_set <- t(AVEmergedData_set)
tAVEmergedData_set <- as.data.frame(tAVEmergedData_set)
# reformatting of subject and actvity name in the dataframe based on row
# names
ACT_SUB <- strsplit(rownames(tAVEmergedData_set), "\\.")
SUBJECT <- NULL
for (i in 1:length(ACT_SUB)) {
    SUBJECT[i] <- as.numeric(ACT_SUB[[i]][2])
}
ACTIVITY_name <- NULL
for (i in 1:length(ACT_SUB)) {
    ACTIVITY_name[i] <- ACT_SUB[[i]][1]
}
tAVEmergedData_set$SUBJECT <- SUBJECT
tAVEmergedData_set$ACTIVITY_name <- ACTIVITY_name
head(tAVEmergedData_set)
```

```
##                      TBODYACC-MEAN()-X TBODYACC-MEAN()-Y TBODYACC-MEAN()-Z
## LAYING.1                        0.2216         -0.040514           -0.1132
## SITTING.1                       0.2612         -0.001308           -0.1045
## STANDING.1                      0.2789         -0.016138           -0.1106
## WALKING.1                       0.2773         -0.017384           -0.1111
## WALKING_DOWNSTAIRS.1            0.2892         -0.009919           -0.1076
## WALKING_UPSTAIRS.1              0.2555         -0.023953           -0.0973
##                      TBODYACC-STD()-X TBODYACC-STD()-Y TBODYACC-STD()-Z
## LAYING.1                     -0.92806         -0.83683         -0.82606
## SITTING.1                    -0.97723         -0.92262         -0.93959
## STANDING.1                   -0.99576         -0.97319         -0.97978
## WALKING.1                    -0.28374          0.11446         -0.26003
## WALKING_DOWNSTAIRS.1          0.03004         -0.03194         -0.23043
## WALKING_UPSTAIRS.1           -0.35471         -0.00232         -0.01948
##                      TGRAVITYACC-MEAN()-X TGRAVITYACC-MEAN()-Y
## LAYING.1                          -0.2489               0.7055
## SITTING.1                          0.8315               0.2044
## STANDING.1                         0.9430              -0.2730
## WALKING.1                          0.9352              -0.2822
## WALKING_DOWNSTAIRS.1               0.9319              -0.2666
## WALKING_UPSTAIRS.1                 0.8934              -0.3622
##                      TGRAVITYACC-MEAN()-Z TGRAVITYACC-STD()-X
## LAYING.1                          0.44582             -0.8968
## SITTING.1                         0.33204             -0.9685
## STANDING.1                        0.01349             -0.9938
## WALKING.1                        -0.06810             -0.9766
## WALKING_DOWNSTAIRS.1             -0.06212             -0.9506
## WALKING_UPSTAIRS.1               -0.07540             -0.9564
##                      TGRAVITYACC-STD()-Y TGRAVITYACC-STD()-Z
## LAYING.1                         -0.9077             -0.8524
## SITTING.1                        -0.9355             -0.9490
## STANDING.1                       -0.9812             -0.9763
## WALKING.1                        -0.9713             -0.9477
## WALKING_DOWNSTAIRS.1             -0.9370             -0.8959
## WALKING_UPSTAIRS.1               -0.9528             -0.9124
##                      TBODYACCJERK-MEAN()-X TBODYACCJERK-MEAN()-Y
## LAYING.1                           0.08109             0.0038382
## SITTING.1                          0.07748            -0.0006191
## STANDING.1                         0.07538             0.0079757
## WALKING.1                          0.07404             0.0282721
## WALKING_DOWNSTAIRS.1               0.05416             0.0296504
## WALKING_UPSTAIRS.1                 0.10137             0.0194863
##                      TBODYACCJERK-MEAN()-Z TBODYACCJERK-STD()-X
## LAYING.1                          0.010834             -0.95848
## SITTING.1                        -0.003368             -0.98643
## STANDING.1                       -0.003685             -0.99460
## WALKING.1                        -0.004168             -0.11362
## WALKING_DOWNSTAIRS.1             -0.010972             -0.01228
## WALKING_UPSTAIRS.1               -0.045563             -0.44684
##                      TBODYACCJERK-STD()-Y TBODYACCJERK-STD()-Z
## LAYING.1                          -0.9241              -0.9549
## SITTING.1                         -0.9814              -0.9879
## STANDING.1                        -0.9856              -0.9923
## WALKING.1                          0.0670              -0.5027
## WALKING_DOWNSTAIRS.1              -0.1016              -0.3457
## WALKING_UPSTAIRS.1                -0.3783              -0.7066
##                      TBODYGYRO-MEAN()-X TBODYGYRO-MEAN()-Y
## LAYING.1                       -0.01655           -0.06449
## SITTING.1                      -0.04535           -0.09192
## STANDING.1                     -0.02399           -0.05940
## WALKING.1                      -0.04183           -0.06953
## WALKING_DOWNSTAIRS.1           -0.03508           -0.09094
## WALKING_UPSTAIRS.1              0.05055           -0.16617
##                      TBODYGYRO-MEAN()-Z TBODYGYRO-STD()-X
## LAYING.1                        0.14869           -0.8735
## SITTING.1                       0.06293           -0.9772
## STANDING.1                      0.07480           -0.9872
## WALKING.1                       0.08494           -0.4735
## WALKING_DOWNSTAIRS.1            0.09009           -0.4580
## WALKING_UPSTAIRS.1              0.05836           -0.5449
##                      TBODYGYRO-STD()-Y TBODYGYRO-STD()-Z
## LAYING.1                     -0.951090           -0.9083
## SITTING.1                    -0.966474           -0.9414
## STANDING.1                   -0.987734           -0.9806
## WALKING.1                    -0.054608           -0.3443
## WALKING_DOWNSTAIRS.1         -0.126349           -0.1247
## WALKING_UPSTAIRS.1            0.004105           -0.5072
##                      TBODYGYROJERK-MEAN()-X TBODYGYROJERK-MEAN()-Y
## LAYING.1                           -0.10727               -0.04152
## SITTING.1                          -0.09368               -0.04021
## STANDING.1                         -0.09961               -0.04406
## WALKING.1                          -0.09000               -0.03984
## WALKING_DOWNSTAIRS.1               -0.07396               -0.04399
## WALKING_UPSTAIRS.1                 -0.12223               -0.04215
##                      TBODYGYROJERK-MEAN()-Z TBODYGYROJERK-STD()-X
## LAYING.1                           -0.07405               -0.9186
## SITTING.1                          -0.04670               -0.9917
## STANDING.1                         -0.04895               -0.9929
## WALKING.1                          -0.04613               -0.2074
## WALKING_DOWNSTAIRS.1               -0.02705               -0.4870
## WALKING_UPSTAIRS.1                 -0.04071               -0.6148
##                      TBODYGYROJERK-STD()-Y TBODYGYROJERK-STD()-Z
## LAYING.1                           -0.9679               -0.9578
## SITTING.1                          -0.9895               -0.9879
## STANDING.1                         -0.9951               -0.9921
## WALKING.1                          -0.3045               -0.4043
## WALKING_DOWNSTAIRS.1               -0.2388               -0.2688
## WALKING_UPSTAIRS.1                 -0.6017               -0.6063
##                      TBODYACCMAG-MEAN() TBODYACCMAG-STD()
## LAYING.1                       -0.84193          -0.79514
## SITTING.1                      -0.94854          -0.92708
## STANDING.1                     -0.98428          -0.98194
## WALKING.1                      -0.13697          -0.21969
## WALKING_DOWNSTAIRS.1            0.02719           0.01988
## WALKING_UPSTAIRS.1             -0.12993          -0.32497
##                      TGRAVITYACCMAG-MEAN() TGRAVITYACCMAG-STD()
## LAYING.1                          -0.84193             -0.79514
## SITTING.1                         -0.94854             -0.92708
## STANDING.1                        -0.98428             -0.98194
## WALKING.1                         -0.13697             -0.21969
## WALKING_DOWNSTAIRS.1               0.02719              0.01988
## WALKING_UPSTAIRS.1                -0.12993             -0.32497
##                      TBODYACCJERKMAG-MEAN() TBODYACCJERKMAG-STD()
## LAYING.1                           -0.95440              -0.92825
## SITTING.1                          -0.98736              -0.98412
## STANDING.1                         -0.99237              -0.99310
## WALKING.1                          -0.14143              -0.07447
## WALKING_DOWNSTAIRS.1               -0.08945              -0.02579
## WALKING_UPSTAIRS.1                 -0.46650              -0.47899
##                      TBODYGYROMAG-MEAN() TBODYGYROMAG-STD()
## LAYING.1                        -0.87476            -0.8190
## SITTING.1                       -0.93089            -0.9345
## STANDING.1                      -0.97649            -0.9787
## WALKING.1                       -0.16098            -0.1870
## WALKING_DOWNSTAIRS.1            -0.07574            -0.2257
## WALKING_UPSTAIRS.1              -0.12674            -0.1486
##                      TBODYGYROJERKMAG-MEAN() TBODYGYROJERKMAG-STD()
## LAYING.1                             -0.9635                -0.9358
## SITTING.1                            -0.9920                -0.9883
## STANDING.1                           -0.9950                -0.9947
## WALKING.1                            -0.2987                -0.3253
## WALKING_DOWNSTAIRS.1                 -0.2955                -0.3065
## WALKING_UPSTAIRS.1                   -0.5949                -0.6486
##                      FBODYACC-MEAN()-X FBODYACC-MEAN()-Y FBODYACC-MEAN()-Z
## LAYING.1                      -0.93910          -0.86707           -0.8827
## SITTING.1                     -0.97964          -0.94408           -0.9592
## STANDING.1                    -0.99525          -0.97707           -0.9853
## WALKING.1                     -0.20279           0.08971           -0.3316
## WALKING_DOWNSTAIRS.1           0.03823           0.00155           -0.2256
## WALKING_UPSTAIRS.1            -0.40432          -0.19098           -0.4333
##                      FBODYACC-STD()-X FBODYACC-STD()-Y FBODYACC-STD()-Z
## LAYING.1                     -0.92444         -0.83363         -0.81289
## SITTING.1                    -0.97641         -0.91728         -0.93447
## STANDING.1                   -0.99603         -0.97229         -0.97794
## WALKING.1                    -0.31913          0.05604         -0.27969
## WALKING_DOWNSTAIRS.1          0.02433         -0.11296         -0.29793
## WALKING_UPSTAIRS.1           -0.33743          0.02177          0.08596
##                      FBODYACC-MEANFREQ()-X FBODYACC-MEANFREQ()-Y
## LAYING.1                          -0.15879               0.09753
## SITTING.1                         -0.04951               0.07595
## STANDING.1                         0.08652               0.11748
## WALKING.1                         -0.20755               0.11309
## WALKING_DOWNSTAIRS.1              -0.30740               0.06322
## WALKING_UPSTAIRS.1                -0.41874              -0.16070
##                      FBODYACC-MEANFREQ()-Z FBODYACCJERK-MEAN()-X
## LAYING.1                           0.08944              -0.95707
## SITTING.1                          0.23883              -0.98660
## STANDING.1                         0.24486              -0.99463
## WALKING.1                          0.04973              -0.17055
## WALKING_DOWNSTAIRS.1               0.29432              -0.02766
## WALKING_UPSTAIRS.1                -0.52011              -0.47988
##                      FBODYACCJERK-MEAN()-Y FBODYACCJERK-MEAN()-Z
## LAYING.1                          -0.92246               -0.9481
## SITTING.1                         -0.98158               -0.9861
## STANDING.1                        -0.98542               -0.9908
## WALKING.1                         -0.03523               -0.4690
## WALKING_DOWNSTAIRS.1              -0.12867               -0.2883
## WALKING_UPSTAIRS.1                -0.41344               -0.6855
##                      FBODYACCJERK-STD()-X FBODYACCJERK-STD()-Y
## LAYING.1                         -0.96416              -0.9322
## SITTING.1                        -0.98749              -0.9825
## STANDING.1                       -0.99507              -0.9870
## WALKING.1                        -0.13359               0.1067
## WALKING_DOWNSTAIRS.1             -0.08633              -0.1346
## WALKING_UPSTAIRS.1               -0.46191              -0.3818
##                      FBODYACCJERK-STD()-Z FBODYACCJERK-MEANFREQ()-X
## LAYING.1                          -0.9606                    0.1324
## SITTING.1                         -0.9883                    0.2566
## STANDING.1                        -0.9923                    0.3142
## WALKING.1                         -0.5347                   -0.2093
## WALKING_DOWNSTAIRS.1              -0.4017                   -0.2532
## WALKING_UPSTAIRS.1                -0.7260                   -0.3770
##                      FBODYACCJERK-MEANFREQ()-Y FBODYACCJERK-MEANFREQ()-Z
## LAYING.1                               0.02451                  0.024388
## SITTING.1                              0.04754                  0.092392
## STANDING.1                             0.03916                  0.138581
## WALKING.1                             -0.38624                 -0.185530
## WALKING_DOWNSTAIRS.1                  -0.33759                  0.009372
## WALKING_UPSTAIRS.1                    -0.50950                 -0.551104
##                      FBODYGYRO-MEAN()-X FBODYGYRO-MEAN()-Y
## LAYING.1                        -0.8502            -0.9522
## SITTING.1                       -0.9762            -0.9758
## STANDING.1                      -0.9864            -0.9890
## WALKING.1                       -0.3390            -0.1031
## WALKING_DOWNSTAIRS.1            -0.3524            -0.0557
## WALKING_UPSTAIRS.1              -0.4926            -0.3195
##                      FBODYGYRO-MEAN()-Z FBODYGYRO-STD()-X
## LAYING.1                       -0.90930           -0.8823
## SITTING.1                      -0.95132           -0.9779
## STANDING.1                     -0.98077           -0.9875
## WALKING.1                      -0.25594           -0.5167
## WALKING_DOWNSTAIRS.1           -0.03187           -0.4954
## WALKING_UPSTAIRS.1             -0.45360           -0.5659
##                      FBODYGYRO-STD()-Y FBODYGYRO-STD()-Z
## LAYING.1                      -0.95123           -0.9166
## SITTING.1                     -0.96235           -0.9439
## STANDING.1                    -0.98711           -0.9823
## WALKING.1                     -0.03351           -0.4366
## WALKING_DOWNSTAIRS.1          -0.18141           -0.2384
## WALKING_UPSTAIRS.1             0.15154           -0.5717
##                      FBODYGYRO-MEANFREQ()-X FBODYGYRO-MEANFREQ()-Y
## LAYING.1                          -0.003547               -0.09153
## SITTING.1                          0.189153                0.06313
## STANDING.1                        -0.120293               -0.04472
## WALKING.1                          0.014784               -0.06577
## WALKING_DOWNSTAIRS.1              -0.100454                0.08255
## WALKING_UPSTAIRS.1                -0.187450               -0.47357
##                      FBODYGYRO-MEANFREQ()-Z FBODYACCMAG-MEAN()
## LAYING.1                          0.0104581           -0.86177
## SITTING.1                        -0.0297839           -0.94778
## STANDING.1                        0.1006076           -0.98536
## WALKING.1                         0.0007733           -0.12862
## WALKING_DOWNSTAIRS.1             -0.0756762            0.09658
## WALKING_UPSTAIRS.1               -0.1333739           -0.35240
##                      FBODYACCMAG-STD() FBODYACCMAG-MEANFREQ()
## LAYING.1                       -0.7983                0.08641
## SITTING.1                      -0.9284                0.23666
## STANDING.1                     -0.9823                0.28456
## WALKING.1                      -0.3980                0.19064
## WALKING_DOWNSTAIRS.1           -0.1865                0.11919
## WALKING_UPSTAIRS.1             -0.4163               -0.09774
##                      FBODYBODYACCJERKMAG-MEAN() FBODYBODYACCJERKMAG-STD()
## LAYING.1                               -0.93330                   -0.9218
## SITTING.1                              -0.98526                   -0.9816
## STANDING.1                             -0.99254                   -0.9925
## WALKING.1                              -0.05712                   -0.1035
## WALKING_DOWNSTAIRS.1                    0.02622                   -0.1041
## WALKING_UPSTAIRS.1                     -0.44265                   -0.5331
##                      FBODYBODYACCJERKMAG-MEANFREQ()
## LAYING.1                                    0.26639
## SITTING.1                                   0.35185
## STANDING.1                                  0.42222
## WALKING.1                                   0.09382
## WALKING_DOWNSTAIRS.1                        0.07649
## WALKING_UPSTAIRS.1                          0.08535
##                      FBODYBODYGYROMAG-MEAN() FBODYBODYGYROMAG-STD()
## LAYING.1                             -0.8622                -0.8243
## SITTING.1                            -0.9584                -0.9322
## STANDING.1                           -0.9846                -0.9785
## WALKING.1                            -0.1993                -0.3210
## WALKING_DOWNSTAIRS.1                 -0.1857                -0.3984
## WALKING_UPSTAIRS.1                   -0.3260                -0.1830
##                      FBODYBODYGYROMAG-MEANFREQ()
## LAYING.1                              -0.1397750
## SITTING.1                             -0.0002622
## STANDING.1                            -0.0286058
## WALKING.1                              0.2688444
## WALKING_DOWNSTAIRS.1                   0.3496139
## WALKING_UPSTAIRS.1                    -0.2193034
##                      FBODYBODYGYROJERKMAG-MEAN()
## LAYING.1                                 -0.9424
## SITTING.1                                -0.9898
## STANDING.1                               -0.9948
## WALKING.1                                -0.3193
## WALKING_DOWNSTAIRS.1                     -0.2820
## WALKING_UPSTAIRS.1                       -0.6347
##                      FBODYBODYGYROJERKMAG-STD()
## LAYING.1                                -0.9327
## SITTING.1                               -0.9870
## STANDING.1                              -0.9947
## WALKING.1                               -0.3816
## WALKING_DOWNSTAIRS.1                    -0.3919
## WALKING_UPSTAIRS.1                      -0.6939
##                      FBODYBODYGYROJERKMAG-MEANFREQ()
## LAYING.1                                      0.1765
## SITTING.1                                     0.1848
## STANDING.1                                    0.3345
## WALKING.1                                     0.1907
## WALKING_DOWNSTAIRS.1                          0.1900
## WALKING_UPSTAIRS.1                            0.1143
##                      ANGLE(TBODYACCMEAN,GRAVITY)
## LAYING.1                               0.0213660
## SITTING.1                              0.0274415
## STANDING.1                            -0.0002223
## WALKING.1                              0.0604537
## WALKING_DOWNSTAIRS.1                  -0.0026951
## WALKING_UPSTAIRS.1                     0.0960861
##                      ANGLE(TBODYACCJERKMEAN),GRAVITYMEAN)
## LAYING.1                                          0.00306
## SITTING.1                                         0.02971
## STANDING.1                                        0.02196
## WALKING.1                                        -0.00793
## WALKING_DOWNSTAIRS.1                              0.08993
## WALKING_UPSTAIRS.1                               -0.06108
##                      ANGLE(TBODYGYROMEAN,GRAVITYMEAN)
## LAYING.1                                    -0.001667
## SITTING.1                                    0.067698
## STANDING.1                                  -0.033794
## WALKING.1                                    0.013059
## WALKING_DOWNSTAIRS.1                         0.063338
## WALKING_UPSTAIRS.1                          -0.194700
##                      ANGLE(TBODYGYROJERKMEAN,GRAVITYMEAN)
## LAYING.1                                          0.08444
## SITTING.1                                        -0.06488
## STANDING.1                                       -0.02792
## WALKING.1                                        -0.01874
## WALKING_DOWNSTAIRS.1                             -0.03998
## WALKING_UPSTAIRS.1                                0.06568
##                      ANGLE(X,GRAVITYMEAN) ANGLE(Y,GRAVITYMEAN)
## LAYING.1                           0.4267             -0.52034
## SITTING.1                         -0.5912             -0.06047
## STANDING.1                        -0.7434              0.27018
## WALKING.1                         -0.7292              0.27695
## WALKING_DOWNSTAIRS.1              -0.7445              0.26725
## WALKING_UPSTAIRS.1                -0.6472              0.33476
##                      ANGLE(Z,GRAVITYMEAN) SUBJECT      ACTIVITY_name
## LAYING.1                         -0.35241       1             LAYING
## SITTING.1                        -0.21802       1            SITTING
## STANDING.1                        0.01225       1           STANDING
## WALKING.1                         0.06886       1            WALKING
## WALKING_DOWNSTAIRS.1              0.06500       1 WALKING_DOWNSTAIRS
## WALKING_UPSTAIRS.1                0.07417       1   WALKING_UPSTAIRS
```

