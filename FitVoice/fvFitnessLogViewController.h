//
//  fvFitnessLogViewController.h
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fvFitnessLogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *results;
    NSString *logType;
}

@property (nonatomic, retain) UITableView *tableView;

@end
