import re
import csv

# 只提取 Code, Name, Continent, Region, Population
pattern = re.compile(
        r"\('([A-Z]{3})','(.*?)','(.*?)','(.*?)',\d+\.?\d*,(NULL|\d+),(\d+),.*?\)"
)

rows = []
with open("world.sql.txt", "r", encoding="utf-8") as f:
    for line in f:
        if line.startswith("INSERT INTO `country`"):
            matches = pattern.findall(line)
            for match in matches:
                code, name, continent, region, indep_year, population = match
                indep_year = indep_year if indep_year != 'NULL' else ''
                rows.append([code, name, continent, region, indep_year, population])

with open("country.csv", "w", newline='', encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["Code", "Name", "Continent", "Region", "IndepYear", "Population"])
    writer.writerows(rows)

