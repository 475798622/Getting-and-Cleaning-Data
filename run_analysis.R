#1.read X_test,X_train.y_test,y_train,subject_test,subject_train,features and activity_labels text files into dataframes
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
#2.Column bind Dataframes y_test and subject_test and add column names Activity and Subject to it. ->A
A<-cbind(y_test,subject_test)
names(A)<-c("Activity","Subject")
#3. Column bind Dataframes y_train and subject_train and add column names Activity and Subject to it. ->B
B<-cbind(y_train,subject_train)
names(B)<-c("Activity","Subject")
#4. Merge A and B (dim-10299*2) ->C
C<-rbind(A,B)
#5. Merge X_test and X_train data -> D (dim-10299*561)
D<-rbind(X_test,X_train)
#6. Change column names of D from features.txt
names(D)<-paste(features[,2], features[,1], sep="_")
#7. Eliminate columns from D which do not have "mean()" or "std()" in the column names. ->E (dim-10299*66)
library("dplyr")
E1<-select(D, matches(".*[Mm]ean\\(.*"))
E2<-select(D, matches(".*[Ss][Tt][Dd]\\(.*"))
E<-cbind(E1,E2)
#8. Column bind C and E (dim-10299*68)
F<-cbind(C,E)
#9. Take mean of observations per activity per subject. (dim-180*68). 
G<-aggregate(F,by=list(F$Activity,F$Subject),FUN=mean)
Finaldata<-G[,-c(1:2)]
#10. Replace activity numbers with Activity names from activity_lables.txt-> Final Table
for (i in 1:nrow(Finaldata)) { 
        if(Finaldata[i,1]==1) Finaldata[i,1] <- "WALKING"
        if(Finaldata[i,1]==2) Finaldata[i,1] <- "WALKING_UPSTAIRS"
        if(Finaldata[i,1]==3) Finaldata[i,1] <- "WALKING_DOWNSTAIRS"
        if(Finaldata[i,1]==4) Finaldata[i,1] <- "SITTING"
        if(Finaldata[i,1]==5) Finaldata[i,1] <- "STANDING"
        if(Finaldata[i,1]==6) Finaldata[i,1] <- "LAYING"
}
write.table(Finaldata,"Finaldata.txt",row.name=FALSE)
