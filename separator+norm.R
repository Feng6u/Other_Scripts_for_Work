rm(list = ls())
library(dplyr)

options(scipen=999) #turn off scientific notation in the output

FEOBV <- read.csv("~/Documents/CRANI/CANTAB/Data_raw/RowBySession_The cholinergic system and cognition .csv", header=FALSE, stringsAsFactors=FALSE)
CBRE <- read.csv("~/Documents/CRANI/CANTAB/Data_raw/RowBySession_CBRE study.csv", header=FALSE, stringsAsFactors=FALSE)
COGREHAB <- read.csv("~/Documents/CRANI/CANTAB/Data_raw/RowBySession_CogRehab.csv", header=FALSE, stringsAsFactors=FALSE)
VR_PHASE1 <- read.csv("~/Documents/CRANI/CANTAB/Data_raw/RowBySession_VR-Phase One.csv", header=FALSE, stringsAsFactors=FALSE)

row1_FEOBV<- FEOBV[1,]
#row1_CBRE<- CBRE[1,]
row1_COGREHAB<- COGREHAB[1,]

CBRE <- subset(CBRE,substr(CBRE[,5],1,1)=="C"|substr(CBRE[,5],1,1)=="N"|substr(CBRE[,5],1,1)== 1 |substr(CBRE[,5],1,1)==2)

control_FEOBV <- bind_rows(row1_FEOBV,subset(FEOBV,substr(FEOBV[,5],6,6)== 0))
patient_FEOBV <- bind_rows(row1_FEOBV,subset(FEOBV,substr(FEOBV[,5],6,6)== 5))

control_CBRE <- bind_rows(row1_CBRE,subset(CBRE,substr(CBRE[,5],1,1)== "N"|substr(CBRE[,5],1,1) == 2))
patient_CBRE <- bind_rows(row1_CBRE,subset(CBRE,substr(CBRE[,5],1,1)== "C"|substr(CBRE[,5],1,1) == 1))

control_COGREHAB <- bind_rows(row1_COGREHAB,subset(COGREHAB,substr(COGREHAB[,5],3,3) == 0))
SZ_COGREHAB <- bind_rows(row1_COGREHAB,subset(COGREHAB,substr(COGREHAB[,5],3,3) == 1))
MDD_COGREHAB <- bind_rows(row1_COGREHAB,subset(COGREHAB,substr(COGREHAB[,5],3,3) == 2)) 


