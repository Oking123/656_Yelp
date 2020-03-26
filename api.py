import sys
import time
import pymysql
import hashlib

db = pymysql.connect("155.138.138.104","xuan","19941110","yelp")
cursor = db.cursor()

class UI:
    user_id = ''
    def check_password(self):
        for i in range(3):
            print("Please input your account number:")
            account = input("")
            cursor.execute('select password from password where user_id= "{}";'.format(account))
            results = cursor.fetchone()
            if not results:
                print("Account does not exist.")
                continue
            else:
                results = results[0]
                for i in range(3):
                    password = input("Password:")
                    if password != results:
                        print("Wrong password.")
                        continue
                    else:
                        print("Hello, {}".format(account))
                        self.user_id = account
                        self.main_menu()
                        break
                break

    def main_menu(self):
        while True:
            print("0. Read newest posts")
            print("1. Post")
            print("2. Friend")
            print("3. Group")
            print("4. Topic")
            print("5. Signout")
            option = input("")
            if option == '0':
                self.read_post()
            elif option == '1':
                self.post_menu()
            elif option == '2':
                self.add_friend()
            elif option == '3':
                self.group_menu()
            elif option == '4':
                self.topic_menu()
            elif option == '5':
                return
            else:
                print("Error: wrong command", file=sys.stderr)


    def group_menu(self):
        while True:
            print("0. Show my groups")
            print("1. Join a group")
            print("2. Quit a group")
            print("3. Back")
            option = input("")
            if option == '0':
                cursor.execute("select group_name, group_list.group_id from group_join inner join group_list on group_list.group_id=group_join.group_id where user_id = '{}';".format(self.user_id))
                results = cursor.fetchall()
                for result in results:
                    print(result[1], result[0])
            elif option == '1':
                group_id = input("Join group_ID:")
                self.join_group(group_id)
            elif option == '2':
                group_id = input("Quit group_ID:")
                self.quit_group(group_id)
            elif option == '3':
                return
            else:
                print("Error: wrong command.", file=sys.stderr)


    def topic_menu(self):
        while True:
            print("0. Show my following topics")
            print("1. Add a topic")
            print("2. Delete a topic")
            print("3. Back")
            option = input("")
            if option == '0':
                cursor.execute("select business.business_id, name from follow_topic inner join business on follow_topic.business_id= business.business_id where user_id = '{}'".format(self.user_id))
                results = cursor.fetchall()
                for result in results:
                    print(result[0],result[1])
            elif option == '1':
                cursor.execute("select business_id from follow_topic where user_id = '{}'".format(self.user_id))
                results = cursor.fetchall()
                topics = []
                for result in results:
                    topics.append(str(result[0]))
                addtopic = input("topic_id:")
                if addtopic in topics:
                    print("Error: Already follows.", file=sys.stderr)
                    continue
                self.follow_topic(addtopic)
                continue
            elif option == '2':
                cursor.execute("select business_id from follow_topic where user_id = '{}'".format(self.user_id))
                results = cursor.fetchall()
                topics = []
                for result in results:
                    topics.append(str(result[0]))
                delete_topic = input("delete_topic_id:")
                if delete_topic not in topics:
                    print("Error: can not delete", file=sys.stderr)
                    continue
                self.unfollow_topic(delete_topic)
                continue
            elif option == '3':
                return
            else:
                print("Error: wrong command", file = sys.stderr)

    def post_menu(self):
        while True:
            print("0. Show my posts")
            print("1. Post new review")
            print("2. Post new tip")
            print("3. Back")
            option = input("")
            if option == '0':
                self.mypost()
            elif option == '1':
                business_id = input("Target topic:")
                comment = input("Comment:")
                rate = input("Rate:")
                self.post_review(comment,business_id,rate)
            elif option == '2':
                business_id = input("Target topic:")
                comment = input("Comment:")
                self.post_tip(comment,business_id)
            elif option == '3':
                return
            else:
                print("Error: wrong command", file=sys.stderr)

    def set_userid(self, user_id):
        self.user_id = user_id

    def read_post(self):
        while True:
            print('0. Friend and Group')
            print('1. Topic')
            print('2. Back')
            option = input('')
            if option == '0':
                self.read_post_friend()
            elif option == '1':
                self.read_post_topic()
            elif option == '2':
                return
            else:
                print("Error: wrong command", file=sys.stderr)

    def read_post_friend(self):
        post = []
        # select friends from friend_list
        cursor.execute('select follower_id from friend_list where followed_id = "{}" ;'.format(self.user_id))
        results = cursor.fetchall()
        # select friends from group
        cursor.execute('select user_id from (select user_id from group_join where group_id in (select group_id from group_join where user_id = "{}")) as A where user_id !="{}";'.format(self.user_id,self.user_id))
        group_result = cursor.fetchall()
        friend_list = []
        if results:
            for friend in results:
                friend_list.append(friend[0])
        if group_result:
            for friend in group_result:
                friend_list.append(friend[0])
        friend_list = list(set(friend_list))
        # select refresh time from user
        cursor.execute('select friendtime from user_time where user_id = "{}"'.format(self.user_id))
        refresh_time = str(cursor.fetchone()[0])
        # select reviews and tips
        for item in friend_list:
            cursor.execute('select user_id,review_date,name,review_text from ((select user_id, business_id, review_date,review_text from review where user_id = "{}") as A inner join (select business_id,name from business) as B on A.business_id = B.business_id);'.format(item))
            results = cursor.fetchall()
            if results:
                for review in results:
                    temp=(review[0],str(review[1]),'review',review[2],review[3])
                    post.append(temp)
        for item in friend_list:
            cursor.execute('select user_id,tip_date,name,tip_text from ((select user_id, business_id, tip_date,tip_text from tip where user_id = "{}") as A inner join (select business_id,name from business) as B on A.business_id = B.business_id);'.format(item))
            results = cursor.fetchall()
            if results:
                for tip in results:
                    temp=(tip[0],str(tip[1]),'tip',tip[2],tip[3])
                    post.append(temp)
        post = list(set(post))
        post.sort(key = lambda i:i[1])
        for item in post:
            if item[1] > refresh_time:
                print(item[0],item[1],item[2],item[3])
                print('')
                print(item[4])
                print('')
        # change the time in table user into current time
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        cursor.execute('update user_time set friendtime = "{}"where user_id = "{}"'.format(current_time,self.user_id))
        db.commit()

    def read_post_topic(self):
        post = []
        # select followed_topic
        cursor.execute('select business_id from follow_topic where user_id = "{}"'.format(self.user_id))
        topic = cursor.fetchall()
        topic_id = []
        if topic:
            for id in topic:
                topic_id.append(id[0])
        topic_id = list(set(topic_id))

        # select refresh time
        cursor.execute('select topictime from user_time where user_id  = "{}"'.format(self.user_id))
        refresh_time = str(cursor.fetchone()[0])

        # selec reviews and tips
        for item in topic_id:
            cursor.execute(
                'select user_id, business_id, review_date,review_text from review where business_id = "{}";'.format(
                    item))
            result1 = cursor.fetchall()
            cursor.execute('select name from business where business_id = "{}"'.format(item))
            result2 = cursor.fetchone()[0]
            if result1 and result2:
                for review in result1:
                    temp = (review[0], str(review[2]), 'review', result2, review[3])
                    post.append(temp)
        for item in topic_id:
            cursor.execute(
                'select user_id, business_id, tip_date,tip_text from tip where business_id = "{}";'.format(item))
            result1 = cursor.fetchall()
            cursor.execute('select name from business where business_id = "{}"'.format(item))
            result2 = cursor.fetchone()[0]
            if result1 and result2:
                for tip in result1:
                    temp = (tip[0], str(tip[2]), 'tip', result2, tip[3])
                    post.append(temp)
        post = list(set(post))
        post.sort(key=lambda i: i[1])
        for item in post:
            if item[1] > refresh_time:
                print(item[0], item[1], item[2], item[3])
                print('')
                print(item[4])
                print('')
        # change the time in table user into current time
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        cursor.execute('update user_time set topictime = "{}"where user_id = "{}"'.format(current_time, self.user_id))
        db.commit()

    def mypost(self):
        mypost = []
        cursor.execute(
            'select user_id,review_date,name,review_text from ((select user_id, business_id, review_date,review_text from review where user_id = "{}") as A inner join (select business_id,name from business) as B on A.business_id = B.business_id);'.format(
                self.user_id))
        result1 = cursor.fetchall()
        if result1:
            for review in result1:
                temp = (review[0], str(review[1]), 'review', review[2], review[3])
                mypost.append(temp)
        cursor.execute(
            'select user_id,tip_date,name,tip_text from ((select user_id, business_id, tip_date,tip_text from tip where user_id = "{}") as A inner join (select business_id,name from business) as B on A.business_id = B.business_id);'.format(
                self.user_id))
        result2 = cursor.fetchall()
        if result2:
            for tip in result2:
                temp = (tip[0], str(tip[1]), 'tip', tip[2], tip[3])
                mypost.append(temp)
        mypost = list(set(mypost))
        mypost.sort(key=lambda i: i[1])
        for item in mypost:
            print(item[0], item[1], item[2], item[3])
            print('')
            print(item[4])
            print('')

    def post_review(self,comment,business_id,rate):
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        temp = business_id + self.user_id + current_time
        comment_id = hashlib.sha3_256(temp.encode('utf-8')).hexdigest()[:22]
        rate = round(float(rate),1)
        try:
            cursor.execute("insert into review value('{}','{}','{}','{}','{}','{}',0,0,0)".format(comment_id,self.user_id,business_id,rate,current_time,comment))
        except pymysql.err.IntegrityError:
            print("Error: unexpected business_id", file=sys.stderr)
            return -1
        db.commit()
        return 1

        pass

    def post_tip(self,comment,business_id):
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        try:
            cursor.execute("insert into tip(user_id,tip_text ,business_id,compliment_count, tip_date) value('{}','{}','{}',0,'{}')".format(self.user_id,comment,business_id,current_time))
        except pymysql.err.IntegrityError:
            print("Error: unexpected business_id", file=sys.stderr)
            return -1
        db.commit()
        return 1

    def add_friend(self):
        while True:
            print('0. Show my friends')
            print('1. add a friend')
            print('2. delete a friend')
            print('3. back to menu')
            option = input("")
            cursor.execute("select follower_id from friend_list where followed_id = '{}';".format(self.user_id))
            friends = cursor.fetchall()
            friend_list = []
            for friend in friends:
                friend_list.append(friend[0])
            if option == '0':
                for friend in friend_list:
                    cursor.execute("select user_id,name from user where user_id = '{}';".format(friend))
                    result = cursor.fetchone()
                    if result:
                        print(result[0],result[1])
            elif option == '1':
                new_friend = input("Add the friend user_id:")
                if new_friend in friend_list or new_friend == self.user_id:
                    print("ERROR: Duplicate friend.")
                cursor.execute("select user_id from user where user_id = '{}';".format(new_friend))
                result = cursor.fetchone()
                if not result:
                    print("User does not exist.")
                    continue
                else:
                    cursor.execute("insert into friend_list(followed_id, follower_id) value('{}','{}');".format(self.user_id, new_friend))
            elif option == '2':
                candi_friend = input("Delete friend:")
                if candi_friend in friend_list:
                    cursor.execute("delete from friend_list where followed_id = '{}' and follower_id = '{}'".format(self.user_id, candi_friend))
            elif option == '3':
                break

    def create_group(self, group_name):
        '''

        :param group_name: VARCHAR(255)
        :return: int:
        '''
        try:
            cursor.execute("insert into group_list(group_name) value('{}');".format(group_name))
        except pymysql.err.DataError:
            print("ERROR: Group name is too long", file=sys.stderr)
            return -1
        cursor.execute("select max(group_id) from group_list;")
        group_number = cursor.fetchone()[0]
        cursor.execute("insert into group_join(user_id, group_id) value('{}',{});".format(self.user_id, group_number))
        db.commit()
        return group_number

    def join_group(self, group_id):
        cursor.execute("select group_id from group_join where user_id ='{}'".format(self.user_id))
        results = cursor.fetchall()
        group = []
        for result in results:
            group.append(str(result[0]))
        if group_id in group:
            print("ERROR: group_id already exists.", file=sys.stderr)
            return -1
        try:
            cursor.execute("insert into group_join(user_id, group_id) value('{}',{});".format(self.user_id, group_id))
        except pymysql.err.IntegrityError:
            print("ERROR: group_id not exists.", file=sys.stderr)
            return -1
        db.commit()
        return 1

    def quit_group(self, group_id):
        '''
        quit a group by its group_ID
        :param group_id: INT
        :return: group_id if success, else -1
        '''
        cursor.execute("select group_id from group_join where user_id ='{}'".format(self.user_id))
        results = cursor.fetchall()
        group = []
        for result in results:
            group.append(str(result[0]))
        if group_id not in group:
            print("ERROR: group_id not exists.", file=sys.stderr)
            return -1
        cursor.execute("delete from group_join where user_id = '{}' and group_id = {}".format(self.user_id, group_id))
        db.commit()
        return group_id

    def follow_topic(self, topic_id):
        try:
            cursor.execute("insert into follow_topic(user_id, business_id) value('{}', '{}')".format(self.user_id,topic_id))
        except pymysql.err.IntegrityError:
            print("Error: unknown business_id.", file = sys.stderr)
            return -1
        db.commit()
        return 1

    def unfollow_topic(self, topic_id):
        try:
            cursor.execute("delete from follow_topic where user_id = '{}' and business_id = '{}'".format(self.user_id, topic_id))
        except pymysql.err.IntegrityError:
            print("Error: unexpected business_id", file = sys.stderr)
            return -1
        db.commit()
        return 1

    def compliment_on_review(self, review_id, up_or_down):
        '''

        :param review: string 22 byte review_id
        :param up_or_down:int 1 means up -1 means down
        :return:
        '''
        if up_or_down == 1:
            cursor.execute("select user_id from review where review_id = '{}'".format(review_id))
            user = cursor.fetchone()[0]
            cursor.execute("update user set useful = useful + 1 where user_id = '{}'".format(user))
            cursor.execute("update review set useful = useful + 1 where review_id = '{}';".format(review_id))
        else:
            cursor.execute("select user_id from review where review_id = '{}'".format(review_id))
            user = cursor.fetchone()[0]
            cursor.execute("update user set useful = useful - 1 where user_id = '{}'".format(user))
            cursor.execute("update review set useful = useful - 1 where review_id = '{}';".format(review_id))
        db.commit()
        return 1

    def compliment_on_tip(self, tip_id, up_or_down):
        '''

        :param tip_id: String tip_id
        :param up_or_down: int 1 means up -1 means down
        :return:
        '''
        if up_or_down == 1:
            cursor.execute("select user_id from tip where tip_id = '{}'".format(tip_id))
            user = cursor.fetchone()[0]
            cursor.execute("update user set useful = useful + 1 where user_id = '{}'".format(user))
            cursor.execute("update tip set compliment_count = compliment_count + 1 where tip_id = '{}';".format(tip_id))
        else:
            cursor.execute("select user_id from tip where tip_id = '{}'".format(tip_id))
            user = cursor.fetchone()[0]
            cursor.execute("update user set useful = useful - 1 where user_id = '{}'".format(user))
            cursor.execute("update tip set compliment_count = compliment_count - 1 where tip_id = '{}';".format(tip_id))
        db.commit()
        return 1


ui = UI()
ui.check_password()
# ui.set_userid('___I9ZYdYGkZ6dMYxwJEIQ')
# ui.compliment_on_tip('1',-1)
db.commit()
db.close()
