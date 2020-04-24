import os

sep = os.path.sep

# app_version = "101"

path_android_assets = "..{0}..{0}ACNHCompanion.Android{0}Resources{0}drawable{0}".format(sep)
path_sqlite = "..{0}..{0}app_data.db".format(sep)
path_sql_scripts = "SQL{0}DDL{0}".format(sep)

table_name_critters = 'critters'
table_name_northern_months = 'northern_months'
table_name_southern_months = 'southern_months'
table_name_villagers = 'villagers'
table_name_config = 'config'

view_name_bugs_northern = 'v_bugs_northern'
view_name_bugs_southern = 'v_bugs_southern'
view_name_fish_northern = 'v_fish_northern'
view_name_fish_southern = 'v_fish_southern'

ascii_checkmark = 10003  # ✓

url_animalcrossing_fandom = 'https://animalcrossing.fandom.com'

url_nookipedia_base = 'https://nookipedia.com'
url_nookipedia_characters = url_nookipedia_base + '/wiki/Animal_Crossing:_New_Horizons/Characters'
