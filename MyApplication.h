//
//  MyApplication.h
//  FitVoice
//
//  Created by Brian Clark on 2/22/14.
//  Copyright (c) 2014 FitVoice. All rights reserved.
//

#ifndef FitVoice_MyApplication_h
#define FitVoice_MyApplication_h

@interface MyApplication : UIApplication
@end

@implementation MyApplication

- (void)sendEvent:(UIEvent *)event {
    //NSSet *touches = [event allTouches];
    //UITouch *oneTouch = [touches anyObject];
    //UIView *touchView = [oneTouch view];
    
    /*if(touches && oneTouch && touchView) {
        
    } else if(touches && oneTouch) {
        NSLog(@"Can't detect View");
    }*/
    
    if (event.type == UIEventTypeTouches) {
        NSLog(@"Touch event Time: %f", event.timestamp);
        // UITouch *touch = [event allTouches].anyObject;
        // if (touch.phase == UITouchPhaseBegan) {
            // Calling some methods
        // }
        // NSLog(@"Touches: %@", event.allTouches);
        NSArray *array = [event.allTouches allObjects];
        UITouch *touch = array[0];
        NSLog(@"Touch: %@", touch);
        NSLog(@"Gesture Recognizers: %@", touch.gestureRecognizers);
        UIView *touchedView = touch.view;
        if([touchedView isKindOfClass:[UIButton class]]) {
            //NSLog(@"Button");
            UIButton *pressedButton = (UIButton*)touch.view;
            NSString *buttonText = pressedButton.titleLabel.text;
            if(buttonText) NSLog(@"Text: %@", buttonText);
        }
        
    }
    [super sendEvent:event];
}

@end

#endif
