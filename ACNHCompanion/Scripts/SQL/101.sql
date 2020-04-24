drop table if exists config;
create table config (ID integer primary key,
            Name text,
            Value text,
            IsEnabled integer default 1);

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
			IsSculpted integer default 0);

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
			IconName text);

drop view if exists v_base_critters;
create view v_base_critters
as
    select critters.ID,
           critters.CritterName,
           critters.SellPrice,
           critters.Location,
           critters.Time,
           critters.ShadowSize,
           critters.Type,
           critters.ImageName,
           critters.Rarity,
           critters.IsDonated,
           critters.IsSculpted,
          case
            when datetime('now', 'localtime') >= datetime(date('now') || critters.CatchStartTime) and datetime('now', 'localtime') <= (case when datetime(date('now') || critters.CatchEndTime) < datetime(date('now') || critters.CatchStartTime) then datetime(date('now') || critters.CatchEndTime, '+1 day') else critters.CatchEndTime end) then true else false
            end as IsCatchableBasedOnTime
    from critters
    order by critters.CritterName;

drop view if exists v_bugs_northern;
create view v_bugs_northern
as
select v_base_critters.*,
	   northern_months.months,
	   case when instr(northern_months.months,
		   case strftime('%m', date('now'))
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

drop view if exists  v_bugs_southern;
create view v_bugs_southern
as
   select v_base_critters.*,
	   southern_months.months,
	   case when instr(southern_months.months,
		   case strftime('%m', date('now'))
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

drop view if exists  v_fish_northern;
create view v_fish_northern
as
   select v_base_critters.*,
		  northern_months.months,
		  case when instr(northern_months.months,
			   case strftime('%m', date('now'))
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

drop view if exists  v_fish_southern;
create view v_fish_southern
as
   select v_base_critters.*,
		  southern_months.months,
   case when instr(southern_months.months,
	   case strftime('%m', date('now'))
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
    replace into config (ID, Name, Value, IsEnabled) VALUES (1, 'hemisphere', 'North', 1);
    replace into config (ID, Name, Value, IsEnabled) VALUES (2, 'version', '101', 1);
commit;

begin transaction;
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (1, 'Common butterfly', 160, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Common_butterfly.png', 'Common (★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (2, 'Yellow butterfly', 160, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Yellow_butterfly.png', 'Common (★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (3, 'Tiger butterfly', 240, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Tiger_butterfly.png', 'Uncommon (★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (4, 'Peacock butterfly', 2500, 'Flying by Hybrid Flowers', '4AM - 7PM', null, 'bug', 'bug_Peacock_butterfly.png', 'Uncommon (★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (5, 'Common bluebottle', 300, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Common_bluebottle.png', 'Common', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (6, 'Paper kite butterfly', 1000, 'Flying', '8AM - 7PM', null, 'bug', 'bug_Paper_kite_butterfly.png', 'Fairly Common (★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (7, 'Great purple emperor', 3000, 'Flying', '4AM - 7PM', null, 'bug', 'bug_Great_purple_emperor.png', 'Scarce (★★★★)', 0, '04:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (8, 'Monarch butterfly', 140, 'Flying', '4AM - 5PM', null, 'bug', 'bug_Monarch_butterfly.png', 'Fairly Common (★★)', 0, '04:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (9, 'Emperor butterfly', 4000, 'Flying', '5PM - 8AM', null, 'bug', 'bug_Emperor_butterfly.png', 'Uncommon (★★★)(WW) Scarce (★★★★)(CF,NL)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (10, 'Agrias butterfly', 3000, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Agrias_butterfly.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (11, 'Rajah Brooke''s birdwing', 2500, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Rajah_Brookes_birdwing.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (12, 'Queen Alexandra''s birdwing', 4000, 'Flying', '8AM - 4PM', null, 'bug', 'bug_Queen_Alexandras_birdwing.png', 'Uncommon (★★★) (NH)', 0, '08:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (13, 'Moth', 130, 'Flying by Light', '7PM - 4AM', null, 'bug', 'bug_Moth.png', 'Common (★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (14, 'Atlas moth', 3000, 'On Trees', '7PM - 4AM', null, 'bug', 'bug_Atlas_moth.png', 'Fairly common', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (15, 'Madagascan sunset moth', 2500, 'Flying', '8AM - 4PM', null, 'bug', 'bug_Madagascan_sunset_moth.png', 'Fairly common (★★)', 0, '08:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (16, 'Long locust', 200, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Long_locust.png', 'Fairly Common (★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (17, 'Migratory locust', 600, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Migratory_locust.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (18, 'Rice grasshopper', 160, 'On the Ground', '8AM - 7PM', null, 'bug', 'bug_Rice_grasshopper.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (19, 'Grasshopper', 160, 'On the Ground', '8AM - 5PM', null, 'bug', 'bug_Grasshopper.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (20, 'Cricket', 130, 'On the Ground', '5PM - 8AM', null, 'bug', 'bug_Cricket.png', 'Common (★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (21, 'Bell cricket', 430, 'On the Ground', '5PM - 8AM', null, 'bug', 'bug_Bell_cricket.png', 'Rare (★★★★) (GCN games) Uncommon (★★★) (WW, CF)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (22, 'Mantis', 430, 'On Flowers', '8AM - 5PM', null, 'bug', 'bug_Mantis.png', 'Uncommon (★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (23, 'Orchid mantis', 2400, 'On Flowers (White)', '8AM - 5PM', null, 'bug', 'bug_Orchid_mantis.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (24, 'Honeybee', 200, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Honeybee.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (25, 'Wasp', 2500, 'Shaking Trees', 'ALL DAY', null, 'bug', 'bug_Wasp.png', 'Limited Per Day (-)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (26, 'Brown cicada', 250, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Brown_cicada.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (27, 'Robust cicada', 300, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Robust_cicada.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (28, 'Giant cicada', 500, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Giant_cicada.png', 'Uncommon (★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (29, 'Walker cicada', 400, 'On Trees', '8AM - 5PM', null, 'bug', 'bug_Walker_cicada.png', 'Uncommon (★★★) (June-August)Scarce (★★★★) September)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (30, 'Evening cicada', 550, 'On Trees', '4AM - 8AM', null, 'bug', 'bug_Evening_cicada.png', 'Uncommon (★★★)(GCN games) Fairly Common (★★)(WW, CF)', 0, '04:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (31, 'Cicada shell', 10, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Cicada_shell.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (32, 'Red dragonfly', 180, 'Flying', '8AM - 7PM', null, 'bug', 'bug_Red_dragonfly.png', 'Common (★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (33, 'Darner dragonfly', 230, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Darner_dragonfly.png', 'Fairly Common (★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (34, 'Banded dragonfly', 4500, 'Flying', '8AM - 5PM', null, 'bug', 'bug_Banded_dragonfly.png', 'Scarce (★★★★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (35, 'Damselfly', 500, 'Flying', 'ALL DAY', null, 'bug', 'bug_Damselfly.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (36, 'Firefly', 300, 'Flying', '7PM - 4AM', null, 'bug', 'bug_Firefly.png', 'Common (★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (37, 'Mole cricket', 500, 'Underground', 'ALL DAY', null, 'bug', 'bug_Mole_cricket.png', 'Uncommon (★★★)(AC)Fairly Common (★★)(CF)Scarce (★★★★)(WW)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (38, 'Pondskater', 130, 'On Ponds and Rivers', '8AM - 7PM', null, 'bug', 'bug_Pondskater.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (39, 'Diving beetle', 800, 'On Ponds and Rivers', '8AM - 7PM', null, 'bug', 'bug_Diving_beetle.png', 'Uncommon (★★★)', 0, '08:00', '19:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (40, 'Giant water bug', 2000, 'On Ponds and Rivers', '7PM - 8AM', null, 'bug', 'bug_Giant_water_bug.png', 'Common', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (41, 'Stinkbug', 120, 'On Flowers', 'ALL DAY', null, 'bug', 'bug_Stinkbug.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (42, 'Man-faced stink bug', 1000, 'On Flowers', '7PM - 8AM', null, 'bug', 'bug_Man_faced_stink_bug.png', 'Fairly Common (★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (43, 'Ladybug', 200, 'On Flowers', '8AM - 5PM', null, 'bug', 'bug_Ladybug.png', 'Common (★)', 0, '08:00', '17:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (44, 'Tiger beetle', 1500, 'On the Ground', 'ALL DAY', null, 'bug', 'bug_Tiger_beetle.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (45, 'Jewel beetle', 2400, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Jewel_beetle.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (46, 'Violin beetle', 450, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Violin_beetle.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (47, 'Citrus long-horned beetle', 350, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Citrus_long_horned_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (48, 'Rosalia batesi beetle', 3000, 'On Tree Stumps', 'ALL DAY', null, 'bug', 'bug_Rosalia_batesi_beetle.png', 'Uncommon', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (49, 'Blue weevil beetle', 800, 'On Trees (Coconut?)', 'ALL DAY', null, 'bug', 'bug_Blue_weevil_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (50, 'Dung beetle', 3000, 'On the Ground (rolling snowballs)', 'ALL DAY', null, 'bug', 'bug_Dung_beetle.png', 'Scarce (★★★★)(AFe+) Uncommon (★★★) (WW, CF, NL)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (51, 'Earth-boring dung beetle', 300, 'On the Ground', 'ALL DAY', null, 'bug', 'bug_Earth_boring_dung_beetle.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (52, 'Scarab beetle', 10000, 'On Trees', '1PM - 8AM', null, 'bug', 'bug_Scarab_beetle.png', 'Scarce (★★★★)', 0, '13:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (53, 'Drone beetle', 200, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Drone_beetle.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (54, 'Goliath beetle', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Goliath_beetle.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (55, 'Saw stag', 2000, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Saw_stag.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (56, 'Miyama stag', 1000, 'On Trees', 'ALL DAY', null, 'bug', 'bug_Miyama_stag.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (57, 'Giant stag', 10000, 'On Trees', '1PM - 8AM', null, 'bug', 'bug_Giant_stag.png', 'Scarce (★★★★)', 0, '13:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (58, 'Rainbow stag', 6000, 'On Trees', '7PM - 8AM', null, 'bug', 'bug_Rainbow_stag.png', 'Scarce (★★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (59, 'Cyclommatus stag', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Cyclommatus_stag.png', 'Scarce (★★★★)(CF) Quite common (★★)(NL)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (60, 'Golden stag', 12000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Golden_stag.png', 'Rare (★★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (61, 'Giraffe stag', 12000, 'On Trees (Coconut?)', '5PM - 8AM', null, 'bug', 'bug_Giraffe_stag.png', 'Unknown', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (62, 'Horned dynastid', 1350, 'On Trees', '5PM - 8AM', null, 'bug', 'bug_Horned_dynastid.png', 'Uncommon (★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (63, 'Horned atlas', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_atlas.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (64, 'Horned elephant', 8000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_elephant.png', 'Scarce (★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (65, 'Horned hercules', 12000, 'On Trees (Coconut)', '5PM - 8AM', null, 'bug', 'bug_Horned_hercules.png', 'Rare (★★★★★)', 0, '17:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (66, 'Walking stick', 600, 'On Trees', '4AM - 8AM', null, 'bug', 'bug_Walking_stick.png', 'Uncommon (★★★)', 0, '04:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (67, 'Walking leaf', 600, 'Under Trees Disguised as Leafs', 'ALL DAY', null, 'bug', 'bug_Walking_leaf.png', 'Clear weather: Scarce (★★★★),  During rain: Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (68, 'Bagworm', 600, 'Shaking Trees', 'ALL DAY', null, 'bug', 'bug_Bagworm.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (69, 'Ant', 80, 'On rotten food', 'ALL DAY', null, 'bug', 'bug_Ant.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (70, 'Hermit crab', 1000, 'Beach disguised as Shells', '7PM - 8AM', null, 'bug', 'bug_Hermit_crab.png', 'Scarce (★★★★), During rain in AFe+: Uncommon (★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (71, 'Wharf roach', 200, 'On Beach Rocks', 'ALL DAY', null, 'bug', 'bug_Wharf_roach.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (72, 'Fly', 60, 'On Trash Items', 'ALL DAY', null, 'bug', 'bug_Fly.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (73, 'Mosquito', 130, 'Flying', '5PM - 4AM', null, 'bug', 'bug_Mosquito.png', 'Fairly Common (★★)', 0, '17:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (74, 'Flea', 70, 'Villager''s Heads', 'ALL DAY', null, 'bug', 'bug_Flea.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (75, 'Snail', 250, 'On Rocks (Rain)', 'ALL DAY', null, 'bug', 'bug_Snail.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (76, 'Pill bug', 250, 'Hitting Rocks', '1PM - 4PM', null, 'bug', 'bug_Pill_bug.png', 'Uncommon (★★★)', 0, '13:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (77, 'Centipede', 300, 'Hitting Rocks', '4PM - 1PM', null, 'bug', 'bug_Centipede.png', 'Scarce (★★★★)', 0, '16:00', '13:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (78, 'Spider', 600, 'Shaking Trees', '7PM - 8AM', null, 'bug', 'bug_Spider.png', 'Uncommon (★★★)', 0, '19:00', '08:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (79, 'Tarantula', 8000, 'On the Ground', '7PM - 4AM', null, 'bug', 'bug_Tarantula.png', 'Rare (★★★★★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (80, 'Scorpion', 8000, 'On the Ground', '7PM - 4AM', null, 'bug', 'bug_Scorpion.png', 'Rare (★★★★★)', 0, '19:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (81, 'Bitterling', 900, 'River', 'ALL DAY', '1', 'fish', 'fish_Bitterling.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (82, 'Pale chub', 200, 'River', '9AM - 4PM', '1', 'fish', 'fish_Pale_chub.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (83, 'Crucian carp', 160, 'River', 'ALL DAY', '2', 'fish', 'fish_Crucian_carp.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (84, 'Dace', 240, 'River', '4PM - 9AM', '3', 'fish', 'fish_Dace.png', 'Fairly Common (★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (85, 'Carp', 300, 'Pond', 'ALL DAY', '4', 'fish', 'fish_Carp.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (86, 'Koi', 4000, 'Pond', '4PM - 9AM', '4', 'fish', 'fish_Koi.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (87, 'Goldfish', 1300, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Goldfish.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (88, 'Pop-eyed goldfish', 1300, 'Pond', '9AM - 4PM', '1', 'fish', 'fish_Pop_eyed_goldfish.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (89, 'Ranchu goldfish', 4500, 'Pond', '9AM - 4PM', '2', 'fish', 'fish_Ranchu_goldfish.png', 'Rare', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (90, 'Killifish', 300, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Killifish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (91, 'Crawfish', 200, 'Pond', 'ALL DAY', '2', 'fish', 'fish_Crawfish.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (92, 'Soft-shelled turtle', 3750, 'River', '4PM - 9AM', '4', 'fish', 'fish_Soft_shelled_turtle.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (93, 'Snapping Turtle', 5000, 'River', '9PM - 4AM', '4', 'fish', 'fish_Snapping_Turtle.png', 'Uncommon', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (94, 'Tadpole', 100, 'Pond', 'ALL DAY', '1', 'fish', 'fish_Tadpole.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (95, 'Frog', 120, 'Pond', 'ALL DAY', '2', 'fish', 'fish_Frog.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (96, 'Freshwater goby', 400, 'River', '4PM - 9AM', '2', 'fish', 'fish_Freshwater_goby.png', 'Uncommon (★★★) - Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (97, 'Loach', 400, 'River', 'ALL DAY', '2', 'fish', 'fish_Loach.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (98, 'Catfish', 800, 'Pond', '4PM - 9AM', '4', 'fish', 'fish_Catfish.png', 'Fairly Common (★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (99, 'Giant snakehead', 5500, 'Pond', '9AM - 4PM', '4', 'fish', 'fish_Giant_snakehead.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (100, 'Bluegill', 180, 'River', '9AM - 4PM', '2', 'fish', 'fish_Bluegill.png', 'Uncommon', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (101, 'Yellow perch', 300, 'River', 'ALL DAY', '3', 'fish', 'fish_Yellow_perch.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (102, 'Black bass', 320, 'River', 'ALL DAY', '4', 'fish', 'fish_Black_bass.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (103, 'Tilapia', 800, 'River', 'ALL DAY', '3', 'fish', 'fish_Tilapia.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (104, 'Pike', 1800, 'River', 'ALL DAY', '5', 'fish', 'fish_Pike.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (105, 'Pond smelt', 500, 'River', 'ALL DAY', '2', 'fish', 'fish_Pond_smelt.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (106, 'Sweetfish', 900, 'River', 'ALL DAY', '3', 'fish', 'fish_Sweetfish.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (107, 'Cherry salmon', 800, 'River (Clifftop)', '4PM - 9AM', '3', 'fish', 'fish_Cherry_salmon.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (108, 'Char', 3800, 'River (Clifftop)  Pond', '4PM - 9AM', '3', 'fish', 'fish_Char.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (109, 'Golden trout', 15000, 'River (Clifftop)', '4PM - 9AM', '3', 'fish', 'fish_Golden_trout.png', 'unknown', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (110, 'Stringfish', 15000, 'River (Clifftop)', '4PM - 9AM', '5', 'fish', 'fish_Stringfish.png', 'Rare (★★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (111, 'Salmon', 700, 'River (Mouth)', 'ALL DAY', '4', 'fish', 'fish_Salmon.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (112, 'King salmon', 1800, 'River (Mouth)', 'ALL DAY', '6', 'fish', 'fish_King_salmon.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (113, 'Mitten crab', 2000, 'River', '4PM - 9AM', '2', 'fish', 'fish_Mitten_crab.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (114, 'Guppy', 1300, 'River', '9AM - 4PM', '1', 'fish', 'fish_Guppy.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (115, 'Nibble fish', 1500, 'River', '9AM - 4PM', '1', 'fish', 'fish_Nibble_fish.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (116, 'Angelfish', 3000, 'River', '4PM - 9AM', '2', 'fish', 'fish_Angelfish.png', 'Uncommon', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (117, 'Betta', 2500, 'River', '9AM - 4PM', '2', 'fish', 'fish_Betta.png', 'Unknown', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (118, 'Neon tetra', 500, 'River', '9AM - 4PM', '1', 'fish', 'fish_Neon_tetra.png', 'Uncommon (★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (119, 'Rainbowfish', 800, 'River', '9AM - 4PM', '1', 'fish', 'fish_Rainbowfish.png', 'Unknown', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (120, 'Piranha', 2500, 'River', '9AM - 4PM', '2', 'fish', 'fish_Piranha.png', 'Scarce (★★★★)', 0, '09:00', '16:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (121, 'Arowana', 10000, 'River', '4PM - 9AM', '4', 'fish', 'fish_Arowana.png', 'Rare', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (122, 'Dorado', 15000, 'River', '4AM - 9PM', '5', 'fish', 'fish_Dorado.png', 'Rare (★★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (123, 'Gar', 6000, 'Pond', '4PM - 9AM', '5', 'fish', 'fish_Gar.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (124, 'Arapaima', 10000, 'River', '4PM - 9AM', '6', 'fish', 'fish_Arapaima.png', 'Rare', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (125, 'Saddled bichir', 4000, 'River', '9PM - 4AM', '4', 'fish', 'fish_Saddled_bichir.png', 'Rare', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (126, 'Sturgeon', 10000, 'River (Mouth)', 'ALL DAY', '6', 'fish', 'fish_Sturgeon.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (127, 'Sea butterfly', 1000, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Sea_butterfly.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (128, 'Sea horse', 1100, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Sea_horse.png', 'Fairly Common (★★) (AFe+), Uncommon (★★★) (WW, CF)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (129, 'Clown fish', 650, 'Sea', 'ALL DAY', '1', 'fish', 'fish_Clown_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (130, 'Surgeonfish', 1000, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Surgeonfish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (131, 'Butterfly fish', 1000, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Butterfly_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (132, 'Napoleonfish', 10000, 'Sea', '4AM - 9PM', '6', 'fish', 'fish_Napoleonfish.png', 'Scarce (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (133, 'Zebra turkeyfish', 500, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Zebra_turkeyfish.png', 'Common', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (134, 'Blowfish', 5000, 'Sea', '9PM - 4AM', '3', 'fish', 'fish_Blowfish.png', 'Scarce (★★★★)', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (135, 'Puffer fish', 250, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Puffer_fish.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (136, 'Anchovy', 200, 'Sea', '4AM - 9PM', '2', 'fish', 'fish_Anchovy.png', 'Uncommon (★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (137, 'Horse mackerel', 150, 'Sea', 'ALL DAY', '2', 'fish', 'fish_Horse_mackerel.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (138, 'Barred knifejaw', 5000, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Barred_knifejaw.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (139, 'Sea bass', 400, 'Sea', 'ALL DAY', '5', 'fish', 'fish_Sea_bass.png', 'Common (★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (140, 'Red snapper', 3000, 'Sea', 'ALL DAY', '4', 'fish', 'fish_Red_snapper.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (141, 'Dab', 300, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Dab.png', 'Fairly Common (★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (142, 'Olive flounder', 800, 'Sea', 'ALL DAY', '5', 'fish', 'fish_Olive_flounder.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (143, 'Squid', 500, 'Sea', 'ALL DAY', '3', 'fish', 'fish_Squid.png', 'Uncommon (★★★) (AFe+), Fairly Common (★★) (WW, CF)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (144, 'Moray eel', 2000, 'Sea', 'ALL DAY', 'Narrow', 'fish', 'fish_Moray_eel.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (145, 'Ribbon eel', 600, 'Sea', 'ALL DAY', 'Narrow', 'fish', 'fish_Ribbon_eel.png', 'Uncommon (★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (146, 'Tuna', 7000, 'Pier', 'ALL DAY', '6', 'fish', 'fish_Tuna.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (147, 'Blue marlin', 10000, 'Pier', 'ALL DAY', '6', 'fish', 'fish_Blue_marlin.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (148, 'Giant trevally', 4500, 'Pier', 'ALL DAY', '5', 'fish', 'fish_Giant_trevally.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (149, 'Mahi-mahi', 6000, 'Pier', 'ALL DAY', '5', 'fish', 'fish_Mahi_mahi.png', 'Unknown', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (150, 'Ocean sunfish', 4000, 'Sea', '4AM - 9PM', '6 (Fin)', 'fish', 'fish_Ocean_sunfish.png', 'Rare (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (151, 'Ray', 3000, 'Sea', '4AM - 9PM', '5', 'fish', 'fish_Ray.png', 'Scarce (★★★★)', 0, '04:00', '21:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (152, 'Saw shark', 12000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Saw_shark.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (153, 'Hammerhead shark', 8000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Hammerhead_shark.png', 'Scarce (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (154, 'Great white shark', 15000, 'Sea', '4PM - 9AM', '6 (Fin)', 'fish', 'fish_Great_white_shark.png', 'Rare (★★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (155, 'Whale shark', 13000, 'Sea', 'ALL DAY', '6 (Fin)', 'fish', 'fish_Whale_shark.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (156, 'Suckerfish', 1500, 'Sea', 'ALL DAY', '4 (Fin)', 'fish', 'fish_Suckerfish.png', 'Uncommon', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (157, 'Football fish', 2500, 'Sea', '4PM - 9AM', '4', 'fish', 'fish_Football_fish.png', 'Uncommon (★★★)', 0, '16:00', '09:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (158, 'Oarfish', 9000, 'Sea', 'ALL DAY', '6', 'fish', 'fish_Oarfish.png', 'Scarce (★★★★)', 0, '00:00', '23:59', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (159, 'Barreleye', 15000, 'Sea', '9PM - 4AM', '2', 'fish', 'fish_Barreleye.png', 'Scarce (★★★★)', 0, '21:00', '04:00', 0);
    replace into critters (ID, CritterName, SellPrice, Location, Time, ShadowSize, Type, ImageName, Rarity, IsDonated, CatchStartTime, CatchEndTime, IsSculpted) VALUES (160, 'Coelacanth', 15000, 'Sea (while raining)', 'ALL DAY', '6', 'fish', 'fish_Coelacanth.png', 'Very Rare (★★★★★)', 0, '00:00', '23:59', 0);
commit;

begin transaction;
    replace into northern_months (ID, CritterName, Months) VALUES (1, 'Common butterfly', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (2, 'Yellow butterfly', 'Mar Apr May Jun Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (3, 'Tiger butterfly', 'Mar Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (4, 'Peacock butterfly', 'Mar Apr May Jun');
    replace into northern_months (ID, CritterName, Months) VALUES (5, 'Common bluebottle', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (6, 'Paper kite butterfly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (7, 'Great purple emperor', 'May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (8, 'Monarch butterfly', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (9, 'Emperor butterfly', 'Jan Feb Mar Jun Jul Aug Sep Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (10, 'Agrias butterfly', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (11, 'Rajah Brooke''s birdwing', 'Jan Feb Apr May Jun Jul Aug Sep Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (12, 'Queen Alexandra''s birdwing', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (13, 'Moth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (14, 'Atlas moth', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (15, 'Madagascan sunset moth', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (16, 'Long locust', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (17, 'Migratory locust', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (18, 'Rice grasshopper', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (19, 'Grasshopper', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (20, 'Cricket', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (21, 'Bell cricket', 'Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (22, 'Mantis', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (23, 'Orchid mantis', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (24, 'Honeybee', 'Mar Apr May Jun Jul');
    replace into northern_months (ID, CritterName, Months) VALUES (25, 'Wasp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (26, 'Brown cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (27, 'Robust cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (28, 'Giant cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (29, 'Walker cicada', 'Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (30, 'Evening cicada', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (31, 'Cicada shell', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (32, 'Red dragonfly', 'Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (33, 'Darner dragonfly', 'Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (34, 'Banded dragonfly', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (35, 'Damselfly', 'Jan Feb Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (36, 'Firefly', 'Jun');
    replace into northern_months (ID, CritterName, Months) VALUES (37, 'Mole cricket', 'Jan Feb Mar Apr May Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (38, 'Pondskater', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (39, 'Diving beetle', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (40, 'Giant water bug', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (41, 'Stinkbug', 'Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (42, 'Man-faced stink bug', 'Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (43, 'Ladybug', 'Mar Apr May Jun Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (44, 'Tiger beetle', 'Feb Mar Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (45, 'Jewel beetle', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (46, 'Violin beetle', 'May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (47, 'Citrus long-horned beetle', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (48, 'Rosalia batesi beetle', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (49, 'Blue weevil beetle', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (50, 'Dung beetle', 'Jan Feb Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (51, 'Earth-boring dung beetle', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (52, 'Scarab beetle', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (53, 'Drone beetle', 'Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (54, 'Goliath beetle', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (55, 'Saw stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (56, 'Miyama stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (57, 'Giant stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (58, 'Rainbow stag', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (59, 'Cyclommatus stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (60, 'Golden stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (61, 'Giraffe stag', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (62, 'Horned dynastid', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (63, 'Horned atlas', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (64, 'Horned elephant', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (65, 'Horned hercules', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (66, 'Walking stick', 'Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (67, 'Walking leaf', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (68, 'Bagworm', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (69, 'Ant', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (70, 'Hermit crab', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (71, 'Wharf roach', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (72, 'Fly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (73, 'Mosquito', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (74, 'Flea', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (75, 'Snail', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (76, 'Pill bug', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (77, 'Centipede', 'Jan Feb Mar Apr May Jun Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (78, 'Spider', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (79, 'Tarantula', 'Jan Feb Mar Apr Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (80, 'Scorpion', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (81, 'Bitterling', 'Jan Feb Mar Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (82, 'Pale chub', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (83, 'Crucian carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (84, 'Dace', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (85, 'Carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (86, 'Koi', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (87, 'Goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (88, 'Pop-eyed goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (89, 'Ranchu goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (90, 'Killifish', 'Apr May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (91, 'Crawfish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (92, 'Soft-shelled turtle', 'Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (93, 'Snapping Turtle', 'Apr May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (94, 'Tadpole', 'Mar Apr May Jun Jul');
    replace into northern_months (ID, CritterName, Months) VALUES (95, 'Frog', 'May Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (96, 'Freshwater goby', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (97, 'Loach', 'Mar Apr May');
    replace into northern_months (ID, CritterName, Months) VALUES (98, 'Catfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (99, 'Giant snakehead', 'Jun Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (100, 'Bluegill', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (101, 'Yellow perch', 'Jan Feb Mar Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (102, 'Black bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (103, 'Tilapia', 'Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (104, 'Pike', 'Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (105, 'Pond smelt', 'Jan Feb Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (106, 'Sweetfish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (107, 'Cherry salmon', 'Mar Apr May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (108, 'Char', 'Mar Apr May Jun Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (109, 'Golden trout', 'Mar Apr May Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (110, 'Stringfish', 'Jan Feb Mar Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (111, 'Salmon', 'Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (112, 'King salmon', 'Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (113, 'Mitten crab', 'Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (114, 'Guppy', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (115, 'Nibble fish', 'May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (116, 'Angelfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (117, 'Betta', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (118, 'Neon tetra', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (119, 'Rainbowfish', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (120, 'Piranha', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (121, 'Arowana', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (122, 'Dorado', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (123, 'Gar', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (124, 'Arapaima', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (125, 'Saddled bichir', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (126, 'Sturgeon', 'Jan Feb Mar Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (127, 'Sea butterfly', 'Jan Feb Mar Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (128, 'Sea horse', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (129, 'Clown fish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (130, 'Surgeonfish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (131, 'Butterfly fish', 'Apr May Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (132, 'Napoleonfish', 'Jul Aug');
    replace into northern_months (ID, CritterName, Months) VALUES (133, 'Zebra turkeyfish', 'Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (134, 'Blowfish', 'Jan Feb Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (135, 'Puffer fish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (136, 'Anchovy', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (137, 'Horse mackerel', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (138, 'Barred knifejaw', 'Mar Apr May Jun Jul Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (139, 'Sea bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (140, 'Red snapper', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (141, 'Dab', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (142, 'Olive flounder', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (143, 'Squid', 'Jan Feb Mar Apr May Jun Jul Aug Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (144, 'Moray eel', 'Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (145, 'Ribbon eel', 'Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (146, 'Tuna', 'Jan Feb Mar Apr Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (147, 'Blue marlin', 'Jan Feb Mar Apr Jul Aug Sep Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (148, 'Giant trevally', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (149, 'Mahi-mahi', 'May Jun Jul Aug Sep Oct');
    replace into northern_months (ID, CritterName, Months) VALUES (150, 'Ocean sunfish', 'Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (151, 'Ray', 'Aug Sep Oct Nov');
    replace into northern_months (ID, CritterName, Months) VALUES (152, 'Saw shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (153, 'Hammerhead shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (154, 'Great white shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (155, 'Whale shark', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (156, 'Suckerfish', 'Jun Jul Aug Sep');
    replace into northern_months (ID, CritterName, Months) VALUES (157, 'Football fish', 'Jan Feb Mar Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (158, 'Oarfish', 'Jan Feb Mar Apr May Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (159, 'Barreleye', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into northern_months (ID, CritterName, Months) VALUES (160, 'Coelacanth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
commit;

begin transaction;
    replace into southern_months (ID, CritterName, Months) VALUES (1, 'Common butterfly', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (2, 'Yellow butterfly', 'Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (3, 'Tiger butterfly', 'Jan Feb Mar Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (4, 'Peacock butterfly', 'Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (5, 'Common bluebottle', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (6, 'Paper kite butterfly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (7, 'Great purple emperor', 'Jan Feb Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (8, 'Monarch butterfly', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (9, 'Emperor butterfly', 'Jan Feb Mar Jun Jul Aug Sep Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (10, 'Agrias butterfly', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (11, 'Rajah Brooke''s birdwing', 'Jan Feb Mar Jun Jul Aug Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (12, 'Queen Alexandra''s birdwing', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (13, 'Moth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (14, 'Atlas moth', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (15, 'Madagascan sunset moth', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (16, 'Long locust', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (17, 'Migratory locust', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (18, 'Rice grasshopper', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (19, 'Grasshopper', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (20, 'Cricket', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (21, 'Bell cricket', 'Mar Apr');
    replace into southern_months (ID, CritterName, Months) VALUES (22, 'Mantis', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (23, 'Orchid mantis', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (24, 'Honeybee', 'Jan Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (25, 'Wasp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (26, 'Brown cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (27, 'Robust cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (28, 'Giant cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (29, 'Walker cicada', 'Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (30, 'Evening cicada', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (31, 'Cicada shell', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (32, 'Red dragonfly', 'Mar Apr');
    replace into southern_months (ID, CritterName, Months) VALUES (33, 'Darner dragonfly', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (34, 'Banded dragonfly', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (35, 'Damselfly', 'May Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) VALUES (36, 'Firefly', 'Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (37, 'Mole cricket', 'May Jun Jul Aug Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) VALUES (38, 'Pondskater', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (39, 'Diving beetle', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (40, 'Giant water bug', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (41, 'Stinkbug', 'Jan Feb Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (42, 'Man-faced stink bug', 'Jan Feb Mar Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (43, 'Ladybug', 'Apr Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (44, 'Tiger beetle', 'Jan Feb Mar Apr Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (45, 'Jewel beetle', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (46, 'Violin beetle', 'Mar Apr May Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (47, 'Citrus long-horned beetle', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (48, 'Rosalia batesi beetle', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (49, 'Blue weevil beetle', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (50, 'Dung beetle', 'Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) VALUES (51, 'Earth-boring dung beetle', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (52, 'Scarab beetle', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (53, 'Drone beetle', 'Jan Feb Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (54, 'Goliath beetle', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (55, 'Saw stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (56, 'Miyama stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (57, 'Giant stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (58, 'Rainbow stag', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (59, 'Cyclommatus stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (60, 'Golden stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (61, 'Giraffe stag', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (62, 'Horned dynastid', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (63, 'Horned atlas', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (64, 'Horned elephant', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (65, 'Horned hercules', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (66, 'Walking stick', 'Jan Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (67, 'Walking leaf', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (68, 'Bagworm', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (69, 'Ant', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (70, 'Hermit crab', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (71, 'Wharf roach', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (72, 'Fly', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (73, 'Mosquito', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (74, 'Flea', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (75, 'Snail', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (76, 'Pill bug', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (77, 'Centipede', 'Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (78, 'Spider', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (79, 'Tarantula', 'May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) VALUES (80, 'Scorpion', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (81, 'Bitterling', 'May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (82, 'Pale chub', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (83, 'Crucian carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (84, 'Dace', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (85, 'Carp', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (86, 'Koi', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (87, 'Goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (88, 'Pop-eyed goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (89, 'Ranchu goldfish', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (90, 'Killifish', 'Jan Feb Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (91, 'Crawfish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (92, 'Soft-shelled turtle', 'Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (93, 'Snapping turtle', 'Jan Feb Mar Apr Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (94, 'Tadpole', 'Jan Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (95, 'Frog', 'Jan Feb Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (96, 'Freshwater goby', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (97, 'Loach', 'Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) VALUES (98, 'Catfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (99, 'Giant snakehead', 'Jan Feb Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (100, 'Bluegill', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (101, 'Yellow perch', 'Apr May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (102, 'Black bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (103, 'Tilapia', 'Jan Feb Mar Apr Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (104, 'Pike', 'Mar Apr May Jun');
    replace into southern_months (ID, CritterName, Months) VALUES (105, 'Pond smelt', 'Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) VALUES (106, 'Sweetfish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (107, 'Cherry salmon', 'Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (108, 'Char', 'Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (109, 'Golden trout', 'Mar Apr May Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) VALUES (110, 'Stringfish', 'Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (111, 'Salmon', 'Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (112, 'King salmon', 'Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (113, 'Mitten crab', 'Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (114, 'Guppy', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (115, 'Nibble fish', 'Jan Feb Mar Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (116, 'Angelfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (117, 'Betta', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (118, 'Neon tetra', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (119, 'Rainbowfish', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (120, 'Piranha', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (121, 'Arowana', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (122, 'Dorado', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (123, 'Gar', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (124, 'Arapaima', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (125, 'Saddled bichir', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (126, 'Sturgeon', 'Mar Apr May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (127, 'Sea butterfly', 'Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (128, 'Sea horse', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (129, 'Clown fish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (130, 'Surgeonfish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (131, 'Butterfly fish', 'Jan Feb Mar Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (132, 'Napoleonfish', 'Jan Feb');
    replace into southern_months (ID, CritterName, Months) VALUES (133, 'Zebra turkeyfish', 'Jan Feb Mar Apr May Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (134, 'Blowfish', 'May Jun Jul Aug');
    replace into southern_months (ID, CritterName, Months) VALUES (135, 'Puffer fish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (136, 'Anchovy', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (137, 'Horse mackerel', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (138, 'Barred knifejaw', 'Jan Feb Mar Apr May Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (139, 'Sea bass', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (140, 'Red snapper', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (141, 'Dab', 'Apr May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) VALUES (142, 'Olive flounder', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (143, 'Squid', 'Jan Feb Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (144, 'Moray eel', 'Feb Mar Apr');
    replace into southern_months (ID, CritterName, Months) VALUES (145, 'Ribbon eel', 'Jan Feb Mar Apr Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (146, 'Tuna', 'May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) VALUES (147, 'Blue marlin', 'Jan Feb Mar May Jun Jul Aug Sep Oct');
    replace into southern_months (ID, CritterName, Months) VALUES (148, 'Giant trevally', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (149, 'Mahi-mahi', 'Jan Feb Mar Apr Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (150, 'Ocean sunfish', 'Jan Feb Mar');
    replace into southern_months (ID, CritterName, Months) VALUES (151, 'Ray', 'Feb Mar Apr May');
    replace into southern_months (ID, CritterName, Months) VALUES (152, 'Saw shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (153, 'Hammerhead shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (154, 'Great white shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (155, 'Whale shark', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (156, 'Suckerfish', 'Jan Feb Mar Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (157, 'Football fish', 'May Jun Jul Aug Sep');
    replace into southern_months (ID, CritterName, Months) VALUES (158, 'Oarfish', 'Jun Jul Aug Sep Oct Nov');
    replace into southern_months (ID, CritterName, Months) VALUES (159, 'Barreleye', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
    replace into southern_months (ID, CritterName, Months) VALUES (160, 'Coelacanth', 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec');
commit;

begin transaction;
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (1, 'Admiral', '♂ Cranky', 'Bird', 'January 27th', '"aye aye"', 'villager_Admiral.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (2, 'Agent S', '♀ Peppy', 'Squirrel', 'July 2nd', '"sidekick"', 'villager_Agent_S.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (3, 'Agnes', '♀ Sisterly', 'Pig', 'April 21st', '"snuffle"', 'villager_Agnes.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (4, 'Al', '♂ Lazy', 'Gorilla', 'October 18th', '"Ayyeeee"', 'villager_Al.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (5, 'Alfonso', '♂ Lazy', 'Alligator', 'June 9th', '"it''sa me"', 'villager_Alfonso.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (6, 'Alice', '♀ Normal', 'Koala', 'August 19th', '"guvnor"', 'villager_Alice.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (7, 'Alli', '♀ Snooty', 'Alligator', 'November 8th', '"graaagh"', 'villager_Alli.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (8, 'Amelia', '♀ Snooty', 'Eagle', 'November 19th', '"cuz"', 'villager_Amelia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (9, 'Anabelle', '♀ Peppy', 'Anteater', 'February 16th', '"snorty"', 'villager_Anabelle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (10, 'Anchovy', '♂ Lazy', 'Bird', 'March 4th', '"chuurp"', 'villager_Anchovy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (11, 'Ankha', '♀ Snooty', 'Cat', 'September 22nd', '"me meow"', 'villager_Ankha.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (12, 'Angus', '♂ Cranky', 'Bull', 'April 30th', '"macmoo"', 'villager_Angus.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (13, 'Anicotti', '♀ Peppy', 'Mouse', 'February 24th', '"cannoli"', 'villager_Anicotti.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (14, 'Annalisa', '♀ Normal', 'Anteater', 'February 6th', '"gumdrop"', 'villager_Annalisa.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (15, 'Annalise', '♀ Snooty', 'Horse', 'December 2nd', '"nipper"', 'villager_Annalise.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (16, 'Antonio', '♂ Jock', 'Anteater', 'October 20th', '"honk"', 'villager_Antonio.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (17, 'Apollo', '♂ Cranky', 'Eagle', 'July 4th', '"pah"', 'villager_Apollo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (18, 'Apple', '♀ Peppy', 'Hamster', 'September 24th', '"cheekers"', 'villager_Apple.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (19, 'Astrid', '♀ Snooty', 'Kangaroo', 'September 8th', '"my pet"', 'villager_Astrid.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (20, 'Audie', '♀ Peppy', 'Wolf', 'August 31st', '"Foxtrot"', 'villager_Audie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (21, 'Aurora', '♀ Normal', 'Penguin', 'January 27th', '"b-b-baby"', 'villager_Aurora.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (22, 'Ava', '♀ Normal', 'Chicken', 'April 28th', '"beaker"', 'villager_Ava.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (23, 'Avery', '♂ Cranky', 'Eagle', 'February 22nd', '"skree-haw"', 'villager_Avery.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (24, 'Axel', '♂ Jock', 'Elephant', 'March 23rd', '"WHONK"', 'villager_Axel.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (25, 'Baabara', '♀ Snooty', 'Sheep', 'March 28th', '"daahling"', 'villager_Baabara.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (26, 'Bam', '♂ Jock', 'Deer', 'November 7th', '"kablang"', 'villager_Bam.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (27, 'Bangle', '♀ Peppy', 'Tiger', 'August 27th', '"growf"', 'villager_Bangle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (28, 'Barold', '♂ Lazy', 'Cub', 'March 2nd', '"cubby"', 'villager_Barold.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (29, 'Beau', '♂ Lazy', 'Deer', 'April 5th', '"saltlick"', 'villager_Beau.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (30, 'Bea', '♀ Normal', 'Dog', 'October 15th', '"bingo"', 'villager_Bea.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (31, 'Beardo', '♂ Smug', 'Bear', 'September 27th', '"whiskers"', 'villager_Beardo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (32, 'Becky', '♀ Snooty', 'Chicken', 'December 9th', '"chicklet"', 'villager_Becky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (33, 'Bella', '♀ Peppy', 'Mouse', 'December 28th', '"eeks"', 'villager_Bella.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (34, 'Benedict', '♂ Lazy', 'Chicken', 'October 10th', '"uh-hoo"', 'villager_Benedict.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (35, 'Benjamin', '♂ Lazy', 'Dog', 'August 3rd', '"alrighty"', 'villager_Benjamin.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (36, 'Bertha', '♀ Normal', 'Hippo', 'April 25th', '"bloop"', 'villager_Bertha.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (37, 'Bettina', '♀ Normal', 'Mouse', 'June 12th', '"eekers"', 'villager_Bettina.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (38, 'Bianca', '♀ Peppy', 'Tiger', 'December 13th', '"glimmer"', 'villager_Bianca.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (39, 'Biff', '♂ Jock', 'Hippo', 'March 29th', '"squirt"', 'villager_Biff.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (40, 'Big Top', '♂ Lazy', 'Elephant', 'October 3rd', '"villain"', 'villager_Big_Top.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (41, 'Bill', '♂ Jock', 'Duck', 'February 1st', '"quacko"', 'villager_Bill.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (42, 'Billy', '♂ Jock', 'Goat', 'March 25th', '"dagnaabit"', 'villager_Billy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (43, 'Biskit', '♂ Lazy', 'Dog', 'May 13th', '"dog"', 'villager_Biskit.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (44, 'Bitty', '♀ Snooty', 'Hippo', 'October 6th', '"my dear"', 'villager_Bitty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (45, 'Blaire', '♀ Snooty', 'Squirrel', 'July 3rd', '"nutlet"', 'villager_Blaire.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (46, 'Blanche', '♀ Snooty', 'Ostrich', 'December 21st', '"quite so"', 'villager_Blanche.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (47, 'Bluebear', '♀ Peppy', 'Cub', 'June 24th', '"peach"', 'villager_Bluebear.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (48, 'Bob', '♂ Lazy', 'Cat', 'January 1st', '"pthhhpth"', 'villager_Bob.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (49, 'Bonbon', '♀ Peppy', 'Rabbit', 'March 3rd', '"deelish"', 'villager_Bonbon.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (50, 'Bones', '♂ Lazy', 'Dog', 'August 4th', '"yip yip"', 'villager_Bones.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (51, 'Boomer', '♂ Lazy', 'Penguin', 'February 7th', '"human"', 'villager_Boomer.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (52, 'Boone', '♂ Jock', 'Gorilla', 'September 12th', '"baboom"', 'villager_Boone.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (53, 'Boots', '♂ Jock', 'Alligator', 'August 7th', '"munchie"', 'villager_Boots.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (54, 'Boris', '♂ Cranky', 'Pig', 'November 6th', '"schnort"', 'villager_Boris.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (55, 'Boyd', '♂ Cranky', 'Gorilla', 'October 1st', '"uh-oh"', 'villager_Boyd.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (56, 'Bree', '♀ Snooty', 'Mouse', 'July 7th', '"cheeseball"', 'villager_Bree.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (57, 'Broccolo', '♂ Lazy', 'Mouse', 'June 30th', '"eat it"', 'villager_Broccolo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (58, 'Bruce', '♂ Cranky', 'Deer', 'May 26th', '"gruff"', 'villager_Bruce.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (59, 'Broffina', '♀ Snooty', 'Chicken', 'October 24th', '"cluckadoo"', 'villager_Broffina.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (60, 'Bubbles', '♀ Peppy', 'Hippo', 'September 18th', '"hipster"', 'villager_Bubbles.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (61, 'Buck', '♂ Jock', 'Horse', 'April 4th', '"pardner"', 'villager_Buck.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (62, 'Bud', '♂ Jock', 'Lion', 'August 8th', '"shredded"', 'villager_Bud.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (63, 'Bunnie', '♀ Peppy', 'Rabbit', 'May 9th', '"tee-hee"', 'villager_Bunnie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (64, 'Butch', '♂ Cranky', 'Dog', 'November 1st', '"ROOOOOWF"', 'villager_Butch.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (65, 'Buzz', '♂ Cranky', 'Eagle', 'December 7th', '"captain"', 'villager_Buzz.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (66, 'Cally', '♀ Normal', 'Squirrel', 'September 4th', '"WHEE"', 'villager_Cally.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (67, 'Camofrog', '♂ Cranky', 'Frog', 'June 5th', '"ten-hut"', 'villager_Camofrog.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (68, 'Canberra', '♀ Sisterly', 'Koala', 'May 14th', '"nuh uh"', 'villager_Canberra.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (69, 'Candi', '♀ Peppy', 'Mouse', 'April 13th', '"sweetie"', 'villager_Candi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (70, 'Carmen', '♀ Peppy', 'Rabbit', 'January 6th', '"nougat"', 'villager_Carmen.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (71, 'Caroline', '♀ Normal', 'Squirrel', 'July 15th', '"hulaaaa"', 'villager_Caroline.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (72, 'Carrie', '♀ Normal', 'Kangaroo', 'December 5th', '"little one"', 'villager_Carrie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (73, 'Cashmere', '♀ Snooty', 'Sheep', 'April 2nd', '"baaaby"', 'villager_Cashmere.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (74, 'Celia', '♀ Normal', 'Eagle', 'March 25th', '"feathers"', 'villager_Celia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (75, 'Cesar', '♂ Cranky', 'Gorilla', 'September 6th', '"highness"', 'villager_Cesar.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (76, 'Chadder', '♂ Smug', 'Mouse', 'December 15th', '"fromage"', 'villager_Chadder.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (77, 'Charlise', '♀ Sisterly', 'Bear', 'April 17th', '"urgh"', 'villager_Charlise.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (78, 'Cheri', '♀ Peppy', 'Cub', 'March 17th', '"tralala"', 'villager_Cheri.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (79, 'Cherry', '♀ Sisterly', 'Dog', 'May 11th', '"what what"', 'villager_Cherry.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (80, 'Chester', '♂ Lazy', 'Cub', 'August 6th', '"rookie"', 'villager_Chester.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (81, 'Chevre', '♀ Normal', 'Goat', 'March 6th', '"la baa"', 'villager_Chevre.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (82, 'Chief', '♂ Cranky', 'Wolf', 'December 19th', '"harrumph"', 'villager_Chief.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (83, 'Chops', '♂ Smug', 'Pig', 'October 13th', '"zoink"', 'villager_Chops.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (84, 'Chow', '♂ Cranky', 'Bear', 'July 22nd', '"aiya"', 'villager_Chow.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (85, 'Chrissy', '♀ Peppy', 'Rabbit', 'August 28th', '"sparkles"', 'villager_Chrissy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (86, 'Claude', '♂ Lazy', 'Rabbit', 'December 3rd', '"hopalong"', 'villager_Claude.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (87, 'Claudia', '♀ Snooty', 'Tiger', 'November 22nd', '"ooh la la"', 'villager_Claudia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (88, 'Clay', '♂ Lazy', 'Hamster', 'October 19th', '"thump"', 'villager_Clay.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (89, 'Cleo', '♀ Snooty', 'Horse', 'February 9th', '"sugar"', 'villager_Cleo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (90, 'Clyde', '♂ Lazy', 'Horse', 'May 1st', '"clip-clawp"', 'villager_Clyde.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (91, 'Coach', '♂ Jock', 'Bull', 'April 29th', '"stubble"', 'villager_Coach.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (92, 'Cobb', '♂ Jock', 'Pig', 'October 7th', '"hot dog"', 'villager_Cobb.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (93, 'Coco', '♀ Normal', 'Rabbit', 'March 1st', '"doyoing"', 'villager_Coco.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (94, 'Cole', '♂ Lazy', 'Rabbit', 'August 10th', '"duuude"', 'villager_Cole.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (95, 'Colton', '♂ Smug', 'Horse', 'May 22nd', '"check it"', 'villager_Colton.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (96, 'Cookie', '♀ Peppy', 'Dog', 'June 18th', '"arfer"', 'villager_Cookie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (97, 'Cousteau', '♂ Jock', 'Frog', 'December 17th', '"oui oui"', 'villager_Cousteau.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (98, 'Cranston', '♂ Lazy', 'Ostrich', 'September 23rd', '"sweatband"', 'villager_Cranston.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (99, 'Croque', '♂ Cranky', 'Frog', 'July 18th', '"as if"', 'villager_Croque.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (100, 'Cube', '♂ Lazy', 'Penguin', 'January 29th', '"d-d-dude"', 'villager_Cube.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (101, 'Curlos', '♂ Smug', 'Sheep', 'May 8th', '"shearly"', 'villager_Curlos.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (102, 'Curly', '♂ Jock', 'Pig', 'July 26th', '"nyoink"', 'villager_Curly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (103, 'Curt', '♂ Cranky', 'Bear', 'July 1st', '"fuzzball"', 'villager_Curt.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (104, 'Cyd', '♂ Cranky', 'Elephant', 'June 9th', '"rockin''"', 'villager_Cyd.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (105, 'Cyrano', '♂ Cranky', 'Anteater', 'March 9th', '"ah-CHOO"', 'villager_Cyrano.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (106, 'Daisy', '♀ Normal', 'Dog', 'November 16th', '"bow-WOW"', 'villager_Daisy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (107, 'Deena', '♀ Normal', 'Duck', 'June 27th', '"woowoo"', 'villager_Deena.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (108, 'Deirdre', '♀ Sisterly', 'Deer', 'May 4th', '"whatevs"', 'villager_Deirdre.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (109, 'Del', '♂ Cranky', 'Alligator', 'May 27th', '"gronk"', 'villager_Del.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (110, 'Deli', '♂ Lazy', 'Monkey', 'May 24th', '"monch"', 'villager_Deli.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (111, 'Derwin', '♂ Lazy', 'Duck', 'May 25th', '"derrrrr"', 'villager_Derwin.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (112, 'Diana', '♀ Snooty', 'Deer', 'January 4th', '"no doy"', 'villager_Diana.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (113, 'Diva', '♀ Sisterly', 'Frog', 'October 2nd', '"ya know"', 'villager_Diva.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (114, 'Dizzy', '♂ Lazy', 'Elephant', 'January 14th', '"woo-oo"', 'villager_Dizzy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (115, 'Dobie', '♂ Cranky', 'Wolf', 'February 17th', '"ohmmm"', 'villager_Dobie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (116, 'Doc', '♂ Lazy', 'Rabbit', 'March 16th', '"ol'' bunny"', 'villager_Doc.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (117, 'Dom', '♂ Jock', 'Sheep', 'March 18th', '"indeedaroo"', 'villager_Dom.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (118, 'Dora', '♀ Normal', 'Mouse', 'February 18th', '"squeaky"', 'villager_Dora.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (119, 'Dotty', '♀ Peppy', 'Rabbit', 'March 14th', '"wee one"', 'villager_Dotty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (120, 'Drago', '♂ Lazy', 'Alligator', 'February 12th', '"burrrn"', 'villager_Drago.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (121, 'Drake', '♂ Lazy', 'Duck', 'June 25th', '"quacko"', 'villager_Drake.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (122, 'Drift', '♂ Jock', 'Frog', 'October 9th', '"brah"', 'villager_Drift.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (123, 'Ed', '♂ Smug', 'Horse', 'September 16th', '"greenhorn"', 'villager_Ed.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (124, 'Egbert', '♂ Lazy', 'Chicken', 'October 14th', '"doodle-duh"', 'villager_Egbert.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (125, 'Elise', '♀ Snooty', 'Monkey', 'March 21st', '"puh-lease"', 'villager_Elise.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (126, 'Ellie', '♀ Normal', 'Elephant', 'May 12th', '"li''l one"', 'villager_Ellie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (127, 'Elmer', '♂ Lazy', 'Horse', 'October 5th', '"tenderfoot"', 'villager_Elmer.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (128, 'Eloise', '♀ Snooty', 'Elephant', 'December 8th', '"tooooot"', 'villager_Eloise.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (129, 'Elvis', '♂ Cranky', 'Lion', 'July 23rd', '"unh-hunh"', 'villager_Elvis.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (130, 'Erik', '♂ Lazy', 'Deer', 'July 27th', '"chow down"', 'villager_Erik.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (131, 'Eunice', '♀ Normal', 'Sheep', 'April 3rd', '"lambchop"', 'villager_Eunice.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (132, 'Eugene', '♂ Smug', 'Koala', 'October 26th', '"yeah buddy"', 'villager_Eugene.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (133, 'Fang', '♂ Cranky', 'Wolf', 'December 18th', '"cha-chomp"', 'villager_Fang.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (134, 'Fauna', '♀ Normal', 'Deer', 'March 26th', '"dearie"', 'villager_Fauna.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (135, 'Felicity', '♀ Peppy', 'Cat', 'March 30th', '"mimimi"', 'villager_Felicity.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (136, 'Filbert', '♂ Lazy', 'Squirrel', 'June 3rd', '"bucko"', 'villager_Filbert.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (137, 'Flip', '♂ Jock', 'Monkey', 'November 21st', '"rerack"', 'villager_Flip.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (138, 'Flo', '♀ Sisterly', 'Penguin', 'September 2nd', '"cha"', 'villager_Flo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (139, 'Flora', '♀ Peppy', 'Ostrich', 'February 9th', '"pinky"', 'villager_Flora.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (140, 'Flurry', '♀ Normal', 'Hamster', 'January 30th', '"powderpuff"', 'villager_Flurry.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (141, 'Francine', '♀ Snooty', 'Rabbit', 'January 22nd', '"karat"', 'villager_Francine.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (142, 'Frank', '♂ Cranky', 'Eagle', 'July 30th', '"crushy"', 'villager_Frank.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (143, 'Freckles', '♀ Peppy', 'Duck', 'February 19th', '"ducky"', 'villager_Freckles.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (144, 'Freya', '♀ Snooty', 'Wolf', 'December 14th', '"uff da"', 'villager_Freya.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (145, 'Friga', '♀ Snooty', 'Penguin', 'October 16th', '"brrmph"', 'villager_Friga.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (146, 'Frita', '♀ Sisterly', 'Sheep', 'July 16th', '"oh ewe"', 'villager_Frita.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (147, 'Frobert', '♂ Jock', 'Frog', 'February 8th', '"fribbit"', 'villager_Frobert.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (148, 'Fuchsia', '♀ Sisterly', 'Deer', 'September 19th', '"precious"', 'villager_Fuchsia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (149, 'Gabi', '♀ Peppy', 'Rabbit', 'December 16th', '"honeybun"', 'villager_Gabi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (150, 'Gala', '♀ Normal', 'Pig', 'March 5th', '"snortie"', 'villager_Gala.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (151, 'Gaston', '♂ Cranky', 'Rabbit', 'October 28th', '"mon chou"', 'villager_Gaston.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (152, 'Gayle', '♀ Normal', 'Alligator', 'May 17th', '"snacky"', 'villager_Gayle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (153, 'Genji', '♂ Jock', 'Rabbit', 'January 21st', '"mochi"', 'villager_Genji.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (154, 'Gigi', '♀ Snooty', 'Frog', 'August 11th', '"ribette"', 'villager_Gigi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (155, 'Gladys', '♀ Normal', 'Ostrich', 'January 15th', '"stretch"', 'villager_Gladys.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (156, 'Gloria', '♀ Snooty', 'Duck', 'August 12th', '"quacker"', 'villager_Gloria.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (157, 'Goldie', '♀ Normal', 'Dog', 'December 27th', '"woof"', 'villager_Goldie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (158, 'Gonzo', '♂ Cranky', 'Koala', 'October 13th', '"mate"', 'villager_Gonzo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (159, 'Goose', '♂ Jock', 'Chicken', 'October 4th', '"buh-kay"', 'villager_Goose.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (160, 'Graham', '♂ Smug', 'Hamster', 'June 20th', '"indeed"', 'villager_Graham.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (161, 'Greta', '♀ Snooty', 'Mouse', 'September 5th', '"yelp"', 'villager_Greta.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (162, 'Grizzly', '♂ Cranky', 'Bear', 'July 31st', '"grrr..."', 'villager_Grizzly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (163, 'Groucho', '♂ Cranky', 'Bear', 'October 23rd', '"grumble"', 'villager_Groucho.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (164, 'Gruff', '♂ Cranky', 'Goat', 'August 29th', '"bleh eh eh"', 'villager_Gruff.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (165, 'Gwen', '♀ Snooty', 'Penguin', 'January 23rd', '"h-h-hon"', 'villager_Gwen.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (166, 'Hamlet', '♂ Jock', 'Hamster', 'May 30th', '"hammie"', 'villager_Hamlet.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (167, 'Hamphrey', '♂ Cranky', 'Hamster', 'February 25th', '"snort"', 'villager_Hamphrey.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (168, 'Hans', '♂ Smug', 'Gorilla', 'December 5th', '"groovy"', 'villager_Hans.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (169, 'Harry', '♂ Cranky', 'Hippo', 'January 7th', '"beach bum"', 'villager_Harry.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (170, 'Hazel', '♀ Sisterly', 'Squirrel', 'August 30th', '"uni-wow"', 'villager_Hazel.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (171, 'Henry', '♂ Smug', 'Frog', 'September 21st', '"snoozit"', 'villager_Henry.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (172, 'Hippeux', '♂ Smug', 'Hippo', 'October 15th', '"natch"', 'villager_Hippeux.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (173, 'Hopkins', '♂ Lazy', 'Rabbit', 'March 11th', '"thumper"', 'villager_Hopkins.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (174, 'Hopper', '♂ Cranky', 'Penguin', 'April 6th', '"slushie"', 'villager_Hopper.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (175, 'Hornsby', '♂ Lazy', 'Rhino', 'March 20th', '"schnozzle"', 'villager_Hornsby.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (176, 'Huck', '♂ Smug', 'Frog', 'July 9th', '"hopper"', 'villager_Huck.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (177, 'Hugh', '♂ Lazy', 'Pig', 'December 30th', '"snortle"', 'villager_Hugh.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (178, 'Iggly', '♂ Jock', 'Penguin', 'November 2nd', '"waddler"', 'villager_Iggly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (179, 'Ike', '♂ Cranky', 'Bear', 'May 16th', '"roadie"', 'villager_Ike.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (180, 'JacobNAJakeyPAL', '♂ Lazy', 'Bird', 'August 24th', '"chuuuuurp"', 'villager_JacobNAJakeyPAL.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (181, 'Jacques', '♂ Smug', 'Bird', 'June 22nd', '"zut alors"', 'villager_Jacques.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (182, 'Jambette', '♀ Normal', 'Frog', 'October 27th', '"croak-kay"', 'villager_Jambette.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (183, 'Jay', '♂ Jock', 'Bird', 'July 17th', '"heeeeeyy"', 'villager_Jay.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (184, 'Jeremiah', '♂ Lazy', 'Frog', 'July 8th', '"nee-deep"', 'villager_Jeremiah.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (185, 'Jitters', '♂ Jock', 'Bird', 'February 2nd', '"bzzert"', 'villager_Jitters.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (186, 'Joey', '♂ Lazy', 'Duck', 'January 3rd', '"bleeeeeck"', 'villager_Joey.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (187, 'Judy', '♀ Snooty', 'Cub', 'March 10th', '"myohmy"', 'villager_Judy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (188, 'Julia', '♀ Snooty', 'Ostrich', 'July 31st', '"dahling"', 'villager_Julia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (189, 'Julian', '♂ Smug', 'Horse', 'March 15th', '"glitter"', 'villager_Julian.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (190, 'June', '♀ Normal', 'Cub', 'May 21st', '"rainbow"', 'villager_June.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (191, 'Kabuki', '♂ Cranky', 'Cat', 'November 29th', '"meooo-OH"', 'villager_Kabuki.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (192, 'Katt', '♀ Sisterly', 'Cat', 'April 27th', '"purrty"', 'villager_Katt.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (193, 'Keaton', '♂ Smug', 'Eagle', 'June 1st', '"wingo"', 'villager_Keaton.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (194, 'Ken', '♂ Smug', 'Chicken', 'December 23rd', '"no doubt"', 'villager_Ken.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (195, 'Ketchup', '♀ Peppy', 'Duck', 'July 27th', '"bitty"', 'villager_Ketchup.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (196, 'Kevin', '♂ Jock', 'Pig', 'April 26th', '"weeweewee"', 'villager_Kevin.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (197, 'Kid Cat', '♂ Jock', 'Cat', 'August 1st', '"psst"', 'villager_Kid_Cat.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (198, 'Kidd', '♂ Smug', 'Goat', 'June 28th', '"wut"', 'villager_Kidd.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (199, 'Kiki', '♀ Normal', 'Cat', 'October 8th', '"kitty cat"', 'villager_Kiki.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (200, 'Kitt', '♀ Normal', 'Kangaroo', 'October 11th', '"child"', 'villager_Kitt.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (201, 'Kitty', '♀ Snooty', 'Cat', 'February 15th', '"mrowrr"', 'villager_Kitty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (202, 'Klaus', '♂ Smug', 'Bear', 'March 31st', '"strudel"', 'villager_Klaus.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (203, 'Knox', '♂ Cranky', 'Chicken', 'November 23rd', '"cluckling"', 'villager_Knox.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (204, 'Kody', '♂ Jock', 'Cub', 'September 28th', '"grah-grah"', 'villager_Kody.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (205, 'Kyle', '♂ Smug', 'Wolf', 'December 6th', '"alpha"', 'villager_Kyle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (206, 'Leonardo', '♂ Jock', 'Tiger', 'May 15th', '"flexin"', 'villager_Leonardo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (207, 'Leopold', '♂ Smug', 'Lion', 'August 14th', '"lion cub"', 'villager_Leopold.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (208, 'Lily', '♀ Normal', 'Frog', 'February 4th', '"toady"', 'villager_Lily.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (209, 'Limberg', '♂ Cranky', 'Mouse', 'October 17th', '"squinky"', 'villager_Limberg.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (210, 'Lionel', '♂ Smug', 'Lion', 'July 29th', '"precisely"', 'villager_Lionel.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (211, 'Lobo', '♂ Cranky', 'Wolf', 'November 5th', '"ah-rooooo"', 'villager_Lobo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (212, 'Lolly', '♀ Normal', 'Cat', 'March 27th', '"bonbon"', 'villager_Lolly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (213, 'Lopez', '♂ Smug', 'Deer', 'August 20th', '"buckaroo"', 'villager_Lopez.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (214, 'Louie', '♂ Jock', 'Gorilla', 'March 26th', '"hoo hoo ha"', 'villager_Louie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (215, 'Lucha', '♂ Smug', 'Bird', 'December 12th', '"cacaw"', 'villager_Lucha.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (216, 'Lucky', '♂ Lazy', 'Dog', 'November 4th', '"rrr-owch"', 'villager_Lucky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (217, 'Lucy', '♀ Normal', 'Pig', 'June 2nd', '"snoooink"', 'villager_Lucy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (218, 'Lyman', '♂ Jock', 'Koala', 'October 12th', '"chips"', 'villager_Lyman.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (219, 'Mac', '♂ Jock', 'Dog', 'November 11th', '"woo woof"', 'villager_Mac.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (220, 'Maddie', '♀ Peppy', 'Dog', 'January 11th', '"yippee"', 'villager_Maddie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (221, 'Maelle', '♀ Snooty', 'Duck', 'April 8th', '"duckling"', 'villager_Maelle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (222, 'Maggie', '♀ Normal', 'Pig', 'September 3rd', '"schep"', 'villager_Maggie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (223, 'Mallary', '♀ Snooty', 'Duck', 'November 17th', '"quackpth"', 'villager_Mallary.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (224, 'Maple', '♀ Normal', 'Cub', 'June 15th', '"honey"', 'villager_Maple.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (225, 'Margie', '♀ Normal', 'Elephant', 'January 28th', '"tootie"', 'villager_Margie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (226, 'Marcel', '♂ Lazy', 'Dog', 'December 31st', '"non"', 'villager_Marcel.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (227, 'Marcie', '♀ Normal', 'Kangaroo', 'May 31st', '"pouches"', 'villager_Marcie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (228, 'Marina', '♀ Normal', 'Octopus', 'June 26th', '"blurp"', 'villager_Marina.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (229, 'Marshal', '♂ Smug', 'Squirrel', 'September 29th', '"sulky"', 'villager_Marshal.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (230, 'Mathilda', '♀ Snooty', 'Kangaroo', 'November 12th', '"wee baby"', 'villager_Mathilda.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (231, 'Megan', '♀ Normal', 'Bear', 'March 13th', '"sundae"', 'villager_Megan.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (232, 'Melba', '♀ Normal', 'Koala', 'April 12th', '"toasty"', 'villager_Melba.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (233, 'Merengue', '♀ Normal', 'Rhino', 'March 19th', '"shortcake"', 'villager_Merengue.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (234, 'Merry', '♀ Peppy', 'Cat', 'June 29th', '"mweee"', 'villager_Merry.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (235, 'Midge', '♀ Normal', 'Bird', 'March 12th', '"tweedledee"', 'villager_Midge.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (236, 'Mint', '♀ Snooty', 'Squirrel', 'May 2nd', '"ahhhhhh"', 'villager_Mint.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (237, 'Mira', '♀ Sisterly', 'Rabbit', 'July 6th', '"cottontail"', 'villager_Mira.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (238, 'Miranda', '♀ Snooty', 'Duck', 'April 23rd', '"quackulous"', 'villager_Miranda.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (239, 'Mitzi', '♀ Normal', 'Cat', 'September 25th', '"mew"', 'villager_Mitzi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (240, 'Moe', '♂ Lazy', 'Cat', 'January 12th', '"myawn"', 'villager_Moe.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (241, 'Molly', '♀ Normal', 'Duck', 'March 7th', '"quackidee"', 'villager_Molly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (242, 'Monique', '♀ Snooty', 'Cat', 'September 30th', '"pffffft"', 'villager_Monique.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (243, 'Monty', '♂ Cranky', 'Monkey', 'December 7th', '"g''tang"', 'villager_Monty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (244, 'Moose', '♂ Jock', 'Mouse', 'September 13th', '"shorty"', 'villager_Moose.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (245, 'Mott', '♂ Jock', 'Lion', 'July 10th', '"cagey"', 'villager_Mott.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (246, 'Muffy', '♀ Sisterly', 'Sheep', 'February 14th', '"nightshade"', 'villager_Muffy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (247, 'Murphy', '♂ Cranky', 'Cub', 'December 29th', '"laddie"', 'villager_Murphy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (248, 'Nan', '♀ Normal', 'Goat', 'August 24th', '"kid"', 'villager_Nan.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (249, 'Nana', '♀ Normal', 'Monkey', 'August 23rd', '"po po"', 'villager_Nana.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (250, 'Naomi', '♀ Snooty', 'Cow', 'February 28th', '"moolah"', 'villager_Naomi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (251, 'Nate', '♂ Lazy', 'Bear', 'August 16th', '"yawwwn"', 'villager_Nate.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (252, 'Nibbles', '♀ Peppy', 'Squirrel', 'July 19th', '"niblet"', 'villager_Nibbles.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (253, 'Norma', '♀ Normal', 'Cow', 'September 20th', '"hoof hoo"', 'villager_Norma.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (254, 'Octavian', '♂ Cranky', 'Octopus', 'September 20th', '"sucker"', 'villager_Octavian.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (255, 'O''Hare', '♂ Smug', 'Rabbit', 'July 24th', '"amigo"', 'villager_OHare.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (256, 'Olaf', '♂ Smug', 'Anteater', 'May 19th', '"whiffa"', 'villager_Olaf.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (257, 'Olive', '♀ Normal', 'Cub', 'July 12th', '"sweet pea"', 'villager_Olive.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (258, 'Olivia', '♀ Snooty', 'Cat', 'February 3rd', '"purrr"', 'villager_Olivia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (259, 'Opal', '♀ Snooty', 'Elephant', 'January 20th', '"snoot"', 'villager_Opal.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (260, 'Ozzie', '♂ Lazy', 'Koala', 'May 7th', '"ol'' bear"', 'villager_Ozzie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (261, 'Pancetti', '♀ Snooty', 'Pig', 'November 14th', '"sooey"', 'villager_Pancetti.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (262, 'Pango', '♀ Peppy', 'Anteater', 'November 9th', '"snooooof"', 'villager_Pango.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (263, 'Papi', '♂ Lazy', 'Horse', 'January 10th', '"haaay"', 'villager_Papi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (264, 'Paolo', '♂ Lazy', 'Elephant', 'May 5th', '"pal"', 'villager_Paolo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (265, 'Pashmina', '♀ Sisterly', 'Goat', 'December 26th', '"kidders"', 'villager_Pashmina.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (266, 'Pate', '♀ Peppy', 'Duck', 'February 23rd', '"quackle"', 'villager_Pate.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (267, 'Patty', '♀ Peppy', 'Cow', 'May 10th', '"how-now"', 'villager_Patty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (268, 'Paula', '♀ Sisterly', 'Bear', 'March 22nd', '"yodelay"', 'villager_Paula.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (269, 'Peaches', '♀ Normal', 'Horse', 'November 28th', '"neighbor"', 'villager_Peaches.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (270, 'Peanut', '♀ Peppy', 'Squirrel', 'June 8th', '"slacker"', 'villager_Peanut.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (271, 'Pecan', '♀ Snooty', 'Squirrel', 'September 10th', '"chipmunk"', 'villager_Pecan.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (272, 'Peck', '♂ Jock', 'Bird', 'July 25th', '"crunch"', 'villager_Peck.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (273, 'Peewee', '♂ Cranky', 'Gorilla', 'September 11th', '"li''l dude"', 'villager_Peewee.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (274, 'Peggy', '♀ Peppy', 'Pig', 'May 23rd', '"shweetie"', 'villager_Peggy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (275, 'Pekoe', '♀ Normal', 'Cub', 'May 18th', '"bud"', 'villager_Pekoe.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (276, 'Penelope', '♀ Peppy', 'Mouse', 'February 5th', '"oh bow"', 'villager_Penelope.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (277, 'Phil', '♂ Smug', 'Ostrich', 'November 27th', '"hurk"', 'villager_Phil.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (278, 'Phoebe', '♀ Sisterly', 'Ostrich', 'April 22nd', '"sparky"', 'villager_Phoebe.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (279, 'Pierce', '♂ Jock', 'Eagle', 'January 8th', '"hawkeye"', 'villager_Pierce.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (280, 'Pietro', '♂ Smug', 'Sheep', 'April 19th', '"honk honk"', 'villager_Pietro.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (281, 'Pinky', '♀ Peppy', 'Bear', 'September 9th', '"wah"', 'villager_Pinky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (282, 'Piper', '♀ Peppy', 'Bird', 'April 18th', '"chickadee"', 'villager_Piper.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (283, 'Pippy', '♀ Peppy', 'Rabbit', 'June 14th', '"li''l hare"', 'villager_Pippy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (284, 'Plucky', '♀ Sisterly', 'Chicken', 'October 12th', '"chicky-poo"', 'villager_Plucky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (285, 'Pompom', '♀ Peppy', 'Duck', 'February 11th', '"rah rah"', 'villager_Pompom.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (286, 'Poncho', '♂ Jock', 'Cub', 'January 2nd', '"li''l bear"', 'villager_Poncho.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (287, 'Poppy', '♀ Normal', 'Squirrel', 'August 5th', '"nutty"', 'villager_Poppy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (288, 'Portia', '♀ Snooty', 'Dog', 'October 25th', '"ruffian"', 'villager_Portia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (289, 'Prince', '♂ Lazy', 'Frog', 'July 21st', '"burrup"', 'villager_Prince.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (290, 'Puck', '♂ Lazy', 'Penguin', 'February 21st', '"brrrrrrrrr"', 'villager_Puck.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (291, 'Puddles', '♀ Peppy', 'Frog', 'January 13th', '"splish"', 'villager_Puddles.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (292, 'Pudge', '♂ Lazy', 'Cub', 'June 11th', '"pudgy"', 'villager_Pudge.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (293, 'Punchy', '♂ Lazy', 'Cat', 'April 11th', '"mrmpht"', 'villager_Punchy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (294, 'Purrl', '♀ Snooty', 'Cat', 'May 29th', '"kitten"', 'villager_Purrl.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (295, 'Queenie', '♀ Snooty', 'Ostrich', 'November 13th', '"chicken"', 'villager_Queenie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (296, 'Quillson', '♂ Smug', 'Duck', 'December 22nd', '"ridukulous"', 'villager_Quillson.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (297, 'Raddle', '♂ Lazy', 'Frog', 'June 6th', '"aaach-"', 'villager_Raddle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (298, 'Rasher', '♂ Cranky', 'Pig', 'April 7th', '"swine"', 'villager_Rasher.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (299, 'Raymond', '♂ Smug', 'Cat', 'October 1st', '"crisp"', 'villager_Raymond.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (300, 'Renée', '♀ Sisterly', 'Rhino', 'May 28th', '"yo yo yo"', 'villager_Renee.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (301, 'Reneigh', '♀ Sisterly', 'Horse', 'June 4th', '"ayup, yup"', 'villager_Reneigh.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (302, 'Rex', '♂ Lazy', 'Lion', 'July 24th', '"cool cat"', 'villager_Rex.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (303, 'Rhonda', '♀ Normal', 'Rhino', 'January 24th', '"bigfoot"', 'villager_Rhonda.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (304, 'Ribbot', '♂ Jock', 'Frog', 'February 13th', '"zzrrbbitt"', 'villager_Ribbot.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (305, 'Ricky', '♂ Cranky', 'Squirrel', 'September 14th', '"nutcase"', 'villager_Ricky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (306, 'Rizzo', '♂ Cranky', 'Mouse', 'January 17th', '"squee"', 'villager_Rizzo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (307, 'Roald', '♂ Jock', 'Penguin', 'January 5th', '"b-b-buddy"', 'villager_Roald.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (308, 'Robin', '♀ Snooty', 'Bird', 'December 4th', '"la-di-da"', 'villager_Robin.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (309, 'Rocco', '♂ Cranky', 'Hippo', 'August 18th', '"hippie"', 'villager_Rocco.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (310, 'Rocket', '♀ Sisterly', 'Gorilla', 'April 14th', '"vroom"', 'villager_Rocket.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (311, 'Rod', '♂ Jock', 'Mouse', 'August 14th', '"ace"', 'villager_Rod.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (312, 'Rodeo', '♂ Lazy', 'Bull', 'October 29th', '"chaps"', 'villager_Rodeo.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (313, 'Rodney', '♂ Smug', 'Hamster', 'November 10th', '"le ham"', 'villager_Rodney.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (314, 'Rolf', '♂ Cranky', 'Tiger', 'August 22nd', '"grrrolf"', 'villager_Rolf.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (315, 'Rooney', '♂ Cranky', 'Kangaroo', 'December 1st', '"punches"', 'villager_Rooney.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (316, 'Rory', '♂ Jock', 'Lion', 'August 7th', '"capital"', 'villager_Rory.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (317, 'Roscoe', '♂ Cranky', 'Horse', 'June 16th', '"nay"', 'villager_Roscoe.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (318, 'Rosie', '♀ Peppy', 'Cat', 'February 27th', '"silly"', 'villager_Rosie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (319, 'Rowan', '♂ Jock', 'Tiger', 'August 26th', '"mango"', 'villager_Rowan.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (320, 'Ruby', '♀ Peppy', 'Rabbit', 'December 25th', '"li''l ears"', 'villager_Ruby.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (321, 'Rudy', '♂ Jock', 'Cat', 'December 20th', '"mush"', 'villager_Rudy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (322, 'Sally', '♀ Normal', 'Squirrel', 'June 19th', '"nutmeg"', 'villager_Sally.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (323, 'Samson', '♂ Jock', 'Mouse', 'July 5th', '"pipsqueak"', 'villager_Samson.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (324, 'Sandy', '♀ Normal', 'Ostrich', 'October 21st', '"speedy"', 'villager_Sandy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (325, 'Savannah', '♀ Normal', 'Horse', 'January 25th', '"y''all"', 'villager_Savannah.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (326, 'Scoot', '♂ Jock', 'Duck', 'June 13th', '"zip zoom"', 'villager_Scoot.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (327, 'Shari', '♀ Sisterly', 'Monkey', 'April 10th', '"cheeky"', 'villager_Shari.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (328, 'Sheldon', '♂ Jock', 'Squirrel', 'February 26th', '"cardio"', 'villager_Sheldon.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (329, 'Shep', '♂ Smug', 'Dog', 'November 24th', '"baaa man"', 'villager_Shep.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (330, 'Sherb', '♂ Lazy', 'Goat', 'January 18th', '"bawwww"', 'villager_Sherb.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (331, 'Simon', '♂ Lazy', 'Monkey', 'January 19th', '"zzzook"', 'villager_Simon.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (332, 'Skye', '♀ Normal', 'Wolf', 'March 24th', '"airmail"', 'villager_Skye.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (333, 'Sly', '♂ Jock', 'Alligator', 'November 15th', '"hoo-rah"', 'villager_Sly.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (334, 'Snake', '♂ Jock', 'Rabbit', 'November 3rd', '"bunyip"', 'villager_Snake.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (335, 'Snooty', '♀ Snooty', 'Anteater', 'August 24th', '"snifffff"', 'villager_Snooty.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (336, 'Soleil', '♀ Snooty', 'Hamster', 'August 9th', '"tarnation"', 'villager_Soleil.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (337, 'Sparro', '♂ Jock', 'Bird', 'November 20th', '"like whoa"', 'villager_Sparro.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (338, 'Spike', '♂ Cranky', 'Rhino', 'June 17th', '"punk"', 'villager_Spike.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (339, 'Spork', '♂ Lazy', 'Pig', 'September 3rd', '"snork"', 'villager_SporkNACracklePAL.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (340, 'Sprinkle', '♀ Peppy', 'Penguin', 'February 20th', '"frappe"', 'villager_Sprinkle.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (341, 'Sprocket', '♂ Jock', 'Ostrich', 'December 1st', '"zort"', 'villager_Sprocket.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (342, 'Static', '♂ Cranky', 'Squirrel', 'July 9th', '"krzzt"', 'villager_Static.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (343, 'Stella', '♀ Normal', 'Sheep', 'April 9th', '"baa-dabing"', 'villager_Stella.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (344, 'Sterling', '♂ Jock', 'Eagle', 'December 11th', '"skraaaaw"', 'villager_Sterling.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (345, 'Stinky', '♂ Jock', 'Cat', 'August 17th', '"GAHHHH"', 'villager_Stinky.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (346, 'Stitches', '♂ Lazy', 'Cub', 'February 10th', '"stuffin''"', 'villager_Stitches.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (347, 'Stu', '♂ Lazy', 'Bull', 'April 20th', '"moo-dude"', 'villager_Stu.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (348, 'Sydney', '♀ Normal', 'Koala', 'June 21st', '"sunshine"', 'villager_Sydney.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (349, 'Sylvana', '♀ Normal', 'Squirrel', 'October 22nd', '"hubbub"', 'villager_Sylvana.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (350, 'Sylvia', '♀ Sisterly', 'Kangaroo', 'May 3rd', '"boing"', 'villager_Sylvia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (351, 'Tabby', '♀ Peppy', 'Cat', 'August 13th', '"me-WOW"', 'villager_Tabby.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (352, 'Tad', '♂ Jock', 'Frog', 'August 3rd', '"sluuuurp"', 'villager_Tad.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (353, 'Tammi', '♀ Peppy', 'Monkey', 'April 2nd', '"chimpy"', 'villager_Tammi.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (354, 'Tammy', '♀ Sisterly', 'Cub', 'June 23rd', '"ya heard"', 'villager_Tammy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (355, 'Tangy', '♀ Peppy', 'Cat', 'June 17th', '"reeeeOWR"', 'villager_Tangy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (356, 'Tank', '♂ Jock', 'Rhino', 'May 6th', '"kerPOW"', 'villager_Tank.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (357, 'T-Bone', '♂ Cranky', 'Bull', 'May 20th', '"moocher"', 'villager_T_Bone.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (358, 'Tasha', '♀ Snooty', 'Squirrel', 'November 30th', '"nice nice"', 'villager_Tasha.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (359, 'Teddy', '♂ Jock', 'Bear', 'September 26th', '"grooof"', 'villager_Teddy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (360, 'Tex', '♂ Smug', 'Penguin', 'October 6th', '"picante"', 'villager_Tex.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (361, 'Tia', '♀ Normal', 'Elephant', 'November 18th', '"teacup"', 'villager_Tia.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (362, 'Tiffany', '♀ Snooty', 'Rabbit', 'January 9th', '"bun bun"', 'villager_Tiffany.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (363, 'Timbra', '♀ Snooty', 'Sheep', 'October 21st', '"pine nut"', 'villager_Timbra.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (364, 'Tipper', '♀ Snooty', 'Cow', 'August 25th', '"pushy"', 'villager_Tipper.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (365, 'Tom', '♂ Cranky', 'Cat', 'December 10th', '"me-YOWZA"', 'villager_Tom.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (366, 'Truffles', '♀ Peppy', 'Pig', 'July 28th', '"snoutie"', 'villager_Truffles.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (367, 'Tucker', '♂ Lazy', 'Elephant', 'September 7th', '"fuzzers"', 'villager_Tucker.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (368, 'Tutu', '♀ Peppy', 'Bear', 'November 15th', '"twinkles"', 'villager_Tutu.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (369, 'Twiggy', '♀ Peppy', 'Bird', 'July 13th', '"cheepers"', 'villager_Twiggy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (370, 'Tybalt', '♂ Jock', 'Tiger', 'August 19th', '"grrRAH"', 'villager_Tybalt.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (371, 'Ursala', '♀ Sisterly', 'Bear', 'January 16th', '"grooomph"', 'villager_Ursala.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (372, 'Velma', '♀ Snooty', 'Goat', 'January 14th', '"blih"', 'villager_Velma.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (373, 'Vesta', '♀ Normal', 'Sheep', 'April 16th', '"baaaffo"', 'villager_Vesta.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (374, 'Vic', '♂ Cranky', 'Bull', 'December 29th', '"cud"', 'villager_Vic.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (375, 'Victoria', '♀ Peppy', 'Horse', 'July 11th', '"sugar cube"', 'villager_Victoria.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (376, 'Violet', '♀ Snooty', 'Gorilla', 'September 1st', '"sweetie"', 'villager_Violet.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (377, 'Vivian', '♀ Snooty', 'Wolf', 'January 26th', '"piffle"', 'villager_Vivian.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (378, 'Vladimir', '♂ Cranky', 'Cub', 'August 2nd', '"nyet"', 'villager_Vladimir.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (379, 'Wade', '♂ Lazy', 'Penguin', 'October 30th', '"so it goes"', 'villager_Wade.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (380, 'Walker', '♂ Lazy', 'Dog', 'June 10th', '"wuh"', 'villager_Walker.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (381, 'Walt', '♂ Cranky', 'Kangaroo', 'April 24th', '"pockets"', 'villager_Walt.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (382, 'Wart Jr.', '♂ Cranky', 'Frog', 'August 21st', '"grr-ribbit"', 'villager_Wart_Jr.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (383, 'Weber', '♂ Lazy', 'Duck', 'June 30th', '"quaa"', 'villager_Weber.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (384, 'Wendy', '♀ Peppy', 'Sheep', 'August 15th', '"lambkins"', 'villager_Wendy.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (385, 'Winnie', '♀ Peppy', 'Horse', 'January 31st', '"hay-OK"', 'villager_Winnie.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (386, 'Whitney', '♀ Snooty', 'Wolf', 'September 17th', '"snappy"', 'villager_Whitney.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (387, 'Willow', '♀ Snooty', 'Sheep', 'November 26th', '"bo peep"', 'villager_Willow.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (388, 'Wolfgang', '♂ Cranky', 'Wolf', 'November 25th', '"snarrrl"', 'villager_Wolfgang.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (389, 'Yuka', '♀ Snooty', 'Koala', 'July 20th', '"tsk tsk"', 'villager_Yuka.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (390, 'Zell', '♂ Smug', 'Deer', 'June 7th', '"pronk"', 'villager_Zell.png');
    replace into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (391, 'Zucker', '♂ Lazy', 'Octopus', 'March 8th', '"bloop"', 'villager_Zucker.png');
commit;

begin transaction;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 1;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 2;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 3;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 4;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 5;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 6;
    update critters set CatchStartTime = '04:00', CatchEndTime = '19:00' where ID = 7;
    update critters set CatchStartTime = '04:00', CatchEndTime = '17:00' where ID = 8;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 9;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 10;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 11;
    update critters set CatchStartTime = '08:00', CatchEndTime = '16:00' where ID = 12;
    update critters set CatchStartTime = '19:00', CatchEndTime = '04:00' where ID = 13;
    update critters set CatchStartTime = '19:00', CatchEndTime = '04:00' where ID = 14;
    update critters set CatchStartTime = '08:00', CatchEndTime = '16:00' where ID = 15;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 16;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 17;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 18;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 19;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 20;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 21;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 22;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 23;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 24;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 25;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 26;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 27;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 28;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 29;
    update critters set CatchStartTime = '04:00', CatchEndTime = '08:00' where ID = 30;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 31;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 32;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 33;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 34;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 35;
    update critters set CatchStartTime = '19:00', CatchEndTime = '04:00' where ID = 36;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 37;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 38;
    update critters set CatchStartTime = '08:00', CatchEndTime = '19:00' where ID = 39;
    update critters set CatchStartTime = '19:00', CatchEndTime = '08:00' where ID = 40;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 41;
    update critters set CatchStartTime = '19:00', CatchEndTime = '08:00' where ID = 42;
    update critters set CatchStartTime = '08:00', CatchEndTime = '17:00' where ID = 43;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 44;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 45;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 46;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 47;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 48;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 49;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 50;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 51;
    update critters set CatchStartTime = '13:00', CatchEndTime = '08:00' where ID = 52;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 53;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 54;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 55;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 56;
    update critters set CatchStartTime = '13:00', CatchEndTime = '08:00' where ID = 57;
    update critters set CatchStartTime = '19:00', CatchEndTime = '08:00' where ID = 58;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 59;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 60;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 61;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 62;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 63;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 64;
    update critters set CatchStartTime = '17:00', CatchEndTime = '08:00' where ID = 65;
    update critters set CatchStartTime = '04:00', CatchEndTime = '08:00' where ID = 66;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 67;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 68;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 69;
    update critters set CatchStartTime = '19:00', CatchEndTime = '08:00' where ID = 70;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 71;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 72;
    update critters set CatchStartTime = '17:00', CatchEndTime = '04:00' where ID = 73;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 74;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 75;
    update critters set CatchStartTime = '13:00', CatchEndTime = '16:00' where ID = 76;
    update critters set CatchStartTime = '16:00', CatchEndTime = '13:00' where ID = 77;
    update critters set CatchStartTime = '19:00', CatchEndTime = '08:00' where ID = 78;
    update critters set CatchStartTime = '19:00', CatchEndTime = '04:00' where ID = 79;
    update critters set CatchStartTime = '19:00', CatchEndTime = '04:00' where ID = 80;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 81;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 82;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 83;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 84;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 85;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 86;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 87;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 88;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 89;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 90;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 91;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 92;
    update critters set CatchStartTime = '21:00', CatchEndTime = '04:00' where ID = 93;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 94;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 95;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 96;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 97;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 98;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 99;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 100;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 101;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 102;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 103;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 104;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 105;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 106;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 107;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 108;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 109;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 110;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 111;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 112;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 113;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 114;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 115;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 116;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 117;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 118;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 119;
    update critters set CatchStartTime = '09:00', CatchEndTime = '16:00' where ID = 120;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 121;
    update critters set CatchStartTime = '04:00', CatchEndTime = '21:00' where ID = 122;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 123;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 124;
    update critters set CatchStartTime = '21:00', CatchEndTime = '04:00' where ID = 125;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 126;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 127;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 128;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 129;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 130;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 131;
    update critters set CatchStartTime = '04:00', CatchEndTime = '21:00' where ID = 132;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 133;
    update critters set CatchStartTime = '21:00', CatchEndTime = '04:00' where ID = 134;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 135;
    update critters set CatchStartTime = '04:00', CatchEndTime = '21:00' where ID = 136;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 137;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 138;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 139;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 140;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 141;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 142;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 143;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 144;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 145;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 146;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 147;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 148;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 149;
    update critters set CatchStartTime = '04:00', CatchEndTime = '21:00' where ID = 150;
    update critters set CatchStartTime = '04:00', CatchEndTime = '21:00' where ID = 151;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 152;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 153;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 154;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 155;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 156;
    update critters set CatchStartTime = '16:00', CatchEndTime = '09:00' where ID = 157;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 158;
    update critters set CatchStartTime = '21:00', CatchEndTime = '04:00' where ID = 159;
    update critters set CatchStartTime = '00:00', CatchEndTime = '23:59' where ID = 160;
commit;

update critters set Rarity = 'Uncommon (★★★)' where ID = 136;
