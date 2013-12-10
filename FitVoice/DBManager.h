//
//  DBManager.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "QueryObject.h"
#import "FoodLogObject.h"
#import "FitnessLogObject.h"
#import "FitnessMeasurementObject.h"

@interface DBManager : NSObject
{
    NSString *databasePath;
    NSString *_email;
    NSDictionary *_fitbitData;
    NSMutableData *responseData;
    NSString *activeModelID;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(void)createEmail:(NSString*)email;
-(NSString*)getEmail;
-(void)createFitbit:(NSDictionary*)fitbitdata;
-(NSDictionary*)getFitbit;

- (BOOL) saveQuery:(QueryObject*)query;
- (NSString*) saveFoodLog:(FoodLogObject*)food;
- (NSString*) saveFitnessLog:(FitnessLogObject*)fitness;
- (NSString*) saveFitnessMeasurement:(FitnessMeasurementObject*)fitness;

- (NSMutableArray*) findAllFood;
- (NSMutableArray*) findAllFitness;
- (NSMutableArray*) findAllMeasurement;

- (BOOL) deleteFood:(NSString*)logID;
- (BOOL) deleteFitness:(NSString*)logID;
- (BOOL) deleteMeasurement:(NSString*)logID;

@end
