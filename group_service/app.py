from flask import Flask
from flask_restplus import Api, Resource, fields
import dataset
app = Flask(__name__)

api = Api(app, version='1.0', title='Group service',
          description='A simple service to handle notification with firebase messaging',
          )
config = {
        'user': 'root',
        'password': 'not_so_secret',
        'host': 'mysql_db',
        'port': '3306',
        'database': 'group_db'
    }

#for the docs: https://dataset.readthedocs.io/en/latest/quickstart.html
def test_db():
    db = dataset.connect('mysql://root:not_so_secret@mysql_db/group_db')
    print(db.tables)
    table = db['user']
    # Insert a new record.
    table.insert(dict(name='John Doe', age=46, country='China'))
    # dataset will create "missing" columns any time you insert a dict with an unknown key
    table.insert(dict(name='Jane Doe', age=37, country='France', gender='female'))
    print(db.tables)
    print("user list:")
    print(list(db['user'].all()))

test_db()


ns = api.namespace('user', description='user management')
notify_ws = api.namespace('notify', description='Notify service')

user_id = api.model('user_id',{
    'userId':fields.String(readOnly=True, description='The user unique identifier'),
})

user = api.model('UserNotificationId', {
    'userId': fields.String(readOnly=True, description='The user unique identifier'),
    'notificationId': fields.String(required=False, description='The task details')
})

notification = api.model('notification', {
    'title': fields.String(readOnly=True, description='Title of the notify'),
    'body': fields.String(readOnly=True, description='body of the notify'),
    'userTargets': fields.List(fields.Nested(user_id),required=True, description='id of users to be notified')
})



class UserDAO(object):
    def __init__(self):
        self.counter = 0
        self.users = []

    def get_all(self):
        return self.users

    def get(self, id):
        for user in self.users:
            if user['userId'] == id:
                return user
        api.abort(404, "user {} doesn't exist".format(id))

    def create(self, data):
        user = data
        self.users.append(user)
        return user

    def update(self, id, notificationId):
        user = self.get(id)
        user['notificationId'] = notificationId
        return user

    def delete(self, id):
        user = self.get(id)
        self.users.remove(user)


DAO = UserDAO();
DAO.create({'userId': 'user_1', 'notificationId':"not1"})
DAO.create({'userId': 'user_2', 'notificationId':"not2"})
DAO.create({'userId': 'user_3', 'notificationId':"not3"})
DAO.create({'userId': 'user_4', 'notificationId':"not4"})


@ns.route('/list')
class UserList(Resource):
    '''Shows a list of all users, and lets you POST to add new tasks'''
    @ns.doc('list_users')
    @ns.marshal_list_with(user)
    def get(self):
        '''List all tasks'''
        return DAO.users

    # @ns.doc('create_user')
    # @ns.expect(user)
    # @ns.marshal_with(user, code=201)
    # def post(self):
    #     '''Create a new task'''
    #     return DAO.create(api.payload), 201


@ns.route('/<string:id>')
@ns.response(404, 'user not found')
@ns.param('id', 'The user id')
class User(Resource):

    '''Show a single user item and lets you delete them'''
    @ns.doc('get_user')
    @ns.marshal_with(user)
    def get(self, id):
        '''Fetch a given resource'''
        return DAO.get(id)

    @ns.doc('delete_user')
    @ns.response(204, 'user deleted')
    def delete(self, id):
        '''Delete a task given its identifier'''
        DAO.delete(id)
        return '', 204

    @ns.expect(user)
    @ns.marshal_with(user)
    def put(self, id):
        '''Update a task given its identifier'''
        print(api.payload)
        return DAO.update(id, api.payload['notificationId'])
    
    @ns.doc('create_user')
    @ns.expect(user)
    @ns.marshal_with(user)
    def post(self, id):
        '''Update a task given its identifier'''
        return DAO.create(api.payload), 201

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
