from flask import Flask
from flask_restplus import Api, Resource, fields
import dataset
from GroupDAO import GroupDAO

app = Flask(__name__)

api = Api(app, version='1.0', title='Group service',
          description='A simple service to handle groups of users',
          )

group_ns = api.namespace('group', description='CRUD for groups')
user_group_ns = api.namespace('user_group', description='Used to insert user in a group')
group_offer = api.namespace('group', description='group management')
ns = api.namespace('old_user', description='group management')


# MODELS

latlng_t = api.model("LatLng",{
    "lat":fields.Float(),
    "lng":fields.Float()
})

offer = api.model("offer",{
    'offerer': fields.String(description="user_id"),
    'capacity': fields.Integer(),
    'usersInside': fields.List(fields.String())
})

group = api.model('group',{
    'group_id':fields.Integer(),
    'name':fields.String(description="name of the group"),
    'path':fields.String(description="polyline encoded"),
    'users':fields.List(fields.String()),
    'offers':fields.List(fields.Nested(offer))
})


DAO = GroupDAO();


@group_ns.route('/<int:id>')
class Group(Resource):
    @group_ns.doc('get info for the group with a specific id')
    def get(self,id):
        pass

    @group_ns.doc('add or update a specific group')
    @group_ns.expect(group)
    #@group_ns.marshal_with(group)
    def post(self,id):
        return DAO.create(api.payload) , 201


    def delete(self,id):
        return DAO.delete(id), 201


@group_ns.route('/')
class Group(Resource):
    @group_ns.doc('get all the groups')
  #  @group_ns.marshal_list_with(group)
    def get(self):
        return DAO.get_all()



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
