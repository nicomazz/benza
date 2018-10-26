from flask import Flask
from flask_restplus import Api, Resource, fields
from pyfcm import FCMNotification

from notification_service.UserDAO import UserDAO
push_service = FCMNotification(api_key="AAAAgTBmNoo:APA91bHL08Z1VW5iaCAnxqM-u3xsSgRcXd9lwbXHRTY9ygDeT-s2GopwclF1-TNkhsWCFcfayZetZE1DHhKbjBRNmFD0FROEOd3JQKFpRioJUsc5pNdO2fY_Z1Go-mohrgsQaKwK97sd")

app = Flask(__name__)

api = Api(app, version='1.0', title='Notification service',
          description='A simple service to handle notification with firebase messaging',
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

# mock users
DAO.create('user_1', "not_key_1")
DAO.create('user_2', "not2")
DAO.create('user_3', "not3")
DAO.create('user_4', "not4")


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
        return {
                   "notification_id": DAO.create(id, api.payload['notification_id'])
               }, 201


def get_notifications_ids(user_ids):
    return ["test1","test2"]


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

        print("todo: send a real notify to ")
        print(notification_ids)
        print(result)
        return result, 201


if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
