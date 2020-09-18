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