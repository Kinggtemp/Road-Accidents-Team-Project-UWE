* Encoding: UTF-8.
PRESERVE.
SET DECIMAL DOT.
CD "C:\Users\%USERNAME%\OneDrive - UWE Bristol\UFCEJA-30-1 - Foundational practice team project 25sep_1\1.Dataset".

GET DATA  /TYPE=TXT
  /FILE="Road Accident Data.csv"
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
/VARIABLES=
  Accident_Index AUTO
  AccidentDate AUTO
  Day_of_Week AUTO
  Junction_Control AUTO
  Junction_Detail AUTO
  Accident_Severity AUTO
  Latitude AUTO
  Light_Conditions AUTO
  Local_Authority_District AUTO
  Carriageway_Hazards AUTO
  Longitude AUTO
  Number_of_Casualties AUTO
  Number_of_Vehicles AUTO
  Police_Force AUTO
  Road_Surface_Conditions AUTO
  Road_Type AUTO
  Speed_limit AUTO
  Time AUTO
  Urban_or_Rural_Area AUTO
  Weather_Conditions AUTO
  Vehicle_Type AUTO
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

* Tell SPSS these are categorical, not scale.
VARIABLE LEVEL
  Junction_Control Junction_Detail Light_Conditions Local_Authority_District
  Carriageway_Hazards Police_Force Road_Surface_Conditions Road_Type
  Urban_or_Rural_Area Weather_Conditions Vehicle_Type
  (NOMINAL).

* Accident severity is ordered.
VARIABLE LEVEL Accident_Severity (ORDINAL).


/*****************************************/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - /
/* - - - - - - - - Variable Clean - - - - - - - - /
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - /
/*****************************************/

/*************************************************/
/* - - - - - - - - Number of Casualties - - - - - - - - /
/*************************************************/

RECODE Number_of_Casualties
 (1 = 1)
 (2 = 2)
 (3 = 3)
 (4 THRU 10 = 4)
 (11 THRU HI = 5)
 INTO Casualty_Group.

VALUE LABELS Casualty_Group
 1 "1 casualty"
 2 "2 casualties"
 3 "3 casualties"
 4 "4–10 casualties"
 5 "11+ casualties".
EXECUTE.

/*******************************************************/
/* - - - - - - - - Rename Traffic auto signal - - - - - - - - /
/******************************************************/

RECODE Junction_Control    
    ("Auto traffic sigl" = "Auto traffic signal")
    (ELSE = COPY).
EXECUTE.

/*****************************************/
/* - - - - - - - - junction control - - - - - - - - /
/*****************************************/

AUTORECODE VARIABLES=Junction_Control
    /INTO    Junction_Control_new
    /PRINT.
VARIABLE LABELS
    Junction_Control_new 'Detailed Description of the junction where the accident happened'.

DELETE VARIABLES Junction_Control.

RENAME VARIABLES (Junction_Control_new = Junction_Control).

EXECUTE.

/*****************************************/
/* - - - - - - - - Junction Detail - - - - - - - - /
/*****************************************/

AUTORECODE VARIABLES=Junction_Detail    
    /INTO    Junction_Detail_new
    /PRINT.
VARIABLE LABELS
    Junction_Detail_new 'Detailed description of the junction where the accident happened'.

DELETE VARIABLES Junction_Detail.

RENAME VARIABLES (Junction_Detail_new = Junction_Detail).

EXECUTE.


/*****************************************/
/* - - - - - - - - Rename Fetal - - - - - - - - /
/*****************************************/

* Fix typo in Accident_Severity.
RECODE Accident_Severity
    ("Fetal" = "Fatal")
    (ELSE = COPY).
EXECUTE.

* Create a new merged string variable.
STRING severity_merged (A10).

* Merge Fatal + Serious into Serious.
IF (Accident_Severity = "Fatal") severity_merged = "Serious".
IF (Accident_Severity = "Serious") severity_merged = "Serious".
IF (Accident_Severity = "Slight") severity_merged = "Slight".
EXECUTE.

* Turn merged text variable into numeric variable for analysis/graphs.
AUTORECODE VARIABLES=severity_merged
    /INTO severity_binary
    /PRINT.

VARIABLE LABELS
    severity_binary 'Accident severity grouped as Serious vs Slight'.

* Add value labels.
VALUE LABELS severity_binary
    1 'Serious'
    2 'Slight'.
EXECUTE.

FREQUENCIES VARIABLES=Accident_Severity severity_merged severity_binary.



/*****************************************/
/* - - - - - - - - Light Conditions - - - - - - - /
/*****************************************/

AUTORECODE VARIABLES=Light_Conditions        
    /INTO    Light_Conditions_new
    /PRINT.
VARIABLE LABELS
    Light_Conditions_new 'Detailed description of the junction where the accident happened'.

DELETE VARIABLES Light_Conditions.

RENAME VARIABLES (Light_Conditions_new = Light_Conditions).

EXECUTE.


/****************************************/
/* - - - - - - - - local authority  - - - - - - - - /
/****************************************/


AUTORECODE VARIABLES= Local_Authority_District      
    /INTO    Local_Authority_District_new
    /PRINT.
