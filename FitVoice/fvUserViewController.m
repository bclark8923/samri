//
//  fvUserViewController.m
//  FitVoice
//
//  Created by Brian Clark on 12/4/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvUserViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface fvUserViewController ()

@end

@implementation fvUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(100, self.view.frame.size.height - 180, self.view.frame.size.width - 200, 50);
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)];
    logoutButton.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    logoutButton.backgroundColor = [UIColor whiteColor];
    [[logoutButton layer] setBorderWidth:2.0f];
    [[logoutButton layer] setBorderColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f].CGColor];
    [logoutButton addTarget:self action:@selector(setCustomButtonForDown:) forControlEvents:UIControlEventTouchDown];
    [logoutButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitleColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    logoutButton.layer.cornerRadius = 3; // this value vary as per your desire
    //signUp.clipsToBounds = YES;
    [self.view addSubview:logoutButton];
    
    PFUser *user = [PFUser currentUser];
    facebookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookLoginButton.frame = CGRectMake(20, self.view.frame.size.height - 250, 280, 50);
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [facebookLoginButton setBackgroundImage:[UIImage imageNamed:@"FBConnect.png"]
                                       forState:UIControlStateNormal];
    } else {
        [facebookLoginButton setUserInteractionEnabled:NO];
        [facebookLoginButton setEnabled:NO];
        [facebookLoginButton setBackgroundImage:[UIImage imageNamed:@"FBConnect.png"]
                                       forState:UIControlStateNormal];
    }
    [facebookLoginButton addTarget:self action:@selector(fbConnect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookLoginButton];
}

- (void)fbConnect:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user logged in with Facebook!");
                [facebookLoginButton setEnabled:NO];
                [facebookLoginButton setUserInteractionEnabled:NO];
                [[[UIAlertView alloc] initWithTitle:@"Facebook Connect"
                                            message:@"Successfully connected!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            } else {
                [self handleAuthError:error];
            }
        }];
    } else {
        [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The user is no longer associated with their Facebook account.");
                [[[UIAlertView alloc] initWithTitle:@"Facebook Connect"
                                            message:@"Account Disconnected!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            } else {
                
                [[[UIAlertView alloc] initWithTitle:@"Facebook Connect"
                                            message:@"Error unlinking account!"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}


- (void)handleAuthError:(NSError *)error{
    
    NSString *alertMessage, *alertTitle;
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it.
        if ([[error userInfo][FBErrorLoginFailedReason]
             isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
            // Show a different error message
            alertTitle = @"App Disabled";
            alertMessage = @"Go to Settings > Facebook and turn ON Samri.";
            // Perform any additional customizations
        } else {
            // If the SDK has a message for the user, surface it.
            alertTitle = @"Something Went Wrong";
            alertMessage = error.fberrorUserMessage;
        }
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    [facebookLoginButton setUserInteractionEnabled:YES];
    [facebookLoginButton setEnabled:YES];}

- (void)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier: @"logoutSegue" sender:self];
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [sender setBackgroundColor:[UIColor whiteColor]];
}

-(void)setCustomButtonForDown:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:199.0f/255.0f green:64.0f/255.0f blue:68.0f/255.0f alpha:1.0f]];
    [sender setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
