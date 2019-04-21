import dataset
###The data access object for the groups database
class GroupDAO(object):
    def __init__(self):
        #connecting to the database with questionable credentials
        self.db = dataset.connect('mysql://root:not_so_secret@mysql_db/group_db')
        self.group_table = self.db['group']
        #The following line can actually break the MySQL db service that Docker launches because there aren't any tables until one is created by inserting new data.
        #print("\nThe group_table column headers:\n", self.group_table.columns, "\n")
    
    # THESE ARE ACCESSED IN THE /GROUP/<INT:ID> NS

    def get(self, group_name):
        return self.group_table.find_one(name=group_name)
    #Can't get Dataset's custom SQL query feature to execute properly. This is a temporary solution
    def update(self, group_name, uid):
        #stmt = 'SELECT * FROM group WHERE name = :group_name'
        #result = self.db.query(stmt, group_name = group_name)
        #for row in self.db.query(stmt):
        #    existingUsers = row['users']
        #    print("Existing Users: ", existingUsers)
        for group in self.group_table:
            if group['name'] == group_name:
                existingUsers = group['users']
                print("existing: ", existingUsers)
                newList = existingUsers + ", " + uid
        print("----------GroupDAO.update()----------")
        print("\n|   Group name to update = ", group_name)
        print("|   User already inside = ", existingUsers)
        print("|   User we're adding = ", uid, "\n")
        data = dict(name = group_name, users = newList) 
        self.group_table.update(data, ['name'])

    def delete(self, id):
        return self.group_table.delete(id=id)

    # THESE ARE ACCESSED IN THE /GROUP/ NS

    def get_all(self):
        print("\n----------GroupDAO.get_all()----------")
        #Dataset lets us use methods like .all() to avoid typing out SQL queries amidst our nice Python
        for group in self.group_table:
            print("   Group %d" % (group['id']))
            print("|  users = ", group['users'])
        result = list(self.group_table.all())
        return result

    def create(self, payload):
        print("----------GroupDAO.create()----------")
        self.group_table.insert(payload)
        print("\n|   payload = ", payload, "\n")
        return self.get(payload['name'])