//
//  FitnessMeasurementObject.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitnessMeasurementObject : NSObject

@property    int         ID;
@property    NSString*   date;
@property    float       amount;
@property    NSString*   type;
@property    NSString*   time;
@property    NSString*   email;

@end
