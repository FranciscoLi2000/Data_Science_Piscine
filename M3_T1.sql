
-- 1) Muestra todos los datos de la tabla city.
.print '------------------- Consulta 1 -------------------'
SELECT * FROM city;

-- 2) Muestra el "name", "continent" y "region" de la tabla country.
.print '------------------- Consulta 2 -------------------'
SELECT name, continent, region FROM country;

-- 3) Muestra los nombres dels paises y su "population" ordenados por su "LifeExpectancy" de mayor a menor.
.print '------------------- Consulta 3 -------------------'
SELECT Name, population FROM country ORDER BY LifeExpectancy DESC;

-- 4) Muestra el top10 de los paises de la consulta anterior.
.print '------------------- Consulta 4 -------------------'
SELECT Name, population FROM country ORDER BY LifeExpectancy DESC LIMIT 10;

-- 5) Muestra cuales son los "GovernmentForm" únicos que hay en la tabla country.
.print '------------------- Consulta 5 -------------------'
SELECT DISTINCT GovernmentForm FROM country;

-- 6) Muestra todos los lenguajes que se hablan en el mundo.
.print '------------------- Consulta 6 -------------------'
SELECT DISTINCT Language FROM countrylanguage;

