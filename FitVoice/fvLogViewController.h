//
//  fvLogViewController.h
//  FitVoice
//
//  Created by Brian Clark on 11/15/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fvLogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *results;
    NSString *logType;
}

@property (nonatomic, retain) UITableView *tableView;

- (id)initWithLog:(NSString*)log;

@end
