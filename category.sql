drop table if exists categories;
create table temp_categories(
 business_id VARCHAR(23) DEFAULT NULL,
 category VARCHAR(255) DEFAULT NULL);

create table categories(category_id INT PRIMARY KEY auto_increment,
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
