from flask import Flask, request
from flask_restplus import Resource, Api

app = Flask(__name__)
api = Api(app)

todos = {}
# todo define models


@api.route('/match')
class TodoSimple(Resource):
    def post(self, todo_id):
        return {"result": "todo"}


if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')
