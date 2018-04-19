# Setup Instructions
Manually:
1. Add `Database` folder to your project.
2. Add `libsqlite3.tbd` or `libsqlite3.0.tbd` to Project -> General -> Linked Frameworks and Libraries.
3. Import `DBManager.h` to AppDelegate and call below method in didFinishLaunchingWithOptions.
```objc 
[DBManager copyDatabaseIfNeeded]; 
```

How to use 
---------
Creat table 
```objc
NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
[data setObject:@"Yash" forKey:@"Name"];
[data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];

[DBManager createTable:@"Users" withDictionary:data]; // pass dictionary and table name.
```
Insert data
```objc
NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
[data setObject:@"Yash" forKey:@"Name"];
[data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];

[DBManager insertData:data tableName:@"Users"]; // pass dictionary and table name.
```
Get single data or find single data with ID
```objc
NSArray *user = [[NSArray alloc] initWithArray:[DBManager findDataWithId:2 tableName:@"Users"]]; // pass id and table name.
```
Get or find data with query
```objc
NSString *query = [NSString stringWithFormat:@"select * from Users"];
NSArray *user = [[NSArray alloc] initWithArray:[DBManager findDataWithQuery:query]]; // pass query.
```
Get all data
```objc
NSArray *users = [[NSArray alloc] initWithArray:[DBManager getAllData:@"Users"]]; // pass table name.
```
Delete data with ID
```objc
BOOL delete = [DBManager deleteDataWithId:1 tableName:@"Users"]; // pass id and table name.
```
Update data with ID
```objc
NSMutableDictionary *updateData = [[NSMutableDictionary alloc] init];
[updateData setObject:@"update" forKey:@"Name"];
[updateData setObject:@"update@gmail.com" forKey:@"Email"];

[DBManager updateData:updateData id:1 tableName:@"Users"]; // pass dictionary, id and table name.
```
Get database path
```objc
NSString *getPath = [DBManager getDBPath];
```



