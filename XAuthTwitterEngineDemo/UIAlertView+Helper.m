//
//  UIAlertViewHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/16/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "UIAlertView+Helper.h"

void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle) {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil 
										  cancelButtonTitle:dismissButtonTitle
										  otherButtonTitles:nil
						  ];
	[alert show];
	[alert autorelease];
}


@implementation UIAlertView (Helper)

@end
