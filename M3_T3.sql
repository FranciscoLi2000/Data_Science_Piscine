
-- 1) Muestra la cuantidad de ciudades que hay en la tabla city.
.print '------------------- Consulta 1 -------------------'
SELECT COUNT(*) FROM city;

-- 2) Muestra la cuantidad de ciudades que da cada "countryCode" de la tabla city.
.print '------------------- Consulta 2 -------------------'
SELECT COUNT(*) FROM city GROUP BY CountryCode;

-- 3) Muestra la "population" maxima de cada "countryCode" de la tabla city.
.print '------------------- Consulta 3 -------------------'
SELECT MAX(Population) FROM city GROUP BY CountryCode;

-- 4) Muestra la "lifeExpentacy" promedio de cada continente y región de la tabla country.
.print '------------------- Consulta 4 -------------------'
SELECT AVG(LifeExpectancy) FROM country GROUP BY Continent, Region;

-- 5) Muestra la "population" total de cada continente.
.print '------------------- Consulta 5 -------------------'
SELECT SUM(Population) FROM country GROUP BY Continent;

-- 6) Muestra la "surfaceArea" mas pequena de cada región de cada continente.
.print '------------------- Consulta 6 -------------------'
SELECT MIN(SurfaceArea) FROM country GROUP BY Continent, Region;

-- 7) Muestra cuantos païses en cada continente.
.print '------------------- Consulta 7 -------------------'
SELECT COUNT(*) FROM country GROUP BY Continent;

-- 8) Muestra los continentes que tienen mas de 50 paises.
.print '------------------- Consulta 8 -------------------'
SELECT Continent FROM country GROUP BY Continent HAVING COUNT(*) > 50;

-- 9) Muestra la cuantidad de paises por "language" y por "IsOfficial".
-- Es decir, cuantos paises hablan una lengua en función de si es oficial o no.
.print '------------------- Consulta 9 -------------------'
SELECT COUNT(*) FROM countrylanguage
GROUP BY Language, IsOfficial
ORDER BY Language, IsOfficial DESC;

