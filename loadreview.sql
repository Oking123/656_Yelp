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




create user 'xuan'@'%' identified by '19941110';
create user 'ran'@'%' identified by '19980809'; 
grant all privileges on *.* to 'ran'@'%' with grant option;