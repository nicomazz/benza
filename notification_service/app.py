import sys

from flask import Flask
from flask_restplus import Api, Resource, fields
from pyfcm import FCMNotification

from UserDAO import UserDAO

# IMPORTANT: this key is revoked, replace it with a new one, and protect it in the most appropriate way
# new key added
push_service = FCMNotification(api_key="AAAAiDRYHIs:APA91bEdzWZ1cZrq8Y8w9MGSwEQ8Ar1CFBbdlJUSn3zWulhUa4KO4izAAwLLcs8tvhLQ1BcQJ5nNJKniQDyEA9F-FhWJbZzIFJXc2GjhMQAmFPydcIELTfzfuWXloyj71xIZldr85eoq")

app = Flask(__name__)

api = Api(app, version='1.0', title='Notification service',
          description='A simple service to handle notifications with Firebase Cloud Messaging',
          )

ns = api.namespace('user', description='user management')
notify_ws = api.namespace('notify', description='Notify service')

### MODELS
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
    'userTargets': fields.List(fields.String(), required=True, description='ids of users to be notified')
})

DAO = UserDAO()

# MOCK USERS for testing purpose
DAO.create('user_1', "notkey1")
DAO.create('user_2', "notkey2")
DAO.create('user_3', "notkey3")
DAO.create('user_4', "notkey4")

# NOTIFICATION_KEY SETTING

@ns.route('/<string:user_id>')
@ns.response(404, 'user not found')
@ns.param('user_id', 'The user id')
class User(Resource):
    '''Show a single user item and lets you delete them'''

    @ns.doc('get_user')
    @ns.marshal_with(notification_id)
    def get(self, user_id):
        return {
            "notification_id": DAO.get(user_id).decode("utf-8")
        }

    @ns.doc('delete_user')
    @ns.response(204, 'user deleted')
    def delete(self, user_id):
        '''Delete a task given its identifier'''
        DAO.delete(user_id)
        return '', 204

    @ns.expect(user)
    @ns.expect(notification_id)
    def put(self, user_id):
        return self.post(user_id)

    @ns.doc('create_user')
    @ns.expect(notification_id)
    @ns.marshal_with(notification_id)
    def post(self, user_id):
        DAO.create(user_id, api.payload['notification_id'])
        return {
                   "notification_id": DAO.get(user_id).decode("utf-8")
               }, 201


def get_notifications_ids(user_ids):
    print(user_ids)
    res = []
    for id in user_ids:
        notification_id = DAO.get(id)
        if notification_id is not None:
            res.append(str(notification_id))
    return res

# setting an endpoint to effectively send a notification
@notify_ws.route('/')
class Notify(Resource):
    @notify_ws.doc('send a notification to the id in the payload')
    @notify_ws.expect(notification)
    #   @ns.marshal_with(user)
    def post(self):
        user_ids = api.payload['userTargets']
        title = api.payload["title"]
        body = api.payload["body"]
        notification_ids = get_notifications_ids(user_ids)
        result = push_service.notify_multiple_devices(registration_ids=notification_ids, message_title=title,
                                                      message_body=body)
        sys.stdout.flush()
        return result, 201


if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
