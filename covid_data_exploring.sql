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


-- Selecting data we are going to work with

SELECT
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM covid_deaths
WHERE (continent IS NOT NULL OR continent != "");