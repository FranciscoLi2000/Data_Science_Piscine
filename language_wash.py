import re
import csv

pattern = re.compile(
        r"\('([A-Z]{3})','(.*?)','([TF])',([\d.]+)\)"
)

rows = []
with open("world.sql.txt", "r", encoding="utf-8") as f:
    for line in f:
        if line.startswith("INSERT INTO `countrylanguage`"):
            matches = pattern.findall(line)
            for match in matches:
                rows.append(list(match))

with open("countrylanguage.csv", "w", newline='', encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["CountryCode", "Language", "IsOfficial", "Percentage"])
    writer.writerows(rows)

