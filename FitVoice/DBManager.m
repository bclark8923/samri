//
//  DBManager.m
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "DBManager.h"
#import "QueryObject.h"
#import "FoodLogObject.h"
#import "FitnessLogObject.h"
#import "FitnessMeasurementObject.h"
#import <Parse/Parse.h>

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"fitvoice.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    activeModelID = @"-1";
    
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"fitvoice.db"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }*/
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *query_table = "create table if not exists query (ID text primary key, email text, query text, json text, model text, modelID integer)";
            if (sqlite3_exec(database, query_table, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create query_table");
            }
            
            const char *food_log_table = "create table if not exists foodLog (ID text primary key, email text, food_name text, calories real, brand_name text, amount real, meal_type text, date text, amount_units text)";
            if (sqlite3_exec(database, food_log_table, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create food_log_table");
            }
            
            const char *fitness_log_table = "create table if not exists fitnessLog (id text primary key, email text, distance real, name text, calories real, distance_units text, duration real, start_date text, start_time text)";
            if (sqlite3_exec(database, fitness_log_table, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create fitness_log_table");
            }
            
            const char *fitness_measurement_table = "create table if not exists fitnessMeasurement (id text primary key, email text, date text, amount real, type text, time text)";
            if (sqlite3_exec(database, fitness_measurement_table, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create fitness_measurement_table");
            }
            
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveQuery:(QueryObject*)query
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        PFObject *parseQueryObject = [PFObject objectWithClassName:@"QueryObject"];
        [parseQueryObject setObject:query.email forKey:@"email"];
        [parseQueryObject setObject:query.query forKey:@"query"];
        [parseQueryObject setObject:query.json forKey:@"json"];
        [parseQueryObject setObject:query.model forKey:@"model"];
        [parseQueryObject setObject:activeModelID forKey:@"modelID"];
        [parseQueryObject save];
        
        NSString *queryID = [NSString stringWithFormat:@"%@", parseQueryObject.objectId];
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into query (ID, email, query, json, model, modelID) values (\"%@\", \"%@\",\"%@\", \"%@\", \"%@\", \"%@\")",queryID, query.email, query.query, @"nil", query.model, query.modelID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Query saved");
            return YES;
        }
        else {
            [parseQueryObject deleteInBackground];
            NSLog(@"%s SQLITE_ERROR '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(database), sqlite3_errcode(database));
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSString*) saveFoodLog:(FoodLogObject*)food
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        PFObject *parseFoodObject = [PFObject objectWithClassName:@"FoodObject"];
        [parseFoodObject setObject:food.email forKey:@"email"];
        [parseFoodObject setObject:food.food_name forKey:@"food_name"];
        [parseFoodObject setObject:[NSString stringWithFormat:@"%f", food.calories] forKey:@"calories"];
        [parseFoodObject setObject:food.brand_name forKey:@"brand_name"];
        [parseFoodObject setObject:[NSString stringWithFormat:@"%f", food.amount] forKey:@"amount"];
        [parseFoodObject setObject:food.meal_type forKey:@"meal_type"];
        [parseFoodObject setObject:food.date forKey:@"date"];
        [parseFoodObject setObject:food.amount_units forKey:@"amount_units"];
        [parseFoodObject save];
        activeModelID = [NSString stringWithFormat:@"%@", parseFoodObject.objectId];
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into foodLog (ID, email, food_name, calories, brand_name, amount, meal_type, date, amount_units) values (\"%@\", \"%@\",\"%@\", \"%f\", \"%@\", \"%f\", \"%@\", \"%@\", \"%@\")",activeModelID, food.email, food.food_name, food.calories, food.brand_name, food.amount, food.meal_type, food.date, food.amount_units];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return activeModelID;
            //return (int)sqlite3_last_insert_rowid(database);
        }
        else {
            [parseFoodObject deleteInBackground];
            return @"-1";
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSString*) saveFitnessLog:(FitnessLogObject*)fitness
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        PFObject *parseFitnessObject = [PFObject objectWithClassName:@"FitnessObject"];
        [parseFitnessObject setObject:fitness.email forKey:@"email"];
        [parseFitnessObject setObject:fitness.name forKey:@"name"];
        [parseFitnessObject setObject:[NSString stringWithFormat:@"%f", fitness.distance] forKey:@"distance"];
        [parseFitnessObject setObject:fitness.distance_units forKey:@"distance_units"];
        [parseFitnessObject setObject:[NSString stringWithFormat:@"%f", fitness.calories] forKey:@"calories"];
        [parseFitnessObject setObject:[NSString stringWithFormat:@"%f", fitness.duration] forKey:@"duration"];
        [parseFitnessObject setObject:fitness.start_date forKey:@"start_date"];
        [parseFitnessObject setObject:fitness.start_time forKey:@"start_time"];
        
        [parseFitnessObject save];
        activeModelID = [NSString stringWithFormat:@"%@", parseFitnessObject.objectId];
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into fitnessLog (ID, email, distance, name, calories, distance_units, duration, start_date, start_time) values (\"%@\", \"%@\",\"%f\", \"%@\", \"%f\", \"%@\", \"%f\", \"%@\", \"%@\")", activeModelID,fitness.email, fitness.distance, fitness.name, fitness.calories, fitness.distance_units, fitness.duration, fitness.start_date, fitness.start_time];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return activeModelID;
            //return (int)sqlite3_last_insert_rowid(database);
        }
        else {
            [parseFitnessObject deleteInBackground];
            return @"-1";
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSString*) saveFitnessMeasurement:(FitnessMeasurementObject*)fitness
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        PFObject *parseMeasurementObject = [PFObject objectWithClassName:@"MeasurementObject"];
        [parseMeasurementObject setObject:fitness.email forKey:@"email"];
        [parseMeasurementObject setObject:fitness.date forKey:@"date"];
        [parseMeasurementObject setObject:[NSString stringWithFormat:@"%f", fitness.amount] forKey:@"amount"];
        [parseMeasurementObject setObject:fitness.type forKey:@"type"];
        [parseMeasurementObject setObject:fitness.time forKey:@"time"];
        
        [parseMeasurementObject save];
        activeModelID = [NSString stringWithFormat:@"%@", parseMeasurementObject.objectId];
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into fitnessMeasurement (ID, email, date, amount, type, time) values (\"%@\",\"%@\",\"%@\", \"%f\", \"%@\", \"%@\")",activeModelID,fitness.email, fitness.date, fitness.amount, fitness.type, fitness.time];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return activeModelID;
            //return (int)sqlite3_last_insert_rowid(database);
        }
        else {
            [parseMeasurementObject deleteInBackground];
            return @"-1";
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Connection didReceiveData of length: %u", data.length);
    
    [responseData appendData:data];
    //NSError *error = nil;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString* theString = [error localizedDescription];
    NSLog(@"connection error: %@", theString);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection success");
    NSError *error = nil;
    NSDictionary *sample = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (!sample) {
        NSString* newStr = [[NSString alloc] initWithData:responseData
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@"%@", newStr);
        NSLog(@"Error parsing JSON: %@", error);
    }
}


- (NSMutableArray*) findAllFood
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ID, food_name, calories, brand_name, amount, meal_type, date, amount_units from foodLog order by date(date) DESC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *row = [[NSMutableArray alloc] init];
                NSString *logID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                [row addObject:logID];
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [row addObject:name];
                NSString *amount = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 4)];
                [row addObject:amount];
                [resultArray addObject:row];
            }
            return resultArray;
            /*
            else{
                NSLog(@"Not found");
                return nil;
            }*/
            sqlite3_reset(statement);
        }
    }
    return nil;
}


- (NSMutableArray*) findAllFitness
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ID, distance, name, calories, distance_units, duration, start_date, start_time from fitnessLog order by date(start_date) DESC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *row = [[NSMutableArray alloc] init];
                NSString *logID = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                [row addObject:logID];
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [row addObject:name];
                NSString *distance = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                [row addObject:distance];
                NSString *distance_units = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                [row addObject:distance_units];
                [resultArray addObject:row];
            }
            return resultArray;
            /*
             else{
             NSLog(@"Not found");
             return nil;
             }*/
            sqlite3_reset(statement);
        }
    }
    return nil;
}


- (NSMutableArray*) findAllMeasurement
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select ID, date, amount, type, time from fitnessMeasurement order by date(date) DESC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *row = [[NSMutableArray alloc] init];
                NSString *logID = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                [row addObject:logID];
                NSString *amount = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [row addObject:amount];
                NSString *type = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 3)];
                [row addObject:type];
                NSString *date = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [row addObject:date];
                [resultArray addObject:row];
            }
            return resultArray;
            /*
             else{
             NSLog(@"Not found");
             return nil;
             }*/
            sqlite3_reset(statement);
        }
    }
    return nil;
}

- (BOOL) deleteFood:(NSString*)logID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM foodLog where ID = \"%@\"", logID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                PFQuery *query = [PFQuery queryWithClassName:@"FoodObject"];
                [query getObjectInBackgroundWithId:logID block:^(PFObject *foodObject, NSError *error) {
                    // Do something with the returned PFObject in the gameScore variable.
                    NSLog(@"%@", foodObject);
                    [foodObject deleteInBackground];
                }];
                //  NSLog( @"row id = %d", (sqlite3_last_insert_rowid(database)+1));
                NSLog(@"No Error");
            }
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (BOOL) deleteFitness:(NSString*)logID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM fitnessLog where ID = \"%@\"", logID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                PFQuery *query = [PFQuery queryWithClassName:@"FitnessObject"];
                [query getObjectInBackgroundWithId:logID block:^(PFObject *fitnessObject, NSError *error) {
                    // Do something with the returned PFObject in the gameScore variable.
                    NSLog(@"%@", fitnessObject);
                    [fitnessObject deleteInBackground];
                }];
                //  NSLog( @"row id = %d", (sqlite3_last_insert_rowid(database)+1));
                NSLog(@"No Error");
            }
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (BOOL) deleteMeasurement:(NSString*)logID
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM fitnessMeasurement where ID = \"%@\"", logID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                PFQuery *query = [PFQuery queryWithClassName:@"MeasurementObject"];
                [query getObjectInBackgroundWithId:logID block:^(PFObject *measurementObject, NSError *error) {
                    // Do something with the returned PFObject in the gameScore variable.
                    NSLog(@"%@", measurementObject);
                    [measurementObject deleteInBackground];
                }];
                //  NSLog( @"row id = %d", (sqlite3_last_insert_rowid(database)+1));
                NSLog(@"No Error");
            }
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}


-(void)createEmail:(NSString*)email {
    _email = [[NSString stringWithFormat:@"%@",email] lowercaseString];
}

-(NSString*)getEmail {
    return _email;
}

-(void)createFitbit:(NSDictionary*)fitbitdata {
    _fitbitData = fitbitdata;
}

-(NSDictionary*)getFitbit {
    return _fitbitData;
}

@end