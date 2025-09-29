-- 1) Mostra el nom del país i les ciutats que hi ha a Andorra i Belize.

-- En aquest cas, fer-ho amb inner join o left join és el mateix
-- ja que tots dos països estan a la taula de "city" i "country" 

select country.Name NombrePais, city.Name NombreCiudad
from world.country inner join world.city on country.code=city.countrycode
where country.Name in ("Andorra","Belize");

select country.Name NombrePais, city.Name NombreCiudad
from world.country left join world.city on country.code=city.countrycode
where country.Name in ("Andorra","Belize");

-- 2) Mostra el nom del país i la quantitat de llengües que es parlen en els dos mateixos països (de la consulta anterior).

-- En aquest cas, fer-ho amb inner join o left join és el mateix
-- ja que tots dos països estan a la taula de "countrylanguage" i "country" 

select country.Name NombrePais, count(countrylanguage.Language)
from world.country inner join world.countrylanguage on country.code=countrylanguage.countrycode
where country.Name in ("Andorra","Belize")
group by country.Name;

select country.Name NombrePais, count(countrylanguage.Language)
from world.country left join world.countrylanguage on country.code=countrylanguage.countrycode
where country.Name in ("Andorra","Belize")
group by country.Name;

-- 3) Mostra el nom del país i les llengües que es parlen a l'Antàrtica i a Xile.

	-- En aquest cas, fer-ho amb inner join o left join té diferències ja que l'Antàrtida no és a la taula de "countrylanguage", per la qual cosa si ho fem amb inner join no ens apareix en el resultat. 
	select country.Name NombrePais, countrylanguage.Language
	from world.country left join world.countrylanguage on country.code=countrylanguage.countrycode
	where country.Name in ("Antarctica","Chile");

	select country.Name NombrePais, countrylanguage.Language
	from world.country inner join world.countrylanguage on country.code=countrylanguage.countrycode
	where country.Name in ("Antarctica","Chile");

-- 4) Digues quants països tenen dades a la taula "country" però no tenen dades a la taula de "countryLanguage".
	select count(*) NumPaisesSinIdioma
	from world.country left join world.countrylanguage on country.code=countrylanguage.countrycode
	where countrylanguage.Language is null;

-- 5) Mostra el nom del país amb on es parlen més llengües.

	-- Si ho fem només amb JOINs aconseguim un resultat estàtic. En aquest cas hi ha 5 països on es parla el major nombre de llengües. Perquè surtin tots de forma dinàmica caldria fer servir subqueries (veure següent solució)
	select country.Name NombrePais, count(countrylanguage.Language)
	from world.country inner join world.countrylanguage on country.code=countrylanguage.countrycode
	group by country.Name
	order by  count(countrylanguage.Language) desc
	limit 1;
	
    -- Solució dinàmica usant subqueries
	SELECT COUNTRY.CODE, COUNTRY.NAME, COUNT(COUNTRYLANGUAGE.LANGUAGE) AS CONTLENGUAS
	FROM COUNTRY INNER JOIN COUNTRYLANGUAGE ON COUNTRY.CODE = COUNTRYLANGUAGE.COUNTRYCODE 
	GROUP BY COUNTRY.CODE, COUNTRY.NAME
	HAVING COUNT(COUNTRYLANGUAGE.LANGUAGE)
	= (
			SELECT COUNT(LANGUAGE) AS CUENTA_LANGUAGE
			FROM COUNTRYLANGUAGE 
			GROUP BY countryCode
			order by CUENTA_LANGUAGE DESC
			limit 1
			)
	ORDER BY COUNTRY.NAME;

-- 6) Mostra el nom del país amb més "population".

	-- En aquest cas només hi ha un país amb màxima població, per la qual cosa ho podem fer de forma simple. Però si es vol fer de forma dinàmica veure següent solució.
	select Name, population
	from world.country
	order by population desc
	limit 1;

    -- Solució dinàmica usant subqueries
	SELECT name, Population
	FROM country
	WHERE Population = (
		SELECT MAX(Population)
		FROM country);

-- 7) Mostra la "population" del país "Guadeloupe" (però, en lloc d'agafar la dada de la taula country, suma les "population" de totes les seves ciutats).
	select country.Code , country.Name, sum(city.population) suma_population
	from world.country country join world.city city on country.Code = city.countryCode
	where country.Name="Guadeloupe"
	group by country.Code, country.Name;

-- 8) Mostra en una mateixa taula, el nom del país, els noms de les seves ciutats, la seva "population" i els seus "language" (del país "Guadeloupe").
	select country.Code , country.Name , city.Name, city.population,  countrylanguage.Language
	from ((country join city on country.Code = city.countryCode)  join countrylanguage on country.Code = countrylanguage.countryCode)
	where country.Name="Guadeloupe";

-- 9) Suma la "population" de la consulta anterior (a mà) i compara-la amb la "population" de la consulta núm. 7. Són iguals? Què està passant?
	
    -- Les dades de la ciutat i els idiomes no es poden analitzar junts ja que estan a nivell de país.
    -- És a dir, no podem saber amb les taules que tenim els idiomes que es parlen per a cada ciutat.
    -- Això provoca duplicats si intentem treure en la mateixa consulta camps de les dues taules.




---------------------------

-- M4T2 (UNIONS)

--select * from union.bbdd_union_nens
--union
--select * from union.bbdd_union_nenes;
-- resultado 21

--select * from union.bbdd_union_nens
--union all
--select * from union.bbdd_union_nenes;
-- resultado 22
