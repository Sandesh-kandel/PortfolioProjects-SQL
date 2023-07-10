SELECT *
FROM PortfolioProject.. CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject.. CovidVaccinations
ORDER BY 3,4

--selecting the data that we are going to be using
SELECT date,location, total_cases, total_deaths, (TRY_CONVERT(decimal, total_deaths) / NULLIF(TRY_CONVERT(decimal, total_cases), 0)) * 100 AS Death_Rate
FROM PortfolioProject.. CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2


--Looking at the total cases vs the population

SELECT date,location, total_cases, population, (TRY_CONVERT(decimal, total_cases) / NULLIF(TRY_CONVERT(decimal, population), 0)) * 100 AS PopulationWith_Covid
FROM PortfolioProject.. CovidDeaths
--WHERE location like '%states%'
ORDER BY 1,2

--highest infecton rate countries, compared to populattion

SELECT location, max(total_cases) as Highest_Inf_Count, population, max((TRY_CONVERT(decimal, total_cases) / NULLIF(TRY_CONVERT(decimal, population), 0))) * 100 AS PopulationWith_Covid_Percentage
FROM PortfolioProject.. CovidDeaths
--WHERE location like '%states%'
GROUP by location, population 
ORDER BY PopulationWith_Covid_Percentage desc


--countries with high death count per population


SELECT location, max(total_deaths) as Highest_Inf_Count, population, max((TRY_CONVERT(decimal, total_deaths) / NULLIF(TRY_CONVERT(decimal, population), 0))) * 100 AS Population_With_Covid_Deaths
FROM PortfolioProject.. CovidDeaths
--WHERE location like '%states%'
GROUP by location, population 
ORDER BY Population_With_Covid_Deaths desc

--HIghest deaht rate by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where location is not null 
Group by location
order by TotalDeathCount desc

--GLobal Numbers

SELECT  
       SUM(TRY_CONVERT(int, new_cases)) AS total_cases,
       SUM(TRY_CONVERT(int, new_deaths)) AS total_deaths,
       CASE 
           WHEN SUM(TRY_CONVERT(int, new_cases)) = 0 THEN 0 -- To handle division by zero
           ELSE (SUM(TRY_CONVERT(int, new_deaths)) * 100.0) / NULLIF(SUM(TRY_CONVERT(int, new_cases)), 0) 
       END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;



-- Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, CONVERT(bigint, dea.population), vac.new_vaccinations,
           SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
       (RollingPeopleVaccinated * 100.0) / NULLIF(Population, 0) AS VaccinationPercentage
FROM PopvsVac;


-- Creating View to store data for later visualizations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 












