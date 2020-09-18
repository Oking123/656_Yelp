/*load user*/

LOAD DATA INFILE 'yelp_academic_dataset_user.csv' 
INTO TABLE user
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@yelping_since,@useful,@compliment_photos,@compliment_list,@compliment_funny,@compliment_plain,@review_count,@friends,@fans,@compliment_note,@funny,@compliment_writer,@compliment_cute,@average_stars,@user_id,@compliment_more,@elite,@compliment_hot,@cool,@name,@compliment_profile,@compliment_cool) 
SET user_id = IF(@user_id ='',NULL,@user_id),
name = IF(@name ='',NULL,@name),
review_count = IF(@review_count ='',NULL,@review_count),
yelping_since = IF(@yelping_since ='',NULL,@yelping_since),
friends  = IF(@friends  ='',NULL,@friends),
useful = IF(@useful ='',NULL,@useful),
funny = IF(@funny ='',NULL,@funny),
cool = IF(@cool ='',NULL,@cool),
fans  = IF(@fans  ='',NULL,@fans),
elite = IF(@elite ='',NULL,@elite),
average_stars = IF(@average_stars  ='',NULL,@average_stars),
compliment_hot = IF(@compliment_hot ='',NULL,@compliment_hot),
compliment_more = IF(@compliment_more ='',NULL,@compliment_more),
compliment_profile = IF(@compliment_profile ='',NULL,@compliment_profile),
compliment_cute = IF(@compliment_cute ='',NULL,@compliment_cute),
compliment_list = IF(@compliment_list ='',NULL,@compliment_list),
compliment_note = IF(@compliment_note ='',NULL,@compliment_note),
compliment_plain = IF(@compliment_plain='',NULL,@compliment_plain),
compliment_cool = IF(@compliment_cool ='',NULL,@compliment_cool),
compliment_funny = IF(@compliment_funny ='',NULL,@compliment_funny),
compliment_writer = IF(@compliment_writer ='',NULL,@compliment_writer),
compliment_photos = IF(@compliment_photos ='',NULL,@compliment_photos);


/*load review*/
LOAD DATA INFILE 'yelp_academic_dataset_review.csv' 
INTO TABLE review
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@funny,@useful,@review_id,@review_text,@business_id,@stars,@review_date,@user_id,@cool) 
SET review_id = IF(@review_id ='',NULL,@review_id),
user_id= IF(@user_id ='',NULL,@user_id),
business_id= IF(@business_id ='',NULL,@business_id),
stars= IF(@stars ='',NULL,@stars),
review_date= IF(@review_date ='',NULL,@review_date),
review_text= IF(@review_text ='',NULL,@review_text),
useful= IF(@useful ='',NULL,@useful),
funny= IF(@funny ='',NULL,@funny),
cool= IF(@cool ='',NULL,@cool);


/*load business*/
LOAD DATA INFILE 'yelp_academic_dataset_business.csv' 
INTO TABLE business
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@business_id,@name,@address,@city,@state,@postal_code,@latitude,@longitude,@stars,@review_count,@is_open,@attributes,@categories,@hours) 
SET business_id = IF(@business_id ='',"233",@business_id),
name = IF(@name ='',NULL,@name),
address = IF(@address ='',NULL,@address),
city = IF(@city ='',NULL,@city),
state = IF(@state ='',NULL,@state),
postal_code = IF(@postal_code ='',NULL,@postal_code),
latitude = IF(@latitude ='',NULL,@latitude),
longitude = IF(@longitude ='',NULL,@longitude),
stars = IF(@stars ='',NULL,@stars),
review_count = IF(@review_count ='',NULL,@review_count),
is_open = IF(@is_open ='',NULL,@is_open),
attributes = IF(@attributes ='',NULL,@attributes),
categories = IF(@categories ='',NULL,@categories),
hours = IF(@hours ='',NULL,@hours);

alter table business drop column attributes;

