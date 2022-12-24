/*
Covid-19 Data Exploration 
Skills used: Joins, CTE's, Subqueries, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting/Casting Data Types
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
	location, 
	MAX(CAST(total_cases AS int)) AS max_inffection_count
FROM covid_deaths
WHERE LOWER(location) IN ("world", "asia", "africa", "south africa", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

-- Continents with the highest death count

SELECT
	location, 
	MAX(CAST(total_deaths AS int)) AS max_death_count 
FROM covid_deaths
WHERE LOWER(location) IN ("world", "asia", "africa", "south africa", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

-- Global numbers

SELECT 
	date,
	SUM(new_cases) AS new_cases,
	SUM(new_deaths) AS new_deaths,
	ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS death_percentage
FROM covid_deaths 
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 1; 

-- Death percentage globally until 2022-12-22

SELECT 
	SUM(new_cases) AS new_cases,
	SUM(new_deaths) AS new_deaths,
	ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS death_percentage
FROM covid_deaths 
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 1; 

-- Total population vs total vaccinations 

SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS accumulated_vaccinations,
	((SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date))/cd.population)*100 AS percentage_vaccinated,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location) AS total_vaccinations_per_country
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON LOWER(cd.location) = LOWER(cv.location)
						  AND cd.date = cv.date 
WHERE LOWER(cd.location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2,3

-- Using CTE 

WITH PopsVac (continent, location, date, population, new_vaccinations, accumulated_vaccinations) AS (

SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS accumulated_vaccinations
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON LOWER(cd.location) = LOWER(cv.location)
						  AND cd.date = cv.date 
WHERE LOWER(cd.location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2,3
)
SELECT 
*
FROM PopsVac

-- Using subquery

WITH vaccinations_data AS (

	SELECT 
		cd.continent, 
		cd.location, 
		cd.date, 
		cd.population,
		cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS accumulated_vaccinations
	FROM covid_deaths cd 
	JOIN covid_vaccinations cv ON LOWER(cd.location) = LOWER(cv.location)
							  AND cd.date = cv.date 
	WHERE LOWER(cd.location) NOT IN ("international", "world", "asia", "lower middle income", 
	"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
	"european union", "south america", "oceania")
	ORDER BY 2,3
	
), percentage_vaccinated AS (

	SELECT 
		continent, 
		location,
		date,
		population,
		new_vaccinations,
		accumulated_vaccinations,
		(accumulated_vaccinations/population)*100 AS percent_vaccinated
	FROM vaccinations_data 
	
)

SELECT
*
FROM percentage_vaccinated

-- Temp Table
-- We MUST execute each query separately on SQLite

DROP TABLE Percentage_Population_Vaccinated

CREATE TABLE Percentage_Population_Vaccinated (

	continent VARCHAR(50),
	location VARCHAR(50),
	date DATETIME,
	population REAL,
	new_vaccinations REAL,
	accumulated_vaccinations REAL,
	percentage_vaccinated REAL,
	total_vaccinations_per_country REAL

)

INSERT INTO Percentage_Population_Vaccinated 

SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS accumulated_vaccinations,
	((SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date))/cd.population)*100 AS percentage_vaccinated,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location) AS total_vaccinations_per_country
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON LOWER(cd.location) = LOWER(cv.location)
						  AND cd.date = cv.date 
WHERE LOWER(cd.location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2,3


SELECT 
*
FROM Percentage_Population_Vaccinated


/* Creating views to store data for later visualizations on Tableau */

CREATE VIEW Percentage_Vaccinated AS 
SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS accumulated_vaccinations,
	((SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date))/cd.population)*100 AS percentage_vaccinated,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location) AS total_vaccinations_per_country
FROM covid_deaths cd 
JOIN covid_vaccinations cv ON LOWER(cd.location) = LOWER(cv.location)
						  AND cd.date = cv.date 
WHERE LOWER(cd.location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2,3

CREATE VIEW Total_Deaths AS
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

CREATE VIEW Total_Deaths_Brazil AS
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

CREATE VIEW Cases_Population_Brazil AS 
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

CREATE VIEW Countries_Max_Infection AS
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

CREATE VIEW Countries_Max_Deaths AS
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

CREATE VIEW Most_Populated_Countries AS
SELECT
	location,  
	population
FROM covid_deaths
WHERE date = "2022-12-22" -- The most updated date of the dataset
AND LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
ORDER BY 2 DESC;

CREATE VIEW Continents_Max_Infection AS
SELECT
	location, 
	MAX(CAST(total_cases AS int)) AS max_inffection_count
FROM covid_deaths
WHERE LOWER(location) IN ("world", "asia", "africa", "south africa", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

CREATE VIEW Continents_Max_Deaths AS
SELECT
	location, 
	MAX(CAST(total_deaths AS int)) AS max_death_count 
FROM covid_deaths
WHERE LOWER(location) IN ("world", "asia", "africa", "south africa", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 2 DESC;

CREATE VIEW Death_per_NewCases AS
SELECT 
	date,
	SUM(new_cases) AS new_cases,
	SUM(new_deaths) AS new_deaths,
	ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS death_percentage
FROM covid_deaths 
WHERE LOWER(location) NOT IN ("international", "world", "asia", "lower middle income", 
"upper middle income", "africa", "south africa", "high income", "low income", "europe", "north america",
"european union", "south america", "oceania")
GROUP BY 1
ORDER BY 1; 