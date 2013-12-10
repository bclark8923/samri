//
//  fvTabBarViewController.m
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvTabBarViewController.h"
#import "sysVersion.h"

@interface fvTabBarViewController ()

@end

@implementation fvTabBarViewController

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
    
    [self setSelectedIndex:2];
    //[[UITabBar appearance] setTranslucent:NO];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    } else {
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
