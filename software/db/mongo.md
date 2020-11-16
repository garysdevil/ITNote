https://docs.mongodb.com/manual/tutorial/enable-authentication/
1. 数据库级别操作
use DATABASE_NAME
show dbs
db.dropDatabase()

2. 集合级别操作
db.createCollection(CONNECTION_NAME, options)
show collections
db.collection.drop()
- 当执行插入文档操作时，没有集合则会默认创建这个集合
	db.CONNECTION_NAME.insert({"KEY":"VALUE"})

2. 权限角色
	0. 开启权限认证 mongod --auth --dbpath "D:\Program Files\MongoDB\Server\4.0\data"
	1. 数据库用户角色
		read: 只读数据权限
		readWrite:读写数据权限
	2. 数据库管理角色
		dbAdmin: 在当前db中执行管理操作的权限
		dbOwner: 在当前db中执行任意操作
		userAdmin: 在当前db中管理user的权限
	3.  查看全局所有账户 
	```
	use admin
	db.system.users.find().pretty()
	```
	4. 查看当前数据库的所有用户
	```
	show users
	```
    5. 为某个数据库创建一个用户
	```shell
	use DATABASE_NAME
	db.createUser({user:"user",pwd:"pass",roles:["readWrite"]}) # 增加用户
	db.updateUser("user",{roles:[ {role:"read",db:"DATABASE_NAME"} ]})  # 修改用户
	db.auth("user","pass") # 切换用户
	```
	6. 创建全局用户
	```
	use admin
	 db.addUser("global_user","global123")
	```
3. 查询
	- db.collection.find(query, projection).pretty()
	- db.collection.find(条件, 获取的字段).pretty()
	1. and 查询 并且只输出title字段
		db.col.find({"by":"菜鸟教程", "title":"MongoDB 教程"},{title:true}).pretty()
	2. or 查询
		db.col.find({$or:[{"by":"菜鸟教程"},{"title": "MongoDB 教程"}]}).pretty()
	3.  查询字段title不为null的且存在记录值的document的数量
		db.getCollection('col').find({"title":{"$ne":null, , $exists:true}}).count()
