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

@interface DBManager : NSObject

+(NSString *)getDBPath;

+(void)copyDatabaseIfNeeded;

+(BOOL)createTable:(NSString*)tableName withDictionary:(NSMutableDictionary*)Dict;

+(BOOL) insertData:(NSMutableDictionary*)Dict tableName:(NSString*)tableName;

+(NSArray*) findDataWithId:(int)ID tableName:(NSString*)tableName;

+(NSArray*) findDataWithQuery:(NSString*)query;

+(NSArray*) getAllData:(NSString*)tableName;

+(BOOL) deleteDataWithId:(int)ID tableName:(NSString*)tableName;

+(BOOL) updateData:(NSMutableDictionary*)dict id:(int)ID tableName:(NSString*)tableName;

@end
