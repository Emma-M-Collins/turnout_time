
# Emma Collins, CU Denver
# Steve Kelley, Battalion Chief, Thornton Fire Dept.


######## Load Data ##########
# replace my file path with whereever the file is located on your computer
# data set I am using is on DropBox page as " Turnout_Time_Analysis.csv "
data <- read.csv("C:\\Users\\Owner\\Desktop\\Portfolio\\TFD\\Turnout_Time_Analysis.csv")


######## Data Prep ##########
# create factor variables (we want R to read '73' as a level, not the number 73)
# relevel data to create desired reference category and in desired order
data$Time <- factor(dat2$Time)
data$Station <- factor(dat2$Station)
data$Year <- factor(dat2$Year)
data$Month <- factor(data$Month, levels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                                            "Sep", "Oct", "Nov", "Dec"))
data$Month <- relevel(data$Month, ref="Jun")
data$ApID <- relevel(data$ApID, ref="E71")
data$Time <- factor(data$Time, levels=c("7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17","18","19","20", 
                                          "21", "22", "23", "0","1","2","3","4","5","6"))

######## Preliminary Graphs #########
#Turnout Time by Apparatus
plot(data$TT ~ data$ApID, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Apparatus", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time by Initial Dispatch Code
par(mar=c(6.5,4,5,1))
plot(data$TT ~ data$InitDisp, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Initial Dispatch Code", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time by Shift
plot(data$TT ~ data$Shift, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Shift", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout Time by Station
plot(data$TT ~ data$Station, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Station", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time by month
plot(data$TT ~ data$Month, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Month", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time by Day
plot(data$TT ~ data$Day, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Day", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#turnout time by Year
boxplot(data$TT ~ data$Year, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Year", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time by time of Call
plot(data$TT ~ data$Time, las=2, xlab=" ", ylab="Turnout Time (sec)", main = "Turnout Time by Time of Call", outline=FALSE)
abline(h=60, col="blue", lwd=2)
abline(h=80, col="red", lwd=2)

#Turnout time v Rest time
plot(data$TT ~ data$RT, xlab="Rest time between Calls (hrs)", ylab = "Turnout Time (sec)", 
     main = "Turnout Time vs Rest Time between Calls")

#Rest time by apparatus
plot(data$RT ~ data$ApID, las=2, xlab=" ", ylab="Rest Time Between Calls (hrs)", 
     main="Rest Time between Calls by Apparatus", outline=FALSE)

#Rest time by shift
plot(data$RT ~ data$Shift, xlab=" ", ylab="Rest Time Between Calls", main="Rest Time between Calls by Shift")


######## Collinearity Check #########
# We need to see if any variables are correlated and remove them
# Having correlated variables creates model instability and inflates standard error - not good!

testmod <- lm(TT ~ ApID + InitDisp + RT + Priority + Shift + Station + Month + Day + Year + Time,
              data = data)
library(faraway)     # need this package for the following function
vif(testmod)         # "variance inflation factors," want values to be below five
                     # All numbers are less than four, so we can proceed without removal


######## Model Selection #########
# Using forward-step BIC selection
# We start with a simple model and start including variables
# based on our perceived importance.
# Goal is to minimize BIC

lmod1 <- lm(TT ~ ApID, data)
BIC(lmod1) 

lmod2 <- lm(TT ~ ApID + InitDisp, data)
BIC(lmod2) 

lmod3 <- lm(TT ~ ApID + InitDisp + Shift, data)
BIC(lmod3) #907781.7 ***

lmod4 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID, data)
BIC(lmod4) #907449.9 ***

lmod5 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year, data)
BIC(lmod5) #905302.8 ***

lmod6 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month, data)
BIC(lmod6) #905147.8

lmod7 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month + Day, data)
BIC(lmod7) #905141.5 ***

lmod8 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month + Day + Time, data)
BIC(lmod8) #887796.8

lmod9 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month + Day + Time + Priority, data)
BIC(lmod9) #887807.8

lmod10 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month + Time, data)
BIC(lmod10) #887748.4

lmod11 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time, data)
BIC(lmod11) #890438.4

lmod12 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Year + Month + Time + Year:Shift, data)
BIC(lmod12) #887538.9 ************

lmod13 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift, data)
BIC(lmod13) #887538.9 ***

lmod14 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift
             + Shift:InitDisp, data)
BIC(lmod14) #887852.1

lmod15 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift
             + Shift:Time , data)
BIC(lmod15) #887911

lmod16 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time
             + Shift:Year + InitDisp:Time, data)
BIC(lmod16) #891115.8

lmod17 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift
             + Station, data)
BIC(lmod17) #887554.1

