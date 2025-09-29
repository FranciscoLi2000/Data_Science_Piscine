-- 1) Mostra el nom del país més gran de cada continent.

	-- Subquery al WHERE (filtre)
		-- Opció amb 2 camps al where
		select name
		from country
		where
			(continent, surfacearea) in
			(	select continent, max(surfacearea)
				from country
				group by continent);
			
		-- Opció amb 1 camp al where
		select name
		from country
		where
			surfacearea =
			(	select max(surfacearea)
				from country
				group by continent);
			
	-- Subquery al FROM
	select name 
	from country left join 
		(select continent, max(surfacearea) maxsurfacearea
			from country
			group by continent) maxsurfaceareaporcontinente
		on (country.continent = maxsurfaceareaporcontinente.continent)
	where SurfaceArea = maxsurfacearea;
    
	-- Subquery correlacionada
    SELECT Name PaisesMasGrandes
	FROM country T1
	WHERE SurfaceArea = (SELECT MAX(SurfaceArea)
					 FROM country T2
                     WHERE T1.continent = T2.continent)
	ORDER BY Continent;

-- 2) Mostra el nom del pais i el nom de la ciutat que te menys habitants de cada país.

	-- Subquery al WHERE (filtre)
		-- Opció amb 2 camps al where
		select country.Name 'nombre país', city.name 'nombre ciudad'
		from city join country on city.countrycode = country.code
		where (countrycode, city.population) in
		(select countrycode, min(city.population)
		from city
		group by countrycode);
    
		-- ERROR! En aquest cas no es pot fer amb un únic camps al filtre ja que surten més països
		select country.Name 'nombre país', city.name 'nombre ciudad'
		from city join country on city.countrycode = country.code
		where city.population in
		(select  min(city.population)
		from city
		group by countrycode);

	-- Subquery al FROM
	select country.Name 'nombre país', city.name 'nombre ciudad'
	from 	city 	join country on city.countrycode = country.code
					join (select countrycode, min(city.population) minpopulation
							from city
							group by countrycode) minpopulationporciudad on country.code = minpopulationporciudad.CountryCode
	where city.population = minpopulation
	order by 1;
    
    -- Subquery correlacionada
    SELECT COUNTRY.NAME Pais, CITY.NAME CiudadMenosHab
	FROM CITY JOIN COUNTRY
	ON CITY.COUNTRYCODE = COUNTRY.CODE
	WHERE CITY.POPULATION = (SELECT MIN(POPULATION)
						FROM CITY MINIMO
                        WHERE MINIMO.COUNTRYCODE = CITY.COUNTRYCODE)
	ORDER BY COUNTRY.NAME;

-- 3) Mostra els països que estàn per sobre de la mitja de "lifeExpectancy" de cada continent

	-- En aquest cas no és possible fer-la al WHERE (filtre)

    -- Subquery al FROM
	select country.continent, name 'nombre país', lifeexpectancy 'esperanza de vida país', avglifeexpectancy 'media esperanza de vida continente'
	from country left join 
		(select continent, avg(lifeexpectancy) avglifeexpectancy
		from country
		group by continent) mediaesperanzadevidaporcontinente
		on (country.Continent=mediaesperanzadevidaporcontinente.continent)
	where lifeexpectancy > avglifeexpectancy
	order by 2;

	-- Subquery correlacionada
	SELECT A.CONTINENT, A.NAME, A.LIFEEXPECTANCY
	FROM
		COUNTRY A
	WHERE
		A.LifeExpectancy > (SELECT AVG(LIFEEXPECTANCY)
							FROM
								country B
							WHERE A.Continent = B.CONTINENT)
							-- no hace falta group by porque ya se está igualando por el continente
	order by 2;
