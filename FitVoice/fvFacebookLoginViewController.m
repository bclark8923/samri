//
//  fvFacebookLoginViewController.m
//  FitVoice
//
//  Created by Brian Clark on 11/18/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvFacebookLoginViewController.h"
#import "fvViewController.h"
#import "DBManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "fvSignUpViewController.h"
#import "fvAppDelegate.h"
#import <Parse/Parse.h>

@implementation fvFacebookLoginViewController

@synthesize facebookLoginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        retryCount = 0;
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    samriLogo = [UIImage imageNamed:@"SamriDefault.png"];
    samriLogoImageView = [[UIImageView alloc] initWithImage:samriLogo];
    float width = 259/2;
    float height = 295/2;
    samriLogoImageView.frame = CGRectMake(self.view.frame.size.width/2 - width/2, self.view.frame.size.height/2 - height/2 - 39, width, height);
    [self.view addSubview:samriLogoImageView];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        double delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [[DBManager getSharedInstance] createEmail:currentUser.email];
            [self performSegueWithIdentifier: @"loginSegue" sender: self];
        });
    } else {
        
        [UIView animateWithDuration:0.75f
                              delay:1.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {
                             samriLogoImageView.frame = CGRectMake(self.view.frame.size.width/2 - width/2, self.view.frame.size.height/2 - height/2 - 140, width, height);
                         }
                         completion:^(BOOL Finished){
                             
                             // show the signup or login screen
                             
                             
                             facebookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                             facebookLoginButton.frame = CGRectMake(20, self.view.frame.size.height - 250, 280, 50);
                             [facebookLoginButton setBackgroundImage:[UIImage imageNamed:@"FBConnect.png"]
                                                            forState:UIControlStateNormal];
                             [facebookLoginButton addTarget:self action:@selector(fbLogin:) forControlEvents:UIControlEventTouchUpInside];
                             [self.view addSubview:facebookLoginButton];
                             
                             signUp = [UIButton buttonWithType:UIButtonTypeCustom];
                             signUp.frame = CGRectMake(170, self.view.frame.size.height - 180, 130, 50);
                             [signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
                             signUp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)];
                             signUp.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
                             signUp.backgroundColor = [UIColor whiteColor];
                             [[signUp layer] setBorderWidth:2.0f];
                             [[signUp layer] setBorderColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f].CGColor];
                             [signUp addTarget:self action:@selector(setCustomButtonForDown:) forControlEvents:UIControlEventTouchDown];
                             [signUp addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
                             [signUp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
                             [signUp setTitleColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                             signUp.layer.cornerRadius = 3; // this value vary as per your desire
                             //signUp.clipsToBounds = YES;
                             [self.view addSubview:signUp];
                             
                             login = [UIButton buttonWithType:UIButtonTypeCustom];
                             login.frame = CGRectMake(20, self.view.frame.size.height - 180, 130, 50);
                             [login setTitle:@"Login" forState:UIControlStateNormal];
                             login.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)];
                             login.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
                             login.backgroundColor = [UIColor whiteColor];
                             [[login layer] setBorderWidth:2.0f];
                             [[login layer] setBorderColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f].CGColor];
                             [login addTarget:self action:@selector(setCustomButtonForDown:) forControlEvents:UIControlEventTouchDown];
                             [login addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
                             [login addTarget:self action:@selector(manualLogin:) forControlEvents:UIControlEventTouchUpInside];
                             [login setTitleColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                             
                             login.layer.cornerRadius = 3; // this value vary as per your desire
                             //login.clipsToBounds = YES;
                             [self.view addSubview:login];
                         }];
    }
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

-(void)signUp:(id)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [sender setBackgroundColor:[UIColor whiteColor]];
    [self performSegueWithIdentifier: @"manualSignUp" sender:self];
    
}

-(void)manualLogin:(id)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [sender setBackgroundColor:[UIColor whiteColor]];
    [self performSegueWithIdentifier: @"manualLogin" sender:self];
}

- (void)setupRootViewController
{
    //NSLog(@"%@",[user objectForKey:@"email"]);
    //[[DBManager getSharedInstance] createEmail:[user objectForKey:@"email"]];
    //fvViewController *myNewVC = [[fvViewController alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    fvViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"fvViewController"];
    
    // do any setup you need for myNewVC
    //[self.navigationController pushViewController:myNewVC animated:YES];
    
    [self presentViewController:lvc animated:YES completion:nil];
}

