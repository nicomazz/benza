from flask import Flask
from flask_restplus import Api, Resource, fields, marshal_with
import dataset
from GroupDAO import GroupDAO

#Defining the high level info for the API.
app = Flask(__name__)

api = Api(app, 
        version='1.0', 
        title='Group service',
        description='A service to handle groups of users',
        )

group_ns = api.namespace('group', description='CRUD for groups')
user_group_ns = api.namespace('user_group', description='Insert user in a group')
group_offer = api.namespace('offer', description='group management')

#The latlng_t and offer models where made a part of the pre-implementation planning stage. They will be left here,
#unused, until the development team can resume work on the project.

latlng_t = api.model('latLngt',{
    'lat':fields.Float(),
    'lng':fields.Float()
})

offer = api.model('offer',{
    'offerer': fields.String(description="The user_id of the user making the offer"),
    'capacity': fields.Integer(description="The available space in the offerer's vehicle"),
    'usersInside': fields.List(fields.String(description="The IDs of users who have already accepted this offer"))
})

#This is the model for the group objects that the API is being passed by the methods in group_provider.dart
group = api.model('group',{
    'group_id':fields.Integer(),
    'name':fields.String(description="The group's name"),
    'location':fields.String(),
    'users':fields.List(fields.String(description="The IDs of users in this group")),
    #'offers':fields.List(fields.Nested(offer))
    'coords':fields.List(fields.String()),
})

#This tells Python to use the imported GroupDAO module
DAO = GroupDAO()

#First example of a Flask RESTPlus decorator.
#This one tells us that this particular post method requires a URL request with the format below.
@group_ns.route('/<string:groupName>/<string:uid>')
class Group(Resource):
    @group_ns.doc('Adds a user to a specific group')
    def post(self, groupName, uid):
        return DAO.update(groupName, uid), 200

#The URL route that requires the client to send their requests with a group id
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

#The base URL route. 
@group_ns.route('/')
class Group(Resource):
    #Another decorator that generates automatically in the Swagger UI to help annotate the interface
    @group_ns.doc('Gets all groups')
    #'self' is the Group class, which represents a RESTPlus resource.
    def get(self):
        #Accessing the .get_all() method in the DAO and returning server code 200 if successful
        return DAO.get_all(), 200

    @group_ns.doc('Creates a group')
    @group_ns.expect(group)
    def post(self):
        return DAO.create(api.payload), 200

#Running the app on localhost.
if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
