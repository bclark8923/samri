#import <objc/runtime.h>
#import "swizzleAnalytics.h"

Boolean AppTouched = false;     // provide a global for touch detection

static IMP iosBeginTouch = nil; // avoid lookup every time through
//static IMP iosEndedTouch = nil;
//static IMP iosCancelledTouch = nil;



@implementation  UIApplication (sendEventDetector)
- (void)sendEventDetector:(UIEvent *)event {
    
    NSLog(@"Event");
    
    return;
}
@end

// implement detectors for UIView
@implementation  UIView (touchesBeganDetector)
- (void)touchesBeganDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppTouched = true;
    
    //id result = [self touchesBeganDetector:touches withEvent:event];
    
    NSLog(@"Touch Began");
    
    if ( iosBeginTouch == nil ) {
        iosBeginTouch = [self methodForSelector:
                         @selector(touchesBeganDetector:withEvent:)];
        /*NSLog(@"Touch event: %@", event);
        NSArray *array = [event.allTouches allObjects];
        UITouch *touch = array[0];
        UIView *touchedView = touch.view;*/
        
    }
    
    //return result;
    //[self touchesBegan:touches withEvent:event];
    return;
    //iosBeginTouch( self, @selector(touchesBegan:withEvent:), touches, event );
}
@end

@implementation  UIView (touchesMovedDetector)
- (void)touchesMovedDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppTouched = true;
    
    //id result = [self touchesBeganDetector:touches withEvent:event];
    
    NSLog(@"Touch Moved");
    
    if ( iosBeginTouch == nil ) {
        iosBeginTouch = [self methodForSelector:
                         @selector(touchesMovedDetector:withEvent:)];
        /*NSLog(@"Touch event: %@", event);
         NSArray *array = [event.allTouches allObjects];
         UITouch *touch = array[0];
         UIView *touchedView = touch.view;*/
        
    }
    
    //return result;
    //[self touchesBegan:touches withEvent:event];
    return;
    //iosBeginTouch( self, @selector(touchesBegan:withEvent:), touches, event );
}
@end

@implementation  UIView (touchesEndedDetector)
- (void)touchesEndedDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppTouched = false;
    
    NSLog(@"Touch Ended");
    /*if ( iosEndedTouch == nil ) {
        iosEndedTouch = [self methodForSelector:
                         @selector(touchesEndedDetector:withEvent:)];
        NSLog(@"Touch event: %@", event);
        NSArray *array = [event.allTouches allObjects];
        UITouch *touch = array[0];
        UIView *touchedView = touch.view;
        
    }*/
    
    return;
    
    [self touchesEnded:touches withEvent:event];
}
@end

@implementation  UIView (touchesCancledDetector)
- (void)touchesCancelledDetector:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppTouched = false;
    
    NSLog(@"Touch Cancelled");
    /*
    if ( iosCancelledTouch == nil ) {
        iosCancelledTouch = [self methodForSelector:
                         @selector(touchesCancledDetector:withEvent:)];
        NSLog(@"Touch event: %@", event);
        NSArray *array = [event.allTouches allObjects];
        UITouch *touch = array[0];
        UIView *touchedView = touch.view;
        
    }*/
    
    return;
    
    [self touchesCancelled:touches withEvent:event];
}
@end

// http://stackoverflow.com/questions/1637604/method-swizzle-on-iphone-device
static void Swizzle(Class c, SEL orig, SEL repl )
{
    Method origMethod = class_getInstanceMethod(c, orig );
    Method newMethod  = class_getInstanceMethod(c, repl );
    
    if(class_addMethod( c, orig, method_getImplementation(newMethod),
                       method_getTypeEncoding(newMethod)) )
        
        class_replaceMethod( c, repl, method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod) );
    else
        method_exchangeImplementations( origMethod, newMethod );
}

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
    
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


@implementation swizzleAnalytics

- (id) init
{
    if ( ! [ super init ] )
        return nil;
    
    SEL rep = @selector( touchesBeganDetector:withEvent: );
    SEL orig = @selector( touchesBegan:withEvent: );
    Swizzle( [UIView class], orig, rep );
    
    rep = @selector( touchesMovedDetector:withEvent: );
    orig = @selector( touchesMoved:withEvent: );
    Swizzle( [UIView class], orig, rep );
    
    rep = @selector( touchesEndedDetector:withEvent: );
    orig = @selector( touchesEnded:withEvent: );
    Swizzle( [UIView class], orig, rep );
    
    rep = @selector( touchesCancelledDetector:withEvent: );
    orig = @selector( touchesCancelled:withEvent: );
    Swizzle( [UIView class], orig, rep );
    
    rep = @selector( sendEventDetector: );
    orig = @selector( sendEvent: );
    Swizzle( [UIApplication class], orig, rep );
    
    return self;
}
@end