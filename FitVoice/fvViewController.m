//
//  fvViewController.m
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvViewController.h"
#import "QueryObject.h"
#import "FoodLogObject.h"
#import "FitnessLogObject.h"
#import "FitnessMeasurementObject.h"
#import "DBManager.h"
#import <Parse/Parse.h>
#import <objc/runtime.h>

#define METERS_PER_MILE 1609.344

@interface fvViewController ()

@end

const unsigned char SpeechKitApplicationKey[] = {0xce, 0x1e, 0x69, 0x7e, 0x3c, 0xfd, 0xe0, 0xe7, 0xcf, 0xb1, 0x77, 0xe1, 0x0d, 0xe9, 0x8b, 0x19, 0x18, 0xa0, 0x1b, 0x45, 0xef, 0xc2, 0x6c, 0x7d, 0x61, 0x26, 0x04, 0xfc, 0x7b, 0xea, 0x82, 0x49, 0x08, 0xeb, 0xc8, 0x44, 0xe8, 0xa8, 0x2b, 0xb7, 0x5a, 0xa3, 0x98, 0x67, 0x8c, 0x24, 0x81, 0xa4, 0xc4, 0x9c, 0xe9, 0xb3, 0x5f, 0x56, 0x31, 0xc0, 0x7c, 0x35, 0xbc, 0xf7, 0x1f, 0x3e, 0x40, 0x27};

const char MyConstantKey;

@implementation fvViewController

