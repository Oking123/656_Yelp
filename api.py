import sys
import time
import pymysql

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
            print("2. Post tip")
            print("3. Friend")
            print("4. Group")
            print("5. Topic")
            print("6. Signout")
            option = input("")
            if option == '0':
                self.read_post()
            elif option == '1':
                self.post_menu()
            elif option == '2':
                self.post_tip()
            elif option == '3':
                self.add_friend()
            elif option == '4':
                self.group_menu()
            elif option == '5':
                self.topic_menu()
            elif option == '6':
                return

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
                pass
            elif option == '1':
                business_id = input("Target topic:")
                comment = input("Comment:")
                self.post_review(comment,business_id)
            elif option == '2':
                business_id = input("Target topic:")
                comment = input("Comment:")
                self.post_tip(comment,business_id)

    def set_userid(self, user_id):
        self.user_id = user_id

    def read_post(self):
        print('0')

    def post_review(self,comment,business_id):
        pass

    def post_tip(self,comment,business_id):
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        try:
            cursor.execute("insert into tip(user_id,tip_text ,business_id,compliment_count, tip_date) value('{}','{}','{}',0,'{}')".format(self.user_id,comment,business_id,current_time))
        except pymysql.err.IntegrityError:
            print("Error: unexpected business_id", file=sys.stderr)
            return -1
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
        return 1

    def unfollow_topic(self, topic_id):
        try:
            cursor.execute("delete from follow_topic where user_id = '{}' and business_id = '{}'".format(self.user_id, topic_id))
        except pymysql.err.IntegrityError:
            print("Error: unexpected business_id", file = sys.stderr)
            return -1
        return 1




ui = UI()
ui.check_password()
# ui.set_userid('___I9ZYdYGkZ6dMYxwJEIQ')
# print(ui.post_tip("123123",'xVEtGucSRLk5pxxN0t4i6g'))
# print(ui.follow_topic('__6jYJ6Hm-Qq8XQEGDrOGQ'))
# print(ui.quit_group(2))
# ui.create_group("group4")
db.commit()
db.close()
