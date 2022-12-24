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
WHERE LOWER(location) = "brazil"
GROUP BY 1,2,3,4,5,6
ORDER BY 1,2;

