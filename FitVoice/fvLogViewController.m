//
//  fvLogViewController.m
//  FitVoice
//
//  Created by Brian Clark on 11/15/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvLogViewController.h"
#import "fvViewController.h"
#import "DBManager.h"
#import "fvLogCell.h"

@interface fvLogViewController ()

@end

@implementation fvLogViewController

- (id)initWithLog:(NSString*)log
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSLog(@"%@",log);
        logType = log;
        if([logType isEqualToString:@"food"]) {
            results = [[DBManager getSharedInstance] findAllFood];
        }
        else if([logType isEqualToString:@"fitness"]) {
            results = [[DBManager getSharedInstance] findAllFitness];
        }
        else if([logType isEqualToString:@"measurement"]) {
            results = [[DBManager getSharedInstance] findAllMeasurement];
        }
        //[self.view setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:172.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
        [self.view setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
        int spacer = 65;
        CGRect tableFrame = CGRectMake(0, spacer, self.view.frame.size.width, self.view.frame.size.height - spacer);
        self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(closeView:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"X" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:30];
        button.frame = CGRectMake(self.view.frame.size.width - 40, 25, 30, 30);
        [self.view addSubview:button];
        
        UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40) ];
        scoreLabel.textAlignment =  NSTextAlignmentCenter;
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:(26.0)];
        
        if([logType isEqualToString:@"food"]) {
            scoreLabel.text = [NSString stringWithFormat: @"FOOD"];
        }
        else if([logType isEqualToString:@"fitness"]) {
            scoreLabel.text = [NSString stringWithFormat: @"FITNESS"];
        }
        else if([logType isEqualToString:@"measurement"]) {
            scoreLabel.text = [NSString stringWithFormat: @"MEASUREMENT"];
        }
        [self.view addSubview:scoreLabel];
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
        if([logType isEqualToString:@"food"]) {
            deleted = [[DBManager getSharedInstance] deleteFood:cell.objectId];
        }
        else if([logType isEqualToString:@"fitness"]) {
            deleted = [[DBManager getSharedInstance] deleteFitness:cell.objectId];
        }
        else if([logType isEqualToString:@"measurement"]) {
            deleted = [[DBManager getSharedInstance] deleteMeasurement:cell.objectId];
        }
        if(deleted) {
            [results removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    /*int spacer = 200;
    self.tableView.frame = CGRectMake(100, spacer, self.view.frame.size.width, self.view.frame.size.height - spacer);*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    fvLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[fvLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    int index = [indexPath indexAtPosition:1];
    NSMutableArray *object = [results objectAtIndex:index];
    cell.objectId = [object objectAtIndex:0];
    //NSLog(@"%d",cell.tag);
    if([logType isEqualToString:@"food"]) {
        NSString *foodText = [NSString stringWithFormat:@"%@ %@", [object objectAtIndex:2], [object objectAtIndex:1]];
        [[cell textLabel] setText:foodText];
    }
    else if([logType isEqualToString:@"fitness"]) {
        NSString *foodText = [NSString stringWithFormat:@"%@ %@ %@", [object objectAtIndex:1], [object objectAtIndex:2], [object objectAtIndex:3]];
        [[cell textLabel] setText:foodText];
    }
    else if([logType isEqualToString:@"measurement"]) {
        NSString *foodText = [NSString stringWithFormat:@"%@ %@", [object objectAtIndex:1], [object objectAtIndex:2]];
        [[cell textLabel] setText:foodText];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
