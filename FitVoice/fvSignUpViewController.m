//
//  fvSignUpViewController.m
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvSignUpViewController.h"
#import "DBManager.h"
#import <Parse/Parse.h>

@interface fvSignUpViewController ()

@end

@implementation fvSignUpViewController

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
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 280, 50)];
    userName.placeholder = @"Email";
    userName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(16.0)];
    userName.layer.masksToBounds=YES;
    userName.layer.borderColor=[[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]CGColor];
    userName.layer.borderWidth= 1.0f;
    [userName setKeyboardType:UIKeyboardTypeEmailAddress];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    userName.leftView = paddingView;
    userName.leftViewMode = UITextFieldViewModeAlways;
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [userName becomeFirstResponder];
    [self.view addSubview:userName];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(20, 149, 280, 50)];
    password.secureTextEntry = YES;
    password.placeholder = @"Password";
    password.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(16.0)];
    password.layer.masksToBounds=YES;
    password.layer.borderColor=[[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]CGColor];
    password.layer.borderWidth= 1.0f;
    UIView *paddingViewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    password.leftView = paddingViewPassword;
    password.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:password];
    
    signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    float buttonWidth = 200;
    signUp.frame = CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, 220, buttonWidth, 50);
    [signUp setTitle:@"Create Account" forState:UIControlStateNormal];
    signUp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(22.0)];
    signUp.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    [signUp addTarget:self action:@selector(setCustomButtonForDown:) forControlEvents:UIControlEventTouchDown];
    [signUp addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [signUp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    signUp.layer.cornerRadius = 3; // this value vary as per your desire
    //signUp.clipsToBounds = YES;
    [self.view addSubview:signUp];
    
    cancelSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    float cancelbuttonWidth = 100;
    cancelSignUp.frame = CGRectMake(self.view.frame.size.width/2 - cancelbuttonWidth/2, 265, cancelbuttonWidth, 50);
    [cancelSignUp setTitle:@"Back to Main" forState:UIControlStateNormal];
    cancelSignUp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(15.0)];
    cancelSignUp.backgroundColor = [UIColor clearColor];
    cancelSignUp.titleLabel.textColor = [UIColor grayColor];
    [cancelSignUp addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    cancelSignUp.layer.cornerRadius = 3; // this value vary as per your desire
    //signUp.clipsToBounds = YES;
    [self.view addSubview:cancelSignUp];
    
    /*UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar.topItem.title = @"SAMRI";
    
    //add the components to the view
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),64)];
    [self.view addSubview: navBar];*/
    
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50) ];
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(24.0)];
    
    scoreLabel.text = [NSString stringWithFormat: @"SAMRI"];
    [self.view addSubview:scoreLabel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == userName) {
        [password becomeFirstResponder];
    } else if (textField == password) {
        //HERE THE LOGIN CODE
        [self signUp:self];
    }
    return YES;
}

- (void)signUp:(id)sender {
    //return;
    [signUp setUserInteractionEnabled:NO];
    [signUp setEnabled:NO];
    PFUser *user = [PFUser user];
    user.username = [userName.text lowercaseString];
    user.password = password.text;
    user.email = [userName.text lowercaseString];
    
    //if(valid) {
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                [[DBManager getSharedInstance] createEmail:user.email];
                [self performSegueWithIdentifier: @"signUpSuccessful" sender:self];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sign Up Error"
                                                                  message:errorString
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Retry"
                                                        otherButtonTitles:nil];
                [message show];
            }
            [signUp setUserInteractionEnabled:YES];
            [signUp setEnabled:YES];
            [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
        }];
    //} else {
        
    //}
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
}

-(void)setCustomButtonForDown:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:199.0f/255.0f green:64.0f/255.0f blue:68.0f/255.0f alpha:1.0f]];
}

-(void)backToLogin:(id)sender {
    [self performSegueWithIdentifier: @"cancelSignUp" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
