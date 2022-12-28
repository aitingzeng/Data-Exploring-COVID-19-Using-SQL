Select *
From ProfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From ProfolioProject..CovidVaccinations
--order by 3, 4

Select location, date, total_cases, new_cases, total_deaths, population
From ProfolioProject..CovidDeaths
where continent is not null
order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From ProfolioProject..CovidDeaths
where location like '%australia%'
and continent is not null
order by 1,2

Select location, date, population, total_cases, (total_cases/population)*100 as PercenPopulationInfected
From ProfolioProject..CovidDeaths
--where location like '%australia%'
where continent is not null
order by 1,2

Select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercenPopulationInfected
From ProfolioProject..CovidDeaths
--where location like '%australia%'
where continent is not null
Group by location, population
order by PercenPopulationInfected desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProfolioProject..CovidDeaths
--where location like '%australia%'
where continent is not null
Group by continent
order by TotalDeathCount desc 



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProfolioProject..CovidDeaths
--where location like '%australia%'
where continent is not null
--group by date
order by 1,2



With PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject..CovidDeaths dea
join ProfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


DROP Table if exists #PercentPopularVaccinated
Create Table #PercentPopularVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopularVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject..CovidDeaths dea
join ProfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopularVaccinated



Create View PercentPopularVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProfolioProject..CovidDeaths dea
join ProfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopularVaccinated