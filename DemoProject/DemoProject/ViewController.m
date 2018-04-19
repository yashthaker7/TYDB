//
//  ViewController.m
//  DatabaseDemo
//
//  Created by Pixster Studio on 14/10/17.
//  Copyright © 2017 YashThaker. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // Create table
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:@"Yash2" forKey:@"Name"];
//    [data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];
//
//    [DBManager createTable:@"Users" withDictionary:data];
    
    
    
//    // Insert data
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:@"Yash2" forKey:@"Name"];
//    [data setObject:@"yashthaker7@gmail.com" forKey:@"Email"];
//
//    [DBManager insertData:data tableName:@"Users"];
    
    
    
//    // Get Single Data / Find single data
//    NSArray *user = [[NSArray alloc] initWithArray:[DBManager findDataWithId:1 tableName:@"Users"]];
//    NSLog(@"%@", user);
    
    

//    // Get Data with query
//    NSString *query = [NSString stringWithFormat:@"select * from Users"];
//    NSArray *user = [[NSArray alloc] initWithArray:[DBManager findDataWithQuery:query]];
//    NSLog(@"%@", user);
    
    
    
//    // Get all data
//    NSArray *users = [[NSArray alloc] initWithArray:[DBManager getAllData:@"Users"]];
//    NSLog(@"%@", users);
    
    
    
//    // Delete data
//    BOOL delete = [DBManager deleteDataWithId:1 tableName:@"Users"];
    
    
    
//    // Update data
//    NSMutableDictionary *updateData = [[NSMutableDictionary alloc] init];
//    [updateData setObject:@"update" forKey:@"Name"];
//    [updateData setObject:@"update@gmail.com" forKey:@"Email"];
//
//    [DBManager updateData:updateData id:1 tableName:@"Users"];
    
    
    
//    // Get database path
//    NSString *getPath = [DBManager getDBPath];
//    NSLog(@"%@", getPath);
}

@end
