drop table if exists config;
create table config (Name text,
            Value text,
            IsEnabled integer default 1,
			primary key (Name));

drop table if exists critters;
create table critters (ID integer primary key,
            CritterName text,
            SellPrice integer,
            Location text,
            Time text,
            ShadowSize text null,
            Type text,
            ImageName text,
            Rarity text,
            IsDonated integer default 0,
			CatchStartTime time default 0 not null,
			CatchEndTime time default 0 not null,
			IsSculpted integer default 0,
			IsCaptured integer default 0);

drop table if exists northern_months;
create table northern_months (ID integer primary key,
            CritterName text,
            Months text);

drop table if exists southern_months;
create table southern_months (ID integer primary key,
            CritterName text,
            Months text);

drop table if exists villagers;
create table villagers (ID integer primary key,
            Name text,
            Personality text,
            Species text,
            Birthday text,
            Catchphrase text,
            ImageName text,
			IconName text,
			IsResident int default 0);

drop view if exists v_base_critters;
create view v_base_critters
as
	select critters.ID,
		   critters.CritterName,
		   critters.SellPrice,
		   critters.Location,
		   critters.Time,
		   critters.ShadowSize,
		   critters.CatchStartTime,
		   critters.CatchEndTime,
		   critters.Type,
		   critters.ImageName,
		   critters.Rarity,
		   critters.IsDonated,
		   critters.IsSculpted,
		   critters.IsCaptured,
		  case
			when time('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')) >= critters.CatchStartTime and time('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')) <= critters.CatchEndTime then true
			when time(critters.CatchEndTime) < time(critters.CatchStartTime) then
				(case when time('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')) >= time(critters.CatchStartTime) or time('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')) <= time(critters.CatchEndTime) then true else false end)
			else false
		  end as IsCatchableBasedOnTime
	from critters
	order by critters.CritterName;

drop view if exists v_bugs_northern;
create view v_bugs_northern
as
select v_base_critters.*,
	   northern_months.months,
	   case when instr(northern_months.months,
		   case strftime('%m', date('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')))
			when '01' then 'Jan'
			when '02' then 'Feb'
			when '03' then 'Mar'
			when '04' then 'Apr'
			when '05' then 'May'
			when '06' then 'Jun'
			when '07' then 'Jul'
			when '08' then 'Aug'
			when '09' then 'Sep'
			when '10' then 'Oct'
			when '11' then 'Nov'
			when '12' then 'Dec'
			else '' end) > 0 then true else false end as IsCatchableBasedOnMonth
from v_base_critters
inner join northern_months on northern_months.CritterName = v_base_critters.CritterName
where v_base_critters.Type = 'bug'
order by v_base_critters.CritterName;

drop view if exists v_bugs_southern;
create view v_bugs_southern
as
   select v_base_critters.*,
	   southern_months.months,
	   case when instr(southern_months.months,
		   case strftime('%m', date('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')))
			when '01' then 'Jan'
			when '02' then 'Feb'
			when '03' then 'Mar'
			when '04' then 'Apr'
			when '05' then 'May'
			when '06' then 'Jun'
			when '07' then 'Jul'
			when '08' then 'Aug'
			when '09' then 'Sep'
			when '10' then 'Oct'
			when '11' then 'Nov'
			when '12' then 'Dec'
			else '' end) > 0 then true else false end as IsCatchableBasedOnMonth
	   from v_base_critters
	   inner join southern_months on southern_months.CritterName = v_base_critters.CritterName
	   where v_base_critters.Type = 'bug'
	   order by v_base_critters.CritterName;

drop view if exists v_fish_northern;
create view v_fish_northern
as
   select v_base_critters.*,
		  northern_months.months,
		  case when instr(northern_months.months,
		   case strftime('%m', date('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')))
				when '01' then 'Jan'
				when '02' then 'Feb'
				when '03' then 'Mar'
				when '04' then 'Apr'
				when '05' then 'May'
				when '06' then 'Jun'
				when '07' then 'Jul'
				when '08' then 'Aug'
				when '09' then 'Sep'
				when '10' then 'Oct'
				when '11' then 'Nov'
				when '12' then 'Dec'
				else '' end) > 0 then true else false end as IsCatchableBasedOnMonth
   from v_base_critters
   inner join northern_months on northern_months.CritterName = v_base_critters.CritterName
   where v_base_critters.Type = 'fish'
   order by v_base_critters.CritterName;

drop view if exists v_fish_southern;
create view v_fish_southern
as
   select v_base_critters.*,
		  southern_months.months,
		  case when instr(southern_months.months,
		   case strftime('%m', date('now', 'localtime', (select Value from config where config.Name = 'customUserTimeDifference')))
		when '01' then 'Jan'
		when '02' then 'Feb'
		when '03' then 'Mar'
		when '04' then 'Apr'
		when '05' then 'May'
		when '06' then 'Jun'
		when '07' then 'Jul'
		when '08' then 'Aug'
		when '09' then 'Sep'
		when '10' then 'Oct'
		when '11' then 'Nov'
		when '12' then 'Dec'
		else '' end) > 0 then true else false end as IsCatchableBasedOnMonth
   from v_base_critters
   inner join southern_months on southern_months.CritterName = v_base_critters.CritterName
   where v_base_critters.Type = 'fish'
   order by v_base_critters.CritterName;

begin transaction;
    replace into config (Name, Value, IsEnabled) values ('hemisphere', 'North', 1);
    replace into config (Name, Value, IsEnabled) values ('version', '101', 1);
    replace into config (Name, Value, IsEnabled) values ('customUserTimeDifference', '+0 minute', 1);
commit;

