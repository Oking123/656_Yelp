/*table user*/
drop table if exists user;
create table user(user_id varchar(255) PRIMARY KEY,
 name varchar(255),
 review_count Int,
 yelping_since DATETIME,
 friends longtext,
 useful Int,
 funny Int,
 cool Int,
 fans Int,
 elite varchar(255),
 average_stars FLOAT, 
 compliment_hot Int, 
 compliment_more Int, 
 compliment_profile Int, 
 compliment_cute Int, 
 compliment_list Int, 
 compliment_note Int, 
 compliment_plain Int, 
 compliment_cool Int, 
 compliment_funny Int, 
 compliment_writer Int, 
 compliment_photos Int);

/*table elite*/
drop table if exists user_elite;
create table user_elite(elite_index int PRIMARY KEY auto_increment, user_id varchar(255),elite varchar(5));

/*table time to set*/
drop table if exists user_time;
create table user_time (user_id varchar(255) PRIMARY KEY,
 friendtime datetime default '1000-01-01 00:00:00',
  topictime datetime default '1000-01-01 00:00:00');
alter table user_time add column friendlast datetime default '2100-01-01 00:00:00';
alter table user_time add column topiclast datetime default '2100-01-01 00:00:00';


/*table password*/
drop table if exists password;
create table password(user_id varchar(30) PRIMARY KEY, password varchar(30) default "123456");


/*table tip*/
drop table if exists tip;
create table tip (tip_id INT PRIMARY KEY auto_increment,
	user_id varchar(255),
	tip_text text,
	business_id varchar(255),
	compliment_count varchar(255),
	tip_date DATETIME);

/*table review*/
drop table if exists review;
create table review (review_id varchar(255) PRIMARY KEY, 
user_id varchar(255), 
business_id varchar(255), 
stars varchar(255), 
review_date varchar(255), 
review_text longtext, 
useful Int, 
funny Int, 
cool varchar(255));

/*table business*/
drop table if exists business;
create table business(
 business_id VARCHAR(255) NOT NULL PRIMARY KEY,
 name VARCHAR(255) DEFAULT NULL,
 address VARCHAR(255) DEFAULT NULL,
 city VARCHAR(255) DEFAULT NULL,
 state VARCHAR(255) DEFAULT NULL,
 postal_code VARCHAR(255) DEFAULT NULL,
 latitude FLOAT DEFAULT NULL,
 longitude FLOAT DEFAULT NULL,
 stars FLOAT DEFAULT NULL,
 review_count INT DEFAULT NULL,
 is_open INT DEFAULT NULL,
 attributes text DEFAULT NULL,
 categories text DEFAULT NULL,
 hours text DEFAULT NULL);

/*work hours of the business*/
drop table if exists business_hours;
create table business_hours(business_id varchar(255) PRIMARY KEY, Monday varchar(255),Tuesday varchar(255), Wednesday varchar(255),Thursday varchar(255),Friday varchar(255),Saturday varchar(255),Sunday varchar(255));


/*table categories*/
drop table if exists categories;
create table categories(category_id INT PRIMARY KEY auto_increment,
 business_id VARCHAR(23) DEFAULT NULL,
 category VARCHAR(255) DEFAULT NULL);


/*add friend relation*/
drop table if exists friend_list;
create table friend_list(friend_index Int PRIMARY KEY auto_increment,followed_id varchar (30),follower_id varchar (30));

drop table if exists group_join;
drop table if exists group_list;
create table group_list(
group_id int PRIMARY key auto_increment,
group_name VARCHAR(255) default null);


create table group_join(
join_id INT PRIMARY KEY auto_increment,
user_id VARCHAR(255) not null,
group_id INT not null);
ALTER table group_join add constraint fk_group foreign key(group_id) references group_list(group_id);
ALTER table group_join add constraint fk_user foreign key(user_id) references user(user_id);

drop table if exists follow_topic;
create table follow_topic(
follow_id int PRIMARY KEY auto_increment,
user_id VARCHAR(255) not null,
business_id VARCHAR(255) not null);
ALTER TABLE follow_topic ADD constraint fk_topic_on_user foreign key(user_id) references user(user_id);
ALTER table follow_topic add constraint fk_topic_on_business foreign key(business_id) references business(business_id);