lmod18 <- lm(TT ~ ApID + InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift
             + Station + Station:Shift, data)
BIC(lmod18) #887641.1
lmod19 <- lm(TT ~ InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift
             + Station, data)
BIC(lmod19) #887554.1

lmod20 <- lm(TT ~ InitDisp + Shift + Shift:ApID + Month + Time + Year:Shift, data)
BIC(lmod20) #887538.9

lmod21 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift, data)
BIC(lmod21) #887538.9

lmod22 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT, data)
BIC(lmod22) #787332.4 ******

lmod23 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + InitDisp:Time, data)
BIC(lmod23) #790966.3

lmod24 <- lm(TT ~ ApID + Shift + Time + Month + InitDisp + Shift:ApID, data)
BIC(lmod24) #890438.4

lmod25 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + ApID, data)
BIC(lmod25) #787332.4

lmod26 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + Shift, data)
BIC(lmod26) #787332.4 

lmod27 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + Year, data)
BIC(lmod27) #787332.4

lmod28 <- lm(TT ~ InitDisp + Month + Time + Year:Shift + RT , data)
BIC(lmod28) #788355.2

lmod29 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + Year + ApID, data)
BIC(lmod29) #787332.4

lmod30 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + Year + Shift, data)
BIC(lmod30) #787332.4

lmod31 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + ApID + Shift, data)
BIC(lmod31) #787332.4

lmod32 <- lm(TT ~ InitDisp + Shift:ApID + Month + Time + Year:Shift + RT + Year + Shift + ApID, data)
BIC(lmod32) #787332.4

# lmod32 is final model.
# Although models without Year, Shift, and ApID have the same BIC
# it is standard practice to include the individual terms when they
# are used in an interaction term.

######## Model Structure ########
# We need to make sure our model is adequately representing the data
# Since every variable except RT is categorical, we can only look at
# diagnostic plots of RTs

finalmod <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
               data)
finalabv <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year, data=data)
crPlot(finalabv, variable="RT")
avPlot(finalmod, variable="RT")
residualPlot(finalmod, variable="RT")
# The above plots do not show much of a relationship between RT and TT
# we'll examine more of this later

######## Model Diagnostics #########
# Ideally, our errors (the difference between our observed values and what our model predicts)
# are normally distributed

qqnorm(residuals(finalmod), main="Error Normality Check")
qqline(residuals(finalmod))

# In a perfect world, our dots would match up with the line
# This indicates our model is skewed, with a tail on the right
# This makes a bit of intuitive sense since we did have some large (over 300 seconds)
# turnout times
# However, since our sample size is so big, we aren't very concerned. We will do a
# bootstrap check to confirm our coefficient values are correct

plot(fitted(finalmod), sqrt(abs(residuals(finalmod))), main="Sqrt(Resid) V Fitted")
# Since there aren't any concerning patterns (especially a megaphone shape)
# we aren't very concerned with our errors being non-normal
### Bootstrap ###
# This is a method that does not rely on any distribution assumptions
# We sample values of our known data and create a model from the sample
# in order to create coefficient values

data3 = na.omit(data)
set.seed(70)                    # set seed for reproducability
nsim = 4000                     # the number of simulations we will run
coefmat = matrix(0, nsim, 105)  # fill w/zeros, nb rows, 105 columns
resids = residuals(finalmod)    # extract residuals
preds = fitted(finalmod)        # fitted values

#### WARNING: THIS WILL TAKE A WHILE TO RUN - IT TOOK ME ABOUT AN HOUR ####

