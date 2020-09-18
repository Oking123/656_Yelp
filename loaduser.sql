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

