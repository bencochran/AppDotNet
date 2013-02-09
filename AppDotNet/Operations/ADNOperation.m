//
//  ADNOperation.m
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNOperation.h"


@interface ADNOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation ADNOperation

- (void)main
{
    NSURL *url = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    self.request = [NSURLRequest requestWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    
    
    self.semaphore = dispatch_semaphore_create(0);
    while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    NSLog(@"response: %@", [NSString stringWithUTF8String:self.responseData.bytes]);
}

- (void)finish
{
    dispatch_semaphore_signal(self.semaphore);
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
    [self finish];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self finish];
}

@end
