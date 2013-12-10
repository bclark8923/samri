//
//  fvSignUpViewController.h
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fvSignUpViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField *userName;
    UITextField *password;
    
    UIButton *signUp;
    UIButton *cancelSignUp;
}

@end
