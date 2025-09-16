#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Cleans table `countrylanguage` -> countrylanguage_full.csv
# Input: /mnt/data/world.sql.txt
# Output: /mnt/data/countrylanguage_full.csv
# Error log: /mnt/data/countrylanguage_full.err

import re, csv, sys, os

# (same helper functions as above; script is self-contained, with table="countrylanguage")
# The resulting CSV header will reflect the CREATE TABLE column order (CountryCode, Language, IsOfficial, Percentage)

INPUT = r"world.sql.txt"

def extract_create_columns(table_name, sql_text):
    m = re.search(r"CREATE TABLE\s+`%s`\s*\((.*?)\)\s*ENGINE=" % re.escape(table_name), sql_text, re.S | re.I)
    if not m:
        m = re.search(r"CREATE TABLE\s+`%s`\s*\((.*?)\)\s*\);" % re.escape(table_name), sql_text, re.S | re.I)
        if not m:
            return None
    body = m.group(1)
    cols = []
    for line in body.splitlines():
        line = line.strip().rstrip(',')
        cm = re.match(r"`([^`]+)`\s+([^\n]+)", line)
        if cm:
            colname = cm.group(1)
            if colname.upper().startswith("PRIMARY") or colname.upper().startswith("KEY") or colname.upper().startswith("CONSTRAINT"):
                continue
            cols.append(colname)
    return cols

def find_insert_blocks(table_name, sql_text):
    pattern = re.compile(r"INSERT INTO\s+`%s`\s+VALUES\s*(.*?);" % re.escape(table_name), re.S | re.I)
    return pattern.findall(sql_text)

def split_top_level_tuples(s):
    tuples = []
    cur = []
    depth = 0
    in_quote = False
    escape = False
    i = 0
    while i < len(s):
        ch = s[i]
        if escape:
            cur.append(ch); escape = False; i += 1; continue
        if ch == "\\":
            escape = True; i += 1; continue
        if ch == "'":
            cur.append(ch); in_quote = not in_quote; i += 1; continue
        if in_quote:
            cur.append(ch); i += 1; continue
        if ch == "(":
            depth += 1; cur.append(ch); i += 1; continue
        if ch == ")":
            depth -= 1; cur.append(ch); i += 1
            if depth == 0:
                tuples.append(''.join(cur).strip()); cur = []
            continue
        if depth == 0:
            i += 1; continue
        cur.append(ch); i += 1
    return tuples

def split_fields(tuple_text):
    s = tuple_text.strip()
    if s.startswith("(") and s.endswith(")"):
        s = s[1:-1]
    fields = []
    cur = []
    in_quote = False
    escape = False
    i = 0
    while i < len(s):
        ch = s[i]
        if escape:
            cur.append(ch); escape = False; i += 1; continue
        if ch == "\\":
            escape = True; i += 1; continue
        if ch == "'":
            cur.append(ch); in_quote = not in_quote; i += 1; continue
        if ch == "," and not in_quote:
            fields.append(''.join(cur).strip()); cur = []; i += 1; continue
        cur.append(ch); i += 1
    if cur:
        fields.append(''.join(cur).strip())
    clean = []
    for f in fields:
        if f.upper() == "NULL":
            clean.append(""); continue
        f = f.strip()
        if len(f) >= 2 and f[0] == "'" and f[-1] == "'":
            inner = f[1:-1].replace("\\'", "'").replace('\\\\', '\\')
            clean.append(inner)
        else:
            clean.append(f)
    return clean

def process_table(table_name, out_csv, out_err):
    with open(INPUT, "r", encoding="utf-8", errors="replace") as fh:
        data = fh.read()
    cols = extract_create_columns(table_name, data)
    if not cols:
        print("ERROR: CREATE TABLE for", table_name, "not found"); return 1
    blocks = find_insert_blocks(table_name, data)
    rows = []; bad_rows = []
    for block in blocks:
        tuples = split_top_level_tuples(block)
        for t in tuples:
            fields = split_fields(t)
            if len(fields) != len(cols):
                bad_rows.append((t, fields.copy()))
                if len(fields) > len(cols):
                    fields = fields[:len(cols)]
                else:
                    fields = fields + [""]*(len(cols)-len(fields))
            rows.append(fields)
    with open(out_csv, "w", newline='', encoding="utf-8") as csvf:
        w = csv.writer(csvf); w.writerow(cols); w.writerows(rows)
    if bad_rows:
        with open(out_err, "w", encoding="utf-8") as ef:
            for t, fields in bad_rows:
                ef.write("ORIG_TUPLE: " + t + "\n")
                ef.write("PARSED_FIELDS_COUNT: %d, EXPECTED: %d\n" % (len(fields), len(cols)))
                ef.write("FIELDS: " + repr(fields) + "\n\n")
    print("Wrote", out_csv, "rows=", len(rows), "cols=", len(cols), "errors=", len(bad_rows))
    return 0

if __name__ == '__main__':
    table = "countrylanguage"
    out_csv = r"countrylanguage.csv"
    out_err = r"countrylanguage.err"
    sys.exit(process_table(table, out_csv, out_err))

