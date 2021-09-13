# Pediatric Hypertension Status

Childhood hypertension status is determined from systolic and diastolic blood pressure, age, sex, and, height percentiles. This results in hundreds of potential hypertension thresholds. The first R script(CHTNsa.Rdata) takes individual values as an input while the second (CHTNdf.Rdata) works on a dataframe.

**Important:** 
Because pediatric hypertension is based on normative values of blood pressure by age, sex, and height, we need to call to some external data which provides these normative values. These data can be found in published work by Flynn et al. [1]. I have extracted and reorganized the relevant data into a form usable by the functions presented here. You can get the file (BPTABLES.rds) from this github page. The functions presented here will not work without this file and you will need to manually edit a file path within the functions that calls to this file.

Inputs for `CHTNsa()` are as follows:

-   age: in years
-   sex: 1 (men) and 2 (women)
-   height: in cm
-   systolic blood pressure: in mmHg
-   diastolic blood pressure: in mmHg

Take an example: If you had data on a 9 year old girl with a height of 163.6 cm and systolic and diastolic blood pressure of 110 and 64 mmHg, respectively, you would call the function as follows:

```
CHTNsa(age = 9, 
        sex = 2, 
        height = 163.6,
        systolic = 110, 
        diastolic = 64)
```

The function returns the hypertension status for both systolic and diastolic blood pressure (something not all calculators do) and plots the values in relation to the guideline cut-offs.

The second function (CHTNdf.Rdata) is a little more complex but also more comprehensive and returns a data frame with the results.

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

```
results <- CHTNdf(mydata)
```

Values returned by the function:

-   0 = NORMOTENSIVE
-   0.5 = ELEVATED
-   1 = STAGE 1
-   2 = STAGE 2

My coding here may not be perfect and please check values returned with validated online hypertension calculators. The functions here are for research purposes only and are not fit for clinical use. Enjoy!

**References** 
1. Flynn JT, et al. (2017). Clinical Practice Guideline for Screening and Management of High Blood Pressure in Children and Adolescents. Pediatrics, 140(3), e20171904.
