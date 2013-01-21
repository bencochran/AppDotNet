//
//  ADNUserTests.m
//  AppDotNet
//
//  Created by Me on 12/24/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNUserTests.h"
#import "ADNHelper.h"
#import "ADNResponseEnvelope.h"
#import "ADNUser.h"

#define TEST_FILE @"User"

@implementation ADNUserTests

- (void)setUp
{
    [super setUp];
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:TEST_FILE ofType:@"json"];
    NSData *userData = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *responseDictionary;
    NSError *error;
    if ((responseDictionary = [ADNHelper dictionaryFromJSONData:userData error:&error])) {
        ADNResponseEnvelope *responseEnvelope = [ADNResponseEnvelope modelWithExternalRepresentation:responseDictionary];
        self.dataDictionary = responseEnvelope.data;
    }
    if (error) {
        STFail(@"Cannot create data dictionary: %@", error);
    }
}

- (void)tearDown
{
    self.dataDictionary = nil;
    
    [super tearDown];
}

- (void)testMessage
{
    ADNUser *user = [ADNUser modelWithExternalRepresentation:self.dataDictionary];
    
    if (![user.externalRepresentation isEqual:self.dataDictionary]) {
        STFail(@"Message dictionary validation failed.");
        NSLog(@"A:\n%@", self.dataDictionary);
        NSLog(@"B:\n%@", user.externalRepresentation);
    }
}

@end
