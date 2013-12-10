//
//  fvFitBitViewController.m
//  FitVoice
//
//  Created by Brian Clark on 11/20/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvFitBitViewController.h"
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>

@interface fvFitBitViewController ()

@end

@implementation fvFitBitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
        fbdata = [[DBManager getSharedInstance] getFitbit];
        
        NSDictionary *innerData = [fbdata objectForKey:@"data"];
        
        
        NSString* name = [innerData objectForKey:@"displayName"];
        NSString* steps = @"5,302";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(closeView:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"X" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:30];
        button.frame = CGRectMake(self.view.frame.size.width - 40, 25, 30, 30);
        [self.view addSubview:button];
        
        int spacer = 60;
        CGRect tableFrame = CGRectMake(0, spacer, self.view.frame.size.width, self.view.frame.size.height - spacer);
        UIView *innerView = [[UIView alloc] initWithFrame:tableFrame];
        [innerView setBackgroundColor:[UIColor whiteColor]];
        
        
        NSString* avatar = [innerData objectForKey:@"avatar"];
        NSURL *imageURL = [NSURL URLWithString:avatar];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *imv = [[UIImageView alloc] initWithImage:image];
        imv.frame = CGRectMake(self.view.frame.size.width/2 - 75, 50, 150, 150);
        imv.layer.cornerRadius = 75;
        imv.clipsToBounds = YES;
        [innerView addSubview:imv];
        
        
        UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40) ];
        scoreLabel.textAlignment =  NSTextAlignmentCenter;
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:(26.0)];
            scoreLabel.text = [NSString stringWithFormat: @"FITBIT"];
        [self.view addSubview:scoreLabel];
        
        
        UILabel *nameLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 275, self.view.frame.size.width, 50) ];
        nameLabel.textAlignment =  NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:(26.0)];
        nameLabel.text = [NSString stringWithFormat:@"%@",name];
        [innerView addSubview:nameLabel];
        
        
        UILabel *stepsLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 325, self.view.frame.size.width, 50) ];
        stepsLabel.textAlignment =  NSTextAlignmentCenter;
        stepsLabel.textColor = [UIColor blackColor];
        stepsLabel.backgroundColor = [UIColor clearColor];
        stepsLabel.font = [UIFont fontWithName:@"Helvetica" size:(26.0)];
        stepsLabel.text = [NSString stringWithFormat:@"%@ Steps Today",steps];
        [innerView addSubview:stepsLabel];
        
        [self.view addSubview:innerView];
        
        
    }
    return self;
}

-(void) closeView:(id) sender {
    //fvViewController *myNewVC = [[fvViewController alloc] init];
    
    // do any setup you need for myNewVC
    //[self.navigationController pushViewController:myNewVC animated:YES];
    
    //[self presentViewController:myNewVC animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
