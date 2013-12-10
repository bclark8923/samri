//
//  fvMeasurementLogViewController.m
//  FitVoice
//
//  Created by Brian Clark on 12/2/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvMeasurementLogViewController.h"
#import "fvViewController.h"
#import "DBManager.h"
#import "fvLogCell.h"

@interface fvMeasurementLogViewController ()

@end

@implementation fvMeasurementLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        fvLogCell *cell = (fvLogCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@ %d", logType, cell.tag);
        BOOL deleted = NO;
        deleted = [[DBManager getSharedInstance] deleteMeasurement:cell.objectId];
        
        if(deleted) {
            [results removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        } else {
            NSLog(@"Error deleting measurement");
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    /*int spacer = 200;
     self.tableView.frame = CGRectMake(100, spacer, self.view.frame.size.width, self.view.frame.size.height - spacer);*/
    results = [[DBManager getSharedInstance] findAllMeasurement];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    results = [[DBManager getSharedInstance] findAllMeasurement];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:172.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    float tabBarHeight = [[[super tabBarController] tabBar] frame].size.height;
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    int spacer = 70;
    CGRect tableFrame = CGRectMake(0, spacer, self.view.frame.size.width, self.view.frame.size.height - spacer - tabBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = NO;
    [self.view addSubview:self.tableView];
    
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 40) ];
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(26.0)];
    
    scoreLabel.text = [NSString stringWithFormat: @"WEIGHT"];
    [self.view addSubview:scoreLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, spacer, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    [self.view addSubview:lineView];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.tableView.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [results count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    fvLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[fvLogCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    
    int index = [indexPath indexAtPosition:1];
    NSMutableArray *object = [results objectAtIndex:index];
    cell.objectId = [object objectAtIndex:0];
    NSString *measurementText = [NSString stringWithFormat:@"%@ lbs.", [object objectAtIndex:1]];
    [[cell textLabel] setText:measurementText];
    [[cell textLabel] setTextAlignment:NSTextAlignmentRight];
    [[cell textLabel] setTextColor:[UIColor grayColor]];
    [[cell textLabel] setFont:[ UIFont fontWithName: @"HelveticaNeue-Light" size: 35.0 ]];
    
    NSString *date = [object objectAtIndex:3];
    cell.detailTextLabel.text = date;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15.0];
    
    return cell;
}

@end