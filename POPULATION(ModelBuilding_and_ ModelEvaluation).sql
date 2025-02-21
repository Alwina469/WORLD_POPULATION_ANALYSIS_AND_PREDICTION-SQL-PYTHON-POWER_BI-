-- MODEL BUILDING AND MODEL EVALUATION

      -- WE WANT TO PREDICT FUTURE POPULATON GROWTH USING HISTORICAL DATA 
      -- ESTIMATES FUTURE VALUES BASED ON PAST TRENDS
      -- WE COMPARE OUR PREDICTION WITH ACTUAL DATA TO SEE HOW ACCURATE OUE MODEL IS 
      
      
-- A. CALCULATE AVERAGE YEARLY GROWTH RATE (how much populaton grew from 2010 - 2022)
	
      select country , ((2022_population - 2010_population)/12) as avg_yearly_growth 
      from population_data_staging;
      
 -- B . PREDICT FUTURE POPULATION (EG:2030,2024)
        -- FUTURE POPULATION = LATEST POPULATION +(YEARLY GROWTH * YEARS AHEAD)
        
     with growth_data as( 
               select country ,`2022_population`, ((`2022_population` - `2010_population`)/12) as avg_yearly_growth 
      from population_data_staging)
      select country , `2022_population` as current_population ,
						`2022_population`+ (avg_yearly_growth * 8) as population_2030 ,
                        `2022_population`+(avg_yearly_growth *18) as population_2040 
      from growth_data;                   
                        
                        
-- C . EVALUATE MODEL ACCURACY
        -- compare past predictions with actual values
        
        
	   with growth_data as(
                     select country , 2010_population , 2020_population , 2022_population,
                     ((2022_population-2010_population)/12) avg_yearly_growth
                     from population_data_staging )
                     
		select country , `2020_population` as actual_population_2020 ,
						(`2010_population`+ (avg_yearly_growth * 10)) as predicted_population_2020 ,
                        `2022_population` as actual_population_2022 ,
                        (`2010_population`+ (avg_yearly_growth *12)) as predicted_population_2022,
                        
                        abs(`2020_population` - (`2010_population`+ (avg_yearly_growth * 10))) error_2020,
                        abs(`2022_population` - (`2010_population`+ (avg_yearly_growth * 12))) error_2022
      from growth_data; 
      
      
      
-- D . CREATING A NEW TABLE FOR PREDICTIONS ( FRO 2020,2022,2023,2040)
      
      create table population_predictions(
               country text ,
               year int , 
               actual_population bigint,
               predicted_population bigint
               );

      -- inserting data into the table 
		-- for year 2020
        
          insert into population_predictions ( country , year , actual_population , predicted_population)
          select
                country , 2020 as year , 2020_population , (2010_population+(avg_yearly_growth * 10)) as predicted_population
                from( 
                     select country , 2020_population , 2010_population ,
                     ((2022_population-2010_population)/12 ) avg_yearly_growth 
                     from population_data_staging) growth_data;
                     
		  
          -- for year 2022
          
          insert into population_predictions ( country , year , actual_population , predicted_population)
          select
                country , 2022 as year , 2022_population , (2010_population+(avg_yearly_growth * 12)) as predicted_population
                from( 
                     select country , 2022_population , 2010_population ,
                     ((2020_population-2010_population)/10 ) avg_yearly_growth 
                     from population_data_staging) growth_data;
				
            -- for year 2030
            
		  insert into population_predictions ( country , year , actual_population , predicted_population)
          select
                country , 2030 as year , NULL AS ACTUAL_POPULATION , (2022_population+(avg_yearly_growth * 8)) as predicted_population
                from( 
                     select country , 2022_population , 2010_population ,
                     ((2022_population-2010_population)/12 ) avg_yearly_growth 
                     from population_data_staging) growth_data;
                     
			
            -- fro year 2040
           insert into population_predictions ( country , year , actual_population , predicted_population)
          select
                country , 2040 as year , NULL AS ACTUAL_POPULATION , (2022_population+(avg_yearly_growth * 18)) as predicted_population
                from( 
                     select country , 2022_population , 2010_population ,
                     ((2022_population-2010_population)/12 ) avg_yearly_growth 
                     from population_data_staging) growth_data;          
                     
	-- E .  VERIFY THE TABLE

           select * from population_predictions;

      
      
      
   
                        
                        
	 
      