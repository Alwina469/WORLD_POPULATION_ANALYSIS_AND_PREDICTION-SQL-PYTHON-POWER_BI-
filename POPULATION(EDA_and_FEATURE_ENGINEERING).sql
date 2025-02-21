create database world_population;
use world_population;

 -- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
 
 create table population_data_staging
 like population_data;
 
 -- insert values in it 
 insert into population_data_staging
 select * from population_data;
 
 select * from population_data_staging;
 
 
 -- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- A. Remove Duplicates

     -- checking for duplicates 
     select `country/territory` , count(*) from population_data_staging
     group by `Country/Territory`
     having count(*)>1;
     
     -- There are no duplicate countries . there no duplicate data to delete
     

-- B. Standardizing Data ( finding issues in data and fixing it)

      -- no need to change datatypes. everything is perfect
      -- but do need to change the name of country/territory column
      
      alter table population_data_staging
      rename column `Country/Territory` to country;
      
      --  need to change the name of Area_(km²) column
      
      alter table population_data_staging
      rename column `Area_(km²)` to area;
      
      -- need to change the name of Density_(per_km²) column
      
      alter table population_data_staging
      rename column `Density_(per_km²)` to density;
      
      -- check for distinct continent
      
      select distinct continent from population_data_staging;

      -- only 6 continents are there is the data . ANTARCTICA is not there. 
      
      
      
      
-- C. Look at Null Values
   
   
   select sum( case when `rank` is null then 1 else 0 end),
sum( case when cca3 is null then 1 else 0 end),
sum( case when country is null then 1 else 0 end),
sum( case when capital is null then 1 else 0 end),
sum( case when continent is null then 1 else 0 end),
sum( case when 2022_population is null then 1 else 0 end),
sum( case when 2020_population is null then 1 else 0 end),
sum( case when 2015_population is null then 1 else 0 end),
sum( case when 2010_population is null then 1 else 0 end),
sum( case when 2000_population is null then 1 else 0 end),
sum( case when 1990_population is null then 1 else 0 end),
sum( case when 1980_population is null then 1 else 0 end),
sum( case when 1970_population is null then 1 else 0 end),
sum( case when area is null then 1 else 0 end),
sum( case when density is null then 1 else 0 end),
sum( case when growth_rate is null then 1 else 0 end),
sum( case when World_Population_Percentage is null then 1 else 0 end)
 from population_data_staging;

-- no null values present
 
 
 
 
 -- D. remove any columns and rows we need to
 
 -- no columns to remove . DATA IS CLEANED
 
 
 
 ----------- FEATURE ENGINEERING ------------
 
 -- A. Add growth category
 
      alter table population_data_staging
      add column growth_category varchar(20);
      
      -- add values in it 
       update population_data_staging
       set growth_category = case 
                             when growth_rate>=2 then "high growth"
							when growth_rate between 1 and 2 then "moderate growth"
                             else "low growth"
                             end;
 
 -- B. Add columns for POPULATON GROWTH RATE OVER DECADES
     
       alter table population_data_staging
		   
		   add column growth_2010s float ,
		   add column growth_2000s float , 
		   add column growth_1900s float ;
 
       update population_data_staging
       set growth_2010s = ((2020_population - 2010_population)/2010_population)*100 ,
           growth_2000s = ((2010_population - 2000_population)/2000_population)*100 ,
           growth_1900s = ((2000_population - 1990_population)/1990_population)*100 ;
           
           -- ( need to change column name it should not be growth_1900s but growth_1990s )
              
                alter table population_data_staging
                rename column growth_1900s to growth_1990s;
                
                
                
                
                
                
       
 
 
 
 
 
 
 
 
 
 
 
 
 
















       















     
 