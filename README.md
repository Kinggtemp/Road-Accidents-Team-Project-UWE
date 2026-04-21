# Road-Accidents-Team-Project-UWE

Team Members
------------
Alex Bashford, Sam Nganga and Hussein Toppozada

Road Accident Analysis & Prediction (UWE Team Project)
------------------------------------------------------

This project explores road accident data in the UK to understand the factors that influence accident severity and to build a model that can predict how serious an accident is likely to be.

The aim of the project was to combine data analysis, statistical testing, and machine learning to identify patterns in accidents and provide insights that could support road safety improvements.

What Was Done
-------------
Analysed a real-world road accident dataset using SPSS and Python

Explored trends across:

-Time (hour of day, monthly patterns)

-Environmental conditions (weather, lighting, road surface)

-Vehicle types involved

-Investigated relationships using cross-tabulation and hypothesis testing

-Built a Decision Tree (CRT model) to predict accident severity


Key Findings
------------

-Accident frequency follows a clear daily pattern, with peaks during morning and evening rush hours

-Most serious accidents occur in fine weather, likely due to higher traffic volume

-After addressing class imbalance, the final model achieved:
~61% accuracy

-Better performance predicting serious accidents (≈64.6%) than slight ones

Example Outputs
---------------
![Hourly Accident Pattern](images/houroftheday.png)

### Accident Frequency by Hour

The distribution of accidents across the day shows a clear temporal pattern. Accident frequency is lowest during the early morning hours (00:00–05:00), which reflects reduced traffic volume during these times.

From around 06:00, accident counts begin to increase as people start commuting to work or school. The number of accidents continues to rise throughout the day, reaching a peak between approximately 16:00 and 18:00. This likely corresponds to evening rush hour, where increased traffic congestion, time pressure, and driver fatigue contribute to a higher likelihood of accidents.

After this peak, accident frequency gradually decreases into the evening and night.

Overall, the pattern suggests that accident frequency is strongly influenced by traffic volume and daily commuting behaviour.

<img src="images/Trainingdecisiontree.png" width="100%">

### Decision Tree Model (Training Data)

The decision tree shows how accident severity is predicted based on key factors in the dataset.

The first split is based on the **number of vehicles involved**, indicating that multi-vehicle accidents have different severity patterns compared to single-vehicle incidents.

Further splits show that **number of casualties** and **location (urban vs rural)** are also important predictors. Accidents in rural areas and those involving more casualties tend to be associated with higher severity.

Overall, the model highlights that accident severity is influenced more by **traffic conditions and environment** rather than individual factors alone.


Modelling Approach
------------------
A CRT decision tree was used after initial models struggled with class imbalance and predicted only the majority class.

To improve performance:

-Balanced the dataset

-Variables were cleaned and grouped where needed

-The model was re-trained and evaluated on test data

The final model showed consistent performance between training and test sets, suggesting good generalisation.

Skills Demonstrated
-------------------
-Exploratory Data Analysis (EDA)

-Data cleaning & preprocessing

-Statistical analysis (Chi-square, cross-tabulation)

-Machine learning (Decision Trees - CRT)

-Handling class imbalance

-Data visualisation

-Git collaboration

Tools Used
----------

SPSS – data cleaning, EDA, statistical tests, decision trees

Python – supplementary analysis

GitLab / GitHub – version control and collaboration

Repository Structure
--------------------

Data/ – raw and processed datasets

Documentation/ – notes, planning, and project write-up

images/ – graphs and model outputs

README.md – project overview

Purpose of This Project
-----------------------
This project was completed as part of a first-year Data Science module at UWE Bristol. It demonstrates practical skills in analysing real-world data, building predictive models, and working collaboratively in a team environment.
