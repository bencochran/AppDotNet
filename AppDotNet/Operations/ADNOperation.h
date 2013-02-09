//
//  ADNOperation.h
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNResponseEnvelope.h"
#import "ADNParameters.h"


typedef enum {
    ADNTokenTypeNone = 0,
    ADNTokenTypeUser = (1 << 0),
    ADNTokenTypeApp  = (1 << 1),
    ADNTokenTypeAny  = ADNTokenTypeUser | ADNTokenTypeApp
} ADNTokenType;


@interface ADNOperation : NSOperation

// Endpoint properties
+ (NSURL *)endpointBaseURL;
+ (NSString *)endpointDescription;
+ (NSString *)endpointMethod;
+ (NSString *)endpointPath;
+ (ADNTokenType)endpointRequiredToken;

+ (NSDictionary *)propertyKeysByURITemplateKey;


@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) ADNTokenType requiredToken;


@property (nonatomic, strong) void (^responseHandler)(ADNResponseEnvelope *response, NSError *error);

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) BOOL prettyJSON;

@property (nonatomic, strong) NSDictionary *parameters;

@end
