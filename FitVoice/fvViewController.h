//
//  fvViewController.h
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QueryObject.h"
#import "FoodLogObject.h"
#import "FitnessLogObject.h"
#import "FitnessMeasurementObject.h"

@interface fvViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, UIAlertViewDelegate, UITableViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
    
    NSMutableArray *books;
    NSMutableData *responseData;
    NSDictionary *actionResponse;
    NSDictionary *fitbitData;
    
    QueryObject *newQuery;
    FoodLogObject *newFoodLog;
    FitnessLogObject *newFitnessLog;
    FitnessMeasurementObject *newFitnessMeasurement;
    BOOL showReward;
    BOOL locationLoaded;
    
    UIView *rewardView;
    UIImageView *charityPrizeView;
    UIImageView *rewardPrizeView;
    UIButton *closeButton;
    
    NSString *chatterPost;
    
    BOOL touchStop;
    BOOL fitbitActive;
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
    
    UIAlertView *textInputAlertView;
    UIButton *textInputButton;
    
    UIAlertView *processingVoiceAlert;
}

@property (nonatomic, assign) BOOL _chatterIsEnabled;

@property (retain, nonatomic) IBOutlet UIButton *recordButton;

@property (retain, nonatomic) IBOutlet UIButton *fitnessLogButton;
@property (retain, nonatomic) IBOutlet UIButton *foodLogButton;
@property (retain, nonatomic) IBOutlet UIButton *fitnessMeasurementButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
