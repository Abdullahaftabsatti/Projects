-- creating a temp table "clean_deaths" from covid_deaths
create temporary table clean_deaths
select location, date, total_cases, total_deaths, population
from covid_deaths
where continent <> '';
-- viewing clean_deaths table
select *
from clean_deaths;

-- Total cases vs total deaths per day
select location, date, total_cases, total_deaths, round(total_deaths/total_cases*100,2) as percent_deaths
from clean_deaths
where location like '%states%';

-- total cases vs population per day
select location, date, total_cases, population, round(total_cases/population*100,2) as percent_cases
from clean_deaths
where location like '%states%';

-- Countries infection max rate with respect to population
select location, population,
	   max(total_cases) as max_cases_reported, max(total_cases/population)*100 as infection_rate
from clean_deaths
group by location
order by infection_rate desc;

-- Total deaths for each country
select location, population, 
       max(total_deaths) max_deaths_reported,
	   max(total_deaths/population*100) as death_rate
from clean_deaths
group by location
order by death_rate desc;

-- Total deaths by continent
select continent, population, max(total_deaths) as death_count
from covid_deaths
where continent <> ''
group by continent
order by death_count desc;

-- Global numbers for each date
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
       sum(new_deaths)/sum(new_cases)*100 as deathsvs_cases
from covid_deaths
where continent <> ''
group by date;

-- joining both tables
select dea.continent, dea.location, dea.date, dea.population, 
       vac.new_vaccinations,
	   sum(new_vaccinations) over (partition by dea.location order by location, date)
       as vaccinations_rollingcount
from covid_deaths dea 
join covid_vaccinaitons vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent <> ''
order by location;

-- total population vs total people vaccinated
with popVSvac (continent, location, date, population,
	 new_vaccinations, vaccinations_rollingcount) as
     (
select dea.continent, dea.location, dea.date, dea.population, 
       vac.new_vaccinations,
	   sum(new_vaccinations) over (partition by dea.location order by location, date)
       as vaccinations_rollingcount
from covid_deaths dea 
join covid_vaccinaitons vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent <> '')
-- order by location)
select *, (vaccinations_rollingcount/population)*100
from popVSvac;

-- temp table
create  table percent_population_vaccinated
(
continent varchar(100),
location varchar(100),
date date,
population integer,
new_vaccinations integer,
vaccinations_rollingcount integer
);
insert into percent_population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, 
       vac.new_vaccinations,
	   sum(new_vaccinations) over (partition by dea.location order by location, date)
       as vaccinations_rollingcount
from covid_deaths dea 
join covid_vaccinaitons vac
     on dea.location = vac.location
     and dea.date = vac.date;
-- where dea.continent <> ''
-- order by location)

select *, (vaccinations_rollingcount/population)*100 as percent_vaccinated
from percent_population_vaccinated;

-- creating view
create view percent_population_vaccinated2 as
select dea.continent, dea.location, dea.date, dea.population, 
       vac.new_vaccinations,
	   sum(new_vaccinations) over (partition by dea.location order by location, date)
       as vaccinations_rollingcount
from covid_deaths dea 
join covid_vaccinaitons vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent <> ''
-- order by location;


     



