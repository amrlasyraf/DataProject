-- Viewing both of the excel table
Select * 
From Covid..CovidDeaths
Where continent is not null

Select * 
From Covid..CovidVaccinations

-- Data selection
Select Location, date, total_cases, new_cases, total_deaths, population
From Covid..CovidDeaths
Where continent is not null

-- Total Cases vs Total Death
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Pct
From Covid..CovidDeaths
Where location like '%Malaysia%' and continent is not null

-- Total Cases vs Population
Select Location, date, total_cases, Population, (total_cases/population)*100 as Covid_Pct
From Covid..CovidDeaths
Where location like '%Malaysia%' and continent is not null

-- Country with Highest Infection Rate
Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PctPopulationInfected
From Covid..CovidDeaths
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

-- Country with Highest Death Rate
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Covid..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Continent with Highest Death Rate
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From Covid..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- General Numbers (Daily)
Select date, SUM(new_cases) as TotalDailyCases, SUM(cast(new_deaths as int)) as TotalDailyDeath, SUM(new_cases)/SUM(cast(new_deaths as int))
as DeathPct
From Covid..CovidDeaths
Where continent is not null
Group by date

-- General Numbers (Total)
Select SUM(new_cases) as TotalDailyCases, SUM(cast(new_deaths as int)) as TotalDailyDeath, SUM(new_cases)/SUM(cast(new_deaths as int))
as DeathPct
From Covid..CovidDeaths
Where continent is not null

-- Total Population vs Vaccinations
With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, Cumulative_Vaccination) as
(
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (Partition 
by dth.location order by dth.location, dth.date) as Cumulative_Vaccination
From Covid..CovidDeaths dth
join Covid..CovidVaccinations vac
	on dth.location = vac.location and dth.date = vac.date
where dth.continent is not null
)
Select *, (Cumulative_Vaccination/Population)*100 as Pct_Vaccination
From PopVsVac

-- 