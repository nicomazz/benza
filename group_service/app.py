from flask import Flask
from flask_restplus import Api, Resource, fields, marshal_with
import dataset
from GroupDAO import GroupDAO

app = Flask(__name__)

api = Api(app, 
        version='1.0', 
        title='Group service',
        description='A service to handle groups of users',
        )

group_ns = api.namespace('group', description='CRUD for groups')
user_group_ns = api.namespace('user_group', description='Insert user in a group')
#group_offer = api.namespace('group', description='group management')
#ns = api.namespace('old_user', description='group management')


# MODELS

latlng_t = api.model('latLngt',{
    'lat':fields.Float(),
    'lng':fields.Float()
})

offer = api.model('offer',{
    'offerer': fields.String(description="The user_id of the user making the offer"),
    'capacity': fields.Integer(description="The available space in the offerer's vehicle"),
    'usersInside': fields.List(fields.String(description="The IDs of users who have already accepted this offer"))
})

group = api.model('group',{
    'group_id':fields.Integer(),
    'name':fields.String(description="The group's name"),
    'location':fields.String(),
    #'path':fields.String(description="polyline encoded"),
    'users':fields.List(fields.String(description="The IDs of users in this group")),
    #'offers':fields.List(fields.Nested(offer))
})


DAO = GroupDAO()



@group_ns.route('/<int:groupId>/<int:uid>')
class Group(Resource):
    @group_ns.doc('Adds a user to a specific group')
    def post(self,groupId,uid):
        return DAO.update(groupId,uid), 200

@group_ns.route('/<int:groupId>')
class Group(Resource):
    @group_ns.doc('Gets info for a specific group')
    def get(self,groupId):
        return DAO.get(groupId), 200

    @group_ns.doc('Adds or updates a specific group')
    @group_ns.expect(group)
    #@group_ns.marshal_with(group)
    def update(self,id):
        return DAO.create(api.payload), 200

    @group_ns.doc('Deletes a specific group')
    def delete(self,id):
        return DAO.delete(id), 200


@group_ns.route('/')
class Group(Resource):
    @group_ns.doc('Gets all groups')
    def get(self):
        return DAO.get_all(), 200

    @group_ns.doc('Creates a group')
    @group_ns.expect(group)
    def post(self):
        return DAO.create(api.payload), 200



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
#for the docs: https://dataset.readthedocs.io/en/latest/quickstart.html

if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
