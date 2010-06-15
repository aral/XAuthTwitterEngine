//
//  MGTwitterXMLParser.h
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 18/02/2008.
//  Copyright 2008 Instinctive Code.
//

#define kMGTwitterDateFormatString @"EEE MMM dd HH:mm:ss ZZZ yyyy"

#import "MGTwitterEngineGlobalHeader.h"

#import "MGTwitterParserDelegate.h"

@interface MGTwitterXMLParser : NSObject 
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 30200 
	<NSXMLParserDelegate> 
#endif
{ 
    __weak NSObject <MGTwitterParserDelegate> *delegate; // weak ref
    NSString *identifier;
    MGTwitterRequestType requestType;
    MGTwitterResponseType responseType;
    NSData *xml;
    NSMutableArray *parsedObjects;
    NSXMLParser *parser;
    __weak NSMutableDictionary *currentNode;
    NSString *lastOpenedElement;
	
	// To remove the warning on the depracated method
	// As per http://mattgemmell.com/2008/02/22/mgtwitterengine-twitter-from-cocoa/comment-page-3#comment-42022
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatter;

+ (id)parserWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(MGTwitterRequestType)reqType 
       responseType:(MGTwitterResponseType)respType;
- (id)initWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(MGTwitterRequestType)reqType 
     responseType:(MGTwitterResponseType)respType;

- (NSString *)lastOpenedElement;
- (void)setLastOpenedElement:(NSString *)value;

- (void)addSource;

@end
