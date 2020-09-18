create table friendlist (user_id varchar(255) PRIMARY KEY, friend_list longtext);
insert into friendlist (select user_id,friends from user);
delete from friendlist where friend_list = 'None';
update friendlist set friend_list  = replace(friend_list,',','');


# build business_hour
create table hourlist (business_id varchar(255), hour_list varchar(255));
insert into hourlist (select business_id, hours from business);
update friendlist set friend_list  = replace(friend_list,'}','');
update friendlist set friend_list  = replace(friend_list,'{','');

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

drop table if exists user_elite;
create table user_elite(elite_index int PRIMARY KEY auto_increment, user_id varchar(255),elite varchar(5));
insert into user_elite (user_id,elite)(select user_id, elite from tempelite);

drop table elitelist;
drop table tempelite;
alter table user drop column elite;

alter table user_elite add constraint elite_ref_user FOREIGN KEY (user_id) references user(user_id);



alter table tip add constraint tip_ref_bus FOREIGN KEY  (business_id) references  business(business_id);
alter table tip add constraint tip_ref_user FOREIGN KEY  (user_id) references  user(user_id);

alter table review add constraint review_ref_bus FOREIGN KEY  (business_id) references  business(business_id);
alter table review add constraint review_ref_user FOREIGN KEY  (user_id) references  user(user_id);

drop table if exists user_time;
create table user_time (user_id varchar(255) PRIMARY KEY, friendtime datetime default '1000-01-01 00:00:00', topictime datetime default '1000-01-01 00:00:00');
insert into user_time (user_id)(select user_id from user);
alter table user_time add constraint time_ref_user FOREIGN KEY (user_id) references user(user_id);

alter table user_time drop column friendtime;
alter table user_time add column friendtime datetime default '1000-01-01 00:00:00';

alter table user_time drop column topictime;
alter table user_time add column topictime datetime default '1000-01-01 00:00:00';

alter table user_time add column friendlast datetime default '2100-01-01 00:00:00';
alter table user_time drop column friendlast;

alter table user_time add column topiclast datetime default '2100-01-01 00:00:00';
alter table user_time drop column topiclast;


 