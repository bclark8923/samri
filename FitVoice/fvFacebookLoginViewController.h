//
//  fvFacebookLoginViewController.h
//  FitVoice
//
//  Created by Brian Clark on 11/18/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fvFacebookLoginViewController : UIViewController <UINavigationBarDelegate> {
    int retryCount;
    UIView *loadingView;
    UIImage *samriLogo;
    UIImageView *samriLogoImageView;
    
    UIButton *signUp;
    UIButton *login;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

- (IBAction)fbLogin: (id)sender;

@end
