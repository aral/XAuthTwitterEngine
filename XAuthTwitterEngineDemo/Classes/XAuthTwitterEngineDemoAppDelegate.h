//
//  XAuthTwitterEngineDemoAppDelegate.h
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 28/02/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XAuthTwitterEngineDemoViewController;

@interface XAuthTwitterEngineDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    XAuthTwitterEngineDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet XAuthTwitterEngineDemoViewController *viewController;

@end