/*load tip*/
SET GLOBAL local_infile = 1;
LOAD DATA INFILE 'yelp_academic_dataset_tip.csv' 
INTO TABLE tip
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@user_id,@tip_text,@business_id,@compliment_count,@tip_date) 
SET user_id = IF(@user_id ='',NULL,@user_id),
tip_text = IF(@tip_text ='',NULL,@tip_text),
business_id= IF(@business_id ='',NULL,@business_id),
compliment_count = IF(@compliment_count ='',NULL,@compliment_count),
tip_date = IF(@tip_date ='',NULL,@tip_date);

delete from tip where length(compliment_count) > 2;

/*build friend_list*/
SET GLOBAL local_infile = 1;
LOAD DATA INFILE 'friend_list_py.csv' 
INTO TABLE friend_list
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@followed_id,@follower_id)
SET followed_id = IF(@followed_id ='',null,@followed_id),
follower_id = IF(@follower_id ='',NULL,@follower_id);

delete from friend_list where follower_id not in (select user_id from user);

create index friend_index on friend_list(followed_id);

ALTER TABLE user DROP column friends;

/*add fk on review*/

create index review_index on review(user_id);
create index review_index_on_business on review(business_id);

delete from review where review.user_id not in (select user_id from user) or review.business_id not in (select business_id from business);

ALTER TABLE review ADD constraint fk_review_on_user foreign key(user_id) references user(user_id);
alter table review add constraint fk_review_on_business foreign key(user_id) references business(business_id);

/*add fk on tip*/
delete from tip where tip.user_id not in (select user_id from user);
delete from tip where tip.business_id not in (select business_id from business);

ALTER TABLE tip ADD constraint fk_tip_on_user foreign key(user_id) references user(user_id);
alter table tip add constraint fk_tip_on_business foreign key(user_id) references business(business_id);


/*set password*/
insert INTO password(user_id)
	select user_id from user;


# build business_hour
drop table if exists hourlist;
create table hourlist (business_id varchar(255), hour_list varchar(255));
insert into hourlist (select business_id, hours from business);
update hourlist set hour_list = replace(hour_list,'}','');
update hourlist set hour_list  = replace(hour_list,'{','');

drop table if exists temphours;
create table temphours (business_index int PRIMARY KEY auto_increment, business_id varchar(255), business varchar(255));


insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=0,substring_index(substring_index(hour_list,',',1),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=1,substring_index(substring_index(hour_list,',',2),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=2,substring_index(substring_index(hour_list,',',3),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=3,substring_index(substring_index(hour_list,',',4),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=4,substring_index(substring_index(hour_list,',',5),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=5,substring_index(substring_index(hour_list,',',6),',',-1),NULL) from hourlist);
insert into temphours(business_id,business)(select business_id, IF((select length(hour_list) - length(replace(hour_list,',','')))>=6,substring_index(substring_index(hour_list,',',7),',',-1),NULL) from hourlist);

drop table if exists hours;
create table hours (business_id varchar(255) PRIMARY KEY);
insert into hours (business_id)(select business_id from business);

drop table if exists tempMon;
create table tempMon (business_id varchar(255) PRIMARY KEY, Monday varchar(255));
insert into tempMon(select business_id, business from temphours where substring(business,3,1) = 'o');

drop table if exists tempTues;
create table tempTues (business_id varchar(255) PRIMARY KEY, Tuesday varchar(255));
insert into tempTues(select business_id, business from temphours where substring(business,3,2) = 'ue');

drop table if exists tempWed;
create table tempWed (business_id varchar(255) PRIMARY KEY, Wednesday varchar(255));
insert into tempWed (select business_id, business from temphours where substring(business,3,2) = 'ed');

drop table if exists tempThur;
create table tempThur (business_id varchar(255) PRIMARY KEY, Thursday varchar(255));
insert into tempThur(select business_id, business from temphours where substring(business,3,2) = 'hu');

drop table if exists tempFri;
create table tempFri (business_id varchar(255) PRIMARY KEY, Friday varchar(255));
insert into tempFri(select business_id, business from temphours where substring(business,3,1) = 'r');

drop table if exists tempSat;
create table tempSat (business_id varchar(255) PRIMARY KEY, Saturday varchar(255));
insert into tempSat (select business_id, business from temphours where substring(business,3,2) = 'at');

drop table if exists tempSun;
create table tempSun (business_id varchar(255) PRIMARY KEY, Sunday varchar(255));
insert into tempSun (select business_id, business from temphours where substring(business,3,2) = 'un');

drop table if exists Mon;
create table Mon (business_id varchar(255) PRIMARY KEY, Monday varchar(255));
insert into Mon (select hours.business_id, tempMon.Monday from hours left join tempMon on hours.business_id = tempMon.business_id);

drop table if exists Tuesday;
create table Tuesday(business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255));
insert into Tuesday(select Mon.business_id, Mon.Monday, tempTues.Tuesday from Mon left join tempTues on Mon.business_id = tempTues.business_id);

drop table if exists Wednesday;
create table Wednesday (business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255));
insert into Wednesday(select Tuesday.business_id, Tuesday.Monday, Tuesday.Tuesday, tempWed.Wednesday from Tuesday left join tempWed on Tuesday.business_id = tempWed.business_id);

drop table if exists Thursday;
create table Thursday (business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255),Thursday varchar(255));
insert into Thursday(select Wednesday.business_id,Wednesday.Monday,Wednesday.Tuesday,Wednesday.Wednesday, tempThur.Thursday from Wednesday left join tempThur on Wednesday.business_id = tempThur.business_id);

