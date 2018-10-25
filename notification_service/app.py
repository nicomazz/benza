from flask import Flask
from flask_restplus import Api, Resource, fields
import redis

app = Flask(__name__)

#import redis

db = redis.Redis(host='redis', port=6379)

app = Flask(__name__)
#r = redis.StrictRedis(host='localhost', port=6379, db=0)

api = Api(app, version='1.0', title='Notification service',
          description='A simple service to handle notification with firebase messaging',
          )

ns = api.namespace('user', description='user management')
notify_ws = api.namespace('notify', description='Notify service')

user_id = api.model('user_id', {
    'user_id': fields.String(readOnly=True, description='The user unique identifier'),
})
notification_id = api.model('notification_id', {
    'notification_id': fields.String(description='The user unique notification id'),
})

user = api.model('user', {
    'user_id': fields.String(readOnly=True, description='The user unique identifier'),
    'notification_id': fields.String(required=False, description='The task details')
})

notification = api.model('notification', {
    'title': fields.String(readOnly=True, description='Title of the notify'),
    'body': fields.String(readOnly=True, description='body of the notify'),
    'userTargets': fields.List(fields.Nested(user_id), required=True, description='id of users to be notified')
})


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


DAO = UserDAO()

# mock users
DAO.create('user_1', "not1")
DAO.create('user_2', "not2")
DAO.create('user_3', "not3")
DAO.create('user_4', "not4")


@ns.route('/<string:id>')
@ns.response(404, 'user not found')
@ns.param('id', 'The user id')
class User(Resource):

    '''Show a single user item and lets you delete them'''
    @ns.doc('get_user')
    @ns.marshal_with(notification_id)
    def get(self, id):
        return {
            "notification_id": DAO.get(id).decode("utf-8")
        }

    @ns.doc('delete_user')
    @ns.response(204, 'user deleted')
    def delete(self, id):
        '''Delete a task given its identifier'''
        DAO.delete(id)
        return '', 204

    @ns.expect(user)
    @ns.expect(notification_id)
    def put(self, id):
        return self.post(id)

    @ns.doc('create_user')
    @ns.expect(notification_id)
    @ns.marshal_with(notification_id)
    def post(self, id):
        return {
            "notification_id":DAO.create(id, api.payload['notification_id'])
        }, 201


@notify_ws.route('/')
class Notify(Resource):
    @notify_ws.doc('send a notification to the id in the payload')
    @notify_ws.expect(notification)
 #   @ns.marshal_with(user)
    def post(self, id):
        print("todo: send a real notify")
        return "{'status':'ok'}", 201


if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
