//
//  DrawingViewController.h
//  AnnoTree Viewer
//
//  Created by Brian Clark on 6/7/13.
//  Copyright (c) 2013 AnnoTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationView.h"

@interface DrawingViewController : UIViewController

@property (nonatomic, retain) AnnotationView *drawScreen;

-(void) setDrawingEnabled:(BOOL)enabled;
-(void) setTextEnabled:(BOOL)enabled;
-(void) setDrawColor:(UIColor *) color;
-(void) setTextColor:(UIColor *) color;
-(void) clearAll;
-(void) setLineWidth:(int)width;
-(void) setTextSize:(int)size;

@end
