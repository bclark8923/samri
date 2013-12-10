//
//  QueryObject.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryObject : NSObject

@property    int         ID;
@property    NSString*   query;
@property    NSString*   json;
@property    NSString*   model;
@property    NSString*   modelID;
@property    NSString*   email;

@end
