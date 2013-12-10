//
//  FitnessLogObject.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitnessLogObject : NSObject

@property   int         ID;
@property   float       distance;
@property   NSString*   name;
@property   float       calories;
@property   NSString*   distance_units;
@property   float       duration;
@property   NSString*   start_date;
@property   NSString*   start_time;
@property    NSString*   email;

@end
