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
Insert data with dictionary
```objc
NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
[data setObject:@"Yash" forKey:@"Name"];
[data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];

[DBManager insertData:data tableName:@"Users"];
```

