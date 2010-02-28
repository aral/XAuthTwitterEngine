//
//  XAuthTwitterEngineDelegate.h
//  
//  Created by Aral Balkan on 28/02/2010.
//  Copyright 2010 Naklab. All rights reserved.
//
//  Based on SA_OAuthTwitterEngine Ben Gottlieb.
//
//  Some code and concepts taken from examples provided by 
//  Matt Gemmell, Chris Kimpton, and Isaiah Carew
//  See ReadMe for further attributions, copyrights and license info.
//

@class OAToken;

@protocol XAuthTwitterEngineDelegate 
@optional

//
// Implement these methods to store off the credentials returned by Twitter.
// If you don't do this, the user will have to re-authenticate every time they run.

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username;
- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;

@end
