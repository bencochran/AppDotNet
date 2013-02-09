//
//  ADNOperation.m
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNOperation.h"


NSString * const ADNAlphaAPIBaseURL = @"https://alpha-api.app.net/stream/0/";


@interface ADNOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation ADNOperation

#pragma mark - Endpoint

+ (NSURL *)endpointBaseURL
{
    return [NSURL URLWithString:ADNAlphaAPIBaseURL];
}

+ (NSString *)endpointDescription
{
    return nil;
}

+ (NSString *)endpointMethod
{
    return @"GET";
}

+ (NSString *)endpointPath
{
    return nil;
}

+ (ADNTokenType)endpointRequiredToken
{
    return ADNTokenTypeNone;
}

+ (NSDictionary *)propertyKeysByURITemplateKey
{
    return nil;
}


#pragma mark - Initialize

- (id)init
{
    self = [super init];
    if (self) {
        // init properties with defaults for the endpoint
        self.baseURL       = [self.class endpointBaseURL];
        self.path          = [self.class endpointPath];
        self.method        = [self.class endpointMethod];
        self.requiredToken = [self.class endpointRequiredToken];
    }
    return self;
}

- (void)setBaseURL:(NSURL *)baseURL
{
    if (_baseURL != baseURL) {
        // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
        if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
            baseURL = [baseURL URLByAppendingPathComponent:@""];
        }
        
        _baseURL = [baseURL copy];
    }
}


#pragma mark - Operation

- (NSURL *)url
{
    NSString *endpoint = self.path;
    
    // process URI template
    NSDictionary *keyPairs = [self.class propertyKeysByURITemplateKey];
    for (NSString *templateKey in keyPairs) {
        NSString *templateString = [NSString stringWithFormat:@"{%@}", templateKey];
        NSString *replacementString = [self valueForKey:keyPairs[templateKey]];
        
        endpoint = [endpoint stringByReplacingOccurrencesOfString:templateString
                                                       withString:replacementString];
    }
    
    // Append parameters to query string
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *param in self.parameters) {
        if (queryString.length) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", param, self.parameters[param]];
    }
    if (queryString.length) {
        NSString *joinString = ([endpoint rangeOfString:@"?"].location == NSNotFound)?@"?":@"&";
        endpoint = [endpoint stringByAppendingFormat:@"%@%@", joinString, queryString];
    }
    
    // Append to base URL
    return [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
}

- (void)main
{
    if (self.requiredToken) {
        NSAssert(self.accessToken, @"This API endpoint (/%@) requires an access token", self.path);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.HTTPMethod = self.method;
    if (self.accessToken) {
        [request addValue:[@"Bearer " stringByAppendingString:self.accessToken] forHTTPHeaderField:@"Authorization"];
    }
    if (self.prettyJSON) {
        [request addValue:@"1" forHTTPHeaderField:ADNHeaderPrettyJSON];
    }

    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    self.semaphore = dispatch_semaphore_create(0);
    while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)finish
{
    dispatch_semaphore_signal(self.semaphore);
}

- (void)handleResponseEnvelope:(ADNResponseEnvelope *)responseEnvelope
                         error:(NSError *)error
{
    if (self.responseHandler) {
        self.responseHandler(responseEnvelope, error);
    }
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    self.responseData = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.responseData options:NULL error:&error];
    
    ADNResponseEnvelope *responseEnvelope = nil;
    if (jsonObject)
        responseEnvelope = [ADNResponseEnvelope modelWithExternalRepresentation:jsonObject];
    
    [self handleResponseEnvelope:responseEnvelope error:error];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self handleResponseEnvelope:nil error:error];
    [self finish];
}

@end