@synthesize recordButton;
@synthesize _chatterIsEnabled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    touchStop = NO;
    locationLoaded = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    recordButton.layer.cornerRadius = 70; // this value vary as per your desire
    recordButton.clipsToBounds = YES;
    
    [recordButton setBackgroundImage:[UIImage imageNamed:@"RecordButtonClearRed.png"] forState:UIControlStateNormal];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"RecordButtonClearRed.png"] forState:UIControlStateHighlighted];
    
    [SpeechKit setupWithID:@"NMDPTRIAL_bclark892320131113234539"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
    [[DBManager getSharedInstance] createDB];
    
    textInputAlertView = [[UIAlertView alloc] initWithTitle:@"Record\n\n\n\n\n\n\n"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Disagree"
                                     otherButtonTitles:@"Agree",nil];
    textInputAlertView.alertViewStyle = UIAlertViewStyleDefault;
    
    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 30.0, 245.0, 25.0)];
    
    //[myTextView setTextAlignment:NSTextAlignmentLeft];
    //[myTextView setEditable:NO];
    
    /*myTextView.layer.borderWidth = 2.0f;
    myTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    myTextView.layer.cornerRadius = 13;
    myTextView.clipsToBounds = YES ;*/
    
    //[myTextView setText:@"LONG LONG TEXT"];
    
    [textInputAlertView addSubview:myTextView];
    [textInputAlertView setTag:10];
    
    textInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textInputButton.frame = CGRectMake(20, 20, 50, 50);
    [textInputButton setTitle:@"+" forState:UIControlStateNormal];
    [textInputButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [textInputButton addTarget:self action:@selector(showInputView:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:textInputButton];
    
    processingVoiceAlert = [[UIAlertView alloc] initWithTitle:@"Processing"
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    locationLoaded = NO;
}

- (void)showInputView:(id)sender {
    [textInputAlertView show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    location = [locations lastObject];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude= location.coordinate.longitude;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    if(!locationLoaded) {
        [_mapView setRegion:viewRegion animated:YES];
        locationLoaded = YES;
    }
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}
*/

- (IBAction)recordButtonAction: (id)sender {
    
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
        touchStop = YES;
    }
    else if (transactionState == TS_IDLE) {
        newQuery = [QueryObject alloc];
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
		//alternativesDisplay.text = @"";
        
        //if (recognitionType.selectedSegmentIndex == 0) {
            /* 'Search' is selected */
            detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
            recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        //}
        //else {
            /* 'Dictation' is selected */
            //detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
            //recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        //}
        
        /* Nuance can also create a custom recognition type optimized for your application if neither search nor dictation are appropriate. */
        
        NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:@"en_US"
                                                delegate:self];
    }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    [processingVoiceAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
	voiceSearch = nil;
}


#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");

    [recordButton setTitle:@"Recording" forState:UIControlStateNormal];
    [recordButton setTitle:@"Recording" forState:UIControlStateHighlighted];
    [recordButton setTitle:@"Recording" forState:UIControlStateSelected];
    
    transactionState = TS_RECORDING;
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");

    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton setTitle:@"Record" forState:UIControlStateHighlighted];
    [recordButton setTitle:@"Record" forState:UIControlStateSelected];
    [recordButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal|UIControlStateSelected|UIControlStateHighlighted)];
    
    transactionState = TS_PROCESSING;
    [processingVoiceAlert show];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [processingVoiceAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    if (numOfResults > 1 && false) {
        //show all possible
        dictationResults = results.results;
        NSLog(@"MULTIPLE USING FIRST: %@", [results firstResult]);//searchBox.text = [results firstResult];
        newQuery.query = [NSString stringWithFormat:@"%@", [results firstResult]];
        NSString *filteredResults = [[results firstResult] stringByReplacingOccurrencesOfString:@" "
                                                                                     withString:@"+"];
        //[self logAction:filteredResults];
        
        newQuery.query = [NSString stringWithFormat:@"%@", [results firstResult]];
        newQuery.email = [[DBManager getSharedInstance] getEmail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Correct?"
                                                        message:@"\n\n\n\n\n\n\n"
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:nil];
        
        UITableView* myView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 264, 150)
                                                           style:UITableViewStyleGrouped];
        myView.delegate = self;
        myView.dataSource = self;
        myView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myView];
        
        //alert.tag = 1;
        //[alert show];
        objc_setAssociatedObject(alert, &MyConstantKey, filteredResults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    } else {
        NSLog(@"%@", [results firstResult]);//searchBox.text = [results firstResult];
        newQuery.query = [NSString stringWithFormat:@"%@", [results firstResult]];
        NSString *filteredResults = [[results firstResult] stringByReplacingOccurrencesOfString:@" "
                                                                                     withString:@"+"];
        //[self logAction:filteredResults];
        //NSLog(@"%@", filteredResults);
        
        newQuery.query = [NSString stringWithFormat:@"%@", [results firstResult]];
        newQuery.email = [[DBManager getSharedInstance] getEmail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Correct?"
                                                        message:[results firstResult]
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = 1;
        [alert show];
        objc_setAssociatedObject(alert, &MyConstantKey, filteredResults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    
	/*if (numOfResults > 1)
		alternativesDisplay.text = [[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"];*/
    
    if (results.suggestion && touchStop == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    touchStop = NO;
    
	voiceSearch = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Clicked");
    if(alertView.tag == 1) {
        NSLog(@"alert view retry");
        if(buttonIndex == 1) {
            NSString *associatedString = objc_getAssociatedObject(alertView, &MyConstantKey);

            [self logAction:associatedString];
            [processingVoiceAlert show];
        }
    }
    if(alertView.tag == 2) {
        if(buttonIndex == 1) {
            PFObject *unsupportedQuery = [PFObject objectWithClassName:@"IncorrectSave"];
            [unsupportedQuery setObject:newQuery.query forKey:@"question"];
            [unsupportedQuery setObject:newQuery.json forKey:@"response"];
            [unsupportedQuery save];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                              message:@"Our team has been notified and is working on improving Samri!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
}

- (void)logAction: (NSString*) query {
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024*64];
    NSTimeInterval request_timeout = 60.0;
    
    NSString *api = @"http://casper-cached.stremor-nli.appspot.com/v1?query=";
    NSString *apiCall = [api stringByAppendingString:query];
    NSURL *url = [NSURL URLWithString:apiCall];
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
    [processingVoiceAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection success");
    NSError *error = nil;
    
    [processingVoiceAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    actionResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (!actionResponse) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        NSLog(@"%@", actionResponse);

        NSDictionary *queryType = [actionResponse objectForKey:@"model"];
        NSDictionary *payload = [actionResponse objectForKey:@"payload"];
        NSLog(@"%@", queryType);
        NSString *result = @"Query Saved";
        NSString *title = @"Result";
        newQuery.json = [NSString stringWithFormat:@"%@", actionResponse];
        newQuery.model = [NSString stringWithFormat:@"%@", queryType];
        newQuery.email = [[DBManager getSharedInstance] getEmail];
        if([newQuery.model isEqualToString:@"food_log"]) {
            newFoodLog = [FoodLogObject alloc];
            newFoodLog.email = [[DBManager getSharedInstance] getEmail];
            //NSLog([payload objectForKey:@"food_name"]);
            
            float amount = 0;
            NSString *amountStr = [payload objectForKey:@"amount"];
            if(![amountStr isKindOfClass: [NSNull class]]) {
                amount = [amountStr floatValue];
            }
            float calories = 0;
            NSString *calorieStr = [payload objectForKey:@"calories"];
            if(![calorieStr isKindOfClass: [NSNull class]]) {
                calories = [calorieStr floatValue];
            }
            
            newFoodLog.amount = amount;
            newFoodLog.amount_units = [payload objectForKey:@"amount_units"];
            newFoodLog.brand_name = [payload objectForKey:@"brand_name"];
            newFoodLog.calories = calories;
            newFoodLog.date = [payload objectForKey:@"date"];
            newFoodLog.food_name = [payload objectForKey:@"food_name"];
            newFoodLog.meal_type = [payload objectForKey:@"meal_type"];
            
            NSDateFormatter *formatter;
            NSString        *dateString;
            
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            if([newFoodLog.date isKindOfClass:[NSDictionary class]]) {

                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
                
                [components setHour:-[components hour]];
                [components setMinute:-[components minute]];
                [components setSecond:-[components second]];
                NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
                
                NSDictionary *dateObject = [payload objectForKey:@"date"];
                NSMutableArray *dateInfo = [dateObject objectForKey:@"#date_add"];
                int dateChange = [[dateInfo objectAtIndex:1] integerValue] * 24;
                
                [components setHour:dateChange];
                [components setMinute:0];
                [components setSecond:0];
                NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
                
                dateString = [formatter stringFromDate:yesterday];
            } else {
                dateString = [formatter stringFromDate:[NSDate date]];
            }
            newFoodLog.date = dateString;
            
            NSString* foodID = [[DBManager getSharedInstance] saveFoodLog:newFoodLog];
            if(![foodID isEqualToString:@"-1"]) {
                newQuery.modelID = foodID;
                title = @"Food";
                result = [NSString stringWithFormat:@"%1.f %@ food saved", newFoodLog.amount, newFoodLog.food_name];
            } else {
                //error
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Result"
                                                                  message:@"Error saving to database"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        } else if([newQuery.model isEqualToString:@"fitness_log"]) {
            newFitnessLog = [FitnessLogObject alloc];
            newFitnessLog.email = [[DBManager getSharedInstance] getEmail];
            //create fitness log item, save to dictionary, set newquery.modelID
            
            
            float distance = 0;
            NSString *distanceStr = [payload objectForKey:@"distance"];
            if(![distanceStr isKindOfClass: [NSNull class]]) {
                distance = [distanceStr floatValue];
            }
            float calories = 0;
            NSString *calorieStr = [payload objectForKey:@"calories"];
            if(![calorieStr isKindOfClass: [NSNull class]]) {
                calories = [calorieStr floatValue];
            }
            float duration = 0;
            NSString *durationStr = [payload objectForKey:@"duration"];
            if(![durationStr isKindOfClass: [NSNull class]]) {
                duration = [durationStr floatValue];
            }
            
            
            newFitnessLog.distance = distance;
            newFitnessLog.name = [payload objectForKey:@"name"];
            newFitnessLog.calories = calories;
            newFitnessLog.distance_units = [payload objectForKey:@"distance_units"];
            newFitnessLog.duration = duration;
            newFitnessLog.start_date = [payload objectForKey:@"start_date"];
            newFitnessLog.start_time = [payload objectForKey:@"start_time"];
            
            //if([newFitnessLog.start_date isEqualToString:@"#date_now"]) {
            NSDateFormatter *formatter;
            NSString        *dateString;
            
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            dateString = [formatter stringFromDate:[NSDate date]];
            
            newFitnessLog.start_date = dateString;
            //}
            
            NSString* fitnessID = [[DBManager getSharedInstance] saveFitnessLog:newFitnessLog];
            if(![fitnessID isEqualToString:@"-1"]) {
                newQuery.modelID = fitnessID;
                result = [NSString stringWithFormat:@"%1.f %@ %@ workout saved", newFitnessLog.distance, newFitnessLog.distance_units, newFitnessLog.name];
                chatterPost = [NSString stringWithFormat:@"Just %@ %1.f %@! (via Samri fit tracker)",  newFitnessLog.name, newFitnessLog.distance, newFitnessLog.distance_units];
                
                title = @"Activity";
            } else {
                //error
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Result"
                                                                  message:@"Error saving to database"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        } else if([newQuery.model isEqualToString:@"fitness_measurement"]) {
            newFitnessMeasurement = [FitnessMeasurementObject alloc];
            newFitnessMeasurement.email = [[DBManager getSharedInstance] getEmail];
            //create fitness measurement item, save to dictionary, set newquery.modelID
            
            float amount = 0;
            NSString *amountStr = [payload objectForKey:@"amount"];
            if(![amountStr isKindOfClass: [NSNull class]]) {
                amount = [amountStr floatValue];
            }
            
            newFitnessMeasurement.date = [payload objectForKey:@"date"];
            newFitnessMeasurement.amount = amount;
            newFitnessMeasurement.type = [payload objectForKey:@"type"];
            newFitnessMeasurement.time = [payload objectForKey:@"time"];
            
            if([newFitnessMeasurement.type isEqualToString:@"weight"]) {
                
                NSDateFormatter *formatter;
                NSString        *dateString;
                
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                
                dateString = [formatter stringFromDate:[NSDate date]];
                
                newFitnessMeasurement.date = dateString;
                
                NSString* fitnessID = [[DBManager getSharedInstance] saveFitnessMeasurement:newFitnessMeasurement];
                if(![fitnessID isEqualToString:@"-1"]) {
                    newQuery.modelID = fitnessID;
                    result = [NSString stringWithFormat:@"%1.f %@ measurement saved", newFitnessMeasurement.amount, newFitnessMeasurement.type];
                    title = @"Measurement";
                } else {
                    //error
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Result"
                                                                      message:@"Error saving to database"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            } else {
                //invalid
                newQuery.modelID = @"-1";
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Result"
                                                                  message:@"Sorry we don't support tracking that right now. Our team has been notified!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
                
                PFObject *unsupportedQuery = [PFObject objectWithClassName:@"UnsupportedQuery"];
                [unsupportedQuery setObject:newQuery.query forKey:@"question"];
                [unsupportedQuery setObject:newQuery.json forKey:@"response"];
                [unsupportedQuery save];
            }

        } else {
            //invalid
            newQuery.modelID = @"-1";
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Result"
                                                              message:@"Sorry we don't support tracking that right now. Our team has been notified!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
            PFObject *unsupportedQuery = [PFObject objectWithClassName:@"UnsupportedQuery"];
            [unsupportedQuery setObject:newQuery.query forKey:@"question"];
            [unsupportedQuery setObject:newQuery.json forKey:@"response"];
            [unsupportedQuery save];
        }
        
        [[DBManager getSharedInstance] saveQuery:newQuery];
        
        if(![newQuery.modelID isEqualToString:@"-1"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                                  message:result
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:@"Incorrect", nil];
            message.tag = 2;
            [message show];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    
    int index = [indexPath indexAtPosition:1];
    NSString *readOptions = [NSString stringWithFormat:@"%@", [dictationResults objectAtIndex:index]];
    //NSString *readOptions = [NSString stringWithFormat:@"%@", [object objectAtIndex:2]];
    [[cell textLabel] setText:readOptions];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dictationResults count];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