begin transaction;
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (1, 'Common butterfly', 160, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Common_butterfly.png', 'Common (★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (2, 'Yellow butterfly', 160, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Yellow_butterfly.png', 'Common (★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (3, 'Tiger butterfly', 240, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Tiger_butterfly.png', 'Uncommon (★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (4, 'Peacock butterfly', 2500, 'Flying by Hybrid Flowers', '4AM - 7PM', null, 'bug', 'bug_Peacock_butterfly.png', 'Uncommon (★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (5, 'Common bluebottle', 300, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Common_bluebottle.png', 'Common', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (6, 'Paper kite butterfly', 1000, 'Flying', '8AM - 7PM', null, 'bug', 'bug_Paper_kite_butterfly.png', 'Fairly Common (★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (7, 'Great purple emperor', 3000, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Great_purple_emperor.png', 'Scarce (★★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (8, 'Monarch butterfly', 140, 'Flying', '4AM - 5PM', null, 'bug', 'bug_Monarch_butterfly.png', 'Fairly Common (★★)', 0, '04:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (9, 'Emperor butterfly', 4000, 'Flying', '5PM - 8AM', null, 'bug', 'bug_Emperor_butterfly.png', 'Uncommon (★★★)(WW) Scarce (★★★★)(CF,NL)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (10, 'Agrias butterfly', 3000, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Agrias_butterfly.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (11, 'Rajah Brooke''s birdwing', 2500, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Rajah_Brookes_birdwing.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (12, 'Queen Alexandra''s birdwing', 4000, 'Flying', '8AM - 4PM', null, 'bug', 'bug_Queen_Alexandras_birdwing.png', 'Uncommon (★★★) (NH)', 0, '08:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (13, 'Moth', 130, 'Flying by Light', '7PM - 4AM', null, 'bug', 'bug_Moth.png', 'Common (★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (14, 'Atlas moth', 3000, 'On Trees', '7PM - 4AM', null, 'bug', 'bug_Atlas_moth.png', 'Fairly common', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (15, 'Madagascan sunset moth', 2500, 'Flying', '8AM - 4PM', null, 'bug', 'bug_Madagascan_sunset_moth.png', 'Fairly common (★★)', 0, '08:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (16, 'Long locust', 200, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Long_locust.png', 'Fairly Common (★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (17, 'Migratory locust', 600, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Migratory_locust.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (18, 'Rice grasshopper', 160, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Rice_grasshopper.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (19, 'Grasshopper', 160, 'On the Ground', '8AM - 5PM', null, 'bug', 'bug_Grasshopper.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (20, 'Cricket', 130, 'On the Ground', '5PM - 8AM', null, 'bug', 'bug_Cricket.png', 'Common (★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (21, 'Bell cricket', 430, 'On the Ground', '5PM - 8AM', null, 'bug', 'bug_Bell_cricket.png', 'Rare (★★★★) (GCN games) Uncommon (★★★) (WW, CF)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (22, 'Mantis', 430, 'On Flowers', '8AM - 5PM', null, 'bug', 'bug_Mantis.png', 'Uncommon (★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (23, 'Orchid mantis', 2400, 'On Flowers (White)', '8AM - 5PM', null, 'bug', 'bug_Orchid_mantis.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (24, 'Honeybee', 200, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Honeybee.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (25, 'Wasp', 2500, 'Shaking Trees', 'ALL DAY', null, 'bug', 'bug_Wasp.png', 'Limited Per Day (-)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (26, 'Brown cicada', 250, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Brown_cicada.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (27, 'Robust cicada', 300, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Robust_cicada.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (28, 'Giant cicada', 500, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Giant_cicada.png', 'Uncommon (★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (29, 'Walker cicada', 400, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Walker_cicada.png', 'Uncommon (★★★) (June-August)Scarce (★★★★) September)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (30, 'Evening cicada', 550, 'On Trees', '4AM - 8AM', null, 'bug', 'bug_Evening_cicada.png', 'Uncommon (★★★)(GCN games) Fairly Common (★★)(WW, CF)', 0, '04:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (31, 'Cicada shell', 10, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Cicada_shell.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (32, 'Red dragonfly', 180, 'Flying', '8AM - 7PM', null, 'bug', 'bug_Red_dragonfly.png', 'Common (★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (33, 'Darner dragonfly', 230, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Darner_dragonfly.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (34, 'Banded dragonfly', 4500, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Banded_dragonfly.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (35, 'Damselfly', 500, 'Flying', 'ALL DAY', null, 'bug', 'bug_Damselfly.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (36, 'Firefly', 300, 'Flying', '7PM - 4AM', null, 'bug', 'bug_Firefly.png', 'Common (★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (37, 'Mole cricket', 500, 'Underground', 'ALL DAY', null, 'bug', 'bug_Mole_cricket.png', 'Uncommon (★★★)(AC)Fairly Common (★★)(CF)Scarce (★★★★)(WW)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (38, 'Pondskater', 130, 'On Ponds and Rivers', '8AM - 7PM', null, 'bug', 'bug_Pondskater.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (39, 'Diving beetle', 800, 'On Ponds and Rivers', '8AM - 7PM', null, 'bug', 'bug_Diving_beetle.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (40, 'Giant water bug', 2000, 'On Ponds and Rivers', '7PM - 8AM', null, 'bug', 'bug_Giant_water_bug.png', 'Common', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (41, 'Stinkbug', 120, 'On Flowers', 'ALL DAY', null, 'bug', 'bug_Stinkbug.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (42, 'Man-faced stink bug', 1000, 'On Flowers', '7PM - 8AM', null, 'bug', 'bug_Man_faced_stink_bug.png', 'Fairly Common (★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (43, 'Ladybug', 200, 'On Flowers', '8AM - 5PM', null, 'bug', 'bug_Ladybug.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (44, 'Tiger beetle', 1500, 'On the Ground', 'ALL DAY', null, 'bug', 'bug_Tiger_beetle.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (45, 'Jewel beetle', 2400, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Jewel_beetle.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (46, 'Violin beetle', 450, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Violin_beetle.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (47, 'Citrus long-horned beetle', 350, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Citrus_long_horned_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (48, 'Rosalia batesi beetle', 3000, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Rosalia_batesi_beetle.png', 'Uncommon', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (49, 'Blue weevil beetle', 800, 'On Trees (Coconut?)', 'ALL DAY', null, 'bug', 'bug_Blue_weevil_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (50, 'Dung beetle', 3000, 'On the Ground (rolling snowballs)', 'ALL DAY', null, 'bug', 'bug_Dung_beetle.png', 'Scarce (★★★★)(AFe+) Uncommon (★★★) (WW, CF, NL)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (51, 'Earth-boring dung beetle', 300, 'On the Ground', 'ALL DAY', null, 'bug', 'bug_Earth_boring_dung_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (52, 'Scarab beetle', 10000, 'On Trees', '1PM - 8AM', null, 'bug', 'bug_Scarab_beetle.png', 'Scarce (★★★★)', 0, '13:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (53, 'Drone beetle', 200, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Drone_beetle.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (54, 'Goliath beetle', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Goliath_beetle.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (55, 'Saw stag', 2000, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Saw_stag.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (56, 'Miyama stag', 1000, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Miyama_stag.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (57, 'Giant stag', 10000, 'On Trees', '1PM - 8AM', null, 'bug', 'bug_Giant_stag.png', 'Scarce (★★★★)', 0, '13:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (58, 'Rainbow stag', 6000, 'On Trees', '7PM - 8AM', null, 'bug', 'bug_Rainbow_stag.png', 'Scarce (★★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (59, 'Cyclommatus stag', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Cyclommatus_stag.png', 'Scarce (★★★★)(CF) Quite common (★★)(NL)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (60, 'Golden stag', 12000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Golden_stag.png', 'Rare (★★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (61, 'Giraffe stag', 12000, 'On Trees (Coconut?)', '5PM - 8AM', null, 'bug', 'bug_Giraffe_stag.png', 'Unknown', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (62, 'Horned dynastid', 1350, 'On Trees', '5PM - 8AM', null, 'bug', 'bug_Horned_dynastid.png', 'Uncommon (★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (63, 'Horned atlas', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_atlas.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (64, 'Horned elephant', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_elephant.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (65, 'Horned hercules', 12000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_hercules.png', 'Rare (★★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (66, 'Walking stick', 600, 'On Trees', '4AM - 8AM', null, 'bug', 'bug_Walking_stick.png', 'Uncommon (★★★)', 0, '04:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (67, 'Walking leaf', 600, 'Under Trees Disguised as Leafs', 'ALL DAY', null, 'bug', 'bug_Walking_leaf.png', 'Clear weather: Scarce (★★★★),  During rain: Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (68, 'Bagworm', 600, 'Shaking Trees', 'ALL DAY', null, 'bug', 'bug_Bagworm.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (69, 'Ant', 80, 'On rotten food', 'ALL DAY', null, 'bug', 'bug_Ant.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (70, 'Hermit crab', 1000, 'Beach disguised as Shells', '7PM - 8AM', null, 'bug', 'bug_Hermit_crab.png', 'Scarce (★★★★), During rain in AFe+: Uncommon (★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (71, 'Wharf roach', 200, 'On Beach Rocks', 'ALL DAY', null, 'bug', 'bug_Wharf_roach.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (72, 'Fly', 60, 'On Trash Items', 'ALL DAY', null, 'bug', 'bug_Fly.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (73, 'Mosquito', 130, 'Flying', '5PM - 4AM', null, 'bug', 'bug_Mosquito.png', 'Fairly Common (★★)', 0, '17:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (74, 'Flea', 70, 'Villager''s Heads', 'ALL DAY', null, 'bug', 'bug_Flea.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (75, 'Snail', 250, 'On Rocks (Rain)', 'ALL DAY', null, 'bug', 'bug_Snail.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (76, 'Pill bug', 250, 'Hitting Rocks', '1PM - 4PM', null, 'bug', 'bug_Pill_bug.png', 'Uncommon (★★★)', 0, '13:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (77, 'Centipede', 300, 'Hitting Rocks', '4PM - 1PM', null, 'bug', 'bug_Centipede.png', 'Scarce (★★★★)', 0, '16:00', '13:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (78, 'Spider', 600, 'Shaking Trees', '7PM - 8AM', null, 'bug', 'bug_Spider.png', 'Uncommon (★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (79, 'Tarantula', 8000, 'On the Ground', '7PM - 4AM', null, 'bug', 'bug_Tarantula.png', 'Rare (★★★★★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (80, 'Scorpion', 8000, 'On the Ground', '7PM - 4AM', null, 'bug', 'bug_Scorpion.png', 'Rare (★★★★★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (81, 'Bitterling', 900, 'River', 'ALL DAY', '1', 'fish', 'fish_Bitterling.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (82, 'Pale chub', 200, 'River', '9AM - 4PM', '1', 'fish', 'fish_Pale_chub.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (83, 'Crucian carp', 160, 'River', 'ALL DAY', '2', 'fish', 'fish_Crucian_carp.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (84, 'Dace', 240, 'River', '4PM - 9AM', '3', 'fish', 'fish_Dace.png', 'Fairly Common (★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (85, 'Carp', 300, 'Pond', 'ALL DAY', '4', 'fish', 'fish_Carp.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (86, 'Koi', 4000, 'Pond', '4PM - 9AM', '4', 'fish', 'fish_Koi.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (87, 'Goldfish', 1300, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Goldfish.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (88, 'Pop-eyed goldfish', 1300, 'Pond', '9AM - 4PM', '1', 'fish', 'fish_Pop_eyed_goldfish.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (89, 'Ranchu goldfish', 4500, 'Pond', '9AM - 4PM', '2', 'fish', 'fish_Ranchu_goldfish.png', 'Rare', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (90, 'Killifish', 300, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Killifish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (91, 'Crawfish', 200, 'Pond', 'ALL DAY', '2', 'fish', 'fish_Crawfish.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (92, 'Soft-shelled turtle', 3750, 'River', '4PM - 9AM', '4', 'fish', 'fish_Soft_shelled_turtle.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (93, 'Snapping Turtle', 5000, 'River', '9PM - 4AM', '4', 'fish', 'fish_Snapping_Turtle.png', 'Uncommon', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (94, 'Tadpole', 100, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Tadpole.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (95, 'Frog', 120, 'Pond', 'ALL DAY', '2', 'fish', 'fish_Frog.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (96, 'Freshwater goby', 400, 'River', '4PM - 9AM', '2', 'fish', 'fish_Freshwater_goby.png', 'Uncommon (★★★) - Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (97, 'Loach', 400, 'River', 'ALL DAY', '2', 'fish', 'fish_Loach.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (98, 'Catfish', 800, 'Pond', '4PM - 9AM', '4', 'fish', 'fish_Catfish.png', 'Fairly Common (★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (99, 'Giant snakehead', 5500, 'Pond', '9AM - 4PM', '4', 'fish', 'fish_Giant_snakehead.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (100, 'Bluegill', 180, 'River', '9AM - 4PM', '2', 'fish', 'fish_Bluegill.png', 'Uncommon', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (101, 'Yellow perch', 300, 'River', 'ALL DAY', '3', 'fish', 'fish_Yellow_perch.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (102, 'Black bass', 320, 'River', 'ALL DAY', '4', 'fish', 'fish_Black_bass.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (103, 'Tilapia', 800, 'River', 'ALL DAY', '3', 'fish', 'fish_Tilapia.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (104, 'Pike', 1800, 'River', 'ALL DAY', '5', 'fish', 'fish_Pike.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (105, 'Pond smelt', 500, 'River', 'ALL DAY', '2', 'fish', 'fish_Pond_smelt.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (106, 'Sweetfish', 900, 'River', 'ALL DAY', '3', 'fish', 'fish_Sweetfish.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (107, 'Cherry salmon', 800, 'River (Clifftop)', '4PM - 9AM', '3', 'fish', 'fish_Cherry_salmon.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (108, 'Char', 3800, 'River (Clifftop)  Pond', '4PM - 9AM', '3', 'fish', 'fish_Char.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (109, 'Golden trout', 15000, 'River (Clifftop)', '4PM - 9AM', '3', 'fish', 'fish_Golden_trout.png', 'unknown', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (110, 'Stringfish', 15000, 'River (Clifftop)', '4PM - 9AM', '5', 'fish', 'fish_Stringfish.png', 'Rare (★★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (111, 'Salmon', 700, 'River (Mouth)', 'ALL DAY', '4', 'fish', 'fish_Salmon.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (112, 'King salmon', 1800, 'River (Mouth)', 'ALL DAY', '6', 'fish', 'fish_King_salmon.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (113, 'Mitten crab', 2000, 'River', '4PM - 9AM', '2', 'fish', 'fish_Mitten_crab.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (114, 'Guppy', 1300, 'River', '9AM - 4PM', '1', 'fish', 'fish_Guppy.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (115, 'Nibble fish', 1500, 'River', '9AM - 4PM', '1', 'fish', 'fish_Nibble_fish.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (116, 'Angelfish', 3000, 'River', '4PM - 9AM', '2', 'fish', 'fish_Angelfish.png', 'Uncommon', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (117, 'Betta', 2500, 'River', '9AM - 4PM', '2', 'fish', 'fish_Betta.png', 'Unknown', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (118, 'Neon tetra', 500, 'River', '9AM - 4PM', '1', 'fish', 'fish_Neon_tetra.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (119, 'Rainbowfish', 800, 'River', '9AM - 4PM', '1', 'fish', 'fish_Rainbowfish.png', 'Unknown', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (120, 'Piranha', 2500, 'River', '9AM - 4PM', '2', 'fish', 'fish_Piranha.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (121, 'Arowana', 10000, 'River', '4PM - 9AM', '4', 'fish', 'fish_Arowana.png', 'Rare', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (122, 'Dorado', 15000, 'River', '4AM - 9PM', '5', 'fish', 'fish_Dorado.png', 'Rare (★★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (123, 'Gar', 6000, 'Pond', '4PM - 9AM', '5', 'fish', 'fish_Gar.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (124, 'Arapaima', 10000, 'River', '4PM - 9AM', '6', 'fish', 'fish_Arapaima.png', 'Rare', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (125, 'Saddled bichir', 4000, 'River', '9PM - 4AM', '4', 'fish', 'fish_Saddled_bichir.png', 'Rare', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (126, 'Sturgeon', 10000, 'River (Mouth)', 'ALL DAY', '6', 'fish', 'fish_Sturgeon.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (127, 'Sea butterfly', 1000, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Sea_butterfly.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (128, 'Sea horse', 1100, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Sea_horse.png', 'Fairly Common (★★) (AFe+), Uncommon (★★★) (WW, CF)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (129, 'Clown fish', 650, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Clown_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (130, 'Surgeonfish', 1000, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Surgeonfish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (131, 'Butterfly fish', 1000, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Butterfly_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (132, 'Napoleonfish', 10000, 'Sea', '4AM - 9PM', '6', 'fish', 'fish_Napoleonfish.png', 'Scarce (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (133, 'Zebra turkeyfish', 500, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Zebra_turkeyfish.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (134, 'Blowfish', 5000, 'Sea', '9PM - 4AM', '3', 'fish', 'fish_Blowfish.png', 'Scarce (★★★★)', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (135, 'Puffer fish', 250, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Puffer_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (136, 'Anchovy', 200, 'Sea', '4AM - 9PM', '2', 'fish', 'fish_Anchovy.png', 'Uncommon (★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (137, 'Horse mackerel', 150, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Horse_mackerel.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (138, 'Barred knifejaw', 5000, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Barred_knifejaw.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (139, 'Sea bass', 400, 'Sea', 'ALL DAY', '5', 'fish', 'fish_Sea_bass.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (140, 'Red snapper', 3000, 'Sea', 'ALL DAY', '4', 'fish', 'fish_Red_snapper.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (141, 'Dab', 300, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Dab.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (142, 'Olive flounder', 800, 'Sea', 'ALL DAY', '5', 'fish', 'fish_Olive_flounder.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (143, 'Squid', 500, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Squid.png', 'Uncommon (★★★) (AFe+), Fairly Common (★★) (WW, CF)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (144, 'Moray eel', 2000, 'Sea', 'ALL DAY', 'Narrow', 'fish', 'fish_Moray_eel.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (145, 'Ribbon eel', 600, 'Sea', 'ALL DAY', 'Narrow', 'fish', 'fish_Ribbon_eel.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (146, 'Tuna', 7000, 'Pier', 'ALL DAY', '6', 'fish', 'fish_Tuna.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (147, 'Blue marlin', 10000, 'Pier', 'ALL DAY', '6', 'fish', 'fish_Blue_marlin.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (148, 'Giant trevally', 4500, 'Pier', 'ALL DAY', '5', 'fish', 'fish_Giant_trevally.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (149, 'Mahi-mahi', 6000, 'Pier', 'ALL DAY', '5', 'fish', 'fish_Mahi_mahi.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (150, 'Ocean sunfish', 4000, 'Sea', '4AM - 9PM', '6 (Fin)', 'fish', 'fish_Ocean_sunfish.png', 'Rare (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (151, 'Ray', 3000, 'Sea', '4AM - 9PM', '5', 'fish', 'fish_Ray.png', 'Scarce (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (152, 'Saw shark', 12000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Saw_shark.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (153, 'Hammerhead shark', 8000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Hammerhead_shark.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (154, 'Great white shark', 15000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Great_white_shark.png', 'Rare (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (155, 'Whale shark', 13000, 'Sea', 'ALL DAY', '6 (Fin)', 'fish', 'fish_Whale_shark.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (156, 'Suckerfish', 1500, 'Sea', 'ALL DAY', '4 (Fin)', 'fish', 'fish_Suckerfish.png', 'Uncommon', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (157, 'Football fish', 2500, 'Sea', '4PM - 9AM', '4', 'fish', 'fish_Football_fish.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (158, 'Oarfish', 9000, 'Sea', 'ALL DAY', '6', 'fish', 'fish_Oarfish.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (159, 'Barreleye', 15000, 'Sea', '9PM - 4AM', '2', 'fish', 'fish_Barreleye.png', 'Scarce (★★★★)', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) values (160, 'Coelacanth', 15000, 'Sea (while raining)', 'ALL DAY', '6', 'fish', 'fish_Coelacanth.png', 'Very Rare (★★★★★)', 0, '00:00', '23:59', 0);
commit;

begin transaction;
    replace into northern_months (ID, CritterName, Months) values (1, 'Common butterfly', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (2, 'Yellow butterfly', 'Mar Apr May Jun Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (3, 'Tiger butterfly', 'Mar Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (4, 'Peacock butterfly', 'Mar Apr May Jun');
    replace into northern_months (ID, CritterName, Months) values (5, 'Common bluebottle', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (6, 'Paper kite butterfly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (7, 'Great purple emperor', 'May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (8, 'Monarch butterfly', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (9, 'Emperor butterfly', 'Jan Feb Mar Jun Jul Aug Sep Dec');
    replace into northern_months (ID, CritterName, Months) values (10, 'Agrias butterfly', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (11, 'Rajah Brooke''s birdwing', 'Jan Feb Apr May Jun Jul Aug Sep Dec');
    replace into northern_months (ID, CritterName, Months) values (12, 'Queen Alexandra''s birdwing', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (13, 'Moth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (14, 'Atlas moth', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (15, 'Madagascan sunset moth', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (16, 'Long locust', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (17, 'Migratory locust', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (18, 'Rice grasshopper', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (19, 'Grasshopper', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (20, 'Cricket', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (21, 'Bell cricket', 'Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (22, 'Mantis', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (23, 'Orchid mantis', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (24, 'Honeybee', 'Mar Apr May Jun Jul');
    replace into northern_months (ID, CritterName, Months) values (25, 'Wasp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (26, 'Brown cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (27, 'Robust cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (28, 'Giant cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (29, 'Walker cicada', 'Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (30, 'Evening cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (31, 'Cicada shell', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (32, 'Red dragonfly', 'Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (33, 'Darner dragonfly', 'Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (34, 'Banded dragonfly', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (35, 'Damselfly', 'Jan Feb Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (36, 'Firefly', 'Jun');
    replace into northern_months (ID, CritterName, Months) values (37, 'Mole cricket', 'Jan Feb Mar Apr May Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (38, 'Pondskater', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (39, 'Diving beetle', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (40, 'Giant water bug', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (41, 'Stinkbug', 'Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (42, 'Man-faced stink bug', 'Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (43, 'Ladybug', 'Mar Apr May Jun Oct');
    replace into northern_months (ID, CritterName, Months) values (44, 'Tiger beetle', 'Feb Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (45, 'Jewel beetle', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (46, 'Violin beetle', 'May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (47, 'Citrus long-horned beetle', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (48, 'Rosalia batesi beetle', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (49, 'Blue weevil beetle', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (50, 'Dung beetle', 'Jan Feb Dec');
    replace into northern_months (ID, CritterName, Months) values (51, 'Earth-boring dung beetle', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (52, 'Scarab beetle', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (53, 'Drone beetle', 'Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (54, 'Goliath beetle', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (55, 'Saw stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (56, 'Miyama stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (57, 'Giant stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (58, 'Rainbow stag', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (59, 'Cyclommatus stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (60, 'Golden stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (61, 'Giraffe stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (62, 'Horned dynastid', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (63, 'Horned atlas', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (64, 'Horned elephant', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (65, 'Horned hercules', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (66, 'Walking stick', 'Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (67, 'Walking leaf', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (68, 'Bagworm', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (69, 'Ant', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (70, 'Hermit crab', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (71, 'Wharf roach', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (72, 'Fly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (73, 'Mosquito', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (74, 'Flea', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (75, 'Snail', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (76, 'Pill bug', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (77, 'Centipede', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (78, 'Spider', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (79, 'Tarantula', 'Jan Feb Mar Apr Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (80, 'Scorpion', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (81, 'Bitterling', 'Jan Feb Mar Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (82, 'Pale chub', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (83, 'Crucian carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (84, 'Dace', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (85, 'Carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (86, 'Koi', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (87, 'Goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (88, 'Pop-eyed goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (89, 'Ranchu goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (90, 'Killifish', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (91, 'Crawfish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (92, 'Soft-shelled turtle', 'Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (93, 'Snapping Turtle', 'Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (94, 'Tadpole', 'Mar Apr May Jun Jul');
    replace into northern_months (ID, CritterName, Months) values (95, 'Frog', 'May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (96, 'Freshwater goby', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (97, 'Loach', 'Mar Apr May');
    replace into northern_months (ID, CritterName, Months) values (98, 'Catfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (99, 'Giant snakehead', 'Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (100, 'Bluegill', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (101, 'Yellow perch', 'Jan Feb Mar Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (102, 'Black bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (103, 'Tilapia', 'Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (104, 'Pike', 'Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (105, 'Pond smelt', 'Jan Feb Dec');
    replace into northern_months (ID, CritterName, Months) values (106, 'Sweetfish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (107, 'Cherry salmon', 'Mar Apr May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (108, 'Char', 'Mar Apr May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (109, 'Golden trout', 'Mar Apr May Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (110, 'Stringfish', 'Jan Feb Mar Dec');
    replace into northern_months (ID, CritterName, Months) values (111, 'Salmon', 'Sep');
    replace into northern_months (ID, CritterName, Months) values (112, 'King salmon', 'Sep');
    replace into northern_months (ID, CritterName, Months) values (113, 'Mitten crab', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (114, 'Guppy', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (115, 'Nibble fish', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (116, 'Angelfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (117, 'Betta', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (118, 'Neon tetra', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (119, 'Rainbowfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (120, 'Piranha', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (121, 'Arowana', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (122, 'Dorado', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (123, 'Gar', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (124, 'Arapaima', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (125, 'Saddled bichir', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (126, 'Sturgeon', 'Jan Feb Mar Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (127, 'Sea butterfly', 'Jan Feb Mar Dec');
    replace into northern_months (ID, CritterName, Months) values (128, 'Sea horse', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (129, 'Clown fish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (130, 'Surgeonfish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (131, 'Butterfly fish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (132, 'Napoleonfish', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) values (133, 'Zebra turkeyfish', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (134, 'Blowfish', 'Jan Feb Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (135, 'Puffer fish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (136, 'Anchovy', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (137, 'Horse mackerel', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (138, 'Barred knifejaw', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (139, 'Sea bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (140, 'Red snapper', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (141, 'Dab', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (142, 'Olive flounder', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (143, 'Squid', 'Jan Feb Mar Apr May Jun Jul Aug Dec');
    replace into northern_months (ID, CritterName, Months) values (144, 'Moray eel', 'Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (145, 'Ribbon eel', 'Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (146, 'Tuna', 'Jan Feb Mar Apr Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (147, 'Blue marlin', 'Jan Feb Mar Apr Jul Aug Sep Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (148, 'Giant trevally', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (149, 'Mahi-mahi', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) values (150, 'Ocean sunfish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (151, 'Ray', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) values (152, 'Saw shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (153, 'Hammerhead shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (154, 'Great white shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (155, 'Whale shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (156, 'Suckerfish', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) values (157, 'Football fish', 'Jan Feb Mar Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (158, 'Oarfish', 'Jan Feb Mar Apr May Dec');
    replace into northern_months (ID, CritterName, Months) values (159, 'Barreleye', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) values (160, 'Coelacanth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
commit;

begin transaction;
    replace into southern_months (ID, CritterName, Months) values (1, 'Common butterfly', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (2, 'Yellow butterfly', 'Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (3, 'Tiger butterfly', 'Jan Feb Mar Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (4, 'Peacock butterfly', 'Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (5, 'Common bluebottle', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (6, 'Paper kite butterfly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (7, 'Great purple emperor', 'Jan Feb Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (8, 'Monarch butterfly', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (9, 'Emperor butterfly', 'Jan Feb Mar Jun Jul Aug Sep Dec');
    replace into southern_months (ID, CritterName, Months) values (10, 'Agrias butterfly', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (11, 'Rajah Brooke''s birdwing', 'Jan Feb Mar Jun Jul Aug Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (12, 'Queen Alexandra''s birdwing', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (13, 'Moth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (14, 'Atlas moth', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (15, 'Madagascan sunset moth', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (16, 'Long locust', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (17, 'Migratory locust', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (18, 'Rice grasshopper', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (19, 'Grasshopper', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (20, 'Cricket', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (21, 'Bell cricket', 'Mar Apr');
    replace into southern_months (ID, CritterName, Months) values (22, 'Mantis', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (23, 'Orchid mantis', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (24, 'Honeybee', 'Jan Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (25, 'Wasp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (26, 'Brown cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (27, 'Robust cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (28, 'Giant cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (29, 'Walker cicada', 'Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (30, 'Evening cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (31, 'Cicada shell', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (32, 'Red dragonfly', 'Mar Apr');
    replace into southern_months (ID, CritterName, Months) values (33, 'Darner dragonfly', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (34, 'Banded dragonfly', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (35, 'Damselfly', 'May Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) values (36, 'Firefly', 'Dec');
    replace into southern_months (ID, CritterName, Months) values (37, 'Mole cricket', 'May Jun Jul Aug Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) values (38, 'Pondskater', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (39, 'Diving beetle', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (40, 'Giant water bug', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (41, 'Stinkbug', 'Jan Feb Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (42, 'Man-faced stink bug', 'Jan Feb Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (43, 'Ladybug', 'Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (44, 'Tiger beetle', 'Jan Feb Mar Apr Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (45, 'Jewel beetle', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (46, 'Violin beetle', 'Mar Apr May Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (47, 'Citrus long-horned beetle', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (48, 'Rosalia batesi beetle', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (49, 'Blue weevil beetle', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (50, 'Dung beetle', 'Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) values (51, 'Earth-boring dung beetle', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (52, 'Scarab beetle', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (53, 'Drone beetle', 'Jan Feb Dec');
    replace into southern_months (ID, CritterName, Months) values (54, 'Goliath beetle', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (55, 'Saw stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (56, 'Miyama stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (57, 'Giant stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (58, 'Rainbow stag', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (59, 'Cyclommatus stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (60, 'Golden stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (61, 'Giraffe stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (62, 'Horned dynastid', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (63, 'Horned atlas', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (64, 'Horned elephant', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (65, 'Horned hercules', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (66, 'Walking stick', 'Jan Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (67, 'Walking leaf', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (68, 'Bagworm', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (69, 'Ant', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (70, 'Hermit crab', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (71, 'Wharf roach', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (72, 'Fly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (73, 'Mosquito', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (74, 'Flea', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (75, 'Snail', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (76, 'Pill bug', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (77, 'Centipede', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (78, 'Spider', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (79, 'Tarantula', 'May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) values (80, 'Scorpion', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (81, 'Bitterling', 'May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (82, 'Pale chub', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (83, 'Crucian carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (84, 'Dace', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (85, 'Carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (86, 'Koi', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (87, 'Goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (88, 'Pop-eyed goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (89, 'Ranchu goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (90, 'Killifish', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (91, 'Crawfish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (92, 'Soft-shelled turtle', 'Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (93, 'Snapping turtle', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (94, 'Tadpole', 'Jan Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (95, 'Frog', 'Jan Feb Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (96, 'Freshwater goby', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (97, 'Loach', 'Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) values (98, 'Catfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (99, 'Giant snakehead', 'Jan Feb Dec');
    replace into southern_months (ID, CritterName, Months) values (100, 'Bluegill', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (101, 'Yellow perch', 'Apr May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (102, 'Black bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (103, 'Tilapia', 'Jan Feb Mar Apr Dec');
    replace into southern_months (ID, CritterName, Months) values (104, 'Pike', 'Mar Apr May Jun');
    replace into southern_months (ID, CritterName, Months) values (105, 'Pond smelt', 'Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) values (106, 'Sweetfish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (107, 'Cherry salmon', 'Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (108, 'Char', 'Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (109, 'Golden trout', 'Mar Apr May Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) values (110, 'Stringfish', 'Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (111, 'Salmon', 'Mar');
    replace into southern_months (ID, CritterName, Months) values (112, 'King salmon', 'Mar');
    replace into southern_months (ID, CritterName, Months) values (113, 'Mitten crab', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (114, 'Guppy', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (115, 'Nibble fish', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (116, 'Angelfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (117, 'Betta', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (118, 'Neon tetra', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (119, 'Rainbowfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (120, 'Piranha', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (121, 'Arowana', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (122, 'Dorado', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (123, 'Gar', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (124, 'Arapaima', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (125, 'Saddled bichir', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (126, 'Sturgeon', 'Mar Apr May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (127, 'Sea butterfly', 'Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (128, 'Sea horse', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (129, 'Clown fish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (130, 'Surgeonfish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (131, 'Butterfly fish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (132, 'Napoleonfish', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) values (133, 'Zebra turkeyfish', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (134, 'Blowfish', 'May Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) values (135, 'Puffer fish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (136, 'Anchovy', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (137, 'Horse mackerel', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (138, 'Barred knifejaw', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (139, 'Sea bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (140, 'Red snapper', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (141, 'Dab', 'Apr May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) values (142, 'Olive flounder', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (143, 'Squid', 'Jan Feb Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (144, 'Moray eel', 'Feb Mar Apr');
    replace into southern_months (ID, CritterName, Months) values (145, 'Ribbon eel', 'Jan Feb Mar Apr Dec');
    replace into southern_months (ID, CritterName, Months) values (146, 'Tuna', 'May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) values (147, 'Blue marlin', 'Jan Feb Mar May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) values (148, 'Giant trevally', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (149, 'Mahi-mahi', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (150, 'Ocean sunfish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) values (151, 'Ray', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) values (152, 'Saw shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (153, 'Hammerhead shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (154, 'Great white shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (155, 'Whale shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (156, 'Suckerfish', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) values (157, 'Football fish', 'May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) values (158, 'Oarfish', 'Jun Jul Aug Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) values (159, 'Barreleye', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) values (160, 'Coelacanth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
commit;

begin transaction;
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (1, 'Admiral', '♂ Cranky', 'Bird', 'January 27th', '"aye aye"', 'villager_Admiral.png', 'villager_icon_Admiral.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (2, 'Agent S', '♀ Peppy', 'Squirrel', 'July 2nd', '"sidekick"', 'villager_Agent_S.png', 'villager_icon_Agent_S.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (3, 'Agnes', '♀ Sisterly', 'Pig', 'April 21st', '"snuffle"', 'villager_Agnes.png', 'villager_icon_Agnes.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (4, 'Al', '♂ Lazy', 'Gorilla', 'October 18th', '"Ayyeeee"', 'villager_Al.png', 'villager_icon_Al.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (5, 'Alfonso', '♂ Lazy', 'Alligator', 'June 9th', '"it''sa me"', 'villager_Alfonso.png', 'villager_icon_Alfonso.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (6, 'Alice', '♀ Normal', 'Koala', 'August 19th', '"guvnor"', 'villager_Alice.png', 'villager_icon_Alice.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (7, 'Alli', '♀ Snooty', 'Alligator', 'November 8th', '"graaagh"', 'villager_Alli.png', 'villager_icon_Alli.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (8, 'Amelia', '♀ Snooty', 'Eagle', 'November 19th', '"cuz"', 'villager_Amelia.png', 'villager_icon_Amelia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (9, 'Anabelle', '♀ Peppy', 'Anteater', 'February 16th', '"snorty"', 'villager_Anabelle.png', 'villager_icon_Anabelle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (10, 'Anchovy', '♂ Lazy', 'Bird', 'March 4th', '"chuurp"', 'villager_Anchovy.png', 'villager_icon_Anchovy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (11, 'Ankha', '♀ Snooty', 'Cat', 'September 22nd', '"me meow"', 'villager_Ankha.png', 'villager_icon_Ankha.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (12, 'Angus', '♂ Cranky', 'Bull', 'April 30th', '"macmoo"', 'villager_Angus.png', 'villager_icon_Angus.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (13, 'Anicotti', '♀ Peppy', 'Mouse', 'February 24th', '"cannoli"', 'villager_Anicotti.png', 'villager_icon_Anicotti.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (14, 'Annalisa', '♀ Normal', 'Anteater', 'February 6th', '"gumdrop"', 'villager_Annalisa.png', 'villager_icon_Annalisa.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (15, 'Annalise', '♀ Snooty', 'Horse', 'December 2nd', '"nipper"', 'villager_Annalise.png', 'villager_icon_Annalise.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (16, 'Antonio', '♂ Jock', 'Anteater', 'October 20th', '"honk"', 'villager_Antonio.png', 'villager_icon_Antonio.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (17, 'Apollo', '♂ Cranky', 'Eagle', 'July 4th', '"pah"', 'villager_Apollo.png', 'villager_icon_Apollo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (18, 'Apple', '♀ Peppy', 'Hamster', 'September 24th', '"cheekers"', 'villager_Apple.png', 'villager_icon_Apple.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (19, 'Astrid', '♀ Snooty', 'Kangaroo', 'September 8th', '"my pet"', 'villager_Astrid.png', 'villager_icon_Astrid.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (20, 'Audie', '♀ Peppy', 'Wolf', 'August 31st', '"Foxtrot"', 'villager_Audie.png', 'villager_icon_Audie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (21, 'Aurora', '♀ Normal', 'Penguin', 'January 27th', '"b-b-baby"', 'villager_Aurora.png', 'villager_icon_Aurora.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (22, 'Ava', '♀ Normal', 'Chicken', 'April 28th', '"beaker"', 'villager_Ava.png', 'villager_icon_Ava.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (23, 'Avery', '♂ Cranky', 'Eagle', 'February 22nd', '"skree-haw"', 'villager_Avery.png', 'villager_icon_Avery.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (24, 'Axel', '♂ Jock', 'Elephant', 'March 23rd', '"WHONK"', 'villager_Axel.png', 'villager_icon_Axel.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (25, 'Baabara', '♀ Snooty', 'Sheep', 'March 28th', '"daahling"', 'villager_Baabara.png', 'villager_icon_Baabara.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (26, 'Bam', '♂ Jock', 'Deer', 'November 7th', '"kablang"', 'villager_Bam.png', 'villager_icon_Bam.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (27, 'Bangle', '♀ Peppy', 'Tiger', 'August 27th', '"growf"', 'villager_Bangle.png', 'villager_icon_Bangle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (28, 'Barold', '♂ Lazy', 'Cub', 'March 2nd', '"cubby"', 'villager_Barold.png', 'villager_icon_Barold.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (29, 'Beau', '♂ Lazy', 'Deer', 'April 5th', '"saltlick"', 'villager_Beau.png', 'villager_icon_Beau.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (30, 'Bea', '♀ Normal', 'Dog', 'October 15th', '"bingo"', 'villager_Bea.png', 'villager_icon_Bea.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (31, 'Beardo', '♂ Smug', 'Bear', 'September 27th', '"whiskers"', 'villager_Beardo.png', 'villager_icon_Beardo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (32, 'Becky', '♀ Snooty', 'Chicken', 'December 9th', '"chicklet"', 'villager_Becky.png', 'villager_icon_Becky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (33, 'Bella', '♀ Peppy', 'Mouse', 'December 28th', '"eeks"', 'villager_Bella.png', 'villager_icon_Bella.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (34, 'Benedict', '♂ Lazy', 'Chicken', 'October 10th', '"uh-hoo"', 'villager_Benedict.png', 'villager_icon_Benedict.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (35, 'Benjamin', '♂ Lazy', 'Dog', 'August 3rd', '"alrighty"', 'villager_Benjamin.png', 'villager_icon_Benjamin.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (36, 'Bertha', '♀ Normal', 'Hippo', 'April 25th', '"bloop"', 'villager_Bertha.png', 'villager_icon_Bertha.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (37, 'Bettina', '♀ Normal', 'Mouse', 'June 12th', '"eekers"', 'villager_Bettina.png', 'villager_icon_Bettina.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (38, 'Bianca', '♀ Peppy', 'Tiger', 'December 13th', '"glimmer"', 'villager_Bianca.png', 'villager_icon_Bianca.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (39, 'Biff', '♂ Jock', 'Hippo', 'March 29th', '"squirt"', 'villager_Biff.png', 'villager_icon_Biff.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (40, 'Big Top', '♂ Lazy', 'Elephant', 'October 3rd', '"villain"', 'villager_Big_Top.png', 'villager_icon_Big_Top.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (41, 'Bill', '♂ Jock', 'Duck', 'February 1st', '"quacko"', 'villager_Bill.png', 'villager_icon_Bill.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (42, 'Billy', '♂ Jock', 'Goat', 'March 25th', '"dagnaabit"', 'villager_Billy.png', 'villager_icon_Billy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (43, 'Biskit', '♂ Lazy', 'Dog', 'May 13th', '"dog"', 'villager_Biskit.png', 'villager_icon_Biskit.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (44, 'Bitty', '♀ Snooty', 'Hippo', 'October 6th', '"my dear"', 'villager_Bitty.png', 'villager_icon_Bitty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (45, 'Blaire', '♀ Snooty', 'Squirrel', 'July 3rd', '"nutlet"', 'villager_Blaire.png', 'villager_icon_Blaire.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (46, 'Blanche', '♀ Snooty', 'Ostrich', 'December 21st', '"quite so"', 'villager_Blanche.png', 'villager_icon_Blanche.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (47, 'Bluebear', '♀ Peppy', 'Cub', 'June 24th', '"peach"', 'villager_Bluebear.png', 'villager_icon_Bluebear.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (48, 'Bob', '♂ Lazy', 'Cat', 'January 1st', '"pthhhpth"', 'villager_Bob.png', 'villager_icon_Bob.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (49, 'Bonbon', '♀ Peppy', 'Rabbit', 'March 3rd', '"deelish"', 'villager_Bonbon.png', 'villager_icon_Bonbon.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (50, 'Bones', '♂ Lazy', 'Dog', 'August 4th', '"yip yip"', 'villager_Bones.png', 'villager_icon_Bones.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (51, 'Boomer', '♂ Lazy', 'Penguin', 'February 7th', '"human"', 'villager_Boomer.png', 'villager_icon_Boomer.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (52, 'Boone', '♂ Jock', 'Gorilla', 'September 12th', '"baboom"', 'villager_Boone.png', 'villager_icon_Boone.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (53, 'Boots', '♂ Jock', 'Alligator', 'August 7th', '"munchie"', 'villager_Boots.png', 'villager_icon_Boots.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (54, 'Boris', '♂ Cranky', 'Pig', 'November 6th', '"schnort"', 'villager_Boris.png', 'villager_icon_Boris.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (55, 'Boyd', '♂ Cranky', 'Gorilla', 'October 1st', '"uh-oh"', 'villager_Boyd.png', 'villager_icon_Boyd.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (56, 'Bree', '♀ Snooty', 'Mouse', 'July 7th', '"cheeseball"', 'villager_Bree.png', 'villager_icon_Bree.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (57, 'Broccolo', '♂ Lazy', 'Mouse', 'June 30th', '"eat it"', 'villager_Broccolo.png', 'villager_icon_Broccolo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (58, 'Bruce', '♂ Cranky', 'Deer', 'May 26th', '"gruff"', 'villager_Bruce.png', 'villager_icon_Bruce.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (59, 'Broffina', '♀ Snooty', 'Chicken', 'October 24th', '"cluckadoo"', 'villager_Broffina.png', 'villager_icon_Broffina.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (60, 'Bubbles', '♀ Peppy', 'Hippo', 'September 18th', '"hipster"', 'villager_Bubbles.png', 'villager_icon_Bubbles.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (61, 'Buck', '♂ Jock', 'Horse', 'April 4th', '"pardner"', 'villager_Buck.png', 'villager_icon_Buck.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (62, 'Bud', '♂ Jock', 'Lion', 'August 8th', '"shredded"', 'villager_Bud.png', 'villager_icon_Bud.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (63, 'Bunnie', '♀ Peppy', 'Rabbit', 'May 9th', '"tee-hee"', 'villager_Bunnie.png', 'villager_icon_Bunnie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (64, 'Butch', '♂ Cranky', 'Dog', 'November 1st', '"ROOOOOWF"', 'villager_Butch.png', 'villager_icon_Butch.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (65, 'Buzz', '♂ Cranky', 'Eagle', 'December 7th', '"captain"', 'villager_Buzz.png', 'villager_icon_Buzz.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (66, 'Cally', '♀ Normal', 'Squirrel', 'September 4th', '"WHEE"', 'villager_Cally.png', 'villager_icon_Cally.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (67, 'Camofrog', '♂ Cranky', 'Frog', 'June 5th', '"ten-hut"', 'villager_Camofrog.png', 'villager_icon_Camofrog.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (68, 'Canberra', '♀ Sisterly', 'Koala', 'May 14th', '"nuh uh"', 'villager_Canberra.png', 'villager_icon_Canberra.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (69, 'Candi', '♀ Peppy', 'Mouse', 'April 13th', '"sweetie"', 'villager_Candi.png', 'villager_icon_Candi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (70, 'Carmen', '♀ Peppy', 'Rabbit', 'January 6th', '"nougat"', 'villager_Carmen.png', 'villager_icon_Carmen.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (71, 'Caroline', '♀ Normal', 'Squirrel', 'July 15th', '"hulaaaa"', 'villager_Caroline.png', 'villager_icon_Caroline.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (72, 'Carrie', '♀ Normal', 'Kangaroo', 'December 5th', '"little one"', 'villager_Carrie.png', 'villager_icon_Carrie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (73, 'Cashmere', '♀ Snooty', 'Sheep', 'April 2nd', '"baaaby"', 'villager_Cashmere.png', 'villager_icon_Cashmere.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (74, 'Celia', '♀ Normal', 'Eagle', 'March 25th', '"feathers"', 'villager_Celia.png', 'villager_icon_Celia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (75, 'Cesar', '♂ Cranky', 'Gorilla', 'September 6th', '"highness"', 'villager_Cesar.png', 'villager_icon_Cesar.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (76, 'Chadder', '♂ Smug', 'Mouse', 'December 15th', '"fromage"', 'villager_Chadder.png', 'villager_icon_Chadder.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (77, 'Charlise', '♀ Sisterly', 'Bear', 'April 17th', '"urgh"', 'villager_Charlise.png', 'villager_icon_Charlise.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (78, 'Cheri', '♀ Peppy', 'Cub', 'March 17th', '"tralala"', 'villager_Cheri.png', 'villager_icon_Cheri.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (79, 'Cherry', '♀ Sisterly', 'Dog', 'May 11th', '"what what"', 'villager_Cherry.png', 'villager_icon_Cherry.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (80, 'Chester', '♂ Lazy', 'Cub', 'August 6th', '"rookie"', 'villager_Chester.png', 'villager_icon_Chester.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (81, 'Chevre', '♀ Normal', 'Goat', 'March 6th', '"la baa"', 'villager_Chevre.png', 'villager_icon_Chevre.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (82, 'Chief', '♂ Cranky', 'Wolf', 'December 19th', '"harrumph"', 'villager_Chief.png', 'villager_icon_Chief.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (83, 'Chops', '♂ Smug', 'Pig', 'October 13th', '"zoink"', 'villager_Chops.png', 'villager_icon_Chops.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (84, 'Chow', '♂ Cranky', 'Bear', 'July 22nd', '"aiya"', 'villager_Chow.png', 'villager_icon_Chow.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (85, 'Chrissy', '♀ Peppy', 'Rabbit', 'August 28th', '"sparkles"', 'villager_Chrissy.png', 'villager_icon_Chrissy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (86, 'Claude', '♂ Lazy', 'Rabbit', 'December 3rd', '"hopalong"', 'villager_Claude.png', 'villager_icon_Claude.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (87, 'Claudia', '♀ Snooty', 'Tiger', 'November 22nd', '"ooh la la"', 'villager_Claudia.png', 'villager_icon_Claudia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (88, 'Clay', '♂ Lazy', 'Hamster', 'October 19th', '"thump"', 'villager_Clay.png', 'villager_icon_Clay.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (89, 'Cleo', '♀ Snooty', 'Horse', 'February 9th', '"sugar"', 'villager_Cleo.png', 'villager_icon_Cleo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (90, 'Clyde', '♂ Lazy', 'Horse', 'May 1st', '"clip-clawp"', 'villager_Clyde.png', 'villager_icon_Clyde.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (91, 'Coach', '♂ Jock', 'Bull', 'April 29th', '"stubble"', 'villager_Coach.png', 'villager_icon_Coach.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (92, 'Cobb', '♂ Jock', 'Pig', 'October 7th', '"hot dog"', 'villager_Cobb.png', 'villager_icon_Cobb.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (93, 'Coco', '♀ Normal', 'Rabbit', 'March 1st', '"doyoing"', 'villager_Coco.png', 'villager_icon_Coco.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (94, 'Cole', '♂ Lazy', 'Rabbit', 'August 10th', '"duuude"', 'villager_Cole.png', 'villager_icon_Cole.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (95, 'Colton', '♂ Smug', 'Horse', 'May 22nd', '"check it"', 'villager_Colton.png', 'villager_icon_Colton.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (96, 'Cookie', '♀ Peppy', 'Dog', 'June 18th', '"arfer"', 'villager_Cookie.png', 'villager_icon_Cookie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (97, 'Cousteau', '♂ Jock', 'Frog', 'December 17th', '"oui oui"', 'villager_Cousteau.png', 'villager_icon_Cousteau.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (98, 'Cranston', '♂ Lazy', 'Ostrich', 'September 23rd', '"sweatband"', 'villager_Cranston.png', 'villager_icon_Cranston.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (99, 'Croque', '♂ Cranky', 'Frog', 'July 18th', '"as if"', 'villager_Croque.png', 'villager_icon_Croque.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (100, 'Cube', '♂ Lazy', 'Penguin', 'January 29th', '"d-d-dude"', 'villager_Cube.png', 'villager_icon_Cube.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (101, 'Curlos', '♂ Smug', 'Sheep', 'May 8th', '"shearly"', 'villager_Curlos.png', 'villager_icon_Curlos.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (102, 'Curly', '♂ Jock', 'Pig', 'July 26th', '"nyoink"', 'villager_Curly.png', 'villager_icon_Curly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (103, 'Curt', '♂ Cranky', 'Bear', 'July 1st', '"fuzzball"', 'villager_Curt.png', 'villager_icon_Curt.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (104, 'Cyd', '♂ Cranky', 'Elephant', 'June 9th', '"rockin''"', 'villager_Cyd.png', 'villager_icon_Cyd.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (105, 'Cyrano', '♂ Cranky', 'Anteater', 'March 9th', '"ah-CHOO"', 'villager_Cyrano.png', 'villager_icon_Cyrano.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (106, 'Daisy', '♀ Normal', 'Dog', 'November 16th', '"bow-WOW"', 'villager_Daisy.png', 'villager_icon_Daisy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (107, 'Deena', '♀ Normal', 'Duck', 'June 27th', '"woowoo"', 'villager_Deena.png', 'villager_icon_Deena.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (108, 'Deirdre', '♀ Sisterly', 'Deer', 'May 4th', '"whatevs"', 'villager_Deirdre.png', 'villager_icon_Deirdre.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (109, 'Del', '♂ Cranky', 'Alligator', 'May 27th', '"gronk"', 'villager_Del.png', 'villager_icon_Del.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (110, 'Deli', '♂ Lazy', 'Monkey', 'May 24th', '"monch"', 'villager_Deli.png', 'villager_icon_Deli.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (111, 'Derwin', '♂ Lazy', 'Duck', 'May 25th', '"derrrrr"', 'villager_Derwin.png', 'villager_icon_Derwin.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (112, 'Diana', '♀ Snooty', 'Deer', 'January 4th', '"no doy"', 'villager_Diana.png', 'villager_icon_Diana.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (113, 'Diva', '♀ Sisterly', 'Frog', 'October 2nd', '"ya know"', 'villager_Diva.png', 'villager_icon_Diva.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (114, 'Dizzy', '♂ Lazy', 'Elephant', 'January 14th', '"woo-oo"', 'villager_Dizzy.png', 'villager_icon_Dizzy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (115, 'Dobie', '♂ Cranky', 'Wolf', 'February 17th', '"ohmmm"', 'villager_Dobie.png', 'villager_icon_Dobie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (116, 'Doc', '♂ Lazy', 'Rabbit', 'March 16th', '"ol'' bunny"', 'villager_Doc.png', 'villager_icon_Doc.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (117, 'Dom', '♂ Jock', 'Sheep', 'March 18th', '"indeedaroo"', 'villager_Dom.png', 'villager_icon_Dom.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (118, 'Dora', '♀ Normal', 'Mouse', 'February 18th', '"squeaky"', 'villager_Dora.png', 'villager_icon_Dora.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (119, 'Dotty', '♀ Peppy', 'Rabbit', 'March 14th', '"wee one"', 'villager_Dotty.png', 'villager_icon_Dotty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (120, 'Drago', '♂ Lazy', 'Alligator', 'February 12th', '"burrrn"', 'villager_Drago.png', 'villager_icon_Drago.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (121, 'Drake', '♂ Lazy', 'Duck', 'June 25th', '"quacko"', 'villager_Drake.png', 'villager_icon_Drake.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (122, 'Drift', '♂ Jock', 'Frog', 'October 9th', '"brah"', 'villager_Drift.png', 'villager_icon_Drift.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (123, 'Ed', '♂ Smug', 'Horse', 'September 16th', '"greenhorn"', 'villager_Ed.png', 'villager_icon_Ed.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (124, 'Egbert', '♂ Lazy', 'Chicken', 'October 14th', '"doodle-duh"', 'villager_Egbert.png', 'villager_icon_Egbert.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (125, 'Elise', '♀ Snooty', 'Monkey', 'March 21st', '"puh-lease"', 'villager_Elise.png', 'villager_icon_Elise.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (126, 'Ellie', '♀ Normal', 'Elephant', 'May 12th', '"li''l one"', 'villager_Ellie.png', 'villager_icon_Ellie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (127, 'Elmer', '♂ Lazy', 'Horse', 'October 5th', '"tenderfoot"', 'villager_Elmer.png', 'villager_icon_Elmer.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (128, 'Eloise', '♀ Snooty', 'Elephant', 'December 8th', '"tooooot"', 'villager_Eloise.png', 'villager_icon_Eloise.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (129, 'Elvis', '♂ Cranky', 'Lion', 'July 23rd', '"unh-hunh"', 'villager_Elvis.png', 'villager_icon_Elvis.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (130, 'Erik', '♂ Lazy', 'Deer', 'July 27th', '"chow down"', 'villager_Erik.png', 'villager_icon_Erik.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (131, 'Eunice', '♀ Normal', 'Sheep', 'April 3rd', '"lambchop"', 'villager_Eunice.png', 'villager_icon_Eunice.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (132, 'Eugene', '♂ Smug', 'Koala', 'October 26th', '"yeah buddy"', 'villager_Eugene.png', 'villager_icon_Eugene.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (133, 'Fang', '♂ Cranky', 'Wolf', 'December 18th', '"cha-chomp"', 'villager_Fang.png', 'villager_icon_Fang.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (134, 'Fauna', '♀ Normal', 'Deer', 'March 26th', '"dearie"', 'villager_Fauna.png', 'villager_icon_Fauna.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (135, 'Felicity', '♀ Peppy', 'Cat', 'March 30th', '"mimimi"', 'villager_Felicity.png', 'villager_icon_Felicity.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (136, 'Filbert', '♂ Lazy', 'Squirrel', 'June 3rd', '"bucko"', 'villager_Filbert.png', 'villager_icon_Filbert.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (137, 'Flip', '♂ Jock', 'Monkey', 'November 21st', '"rerack"', 'villager_Flip.png', 'villager_icon_Flip.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (138, 'Flo', '♀ Sisterly', 'Penguin', 'September 2nd', '"cha"', 'villager_Flo.png', 'villager_icon_Flo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (139, 'Flora', '♀ Peppy', 'Ostrich', 'February 9th', '"pinky"', 'villager_Flora.png', 'villager_icon_Flora.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (140, 'Flurry', '♀ Normal', 'Hamster', 'January 30th', '"powderpuff"', 'villager_Flurry.png', 'villager_icon_Flurry.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (141, 'Francine', '♀ Snooty', 'Rabbit', 'January 22nd', '"karat"', 'villager_Francine.png', 'villager_icon_Francine.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (142, 'Frank', '♂ Cranky', 'Eagle', 'July 30th', '"crushy"', 'villager_Frank.png', 'villager_icon_Frank.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (143, 'Freckles', '♀ Peppy', 'Duck', 'February 19th', '"ducky"', 'villager_Freckles.png', 'villager_icon_Freckles.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (144, 'Freya', '♀ Snooty', 'Wolf', 'December 14th', '"uff da"', 'villager_Freya.png', 'villager_icon_Freya.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (145, 'Friga', '♀ Snooty', 'Penguin', 'October 16th', '"brrmph"', 'villager_Friga.png', 'villager_icon_Friga.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (146, 'Frita', '♀ Sisterly', 'Sheep', 'July 16th', '"oh ewe"', 'villager_Frita.png', 'villager_icon_Frita.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (147, 'Frobert', '♂ Jock', 'Frog', 'February 8th', '"fribbit"', 'villager_Frobert.png', 'villager_icon_Frobert.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (148, 'Fuchsia', '♀ Sisterly', 'Deer', 'September 19th', '"precious"', 'villager_Fuchsia.png', 'villager_icon_Fuchsia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (149, 'Gabi', '♀ Peppy', 'Rabbit', 'December 16th', '"honeybun"', 'villager_Gabi.png', 'villager_icon_Gabi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (150, 'Gala', '♀ Normal', 'Pig', 'March 5th', '"snortie"', 'villager_Gala.png', 'villager_icon_Gala.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (151, 'Gaston', '♂ Cranky', 'Rabbit', 'October 28th', '"mon chou"', 'villager_Gaston.png', 'villager_icon_Gaston.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (152, 'Gayle', '♀ Normal', 'Alligator', 'May 17th', '"snacky"', 'villager_Gayle.png', 'villager_icon_Gayle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (153, 'Genji', '♂ Jock', 'Rabbit', 'January 21st', '"mochi"', 'villager_Genji.png', 'villager_icon_Genji.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (154, 'Gigi', '♀ Snooty', 'Frog', 'August 11th', '"ribette"', 'villager_Gigi.png', 'villager_icon_Gigi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (155, 'Gladys', '♀ Normal', 'Ostrich', 'January 15th', '"stretch"', 'villager_Gladys.png', 'villager_icon_Gladys.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (156, 'Gloria', '♀ Snooty', 'Duck', 'August 12th', '"quacker"', 'villager_Gloria.png', 'villager_icon_Gloria.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (157, 'Goldie', '♀ Normal', 'Dog', 'December 27th', '"woof"', 'villager_Goldie.png', 'villager_icon_Goldie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (158, 'Gonzo', '♂ Cranky', 'Koala', 'October 13th', '"mate"', 'villager_Gonzo.png', 'villager_icon_Gonzo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (159, 'Goose', '♂ Jock', 'Chicken', 'October 4th', '"buh-kay"', 'villager_Goose.png', 'villager_icon_Goose.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (160, 'Graham', '♂ Smug', 'Hamster', 'June 20th', '"indeed"', 'villager_Graham.png', 'villager_icon_Graham.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (161, 'Greta', '♀ Snooty', 'Mouse', 'September 5th', '"yelp"', 'villager_Greta.png', 'villager_icon_Greta.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (162, 'Grizzly', '♂ Cranky', 'Bear', 'July 31st', '"grrr..."', 'villager_Grizzly.png', 'villager_icon_Grizzly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (163, 'Groucho', '♂ Cranky', 'Bear', 'October 23rd', '"grumble"', 'villager_Groucho.png', 'villager_icon_Groucho.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (164, 'Gruff', '♂ Cranky', 'Goat', 'August 29th', '"bleh eh eh"', 'villager_Gruff.png', 'villager_icon_Gruff.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (165, 'Gwen', '♀ Snooty', 'Penguin', 'January 23rd', '"h-h-hon"', 'villager_Gwen.png', 'villager_icon_Gwen.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (166, 'Hamlet', '♂ Jock', 'Hamster', 'May 30th', '"hammie"', 'villager_Hamlet.png', 'villager_icon_Hamlet.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (167, 'Hamphrey', '♂ Cranky', 'Hamster', 'February 25th', '"snort"', 'villager_Hamphrey.png', 'villager_icon_Hamphrey.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (168, 'Hans', '♂ Smug', 'Gorilla', 'December 5th', '"groovy"', 'villager_Hans.png', 'villager_icon_Hans.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (169, 'Harry', '♂ Cranky', 'Hippo', 'January 7th', '"beach bum"', 'villager_Harry.png', 'villager_icon_Harry.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (170, 'Hazel', '♀ Sisterly', 'Squirrel', 'August 30th', '"uni-wow"', 'villager_Hazel.png', 'villager_icon_Hazel.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (171, 'Henry', '♂ Smug', 'Frog', 'September 21st', '"snoozit"', 'villager_Henry.png', 'villager_icon_Henry.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (172, 'Hippeux', '♂ Smug', 'Hippo', 'October 15th', '"natch"', 'villager_Hippeux.png', 'villager_icon_Hippeux.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (173, 'Hopkins', '♂ Lazy', 'Rabbit', 'March 11th', '"thumper"', 'villager_Hopkins.png', 'villager_icon_Hopkins.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (174, 'Hopper', '♂ Cranky', 'Penguin', 'April 6th', '"slushie"', 'villager_Hopper.png', 'villager_icon_Hopper.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (175, 'Hornsby', '♂ Lazy', 'Rhino', 'March 20th', '"schnozzle"', 'villager_Hornsby.png', 'villager_icon_Hornsby.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (176, 'Huck', '♂ Smug', 'Frog', 'July 9th', '"hopper"', 'villager_Huck.png', 'villager_icon_Huck.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (177, 'Hugh', '♂ Lazy', 'Pig', 'December 30th', '"snortle"', 'villager_Hugh.png', 'villager_icon_Hugh.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (178, 'Iggly', '♂ Jock', 'Penguin', 'November 2nd', '"waddler"', 'villager_Iggly.png', 'villager_icon_Iggly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (179, 'Ike', '♂ Cranky', 'Bear', 'May 16th', '"roadie"', 'villager_Ike.png', 'villager_icon_Ike.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (180, 'JacobNAJakeyPAL', '♂ Lazy', 'Bird', 'August 24th', '"chuuuuurp"', 'villager_Jacob.png', 'villager_icon_Jacob.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (181, 'Jacques', '♂ Smug', 'Bird', 'June 22nd', '"zut alors"', 'villager_Jacques.png', 'villager_icon_Jacques.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (182, 'Jambette', '♀ Normal', 'Frog', 'October 27th', '"croak-kay"', 'villager_Jambette.png', 'villager_icon_Jambette.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (183, 'Jay', '♂ Jock', 'Bird', 'July 17th', '"heeeeeyy"', 'villager_Jay.png', 'villager_icon_Jay.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (184, 'Jeremiah', '♂ Lazy', 'Frog', 'July 8th', '"nee-deep"', 'villager_Jeremiah.png', 'villager_icon_Jeremiah.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (185, 'Jitters', '♂ Jock', 'Bird', 'February 2nd', '"bzzert"', 'villager_Jitters.png', 'villager_icon_Jitters.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (186, 'Joey', '♂ Lazy', 'Duck', 'January 3rd', '"bleeeeeck"', 'villager_Joey.png', 'villager_icon_Joey.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (187, 'Judy', '♀ Snooty', 'Cub', 'March 10th', '"myohmy"', 'villager_Judy.png', 'villager_icon_Judy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (188, 'Julia', '♀ Snooty', 'Ostrich', 'July 31st', '"dahling"', 'villager_Julia.png', 'villager_icon_Julia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (189, 'Julian', '♂ Smug', 'Horse', 'March 15th', '"glitter"', 'villager_Julian.png', 'villager_icon_Julian.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (190, 'June', '♀ Normal', 'Cub', 'May 21st', '"rainbow"', 'villager_June.png', 'villager_icon_June.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (191, 'Kabuki', '♂ Cranky', 'Cat', 'November 29th', '"meooo-OH"', 'villager_Kabuki.png', 'villager_icon_Kabuki.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (192, 'Katt', '♀ Sisterly', 'Cat', 'April 27th', '"purrty"', 'villager_Katt.png', 'villager_icon_Katt.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (193, 'Keaton', '♂ Smug', 'Eagle', 'June 1st', '"wingo"', 'villager_Keaton.png', 'villager_icon_Keaton.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (194, 'Ken', '♂ Smug', 'Chicken', 'December 23rd', '"no doubt"', 'villager_Ken.png', 'villager_icon_Ken.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (195, 'Ketchup', '♀ Peppy', 'Duck', 'July 27th', '"bitty"', 'villager_Ketchup.png', 'villager_icon_Ketchup.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (196, 'Kevin', '♂ Jock', 'Pig', 'April 26th', '"weeweewee"', 'villager_Kevin.png', 'villager_icon_Kevin.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (197, 'Kid Cat', '♂ Jock', 'Cat', 'August 1st', '"psst"', 'villager_Kid_Cat.png', 'villager_icon_Kid_Cat.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (198, 'Kidd', '♂ Smug', 'Goat', 'June 28th', '"wut"', 'villager_Kidd.png', 'villager_icon_Kidd.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (199, 'Kiki', '♀ Normal', 'Cat', 'October 8th', '"kitty cat"', 'villager_Kiki.png', 'villager_icon_Kiki.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (200, 'Kitt', '♀ Normal', 'Kangaroo', 'October 11th', '"child"', 'villager_Kitt.png', 'villager_icon_Kitt.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (201, 'Kitty', '♀ Snooty', 'Cat', 'February 15th', '"mrowrr"', 'villager_Kitty.png', 'villager_icon_Kitty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (202, 'Klaus', '♂ Smug', 'Bear', 'March 31st', '"strudel"', 'villager_Klaus.png', 'villager_icon_Klaus.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (203, 'Knox', '♂ Cranky', 'Chicken', 'November 23rd', '"cluckling"', 'villager_Knox.png', 'villager_icon_Knox.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (204, 'Kody', '♂ Jock', 'Cub', 'September 28th', '"grah-grah"', 'villager_Kody.png', 'villager_icon_Kody.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (205, 'Kyle', '♂ Smug', 'Wolf', 'December 6th', '"alpha"', 'villager_Kyle.png', 'villager_icon_Kyle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (206, 'Leonardo', '♂ Jock', 'Tiger', 'May 15th', '"flexin"', 'villager_Leonardo.png', 'villager_icon_Leonardo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (207, 'Leopold', '♂ Smug', 'Lion', 'August 14th', '"lion cub"', 'villager_Leopold.png', 'villager_icon_Leopold.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (208, 'Lily', '♀ Normal', 'Frog', 'February 4th', '"toady"', 'villager_Lily.png', 'villager_icon_Lily.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (209, 'Limberg', '♂ Cranky', 'Mouse', 'October 17th', '"squinky"', 'villager_Limberg.png', 'villager_icon_Limberg.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (210, 'Lionel', '♂ Smug', 'Lion', 'July 29th', '"precisely"', 'villager_Lionel.png', 'villager_icon_Lionel.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (211, 'Lobo', '♂ Cranky', 'Wolf', 'November 5th', '"ah-rooooo"', 'villager_Lobo.png', 'villager_icon_Lobo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (212, 'Lolly', '♀ Normal', 'Cat', 'March 27th', '"bonbon"', 'villager_Lolly.png', 'villager_icon_Lolly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (213, 'Lopez', '♂ Smug', 'Deer', 'August 20th', '"buckaroo"', 'villager_Lopez.png', 'villager_icon_Lopez.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (214, 'Louie', '♂ Jock', 'Gorilla', 'March 26th', '"hoo hoo ha"', 'villager_Louie.png', 'villager_icon_Louie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (215, 'Lucha', '♂ Smug', 'Bird', 'December 12th', '"cacaw"', 'villager_Lucha.png', 'villager_icon_Lucha.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (216, 'Lucky', '♂ Lazy', 'Dog', 'November 4th', '"rrr-owch"', 'villager_Lucky.png', 'villager_icon_Lucky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (217, 'Lucy', '♀ Normal', 'Pig', 'June 2nd', '"snoooink"', 'villager_Lucy.png', 'villager_icon_Lucy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (218, 'Lyman', '♂ Jock', 'Koala', 'October 12th', '"chips"', 'villager_Lyman.png', 'villager_icon_Lyman.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (219, 'Mac', '♂ Jock', 'Dog', 'November 11th', '"woo woof"', 'villager_Mac.png', 'villager_icon_Mac.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (220, 'Maddie', '♀ Peppy', 'Dog', 'January 11th', '"yippee"', 'villager_Maddie.png', 'villager_icon_Maddie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (221, 'Maelle', '♀ Snooty', 'Duck', 'April 8th', '"duckling"', 'villager_Maelle.png', 'villager_icon_Maelle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (222, 'Maggie', '♀ Normal', 'Pig', 'September 3rd', '"schep"', 'villager_Maggie.png', 'villager_icon_Maggie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (223, 'Mallary', '♀ Snooty', 'Duck', 'November 17th', '"quackpth"', 'villager_Mallary.png', 'villager_icon_Mallary.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (224, 'Maple', '♀ Normal', 'Cub', 'June 15th', '"honey"', 'villager_Maple.png', 'villager_icon_Maple.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (225, 'Margie', '♀ Normal', 'Elephant', 'January 28th', '"tootie"', 'villager_Margie.png', 'villager_icon_Margie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (226, 'Marcel', '♂ Lazy', 'Dog', 'December 31st', '"non"', 'villager_Marcel.png', 'villager_icon_Marcel.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (227, 'Marcie', '♀ Normal', 'Kangaroo', 'May 31st', '"pouches"', 'villager_Marcie.png', 'villager_icon_Marcie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (228, 'Marina', '♀ Normal', 'Octopus', 'June 26th', '"blurp"', 'villager_Marina.png', 'villager_icon_Marina.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (229, 'Marshal', '♂ Smug', 'Squirrel', 'September 29th', '"sulky"', 'villager_Marshal.png', 'villager_icon_Marshal.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (230, 'Mathilda', '♀ Snooty', 'Kangaroo', 'November 12th', '"wee baby"', 'villager_Mathilda.png', 'villager_icon_Mathilda.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (231, 'Megan', '♀ Normal', 'Bear', 'March 13th', '"sundae"', 'villager_Megan.png', 'villager_icon_Megan.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (232, 'Melba', '♀ Normal', 'Koala', 'April 12th', '"toasty"', 'villager_Melba.png', 'villager_icon_Melba.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (233, 'Merengue', '♀ Normal', 'Rhino', 'March 19th', '"shortcake"', 'villager_Merengue.png', 'villager_icon_Merengue.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (234, 'Merry', '♀ Peppy', 'Cat', 'June 29th', '"mweee"', 'villager_Merry.png', 'villager_icon_Merry.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (235, 'Midge', '♀ Normal', 'Bird', 'March 12th', '"tweedledee"', 'villager_Midge.png', 'villager_icon_Midge.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (236, 'Mint', '♀ Snooty', 'Squirrel', 'May 2nd', '"ahhhhhh"', 'villager_Mint.png', 'villager_icon_Mint.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (237, 'Mira', '♀ Sisterly', 'Rabbit', 'July 6th', '"cottontail"', 'villager_Mira.png', 'villager_icon_Mira.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (238, 'Miranda', '♀ Snooty', 'Duck', 'April 23rd', '"quackulous"', 'villager_Miranda.png', 'villager_icon_Miranda.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (239, 'Mitzi', '♀ Normal', 'Cat', 'September 25th', '"mew"', 'villager_Mitzi.png', 'villager_icon_Mitzi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (240, 'Moe', '♂ Lazy', 'Cat', 'January 12th', '"myawn"', 'villager_Moe.png', 'villager_icon_Moe.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (241, 'Molly', '♀ Normal', 'Duck', 'March 7th', '"quackidee"', 'villager_Molly.png', 'villager_icon_Molly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (242, 'Monique', '♀ Snooty', 'Cat', 'September 30th', '"pffffft"', 'villager_Monique.png', 'villager_icon_Monique.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (243, 'Monty', '♂ Cranky', 'Monkey', 'December 7th', '"g''tang"', 'villager_Monty.png', 'villager_icon_Monty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (244, 'Moose', '♂ Jock', 'Mouse', 'September 13th', '"shorty"', 'villager_Moose.png', 'villager_icon_Moose.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (245, 'Mott', '♂ Jock', 'Lion', 'July 10th', '"cagey"', 'villager_Mott.png', 'villager_icon_Mott.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (246, 'Muffy', '♀ Sisterly', 'Sheep', 'February 14th', '"nightshade"', 'villager_Muffy.png', 'villager_icon_Muffy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (247, 'Murphy', '♂ Cranky', 'Cub', 'December 29th', '"laddie"', 'villager_Murphy.png', 'villager_icon_Murphy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (248, 'Nan', '♀ Normal', 'Goat', 'August 24th', '"kid"', 'villager_Nan.png', 'villager_icon_Nan.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (249, 'Nana', '♀ Normal', 'Monkey', 'August 23rd', '"po po"', 'villager_Nana.png', 'villager_icon_Nana.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (250, 'Naomi', '♀ Snooty', 'Cow', 'February 28th', '"moolah"', 'villager_Naomi.png', 'villager_icon_Naomi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (251, 'Nate', '♂ Lazy', 'Bear', 'August 16th', '"yawwwn"', 'villager_Nate.png', 'villager_icon_Nate.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (252, 'Nibbles', '♀ Peppy', 'Squirrel', 'July 19th', '"niblet"', 'villager_Nibbles.png', 'villager_icon_Nibbles.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (253, 'Norma', '♀ Normal', 'Cow', 'September 20th', '"hoof hoo"', 'villager_Norma.png', 'villager_icon_Norma.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (254, 'Octavian', '♂ Cranky', 'Octopus', 'September 20th', '"sucker"', 'villager_Octavian.png', 'villager_icon_Octavian.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (255, 'O''Hare', '♂ Smug', 'Rabbit', 'July 24th', '"amigo"', 'villager_OHare.png', 'villager_icon_OHare.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (256, 'Olaf', '♂ Smug', 'Anteater', 'May 19th', '"whiffa"', 'villager_Olaf.png', 'villager_icon_Olaf.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (257, 'Olive', '♀ Normal', 'Cub', 'July 12th', '"sweet pea"', 'villager_Olive.png', 'villager_icon_Olive.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (258, 'Olivia', '♀ Snooty', 'Cat', 'February 3rd', '"purrr"', 'villager_Olivia.png', 'villager_icon_Olivia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (259, 'Opal', '♀ Snooty', 'Elephant', 'January 20th', '"snoot"', 'villager_Opal.png', 'villager_icon_Opal.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (260, 'Ozzie', '♂ Lazy', 'Koala', 'May 7th', '"ol'' bear"', 'villager_Ozzie.png', 'villager_icon_Ozzie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (261, 'Pancetti', '♀ Snooty', 'Pig', 'November 14th', '"sooey"', 'villager_Pancetti.png', 'villager_icon_Pancetti.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (262, 'Pango', '♀ Peppy', 'Anteater', 'November 9th', '"snooooof"', 'villager_Pango.png', 'villager_icon_Pango.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (263, 'Papi', '♂ Lazy', 'Horse', 'January 10th', '"haaay"', 'villager_Papi.png', 'villager_icon_Papi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (264, 'Paolo', '♂ Lazy', 'Elephant', 'May 5th', '"pal"', 'villager_Paolo.png', 'villager_icon_Paolo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (265, 'Pashmina', '♀ Sisterly', 'Goat', 'December 26th', '"kidders"', 'villager_Pashmina.png', 'villager_icon_Pashmina.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (266, 'Pate', '♀ Peppy', 'Duck', 'February 23rd', '"quackle"', 'villager_Pate.png', 'villager_icon_Pate.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (267, 'Patty', '♀ Peppy', 'Cow', 'May 10th', '"how-now"', 'villager_Patty.png', 'villager_icon_Patty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (268, 'Paula', '♀ Sisterly', 'Bear', 'March 22nd', '"yodelay"', 'villager_Paula.png', 'villager_icon_Paula.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (269, 'Peaches', '♀ Normal', 'Horse', 'November 28th', '"neighbor"', 'villager_Peaches.png', 'villager_icon_Peaches.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (270, 'Peanut', '♀ Peppy', 'Squirrel', 'June 8th', '"slacker"', 'villager_Peanut.png', 'villager_icon_Peanut.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (271, 'Pecan', '♀ Snooty', 'Squirrel', 'September 10th', '"chipmunk"', 'villager_Pecan.png', 'villager_icon_Pecan.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (272, 'Peck', '♂ Jock', 'Bird', 'July 25th', '"crunch"', 'villager_Peck.png', 'villager_icon_Peck.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (273, 'Peewee', '♂ Cranky', 'Gorilla', 'September 11th', '"li''l dude"', 'villager_Peewee.png', 'villager_icon_Peewee.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (274, 'Peggy', '♀ Peppy', 'Pig', 'May 23rd', '"shweetie"', 'villager_Peggy.png', 'villager_icon_Peggy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (275, 'Pekoe', '♀ Normal', 'Cub', 'May 18th', '"bud"', 'villager_Pekoe.png', 'villager_icon_Pekoe.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (276, 'Penelope', '♀ Peppy', 'Mouse', 'February 5th', '"oh bow"', 'villager_Penelope.png', 'villager_icon_Penelope.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (277, 'Phil', '♂ Smug', 'Ostrich', 'November 27th', '"hurk"', 'villager_Phil.png', 'villager_icon_Phil.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (278, 'Phoebe', '♀ Sisterly', 'Ostrich', 'April 22nd', '"sparky"', 'villager_Phoebe.png', 'villager_icon_Phoebe.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (279, 'Pierce', '♂ Jock', 'Eagle', 'January 8th', '"hawkeye"', 'villager_Pierce.png', 'villager_icon_Pierce.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (280, 'Pietro', '♂ Smug', 'Sheep', 'April 19th', '"honk honk"', 'villager_Pietro.png', 'villager_icon_Pietro.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (281, 'Pinky', '♀ Peppy', 'Bear', 'September 9th', '"wah"', 'villager_Pinky.png', 'villager_icon_Pinky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (282, 'Piper', '♀ Peppy', 'Bird', 'April 18th', '"chickadee"', 'villager_Piper.png', 'villager_icon_Piper.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (283, 'Pippy', '♀ Peppy', 'Rabbit', 'June 14th', '"li''l hare"', 'villager_Pippy.png', 'villager_icon_Pippy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (284, 'Plucky', '♀ Sisterly', 'Chicken', 'October 12th', '"chicky-poo"', 'villager_Plucky.png', 'villager_icon_Plucky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (285, 'Pompom', '♀ Peppy', 'Duck', 'February 11th', '"rah rah"', 'villager_Pompom.png', 'villager_icon_Pompom.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (286, 'Poncho', '♂ Jock', 'Cub', 'January 2nd', '"li''l bear"', 'villager_Poncho.png', 'villager_icon_Poncho.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (287, 'Poppy', '♀ Normal', 'Squirrel', 'August 5th', '"nutty"', 'villager_Poppy.png', 'villager_icon_Poppy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (288, 'Portia', '♀ Snooty', 'Dog', 'October 25th', '"ruffian"', 'villager_Portia.png', 'villager_icon_Portia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (289, 'Prince', '♂ Lazy', 'Frog', 'July 21st', '"burrup"', 'villager_Prince.png', 'villager_icon_Prince.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (290, 'Puck', '♂ Lazy', 'Penguin', 'February 21st', '"brrrrrrrrr"', 'villager_Puck.png', 'villager_icon_Puck.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (291, 'Puddles', '♀ Peppy', 'Frog', 'January 13th', '"splish"', 'villager_Puddles.png', 'villager_icon_Puddles.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (292, 'Pudge', '♂ Lazy', 'Cub', 'June 11th', '"pudgy"', 'villager_Pudge.png', 'villager_icon_Pudge.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (293, 'Punchy', '♂ Lazy', 'Cat', 'April 11th', '"mrmpht"', 'villager_Punchy.png', 'villager_icon_Punchy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (294, 'Purrl', '♀ Snooty', 'Cat', 'May 29th', '"kitten"', 'villager_Purrl.png', 'villager_icon_Purrl.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (295, 'Queenie', '♀ Snooty', 'Ostrich', 'November 13th', '"chicken"', 'villager_Queenie.png', 'villager_icon_Queenie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (296, 'Quillson', '♂ Smug', 'Duck', 'December 22nd', '"ridukulous"', 'villager_Quillson.png', 'villager_icon_Quillson.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (297, 'Raddle', '♂ Lazy', 'Frog', 'June 6th', '"aaach-"', 'villager_Raddle.png', 'villager_icon_Raddle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (298, 'Rasher', '♂ Cranky', 'Pig', 'April 7th', '"swine"', 'villager_Rasher.png', 'villager_icon_Rasher.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (299, 'Raymond', '♂ Smug', 'Cat', 'October 1st', '"crisp"', 'villager_Raymond.png', 'villager_icon_Raymond.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (300, 'Renée', '♀ Sisterly', 'Rhino', 'May 28th', '"yo yo yo"', 'villager_Renee.png', 'villager_icon_Renee.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (301, 'Reneigh', '♀ Sisterly', 'Horse', 'June 4th', '"ayup, yup"', 'villager_Reneigh.png', 'villager_icon_Reneigh.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (302, 'Rex', '♂ Lazy', 'Lion', 'July 24th', '"cool cat"', 'villager_Rex.png', 'villager_icon_Rex.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (303, 'Rhonda', '♀ Normal', 'Rhino', 'January 24th', '"bigfoot"', 'villager_Rhonda.png', 'villager_icon_Rhonda.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (304, 'Ribbot', '♂ Jock', 'Frog', 'February 13th', '"zzrrbbitt"', 'villager_Ribbot.png', 'villager_icon_Ribbot.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (305, 'Ricky', '♂ Cranky', 'Squirrel', 'September 14th', '"nutcase"', 'villager_Ricky.png', 'villager_icon_Ricky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (306, 'Rizzo', '♂ Cranky', 'Mouse', 'January 17th', '"squee"', 'villager_Rizzo.png', 'villager_icon_Rizzo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (307, 'Roald', '♂ Jock', 'Penguin', 'January 5th', '"b-b-buddy"', 'villager_Roald.png', 'villager_icon_Roald.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (308, 'Robin', '♀ Snooty', 'Bird', 'December 4th', '"la-di-da"', 'villager_Robin.png', 'villager_icon_Robin.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (309, 'Rocco', '♂ Cranky', 'Hippo', 'August 18th', '"hippie"', 'villager_Rocco.png', 'villager_icon_Rocco.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (310, 'Rocket', '♀ Sisterly', 'Gorilla', 'April 14th', '"vroom"', 'villager_Rocket.png', 'villager_icon_Rocket.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (311, 'Rod', '♂ Jock', 'Mouse', 'August 14th', '"ace"', 'villager_Rod.png', 'villager_icon_Rod.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (312, 'Rodeo', '♂ Lazy', 'Bull', 'October 29th', '"chaps"', 'villager_Rodeo.png', 'villager_icon_Rodeo.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (313, 'Rodney', '♂ Smug', 'Hamster', 'November 10th', '"le ham"', 'villager_Rodney.png', 'villager_icon_Rodney.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (314, 'Rolf', '♂ Cranky', 'Tiger', 'August 22nd', '"grrrolf"', 'villager_Rolf.png', 'villager_icon_Rolf.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (315, 'Rooney', '♂ Cranky', 'Kangaroo', 'December 1st', '"punches"', 'villager_Rooney.png', 'villager_icon_Rooney.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (316, 'Rory', '♂ Jock', 'Lion', 'August 7th', '"capital"', 'villager_Rory.png', 'villager_icon_Rory.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (317, 'Roscoe', '♂ Cranky', 'Horse', 'June 16th', '"nay"', 'villager_Roscoe.png', 'villager_icon_Roscoe.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (318, 'Rosie', '♀ Peppy', 'Cat', 'February 27th', '"silly"', 'villager_Rosie.png', 'villager_icon_Rosie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (319, 'Rowan', '♂ Jock', 'Tiger', 'August 26th', '"mango"', 'villager_Rowan.png', 'villager_icon_Rowan.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (320, 'Ruby', '♀ Peppy', 'Rabbit', 'December 25th', '"li''l ears"', 'villager_Ruby.png', 'villager_icon_Ruby.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (321, 'Rudy', '♂ Jock', 'Cat', 'December 20th', '"mush"', 'villager_Rudy.png', 'villager_icon_Rudy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (322, 'Sally', '♀ Normal', 'Squirrel', 'June 19th', '"nutmeg"', 'villager_Sally.png', 'villager_icon_Sally.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (323, 'Samson', '♂ Jock', 'Mouse', 'July 5th', '"pipsqueak"', 'villager_Samson.png', 'villager_icon_Samson.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (324, 'Sandy', '♀ Normal', 'Ostrich', 'October 21st', '"speedy"', 'villager_Sandy.png', 'villager_icon_Sandy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (325, 'Savannah', '♀ Normal', 'Horse', 'January 25th', '"y''all"', 'villager_Savannah.png', 'villager_icon_Savannah.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (326, 'Scoot', '♂ Jock', 'Duck', 'June 13th', '"zip zoom"', 'villager_Scoot.png', 'villager_icon_Scoot.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (327, 'Shari', '♀ Sisterly', 'Monkey', 'April 10th', '"cheeky"', 'villager_Shari.png', 'villager_icon_Shari.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (328, 'Sheldon', '♂ Jock', 'Squirrel', 'February 26th', '"cardio"', 'villager_Sheldon.png', 'villager_icon_Sheldon.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (329, 'Shep', '♂ Smug', 'Dog', 'November 24th', '"baaa man"', 'villager_Shep.png', 'villager_icon_Shep.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (330, 'Sherb', '♂ Lazy', 'Goat', 'January 18th', '"bawwww"', 'villager_Sherb.png', 'villager_icon_Sherb.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (331, 'Simon', '♂ Lazy', 'Monkey', 'January 19th', '"zzzook"', 'villager_Simon.png', 'villager_icon_Simon.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (332, 'Skye', '♀ Normal', 'Wolf', 'March 24th', '"airmail"', 'villager_Skye.png', 'villager_icon_Skye.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (333, 'Sly', '♂ Jock', 'Alligator', 'November 15th', '"hoo-rah"', 'villager_Sly.png', 'villager_icon_Sly.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (334, 'Snake', '♂ Jock', 'Rabbit', 'November 3rd', '"bunyip"', 'villager_Snake.png', 'villager_icon_Snake.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (335, 'Snooty', '♀ Snooty', 'Anteater', 'August 24th', '"snifffff"', 'villager_Snooty.png', 'villager_icon_Snooty.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (336, 'Soleil', '♀ Snooty', 'Hamster', 'August 9th', '"tarnation"', 'villager_Soleil.png', 'villager_icon_Soleil.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (337, 'Sparro', '♂ Jock', 'Bird', 'November 20th', '"like whoa"', 'villager_Sparro.png', 'villager_icon_Sparro.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (338, 'Spike', '♂ Cranky', 'Rhino', 'June 17th', '"punk"', 'villager_Spike.png', 'villager_icon_Spike.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (339, 'Spork', '♂ Lazy', 'Pig', 'September 3rd', '"snork"', 'villager_Spork.png', 'villager_icon_Spork.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (340, 'Sprinkle', '♀ Peppy', 'Penguin', 'February 20th', '"frappe"', 'villager_Sprinkle.png', 'villager_icon_Sprinkle.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (341, 'Sprocket', '♂ Jock', 'Ostrich', 'December 1st', '"zort"', 'villager_Sprocket.png', 'villager_icon_Sprocket.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (342, 'Static', '♂ Cranky', 'Squirrel', 'July 9th', '"krzzt"', 'villager_Static.png', 'villager_icon_Static.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (343, 'Stella', '♀ Normal', 'Sheep', 'April 9th', '"baa-dabing"', 'villager_Stella.png', 'villager_icon_Stella.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (344, 'Sterling', '♂ Jock', 'Eagle', 'December 11th', '"skraaaaw"', 'villager_Sterling.png', 'villager_icon_Sterling.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (345, 'Stinky', '♂ Jock', 'Cat', 'August 17th', '"GAHHHH"', 'villager_Stinky.png', 'villager_icon_Stinky.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (346, 'Stitches', '♂ Lazy', 'Cub', 'February 10th', '"stuffin''"', 'villager_Stitches.png', 'villager_icon_Stitches.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (347, 'Stu', '♂ Lazy', 'Bull', 'April 20th', '"moo-dude"', 'villager_Stu.png', 'villager_icon_Stu.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (348, 'Sydney', '♀ Normal', 'Koala', 'June 21st', '"sunshine"', 'villager_Sydney.png', 'villager_icon_Sydney.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (349, 'Sylvana', '♀ Normal', 'Squirrel', 'October 22nd', '"hubbub"', 'villager_Sylvana.png', 'villager_icon_Sylvana.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (350, 'Sylvia', '♀ Sisterly', 'Kangaroo', 'May 3rd', '"boing"', 'villager_Sylvia.png', 'villager_icon_Sylvia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (351, 'Tabby', '♀ Peppy', 'Cat', 'August 13th', '"me-WOW"', 'villager_Tabby.png', 'villager_icon_Tabby.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (352, 'Tad', '♂ Jock', 'Frog', 'August 3rd', '"sluuuurp"', 'villager_Tad.png', 'villager_icon_Tad.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (353, 'Tammi', '♀ Peppy', 'Monkey', 'April 2nd', '"chimpy"', 'villager_Tammi.png', 'villager_icon_Tammi.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (354, 'Tammy', '♀ Sisterly', 'Cub', 'June 23rd', '"ya heard"', 'villager_Tammy.png', 'villager_icon_Tammy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (355, 'Tangy', '♀ Peppy', 'Cat', 'June 17th', '"reeeeOWR"', 'villager_Tangy.png', 'villager_icon_Tangy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (356, 'Tank', '♂ Jock', 'Rhino', 'May 6th', '"kerPOW"', 'villager_Tank.png', 'villager_icon_Tank.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (357, 'T-Bone', '♂ Cranky', 'Bull', 'May 20th', '"moocher"', 'villager_T_Bone.png', 'villager_icon_T_Bone.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (358, 'Tasha', '♀ Snooty', 'Squirrel', 'November 30th', '"nice nice"', 'villager_Tasha.png', 'villager_icon_Tasha.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (359, 'Teddy', '♂ Jock', 'Bear', 'September 26th', '"grooof"', 'villager_Teddy.png', 'villager_icon_Teddy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (360, 'Tex', '♂ Smug', 'Penguin', 'October 6th', '"picante"', 'villager_Tex.png', 'villager_icon_Tex.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (361, 'Tia', '♀ Normal', 'Elephant', 'November 18th', '"teacup"', 'villager_Tia.png', 'villager_icon_Tia.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (362, 'Tiffany', '♀ Snooty', 'Rabbit', 'January 9th', '"bun bun"', 'villager_Tiffany.png', 'villager_icon_Tiffany.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (363, 'Timbra', '♀ Snooty', 'Sheep', 'October 21st', '"pine nut"', 'villager_Timbra.png', 'villager_icon_Timbra.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (364, 'Tipper', '♀ Snooty', 'Cow', 'August 25th', '"pushy"', 'villager_Tipper.png', 'villager_icon_Tipper.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (365, 'Tom', '♂ Cranky', 'Cat', 'December 10th', '"me-YOWZA"', 'villager_Tom.png', 'villager_icon_Tom.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (366, 'Truffles', '♀ Peppy', 'Pig', 'July 28th', '"snoutie"', 'villager_Truffles.png', 'villager_icon_Truffles.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (367, 'Tucker', '♂ Lazy', 'Elephant', 'September 7th', '"fuzzers"', 'villager_Tucker.png', 'villager_icon_Tucker.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (368, 'Tutu', '♀ Peppy', 'Bear', 'November 15th', '"twinkles"', 'villager_Tutu.png', 'villager_icon_Tutu.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (369, 'Twiggy', '♀ Peppy', 'Bird', 'July 13th', '"cheepers"', 'villager_Twiggy.png', 'villager_icon_Twiggy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (370, 'Tybalt', '♂ Jock', 'Tiger', 'August 19th', '"grrRAH"', 'villager_Tybalt.png', 'villager_icon_Tybalt.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (371, 'Ursala', '♀ Sisterly', 'Bear', 'January 16th', '"grooomph"', 'villager_Ursala.png', 'villager_icon_Ursala.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (372, 'Velma', '♀ Snooty', 'Goat', 'January 14th', '"blih"', 'villager_Velma.png', 'villager_icon_Velma.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (373, 'Vesta', '♀ Normal', 'Sheep', 'April 16th', '"baaaffo"', 'villager_Vesta.png', 'villager_icon_Vesta.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (374, 'Vic', '♂ Cranky', 'Bull', 'December 29th', '"cud"', 'villager_Vic.png', 'villager_icon_Vic.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (375, 'Victoria', '♀ Peppy', 'Horse', 'July 11th', '"sugar cube"', 'villager_Victoria.png', 'villager_icon_Victoria.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (376, 'Violet', '♀ Snooty', 'Gorilla', 'September 1st', '"sweetie"', 'villager_Violet.png', 'villager_icon_Violet.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (377, 'Vivian', '♀ Snooty', 'Wolf', 'January 26th', '"piffle"', 'villager_Vivian.png', 'villager_icon_Vivian.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (378, 'Vladimir', '♂ Cranky', 'Cub', 'August 2nd', '"nyet"', 'villager_Vladimir.png', 'villager_icon_Vladimir.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (379, 'Wade', '♂ Lazy', 'Penguin', 'October 30th', '"so it goes"', 'villager_Wade.png', 'villager_icon_Wade.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (380, 'Walker', '♂ Lazy', 'Dog', 'June 10th', '"wuh"', 'villager_Walker.png', 'villager_icon_Walker.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (381, 'Walt', '♂ Cranky', 'Kangaroo', 'April 24th', '"pockets"', 'villager_Walt.png', 'villager_icon_Walt.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (382, 'Wart Jr.', '♂ Cranky', 'Frog', 'August 21st', '"grr-ribbit"', 'villager_Wart_Jr.png', 'villager_icon_Wart_Jr.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (383, 'Weber', '♂ Lazy', 'Duck', 'June 30th', '"quaa"', 'villager_Weber.png', 'villager_icon_Weber.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (384, 'Wendy', '♀ Peppy', 'Sheep', 'August 15th', '"lambkins"', 'villager_Wendy.png', 'villager_icon_Wendy.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (385, 'Winnie', '♀ Peppy', 'Horse', 'January 31st', '"hay-OK"', 'villager_Winnie.png', 'villager_icon_Winnie.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (386, 'Whitney', '♀ Snooty', 'Wolf', 'September 17th', '"snappy"', 'villager_Whitney.png', 'villager_icon_Whitney.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (387, 'Willow', '♀ Snooty', 'Sheep', 'November 26th', '"bo peep"', 'villager_Willow.png', 'villager_icon_Willow.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (388, 'Wolfgang', '♂ Cranky', 'Wolf', 'November 25th', '"snarrrl"', 'villager_Wolfgang.png', 'villager_icon_Wolfgang.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (389, 'Yuka', '♀ Snooty', 'Koala', 'July 20th', '"tsk tsk"', 'villager_Yuka.png', 'villager_icon_Yuka.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (390, 'Zell', '♂ Smug', 'Deer', 'June 7th', '"pronk"', 'villager_Zell.png', 'villager_icon_Zell.png', 0);
	replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName, IconName, IsResident) values (391, 'Zucker', '♂ Lazy', 'Octopus', 'March 8th', '"bloop"', 'villager_Zucker.png', 'villager_icon_Zucker.png', 0);
commit;
