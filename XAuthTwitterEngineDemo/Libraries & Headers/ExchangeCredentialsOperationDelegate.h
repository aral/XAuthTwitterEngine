@class OAServiceTicket;

@protocol ExchangeCredentialsOperationDelegate

- (void) setAccessTokenFromTokenString:(NSString *)tokenString;
- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *) error;

@end