write.table(control_FEOBV,file = "~/Documents/CRANI/CANTAB/Controls/FEOBV_controls.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(patient_FEOBV,file = "~/Documents/CRANI/CANTAB/Patients/FEOBV_patients.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(control_CBRE,file = "~/Documents/CRANI/CANTAB/Controls/CBRE_controls.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(patient_CBRE,file = "~/Documents/CRANI/CANTAB/Patients/CBRE_patients.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(control_COGREHAB,file = "~/Documents/CRANI/CANTAB/Controls/COGREHAB_controls.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(SZ_COGREHAB,file = "~/Documents/CRANI/CANTAB/Patients/COGREHAB_SZ.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(MDD_COGREHAB,file = "~/Documents/CRANI/CANTAB/Patients/COGREHAB_MDD.csv",sep = ",",row.names = FALSE,col.names = FALSE)
write.table(VR_PHASE1,file = "~/Documents/CRANI/CANTAB/Patients/VR_PHASE1_patients.csv",sep = ",",row.names = FALSE,col.names = FALSE)


#make a list of data files that are needed for calculating norms. These lines of code 
#will import all the .csv files stored in each folder into R for computation. 
###IMPORTANT: Make sure to change the paths of the directories where the CANTAB data for healthy 
#control and patients are stored.
###IMPORTANT: Also make sure there are no other .csv files in that folder. 
controls <- lapply(Sys.glob("~/Documents/CRANI/CANTAB/Controls/*.csv"),read.csv) #for controls
patients <- lapply(Sys.glob("~/Documents/CRANI/CANTAB/Patients/*.csv"),read.csv) #for patients




#Make a loop in each list to pull out the relavant 37 variables in each data file

#Some measures are reversed by adding a "-" to the varialbe name, so that a higher score always
#indicates better performance. 

#controls
for (i in 1:length(controls)){
  colnames(controls[[i]])[5] <- "subject.ID"
  controls[[i]]$subject.ID <- as.character(controls[[i]]$subject.ID)
  attach(controls[[i]])
  controls[[i]] <- data.frame(subject.ID,-RTIFMDRT,-RTIFMDMT,VRMFRDS,VRMIRTC,VRMDRTC,SOCPSMMT,-SOCMNM5,-SOCITMD5,-SOCSTMD5,RVPA,-RVPPFA,-RVPMDL,-MTTTIC,-MTTLMD,-MTTICMD,-MTTMTCMD,-SWMBE,-SWMS,-SWMBE4,-SWMBE6,-SWMBE8,-PALTEA,PALFAMS,-ERTOMDRT,ERTTH,ERTUHRH,ERTUHRS,ERTUHRF,ERTUHRA,ERTUHRSU,ERTUHRD,DMSPCAD,DMSPCS,DMSPC0,DMSPC4,DMSPC12,-DMSPEGE)
  detach(controls[[i]])
}

#patients
for (i in 1:length(patients)){
  colnames(patients[[i]])[5] <- "subject.ID"
  patients[[i]]$subject.ID <- as.character(patients[[i]]$subject.ID)
  attach(patients[[i]])
  patients[[i]] <- data.frame(subject.ID,-RTIFMDRT,-RTIFMDMT,VRMFRDS,VRMIRTC,VRMDRTC,SOCPSMMT,-SOCMNM5,-SOCITMD5,-SOCSTMD5,RVPA,-RVPPFA,-RVPMDL,-MTTTIC,-MTTLMD,-MTTICMD,-MTTMTCMD,-SWMBE,-SWMS,-SWMBE4,-SWMBE6,-SWMBE8,-PALTEA,PALFAMS,-ERTOMDRT,ERTTH,ERTUHRH,ERTUHRS,ERTUHRF,ERTUHRA,ERTUHRSU,ERTUHRD,DMSPCAD,DMSPCS,DMSPC0,DMSPC4,DMSPC12,-DMSPEGE)
  detach(patients[[i]])
}




#combine the newly created data files vertically into one data frame for controls 
#and another one for patients
controls <- bind_rows(controls)
patients <- bind_rows(patients)



#swap row numbers with participant ID's for each participant in the data frames
row.names(controls) <- controls[,1]
row.names(patients) <- patients[,1]



#remove the first column (the original column containing participant ID's)
controls[,1] <- NULL
patients[,1] <- NULL






################################# For N/A analysis ########################################
#count the number of NA's in each variable (to see how many missing data points there are
#in each variable)
colSums(is.na(controls)) #for healthy controls
colSums(is.na(patients)) #for patients


#print a table where there are NA values in the row or column (to see missing data points
#printed with participant ID)
print(controls[rowSums(is.na(controls)) > 0, colSums(is.na(controls)) > 0]) #for healthy controls
print(patients[rowSums(is.na(patients)) > 0, colSums(is.na(patients)) > 0]) #for patients







############################################ norm calculation ################################

#computes the means of healthy controls (results in one row of data)
mean_controls <- data.frame(t(data.frame(sapply(controls, mean, na.rm = T))))

#duplicate the row of data into a dataframe with the dimensions of patients' dataframe so that
#the two dataframes can be subtracted in the next step
mean_controls_rep <- mean_controls[rep(seq_len(nrow(mean_controls)), each=nrow(patients)),]

#duplicate the row of data into a dataframe with the dimensions of controls' dataframe so that
#the two dataframes can be subtracted in the next step
mean_controls_rep2 <- mean_controls[rep(seq_len(nrow(mean_controls)), each=nrow(controls)),]





#computes the standard deviations of healthy controls (results in one row of data)
sd_controls <- data.frame(t(data.frame(sapply(controls, sd, na.rm = T))))

#duplicate the row of data into a dataframe with the dimensions of patients' dataframe so that
#the two dataframes can be divided in the next step
sd_controls_rep <- sd_controls[rep(seq_len(nrow(sd_controls)), each=nrow(patients)),]

#duplicate the row of data into a dataframe with the dimensions of controls' dataframe so that
#the two dataframes can be divided in the next step
sd_controls_rep2 <- sd_controls[rep(seq_len(nrow(sd_controls)), each=nrow(controls)),]





#a table of z-scores for each data point of each patient (patients' data subtracting from
#controls' means and then dividing by controls' standard deviations)
z_patients <- (patients-mean_controls_rep)/sd_controls_rep  

#a table of z-scores for each data point of each control (controls' data subtracting from
#controls' means and then dividing by controls' standard deviations)
z_controls <- (controls-mean_controls_rep2)/sd_controls_rep2 



#get a cleaner environment
rm(list = ls()[!ls() %in% c("z_patients", "z_controls")])



#to prepare for a data frame with only norms
norm_patients <- z_patients
norm_controls <- z_controls



#calculate overall means of z-scores per person across all domains

#For patients

#calculate means of z-scores per person for RTI
norm_patients$RTI_mean <- rowMeans(norm_patients[c('X.RTIFMDRT', 'X.RTIFMDMT')], na.rm=TRUE) 

#calculate means of z-scores per person for VRM
norm_patients$VRM_mean <- rowMeans(norm_patients[c('VRMFRDS', 'VRMIRTC', 'VRMDRTC')], na.rm=TRUE)

#calculate means of z-scores per person for SOC
norm_patients$SOC_mean <- rowMeans(norm_patients[c('SOCPSMMT', 'X.SOCMNM5', 'X.SOCITMD5','X.SOCSTMD5')], na.rm=TRUE)

#calculate means of z-scores per person for RVP
norm_patients$RVP_mean <- rowMeans(norm_patients[c('RVPA', 'X.RVPPFA', 'X.RVPMDL')], na.rm=TRUE)

#calculate means of z-scores per person for MTT
norm_patients$MTT_mean <- rowMeans(norm_patients[c('X.MTTTIC', 'X.MTTLMD', 'X.MTTICMD','X.MTTMTCMD')], na.rm=TRUE)

#calculate means of z-scores per person for SWM
norm_patients$SWM_mean <- rowMeans(norm_patients[c('X.SWMBE', 'X.SWMS', 'X.SWMBE4','X.SWMBE6','X.SWMBE8')], na.rm=TRUE)

#calculate means of z-scores per person for PAL
norm_patients$PAL_mean <- rowMeans(norm_patients[c('X.PALTEA', 'PALFAMS')], na.rm=TRUE)

#calculate means of z-scores per person for ERT
norm_patients$ERT_mean <- rowMeans(norm_patients[c('X.ERTOMDRT', 'ERTTH','ERTUHRH','ERTUHRS','ERTUHRF','ERTUHRA','ERTUHRSU','ERTUHRD')], na.rm=TRUE)

#calculate means of z-scores per person for DMS
norm_patients$DMS_mean <- rowMeans(norm_patients[c('DMSPCAD', 'DMSPCS','DMSPC0','DMSPC4','DMSPC12','X.DMSPEGE')], na.rm=TRUE)





#calculate means of z-scores per person for attention and processing speed
norm_patients$attn_speed <- rowMeans(norm_patients[c('RTI_mean', 'RVP_mean')], na.rm=TRUE)

#calculate means of z-scores per person for executive functioning
norm_patients$executive <- rowMeans(norm_patients[c('MTT_mean', 'SOC_mean')], na.rm=TRUE)

#calculate means of z-scores per person for emotion recognition
norm_patients$emotion_recog <- norm_patients$ERT_mean

#calculate means of z-scores per person for memory
norm_patients$memory <- rowMeans(norm_patients[c('DMS_mean', 'PAL_mean', 'SWM_mean','VRM_mean')], na.rm=TRUE)

#calculate means of z-scores per person for visual episodic memory (subdomain of memory)
norm_patients$visual_episodic <- rowMeans(norm_patients[c('DMS_mean', 'PAL_mean')], na.rm=TRUE)

#calculate means of z-scores per person for working memory (subdomain of memory)
norm_patients$working_memory <- norm_patients$SWM_mean  

#calculate means of z-scores per person for verbal episodic memory (subdomain of memory)
norm_patients$verbal_episodic <- norm_patients$VRM_mean


#compute average z-score per person across all domains for patients
norm_patients$overall_mean <- rowMeans(norm_patients[c('RTI_mean', 'VRM_mean','SOC_mean','RVP_mean', 'ERT_mean','MTT_mean','SWM_mean', 'PAL_mean','DMS_mean')], na.rm=TRUE)

#compute average z-score per person across all domains for patients for FEOBV
norm_patients$overall_FEOBV <- rowMeans(norm_patients[c('RTI_mean', 'VRM_mean','SOC_mean','RVP_mean','MTT_mean','SWM_mean', 'PAL_mean','DMS_mean')], na.rm=TRUE)




#For Controls

#calculate means of z-scores per person for RTI
norm_controls$RTI_mean <- rowMeans(norm_controls[c('X.RTIFMDRT', 'X.RTIFMDMT')], na.rm=TRUE) 

#calculate means of z-scores per person for VRM
norm_controls$VRM_mean <- rowMeans(norm_controls[c('VRMFRDS', 'VRMIRTC', 'VRMDRTC')], na.rm=TRUE)

#calculate means of z-scores per person for SOC
norm_controls$SOC_mean <- rowMeans(norm_controls[c('SOCPSMMT', 'X.SOCMNM5', 'X.SOCITMD5','X.SOCSTMD5')], na.rm=TRUE)

#calculate means of z-scores per person for RVP
norm_controls$RVP_mean <- rowMeans(norm_controls[c('RVPA', 'X.RVPPFA', 'X.RVPMDL')], na.rm=TRUE)

#calculate means of z-scores per person for MTT
norm_controls$MTT_mean <- rowMeans(norm_controls[c('X.MTTTIC', 'X.MTTLMD', 'X.MTTICMD','X.MTTMTCMD')], na.rm=TRUE)

#calculate means of z-scores per person for SWM
norm_controls$SWM_mean <- rowMeans(norm_controls[c('X.SWMBE', 'X.SWMS', 'X.SWMBE4','X.SWMBE6','X.SWMBE8')], na.rm=TRUE)

#calculate means of z-scores per person for PAL
norm_controls$PAL_mean <- rowMeans(norm_controls[c('X.PALTEA', 'PALFAMS')], na.rm=TRUE)

#calculate means of z-scores per person for ERT
norm_controls$ERT_mean <- rowMeans(norm_controls[c('X.ERTOMDRT', 'ERTTH','ERTUHRH','ERTUHRS','ERTUHRF','ERTUHRA','ERTUHRSU','ERTUHRD')], na.rm=TRUE)

#calculate means of z-scores per person for DMS
norm_controls$DMS_mean <- rowMeans(norm_controls[c('DMSPCAD', 'DMSPCS','DMSPC0','DMSPC4','DMSPC12','X.DMSPEGE')], na.rm=TRUE)





#calculate means of z-scores per person for attention and processing speed
norm_controls$attn_speed <- rowMeans(norm_controls[c('RTI_mean', 'RVP_mean')], na.rm=TRUE)

#calculate means of z-scores per person for executive functioning
norm_controls$executive <- rowMeans(norm_controls[c('MTT_mean', 'SOC_mean')], na.rm=TRUE)

#calculate means of z-scores per person for emotion recognition
norm_controls$emotion_recog <- norm_controls$ERT_mean

#calculate means of z-scores per person for memory
norm_controls$memory <- rowMeans(norm_controls[c('DMS_mean', 'PAL_mean', 'SWM_mean','VRM_mean')], na.rm=TRUE)

#calculate means of z-scores per person for visual episodic memory (subdomain of memory)
norm_controls$visual_episodic <- rowMeans(norm_controls[c('DMS_mean', 'PAL_mean')], na.rm=TRUE)

#calculate means of z-scores per person for working memory (subdomain of memory)
norm_controls$working_memory <- norm_controls$SWM_mean  

#calculate means of z-scores per person for verbal episodic memory (subdomain of memory)
norm_controls$verbal_episodic <- norm_controls$VRM_mean


#compute average z-score per person across all domains for controls
norm_controls$overall_mean <- rowMeans(norm_controls[c('RTI_mean', 'VRM_mean','SOC_mean','RVP_mean','ERT_mean','MTT_mean','SWM_mean', 'PAL_mean','DMS_mean')], na.rm=TRUE)

#compute average z-score per person across all domains for controls for FEOBV
norm_controls$overall_FEOBV <- rowMeans(norm_controls[c('RTI_mean', 'VRM_mean','SOC_mean','RVP_mean','MTT_mean','SWM_mean', 'PAL_mean','DMS_mean')], na.rm=TRUE)




#A table of z-scores for each patient for each domain
norm_patients <- norm_patients[,-c(1:37)] 

#A table of z-scores for each control for each domain
norm_controls <- norm_controls[,-c(1:37)] 




#A summary table of average z-scores for each domain for patients
summary <- data.frame(colMeans(norm_patients, na.rm = TRUE))
colnames(summary)[1] <- "Mean Z-score"



#Export a txt file called "summary.txt" with the average z-scores for each domain
#Make sure to modify the desired path for the file to be saved 
write.table(summary, file = "~/Documents/CRANI/CANTAB/output/summary.txt", sep = "\t", col.names = FALSE)


############################### DISTRIBUTION OF SCORES ####################################

#PATIENTS
#Graph for overall mean z-score
h_patients <- hist(norm_patients$overall_mean, breaks = 10, density = 10,
                   col = "lightgray", xlab = "Z-score", main = "Patients Overall") 
xfit <- seq(min(norm_patients$overall_mean), max(norm_patients$overall_mean), length = 40) 
yfit <- dnorm(xfit, mean = mean(norm_patients$overall_mean), sd = sd(norm_patients$overall_mean)) 
yfit <- yfit * diff(h_patients$mids[1:2]) * length(norm_patients$overall_mean) 
lines(xfit, yfit, col = "black", lwd = 2)
rm(h_patients)


#Graph for overall mean z-score for FEOBV
h_patients_FEOBV <- hist(norm_patients$overall_FEOBV, breaks = 10, density = 10,
                         col = "lightgray", xlab = "Z-score", main = "Patients Overall for FEOBV") 
xfit <- seq(min(norm_patients$overall_FEOBV), max(norm_patients$overall_FEOBV), length = 40) 
yfit <- dnorm(xfit, mean = mean(norm_patients$overall_FEOBV), sd = sd(norm_patients$overall_FEOBV)) 
yfit <- yfit * diff(h_patients_FEOBV$mids[1:2]) * length(norm_patients$overall_FEOBV) 
lines(xfit, yfit, col = "black", lwd = 2)
rm(h_patients_FEOBV)


#CONTROLS
#Graph for overall mean z-score
h_controls <- hist(norm_controls$overall_mean, breaks = 10, density = 10,
                   col = "lightgray", xlab = "Z-score", main = "Controls Overall") 
xfit <- seq(min(norm_controls$overall_mean), max(norm_controls$overall_mean), length = 40) 
yfit <- dnorm(xfit, mean = mean(norm_controls$overall_mean), sd = sd(norm_controls$overall_mean)) 
yfit <- yfit * diff(h_controls$mids[1:2]) * length(norm_controls$overall_mean) 
lines(xfit, yfit, col = "black", lwd = 2)
rm(h_controls)


#Graph for overall mean z-score for FEOBV
h_controls_FEOBV <- hist(norm_controls$overall_FEOBV, breaks = 10, density = 10,
                         col = "lightgray", xlab = "Z-score", main = "Controls Overall for FEOBV") 
xfit <- seq(min(norm_controls$overall_FEOBV), max(norm_controls$overall_FEOBV), length = 40) 
yfit <- dnorm(xfit, mean = mean(norm_controls$overall_FEOBV), sd = sd(norm_controls$overall_FEOBV)) 
yfit <- yfit * diff(h_controls_FEOBV$mids[1:2]) * length(norm_controls$overall_FEOBV) 
lines(xfit, yfit, col = "black", lwd = 2)
rm(h_controls_FEOBV)

########################################## NOTE TO USER #####################################
#Click the norm_patients dataframe in the torp right corner to view the z-score of each patient
#Click the norm_control dataframe in the top right corner to view z-score of each control

write.table(norm_patients, file = "~/Documents/CRANI/CANTAB/output/norm_patients.csv", sep = '\t')
write.table(norm_controls, file = "~/Documents/CRANI/CANTAB/output/norm_controls.csv", sep = '\t')