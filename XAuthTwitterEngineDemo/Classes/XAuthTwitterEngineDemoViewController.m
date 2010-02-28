//
//  XAuthTwitterEngineDemoViewController.m
//  XAuthTwitterEngineDemo
//
//  Created by Aral Balkan on 28/02/2010.
//  Copyright Naklab 2010. All rights reserved.
//


#import "XAuthTwitterEngineDemoViewController.h"
#import "XAuthTwitterEngine.h"
#import "UIAlertView+Helper.h"

@implementation XAuthTwitterEngineDemoViewController

@synthesize usernameTextField, passwordTextField, twitterEngine, sendTweetButton;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Sanity check
	if ([kOAuthConsumerKey isEqualToString:@""] || [kOAuthConsumerSecret isEqualToString:@""])
	{
		NSString *message = @"Please add your Consumer Key and Consumer Secret from http://twitter.com/oauth_clients/details/<your app id> to the XAuthTwitterEngineDemoViewController.h before running the app. Thank you!";
		UIAlertViewQuick(@"Missing oAuth details", message, @"OK");
	}
	
	//
	// Initialize the XAuthTwitterEngine.
	//
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;

	if ([self.twitterEngine isAuthorized])
	{
		UIAlertViewQuick(@"Cached xAuth token found!", @"This app was previously authorized for a Twitter account so you can press the second button to send a tweet now.", @"OK");
		self.sendTweetButton.enabled = YES;
	}
	
	// Focus
	[self.usernameTextField becomeFirstResponder];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.usernameTextField = nil;
	self.passwordTextField = nil;
	self.sendTweetButton = nil;
}


- (void)dealloc {
	
	[self.usernameTextField release];
	[self.passwordTextField release];
	[self.sendTweetButton release];
	[self.twitterEngine release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)xAuthAccessTokenRequestButtonTouchUpInside
{
	NSString *username = self.usernameTextField.text;
	NSString *password = self.passwordTextField.text;
	
	NSLog(@"About to request an xAuth token exchange for username: ]%@[ password: ]%@[.",
		  username, password);
	
	[self.twitterEngine exchangeAccessTokenForUsername:username password:password];
}

- (IBAction)sendTestTweetButtonTouchUpInside
{
	NSString *tweetText = @"Testing xAuth from the XAuthTwitterEngineDemo!";
	NSLog(@"About to send test tweet: \"%@\"", tweetText);
	[self.twitterEngine sendUpdate:tweetText];
}

#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	//
	// Note: do not use NSUserDefaults to store this in a production environment. 
	// ===== Use the keychain instead. Check out SFHFKeychainUtils if you want 
	//       an easy to use library. (http://github.com/ldandersen/scifihifi-iphone) 
	//
	NSLog(@"Access token string returned: %@", tokenString);
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
	
	// Enable the send tweet button.
	self.sendTweetButton.enabled = YES;
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}


- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
	
	UIAlertViewQuick(@"Authentication error", @"Please check your username and password and try again.", @"OK");
}


#pragma mark -
#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
	NSLog(@"Twitter request succeeded: %@", connectionIdentifier);
	
	UIAlertViewQuick(@"Tweet sent!", @"The tweet was successfully sent. Everything works!", @"OK");
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
	NSLog(@"Twitter request failed: %@ with error:%@", connectionIdentifier, error);
		
	if ([[error domain] isEqualToString: @"HTTP"])
	{
		switch ([error code]) {
				
			case 401:
			{
				// Unauthorized. The user's credentials failed to verify.
				UIAlertViewQuick(@"Oops!", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
				break;				
			}
				
			case 502:
			{
				// Bad gateway: twitter is down or being upgraded.
				UIAlertViewQuick(@"Fail whale!", @"Looks like Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
				break;				
			}
				
			case 503:
			{
				// Service unavailable
				UIAlertViewQuick(@"Hold your taps!", @"Looks like Twitter is overloaded. Please wait a few seconds and try again.", @"OK");	
				break;								
			}
				
			default:
			{
				NSString *errorMessage = [[NSString alloc] initWithFormat: @"%d %@", [error	code], [error localizedDescription]];
				UIAlertViewQuick(@"Twitter error!", errorMessage, @"OK");	
				[errorMessage release];
				break;				
			}
		}
		
	}
	else 
	{
		switch ([error code]) {
				
			case -1009:
			{
				UIAlertViewQuick(@"You're offline!", @"Sorry, it looks like you lost your Internet connection. Please reconnect and try again.", @"OK");					
				break;				
			}
				
			case -1200:
			{
				UIAlertViewQuick(@"Secure connection failed", @"I couldn't connect to Twitter. This is most likely a temporary issue, please try again.", @"OK");					
				break;								
			}
				
			default:
			{				
				NSString *errorMessage = [[NSString alloc] initWithFormat:@"%@ xx %d: %@", [error domain], [error code], [error localizedDescription]];
				UIAlertViewQuick(@"Network Error!", errorMessage , @"OK");
				[errorMessage release];
			}
		}
	}
	
}


@end
