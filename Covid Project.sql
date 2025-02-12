--select location, date,total_cases, new_cases, total_deaths, population
--from CovidDeaths
--where continent is not null
--order by 1,2;

-- Looking at Total cases vs Total deaths
-- Likilyhood of dying

select location, date,total_cases, total_deaths, cast(total_deaths as float) / total_cases *100 as DeathPercentage
from CovidDeaths
where location like '%India'
order by 1,2

-- Looking at Total cases vs Population

select location, date,total_cases,population,cast(total_cases as float) / population*100 as DeathPercentage
from CovidDeaths
where location like '%India'
order by 1,2

--Looking at countries at highest infaction rate

select location, population,max(total_cases) as HighestInfactionCount, max(cast(total_cases as float) / population*100) as PercentPopulationInfected
from CovidDeaths
where continent is not null
group by location, population
order by 4 desc

--Looking at countries at highest death rate

select continent, max(total_deaths) as HighestDeathCount
from CovidDeaths
where continent is not null
group by continent
order by 2 desc

--Continents with highest death count per population

select continent,max(total_deaths) as HighestDeathCount, max(cast(total_deaths as float) / population*100) as PercentPopulationDeath
from CovidDeaths
where continent is not null
group by continent
order by 3 desc

--Global Numbers

select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(cast(new_deaths as float)) / sum(new_cases) *100 as DeathPercentage
from CovidDeaths
--where location like '%India'
where continent is not null
--group by date
order by 1,2


--Join Death and Vaccination table and look population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollongPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



--CTE

with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollongPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

select *, RollingPeopleVaccinated/Population*100
from PopvsVac


--TempTable

drop table if exists #PercentPopVaccinated
create table #PercentPopVaccinated
(
Continent nvarchar(50), Location nvarchar(50), Date date, Population bigint, New_Vaccinations nvarchar(50), RollingPeopleVaccinated numeric)

insert into #PercentPopVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollongPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, RollingPeopleVaccinated/Population*100
from #PercentPopVaccinated



--Creating Views

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollongPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


create view GlobalNumbers as
select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(cast(new_deaths as float)) / sum(new_cases) *100 as DeathPercentage
from CovidDeaths
--where location like '%India'
where continent is not null
--group by date



