# 656_Yelp
# Attention the server has been removed, the instructions may not take effect.
Simple social network:

Installation:
	pip3 install pymysql

Usage:
	python3 user_client.py


Login:
Then input the user_id(e.g. __0NoInkjvjBExSstL7_ww) and password(default:123456), then log in and the main menu can be seen as follows.

Menus:

1.Main menu

	------------MAIN------------
	0. Read newest posts
	1. Post
	2. Friend
	3. Group
	4. Topic
	5. Signout
	----------------------------

	Input the 0~5 to enter the submenus. Input 5 to end the client.

2.Read menu

	-------------READ-----------
	0. Post by friends and groups
	1. Post about followed topics
	2. Back
	----------------------------

	Input 0 to read the newest unread 10 reviews posted by friends or groups.
	Input 1 to read posts about followed topics.
	Input 2 to get back to main menu.

3.Compliment menu
	#0 r0xVcBmRzJOe5qvOFU7wAQ  TOPIC: Costa di Mare  2018-10-07 20:21:09 COMPLIMENT_COUNT:0

	REVIEW: Impeccable service and delicious fresh seafood! 

	......
	#9 r0xVcBmRzJOe5qvOFU7wAQ  TOPIC: Mona Van Joseph  2016-03-05 02:08:43 COMPLIMENT_COUNT:4
	----------------------------
	0. Compliment
	1. Next Page
	2. Back
	----------------------------

	Input 0 and the input the index in the 10 reviews(e.g. 0 for review#0), then choose the like or unlike to make compliment on review.
	Input 1 to see next page.
	Input 2 to get back to read menu.

4.Post menu

	------------POST------------
	0. Show my posts
	1. Post new review
	2. Post new tip
	3. Back
	----------------------------

	Input 0 to show all the reviews and tips post by user.
	Input 1 to post a new review with a business_id and review comment and rate the business.
	Input 2 to post a tip on a business_id.
	Input 3 to get back to main menu.

5.Friend menu

	-----------FRIEND-----------
	0. Show my friends
	1. add a friend
	2. delete a friend
	3. back to menu
	----------------------------

	Input 0~3 to manage the friend list by user_id.

6.Group menu

	-----------GROUP------------
	0. Show my groups
	1. Join a group
	2. Quit a group
	3. create a group
	4. Back
	----------------------------
	
	Input 0~4 to manange group list by group_id.

7.Topic menu

	-----------TOPIC------------
	0. Show my following topics
	1. Add a topic
	2. Delete a topic
	3. Back
	----------------------------
	
	Input 0~3 to manage topic list by topic_id(business_id e.g.__3qOwWFBUE8mdOToI7YrQ).



