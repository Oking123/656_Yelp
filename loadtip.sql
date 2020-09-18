drop table if exists tip;
create table tip (tip_id INT PRIMARY KEY auto_increment,user_id varchar(255),tip_text text,business_id varchar(255),compliment_count varchar(255), tip_date DATETIME);

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