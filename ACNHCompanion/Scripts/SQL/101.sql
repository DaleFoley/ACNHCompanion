drop table if exists config;
drop table config (ID integer primary key,
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

drop table northern_months;
create table northern_months (ID integer primary key,
            CritterName text,
            Months text);

drop table southern_months;
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
			when '01' then 'jan'
			when '02' then 'feb'
			when '03' then 'mar'
			when '04' then 'apr'
			when '05' then 'may'
			when '06' then 'jun'
			when '07' then 'jul'
			when '08' then 'aug'
			when '09' then 'sep'
			when '10' then 'oct'
			when '11' then 'nov'
			when '12' then 'dec'
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
			when '01' then 'jan'
			when '02' then 'feb'
			when '03' then 'mar'
			when '04' then 'apr'
			when '05' then 'may'
			when '06' then 'jun'
			when '07' then 'jul'
			when '08' then 'aug'
			when '09' then 'sep'
			when '10' then 'oct'
			when '11' then 'nov'
			when '12' then 'dec'
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
				when '01' then 'jan'
				when '02' then 'feb'
				when '03' then 'mar'
				when '04' then 'apr'
				when '05' then 'may'
				when '06' then 'jun'
				when '07' then 'jul'
				when '08' then 'aug'
				when '09' then 'sep'
				when '10' then 'oct'
				when '11' then 'nov'
				when '12' then 'dec'
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
		when '01' then 'jan'
		when '02' then 'feb'
		when '03' then 'mar'
		when '04' then 'apr'
		when '05' then 'may'
		when '06' then 'jun'
		when '07' then 'jul'
		when '08' then 'aug'
		when '09' then 'sep'
		when '10' then 'oct'
		when '11' then 'nov'
		when '12' then 'dec'
		else '' end) > 0 then true else false end as IsCatchableBasedOnMonth
   from v_base_critters
   inner join southern_months on southern_months.CritterName = v_base_critters.CritterName
   where v_base_critters.Type = 'fish'
   order by v_base_critters.CritterName;		

insert into config (ID, Name, Value, IsEnabled) VALUES (1, 'hemisphere', 'North', 1);
insert into config (ID, Name, Value, IsEnabled) VALUES (2, 'version', '101', 1);

