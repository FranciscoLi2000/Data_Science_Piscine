import re
import csv

# 打开文件
with open("world.sql.txt", "r", encoding="utf-8") as f:
    lines = f.readlines()

# 匹配 INSERT INTO city 的数据
insert_lines = [line for line in lines if line.startswith("INSERT INTO `city`")]

# 更强的正则表达式来提取数据项
pattern = re.compile(
        r"\((\d+),'(.*?)','(.*?)','(.*?)',(\d+)\)"
)

rows = []
for line in insert_lines:
    matches = pattern.findall(line)
    for match in matches:
        rows.append(match)

# 写入 CSV 文件
with open("city.csv", "w", newline='', encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["ID", "Name", "CountryCode", "District", "Population"])
    writer.writerows(rows)

