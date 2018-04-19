//
//  DBManager.m
//  SQLiteDatabase1
//
//  Created by Admin on 14/11/16.
//  Copyright © 2016 Yash Thaker. All rights reserved.
//

// NOTE: Don't forget to import libsqlite3 in linked frameworks and libraries

#import "DBManager.h"

@implementation DBManager

static NSString *databasePath;
static sqlite3 *database;
static sqlite3_stmt *statement;

+(NSString *)getDBPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath] == NO)
    {
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent: @"Database.sqlite"]];
    }
    // NSLog(@"%@",databasePath);
    return databasePath;
}

+(void)copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Database.sqlite"];
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (success)
        {
            NSLog(@"Copy successfully.");
            NSLog(@"%@",dbPath);
        }
        
        if (!success)
        {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

+(BOOL)createTable:(NSString*)tableName withDictionary:(NSMutableDictionary*)Dict
{
    BOOL isSuccess = YES;
    
    NSArray *keys = [[NSArray alloc] initWithArray:[Dict allKeys]];
    NSString *sqlStmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (ID INTEGER PRIMARY KEY AUTOINCREMENT, ",tableName];
    
    for (int i=0; i<[keys count]; i++)
    {
        if ([[[Dict allKeys] objectAtIndex:i]  isEqual: @"ID"] )
        {
            continue;
        }
        if (i == [keys count]-1)
        {
            NSString *string = [NSString stringWithFormat:@"%@)",[keys objectAtIndex:i]];
            sqlStmt = [sqlStmt stringByAppendingString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@, ",[keys objectAtIndex:i]];
            sqlStmt = [sqlStmt stringByAppendingString:string];
        }
    }
    //NSLog(@"%@",sqlStmt);
    
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = [sqlStmt UTF8String];
        
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"Failed to create table.");
        }
        
        sqlite3_close(database);
        NSLog(@"Create Successfully.");
        NSLog(@"%@", [self getDBPath]);
        return  isSuccess;
        
    }
    else
    {
        isSuccess = NO;
        NSLog(@"Failed to open/create database.");
    }
    return isSuccess;
}

+(BOOL) insertData:(NSMutableDictionary*)Dict tableName:(NSString*)tableName
{
    [self createTable:tableName withDictionary:Dict];
    NSMutableArray *Keys = [[NSMutableArray alloc] initWithArray:[Dict allKeys]];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:[Dict allValues]];
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into \"%@\" (",tableName];
    
    for (int i=0; i<[Keys count]; i++)
    {
        if (i == [Keys count]-1)
        {
            NSString *string = [NSString stringWithFormat:@"%@) values (",[Keys objectAtIndex:i]];
            insertSQL = [insertSQL stringByAppendingString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@, ",[Keys objectAtIndex:i]];
            insertSQL = [insertSQL stringByAppendingString:string];
        }
    }
    //NSLog(@"%@",insertSQL);
    
    for (int i=0; i<[values count]; i++)
    {
        if (i == [values count]-1)
        {
            NSString *string = [NSString stringWithFormat:@"\"%@\")",[values objectAtIndex:i]];
            insertSQL = [insertSQL stringByAppendingString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"\"%@\", ",[values objectAtIndex:i]];
            insertSQL = [insertSQL stringByAppendingString:string];
        }
    }
    //NSLog(@"%@",insertSQL);
    
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            NSLog(@"Insert successfully.");
            return YES;
        }
        else
        {
            NSLog(@"Error while inserting.");
            return NO;
        }
    }
    return NO;
}

