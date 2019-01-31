import dataset


class GroupDAO(object):
    def __init__(self):
        self.db = dataset.connect(
            'mysql://root:not_so_secret@mysql_db/group_db')
        self.group_table = self.db['group']
        #print("db tables:")
        #print(self.db.tables)

    def get(self, group_id):
        return self.group_table.find_one(group_id=group_id)

    def get_all(self):
        result = list(self.group_table.all())
        print(result)
        return result

    def create(self, data):
        self.group_table.insert(data)
        return self.get(data['group_id'])

    def update(self, group_id, data):
        self.create( data)

    def delete(self, id):
        return self.group_table.delete(group_id=id)
