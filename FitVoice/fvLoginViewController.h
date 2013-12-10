//
//  fvLoginViewController.h
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fvLoginViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField *userName;
    UITextField *password;
    
    UIButton *loginButton;
    UIButton *cancelLogin;
}

@end
