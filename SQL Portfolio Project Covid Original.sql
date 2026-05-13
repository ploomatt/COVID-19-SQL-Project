--Provide an overview of all values listed in the dataset
Select *
From PortfolioProject..CovidDeathsXL
Where continent <> ''
order by location, CAST(date AS DATE);


--Total cases vs Total Deaths
--Liklihood of death upon contraction
Select 
	Location, 
	date, 
	total_cases, 
	total_deaths, 
	(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeathsXL
Where continent <> ''
order by location, CAST(date AS DATE);


--Total Covid cases vs Population in the US
--percentage of population contracted Covid
Select 
	Location, 
	date, 
	total_cases, 
	population, 
	(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeathsXL
Where location like '%states%' and continent <> ''
order by location, CAST(date AS DATE);


--Look at Countries with Highest Infection Rate compared to population
SELECT 
	Location, 
	Population, 
	MAX(total_cases) AS HighestInfectionCount, 
	MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc;


--Show Countries with Highest Death Count per Population(Countries)
Select 
	Location, 
	Population, 
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY location, population
ORDER BY TotalDeathCount desc;


--Show continents with the highest death count
Select 
	continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeathsXL
Where continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount desc;


--Death percentage by Global infection numbers
SELECT 
	SUM(CAST(new_cases AS INT)) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(CAST(new_cases AS INT)), 0) AS DeathPercentage
FROM PortfolioProject..CovidDeathsXL
WHERE continent <> ''
ORDER BY 1, 2



--Top 10 Countries by total vaccination
SELECT TOP 10
    dea.location,
    dea.population,
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) AS TotalVaccinations
FROM PortfolioProject..CovidDeathsXL dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
AND vac.new_vaccinations IS NOT NULL
GROUP BY dea.location, dea.population
ORDER BY TotalVaccinations DESC;


--Total Vaccinations by Continent
SELECT
    dea.continent,
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) AS TotalVaccinations
FROM PortfolioProject..CovidDeathsXL dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
AND vac.new_vaccinations IS NOT NULL
GROUP BY dea.continent
ORDER BY TotalVaccinations DESC;
