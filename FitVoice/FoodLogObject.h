//
//  FoodLogObject.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodLogObject : NSObject

@property    int         ID;
@property    float       amount;
@property    NSString*   amount_units;
@property    NSString*   brand_name;
@property    float       calories;
@property    NSString*   date;
@property    NSString*   food_name;
@property    NSString*   meal_type;
@property    NSString*   email;

@end