VARIABLE LABELS
    Local_Authority_District_new 'Where the accident happened'.

DELETE VARIABLES Local_Authority_District.

RENAME VARIABLES (Local_Authority_District_new = Local_Authority_District).

EXECUTE.

/**************************************************************************************/
/* - - - - - - - - removes local authority values with less than 150 cases  - - - - - - - - /
/**************************************************************************************/

AGGREGATE
/OUTFILE=* MODE=ADDVARIABLES
 /BREAK=Local_Authority_District
/district_count = N.

SELECT IF (district_count > 150).
EXECUTE.

/****************************************/
/* - - - - - - carriageway hazards - - - -  /
/****************************************/

AUTORECODE VARIABLES= Carriageway_Hazards     
    /INTO    Carriageway_Hazards_new
    /PRINT.
VARIABLE LABELS
   Carriageway_Hazards_new 'Hazards that possibly affected the accident'.

DELETE VARIABLES Carriageway_Hazards.

RENAME VARIABLES (Carriageway_Hazards_new =Carriageway_Hazards).

EXECUTE.

VALUE LABELS Carriageway_Hazards
  1 'Any animal in carriageway'
  2 'None'
  3 'Other object on road'
  4 'Pedestrian in carriageway - not injured'
  5 'Previous accident'
  6 'Vehicle load on road'.
EXECUTE.

RECODE Carriageway_Hazards (2=1)(3=2)(4=3)(5=4)(6=5)(7=6) (ELSE=COPY) INTO Carriageway_Hazards.
EXECUTE.

/****************************************/
/* - - - - - - - - - police force - - - - - - - - - /
/****************************************/

AUTORECODE VARIABLES= Police_Force
    /INTO    Police_Force_new
    /PRINT.
VARIABLE LABELS
   Police_Force_new 'Police that reported to the scene'.

DELETE VARIABLES Police_Force.

RENAME VARIABLES (Police_Force_new = Police_Force).

EXECUTE.


/****************************************/
/* - - - - Road surface conditions - - - - /
/****************************************/

AUTORECODE VARIABLES= Road_Surface_Conditions
    /INTO    Road_Surface_Conditions_new
    /PRINT.
VARIABLE LABELS
   Road_Surface_Conditions_new 'Road surface conditions'.

DELETE VARIABLES Road_Surface_Conditions.

RENAME VARIABLES (Road_Surface_Conditions_new = Road_Surface_Conditions).

EXECUTE.

RECODE Road_Surface_Conditions (2=1)(3=2)(4=3)(5=4)(6=5) (ELSE=COPY) INTO Road_Surface_Conditions.
EXECUTE.


VALUE LABELS Road_Surface_Conditions
  1 'Dry'
  2 'Flood over 3cm. deep'
  3 'Frost or ice'
  4 'Snow'
  5 'Wet or damp'.
EXECUTE.

/***************************************/
/* - - - - - - - - - Road Type - - - - - - - - - /
/***************************************/

AUTORECODE VARIABLES= Road_Type
    /INTO    Road_Type_new
    /PRINT.
VARIABLE LABELS
   Road_Type_new 'What the highway code for the road is'.

DELETE VARIABLES Road_Type.

RENAME VARIABLES (Road_Type_new = Road_Type).

EXECUTE.

RECODE Road_Type (2=1)(3=2)(4=3)(5=4)(6=5) (ELSE=COPY) INTO Road_Type.
EXECUTE.

VALUE LABELS Road_Type
  1 'Dual carriageway'
  2 'One way street'
  3 'Roundabout'
  4 'Single carriageway'
  5 'Slip road'.
EXECUTE.

/**************************************/
/* - - - - - - - - urban or rural - - - - - - - /
/**************************************/

AUTORECODE VARIABLES= Urban_or_Rural_Area
    /INTO    Urban_or_Rural_Area_new
    /PRINT.
VARIABLE LABELS
   Urban_or_Rural_Area_new 'Urban or Rural'.

DELETE VARIABLES Urban_or_Rural_Area.

RENAME VARIABLES (Urban_or_Rural_Area_new = Urban_or_Rural_Area).

EXECUTE.


/***************************************/
/* - - - - - Weather conditions - - - - - - /
/***************************************/

AUTORECODE VARIABLES= Weather_Conditions
    /INTO    Weather_Conditions_new
    /PRINT.
VARIABLE LABELS
   Weather_Conditions_new 'What the weather is during the accinent'.

DELETE VARIABLES Weather_Conditions.

RENAME VARIABLES (Weather_Conditions_new = Weather_Conditions).

EXECUTE.

RECODE Weather_Conditions (2=1)(3=2)(4=3)(5=4)(6=5)(7=6)(8=7)(9=8) (ELSE=COPY) INTO Weather_Conditions.
EXECUTE.

VALUE LABELS Weather_Conditions
  1 'Fine + high winds'
  2 'Fine no high winds'
  3 'Fog or mist'
  4 'Other'
  5 'Raining + high winds'
  6 'Raining no high winds'
  7 'Snowing + high winds'
  8 'Snowing no high winds'.