insert into northern_months (ID, CritterName, Months) VALUES (1, 'Common butterfly', 'jan feb mar apr may jun sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (2, 'Yellow butterfly', 'mar apr may jun sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (3, 'Tiger butterfly', 'mar apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (4, 'Peacock butterfly', 'mar apr may jun');
insert into northern_months (ID, CritterName, Months) VALUES (5, 'Common bluebottle', 'apr may jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (6, 'Paper kite butterfly', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (7, 'Great purple emperor', 'may jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (8, 'Monarch butterfly', 'sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (9, 'Emperor butterfly', 'jan feb mar jun jul aug sep dec');
insert into northern_months (ID, CritterName, Months) VALUES (10, 'Agrias butterfly', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (11, 'Rajah Brooke''s birdwing', 'jan feb apr may jun jul aug sep dec');
insert into northern_months (ID, CritterName, Months) VALUES (12, 'Queen Alexandra''s birdwing', 'may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (13, 'Moth', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (14, 'Atlas moth', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (15, 'Madagascan sunset moth', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (16, 'Long locust', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (17, 'Migratory locust', 'aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (18, 'Rice grasshopper', 'aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (19, 'Grasshopper', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (20, 'Cricket', 'sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (21, 'Bell cricket', 'sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (22, 'Mantis', 'mar apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (23, 'Orchid mantis', 'mar apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (24, 'Honeybee', 'mar apr may jun jul');
insert into northern_months (ID, CritterName, Months) VALUES (25, 'Wasp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (26, 'Brown cicada', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (27, 'Robust cicada', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (28, 'Giant cicada', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (29, 'Walker cicada', 'aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (30, 'Evening cicada', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (31, 'Cicada shell', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (32, 'Red dragonfly', 'sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (33, 'Darner dragonfly', 'apr may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (34, 'Banded dragonfly', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (35, 'Damselfly', 'jan feb nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (36, 'Firefly', 'jun');
insert into northern_months (ID, CritterName, Months) VALUES (37, 'Mole cricket', 'jan feb mar apr may nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (38, 'Pondskater', 'may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (39, 'Diving beetle', 'may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (40, 'Giant water bug', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (41, 'Stinkbug', 'mar apr may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (42, 'Man-faced stink bug', 'mar apr may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (43, 'Ladybug', 'mar apr may jun oct');
insert into northern_months (ID, CritterName, Months) VALUES (44, 'Tiger beetle', 'feb mar apr may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (45, 'Jewel beetle', 'apr may jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (46, 'Violin beetle', 'may jun sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (47, 'Citrus long-horned beetle', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (48, 'Rosalia batesi beetle', 'may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (49, 'Blue weevil beetle', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (50, 'Dung beetle', 'jan feb dec');
insert into northern_months (ID, CritterName, Months) VALUES (51, 'Earth-boring dung beetle', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (52, 'Scarab beetle', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (53, 'Drone beetle', 'jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (54, 'Goliath beetle', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (55, 'Saw stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (56, 'Miyama stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (57, 'Giant stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (58, 'Rainbow stag', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (59, 'Cyclommatus stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (60, 'Golden stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (61, 'Giraffe stag', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (62, 'Horned dynastid', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (63, 'Horned atlas', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (64, 'Horned elephant', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (65, 'Horned hercules', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (66, 'Walking stick', 'jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (67, 'Walking leaf', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (68, 'Bagworm', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (69, 'Ant', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (70, 'Hermit crab', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (71, 'Wharf roach', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (72, 'Fly', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (73, 'Mosquito', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (74, 'Flea', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (75, 'Snail', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (76, 'Pill bug', 'jan feb mar apr may jun sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (77, 'Centipede', 'jan feb mar apr may jun sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (78, 'Spider', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (79, 'Tarantula', 'jan feb mar apr nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (80, 'Scorpion', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (81, 'Bitterling', 'jan feb mar nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (82, 'Pale chub', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (83, 'Crucian carp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (84, 'Dace', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (85, 'Carp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (86, 'Koi', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (87, 'Goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (88, 'Pop-eyed goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (89, 'Ranchu goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (90, 'Killifish', 'apr may jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (91, 'Crawfish', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (92, 'Soft-shelled turtle', 'aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (93, 'Snapping Turtle', 'apr may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (94, 'Tadpole', 'mar apr may jun jul');
insert into northern_months (ID, CritterName, Months) VALUES (95, 'Frog', 'may jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (96, 'Freshwater goby', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (97, 'Loach', 'mar apr may');
insert into northern_months (ID, CritterName, Months) VALUES (98, 'Catfish', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (99, 'Giant snakehead', 'jun jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (100, 'Bluegill', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (101, 'Yellow perch', 'jan feb mar oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (102, 'Black bass', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (103, 'Tilapia', 'jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (104, 'Pike', 'sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (105, 'Pond smelt', 'jan feb dec');
insert into northern_months (ID, CritterName, Months) VALUES (106, 'Sweetfish', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (107, 'Cherry salmon', 'mar apr may jun sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (108, 'Char', 'mar apr may jun sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (109, 'Golden trout', 'mar apr may sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (110, 'Stringfish', 'jan feb mar dec');
insert into northern_months (ID, CritterName, Months) VALUES (111, 'Salmon', 'sep');
insert into northern_months (ID, CritterName, Months) VALUES (112, 'King salmon', 'sep');
insert into northern_months (ID, CritterName, Months) VALUES (113, 'Mitten crab', 'sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (114, 'Guppy', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (115, 'Nibble fish', 'may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (116, 'Angelfish', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (117, 'Betta', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (118, 'Neon tetra', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (119, 'Rainbowfish', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (120, 'Piranha', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (121, 'Arowana', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (122, 'Dorado', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (123, 'Gar', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (124, 'Arapaima', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (125, 'Saddled bichir', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (126, 'Sturgeon', 'jan feb mar sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (127, 'Sea butterfly', 'jan feb mar dec');
insert into northern_months (ID, CritterName, Months) VALUES (128, 'Sea horse', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (129, 'Clown fish', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (130, 'Surgeonfish', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (131, 'Butterfly fish', 'apr may jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (132, 'Napoleonfish', 'jul aug');
insert into northern_months (ID, CritterName, Months) VALUES (133, 'Zebra turkeyfish', 'apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (134, 'Blowfish', 'jan feb nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (135, 'Puffer fish', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (136, 'Anchovy', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (137, 'Horse mackerel', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (138, 'Barred knifejaw', 'mar apr may jun jul aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (139, 'Sea bass', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (140, 'Red snapper', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (141, 'Dab', 'jan feb mar apr oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (142, 'Olive flounder', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (143, 'Squid', 'jan feb mar apr may jun jul aug dec');
insert into northern_months (ID, CritterName, Months) VALUES (144, 'Moray eel', 'aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (145, 'Ribbon eel', 'jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (146, 'Tuna', 'jan feb mar apr nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (147, 'Blue marlin', 'jan feb mar apr jul aug sep nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (148, 'Giant trevally', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (149, 'Mahi-mahi', 'may jun jul aug sep oct');
insert into northern_months (ID, CritterName, Months) VALUES (150, 'Ocean sunfish', 'jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (151, 'Ray', 'aug sep oct nov');
insert into northern_months (ID, CritterName, Months) VALUES (152, 'Saw shark', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (153, 'Hammerhead shark', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (154, 'Great white shark', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (155, 'Whale shark', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (156, 'Suckerfish', 'jun jul aug sep');
insert into northern_months (ID, CritterName, Months) VALUES (157, 'Football fish', 'jan feb mar nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (158, 'Oarfish', 'jan feb mar apr may dec');
insert into northern_months (ID, CritterName, Months) VALUES (159, 'Barreleye', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into northern_months (ID, CritterName, Months) VALUES (160, 'Coelacanth', 'jan feb mar apr may jun jul aug sep oct nov dec');

insert into southern_months (ID, CritterName, Months) VALUES (1, 'Common butterfly', 'mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (2, 'Yellow butterfly', 'mar apr sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (3, 'Tiger butterfly', 'jan feb mar sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (4, 'Peacock butterfly', 'sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (5, 'Common bluebottle', 'jan feb oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (6, 'Paper kite butterfly', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (7, 'Great purple emperor', 'jan feb nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (8, 'Monarch butterfly', 'mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (9, 'Emperor butterfly', 'jan feb mar jun jul aug sep dec');
insert into southern_months (ID, CritterName, Months) VALUES (10, 'Agrias butterfly', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (11, 'Rajah Brooke''s birdwing', 'jan feb mar jun jul aug oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (12, 'Queen Alexandra''s birdwing', 'jan feb mar nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (13, 'Moth', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (14, 'Atlas moth', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (15, 'Madagascan sunset moth', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (16, 'Long locust', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (17, 'Migratory locust', 'feb mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (18, 'Rice grasshopper', 'feb mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (19, 'Grasshopper', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (20, 'Cricket', 'mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (21, 'Bell cricket', 'mar apr');
insert into southern_months (ID, CritterName, Months) VALUES (22, 'Mantis', 'jan feb mar apr may sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (23, 'Orchid mantis', 'jan feb mar apr may sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (24, 'Honeybee', 'jan sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (25, 'Wasp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (26, 'Brown cicada', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (27, 'Robust cicada', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (28, 'Giant cicada', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (29, 'Walker cicada', 'feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (30, 'Evening cicada', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (31, 'Cicada shell', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (32, 'Red dragonfly', 'mar apr');
insert into southern_months (ID, CritterName, Months) VALUES (33, 'Darner dragonfly', 'jan feb mar apr oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (34, 'Banded dragonfly', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (35, 'Damselfly', 'may jun jul aug');
insert into southern_months (ID, CritterName, Months) VALUES (36, 'Firefly', 'dec');
insert into southern_months (ID, CritterName, Months) VALUES (37, 'Mole cricket', 'may jun jul aug sep oct nov');
insert into southern_months (ID, CritterName, Months) VALUES (38, 'Pondskater', 'jan feb mar nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (39, 'Diving beetle', 'jan feb mar nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (40, 'Giant water bug', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (41, 'Stinkbug', 'jan feb mar apr sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (42, 'Man-faced stink bug', 'jan feb mar apr sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (43, 'Ladybug', 'apr sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (44, 'Tiger beetle', 'jan feb mar apr aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (45, 'Jewel beetle', 'jan feb oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (46, 'Violin beetle', 'mar apr may nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (47, 'Citrus long-horned beetle', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (48, 'Rosalia batesi beetle', 'jan feb mar nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (49, 'Blue weevil beetle', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (50, 'Dung beetle', 'jun jul aug');
insert into southern_months (ID, CritterName, Months) VALUES (51, 'Earth-boring dung beetle', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (52, 'Scarab beetle', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (53, 'Drone beetle', 'jan feb dec');
insert into southern_months (ID, CritterName, Months) VALUES (54, 'Goliath beetle', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (55, 'Saw stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (56, 'Miyama stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (57, 'Giant stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (58, 'Rainbow stag', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (59, 'Cyclommatus stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (60, 'Golden stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (61, 'Giraffe stag', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (62, 'Horned dynastid', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (63, 'Horned atlas', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (64, 'Horned elephant', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (65, 'Horned hercules', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (66, 'Walking stick', 'jan feb mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (67, 'Walking leaf', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (68, 'Bagworm', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (69, 'Ant', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (70, 'Hermit crab', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (71, 'Wharf roach', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (72, 'Fly', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (73, 'Mosquito', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (74, 'Flea', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (75, 'Snail', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (76, 'Pill bug', 'mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (77, 'Centipede', 'mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (78, 'Spider', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (79, 'Tarantula', 'may jun jul aug sep oct');
insert into southern_months (ID, CritterName, Months) VALUES (80, 'Scorpion', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (81, 'Bitterling', 'may jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (82, 'Pale chub', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (83, 'Crucian carp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (84, 'Dace', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (85, 'Carp', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (86, 'Koi', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (87, 'Goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (88, 'Pop-eyed goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (89, 'Ranchu goldfish', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (90, 'Killifish', 'jan feb oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (91, 'Crawfish', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (92, 'Soft-shelled turtle', 'feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (93, 'Snapping turtle', 'jan feb mar apr oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (94, 'Tadpole', 'jan sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (95, 'Frog', 'jan feb nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (96, 'Freshwater goby', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (97, 'Loach', 'sep oct nov');
insert into southern_months (ID, CritterName, Months) VALUES (98, 'Catfish', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (99, 'Giant snakehead', 'jan feb dec');
insert into southern_months (ID, CritterName, Months) VALUES (100, 'Bluegill', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (101, 'Yellow perch', 'apr may jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (102, 'Black bass', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (103, 'Tilapia', 'jan feb mar apr dec');
insert into southern_months (ID, CritterName, Months) VALUES (104, 'Pike', 'mar apr may jun');
insert into southern_months (ID, CritterName, Months) VALUES (105, 'Pond smelt', 'jun jul aug');
insert into southern_months (ID, CritterName, Months) VALUES (106, 'Sweetfish', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (107, 'Cherry salmon', 'mar apr may sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (108, 'Char', 'mar apr may sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (109, 'Golden trout', 'mar apr may sep oct nov');
insert into southern_months (ID, CritterName, Months) VALUES (110, 'Stringfish', 'jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (111, 'Salmon', 'mar');
insert into southern_months (ID, CritterName, Months) VALUES (112, 'King salmon', 'mar');
insert into southern_months (ID, CritterName, Months) VALUES (113, 'Mitten crab', 'mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (114, 'Guppy', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (115, 'Nibble fish', 'jan feb mar nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (116, 'Angelfish', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (117, 'Betta', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (118, 'Neon tetra', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (119, 'Rainbowfish', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (120, 'Piranha', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (121, 'Arowana', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (122, 'Dorado', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (123, 'Gar', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (124, 'Arapaima', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (125, 'Saddled bichir', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (126, 'Sturgeon', 'mar apr may jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (127, 'Sea butterfly', 'jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (128, 'Sea horse', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (129, 'Clown fish', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (130, 'Surgeonfish', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (131, 'Butterfly fish', 'jan feb mar oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (132, 'Napoleonfish', 'jan feb');
insert into southern_months (ID, CritterName, Months) VALUES (133, 'Zebra turkeyfish', 'jan feb mar apr may oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (134, 'Blowfish', 'may jun jul aug');
insert into southern_months (ID, CritterName, Months) VALUES (135, 'Puffer fish', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (136, 'Anchovy', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (137, 'Horse mackerel', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (138, 'Barred knifejaw', 'jan feb mar apr may sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (139, 'Sea bass', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (140, 'Red snapper', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (141, 'Dab', 'apr may jun jul aug sep oct');
insert into southern_months (ID, CritterName, Months) VALUES (142, 'Olive flounder', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (143, 'Squid', 'jan feb jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (144, 'Moray eel', 'feb mar apr');
insert into southern_months (ID, CritterName, Months) VALUES (145, 'Ribbon eel', 'jan feb mar apr dec');
insert into southern_months (ID, CritterName, Months) VALUES (146, 'Tuna', 'may jun jul aug sep oct');
insert into southern_months (ID, CritterName, Months) VALUES (147, 'Blue marlin', 'jan feb mar may jun jul aug sep oct');
insert into southern_months (ID, CritterName, Months) VALUES (148, 'Giant trevally', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (149, 'Mahi-mahi', 'jan feb mar apr nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (150, 'Ocean sunfish', 'jan feb mar');
insert into southern_months (ID, CritterName, Months) VALUES (151, 'Ray', 'feb mar apr may');
insert into southern_months (ID, CritterName, Months) VALUES (152, 'Saw shark', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (153, 'Hammerhead shark', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (154, 'Great white shark', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (155, 'Whale shark', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (156, 'Suckerfish', 'jan feb mar dec');
insert into southern_months (ID, CritterName, Months) VALUES (157, 'Football fish', 'may jun jul aug sep');
insert into southern_months (ID, CritterName, Months) VALUES (158, 'Oarfish', 'jun jul aug sep oct nov');
insert into southern_months (ID, CritterName, Months) VALUES (159, 'Barreleye', 'jan feb mar apr may jun jul aug sep oct nov dec');
insert into southern_months (ID, CritterName, Months) VALUES (160, 'Coelacanth', 'jan feb mar apr may jun jul aug sep oct nov dec');

insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (1, 'Admiral', '♂ Cranky', 'Bird', 'January 27th', '"aye aye"', 'villager_Admiral.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (2, 'Agent S', '♀ Peppy', 'Squirrel', 'July 2nd', '"sidekick"', 'villager_Agent_S.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (3, 'Agnes', '♀ Sisterly', 'Pig', 'April 21st', '"snuffle"', 'villager_Agnes.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (4, 'Al', '♂ Lazy', 'Gorilla', 'October 18th', '"Ayyeeee"', 'villager_Al.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (5, 'Alfonso', '♂ Lazy', 'Alligator', 'June 9th', '"it''sa me"', 'villager_Alfonso.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (6, 'Alice', '♀ Normal', 'Koala', 'August 19th', '"guvnor"', 'villager_Alice.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (7, 'Alli', '♀ Snooty', 'Alligator', 'November 8th', '"graaagh"', 'villager_Alli.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (8, 'Amelia', '♀ Snooty', 'Eagle', 'November 19th', '"cuz"', 'villager_Amelia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (9, 'Anabelle', '♀ Peppy', 'Anteater', 'February 16th', '"snorty"', 'villager_Anabelle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (10, 'Anchovy', '♂ Lazy', 'Bird', 'March 4th', '"chuurp"', 'villager_Anchovy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (11, 'Ankha', '♀ Snooty', 'Cat', 'September 22nd', '"me meow"', 'villager_Ankha.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (12, 'Angus', '♂ Cranky', 'Bull', 'April 30th', '"macmoo"', 'villager_Angus.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (13, 'Anicotti', '♀ Peppy', 'Mouse', 'February 24th', '"cannoli"', 'villager_Anicotti.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (14, 'Annalisa', '♀ Normal', 'Anteater', 'February 6th', '"gumdrop"', 'villager_Annalisa.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (15, 'Annalise', '♀ Snooty', 'Horse', 'December 2nd', '"nipper"', 'villager_Annalise.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (16, 'Antonio', '♂ Jock', 'Anteater', 'October 20th', '"honk"', 'villager_Antonio.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (17, 'Apollo', '♂ Cranky', 'Eagle', 'July 4th', '"pah"', 'villager_Apollo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (18, 'Apple', '♀ Peppy', 'Hamster', 'September 24th', '"cheekers"', 'villager_Apple.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (19, 'Astrid', '♀ Snooty', 'Kangaroo', 'September 8th', '"my pet"', 'villager_Astrid.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (20, 'Audie', '♀ Peppy', 'Wolf', 'August 31st', '"Foxtrot"', 'villager_Audie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (21, 'Aurora', '♀ Normal', 'Penguin', 'January 27th', '"b-b-baby"', 'villager_Aurora.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (22, 'Ava', '♀ Normal', 'Chicken', 'April 28th', '"beaker"', 'villager_Ava.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (23, 'Avery', '♂ Cranky', 'Eagle', 'February 22nd', '"skree-haw"', 'villager_Avery.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (24, 'Axel', '♂ Jock', 'Elephant', 'March 23rd', '"WHONK"', 'villager_Axel.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (25, 'Baabara', '♀ Snooty', 'Sheep', 'March 28th', '"daahling"', 'villager_Baabara.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (26, 'Bam', '♂ Jock', 'Deer', 'November 7th', '"kablang"', 'villager_Bam.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (27, 'Bangle', '♀ Peppy', 'Tiger', 'August 27th', '"growf"', 'villager_Bangle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (28, 'Barold', '♂ Lazy', 'Cub', 'March 2nd', '"cubby"', 'villager_Barold.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (29, 'Beau', '♂ Lazy', 'Deer', 'April 5th', '"saltlick"', 'villager_Beau.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (30, 'Bea', '♀ Normal', 'Dog', 'October 15th', '"bingo"', 'villager_Bea.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (31, 'Beardo', '♂ Smug', 'Bear', 'September 27th', '"whiskers"', 'villager_Beardo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (32, 'Becky', '♀ Snooty', 'Chicken', 'December 9th', '"chicklet"', 'villager_Becky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (33, 'Bella', '♀ Peppy', 'Mouse', 'December 28th', '"eeks"', 'villager_Bella.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (34, 'Benedict', '♂ Lazy', 'Chicken', 'October 10th', '"uh-hoo"', 'villager_Benedict.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (35, 'Benjamin', '♂ Lazy', 'Dog', 'August 3rd', '"alrighty"', 'villager_Benjamin.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (36, 'Bertha', '♀ Normal', 'Hippo', 'April 25th', '"bloop"', 'villager_Bertha.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (37, 'Bettina', '♀ Normal', 'Mouse', 'June 12th', '"eekers"', 'villager_Bettina.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (38, 'Bianca', '♀ Peppy', 'Tiger', 'December 13th', '"glimmer"', 'villager_Bianca.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (39, 'Biff', '♂ Jock', 'Hippo', 'March 29th', '"squirt"', 'villager_Biff.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (40, 'Big Top', '♂ Lazy', 'Elephant', 'October 3rd', '"villain"', 'villager_Big_Top.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (41, 'Bill', '♂ Jock', 'Duck', 'February 1st', '"quacko"', 'villager_Bill.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (42, 'Billy', '♂ Jock', 'Goat', 'March 25th', '"dagnaabit"', 'villager_Billy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (43, 'Biskit', '♂ Lazy', 'Dog', 'May 13th', '"dog"', 'villager_Biskit.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (44, 'Bitty', '♀ Snooty', 'Hippo', 'October 6th', '"my dear"', 'villager_Bitty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (45, 'Blaire', '♀ Snooty', 'Squirrel', 'July 3rd', '"nutlet"', 'villager_Blaire.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (46, 'Blanche', '♀ Snooty', 'Ostrich', 'December 21st', '"quite so"', 'villager_Blanche.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (47, 'Bluebear', '♀ Peppy', 'Cub', 'June 24th', '"peach"', 'villager_Bluebear.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (48, 'Bob', '♂ Lazy', 'Cat', 'January 1st', '"pthhhpth"', 'villager_Bob.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (49, 'Bonbon', '♀ Peppy', 'Rabbit', 'March 3rd', '"deelish"', 'villager_Bonbon.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (50, 'Bones', '♂ Lazy', 'Dog', 'August 4th', '"yip yip"', 'villager_Bones.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (51, 'Boomer', '♂ Lazy', 'Penguin', 'February 7th', '"human"', 'villager_Boomer.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (52, 'Boone', '♂ Jock', 'Gorilla', 'September 12th', '"baboom"', 'villager_Boone.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (53, 'Boots', '♂ Jock', 'Alligator', 'August 7th', '"munchie"', 'villager_Boots.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (54, 'Boris', '♂ Cranky', 'Pig', 'November 6th', '"schnort"', 'villager_Boris.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (55, 'Boyd', '♂ Cranky', 'Gorilla', 'October 1st', '"uh-oh"', 'villager_Boyd.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (56, 'Bree', '♀ Snooty', 'Mouse', 'July 7th', '"cheeseball"', 'villager_Bree.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (57, 'Broccolo', '♂ Lazy', 'Mouse', 'June 30th', '"eat it"', 'villager_Broccolo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (58, 'Bruce', '♂ Cranky', 'Deer', 'May 26th', '"gruff"', 'villager_Bruce.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (59, 'Broffina', '♀ Snooty', 'Chicken', 'October 24th', '"cluckadoo"', 'villager_Broffina.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (60, 'Bubbles', '♀ Peppy', 'Hippo', 'September 18th', '"hipster"', 'villager_Bubbles.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (61, 'Buck', '♂ Jock', 'Horse', 'April 4th', '"pardner"', 'villager_Buck.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (62, 'Bud', '♂ Jock', 'Lion', 'August 8th', '"shredded"', 'villager_Bud.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (63, 'Bunnie', '♀ Peppy', 'Rabbit', 'May 9th', '"tee-hee"', 'villager_Bunnie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (64, 'Butch', '♂ Cranky', 'Dog', 'November 1st', '"ROOOOOWF"', 'villager_Butch.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (65, 'Buzz', '♂ Cranky', 'Eagle', 'December 7th', '"captain"', 'villager_Buzz.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (66, 'Cally', '♀ Normal', 'Squirrel', 'September 4th', '"WHEE"', 'villager_Cally.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (67, 'Camofrog', '♂ Cranky', 'Frog', 'June 5th', '"ten-hut"', 'villager_Camofrog.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (68, 'Canberra', '♀ Sisterly', 'Koala', 'May 14th', '"nuh uh"', 'villager_Canberra.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (69, 'Candi', '♀ Peppy', 'Mouse', 'April 13th', '"sweetie"', 'villager_Candi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (70, 'Carmen', '♀ Peppy', 'Rabbit', 'January 6th', '"nougat"', 'villager_Carmen.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (71, 'Caroline', '♀ Normal', 'Squirrel', 'July 15th', '"hulaaaa"', 'villager_Caroline.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (72, 'Carrie', '♀ Normal', 'Kangaroo', 'December 5th', '"little one"', 'villager_Carrie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (73, 'Cashmere', '♀ Snooty', 'Sheep', 'April 2nd', '"baaaby"', 'villager_Cashmere.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (74, 'Celia', '♀ Normal', 'Eagle', 'March 25th', '"feathers"', 'villager_Celia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (75, 'Cesar', '♂ Cranky', 'Gorilla', 'September 6th', '"highness"', 'villager_Cesar.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (76, 'Chadder', '♂ Smug', 'Mouse', 'December 15th', '"fromage"', 'villager_Chadder.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (77, 'Charlise', '♀ Sisterly', 'Bear', 'April 17th', '"urgh"', 'villager_Charlise.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (78, 'Cheri', '♀ Peppy', 'Cub', 'March 17th', '"tralala"', 'villager_Cheri.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (79, 'Cherry', '♀ Sisterly', 'Dog', 'May 11th', '"what what"', 'villager_Cherry.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (80, 'Chester', '♂ Lazy', 'Cub', 'August 6th', '"rookie"', 'villager_Chester.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (81, 'Chevre', '♀ Normal', 'Goat', 'March 6th', '"la baa"', 'villager_Chevre.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (82, 'Chief', '♂ Cranky', 'Wolf', 'December 19th', '"harrumph"', 'villager_Chief.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (83, 'Chops', '♂ Smug', 'Pig', 'October 13th', '"zoink"', 'villager_Chops.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (84, 'Chow', '♂ Cranky', 'Bear', 'July 22nd', '"aiya"', 'villager_Chow.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (85, 'Chrissy', '♀ Peppy', 'Rabbit', 'August 28th', '"sparkles"', 'villager_Chrissy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (86, 'Claude', '♂ Lazy', 'Rabbit', 'December 3rd', '"hopalong"', 'villager_Claude.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (87, 'Claudia', '♀ Snooty', 'Tiger', 'November 22nd', '"ooh la la"', 'villager_Claudia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (88, 'Clay', '♂ Lazy', 'Hamster', 'October 19th', '"thump"', 'villager_Clay.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (89, 'Cleo', '♀ Snooty', 'Horse', 'February 9th', '"sugar"', 'villager_Cleo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (90, 'Clyde', '♂ Lazy', 'Horse', 'May 1st', '"clip-clawp"', 'villager_Clyde.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (91, 'Coach', '♂ Jock', 'Bull', 'April 29th', '"stubble"', 'villager_Coach.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (92, 'Cobb', '♂ Jock', 'Pig', 'October 7th', '"hot dog"', 'villager_Cobb.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (93, 'Coco', '♀ Normal', 'Rabbit', 'March 1st', '"doyoing"', 'villager_Coco.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (94, 'Cole', '♂ Lazy', 'Rabbit', 'August 10th', '"duuude"', 'villager_Cole.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (95, 'Colton', '♂ Smug', 'Horse', 'May 22nd', '"check it"', 'villager_Colton.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (96, 'Cookie', '♀ Peppy', 'Dog', 'June 18th', '"arfer"', 'villager_Cookie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (97, 'Cousteau', '♂ Jock', 'Frog', 'December 17th', '"oui oui"', 'villager_Cousteau.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (98, 'Cranston', '♂ Lazy', 'Ostrich', 'September 23rd', '"sweatband"', 'villager_Cranston.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (99, 'Croque', '♂ Cranky', 'Frog', 'July 18th', '"as if"', 'villager_Croque.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (100, 'Cube', '♂ Lazy', 'Penguin', 'January 29th', '"d-d-dude"', 'villager_Cube.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (101, 'Curlos', '♂ Smug', 'Sheep', 'May 8th', '"shearly"', 'villager_Curlos.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (102, 'Curly', '♂ Jock', 'Pig', 'July 26th', '"nyoink"', 'villager_Curly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (103, 'Curt', '♂ Cranky', 'Bear', 'July 1st', '"fuzzball"', 'villager_Curt.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (104, 'Cyd', '♂ Cranky', 'Elephant', 'June 9th', '"rockin''"', 'villager_Cyd.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (105, 'Cyrano', '♂ Cranky', 'Anteater', 'March 9th', '"ah-CHOO"', 'villager_Cyrano.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (106, 'Daisy', '♀ Normal', 'Dog', 'November 16th', '"bow-WOW"', 'villager_Daisy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (107, 'Deena', '♀ Normal', 'Duck', 'June 27th', '"woowoo"', 'villager_Deena.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (108, 'Deirdre', '♀ Sisterly', 'Deer', 'May 4th', '"whatevs"', 'villager_Deirdre.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (109, 'Del', '♂ Cranky', 'Alligator', 'May 27th', '"gronk"', 'villager_Del.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (110, 'Deli', '♂ Lazy', 'Monkey', 'May 24th', '"monch"', 'villager_Deli.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (111, 'Derwin', '♂ Lazy', 'Duck', 'May 25th', '"derrrrr"', 'villager_Derwin.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (112, 'Diana', '♀ Snooty', 'Deer', 'January 4th', '"no doy"', 'villager_Diana.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (113, 'Diva', '♀ Sisterly', 'Frog', 'October 2nd', '"ya know"', 'villager_Diva.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (114, 'Dizzy', '♂ Lazy', 'Elephant', 'January 14th', '"woo-oo"', 'villager_Dizzy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (115, 'Dobie', '♂ Cranky', 'Wolf', 'February 17th', '"ohmmm"', 'villager_Dobie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (116, 'Doc', '♂ Lazy', 'Rabbit', 'March 16th', '"ol'' bunny"', 'villager_Doc.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (117, 'Dom', '♂ Jock', 'Sheep', 'March 18th', '"indeedaroo"', 'villager_Dom.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (118, 'Dora', '♀ Normal', 'Mouse', 'February 18th', '"squeaky"', 'villager_Dora.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (119, 'Dotty', '♀ Peppy', 'Rabbit', 'March 14th', '"wee one"', 'villager_Dotty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (120, 'Drago', '♂ Lazy', 'Alligator', 'February 12th', '"burrrn"', 'villager_Drago.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (121, 'Drake', '♂ Lazy', 'Duck', 'June 25th', '"quacko"', 'villager_Drake.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (122, 'Drift', '♂ Jock', 'Frog', 'October 9th', '"brah"', 'villager_Drift.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (123, 'Ed', '♂ Smug', 'Horse', 'September 16th', '"greenhorn"', 'villager_Ed.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (124, 'Egbert', '♂ Lazy', 'Chicken', 'October 14th', '"doodle-duh"', 'villager_Egbert.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (125, 'Elise', '♀ Snooty', 'Monkey', 'March 21st', '"puh-lease"', 'villager_Elise.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (126, 'Ellie', '♀ Normal', 'Elephant', 'May 12th', '"li''l one"', 'villager_Ellie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (127, 'Elmer', '♂ Lazy', 'Horse', 'October 5th', '"tenderfoot"', 'villager_Elmer.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (128, 'Eloise', '♀ Snooty', 'Elephant', 'December 8th', '"tooooot"', 'villager_Eloise.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (129, 'Elvis', '♂ Cranky', 'Lion', 'July 23rd', '"unh-hunh"', 'villager_Elvis.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (130, 'Erik', '♂ Lazy', 'Deer', 'July 27th', '"chow down"', 'villager_Erik.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (131, 'Eunice', '♀ Normal', 'Sheep', 'April 3rd', '"lambchop"', 'villager_Eunice.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (132, 'Eugene', '♂ Smug', 'Koala', 'October 26th', '"yeah buddy"', 'villager_Eugene.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (133, 'Fang', '♂ Cranky', 'Wolf', 'December 18th', '"cha-chomp"', 'villager_Fang.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (134, 'Fauna', '♀ Normal', 'Deer', 'March 26th', '"dearie"', 'villager_Fauna.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (135, 'Felicity', '♀ Peppy', 'Cat', 'March 30th', '"mimimi"', 'villager_Felicity.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (136, 'Filbert', '♂ Lazy', 'Squirrel', 'June 3rd', '"bucko"', 'villager_Filbert.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (137, 'Flip', '♂ Jock', 'Monkey', 'November 21st', '"rerack"', 'villager_Flip.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (138, 'Flo', '♀ Sisterly', 'Penguin', 'September 2nd', '"cha"', 'villager_Flo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (139, 'Flora', '♀ Peppy', 'Ostrich', 'February 9th', '"pinky"', 'villager_Flora.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (140, 'Flurry', '♀ Normal', 'Hamster', 'January 30th', '"powderpuff"', 'villager_Flurry.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (141, 'Francine', '♀ Snooty', 'Rabbit', 'January 22nd', '"karat"', 'villager_Francine.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (142, 'Frank', '♂ Cranky', 'Eagle', 'July 30th', '"crushy"', 'villager_Frank.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (143, 'Freckles', '♀ Peppy', 'Duck', 'February 19th', '"ducky"', 'villager_Freckles.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (144, 'Freya', '♀ Snooty', 'Wolf', 'December 14th', '"uff da"', 'villager_Freya.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (145, 'Friga', '♀ Snooty', 'Penguin', 'October 16th', '"brrmph"', 'villager_Friga.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (146, 'Frita', '♀ Sisterly', 'Sheep', 'July 16th', '"oh ewe"', 'villager_Frita.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (147, 'Frobert', '♂ Jock', 'Frog', 'February 8th', '"fribbit"', 'villager_Frobert.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (148, 'Fuchsia', '♀ Sisterly', 'Deer', 'September 19th', '"precious"', 'villager_Fuchsia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (149, 'Gabi', '♀ Peppy', 'Rabbit', 'December 16th', '"honeybun"', 'villager_Gabi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (150, 'Gala', '♀ Normal', 'Pig', 'March 5th', '"snortie"', 'villager_Gala.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (151, 'Gaston', '♂ Cranky', 'Rabbit', 'October 28th', '"mon chou"', 'villager_Gaston.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (152, 'Gayle', '♀ Normal', 'Alligator', 'May 17th', '"snacky"', 'villager_Gayle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (153, 'Genji', '♂ Jock', 'Rabbit', 'January 21st', '"mochi"', 'villager_Genji.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (154, 'Gigi', '♀ Snooty', 'Frog', 'August 11th', '"ribette"', 'villager_Gigi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (155, 'Gladys', '♀ Normal', 'Ostrich', 'January 15th', '"stretch"', 'villager_Gladys.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (156, 'Gloria', '♀ Snooty', 'Duck', 'August 12th', '"quacker"', 'villager_Gloria.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (157, 'Goldie', '♀ Normal', 'Dog', 'December 27th', '"woof"', 'villager_Goldie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (158, 'Gonzo', '♂ Cranky', 'Koala', 'October 13th', '"mate"', 'villager_Gonzo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (159, 'Goose', '♂ Jock', 'Chicken', 'October 4th', '"buh-kay"', 'villager_Goose.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (160, 'Graham', '♂ Smug', 'Hamster', 'June 20th', '"indeed"', 'villager_Graham.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (161, 'Greta', '♀ Snooty', 'Mouse', 'September 5th', '"yelp"', 'villager_Greta.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (162, 'Grizzly', '♂ Cranky', 'Bear', 'July 31st', '"grrr..."', 'villager_Grizzly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (163, 'Groucho', '♂ Cranky', 'Bear', 'October 23rd', '"grumble"', 'villager_Groucho.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (164, 'Gruff', '♂ Cranky', 'Goat', 'August 29th', '"bleh eh eh"', 'villager_Gruff.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (165, 'Gwen', '♀ Snooty', 'Penguin', 'January 23rd', '"h-h-hon"', 'villager_Gwen.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (166, 'Hamlet', '♂ Jock', 'Hamster', 'May 30th', '"hammie"', 'villager_Hamlet.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (167, 'Hamphrey', '♂ Cranky', 'Hamster', 'February 25th', '"snort"', 'villager_Hamphrey.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (168, 'Hans', '♂ Smug', 'Gorilla', 'December 5th', '"groovy"', 'villager_Hans.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (169, 'Harry', '♂ Cranky', 'Hippo', 'January 7th', '"beach bum"', 'villager_Harry.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (170, 'Hazel', '♀ Sisterly', 'Squirrel', 'August 30th', '"uni-wow"', 'villager_Hazel.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (171, 'Henry', '♂ Smug', 'Frog', 'September 21st', '"snoozit"', 'villager_Henry.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (172, 'Hippeux', '♂ Smug', 'Hippo', 'October 15th', '"natch"', 'villager_Hippeux.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (173, 'Hopkins', '♂ Lazy', 'Rabbit', 'March 11th', '"thumper"', 'villager_Hopkins.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (174, 'Hopper', '♂ Cranky', 'Penguin', 'April 6th', '"slushie"', 'villager_Hopper.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (175, 'Hornsby', '♂ Lazy', 'Rhino', 'March 20th', '"schnozzle"', 'villager_Hornsby.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (176, 'Huck', '♂ Smug', 'Frog', 'July 9th', '"hopper"', 'villager_Huck.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (177, 'Hugh', '♂ Lazy', 'Pig', 'December 30th', '"snortle"', 'villager_Hugh.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (178, 'Iggly', '♂ Jock', 'Penguin', 'November 2nd', '"waddler"', 'villager_Iggly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (179, 'Ike', '♂ Cranky', 'Bear', 'May 16th', '"roadie"', 'villager_Ike.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (180, 'JacobNAJakeyPAL', '♂ Lazy', 'Bird', 'August 24th', '"chuuuuurp"', 'villager_JacobNAJakeyPAL.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (181, 'Jacques', '♂ Smug', 'Bird', 'June 22nd', '"zut alors"', 'villager_Jacques.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (182, 'Jambette', '♀ Normal', 'Frog', 'October 27th', '"croak-kay"', 'villager_Jambette.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (183, 'Jay', '♂ Jock', 'Bird', 'July 17th', '"heeeeeyy"', 'villager_Jay.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (184, 'Jeremiah', '♂ Lazy', 'Frog', 'July 8th', '"nee-deep"', 'villager_Jeremiah.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (185, 'Jitters', '♂ Jock', 'Bird', 'February 2nd', '"bzzert"', 'villager_Jitters.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (186, 'Joey', '♂ Lazy', 'Duck', 'January 3rd', '"bleeeeeck"', 'villager_Joey.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (187, 'Judy', '♀ Snooty', 'Cub', 'March 10th', '"myohmy"', 'villager_Judy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (188, 'Julia', '♀ Snooty', 'Ostrich', 'July 31st', '"dahling"', 'villager_Julia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (189, 'Julian', '♂ Smug', 'Horse', 'March 15th', '"glitter"', 'villager_Julian.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (190, 'June', '♀ Normal', 'Cub', 'May 21st', '"rainbow"', 'villager_June.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (191, 'Kabuki', '♂ Cranky', 'Cat', 'November 29th', '"meooo-OH"', 'villager_Kabuki.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (192, 'Katt', '♀ Sisterly', 'Cat', 'April 27th', '"purrty"', 'villager_Katt.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (193, 'Keaton', '♂ Smug', 'Eagle', 'June 1st', '"wingo"', 'villager_Keaton.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (194, 'Ken', '♂ Smug', 'Chicken', 'December 23rd', '"no doubt"', 'villager_Ken.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (195, 'Ketchup', '♀ Peppy', 'Duck', 'July 27th', '"bitty"', 'villager_Ketchup.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (196, 'Kevin', '♂ Jock', 'Pig', 'April 26th', '"weeweewee"', 'villager_Kevin.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (197, 'Kid Cat', '♂ Jock', 'Cat', 'August 1st', '"psst"', 'villager_Kid_Cat.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (198, 'Kidd', '♂ Smug', 'Goat', 'June 28th', '"wut"', 'villager_Kidd.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (199, 'Kiki', '♀ Normal', 'Cat', 'October 8th', '"kitty cat"', 'villager_Kiki.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (200, 'Kitt', '♀ Normal', 'Kangaroo', 'October 11th', '"child"', 'villager_Kitt.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (201, 'Kitty', '♀ Snooty', 'Cat', 'February 15th', '"mrowrr"', 'villager_Kitty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (202, 'Klaus', '♂ Smug', 'Bear', 'March 31st', '"strudel"', 'villager_Klaus.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (203, 'Knox', '♂ Cranky', 'Chicken', 'November 23rd', '"cluckling"', 'villager_Knox.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (204, 'Kody', '♂ Jock', 'Cub', 'September 28th', '"grah-grah"', 'villager_Kody.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (205, 'Kyle', '♂ Smug', 'Wolf', 'December 6th', '"alpha"', 'villager_Kyle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (206, 'Leonardo', '♂ Jock', 'Tiger', 'May 15th', '"flexin"', 'villager_Leonardo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (207, 'Leopold', '♂ Smug', 'Lion', 'August 14th', '"lion cub"', 'villager_Leopold.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (208, 'Lily', '♀ Normal', 'Frog', 'February 4th', '"toady"', 'villager_Lily.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (209, 'Limberg', '♂ Cranky', 'Mouse', 'October 17th', '"squinky"', 'villager_Limberg.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (210, 'Lionel', '♂ Smug', 'Lion', 'July 29th', '"precisely"', 'villager_Lionel.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (211, 'Lobo', '♂ Cranky', 'Wolf', 'November 5th', '"ah-rooooo"', 'villager_Lobo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (212, 'Lolly', '♀ Normal', 'Cat', 'March 27th', '"bonbon"', 'villager_Lolly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (213, 'Lopez', '♂ Smug', 'Deer', 'August 20th', '"buckaroo"', 'villager_Lopez.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (214, 'Louie', '♂ Jock', 'Gorilla', 'March 26th', '"hoo hoo ha"', 'villager_Louie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (215, 'Lucha', '♂ Smug', 'Bird', 'December 12th', '"cacaw"', 'villager_Lucha.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (216, 'Lucky', '♂ Lazy', 'Dog', 'November 4th', '"rrr-owch"', 'villager_Lucky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (217, 'Lucy', '♀ Normal', 'Pig', 'June 2nd', '"snoooink"', 'villager_Lucy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (218, 'Lyman', '♂ Jock', 'Koala', 'October 12th', '"chips"', 'villager_Lyman.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (219, 'Mac', '♂ Jock', 'Dog', 'November 11th', '"woo woof"', 'villager_Mac.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (220, 'Maddie', '♀ Peppy', 'Dog', 'January 11th', '"yippee"', 'villager_Maddie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (221, 'Maelle', '♀ Snooty', 'Duck', 'April 8th', '"duckling"', 'villager_Maelle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (222, 'Maggie', '♀ Normal', 'Pig', 'September 3rd', '"schep"', 'villager_Maggie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (223, 'Mallary', '♀ Snooty', 'Duck', 'November 17th', '"quackpth"', 'villager_Mallary.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (224, 'Maple', '♀ Normal', 'Cub', 'June 15th', '"honey"', 'villager_Maple.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (225, 'Margie', '♀ Normal', 'Elephant', 'January 28th', '"tootie"', 'villager_Margie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (226, 'Marcel', '♂ Lazy', 'Dog', 'December 31st', '"non"', 'villager_Marcel.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (227, 'Marcie', '♀ Normal', 'Kangaroo', 'May 31st', '"pouches"', 'villager_Marcie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (228, 'Marina', '♀ Normal', 'Octopus', 'June 26th', '"blurp"', 'villager_Marina.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (229, 'Marshal', '♂ Smug', 'Squirrel', 'September 29th', '"sulky"', 'villager_Marshal.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (230, 'Mathilda', '♀ Snooty', 'Kangaroo', 'November 12th', '"wee baby"', 'villager_Mathilda.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (231, 'Megan', '♀ Normal', 'Bear', 'March 13th', '"sundae"', 'villager_Megan.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (232, 'Melba', '♀ Normal', 'Koala', 'April 12th', '"toasty"', 'villager_Melba.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (233, 'Merengue', '♀ Normal', 'Rhino', 'March 19th', '"shortcake"', 'villager_Merengue.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (234, 'Merry', '♀ Peppy', 'Cat', 'June 29th', '"mweee"', 'villager_Merry.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (235, 'Midge', '♀ Normal', 'Bird', 'March 12th', '"tweedledee"', 'villager_Midge.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (236, 'Mint', '♀ Snooty', 'Squirrel', 'May 2nd', '"ahhhhhh"', 'villager_Mint.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (237, 'Mira', '♀ Sisterly', 'Rabbit', 'July 6th', '"cottontail"', 'villager_Mira.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (238, 'Miranda', '♀ Snooty', 'Duck', 'April 23rd', '"quackulous"', 'villager_Miranda.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (239, 'Mitzi', '♀ Normal', 'Cat', 'September 25th', '"mew"', 'villager_Mitzi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (240, 'Moe', '♂ Lazy', 'Cat', 'January 12th', '"myawn"', 'villager_Moe.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (241, 'Molly', '♀ Normal', 'Duck', 'March 7th', '"quackidee"', 'villager_Molly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (242, 'Monique', '♀ Snooty', 'Cat', 'September 30th', '"pffffft"', 'villager_Monique.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (243, 'Monty', '♂ Cranky', 'Monkey', 'December 7th', '"g''tang"', 'villager_Monty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (244, 'Moose', '♂ Jock', 'Mouse', 'September 13th', '"shorty"', 'villager_Moose.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (245, 'Mott', '♂ Jock', 'Lion', 'July 10th', '"cagey"', 'villager_Mott.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (246, 'Muffy', '♀ Sisterly', 'Sheep', 'February 14th', '"nightshade"', 'villager_Muffy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (247, 'Murphy', '♂ Cranky', 'Cub', 'December 29th', '"laddie"', 'villager_Murphy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (248, 'Nan', '♀ Normal', 'Goat', 'August 24th', '"kid"', 'villager_Nan.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (249, 'Nana', '♀ Normal', 'Monkey', 'August 23rd', '"po po"', 'villager_Nana.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (250, 'Naomi', '♀ Snooty', 'Cow', 'February 28th', '"moolah"', 'villager_Naomi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (251, 'Nate', '♂ Lazy', 'Bear', 'August 16th', '"yawwwn"', 'villager_Nate.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (252, 'Nibbles', '♀ Peppy', 'Squirrel', 'July 19th', '"niblet"', 'villager_Nibbles.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (253, 'Norma', '♀ Normal', 'Cow', 'September 20th', '"hoof hoo"', 'villager_Norma.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (254, 'Octavian', '♂ Cranky', 'Octopus', 'September 20th', '"sucker"', 'villager_Octavian.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (255, 'O''Hare', '♂ Smug', 'Rabbit', 'July 24th', '"amigo"', 'villager_OHare.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (256, 'Olaf', '♂ Smug', 'Anteater', 'May 19th', '"whiffa"', 'villager_Olaf.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (257, 'Olive', '♀ Normal', 'Cub', 'July 12th', '"sweet pea"', 'villager_Olive.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (258, 'Olivia', '♀ Snooty', 'Cat', 'February 3rd', '"purrr"', 'villager_Olivia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (259, 'Opal', '♀ Snooty', 'Elephant', 'January 20th', '"snoot"', 'villager_Opal.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (260, 'Ozzie', '♂ Lazy', 'Koala', 'May 7th', '"ol'' bear"', 'villager_Ozzie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (261, 'Pancetti', '♀ Snooty', 'Pig', 'November 14th', '"sooey"', 'villager_Pancetti.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (262, 'Pango', '♀ Peppy', 'Anteater', 'November 9th', '"snooooof"', 'villager_Pango.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (263, 'Papi', '♂ Lazy', 'Horse', 'January 10th', '"haaay"', 'villager_Papi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (264, 'Paolo', '♂ Lazy', 'Elephant', 'May 5th', '"pal"', 'villager_Paolo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (265, 'Pashmina', '♀ Sisterly', 'Goat', 'December 26th', '"kidders"', 'villager_Pashmina.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (266, 'Pate', '♀ Peppy', 'Duck', 'February 23rd', '"quackle"', 'villager_Pate.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (267, 'Patty', '♀ Peppy', 'Cow', 'May 10th', '"how-now"', 'villager_Patty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (268, 'Paula', '♀ Sisterly', 'Bear', 'March 22nd', '"yodelay"', 'villager_Paula.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (269, 'Peaches', '♀ Normal', 'Horse', 'November 28th', '"neighbor"', 'villager_Peaches.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (270, 'Peanut', '♀ Peppy', 'Squirrel', 'June 8th', '"slacker"', 'villager_Peanut.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (271, 'Pecan', '♀ Snooty', 'Squirrel', 'September 10th', '"chipmunk"', 'villager_Pecan.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (272, 'Peck', '♂ Jock', 'Bird', 'July 25th', '"crunch"', 'villager_Peck.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (273, 'Peewee', '♂ Cranky', 'Gorilla', 'September 11th', '"li''l dude"', 'villager_Peewee.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (274, 'Peggy', '♀ Peppy', 'Pig', 'May 23rd', '"shweetie"', 'villager_Peggy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (275, 'Pekoe', '♀ Normal', 'Cub', 'May 18th', '"bud"', 'villager_Pekoe.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (276, 'Penelope', '♀ Peppy', 'Mouse', 'February 5th', '"oh bow"', 'villager_Penelope.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (277, 'Phil', '♂ Smug', 'Ostrich', 'November 27th', '"hurk"', 'villager_Phil.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (278, 'Phoebe', '♀ Sisterly', 'Ostrich', 'April 22nd', '"sparky"', 'villager_Phoebe.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (279, 'Pierce', '♂ Jock', 'Eagle', 'January 8th', '"hawkeye"', 'villager_Pierce.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (280, 'Pietro', '♂ Smug', 'Sheep', 'April 19th', '"honk honk"', 'villager_Pietro.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (281, 'Pinky', '♀ Peppy', 'Bear', 'September 9th', '"wah"', 'villager_Pinky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (282, 'Piper', '♀ Peppy', 'Bird', 'April 18th', '"chickadee"', 'villager_Piper.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (283, 'Pippy', '♀ Peppy', 'Rabbit', 'June 14th', '"li''l hare"', 'villager_Pippy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (284, 'Plucky', '♀ Sisterly', 'Chicken', 'October 12th', '"chicky-poo"', 'villager_Plucky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (285, 'Pompom', '♀ Peppy', 'Duck', 'February 11th', '"rah rah"', 'villager_Pompom.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (286, 'Poncho', '♂ Jock', 'Cub', 'January 2nd', '"li''l bear"', 'villager_Poncho.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (287, 'Poppy', '♀ Normal', 'Squirrel', 'August 5th', '"nutty"', 'villager_Poppy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (288, 'Portia', '♀ Snooty', 'Dog', 'October 25th', '"ruffian"', 'villager_Portia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (289, 'Prince', '♂ Lazy', 'Frog', 'July 21st', '"burrup"', 'villager_Prince.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (290, 'Puck', '♂ Lazy', 'Penguin', 'February 21st', '"brrrrrrrrr"', 'villager_Puck.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (291, 'Puddles', '♀ Peppy', 'Frog', 'January 13th', '"splish"', 'villager_Puddles.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (292, 'Pudge', '♂ Lazy', 'Cub', 'June 11th', '"pudgy"', 'villager_Pudge.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (293, 'Punchy', '♂ Lazy', 'Cat', 'April 11th', '"mrmpht"', 'villager_Punchy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (294, 'Purrl', '♀ Snooty', 'Cat', 'May 29th', '"kitten"', 'villager_Purrl.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (295, 'Queenie', '♀ Snooty', 'Ostrich', 'November 13th', '"chicken"', 'villager_Queenie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (296, 'Quillson', '♂ Smug', 'Duck', 'December 22nd', '"ridukulous"', 'villager_Quillson.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (297, 'Raddle', '♂ Lazy', 'Frog', 'June 6th', '"aaach-"', 'villager_Raddle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (298, 'Rasher', '♂ Cranky', 'Pig', 'April 7th', '"swine"', 'villager_Rasher.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (299, 'Raymond', '♂ Smug', 'Cat', 'October 1st', '"crisp"', 'villager_Raymond.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (300, 'Renée', '♀ Sisterly', 'Rhino', 'May 28th', '"yo yo yo"', 'villager_Renee.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (301, 'Reneigh', '♀ Sisterly', 'Horse', 'June 4th', '"ayup, yup"', 'villager_Reneigh.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (302, 'Rex', '♂ Lazy', 'Lion', 'July 24th', '"cool cat"', 'villager_Rex.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (303, 'Rhonda', '♀ Normal', 'Rhino', 'January 24th', '"bigfoot"', 'villager_Rhonda.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (304, 'Ribbot', '♂ Jock', 'Frog', 'February 13th', '"zzrrbbitt"', 'villager_Ribbot.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (305, 'Ricky', '♂ Cranky', 'Squirrel', 'September 14th', '"nutcase"', 'villager_Ricky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (306, 'Rizzo', '♂ Cranky', 'Mouse', 'January 17th', '"squee"', 'villager_Rizzo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (307, 'Roald', '♂ Jock', 'Penguin', 'January 5th', '"b-b-buddy"', 'villager_Roald.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (308, 'Robin', '♀ Snooty', 'Bird', 'December 4th', '"la-di-da"', 'villager_Robin.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (309, 'Rocco', '♂ Cranky', 'Hippo', 'August 18th', '"hippie"', 'villager_Rocco.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (310, 'Rocket', '♀ Sisterly', 'Gorilla', 'April 14th', '"vroom"', 'villager_Rocket.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (311, 'Rod', '♂ Jock', 'Mouse', 'August 14th', '"ace"', 'villager_Rod.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (312, 'Rodeo', '♂ Lazy', 'Bull', 'October 29th', '"chaps"', 'villager_Rodeo.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (313, 'Rodney', '♂ Smug', 'Hamster', 'November 10th', '"le ham"', 'villager_Rodney.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (314, 'Rolf', '♂ Cranky', 'Tiger', 'August 22nd', '"grrrolf"', 'villager_Rolf.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (315, 'Rooney', '♂ Cranky', 'Kangaroo', 'December 1st', '"punches"', 'villager_Rooney.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (316, 'Rory', '♂ Jock', 'Lion', 'August 7th', '"capital"', 'villager_Rory.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (317, 'Roscoe', '♂ Cranky', 'Horse', 'June 16th', '"nay"', 'villager_Roscoe.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (318, 'Rosie', '♀ Peppy', 'Cat', 'February 27th', '"silly"', 'villager_Rosie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (319, 'Rowan', '♂ Jock', 'Tiger', 'August 26th', '"mango"', 'villager_Rowan.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (320, 'Ruby', '♀ Peppy', 'Rabbit', 'December 25th', '"li''l ears"', 'villager_Ruby.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (321, 'Rudy', '♂ Jock', 'Cat', 'December 20th', '"mush"', 'villager_Rudy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (322, 'Sally', '♀ Normal', 'Squirrel', 'June 19th', '"nutmeg"', 'villager_Sally.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (323, 'Samson', '♂ Jock', 'Mouse', 'July 5th', '"pipsqueak"', 'villager_Samson.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (324, 'Sandy', '♀ Normal', 'Ostrich', 'October 21st', '"speedy"', 'villager_Sandy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (325, 'Savannah', '♀ Normal', 'Horse', 'January 25th', '"y''all"', 'villager_Savannah.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (326, 'Scoot', '♂ Jock', 'Duck', 'June 13th', '"zip zoom"', 'villager_Scoot.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (327, 'Shari', '♀ Sisterly', 'Monkey', 'April 10th', '"cheeky"', 'villager_Shari.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (328, 'Sheldon', '♂ Jock', 'Squirrel', 'February 26th', '"cardio"', 'villager_Sheldon.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (329, 'Shep', '♂ Smug', 'Dog', 'November 24th', '"baaa man"', 'villager_Shep.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (330, 'Sherb', '♂ Lazy', 'Goat', 'January 18th', '"bawwww"', 'villager_Sherb.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (331, 'Simon', '♂ Lazy', 'Monkey', 'January 19th', '"zzzook"', 'villager_Simon.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (332, 'Skye', '♀ Normal', 'Wolf', 'March 24th', '"airmail"', 'villager_Skye.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (333, 'Sly', '♂ Jock', 'Alligator', 'November 15th', '"hoo-rah"', 'villager_Sly.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (334, 'Snake', '♂ Jock', 'Rabbit', 'November 3rd', '"bunyip"', 'villager_Snake.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (335, 'Snooty', '♀ Snooty', 'Anteater', 'August 24th', '"snifffff"', 'villager_Snooty.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (336, 'Soleil', '♀ Snooty', 'Hamster', 'August 9th', '"tarnation"', 'villager_Soleil.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (337, 'Sparro', '♂ Jock', 'Bird', 'November 20th', '"like whoa"', 'villager_Sparro.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (338, 'Spike', '♂ Cranky', 'Rhino', 'June 17th', '"punk"', 'villager_Spike.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (339, 'Spork', '♂ Lazy', 'Pig', 'September 3rd', '"snork"', 'villager_SporkNACracklePAL.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (340, 'Sprinkle', '♀ Peppy', 'Penguin', 'February 20th', '"frappe"', 'villager_Sprinkle.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (341, 'Sprocket', '♂ Jock', 'Ostrich', 'December 1st', '"zort"', 'villager_Sprocket.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (342, 'Static', '♂ Cranky', 'Squirrel', 'July 9th', '"krzzt"', 'villager_Static.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (343, 'Stella', '♀ Normal', 'Sheep', 'April 9th', '"baa-dabing"', 'villager_Stella.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (344, 'Sterling', '♂ Jock', 'Eagle', 'December 11th', '"skraaaaw"', 'villager_Sterling.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (345, 'Stinky', '♂ Jock', 'Cat', 'August 17th', '"GAHHHH"', 'villager_Stinky.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (346, 'Stitches', '♂ Lazy', 'Cub', 'February 10th', '"stuffin''"', 'villager_Stitches.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (347, 'Stu', '♂ Lazy', 'Bull', 'April 20th', '"moo-dude"', 'villager_Stu.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (348, 'Sydney', '♀ Normal', 'Koala', 'June 21st', '"sunshine"', 'villager_Sydney.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (349, 'Sylvana', '♀ Normal', 'Squirrel', 'October 22nd', '"hubbub"', 'villager_Sylvana.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (350, 'Sylvia', '♀ Sisterly', 'Kangaroo', 'May 3rd', '"boing"', 'villager_Sylvia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (351, 'Tabby', '♀ Peppy', 'Cat', 'August 13th', '"me-WOW"', 'villager_Tabby.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (352, 'Tad', '♂ Jock', 'Frog', 'August 3rd', '"sluuuurp"', 'villager_Tad.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (353, 'Tammi', '♀ Peppy', 'Monkey', 'April 2nd', '"chimpy"', 'villager_Tammi.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (354, 'Tammy', '♀ Sisterly', 'Cub', 'June 23rd', '"ya heard"', 'villager_Tammy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (355, 'Tangy', '♀ Peppy', 'Cat', 'June 17th', '"reeeeOWR"', 'villager_Tangy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (356, 'Tank', '♂ Jock', 'Rhino', 'May 6th', '"kerPOW"', 'villager_Tank.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (357, 'T-Bone', '♂ Cranky', 'Bull', 'May 20th', '"moocher"', 'villager_T_Bone.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (358, 'Tasha', '♀ Snooty', 'Squirrel', 'November 30th', '"nice nice"', 'villager_Tasha.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (359, 'Teddy', '♂ Jock', 'Bear', 'September 26th', '"grooof"', 'villager_Teddy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (360, 'Tex', '♂ Smug', 'Penguin', 'October 6th', '"picante"', 'villager_Tex.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (361, 'Tia', '♀ Normal', 'Elephant', 'November 18th', '"teacup"', 'villager_Tia.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (362, 'Tiffany', '♀ Snooty', 'Rabbit', 'January 9th', '"bun bun"', 'villager_Tiffany.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (363, 'Timbra', '♀ Snooty', 'Sheep', 'October 21st', '"pine nut"', 'villager_Timbra.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (364, 'Tipper', '♀ Snooty', 'Cow', 'August 25th', '"pushy"', 'villager_Tipper.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (365, 'Tom', '♂ Cranky', 'Cat', 'December 10th', '"me-YOWZA"', 'villager_Tom.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (366, 'Truffles', '♀ Peppy', 'Pig', 'July 28th', '"snoutie"', 'villager_Truffles.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (367, 'Tucker', '♂ Lazy', 'Elephant', 'September 7th', '"fuzzers"', 'villager_Tucker.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (368, 'Tutu', '♀ Peppy', 'Bear', 'November 15th', '"twinkles"', 'villager_Tutu.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (369, 'Twiggy', '♀ Peppy', 'Bird', 'July 13th', '"cheepers"', 'villager_Twiggy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (370, 'Tybalt', '♂ Jock', 'Tiger', 'August 19th', '"grrRAH"', 'villager_Tybalt.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (371, 'Ursala', '♀ Sisterly', 'Bear', 'January 16th', '"grooomph"', 'villager_Ursala.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (372, 'Velma', '♀ Snooty', 'Goat', 'January 14th', '"blih"', 'villager_Velma.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (373, 'Vesta', '♀ Normal', 'Sheep', 'April 16th', '"baaaffo"', 'villager_Vesta.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (374, 'Vic', '♂ Cranky', 'Bull', 'December 29th', '"cud"', 'villager_Vic.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (375, 'Victoria', '♀ Peppy', 'Horse', 'July 11th', '"sugar cube"', 'villager_Victoria.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (376, 'Violet', '♀ Snooty', 'Gorilla', 'September 1st', '"sweetie"', 'villager_Violet.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (377, 'Vivian', '♀ Snooty', 'Wolf', 'January 26th', '"piffle"', 'villager_Vivian.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (378, 'Vladimir', '♂ Cranky', 'Cub', 'August 2nd', '"nyet"', 'villager_Vladimir.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (379, 'Wade', '♂ Lazy', 'Penguin', 'October 30th', '"so it goes"', 'villager_Wade.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (380, 'Walker', '♂ Lazy', 'Dog', 'June 10th', '"wuh"', 'villager_Walker.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (381, 'Walt', '♂ Cranky', 'Kangaroo', 'April 24th', '"pockets"', 'villager_Walt.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (382, 'Wart Jr.', '♂ Cranky', 'Frog', 'August 21st', '"grr-ribbit"', 'villager_Wart_Jr.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (383, 'Weber', '♂ Lazy', 'Duck', 'June 30th', '"quaa"', 'villager_Weber.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (384, 'Wendy', '♀ Peppy', 'Sheep', 'August 15th', '"lambkins"', 'villager_Wendy.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (385, 'Winnie', '♀ Peppy', 'Horse', 'January 31st', '"hay-OK"', 'villager_Winnie.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (386, 'Whitney', '♀ Snooty', 'Wolf', 'September 17th', '"snappy"', 'villager_Whitney.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (387, 'Willow', '♀ Snooty', 'Sheep', 'November 26th', '"bo peep"', 'villager_Willow.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (388, 'Wolfgang', '♂ Cranky', 'Wolf', 'November 25th', '"snarrrl"', 'villager_Wolfgang.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (389, 'Yuka', '♀ Snooty', 'Koala', 'July 20th', '"tsk tsk"', 'villager_Yuka.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (390, 'Zell', '♂ Smug', 'Deer', 'June 7th', '"pronk"', 'villager_Zell.png');
insert into villagers (ID, Name, Personality, Species, Birthday, Catchphrase, ImageName) VALUES (391, 'Zucker', '♂ Lazy', 'Octopus', 'March 8th', '"bloop"', 'villager_Zucker.png');

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

update critters set Rarity = 'Uncommon (★★★)' where ID = 136;