- (IBAction)fbLogin: (id)sender
{
    //[self.view addSubview:loadingView];
    [facebookLoginButton setUserInteractionEnabled:NO];
    [facebookLoginButton setEnabled:NO];
    [login setUserInteractionEnabled:NO];
    //[login setEnabled:NO];
    [signUp setUserInteractionEnabled:NO];
    //[signUp setEnabled:NO];
    
    NSArray *permissions =
    [NSArray arrayWithObjects:@"basic_info", @"email", nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [self handleAuthError:error];
        } else if (user.isNew) {
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
                NSLog(@"User is new");
                NSLog(@"Username: %@", user.username);
                NSLog(@"Email: %@", fbUser[@"email"]);
                NSLog(@"ID: %@", [user objectForKey:@"id"]);
                PFQuery *query = [PFUser query];
                [query whereKey:@"username" equalTo:[fbUser[@"email"] lowercaseString]];
                NSLog(@"%d",[query countObjects]);
                //if email exists, link accounts
                if([query countObjects] > 0) {
                    [user deleteInBackground];
                    [[FBSession activeSession] closeAndClearTokenInformation];
                    [[[UIAlertView alloc] initWithTitle:@"Account Exists"
                                                message:@"It looks like you already have an account. Sign in and then go to \"Me\" to link to Facebook."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                    [facebookLoginButton setUserInteractionEnabled:YES];
                    [facebookLoginButton setEnabled:YES];
                    [login setUserInteractionEnabled:YES];
                    [signUp setUserInteractionEnabled:YES];
                } else {
                    [self loginSuccess:fbUser[@"email"]];
                }
            }];
            //[self loginSuccess:[user objectForKey:@"email"]];
        } else {
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
                NSLog(@"User existed");
                NSLog(@"Username: %@", user.username);
                NSLog(@"Email: %@", fbUser[@"email"]);
                NSLog(@"ID: %@", [user objectForKey:@"id"]);
                PFQuery *query = [PFUser query];
                [query whereKey:@"username" equalTo:[fbUser[@"email"] lowercaseString]];
                NSLog(@"%d",[query countObjects]);
                [self loginSuccess:fbUser[@"email"]];
            }];
            //[self loginSuccess:[user objectForKey:@"email"]];
        }
    }];
    /*
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // handle success + failure in block
                                      if (FBSession.activeSession.isOpen) {
                                          [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                              if (!error) {
                                                  [self loginSuccess:[user objectForKey:@"email"]];
                                              } else {
                                                  [self handleAuthError:error];
                                                  
                                              }
                                          }];
                                      } else {
                                          [self handleAuthError:error];
                                      }
                                  }];
     */
}

- (void)loginSuccess:(NSString*)email {
    NSLog(@"%@",email);
    [[DBManager getSharedInstance] createEmail:email];
    
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    fvViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"fvViewController"];
    lvc._chatterIsEnabled = NO;
    
    [self presentViewController:lvc animated:YES completion:nil];*/
    [self performSegueWithIdentifier: @"loginSegue" sender: self];
    
    [loadingView removeFromSuperview];
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
    [loadingView removeFromSuperview];
    [facebookLoginButton setUserInteractionEnabled:YES];
    [facebookLoginButton setEnabled:YES];
    [login setUserInteractionEnabled:YES];
    //[login setEnabled:YES];
    [signUp setUserInteractionEnabled:YES];
    //[signUp setEnabled:YES];
    
    /*login.titleLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    signUp.titleLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];*/
}

// Helper method to handle errors during permissions request
- (void)handleRequestPermissionError:(NSError *)error
{
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it.
        [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong"
                                    message:error.fberrorUserMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        if (error.fberrorCategory == FBErrorCategoryUserCancelled){
            // The user has cancelled the request. You can inspect the value and
            // inner error for more context. Here we simply ignore it.
            NSLog(@"User cancelled post permissions.");
        } else {
            NSLog(@"Unexpected error requesting permissions:%@", error);
            [[[UIAlertView alloc] initWithTitle:@"Permission Error"
                                        message:@"Unable to request publish permissions"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}

- (void)loginViewController:(id)sender
              receivedError:(NSError *)error
{
    [self handleAuthError:error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
