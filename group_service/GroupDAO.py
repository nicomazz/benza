import dataset


class GroupDAO(object):
    def __init__(self):
        self.db = dataset.connect('mysql://root:not_so_secret@mysql_db/group_db')
        self.group_table = self.db['group']
        print("\nThe group_table column headers:\n", self.group_table.columns, "\n")
    
    # THESE ARE ACCESSED IN THE /GROUP/<INT:ID> NS

    def get(self, group_id):
        return self.group_table.find_one(group_id=group_id)

    def update(self, payload, group_id):
        self.group_table.update(payload, ['group_id'])

    def delete(self, id):
        return self.group_table.delete(group_id=id)

    # THESE ARE ACCESSED IN THE /GROUP/ NS

    def get_all(self):
        print("\n----------GroupDAO.get_all()----------")
        for group in self.group_table:
            print("|  Group %d" % (group['id']))
            print("|  users = ", group['users'])
            print("|   type = ", type(group['users']),"\n") 
        result = list(self.group_table.all())
        return result

    def create(self, payload):
        print("----------GroupDAO.create()----------")
        self.group_table.insert(payload)
        print("\n|   payload = ", payload, "\n")
        return self.get(payload['name'])