SELECT *
FROM PROJECT.dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM PROJECT.dbo.CovidVaccinations
ORDER BY 3, 4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PROJECT.dbo.CovidDeaths
ORDER BY location, date

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DEATHPERCENT
FROM PROJECT.dbo.CovidDeaths
ORDER BY location, date

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DEATHPERCENT
FROM PROJECT.dbo.CovidDeaths
WHERE Location LIKE '%STATE%'
ORDER BY location, date

SELECT location, date, total_cases, population, (total_cases/population)*100 INFECTEDPERCENT
FROM PROJECT.dbo.CovidDeaths
WHERE Location IS NOT NULL
ORDER BY location, date

SELECT location, date, total_cases, population, (total_cases/population)*100 INFECTEDPERCENT
FROM PROJECT.dbo.CovidDeaths
WHERE Location LIKE '%STATE%'
ORDER BY location, date

SELECT location, population, MAX(total_cases) AS INFFECTIONCOUNT,
	MAX(total_cases/population)*100 INFECTEDPERCENT
FROM PROJECT.dbo.CovidDeaths
GROUP BY location, population
ORDER BY INFECTEDPERCENT DESC


SELECT location, MAX(CAST (total_deaths as INT)) AS TOTALDEATH
FROM PROJECT.dbo.CovidDeaths
GROUP BY location
ORDER BY TOTALDEATH DESC

SELECT location, MAX(CAST (total_deaths as INT)) AS TOTALDEATH
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY location
ORDER BY TOTALDEATH DESC

SELECT location, MAX(CAST (total_deaths as INT)) AS TOTALDEATH
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS  NULL
GROUP BY location
ORDER BY TOTALDEATH DESC


SELECT location, MAX(CAST (total_deaths as INT)) AS TOTALDEATH
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS  NULL
GROUP BY location
ORDER BY TOTALDEATH DESC


SELECT date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS NOT NULL
--GROUP BY location
ORDER BY 1,2 DESC

SELECT date, SUM(total_cases) Totalcases, 
	SUM(CAST(New_deaths AS INT)) AS Totaldeath,
	SUM(CAST(New_deaths AS INT))/SUM(new_cases)*100 as NewCasepercentage
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY 1,2 DESC


SELECT SUM(total_cases) Totalcases, 
	SUM(CAST(New_deaths AS INT)) AS Totaldeath,
	SUM(CAST(New_deaths AS INT))/SUM(new_cases)*100 as NewCasepercentage
FROM PROJECT.dbo.CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 1,2 DESC

SELECT *
FROM PROJECT..CovidVaccinations


SELECT *
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date
WHERE Dea.continent IS NOT NULL

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, VAC.new_vaccinations
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date
WHERE Dea.continent IS NOT NULL
ORDER BY 1, 2

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, VAC.new_vaccinations
, SUM(CONVERT(INT, VAC.new_vaccinations)) OVER (PARTITION BY Dea.Location, Dea.date)
AS ROLLINGPEOPLE
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date

WITH PopvsVac
AS 
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, VAC.new_vaccinations
, SUM(CONVERT(INT, VAC.new_vaccinations)) OVER (PARTITION BY Dea.Location, Dea.date)
AS ROLLINGPEOPLE
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date
WHERE Dea.continent IS NOT NULL
)
SELECT*, (ROLLINGPEOPLE/Population)*100 AS ROLLINGPPERCENT5
FROM PopvsVac


 TEMP**
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
Continent Nvarchar(255),
Location Nvarchar(255),
Date datetime,
population Numeric,
New_Vaccinations numeric,
ROLLINGPEOPLE Numeric
)

INSERT INTO #PERCENTPOPULATIONVACCINATED

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, VAC.new_vaccinations
, SUM(CONVERT(INT, VAC.new_vaccinations)) OVER (PARTITION BY Dea.Location, Dea.date)
AS ROLLINGPEOPLE
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date
WHERE Dea.continent IS NOT NULL

SELECT*, (ROLLINGPEOPLE/Population)*100 AS ROLLINGPPERCENT5
FROM #PERCENTPOPULATIONVACCINATED
**
Create view to store date

CREATE VIEW PERCENTPOPULATIONVACCINATED AS

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, VAC.new_vaccinations
, SUM(CONVERT(INT, VAC.new_vaccinations)) OVER (PARTITION BY Dea.Location, Dea.date)
AS ROLLINGPEOPLE
FROM PROJECT..CovidDeaths Dea
	JOIN PROJECT..CovidVaccinations VAC
		ON Dea.location = VAC.location
			AND Dea.date = VAC.date
WHERE Dea.continent IS NOT NULL

SELECT *
FROM PERCENTPOPULATIONVACCINATED

