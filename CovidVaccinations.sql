-- --------------------------------------
-- COVID-19 Data for Zimbabwe on 20-04-21
-- --------------------------------------
--iso_code: ZWE (ISO code for Zimbabwe).
-- --------------------------------------
--continent: Africa (the continent to which Zimbabwe belongs).
-- --------------------------------------
--location: Zimbabwe (the specific country or region).
-- --------------------------------------
--date: 20-04-21 (the date of the observation).
-- --------------------------------------
--new_tests: 2493 (the number of new COVID-19 tests conducted on that day).
-- --------------------------------------
--total_tests: 474,882 (the total number of COVID-19 tests conducted up to that date).
-- --------------------------------------
--total_tests_per_thousand: 31.951 (total tests per thousand people).
-- --------------------------------------
--new_tests_per_thousand: 0.168 (new tests per thousand people on that day).
-- --------------------------------------
--new_tests_smoothed: 2126 (a smoothed or averaged value for new tests).
-- --------------------------------------
--new_tests_smoothed_per_thousand: 0.143 (smoothed or averaged new tests per thousand people).
-- --------------------------------------
--positive_rate: 0.037 (the proportion of positive results among the tested individuals).
-- --------------------------------------
--tests_per_case: 27.3 (the average number of tests conducted per confirmed case).
-- --------------------------------------
--tests_units: "tests performed" (the units in which testing data is reported).
-- --------------------------------------
--total_vaccinations: 325,007 (the total number of COVID-19 vaccine doses administered).
-- --------------------------------------
--people_vaccinated: 288,229 (the number of individuals who received at least one vaccine dose).
-- --------------------------------------
--people_fully_vaccinated: 36,778 (the number of individuals fully vaccinated with the required doses).
-- --------------------------------------
--new_vaccinations: 8,016 (the number of new vaccinations administered on that day).
-- --------------------------------------
--new_vaccinations_smoothed: 10,950 (a smoothed or averaged value for new vaccinations).
-- --------------------------------------
--total_vaccinations_per_hundred: 2.19 (total vaccinations per hundred people).
-- --------------------------------------
--people_vaccinated_per_hundred: 1.94 (people vaccinated per hundred people).
-- --------------------------------------
--people_fully_vaccinated_per_hundred: 0.25 (people fully vaccinated per hundred people).
-- --------------------------------------
--new_vaccinations_smoothed_per_million: 737 (smoothed or averaged new vaccinations per million people).
-- --------------------------------------
--stringency_index: 51.85 (a measure of government response stringency to the pandemic).
-- --------------------------------------
--population_density: 42.729 (population density in people per square kilometer).
-- --------------------------------------
--median_age: 19.6 (median age of the population).
-- --------------------------------------
--aged_65_older: 2.822 (percentage of the population aged 65 years and older).
-- --------------------------------------
--aged_70_older: 1.882 (percentage of the population aged 70 years and older).
-- --------------------------------------
--gdp_per_capita: 1,899.775 (Gross Domestic Product per capita in current international dollars).
-- --------------------------------------
--extreme_poverty: 21.4 (percentage of the population living in extreme poverty).
-- --------------------------------------
--cardiovasc_death_rate: 307.846 (cardiovascular disease death rate per 100,000 people).
-- --------------------------------------
--diabetes_prevalence: 1.82 (percentage of the population aged 20 to 79 with diabetes).
-- --------------------------------------
--female_smokers: 1.6 (percentage of female smokers).
-- --------------------------------------
--male_smokers: 30.7 (percentage of male smokers).
-- --------------------------------------
--handwashing_facilities: 36.791 (percentage of the population with access to basic handwashing facilities).
-- --------------------------------------
--hospital_beds_per_thousand: 1.7 (hospital beds per thousand people).
-- --------------------------------------
--life_expectancy: 61.49 (life expectancy at birth in years).
-- --------------------------------------
--human_development_index: 0.571 (the Human Development Index, a composite statistic of life expectancy, education, and income).
-- --------------------------------------


Select *
From PortfolioProject..CovidVaccinations


Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


-- Looking at Total Population vs Vaccinations
-- This query essentially retrieves specific information from both tables without any additional computations or transformations. It's a straightforward selection of columns.
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


-- The rolling sum provides a cumulative total of new vaccinations over time for each location,  providing additional insights into the cumulative effect of vaccination efforts over time. 
-- This can be particularly useful for tracking the progress of vaccination campaigns and understanding the overall vaccination coverage in different regions.
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Recursive Common Table Expression (CTE):
-- Some databases support recursive CTEs for calculating cumulative sums. Recursive CTEs are useful when dealing with hierarchical or sequential data.
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
