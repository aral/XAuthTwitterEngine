//
//  ExchangeCredentialsOperation.h
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 10/03/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeCredentialsOperationDelegate.h"

@class OAConsumer;

@interface ExchangeCredentialsOperation : NSOperation {
	OAConsumer	*_consumer;
	NSString *_username;
	NSString *_password;
	
	id <ExchangeCredentialsOperationDelegate> _delegate;
}

@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) NSString *username, *password;
@property (nonatomic, assign) id <ExchangeCredentialsOperationDelegate> delegate;

@end
