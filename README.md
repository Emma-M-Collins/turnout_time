# A Statistical Analysis of Thornton Fire Department Turnout Time

* Consulting with Thornton Fire Department (TFD) of Thornton, Colorado in the Denver Metro area.
* TFD wanted to improve turnout time, the time it takes a firefighting crew to put on the proper gear and leave the station after being notified of a call.
* Focus on *inference* instead of *prediction*.

![](https://github.com/Emma-M-Collins/turnout_time/blob/main/EDAPlots.png)
The National Fire Protection Association (NFPA) recommends a 60 second turnout time (blue) for EMS calls and 80 seconds (red) for complex calls.

* Raw data was provided by TFD from 2014-2018, including over 100,000 observations.  Through discussion with TFD personell, hundreds of variables were narrowed down to less than 15 to be considered in the model.  
* **The Goal**: Determine which variables, such as apparatus, shift, station, and call type, result in longer turnout times.

### Model Creation

* Since most of the variables were categorical, there were upwards of 100 dummy variables.  Thus, BIC stepwise selection was used to determine the best model because it penalizes models with more terms. 
![](https://github.com/Emma-M-Collins/turnout_time/blob/main/FinalModel.png)
* The final model has skewed errors, indicating it did not predict high turnout times (three minutes or greater) well.  However, since these long times are uncommon and we are more concerned about inference instead of prediction, we are not too concerned. 
* Bootstrapping was used to confirm coefficient values and the model was checked for any outliers and influential observations.

### Results 

* Because the final model has 105 coefficients, bar charts are used to present results.
![](https://github.com/Emma-M-Collins/turnout_time/blob/main/FinalModelCoeff.png)
Engine 75 is, on average, 15 seconds faster than Engine 71, while Engine 76 is, on average, 15 seconds slower than Engine 71 (Right).
On average, EMS-ECHO calls have a 10 second faster turnout time than auto accidents, while hazmat calls have a 10 second slower turnout time than auto accidents (Left).

### Conclusions/Future Work

* Turnout time has improved since 2014 but has slowly increased over the years.
* Across all years, on average, the battalion cheif and Engine 76 are much slower than other apparatuses, while Engine 75 is much faster.
* Future Analysis would involve more data (such as recent hires/retirements and injuries) and a time series analysis across time of calls and/or year.
