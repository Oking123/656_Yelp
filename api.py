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
            results = cursor.fetchone()[0]
            if not results:
                print("Account does not exist.")
                continue
            else:
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
            print("1. Post review")
            print("2. Post tip")
            print("3. Add a friend")
            print("4. Join a group")
            print("5. Follow a topic")
            print("6. Signout")
            option = input("")
            if option == '0':
                self.read_post()
            elif option == '1':
                self.post_review()
            elif option == '2':
                self.post_tip()
            elif option == '3':
                self.add_friend()
            elif option == '4':
                self.join_group()
            elif option == '5':
                self.follow_topic()
            elif option == '6':
                return

    def read_post(self):
        cursor.execute('select follower_id from friend_list where followed_id = "{}" ;'.format(self.user_id))
        results = cursor.fetchall()
        cursor.execute('select time from temp where user_id = "{}"'.format(self.user_id))
        time = cursor.fetchone()[0]
        print(time)
        for friend in results:
            cursor.execute('select user_id, review_date, review_text from review where user_id = "{}"'.format(friend[0]))
            text = cursor.fetchall()
            for rows in text:
                print(rows[0],rows[1])
                print('')
                print(rows[2])
                print('')
        print('0')

    def post_review(self):
        print('1')

    def post_tip(self):
        print('2')

    def add_friend(self):
        print('3')

    def join_group(self):
        print('4')

    def follow_topic(self):
        print('5')


ui = UI()
ui.check_password()
db.close()