drop table if exists Friday;
create table Friday(business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255),Thursday varchar(255),Friday varchar(255));
insert into Friday(select Thursday.business_id,Thursday.Monday,Thursday.Tuesday,Thursday.Wednesday,Thursday.Thursday,tempFri.Friday from Thursday left join tempFri on Thursday.business_id = tempFri.business_id);

drop table if exists Saturday;
create table Saturday(business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255),Thursday varchar(255),Friday varchar(255),Saturday varchar(255));
insert into Saturday (select Friday.business_id, Friday.Monday, Friday.Tuesday,Friday.Wednesday,Friday.Thursday,Friday.Friday,tempSat.Saturday from Friday left join tempSat on Friday.business_id = tempSat.business_id);


drop table if exists business_hours;
create table business_hours(business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255),Thursday varchar(255),Friday varchar(255),Saturday varchar(255),Sunday varchar(255));
insert into business_hours(select Saturday.business_id,Saturday.Monday,Saturday.Tuesday,Saturday.Wednesday,Saturday.Thursday,Saturday.Friday,Saturday.Saturday,tempSun.Sunday from Saturday left join tempSun on Saturday.business_id = tempSun.business_id);


update business_hours set Monday = replace(Monday,'\"Monday\":','');
update business_hours set Tuesday = replace(Tuesday,'\"Tuesday\":','');
update business_hours set Wednesday = replace(Wednesday,'\"Wednesday\":','');
update business_hours set Thursday = replace(Thursday,'\"Thursday\":','');
update business_hours set Friday = replace(Friday,'\"Friday\":','');
update business_hours set Saturday = replace(Saturday,'\"Saturday\":','');
update business_hours set Sunday = replace(Sunday,'\"Sunday\":','');

drop table hourlist;
drop table temphours;
drop table hours;
drop table tempMon;
drop table tempTues;
drop table tempWed;
drop table tempThur;
drop table tempFri;
drop table tempSat;
drop table tempSun;
drop table Mon;
drop table Tuesday;
drop table Wednesday;
drop table Thursday;
drop table Friday;
drop table Saturday;

alter table business drop column hours;

alter table business_hours add constraint hours_ref_business FOREIGN KEY (business_id) references business(business_id);

# build user_elite
drop table if exists elitelist;
create table elitelist (user_id varchar(255) PRIMARY KEY, elite_list varchar(255));
insert into elitelist(user_id,elite_list)(select user_id,elite from user);
delete from elitelist where elite_list is NULL;


