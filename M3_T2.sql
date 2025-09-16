
-- 1) Muestra todos los datos de las ciudades que comenzan por "al-", de la tabla city.
.print '------------------- Consulta 1 -------------------'
SELECT * FROM city WHERE Name LIKE 'Al-%';

-- 2) De la consulta anterior, muestra los "countryCode" únicos.
.print '------------------- Consulta 2 -------------------'
SELECT DISTINCT CountryCode FROM city WHERE Name LIKE 'Al-%';

-- 3) Muestra el "name" de las ciudades que tienen menos de 10000 personas de "population".
.print '------------------- Consulta 3 -------------------'
SELECT Name FROM city WHERE population < 10000;

-- 4) Muestra las ciudades de los "countryCode" AUS, DOM, GMB y SLV.
.print '------------------- Consulta 4 -------------------'
SELECT Name FROM city WHERE CountryCode IN ('AUS', 'DOM', 'GMB', 'SLV');

-- 5) Muestra todos los datos de los paises que tienen entre 70 y 80 anyos de "lifeExpentancy".
.print '------------------- Consulta 5 -------------------'
SELECT * FROM country WHERE LifeExpectancy BETWEEN 70 AND 80;

-- 6) Muestra los nombres de los paises que estan en el continente europeo y en la región nòrdica.
.print '------------------- Consulta 6 -------------------'
SELECT Name FROM country WHERE Continent = 'Europe' AND Region = 'Nordic Countries';

-- 7) Muestra los 3 paises con mas "lifeExpentancy" del grupo de paises de Europa baltica y nord amèrica carib.
.print '------------------- Consulta 7 -------------------'
SELECT Name FROM country
WHERE Region IN ('Baltic Countries', 'Caribbean')
ORDER BY LifeExpectancy DESC
LIMIT 3;

-- 8) Muestra los paises que comenzan por letra "i" o comenzan por letra "o".
.print '------------------- Consulta 8 -------------------'
SELECT Name FROM country
WHERE Name LIKE 'I%' OR Name LIKE 'O%';

-- 9) Muestra todos los lenguajes que se hablan en el mundo (que son lenguaje oficial en su país).
.print '------------------- Consulta 9 -------------------'
SELECT DISTINCT Language
FROM countrylanguage
WHERE IsOfficial = 'T';

