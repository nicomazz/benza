import redis


class UserDAO(object):
    def __init__(self):
        self.db = redis.Redis(host='redis', port=6379)

    def get(self, user_id):
        return self.db.get(user_id)

    def create(self, user_id, notification_id):
        self.db.set(user_id, notification_id)
        return notification_id

    def update(self, user_id, notification_id):
        self.create(user_id, notification_id)

    def delete(self, id):
        self.db.set(id, "")
