# Pediatric Hypertension Status

Childhood hypertension status is determined from systolic and diastolic blood pressure, age, sex, and, height percentiles. This results in hundreds of potential hypertension thresholds. The first R script (CHTNsa.R) takes individual values as an input while the second (CHTNdf.R) works on a dataframe.

Load the functions from Github:

```R
devtools::source_url("https://raw.githubusercontent.com/mkarmstrong/PediatricBP/main/CHTNsa.R")
devtools::source_url("https://raw.githubusercontent.com/mkarmstrong/PediatricBP/main/CHTNdf.R")
```


**Important note:** 
Because pediatric hypertension is based on normative values of blood pressure by age, sex, and height, we need to call to a dataframe which provides these normative values. These data can be found in published work by Flynn et al. [1]. I have extracted and reorganized the relevant data into a form usable by the functions presented here. You can get these data (BPTABLES.csv) from this github page. Currently, my functions presented here load the normative values data directly from this Github page, but this makes the functions run slow. It is recomended that you save the BPTABLES.csv file locally and change the file path within the function.
<br/><br/>

**FUNCTION 1**

Inputs for `CHTNsa()` are as follows:

-   **age:** in years
-   **sex:** 1 (men) and 2 (women)
-   **height:** in cm
-   **systolic:** BP (systolic) in mmHg
-   **diastolic:** BP (diastolic) in mmHg

Take an example: If you had data on a 9 year old girl with a height of 163.6 cm and systolic and diastolic blood pressure of 110 and 64 mmHg, respectively, you would call the function as follows:

```R
CHTNsa(age = 9, 
       sex = 2, 
       height = 163.6,
       systolic = 110, 
       diastolic = 64)
```

The function returns the hypertension status for both systolic and diastolic blood pressure (something not all calculators do) and plots the values in relation to the guideline cut-offs (as reported in Flyn et al.[1]).

![alt text](https://github.com/mkarmstrong/PediatricBP/blob/main/PedsHypertension.png)

<br/><br/>

**FUNCTION 2**

The second function (CHTNdf.R) is a little more complex but also more comprehensive and runs on a data frame.

It is important that your dataframe contains the following variables with (exact) column labels:

| Column label | Description           |
|--------------|-----------------------|
| id           | participant id        |
| age.y        | age in years          |
| sex          | 1 (men) and 2 (women) |
| systolic     | systolic BP (mmHg)    |
| diastolic    | diastolic BP (mmHg)   |
| height.cm    | height in cm          |


**Notes:**

-   If age.y is \>=18 years, then the height and sex values are ignored and hypertension status is determined as per the adult AHA guidelines.
-   For individuals aged \>=13 years, AHA adult guidelines are used to determine hypertension status (as per Flynn et al.) unless `simple = F` then sex and height percentiles are used.

Apply the function to the data as follows:

```R
# Use AHA adult gidlines for individuals >= 13y
results <- CHTNdf(mydata, simple = T)

# Use height and sex percentiles for individuals >= 13y (up to age 18y).
results <- CHTNdf(mydata, simple = F) 
```

Values returned by the function:

-   0 = NORMOTENSIVE
-   0.5 = ELEVATED
-   1 = STAGE 1
-   2 = STAGE 2

Please check values returned by this function with validated online hypertension calculators. The functions here are for research purposes only and are not fit for clinical use. Enjoy!

**References** 
1. Flynn JT, et al. (2017). Clinical Practice Guideline for Screening and Management of High Blood Pressure in Children and Adolescents. Pediatrics, 140(3), e20171904.
