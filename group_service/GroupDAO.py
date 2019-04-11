import dataset


class GroupDAO(object):
    def __init__(self):
        self.db = dataset.connect('mysql://root:not_so_secret@mysql_db/group_db')
        self.group_table = self.db['group']
        #print("\nThe group_table column headers:\n", self.group_table.columns, "\n")
    
    # THESE ARE ACCESSED IN THE /GROUP/<INT:ID> NS

    def get(self, group_name):
        return self.group_table.find_one(name=group_name)

    def update(self, group_name, uid):
        ### Can't get the SQL to execute properly. Really bad hack in the meantime
        #stmt = 'SELECT * FROM group WHERE name = :group_name'
        #result = self.db.query(stmt, group_name = group_name)
        #for row in self.db.query(stmt):
        #    existingUsers = row['users']
        #    print("!!! Existing Users: ", existingUsers)
        for group in self.group_table:
            if group['name'] == group_name:
                existingUsers = group['users']
                print("existing: ", existingUsers)
                newList = existingUsers + ", " +uid
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
        for group in self.group_table:
            print("   Group %d" % (group['id']))
            print("|  users = ", group['users'])
            print("|   type = ", type(group['users']),"\n") 
        result = list(self.group_table.all())
        return result

    def create(self, payload):
        print("----------GroupDAO.create()----------")
        self.group_table.insert(payload)
        print("\n|   payload = ", payload, "\n")
        return self.get(payload['name'])