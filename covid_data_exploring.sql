/*
Covid-19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting/Casting Data Types
*/


-- Double check if data is ok

SELECT 
	*
FROM covid_deaths
ORDER BY 3,4;

SELECT 
	*
FROM covid_vaccinations 
ORDER BY 3,4;


-- Checking if everything is ok with continent field

SELECT DISTINCT 
	continent 
FROM covid_deaths; 
	

-- Checking NULL values for continent
-- Based on this query, we should discard values where continent is null

SELECT DISTINCT 
	continent,
	location 
FROM covid_deaths 
WHERE (continent IS NULL OR continent = "");

SELECT DISTINCT
	continent,
	location
FROM covid_deaths 
WHERE LOWER(location) = "africa";


-- Selecting data we are going to work with

SELECT
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM covid_deaths
WHERE (continent IS NOT NULL OR continent != "")
ORDER BY 1,2;

-- Total cases vs total deaths

SELECT
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population,
	ROUND((total_deaths/total_cases)*100, 2) AS percentage_death_case,
	ROUND((total_deaths/population)*100, 5) AS percentage_death_population
FROM covid_deaths
WHERE (continent IS NOT NULL OR continent != "")
GROUP BY 1,2,3,4,5,6
ORDER BY 1,2;

-- Total cases vs total deaths in Brazil
-- It shows the likelihood of dying in Brazil if you get Covid-19
-- It shows the percentage of the entire population in Brazil who died for Covid-19

SELECT
	location, 
	date, 
	total_cases,  
	total_deaths, 
	population,
	ROUND((total_deaths/total_cases)*100, 2) AS percentage_death_case,
	ROUND((total_deaths/population)*100, 5) AS percentage_death_population
FROM covid_deaths
WHERE LOWER(location) = "brazil"
GROUP BY 1,2,3,4,5
ORDER BY 1,2;

-- Total cases vs population
-- It shows the percentage of population who has gotten Covid-19

SELECT
	location, 
	date, 
	total_cases, 
	population,
	ROUND((total_cases/population)*100, 5) AS percentage_cases_population
FROM covid_deaths
WHERE LOWER(location) = "brazil"
GROUP BY 1,2,3,4
ORDER BY 1,2;

-- Countries with the highest infection rates compared to population 

SELECT
	location, 
	total_cases, 
	population,
	ROUND((total_cases/population)*100, 5) AS infection_rate
FROM covid_deaths
WHERE date = "2022-12-22" -- The most updated date of the dataset
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Countries with the highest infection count

SELECT
	location, 
	MAX(CAST(total_cases AS int)) AS max_inffection_count, 
	ROUND((CAST(total_cases AS int)/population)*100, 5) AS infection_rate
FROM covid_deaths
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

-- Countries with the highest death rates compared to population 

SELECT
	location, 
	total_deaths, 
	population,
	ROUND(total_deaths/population)*100, 5) AS death_rate
FROM covid_deaths
WHERE date = "2022-12-22" -- The most updated date of the dataset
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Countries with the highest death count

SELECT
	location, 
	MAX(CAST(total_deaths AS int)) AS max_death_count, 
	ROUND((CAST(total_deaths AS int)/population)*100, 5) AS death_rate
FROM covid_deaths
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

-- The most populated countries in 2022-12-22

SELECT
	location,  
	population
FROM covid_deaths
WHERE date = "2022-12-22" -- The most updated date of the dataset
AND LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2 DESC;

-- Continents with the highest infection count

SELECT
	continent, 
	MAX(CAST(total_cases AS int)) AS max_inffection_count
FROM covid_deaths
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

-- Continents with the highest death count

SELECT
	continent, 
	MAX(CAST(total_deaths AS int)) AS max_death_count 
FROM covid_deaths
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;