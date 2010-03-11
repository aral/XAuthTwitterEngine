//
//  ExchangeCredentialsOperation.m
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 10/03/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import "ExchangeCredentialsOperation.h"
#import "OAMutableURLRequest.h"
#import "OARequestParameter.h"
#import "OADataFetcher.h"

@implementation ExchangeCredentialsOperation

@synthesize consumer = _consumer;
@synthesize username = _username, password = _password;
@synthesize delegate = _delegate;

- (void)main
{
	// This is running in its own thread: create an autorelease pool.
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];		

	
	//
	// Modified from http://github.com/norio-nomura/ntlniph/commit/5ce25d68916cd45254c7ff2ba9b91de4f324899a
	// Courtesy of Norio Nomura (@norio_nomura) via Steve Reynolds (@SteveReynolds)
	//
	// Carry out the xAuth, using the OAuthConsumer library directly.
	//
	NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:self.consumer
																	  token:nil   // we don't have a Token yet
																	  realm:nil   // our service provider doesn't specify a realm
														  signatureProvider:nil] ; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"POST"];
	[request setParameters:[NSArray arrayWithObjects:
							[OARequestParameter requestParameterWithName:@"x_auth_mode" value:@"client_auth"],
							[OARequestParameter requestParameterWithName:@"x_auth_username" value:self.username],
							[OARequestParameter requestParameterWithName:@"x_auth_password" value:self.password],
							nil]];
	
	
	OADataFetcher *dataFetcher = [[OADataFetcher alloc] init];
	[dataFetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(setAccessToken:withData:) didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	[dataFetcher release];
	
	[request release];	

	[pool drain];
}

//
// Access token fetch failed.
//
- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *) error {
	NSLog(@"access token did fail ***************");
	
	[self performSelectorOnMainThread:@selector(callDelegateOnMainThreadWithAccessTokenTicket:didFailWithError:) withObject:error waitUntilDone:[NSThread isMainThread]];	
}

- (void) callDelegateOnMainThreadWithAccessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *) error {
	[self.delegate accessTokenTicket:ticket didFailWithError:error];
}

//
// access token callback
// when twitter sends us an access token this callback will fire
// we store it in our ivar as well as writing it to the keychain
//

- (void) setAccessToken: (OAServiceTicket *) ticket withData: (NSData *) data {
	NSLog(@"£$@£$£@$@£$£@");
	if (!ticket.didSucceed || !data) 
	{
		[self accessTokenTicket:ticket didFailWithError:nil];
		return;
	}
	
	NSString *dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	if (!dataString)
	{
		[self accessTokenTicket:ticket didFailWithError:nil];		
		return;
	}
	
	[self performSelectorOnMainThread:@selector(callDelegateOnMainThreadWithSetAccessTokenFromTokenString:) withObject:dataString waitUntilDone:[NSThread isMainThread]];
}

- (void) callDelegateOnMainThreadWithSetAccessTokenFromTokenString: (NSString *)tokenString
{
	[self.delegate setAccessTokenFromTokenString:tokenString];
}


@end
