# COVID-19 Data Analysis

<code><img width="100%" src="https://github.com/lucasquemelli/COVID-19_Data-Analysis/blob/main/cover%20image/covid_analytics.jpeg"></code>

# Project Description

This is a data analysis project in order to explore COVID-19 world data using SQL and create a dashboard using Tableau. 

The dataset used in this project contains COVID-19 world data in the period between Jan 2020 and Dec 2022. It is available on [Our World in Data - Coronavirus (COVID-19) Deaths](https://ourworldindata.org/covid-deaths).

# 1. Database

The steps to create a database were:

**1.** Firstly, we created two tables from the dataset downloaded: **(1)** Covid Deaths and **(2)** Covid Vaccinations. The size of these datasets are too big to upload them on GitHub. Yet, in the next section we created views from them and the views may be found in this project. 

**2.** Then, we used DBeaver as a database manager. Subsequently, we created a connection with SQLite to create the database. 

**3.** Finally, we imported csv files from the data generated in the SQLite database to use them on Tableau Public as datasource. 

# 2. Data Exploration 

We may find the [Data Exploration file](https://github.com/lucasquemelli/COVID-19_Data-Analysis/blob/main/covid_data_exploring.sql) by clicking on this hyper link. 

In this section, we performed the data exploration using SQLite. The skills used in this task were: Joins, CTE's, Subqueries, Temp Tables, Window Functions, Aggregate Functions, Views, and Converting/Casting Data Types.

All data generated were used to create multiple views. All views were exported to csv files and may be found on [Views Folder](https://github.com/lucasquemelli/COVID-19_Data-Analysis/tree/main/Views). Since we used Tableau Public to create charts and we cannot connect it to a database, we used these csv files as datasource. 

# 3. Data Visualization 

We needed to treat the data before showing them out. The main treatments were:

**1. Data type change:** We had to change data type of some columns that was string into numeric type. We made the change in the visualization window on Tableau, because in the datasource the rows could become null. We also converted location (string) into geographic field in order to create maps.

**2. Null treatment:** The tables **(1) Death_per_NewCases** and **(2) Total_Deaths** had null values. To solve this problem, we created new calculated fields on Tableau and attributed 0 in case of null content.  

We may see the final Covid-19 dashboard down here. Yet, if you wish to visualize it more interactively, you may click [here](https://public.tableau.com/app/profile/lucas.quemelli/viz/Covid-19Dashboard_16720056629290/Covid-19Dashboard?publish=yes).

<code><img width="100%" src="https://user-images.githubusercontent.com/81119854/209557581-75ef79e1-3257-42a6-99d5-2749e324b177.png"></code>