+(NSArray*) findDataWithId:(int)ID tableName:(NSString*)tableName
{
    const char *dbpath = [[self getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from \"%@\" where ID = %d",tableName,ID];
        
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                // Get the total number of columns.
                int totalColumns = sqlite3_column_count(statement);
                
                // Go through all columns and fetch each column data.
                for (int i=0; i<totalColumns; i++)
                {
                    // Convert the column data to text (characters).
                    char *dbDataAsChars = (char *)sqlite3_column_text(statement, i);
                    char *columnName = (char *)sqlite3_column_name(statement,i);
                    // If there are contents in the currenct column (field) then add them to the current row array.
                    if (dbDataAsChars != NULL) {
                        // Convert the characters to string.
                        [data setObject:[NSString  stringWithUTF8String:dbDataAsChars] forKey:[NSString stringWithUTF8String:columnName]];
                    }
                }
                [resultArray addObject:data];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            //NSLog(@"%@", resultArray);
            return resultArray;
        }
        else
        {
            NSLog(@"Not found");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return nil;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return nil;
}

+(NSArray*) findDataWithQuery:(NSString*)query {
    const char *dbpath = [[self getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"%@", query];
        
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                // Get the total number of columns.
                int totalColumns = sqlite3_column_count(statement);
                
                // Go through all columns and fetch each column data.
                for (int i=0; i<totalColumns; i++)
                {
                    // Convert the column data to text (characters).
                    char *dbDataAsChars = (char *)sqlite3_column_text(statement, i);
                    char *columnName = (char *)sqlite3_column_name(statement,i);
                    // If there are contents in the currenct column (field) then add them to the current row array.
                    if (dbDataAsChars != NULL) {
                        // Convert the characters to string.
                        [data setObject:[NSString  stringWithUTF8String:dbDataAsChars] forKey:[NSString stringWithUTF8String:columnName]];
                    }
                }
                [resultArray addObject:data];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            //NSLog(@"%@", resultArray);
            return resultArray;
        }
        else
        {
            NSLog(@"Not found");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return nil;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return nil;
}

+(NSArray*) getAllData:(NSString*)tableName
{
    const char *dbpath = [[self getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from \"%@\" ",tableName];
        const char *query_stmt = [querySQL UTF8String];
        
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                // Get the total number of columns.
                int totalColumns = sqlite3_column_count(statement);
                
                // Go through all columns and fetch each column data.
                for (int i=0; i<totalColumns; i++)
                {
                    // Convert the column data to text (characters).
                    char *dbDataAsChars = (char *)sqlite3_column_text(statement, i);
                    char *columnName = (char *)sqlite3_column_name(statement,i);
                    // If there are contents in the currenct column (field) then add them to the current row array.
                    if (dbDataAsChars != NULL) {
                        // Convert the characters to string.
                        [data setObject:[NSString  stringWithUTF8String:dbDataAsChars] forKey:[NSString stringWithUTF8String:columnName]];
                    }
                }
                [resultArray addObject:data];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            //NSLog(@"%@", resultArray);
            return resultArray;
        }
        else
        {
            NSLog(@"Not found");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return nil;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return nil;
}

+(BOOL) deleteDataWithId:(int)ID tableName:(NSString*)tableName
{
    const char *dbpath = [[self getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"delete from \"%@\" where ID = %d",tableName,ID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(database, query_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            NSLog(@"Delete successfully.");
            return YES;
        }
        else
        {
            NSLog(@"Error while Deleting.");
            return NO;
        }
    }
    return NO;
}

+(BOOL) updateData:(NSMutableDictionary*)dict id:(int)ID tableName:(NSString*)tableName
{
    NSMutableArray *Keys = [[NSMutableArray alloc] initWithArray:[dict allKeys]];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:[dict allValues]];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE \"%@\" SET ",tableName];
    
    for (int i=0; i<[Keys count]; i++)
    {
        if (i == [Keys count]-1)
        {
            NSString *string = [NSString stringWithFormat:@"%@ = \"%@\" ",[Keys objectAtIndex:i],[values objectAtIndex:i]];
            updateSQL = [updateSQL stringByAppendingString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@ = \"%@\", ",[Keys objectAtIndex:i],[values objectAtIndex:i]];
            updateSQL = [updateSQL stringByAppendingString:string];
        }
    }
    
    NSString *string = [NSString stringWithFormat:@"WHERE ID = \"%d\"", ID];
    updateSQL = [updateSQL stringByAppendingString:string];
    
    //NSLog(@"%@",updateSQL);
    
    const char *dbpath = [[self getDBPath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(database, update_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            NSLog(@"Update successfully.");
            return YES;
        }
        else
        {
            NSLog(@"Error while updating.");
            return NO;
        }
    }
    return NO;
}
@end
