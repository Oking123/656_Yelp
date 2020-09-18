drop table if exists checkin;
create table checkin (business_id varchar(255), checkin_date longtext);

SET GLOBAL local_infile = 1;
LOAD DATA INFILE 'yelp_academic_dataset_checkin.csv' 
INTO TABLE checkin
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@checkin_date,@business_id) 
SET business_id = IF(@business_id ='',NULL,@business_id),
checkin_date = IF(@checkin_date ='',NULL,@checkin_date);

update checkin set business_id = replace(business_id,'--','');

ALTER TABLE checkin add CONSTRAINT checkin_pk PRIMARY KEY(business_id);	