for (i in 1:nsim) {
  booty <- preds + sample(resids, replace = TRUE) # create bootstrap data
  # fit regression model to bootstrap data
  bmod <- lm(booty ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift, data = data3)
  coefmat[i,] = coef(bmod) # extract estimated coefficients from bmod and store them for later
}
# rename matrix columns
colnames(coefmat) = c("Reference", "BC71", "E72", "E73", "E75", "E76",
                      "MED71", "MED72", "MED74", "MED75", "SAM71", "SQD73", "T74",
                      "ALARMF", "ASUIC", "AUTOAID", "DEATH", "EMS", "EMS-ALPHA", "EMS-BRAVO",
                      "EMS-CHRL", "EMS-DELT", "EMS-ECHO", "EMS-OFC", "EMS-OMEG", "FIRE",
                      "HAZMAT", "RESCUE", "SERV", "SHOOT", "STAB", "STRUCT",
                      "Time 8", "Time 9",
                      "Time 10", "Time 11", "Time 12", "Time 13", "Time 14", "Time 15", "Time 16",
                      "Time 17", "Time 18", "Time 19", "Time 20", "Time 21", "Time 22", "Time 23",
                      "Time 0", "Time 1", "Time 2", "Time 3", "Time 4", "Time 5", "Time 6",
                      "RT",
                      "Shift B", "Shift C", "Jan", "Feb", "Mar", "Apr", "May", "Jul", "Aug", "Sep",
                      "Oct", "Nov", "Dec", "2015", "2016", "2017", "2018",
                      "BC71:ShiftB", "E72:ShiftB", "E73:ShiftB", "E75:ShiftB", "E76:ShiftB","MED71:ShiftB",
                      "MED72:ShiftB", "MED74:ShiftB", "MED75:ShiftB", "SAM71:ShiftB", "SQD73:ShiftB", "T74:ShiftB",
                      "BC71:ShiftC", "E72:ShiftC", "E73:ShiftC", "E75:ShiftC", "E76:ShiftC", "MED71:ShiftC",
                      "MED72:ShiftC", "MED74:ShiftC", "MED75:ShiftC", "SAM71:ShiftC", "SQD73:ShiftC", "T74:ShiftC",
                      "ShiftB:2015", "ShiftC:2015", "ShiftB:2016", "Shiftc:2016", "ShiftB:2017", "ShiftC:2017",
                      "ShiftB:2018", "ShiftC:2018")
coef_df <- data.frame(coefmat) # convert to data frame
cis = apply(coef_df, 2, quantile, probs = c(.025, .975)) # construct 95% CIs for each coefficients using the apply function
cis
# by visual examination, none of the confidence intervals seem to deviate from the coefficients
# the model summary gives us
hist(coefmat[,"RT"], main="Bootstrap Results for Rest Time", xlab="Rest Time between Calls", col="blanchedalmond")
abline(v=0.5649, lwd=2)

# Histogram of the bootstrap values against the model value (represented by the vertical line)
# save matrix of bootstrap values so we don't have to run the code again
save(coefmat, file = "bootstrap_coefmatrix.rda")
load(file = "bootstrap_coefmatrix.rda")


### Outliers and Influential Points ###
library(car)
outlierTest(finalmod)
influencePlot(finalmod)
# We see there are some possible outliers and influential points
# We'll remove these observations from the model and see if they
# change our coefficients drastically

block <- row.names(data)
# refit model after removing Obs 64625
mod1 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 64625))
compareCoefs(finalmod, mod1)
#refit model after removing Obs 77506
mod2 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 77506))
compareCoefs(finalmod, mod2)
#refit model after removing Obs 17861
mod3 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 17861))
compareCoefs(finalmod, mod3)
#refit model after removing Obs 378
mod4 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 378))
compareCoefs(finalmod, mod4)
#refit model after removing Obs 51821
mod5 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 51821))
compareCoefs(finalmod, mod5)
#MED71 goes from .2 to -.01, sign change is concerning but the magnintude is relatively small
#refit model after removing Obs 11711
mod6 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 11711))
compareCoefs(finalmod, mod6)
#refit model after removing Obs 2218
mod7 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 2218))
compareCoefs(finalmod, mod7)
#refit model after removing Obs 27672
mod8 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 27672))
compareCoefs(finalmod, mod8)
#refit model after removing Obs 38978
mod9 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
           data=data, subset = (block != 38978))
compareCoefs(finalmod, mod9)
#refit model after removing Obs 30398
mod10 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 30398))
compareCoefs(finalmod, mod10)
#refit model after removing Obs 20711
mod11 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 20711))
compareCoefs(finalmod, mod11)
#refit model after removing Obs 55580
mod12 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 55580))
compareCoefs(finalmod, mod12)
#refit model after removing Obs 61642
mod13 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 61642))
compareCoefs(finalmod, mod13)
#refit model after removing Obs 68172
mod14 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 68172))
compareCoefs(finalmod, mod14)
#refit model after removing Obs 77506
mod15 <- lm(TT ~ ApID + InitDisp + Time + RT + Shift + Month + Year + Shift:ApID + Year:Shift,
            data=data, subset = (block != 77506))
compareCoefs(finalmod, mod15)
# There are no drastic changes from removing any observations, so they remain within the model.


###### FINAL MODEL SUMMARY #######

summary(finalmod)
# since there are so many predictors, making it hard to read and observe the change between
# levels, we look at barcharts comparing each level in a predictor to it's respective
# reference level


###### Creating Visuals and Pretty Pictures ######

# Plot of apparatus comparisons
barplot(finalmod$coef[c(2:13)], las=2, ylim=c(-15, 20), main = "Apparatus Comparison (Ref = Engine 71)",
        col=c("orange", "orange", 3, 3, "orange", "orange", 3,3,3, "orange",3,"orange" ),
        names.arg = c("BC71", "E72", "E73", "E75", "E76", "MED71", "MED72", "MED74", "MED75", "SAM71", "SQD73", "T74"))

