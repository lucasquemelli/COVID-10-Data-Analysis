# COVID-19 Data Analysis

<code><img width="100%" src="https://github.com/lucasquemelli/COVID-19_Data-Analysis/blob/main/cover%20image/covid_analytics.jpeg"></code>

# Project Description

This is a data analysis project in order to explore COVID-19 world data using SQL and create a dashboard using Tableau. 

The dataset used in this project contains COVID-19 world data in the period between Jan 2020 and Dec 2022. It is available on [Our World in Data - Coronavirus (COVID-19) Deaths](https://ourworldindata.org/covid-deaths).

# 1. Database

The steps to create a database were:

**1.** Firstly, we created two tables from the dataset downloaded: **(1)** Covid Deaths and **(2)** Covid Vaccinations. 

**2.** Then, we used DBeaver as a database manager. Thus we created a connection with SQLite and created a database. 

**3.** Finally, we imported the csv files to the SQLite database. 

# 2. Data Exploration 

We may find the [Data Exploration file](https://github.com/lucasquemelli/COVID-19_Data-Analysis/blob/main/covid_data_exploring.sql) by clicking on this hyper link. 

In this section, we performed the data exploration using SQLite. The skills used in this task were: Joins, CTE's, Subqueries, Temp Tables, Window Functions, Aggregate Functions, Views, and Converting/Casting Data Types.

All data generated were used to create multiple views. All views were exported to csv files and may be found on [Views Folder](https://github.com/lucasquemelli/COVID-19_Data-Analysis/tree/main/Views). Since we used Tableau Public to create charts and we cannot connect it to a database, we used these csv files as datasource. 

# 3. Data Visualization 

