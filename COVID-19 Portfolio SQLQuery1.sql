Select * 
From [COVID-19 Portfolio Project]..CovidDeaths$
Where continent is not null
order by 3,4

--Select * 
--From [COVID-19 Portfolio Project]..CovidVaccinations$
--order by 3,4

--Select data that is going to be used

Select Location, date, total_cases, new_cases, total_deaths, population
From [COVID-19 Portfolio Project]..CovidDeaths$
Where continent is not null
order by 1,2


--Looking at the Total Cases vs Total Deaths
--Shows likelihood of dying if you contract COVID in the US
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [COVID-19 Portfolio Project]..CovidDeaths$
Where location like '%states%'
Where continent is not null
order by 1,2

--Looking at the Total Cases vs Population
--Shows what percentage of population got COVID
Select Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
From [COVID-19 Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as
	PercentPopulationInfected
From [COVID-19 Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [COVID-19 Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Categorize by continent
--Showing continents with the highest death count per population 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [COVID-19 Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)), as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From [COVID-19 Portfolio Project]..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group By date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date)
	as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
From [COVID-19 Portfolio Project]..CovidDeaths$ dea
Join [COVID-19 Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE

With PopvsVac (Continent, Location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.Date)
	as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
From [COVID-19 Portfolio Project]..CovidDeaths$ dea
Join [COVID-19 Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--Creating view to store data for data visualizations on tableau

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.Date)
	as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
From [COVID-19 Portfolio Project]..CovidDeaths$ dea
Join [COVID-19 Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select*
From PercentPopulationVaccinated