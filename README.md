# A Statistical Analysis of Thornton Fire Department Turnout Time

* Consulting with Thornton Fire Department (TFD) of Thornton, Colorado in the Denver Metro area.
* TFD wanted to improve turnout time, the time it takes a firefighting crew to put on the proper gear and leave the station after being notified of a call.
* Focus on *inference* instead of *prediction*.

![](https://github.com/Emma-M-Collins/turnout_time/blob/main/EDAPlots.png)
The National Fire Protection Association (NFPA) recommends a 60 second turnout time (blue) for EMS calls and 80 seconds (red) for complex calls.

* Raw data was provided by TFD.  Through discussion with TFD personell, hundreds of variables were narrowed down to less than 15 to be considered in the model.  
* **The Goal**: Determine which variables, such as apparatus, shift, station, and call type, result in longer turnout times.

### Model Selection

* Since most of the variables were categorical, there were upwards of 100 dummy variables.  Thus, BIC stepwise selection was used to determine the best model because it penalizes models with more terms.

