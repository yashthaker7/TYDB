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

```
Insert data
```objc
NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
[data setObject:@"Yash" forKey:@"Name"];
[data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];

[DBManager insertData:data tableName:@"Users"]; // pass dictionary and table name.
```
Get all data
```objc
NSArray *users = [[NSArray alloc] initWithArray:[DBManager getAllData:@"Users"]]; // pass table name.
```
Get single data 
```objc
NSArray *user = [[NSArray alloc] initWithArray:[DBManager findDataWithId:2 tableName:@"Users"]]; // pass id and table name.
```
Delete data
```objc
BOOL delete = [DBManager deleteDataWithId:1 tableName:@"Users"]; // pass id and table name.
```
Update data
```objc

```
Get database path
```objc

```



