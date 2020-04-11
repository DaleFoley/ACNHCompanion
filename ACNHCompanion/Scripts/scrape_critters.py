from bs4 import BeautifulSoup

import requests
import sqlite3
import re
import logging

# This is a one-off script to populate a sqlite database with required data for the app, in this case 'bugs' and 'fish'
# data. It also grabs any related images and adds them to our project.

# TODO: copy images to iOS path


def format_time(time):
    time_match = re.findall(r'([0-9])\s*(am|pm)',
                            time,
                            re.IGNORECASE)

    # In an effort to keep the time portion in a consistent format
    # Is there a better way to do this? Feels awfully verbose and error-prone. I want consistent formatting.
    # Example: '7AM - 9PM' as opposed to something like '7  Am - 8 PM' which could appear in our scraped content.
    if len(time_match) > 0:
        time = time_match[0][0].strip().upper() + time_match[0][1].strip().upper() + \
               " - " + time_match[1][0].strip().upper() + time_match[1][1].strip().upper()

    return time


def insert_critter_months(html_content, destination_table, contents_index_offset=0):
    for idx in range(1, len(html_content)):
        html_table_row = html_content[idx]

        name = html_table_row.contents[1].text.strip()

        months_available = []

        if ord(html_table_row.contents[6 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jan")

        if ord(html_table_row.contents[7 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("feb")

        if ord(html_table_row.contents[8 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("mar")

        if ord(html_table_row.contents[9 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("apr")

        if ord(html_table_row.contents[10 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("may")

        if ord(html_table_row.contents[11 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jun")

        if ord(html_table_row.contents[12 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jul")

        if ord(html_table_row.contents[13 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("aug")

        if ord(html_table_row.contents[14 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("sep")

        if ord(html_table_row.contents[15 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("oct")

        if ord(html_table_row.contents[16 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("nov")

        if ord(html_table_row.contents[17 + contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("dec")

        months = ' '.join(months_available)
        db_command.execute('insert into ' + destination_table + ' (critter_name, months) values (?, ?)',
                           (name, months))

    db_connection.commit()


def insert_fish_and_scrape_images(html_content):
    for idx in range(1, len(html_content)):
        fish_row = html_content[idx]

        fish_name = fish_row.contents[1].text.strip()
        fish_image_name = 'fish_' + fish_row.contents[1].text.strip().replace('-', '_').replace(' ', '_').replace('\'', '') +\
                          ".png"
        fish_image = fish_row.contents[2]
        sell_price = fish_row.contents[3].text.strip()
        location = fish_row.contents[4].text.strip()
        shadow_size = fish_row.contents[5].text.strip()
        time = fish_row.contents[6].text.strip().upper()

        time = format_time(time)

        db_command.execute('''insert into ''' + table_name_critters + ''' values (?, ?, ?, ?, ?, ?, ?, ?)''',
                           (fish_name, sell_price, location, time, shadow_size, 'fish', fish_image_name, 0))

        download_critter_image(fish_image, fish_image_name)

    db_connection.commit()


def insert_bugs_and_scrape_images(html_content):
    for idx in range(1, len(html_content)):
        bug_row = html_content[idx]

        bug_name = bug_row.contents[1].text.strip()
        bug_image_name = 'bug_' + bug_row.contents[1].text.strip().replace('-', '_').replace(' ', '_')\
            .replace('\'', '') + ".png"
        bug_image = bug_row.contents[2]
        sell_price = bug_row.contents[3].text.strip()
        location = bug_row.contents[4].text.strip()
        time = bug_row.contents[5].text.strip().upper()

        time = format_time(time)

        db_command.execute('''insert into ''' + table_name_critters + ''' values (?, ?, ?, ?, ?, ?, ?, ?)''',
                           (bug_name, sell_price, location, time, None, 'bug', bug_image_name, 0))

        download_critter_image(bug_image, bug_image_name)

    db_connection.commit()


def download_critter_image(image_tag, path_image):
    image_src_url = image_tag.a.img.attrs['data-src']
    image_response = requests.get(image_src_url)

    if image_response.status_code == 200:
        image_data = image_response.content

        image_file = open(path_android_assets + path_image, 'wb')
        image_file.write(image_data)
        image_file.close()
    else:
        breakpoint()


path_android_assets = "../../ACNHCompanion.Android/Resources/drawable/"
path_sqlite = "../../app_data.db"

table_name_critters = 'critters'
table_name_northern_months = 'northern_months'
table_name_southern_months = 'southern_months'

ascii_checkmark = 10003

db_connection = sqlite3.connect(path_sqlite)

try:
    db_command = db_connection.cursor()

    db_command.execute('''drop table if exists ''' + table_name_critters)
    db_command.execute('''create table ''' + table_name_critters + ''' (critter_name text primary key,
        sell_price integer,
        location text,
        time text,
        shadow_size text null,
        type text,
        image_name text,
        is_donated integer default 0)''')

    db_command.execute('''drop table if exists ''' + table_name_northern_months)
    db_command.execute('''create table ''' + table_name_northern_months + ''' (id integer primary key,
        critter_name text,
        months text)''')

    db_command.execute('''drop table if exists ''' + table_name_southern_months)
    db_command.execute('''create table ''' + table_name_southern_months + ''' (id integer primary key,
        critter_name text,
        months text)''')

    response = requests.get('https://animalcrossing.fandom.com/wiki/Bugs_(New_Horizons)')

    if response.status_code == 200:
        html_doc = response.text
        html_source = BeautifulSoup(html_doc, 'html.parser')

        bug_rows_northern = html_source.findAll('table')[2].findAll('table')[0].findAll('tr')
        insert_bugs_and_scrape_images(bug_rows_northern)
        insert_critter_months(bug_rows_northern, table_name_northern_months)

        bug_rows_southern = html_source.findAll('table')[4].findAll('table')[0].findAll('tr')
        insert_critter_months(bug_rows_southern, table_name_southern_months)

    response = requests.get('https://animalcrossing.fandom.com/wiki/Fish_(New_Horizons)')

    if response.status_code == 200:
        html_doc = response.text
        html_source = BeautifulSoup(html_doc, 'html.parser')

        fish_rows_northern = html_source.findAll('table')[2].findAll('tr')
        insert_fish_and_scrape_images(fish_rows_northern)
        insert_critter_months(fish_rows_northern, table_name_northern_months, 1)

        fish_rows_southern = html_source.findAll('table')[4].findAll('tr')
        insert_critter_months(fish_rows_northern, table_name_southern_months, 1)

except BaseException as error:
    logger = logging.getLogger("scrape")
    hldr = logging.FileHandler('error.log')
    logger.addHandler(hldr)

    logger.exception("Unexpected error")
finally:
    db_connection.close()
