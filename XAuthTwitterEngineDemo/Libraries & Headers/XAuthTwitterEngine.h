//
//  XAuthTwitterEngine.h
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

#import "MGTwitterEngine.h"
#import "XAuthTwitterEngineDelegate.h"

@class OAToken;
@class OAConsumer;

@interface XAuthTwitterEngine : MGTwitterEngine {
	NSString	*_consumerSecret;
	NSString	*_consumerKey;
	NSURL		*_accessTokenURL;
			
@private
	OAToken		*_accessToken; 
	OAConsumer	*_consumer;
}

@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, readwrite, retain) NSString *consumerSecret, *consumerKey;
@property (nonatomic, readwrite, retain) NSURL *accessTokenURL;
@property (nonatomic, readonly) BOOL OAuthSetup;

+ (XAuthTwitterEngine *) XAuthTwitterEngineWithDelegate: (NSObject *) delegate;
- (XAuthTwitterEngine *) initXAuthWithDelegate: (NSObject *) delegate;
- (void) exchangeAccessTokenForUsername:(NSString *)username password:(NSString *)password;
- (BOOL) isAuthorized;

- (void) clearAccessToken;

@property (nonatomic, readonly) OAConsumer *consumer;

@end
