from bs4 import BeautifulSoup

import requests
import sqlite3
import re

# This is a one-off script to populate a sqlite database with required data for the app, in this case 'bugs' data.
# It also grabs any related images and adds them to our project.

# TODO: iOS assets
path_assets = "../../ACNHGuide.Android/Resources/drawable"
path_sqlite = "../../app_data.db"

table_name_bugs = 'bugs'
table_name_northern_months = 'northern_months'
table_name_southern_months = 'southern_months'

ascii_checkmark = 10003

db_connection = sqlite3.connect(path_sqlite)
db_command = db_connection.cursor()

db_command.execute('''drop table if exists ''' + table_name_bugs)
db_command.execute('''create table ''' + table_name_bugs + ''' (name text primary key,
    sell_price integer,
    location text,
    time text)''')

db_command.execute('''drop table if exists ''' + table_name_northern_months)
db_command.execute('''create table ''' + table_name_northern_months + ''' (id integer primary key,
    animal_name text,
    months text)''')

db_command.execute('''drop table if exists ''' + table_name_southern_months)
db_command.execute('''create table ''' + table_name_southern_months + ''' (id integer primary key,
    animal_name text,
    months text)''')


def insert_animal_months(html_content, destination_table):
    for idx in range(1, len(html_content)):
        html_table_row = html_content[idx]

        name = html_table_row.contents[1].text.strip()

        months_available = []

        if ord(html_table_row.contents[6].text.strip()) == ascii_checkmark:
            months_available.append("jan")

        if ord(html_table_row.contents[7].text.strip()) == ascii_checkmark:
            months_available.append("feb")

        if ord(html_table_row.contents[8].text.strip()) == ascii_checkmark:
            months_available.append("mar")

        if ord(html_table_row.contents[9].text.strip()) == ascii_checkmark:
            months_available.append("apr")

        if ord(html_table_row.contents[10].text.strip()) == ascii_checkmark:
            months_available.append("may")

        if ord(html_table_row.contents[11].text.strip()) == ascii_checkmark:
            months_available.append("jun")

        if ord(html_table_row.contents[12].text.strip()) == ascii_checkmark:
            months_available.append("jul")

        if ord(html_table_row.contents[13].text.strip()) == ascii_checkmark:
            months_available.append("aug")

        if ord(html_table_row.contents[14].text.strip()) == ascii_checkmark:
            months_available.append("sep")

        if ord(html_table_row.contents[15].text.strip()) == ascii_checkmark:
            months_available.append("oct")

        if ord(html_table_row.contents[16].text.strip()) == ascii_checkmark:
            months_available.append("nov")

        if ord(html_table_row.contents[17].text.strip()) == ascii_checkmark:
            months_available.append("dec")

        months = ' '.join(months_available)
        db_command.execute('insert into ' + destination_table + ' (animal_name, months) values (?, ?)',
                           (name, months))

    db_connection.commit()


def insert_bugs(html_content):
    for idx in range(1, len(html_content)):
        bug_row = html_content[idx]

        name = bug_row.contents[1].text.strip()
        sell_price = bug_row.contents[3].text.strip()
        location = bug_row.contents[4].text.strip()
        time = bug_row.contents[5].text.strip().upper()

        # In an effort to keep the time portion in a consistent format
        # Is there a better way to do this? Feels awfully verbose and error-prone. I want consistent formatting.
        # Example: '7AM - 9PM' as opposed to something like '7  Am - 8 PM' which could appear in our scraped content.
        time_match = re.findall(r'([0-9])\s*(am|pm)',
                                time,
                                re.IGNORECASE)

        if len(time_match) > 0:
            time = time_match[0][0].strip().upper() + time_match[0][1].strip().upper() + \
                   " - " + time_match[1][0].strip().upper() + time_match[1][1].strip().upper()

        db_command.execute('''insert into bugs values (?, ?, ?, ?)''',
                           (name, sell_price, location, time))

    db_connection.commit()


response = requests.get('https://animalcrossing.fandom.com/wiki/Bugs_(New_Horizons)')

if response.status_code == 200:
    html_doc = response.text
    html_source = BeautifulSoup(html_doc, 'html.parser')

    bug_rows_northern = html_source.findAll('table')[2].findAll('table')[0].findAll('tr')
    insert_bugs(bug_rows_northern)
    insert_animal_months(bug_rows_northern, table_name_northern_months)

    bug_rows_southern = html_source.findAll('table')[4].findAll('table')[0].findAll('tr')
    insert_animal_months(bug_rows_southern, table_name_southern_months)

db_connection.close()