EXECUTE.

/***************************************/
/* - - - - - - - - Vechile Type - - - - - - - - - /
/***************************************/

AUTORECODE VARIABLES= Vehicle_Type
    /INTO    Vehicle_Type_new
    /PRINT.
VARIABLE LABELS
   Vehicle_Type_new 'What type of vechile caused the accident'.

DELETE VARIABLES Vehicle_Type.

RENAME VARIABLES (Vehicle_Type_new = Vehicle_Type).

EXECUTE.

/***************************************/
/* - - - - - - - - Time - - - - - - - - - /
/***************************************/

*creates new Hour variable for analysis

COMPUTE Hour = XDATE.HOUR(Time).
EXECUTE.

DELETE VARIABLES Time.
EXECUTE.

 RENAME VARIABLES (Hour = Time).
EXECUTE.

VARIABLE LEVEL Time (SCALE).
VARIABLE LABELS Time "Hour of day (0-23)".
EXECUTE.


/***************************************/
/* - - - - - - - - Accident date - - - - - - - - - /
/***************************************/

COMPUTE Month = XDATE.MONTH(AccidentDate).
FORMATS Month (F1.0).
EXECUTE.

VALUE LABELS Month
  1  "January"
  2  "February"
  3  "March"
  4  "April"
  5  "May"
  6  "June"
  7  "July"
  8  "August"
  9  "September"
  10 "October"
  11 "November"
  12 "December".
EXECUTE.

VARIABLE LEVEL Month (NOMINAL).
EXECUTE.

*Year comparison
    
COMPUTE Year = XDATE.YEAR(AccidentDate).
FORMATS Year (F1.0).
EXECUTE.

/*********************************************************/
/* - - - - - - - - - - - - - - - Analysis  - - - - - - - - - - - - - - - - - /
/*********************************************************/

/******************************************************************************/
/* - - - - - - - - - - - - - - - Accident severity distribution  - - - - - - - - - - - - - - - - - /
/******************************************************************************/

FREQUENCIES VARIABLES=severity_binary.

/*********************************************************/
/* - - - - - - - -Accidents across the day  - - - - - - - - - - -  /
/*********************************************************/

GRAPH
  /BAR(SIMPLE)=COUNT BY Time.

/***********************************************************************************/
/* - - - - - - - - Accidents by Month with separate lines for each Year - - - - - - - - - /
/***********************************************************************************/

*seasonal patterns, winter spikes higher

GRAPH
  /LINE(MULTIPLE)=COUNT BY Month BY Year.

/**********************************************************/
/* - - - - - - - -  Accident severity by Weather  - - - - - - - - - /
/**********************************************************/

* fine no winds is higher but this could mean that more people drive beacuse there is no danger but when weather is dangerous the numbers are lower because less people are driving.

CROSSTABS
  /TABLES=severity_binary BY Weather_Conditions
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW.

GRAPH
  /BAR(GROUPED)=COUNT BY Weather_Conditions BY severity_binary.

/****************************************************/
/* - - - - - - - -  Urban vs Rural Severity - - - - - - - - - /
/****************************************************/

*shows that Rural accidents have higher fatality rates because speeds are higher

CROSSTABS
  /TABLES=severity_binary BY Urban_or_Rural_Area
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW.

GRAPH
  /BAR(GROUPED)=COUNT BY Urban_or_Rural_Area BY severity_binary.

/****************************************************/
/* - - - - - - - -  Speed Limit vs Severity - - - - - - - - - /
/****************************************************/
/* This explores whether higher speed environments produce worse accidents*/
/*we can see*/
/*Slight: lower speeds*/
/*Serious: moderate*/
/*Fatal: higher speed environments*/

MEANS TABLES=Speed_limit BY severity_binary.

EXAMINE VARIABLES=Speed_limit BY severity_binary
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.

/**************************************/
/* - - - - - - - -  Casualties - - - - - - - - -/
/**************************************/

FREQUENCIES VARIABLES=Casualty_Group.
GRAPH
 /BAR(SIMPLE)=COUNT BY Casualty_Group.

/****************************************/
/* - - - - - - - -  Vehicle Type - - - - - - - - -/
/****************************************/

CROSSTABS
  /TABLES=severity_binary BY Vehicle_Type
  /CELLS=COUNT ROW.

/********************************************/
/* - - - - - - - -  Light Conditions - - - - - - - - -/
/********************************************/

CROSSTABS
  /TABLES=severity_binary BY Light_Conditions
  /CELLS=COUNT ROW.

/********************************************/
/* - - - - - - - -  Road Type - - - - - - - - -/
/********************************************/

CROSSTABS
  /TABLES=severity_binary BY Road_Type
  /CELLS=COUNT ROW.



/*********************************************/
/* - - - - - - - -  Balances dataset - - - - - - - - -*/
   
   *COMPUTE severe_flag = (severity_binary = 1).
    *COMPUTE rand = RV.UNIFORM(0,1).
    *EXECUTE.
    
    *SELECT IF (severe_flag = 1 OR rand < 0.15).
   * EXECUTE.

*FREQUENCIES VARIABLES=severity_binary.