drop table if exists tempelite;
create table tempelite (user_index int PRIMARY KEY auto_increment,user_id varchar(255), elite varchar(5));
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=0, substring_index(substring_index(elite_list,',',1),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=1, substring_index(substring_index(elite_list,',',2),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=2, substring_index(substring_index(elite_list,',',3),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=3, substring_index(substring_index(elite_list,',',4),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=4, substring_index(substring_index(elite_list,',',5),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=5, substring_index(substring_index(elite_list,',',6),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=6, substring_index(substring_index(elite_list,',',7),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=7, substring_index(substring_index(elite_list,',',8),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=8, substring_index(substring_index(elite_list,',',9),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=9, substring_index(substring_index(elite_list,',',10),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=10, substring_index(substring_index(elite_list,',',11),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=11, substring_index(substring_index(elite_list,',',12),',',-1 ),NULL) from elitelist);
insert into tempelite (user_id,elite)(select user_id, IF((select length(elite_list)-length(replace(elite_list,',','')))>=12, substring_index(substring_index(elite_list,',',13),',',-1 ),NULL) from elitelist);
delete from tempelite where elite is NULL;

insert into user_elite (user_id,elite)(select user_id, elite from tempelite);

drop table elitelist;
drop table tempelite;
alter table user drop column elite;

alter table user_elite add constraint elite_ref_user FOREIGN KEY (user_id) references user(user_id);


/*user_time*/
insert into user_time (user_id)(select user_id from user);
alter table user_time add constraint time_ref_user FOREIGN KEY (user_id) references user(user_id);



alter table tip add constraint tip_ref_bus FOREIGN KEY  (business_id) references  business(business_id);
alter table tip add constraint tip_ref_user FOREIGN KEY  (user_id) references  user(user_id);

alter table review add constraint review_ref_bus FOREIGN KEY  (business_id) references  business(business_id);
alter table review add constraint review_ref_user FOREIGN KEY  (user_id) references  user(user_id);


/*build category*/
drop table if exists temp_categories;
create table temp_categories(
 business_id VARCHAR(23) DEFAULT NULL,
 category VARCHAR(255) DEFAULT NULL);
 insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=0,substring_index(substring_index(categories, ', ',1),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=1,substring_index(substring_index(categories, ', ',2),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=2,substring_index(substring_index(categories, ', ',3),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=3,substring_index(substring_index(categories, ', ',4),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=4,substring_index(substring_index(categories, ', ',5),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=5,substring_index(substring_index(categories, ', ',6),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=6,substring_index(substring_index(categories, ', ',7),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=7,substring_index(substring_index(categories, ', ',8),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=8,substring_index(substring_index(categories, ', ',9),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=9,substring_index(substring_index(categories, ', ',10),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=10,substring_index(substring_index(categories, ', ',11),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=11,substring_index(substring_index(categories, ', ',12),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=12,substring_index(substring_index(categories, ', ',13),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=13,substring_index(substring_index(categories, ', ',14),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=14,substring_index(substring_index(categories, ', ',15),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=15,substring_index(substring_index(categories, ', ',16),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=16,substring_index(substring_index(categories, ', ',17),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=17,substring_index(substring_index(categories, ', ',18),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=18,substring_index(substring_index(categories, ', ',19),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=19,substring_index(substring_index(categories, ', ',20),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=20,substring_index(substring_index(categories, ', ',21),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=21,substring_index(substring_index(categories, ', ',22),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=22,substring_index(substring_index(categories, ', ',23),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=23,substring_index(substring_index(categories, ', ',24),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=24,substring_index(substring_index(categories, ', ',25),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=25,substring_index(substring_index(categories, ', ',26),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=26,substring_index(substring_index(categories, ', ',27),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=27,substring_index(substring_index(categories, ', ',28),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=28,substring_index(substring_index(categories, ', ',29),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=29,substring_index(substring_index(categories, ', ',30),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=30,substring_index(substring_index(categories, ', ',31),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=31,substring_index(substring_index(categories, ', ',32),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=32,substring_index(substring_index(categories, ', ',33),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=33,substring_index(substring_index(categories, ', ',34),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=34,substring_index(substring_index(categories, ', ',35),', ',-1),NULL) from business;
insert into temp_categories(business_id, category)
select business_id, IF((length(categories) - length(replace(categories,',','')))>=35,substring_index(substring_index(categories, ', ',36),', ',-1),NULL) from business;
delete from temp_categories where category is NUll;
insert into categories(business_id, category)
select * from temp_categories order by business_id;
drop table temp_categories;
alter table business drop column categories;
