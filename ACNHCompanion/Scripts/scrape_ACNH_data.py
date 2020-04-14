from bs4 import BeautifulSoup
from PIL import Image

import requests
import sqlite3
import re
import logging

# This is a one-off script to populate a sqlite database with ACNH data. Fish, Bugs, Villagers etc..
# Keep in mind HTML structural changes on target sites will most likely cause errors and/or malformed scraped data.

# TODO: copy images to iOS path


def crop_image_to_size(p_path_to_image):
    im = Image.open(p_path_to_image)
    im_boundingbox = im.getbbox()
    cropped_image = im.crop(im_boundingbox)
    cropped_image.save(p_path_to_image)


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


def insert_critter_months(p_html_content, p_destination_table, p_contents_index_offset=0):
    for idx in range(1, len(p_html_content)):
        html_table_row = p_html_content[idx]

        name = html_table_row.contents[1].text.strip()

        months_available = []

        if ord(html_table_row.contents[6 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jan")

        if ord(html_table_row.contents[7 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("feb")

        if ord(html_table_row.contents[8 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("mar")

        if ord(html_table_row.contents[9 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("apr")

        if ord(html_table_row.contents[10 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("may")

        if ord(html_table_row.contents[11 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jun")

        if ord(html_table_row.contents[12 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("jul")

        if ord(html_table_row.contents[13 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("aug")

        if ord(html_table_row.contents[14 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("sep")

        if ord(html_table_row.contents[15 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("oct")

        if ord(html_table_row.contents[16 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("nov")

        if ord(html_table_row.contents[17 + p_contents_index_offset].text.strip()) == ascii_checkmark:
            months_available.append("dec")

        months = ' '.join(months_available)
        db_command.execute('insert into ' + p_destination_table + ' (critter_name, months) values (?, ?)',
                           (name, months))


def get_rarity_data(p_url):
    rarity = None
    response = requests.get(p_url)

    if response.status_code == 200:
        html_doc = response.text
        html_source = BeautifulSoup(html_doc, 'html.parser')

        rarity_div = html_source.find("div", {"data-source": "rarity"})
        if rarity_div is not None:
            rarity = rarity_div.div.text

    return rarity


def insert_fish_and_scrape_images(p_html_content):
    for idx in range(1, len(p_html_content)):
        fish_row = p_html_content[idx]

        fish_name = fish_row.contents[1].text.strip()

        anchor_row = fish_row.contents[1].a
        url_to_extended_info = url_animalcrossing_fandom + anchor_row.attrs['href']
        rarity = get_rarity_data(url_to_extended_info)

        fish_image_name = 'fish_' + fish_row.contents[1].text.strip().replace('-', '_').replace(' ', '_')\
            .replace('\'', '') + ".png"
        fish_image = fish_row.contents[2]
        sell_price = fish_row.contents[3].text.strip()
        location = fish_row.contents[4].text.strip()
        shadow_size = fish_row.contents[5].text.strip()
        time = fish_row.contents[6].text.strip().upper()

        time = format_time(time)

        db_command.execute('''insert into ''' + table_name_critters + '''
                            (critter_name, sell_price, location, time, shadow_size, type, image_name, rarity) values (?, ?, ?, ?, ?, ?, ?, ?)''',
                           (fish_name, sell_price, location, time, shadow_size, 'fish', fish_image_name, rarity))

        download_critter_image(fish_image, fish_image_name)


def insert_bugs_and_scrape_images(p_html_content):
    for idx in range(1, len(p_html_content)):
        bug_row = p_html_content[idx]

        bug_name = bug_row.contents[1].text.strip()

        anchor_row = bug_row.contents[1].a
        url_to_extended_info = url_animalcrossing_fandom + anchor_row.attrs['href']
        rarity = get_rarity_data(url_to_extended_info)

        bug_image_name = 'bug_' + bug_row.contents[1].text.strip().replace('-', '_').replace(' ', '_')\
            .replace('\'', '') + ".png"
        bug_image = bug_row.contents[2]
        sell_price = bug_row.contents[3].text.strip()
        location = bug_row.contents[4].text.strip()
        time = bug_row.contents[5].text.strip().upper()

        time = format_time(time)

        db_command.execute('''insert into ''' + table_name_critters + '''
                            (critter_name, sell_price, location, time, shadow_size, type, image_name, rarity) values (?, ?, ?, ?, ?, ?, ?, ?)''',
                           (bug_name, sell_price, location, time, None, 'bug', bug_image_name, rarity))

        download_critter_image(bug_image, bug_image_name)


def download_critter_image(p_image_tag, p_path_image):
    image_src_url = p_image_tag.a.img.attrs['data-src']
    image_response = requests.get(image_src_url)

    path_saved_image = path_android_assets + p_path_image
    if image_response.status_code == 200:
        image_data = image_response.content

        image_file = open(path_saved_image, 'wb')
        image_file.write(image_data)
        image_file.close()

        crop_image_to_size(path_saved_image)
    else:
        breakpoint()


def setup_db_schemas(p_db_command):
    p_db_command.execute('''drop table if exists ''' + table_name_critters)
    p_db_command.execute('''create table ''' + table_name_critters + ''' (id integer primary key,
            critter_name text,
            sell_price integer,
            location text,
            time text,
            shadow_size text null,
            type text,
            image_name text,
            rarity text,
            is_donated default 0)''')

    p_db_command.execute('''drop table if exists ''' + table_name_northern_months)
    p_db_command.execute('''create table ''' + table_name_northern_months + ''' (id integer primary key,
            critter_name text,
            months text)''')

    p_db_command.execute('''drop table if exists ''' + table_name_southern_months)
    p_db_command.execute('''create table ''' + table_name_southern_months + ''' (id integer primary key,
            critter_name text,
            months text)''')

    p_db_command.execute('''drop view if exists ''' + view_name_bugs_northern)
    p_db_command.execute('create view ' + view_name_bugs_northern + '''
    as 
       select ''' + table_name_critters + '''.*, ''' + table_name_northern_months + '''.months
       from ''' + table_name_critters + '''
       inner join ''' + table_name_northern_months + ''' on ''' +
                         table_name_northern_months + '''.critter_name = ''' +
                         table_name_critters + '''.critter_name 
       where ''' + table_name_critters + '''.type = 'bug'
       order by ''' + table_name_critters + '''.critter_name''')

    p_db_command.execute('''drop view if exists ''' + view_name_bugs_southern)
    p_db_command.execute('create view ' + view_name_bugs_southern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_southern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_southern_months + ''' on ''' +
                         table_name_southern_months + '''.critter_name = ''' +
                         table_name_critters + '''.critter_name 
           where ''' + table_name_critters + '''.type = 'bug'
           order by ''' + table_name_critters + '''.critter_name''')

    p_db_command.execute('''drop view if exists ''' + view_name_fish_northern)
    p_db_command.execute('create view ' + view_name_fish_northern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_northern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_northern_months + ''' on ''' +
                         table_name_northern_months + '''.critter_name = ''' +
                         table_name_critters + '''.critter_name 
           where ''' + table_name_critters + '''.type = 'fish'
           order by ''' + table_name_critters + '''.critter_name''')

    p_db_command.execute('''drop view if exists ''' + view_name_fish_southern)
    p_db_command.execute('create view ' + view_name_fish_southern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_southern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_southern_months + ''' on ''' +
                         table_name_southern_months + '''.critter_name = ''' +
                         table_name_critters + '''.critter_name 
           where ''' + table_name_critters + '''.type = 'fish'
           order by ''' + table_name_critters + '''.critter_name''')


path_android_assets = "../../ACNHCompanion.Android/Resources/drawable/"
path_sqlite = "../../app_data.db"

table_name_critters = 'critters'
table_name_northern_months = 'northern_months'
table_name_southern_months = 'southern_months'

view_name_bugs_northern = 'v_bugs_northern'
view_name_bugs_southern = 'v_bugs_southern'
view_name_fish_northern = 'v_fish_northern'
view_name_fish_southern = 'v_fish_southern'

ascii_checkmark = 10003

db_connection = sqlite3.connect(path_sqlite)

url_animalcrossing_fandom = 'https://animalcrossing.fandom.com'

try:
    db_command = db_connection.cursor()

    setup_db_schemas(db_command)

    response = requests.get(url_animalcrossing_fandom + '/wiki/Bugs_(New_Horizons)')

    if response.status_code == 200:
        html_doc = response.text
        html_source = BeautifulSoup(html_doc, 'html.parser')

        bug_rows_northern = html_source.findAll('table')[2].findAll('table')[0].findAll('tr')
        insert_bugs_and_scrape_images(bug_rows_northern)
        insert_critter_months(bug_rows_northern, table_name_northern_months)

        bug_rows_southern = html_source.findAll('table')[4].findAll('table')[0].findAll('tr')
        insert_critter_months(bug_rows_southern, table_name_southern_months)

    response = requests.get(url_animalcrossing_fandom + '/wiki/Fish_(New_Horizons)')

    if response.status_code == 200:
        html_doc = response.text
        html_source = BeautifulSoup(html_doc, 'html.parser')

        fish_rows_northern = html_source.findAll('table')[2].findAll('tr')
        insert_fish_and_scrape_images(fish_rows_northern)
        insert_critter_months(fish_rows_northern, table_name_northern_months, 1)

        fish_rows_southern = html_source.findAll('table')[4].findAll('tr')
        insert_critter_months(fish_rows_southern, table_name_southern_months, 1)

except BaseException as error:
    logger = logging.getLogger("scrape")
    hldr = logging.FileHandler('error.log')
    logger.addHandler(hldr)

    logger.exception("Unexpected error")
finally:
    db_connection.commit()
    db_connection.close()
