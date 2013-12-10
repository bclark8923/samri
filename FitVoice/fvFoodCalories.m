//
//  fvFoodCalories.m
//  FitVoice
//
//  Created by Brian Clark on 11/20/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvFoodCalories.h"

@implementation fvFoodCalories

- (void)getCalories: (NSString*) json {
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024*64];
    NSTimeInterval request_timeout = 60.0;
    
    NSString *api = @"http://casper-cached.stremor-nli.appspot.com/v1";
    //NSString *apiCall = [api stringByAppendingString:query];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:request_timeout];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if(connection) {
        responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"connection failed");
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Connection didReceiveData of length: %u", data.length);
    
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString* theString = [error localizedDescription];
    NSLog(@"connection error: %@", theString);
}

@end
