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


--

SELECT
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM covid_deaths
WHERE (continent IS NOT NULL OR continent != "")