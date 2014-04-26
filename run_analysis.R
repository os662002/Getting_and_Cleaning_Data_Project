# Downloading and extracting data

setwd("E:/Olivier/Getting and Cleaning Data/assessment")

dir.create("./Data")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setInternet2(use = TRUE)
download.file(fileUrl,destfile="./Data/getdata_projectfiles_UCI HAR Dataset.zip")

unzip("./Data/getdata_projectfiles_UCI HAR Dataset.zip",
      exdir="./Data")

# Merging train and test data
liste_features<-read.table("./Data/UCI HAR Dataset/features.txt",sep=" ")
nfeatures<-nrow(liste_features)
# Treatment of training data
list.files("./Data/UCI HAR Dataset/train")
# List of activity names
activity_names<-read.table("./Data/UCI HAR Dataset/activity_labels.txt")
names(activity_names)<-c("activity_id","ACTIVITY_name")
#activity_vector<-activity_names[activity_names[,1],2]
# Training data set
train_set<-read.table("./Data/UCI HAR Dataset/train/X_train.txt")
train_labels<-read.table("./Data/UCI HAR Dataset/train/Y_train.txt")
train_subject<-read.table("./Data/UCI HAR Dataset/train/subject_train.txt")
train_total_acc_x_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
train_total_acc_y_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
train_total_acc_z_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
train_body_acc_x_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
train_body_acc_y_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
train_body_acc_z_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
train_gyro_acc_x_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
train_gyro_acc_y_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
train_gyro_acc_z_train<-read.table("./Data/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")

# Treatment of test data
list.files("./Data/UCI HAR Dataset/test")
test_set<-read.table("./Data/UCI HAR Dataset/test/X_test.txt")
test_labels<-read.table("./Data/UCI HAR Dataset/test/Y_test.txt")
test_subject<-read.table("./Data/UCI HAR Dataset/test/subject_test.txt")
test_total_acc_x_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
test_total_acc_y_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
test_total_acc_z_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")
test_body_acc_x_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
test_body_acc_y_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
test_body_acc_z_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
test_body_gyro_x_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
test_body_gyro_y_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
test_body_gyro_z_train<-read.table("./Data/UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")

# adding subject column to train/test set
train_set$activity<-train_labels[,1]
train_set$subject<-train_subject[,1]
names(train_set$activity)<-"activity"
names(train_set$subject)<-"subject"
test_set$activity<-test_labels[,1]
test_set$subject<-test_subject[,1]
names(test_set$subject)<-"subject"

# adding column names to the 2 data sets using feature list
names(train_set)[1:nfeatures]<-as.character(liste_features[,2])
names(test_set)[1:nfeatures]<-as.character(liste_features[,2])

# Merge the 2 data sets
data_set<-rbind(train_set,test_set)

# Conversion of names to upper case
names(data_set)<-toupper(names(data_set))
# Extraction of variable means.
index_newnames<-grep("MEAN|STD",names(data_set))
index_activity<-which(names(data_set)=="ACTIVITY")
index_subject<-which(names(data_set)=="SUBJECT")
newdata_set<-data_set[,c(index_newnames,index_activity,index_subject)]
# merging activity names table with data set
mergedData_set <- merge(newdata_set,activity_names,by.x="ACTIVITY",by.y="activity_id",all=TRUE)
# changing order of columns
index_activity<-which(names(mergedData_set)=="ACTIVITY")
index_activity_name<-which(names(mergedData_set)=="ACTIVITY_name")
index_subject<-which(names(mergedData_set)=="SUBJECT")
mergedData_set <- mergedData_set[c(2:87,index_subject,index_activity,index_activity_name)]
names(mergedData_set)

# mean variables
class(mergedData_set$ACTIVITY_name)
class(mergedData_set$SUBJECT)
s<-split(mergedData_set[,1:86],list(mergedData_set$ACTIVITY_name,mergedData_set$SUBJECT),drop=TRUE)
AVEmergedData_set<-as.data.frame(sapply(s,function(x) colMeans(x[,1:86],na.rm=TRUE)))
tAVEmergedData_set<-t(AVEmergedData_set)
tAVEmergedData_set<-as.data.frame(tAVEmergedData_set)
# reconstruction of subject and actvity name
ACT_SUB<-strsplit(rownames(tAVEmergedData_set),"\\.")
SUBJECT<-NULL
for (i in 1:length(ACT_SUB)) {
  SUBJECT[i]<-as.numeric(ACT_SUB[[i]][2])
}
ACTIVITY_name<-NULL
for (i in 1:length(ACT_SUB)) {
  ACTIVITY_name[i]<-ACT_SUB[[i]][1]
}
tAVEmergedData_set$SUBJECT<-SUBJECT
tAVEmergedData_set$ACTIVITY_name<-ACTIVITY_name
write.table(tAVEmergedData_set,file="tidy_data_set.txt",sep=",")

