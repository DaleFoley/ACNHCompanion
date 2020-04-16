from global_constants import *

import sqlite3


def setup_db_schemas(p_db_command):
    p_db_command.execute('''drop table if exists ''' + table_name_critters)
    p_db_command.execute('''create table ''' + table_name_critters + ''' (ID integer primary key,
            CritterName text,
            SellPrice integer,
            Location text,
            Time text,
            ShadowSize text null,
            Type text,
            ImageName text,
            Rarity text,
            IsDonated integer default 0)''')

    p_db_command.execute('''drop table if exists ''' + table_name_villagers)
    p_db_command.execute('''create table ''' + table_name_villagers + ''' (ID integer primary key,
            Name text,
            Personality text,
            Species text,
            Birthday text,
            Catchphrase text,
            ImageName text)''')

    p_db_command.execute('''drop table if exists ''' + table_name_config)
    p_db_command.execute('''create table ''' + table_name_config + ''' (ID integer primary key,
            Name text,
            Value text,
            IsEnabled integer default 1)''')

    p_db_command.execute('''drop table if exists ''' + table_name_northern_months)
    p_db_command.execute('''create table ''' + table_name_northern_months + ''' (ID integer primary key,
            CritterName text,
            Months text)''')

    p_db_command.execute('''drop table if exists ''' + table_name_southern_months)
    p_db_command.execute('''create table ''' + table_name_southern_months + ''' (ID integer primary key,
            CritterName text,
            Months text)''')

    p_db_command.execute('''drop view if exists ''' + view_name_bugs_northern)
    p_db_command.execute('create view ' + view_name_bugs_northern + '''
    as 
       select ''' + table_name_critters + '''.*, ''' + table_name_northern_months + '''.months
       from ''' + table_name_critters + '''
       inner join ''' + table_name_northern_months + ''' on ''' +
                         table_name_northern_months + '''.CritterName = ''' +
                         table_name_critters + '''.CritterName 
       where ''' + table_name_critters + '''.Type = 'bug'
       order by ''' + table_name_critters + '''.CritterName''')

    p_db_command.execute('''drop view if exists ''' + view_name_bugs_southern)
    p_db_command.execute('create view ' + view_name_bugs_southern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_southern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_southern_months + ''' on ''' +
                         table_name_southern_months + '''.CritterName = ''' +
                         table_name_critters + '''.CritterName 
           where ''' + table_name_critters + '''.Type = 'bug'
           order by ''' + table_name_critters + '''.CritterName''')

    p_db_command.execute('''drop view if exists ''' + view_name_fish_northern)
    p_db_command.execute('create view ' + view_name_fish_northern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_northern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_northern_months + ''' on ''' +
                         table_name_northern_months + '''.CritterName = ''' +
                         table_name_critters + '''.CritterName 
           where ''' + table_name_critters + '''.Type = 'fish'
           order by ''' + table_name_critters + '''.CritterName''')

    p_db_command.execute('''drop view if exists ''' + view_name_fish_southern)
    p_db_command.execute('create view ' + view_name_fish_southern + '''
        as 
           select ''' + table_name_critters + '''.*, ''' + table_name_southern_months + '''.months
           from ''' + table_name_critters + '''
           inner join ''' + table_name_southern_months + ''' on ''' +
                         table_name_southern_months + '''.CritterName = ''' +
                         table_name_critters + '''.CritterName 
           where ''' + table_name_critters + '''.Type = 'fish'
           order by ''' + table_name_critters + '''.CritterName''')


def insert_predefined_values(p_db_command):
    p_db_command.execute('''insert into ''' + table_name_config +
                         ''' (Name, Value) values (?, ?)''', ('hemisphere', 'North'))
    p_db_command.execute('''insert into ''' + table_name_config +
                         ''' (Name, Value) values (?, ?)''', ('version', '1.0.0'))


db_connection = sqlite3.connect(path_sqlite)
db_command = db_connection.cursor()
