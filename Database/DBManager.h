//
//  DBManager.h
//  SQLiteDatabase1
//
//  Created by Admin on 14/11/16.
//  Copyright © 2016 Yash Thaker. All rights reserved.
//

// NOTE: Don't forget to import libsqlite3 in linked frameworks and libraries

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject{
    
    NSString *databasePath;
    sqlite3 *database;
    sqlite3_stmt *statement;
}
-(NSString *)getDBPath;

-(void)copyDatabaseIfNeeded;

-(BOOL)createDB:(NSMutableDictionary*)Dict tableName:(NSString*)tableName;

-(BOOL) insertData:(NSMutableDictionary*)Dict tableName:(NSString*)tableName;

-(NSArray*) findById:(int)ID tableName:(NSString*)tableName;

-(NSArray*) showAllData:(NSString*)tableName;

- (BOOL) deleteData:(int)ID tableName:(NSString*)tableName;

-(BOOL) updateData:(NSMutableDictionary*)dict tableName:(NSString*)tableName;



@end
