from global_constants import *

import sqlite3
import time

db_connection = sqlite3.connect(path_sqlite)
db_command = db_connection.cursor()


def get_critters_time_update_string(p_db_command):
    sql_update_string = ""

    rows = p_db_command.execute('''select ID, Time from ''' + table_name_critters)
    row_results = rows.fetchall()

    for row in row_results:
        critter_id = row[0]
        critter_time = row[1]

        time_split = critter_time.split('-')
        time_split_len = len(time_split)

        db_friendly_start_time = "00:00"
        db_friendly_end_time = "23:59"

        if time_split_len == 2:
            time_split[0] = time_split[0].strip()
            time_split[1] = time_split[1].strip()

            time_start_struc = time.strptime(time_split[0], '%I%p')
            time_end_struc = time.strptime(time_split[1], '%I%p')

            db_friendly_start_time = time.strftime('%H:%M', time_start_struc)
            db_friendly_end_time = time.strftime('%H:%M', time_end_struc)

        sql_update_string += "update " + table_name_critters + " set CatchStartTime = '" +\
                             str(db_friendly_start_time) + "', CatchEndTime = '" + str(db_friendly_end_time) +\
                             "' where ID = " + str(critter_id) + ";" + '\n'

    return sql_update_string


sql_update_string_to_write = get_critters_time_update_string(db_command)

file_to_write = open(path_sql_scripts + '101.sql', 'a')
file_to_write.write(sql_update_string_to_write)
file_to_write.close()
