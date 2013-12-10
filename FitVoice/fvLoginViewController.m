//
//  fvSignUpViewController.m
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvLoginViewController.h"
#import "DBManager.h"
#import <Parse/Parse.h>

@interface fvLoginViewController ()

@end

@implementation fvLoginViewController

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
    
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50) ];
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(32.0)];
    
    scoreLabel.text = [NSString stringWithFormat: @"SAMRI"];
    [self.view addSubview:scoreLabel];
    
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
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float buttonWidth = 200;
    loginButton.frame = CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, 220, buttonWidth, 50);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(22.0)];
    loginButton.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    [loginButton addTarget:self action:@selector(setCustomButtonForDown:) forControlEvents:UIControlEventTouchDown];
    [loginButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [loginButton addTarget:self action:@selector(loginWithParse:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 3; // this value vary as per your desire

    //signUp.clipsToBounds = YES;
    [self.view addSubview:loginButton];
    
    cancelLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    float cancelbuttonWidth = 100;
    cancelLogin.frame = CGRectMake(self.view.frame.size.width/2 - cancelbuttonWidth/2, 265, cancelbuttonWidth, 50);
    [cancelLogin setTitle:@"Back to Main" forState:UIControlStateNormal];
    cancelLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(15.0)];
    cancelLogin.backgroundColor = [UIColor clearColor];
    cancelLogin.titleLabel.textColor = [UIColor grayColor];
    [cancelLogin addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    cancelLogin.layer.cornerRadius = 3; // this value vary as per your desire
    //signUp.clipsToBounds = YES;
    [self.view addSubview:cancelLogin];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == userName) {
        [password becomeFirstResponder];
    } else if (textField == password) {
        //HERE THE LOGIN CODE
        [self loginWithParse:self];
    }
    return YES;
}

- (void)loginWithParse:(id)sender {
    
    //if(valid) {
    [loginButton setUserInteractionEnabled:NO];
    [loginButton setEnabled:NO];
    [PFUser logInWithUsernameInBackground:[userName.text lowercaseString] password:password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                        
                                            [[DBManager getSharedInstance] createEmail:user.email];
                                            [self performSegueWithIdentifier: @"loginSuccessful" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            // Show the errorString somewhere and let the user try again.
                                            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                                              message:errorString
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Retry"
                                                                                    otherButtonTitles:nil];
                                            [message show];
                                        }
                                        [sender setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
                                        [loginButton setUserInteractionEnabled:YES];
                                        [loginButton setEnabled:YES];
                                    }];
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
    [self performSegueWithIdentifier: @"cancelLogin" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
