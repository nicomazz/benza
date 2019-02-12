import redis

#Class to handle the connection between the the service and the database
class UserDAO(object):
    def __init__(self):
        try:
            self.db = redis.Redis(host='redis', port=6379)
            print(self.db.keys())
        except redis.ConnectionError:
            print("error in the connection")

    def get(self, user_id):
        try:
            return self.db.get(user_id)
        except redis.ConnectionError:
            print("ERROR IN GET")
            return None

    def create(self, user_id, notification_id):
        try:
            self.db.set(user_id, notification_id)
            return notification_id
        except redis.ConnectionError:
            print("ERROR IN CREATE")
            return None

    def update(self, user_id, notification_id):
        self.create(user_id, notification_id)

    def delete(self, id):
        try:
            self.db.set(id, "")
        except redis.ConnectionError:
            print("ERROR IN delete")
