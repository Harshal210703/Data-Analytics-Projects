-- -------------------------------------
-- COVID-19 Data for Ireland on 05-04-20
-- -------------------------------------
-- iso_code: IRL (ISO code for Ireland).
-- -------------------------------------
--continent: Europe (the continent to which Ireland belongs).
-- -------------------------------------
--location: Ireland (the specific country or region).
-- -------------------------------------
--date: 05-04-20 (the date of the observation).
-- -------------------------------------
--population: 4,937,796 (the population of Ireland).
-- -------------------------------------
--total_cases: 4,994 (the total confirmed cases of COVID-19 up to that date).
-- -------------------------------------
--new_cases: 390 (the number of new confirmed cases reported on that specific day).
-- -------------------------------------
--new_cases_smoothed: 339.857 (a smoothed or averaged value for new cases, likely to reduce daily fluctuations).
-- -------------------------------------
--total_deaths: 158 (the total number of deaths due to COVID-19 up to that date).
-- -------------------------------------
--new_deaths: 21 (the number of new deaths reported on that specific day).
-- -------------------------------------
--new_deaths_smoothed: 16 (a smoothed or averaged value for new deaths, likely to reduce daily fluctuations).
-- -------------------------------------
--total_cases_per_million: 1,011.382 (total confirmed cases per million people).
-- -------------------------------------
--new_cases_per_million: 78.983 (new confirmed cases per million people on that day).
-- -------------------------------------
--new_cases_smoothed_per_million: 68.828 (smoothed or averaged new cases per million people).
-- -------------------------------------
--total_deaths_per_million: 31.998 (total deaths per million people).
-- -------------------------------------
--new_deaths_per_million: 4.253 (new deaths per million people on that day).
-- -------------------------------------
--new_deaths_smoothed_per_million: 3.24 (smoothed or averaged new deaths per million people).
-- -------------------------------------
--reproduction_rate: 1.55 (the estimated reproduction rate, representing the average number of secondary infections produced by one infected individual).
-- -------------------------------------
--icu_patients: 139 (the number of patients in Intensive Care Units).
-- -------------------------------------
--icu_patients_per_million: 28.15 (ICU patients per million people).
-- -------------------------------------
--hosp_patients: 702 (the number of hospitalised patients).
-- -------------------------------------
--hosp_patients_per_million: 142.169 (hospitalised patients per million people).
-- -------------------------------------
--weekly_icu_admissions: 3.979 (the number of weekly ICU admissions).
-- -------------------------------------
--weekly_icu_admissions_per_million: 0.806 (weekly ICU admissions per million people).
-- -------------------------------------
--weekly_hosp_admissions: 165.109 (the number of weekly hospital admissions).
-- -------------------------------------
--weekly_hosp_admissions_per_million: 33.438 (weekly hospital admissions per million people).
-- -------------------------------------


Select *
From PortfolioProject..CovidDeaths
order by 3, 4


--Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'India'
and continent is not null


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null


--Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc


-- Showing Continents with Highest Death Count per Population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Showing Continents with Highest Death Count per Population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
-- Casting new_deaths because some aggregrate functions are not supported by features of nvarchar dtype like 'SUM'
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
Group By date