# Plot of Initial Dispatch Code Comparison
par(mar=c(6.5,4,5,1))
barplot(finalmod$coef[c(14:32)], las=2, main = "Initial Dispatch Code Comparison (Ref = Accident)",
        col=c("orange", 3, "orange", "orange", 3, 3, 3, 3, 3, 3, 3, 3,"orange","orange","orange","orange",3,3,"orange"),
        names.arg = c("ALARMF", "ASUIC", "AUTOAID", "DEATH", "EMS", "EMS-ALPHA", "EMS-BRAVO",
                      "EMS-CHRL", "EMS-DELT", "EMS-ECHO", "EMS-OFC", "EMS-OMEG", "FIRE",
                      "HAZMAT", "RESCUE", "SERV", "SHOOT", "STAB", "STRUCT"))

# Plot of time of call comparison
par(mar=c(7,4,5,1))
barplot(finalmod$coef[c(33:55)], las=2, main = "Time of Call Comparison (Ref = 7:00-7:59)",
        col=c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, "orange", "orange", "orange", "orange", "orange","orange",
              "orange", "orange", "orange"), ylim=c(-20, 40),
        names.arg = c("08:00-8:59", "09:00-9:59", "10:00-10:59", "11:00-11:59", "12:00-12:59", "13:00-13:59",
                      "14:00-14:59", "15:00-15:59", "16:00-16:59", "17:00-17:59", "18:00-18:59", "19:00-19:59",
                      "20:00-20:59", "21:00-21:59", "22:00-22:59", "23:00-23:59", "00:00-00:59", "01:00-01:59",
                      "02:00-02:59", "03:00-03:59", "04:00-04:59", "05:00-05:59", "06:00-06:59"))

# Plot of Shift comparison
barplot(finalmod$coef[c(56:57)], main = "Shift Comparison (Ref = Shift A)", col=("orange"),
        names.arg = c("Shift B", "Shift C"), ylim=c(0, 3))

# Plot of month comparison
par(mar=c(4,4,5,1))
barplot(finalmod$coef[c(58:68)], las=2, main = "Month Comparison (Ref = June)",
        col=c("orange","orange","orange","orange",3,3,3,3,3,3,3), ylim=c(-5,20),
        names.arg = c("Jan", "Feb", "Mar", "Apr", "May", "Jul", "Aug", "Sep",
                      "Oct", "Nov", "Dec"))

# Plot of year comparison
barplot(finalmod$coef[c(69:72)], main = "Year Comparison (Ref = 2014)",
        col=c(3), ylim=c(-20, 0),
        names.arg = c("2015", "2016", "2017", "2018"))

# Plot of apparatus*shift comparsion, SHIFT B
par(mar=c(6.5,4,5,1))
barplot(finalmod$coef[c(73:84)], las=2, main = "Apparatus:Shift B Comparison (Ref = E71, Shift A)",
        col=c(3, "orange", 3, "orange", "orange", 3, 3, "orange", 3, "orange", "orange", "orange"),
        names.arg = c("BC71:ShiftB", "E72:ShiftB", "E73:ShiftB", "E75:ShiftB", "E76:ShiftB","MED71:ShiftB",
                      "MED72:ShiftB", "MED74:ShiftB", "MED75:ShiftB", "SAM71:ShiftB", "SQD73:ShiftB", "T74:ShiftB"))

# Plot of apparatus*shift comparsion, SHIFT C
barplot(finalmod$coef[c(85:96)], las=2, main = "Apparatus:Shift C Comparison (Ref = E71, Shift A)",
        col=c(3, "orange", 3, "orange", "orange", 3, 3, 3, 3, 3, "orange", 3), ylim=c(-5, 15),
        names.arg = c("BC71:ShiftC", "E72:ShiftC", "E73:ShiftC", "E75:ShiftC", "E76:ShiftC", "MED71:ShiftC",
                      "MED72:ShiftC", "MED74:ShiftC", "MED75:ShiftC", "SAM71:ShiftC", "SQD73:ShiftC", "T74:ShiftC"))

# Plot of Shift:Year comparison
par(mar=c(6.5,4,5,1))
barplot(finalmod$coef[c(97:104)], las=2, ylim=c(-16, 0), main = "Shift:Year Comparison (Ref = Shift A, 2014)",
        col=3,
        names.arg = c("ShiftB:2015", "ShiftC:2015", "ShiftB:2016", "Shiftc:2016", "ShiftB:2017", "ShiftC:2017",
                      "ShiftB:2018", "ShiftC:2018"))


