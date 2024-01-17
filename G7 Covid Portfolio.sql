Select *
From g7coviddeaths
Order by 3,4;

Select *
From g7Vaccinations
Order by 3,4;

-- data I am going to use
Select location, date, total_cases, new_cases, total_deaths, population
From g7coviddeaths
Order by 1,2;

-- Looking at Total Cases and Total Deaths
-- shows likelihood of dying if you contract covid in those countries
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From g7coviddeaths
Where location like '%states%'
Order by 1,2;

-- Looking at Total Cases vs Population
-- Show what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From g7coviddeaths
Where location like '%ca%'
Order by 1,2; 

-- Looking at Countries with the highest infection rate compared to Population among G7

Select location, Max(total_cases), population, Max((total_cases/population))*100 as PercentPopulationInfected
From g7coviddeaths
-- Where location like '%ca%'
Group by location, population
Order by PercentPopulationInfected Desc;

-- Showing countries with Highest death count per population

Select location, Max(total_deaths) as TotalDeathCount
From g7coviddeaths
-- Where location like '%ca%'
Group by location
Order by TotalDeathCount Desc;

-- G7 Cases
Select sum(new_cases), sum(new_deaths), sum(new_deaths)/sum(new_cases)*100 as TotalDeathPercentage
From g7coviddeaths
-- Where location like '%states%'
-- Group by date
Order by 1,2;

-- Looking at Total Population vs Vaccination

With PopvsVac(location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) Over (partition by d.location Order by d.location, d.date) as 'RollingPeopleVaccinated' 
 -- ,(RollingPeopleVaccinated/population) * 100
From G7coviddeaths d
Join G7Vaccinations v
	ON d.location = v.location
    And d.date = v.date
    And d.iso_code = v.iso_code
-- Order by 1,2
)
-- USE CTE

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVAc; 

-- temp Table

Drop Temporary Table if exists PercentPopulationVaccinated;
Create Temporary Table PercentPopulationVaccinated
(
location text(255),
date datetime,
population int,
new_vaccinations int,
RollingPeopleVaccinated int
);

Insert into PercentPopulationVaccinated
Select d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) Over (partition by d.location Order by d.location, d.date) as 'RollingPeopleVaccinated' 
 -- ,(RollingPeopleVaccinated/population) * 100
From G7coviddeaths d
Join G7Vaccinations v
	ON d.location = v.location
    And d.date = v.date
    And d.iso_code = v.iso_code;
-- Order by 1,2

Select *, (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated; 

-- Creating view to store data for visualizations

Create View PercentPopulationVaccinated as
Select d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) Over (partition by d.location Order by d.location, d.date) as 'RollingPeopleVaccinated' 
 -- ,(RollingPeopleVaccinated/population) * 100
From G7coviddeaths d
Join G7Vaccinations v
	ON d.location = v.location
    And d.date = v.date
    And d.iso_code = v.iso_code;
-- Order by 1,2



