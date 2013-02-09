//
//  ADNOperation.h
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNResponseEnvelope.h"


typedef enum {
    ADNTokenTypeNone = 0,
    ADNTokenTypeUser = (1 << 0),
    ADNTokenTypeApp  = (1 << 1),
    ADNTokenTypeAny  = ADNTokenTypeUser | ADNTokenTypeApp
} ADNTokenType;


@interface ADNOperation : NSOperation

// Endpoint properties
+ (NSString *)description;
+ (NSString *)method;
+ (NSString *)endpoint;
+ (ADNTokenType)tokenType;

+ (NSDictionary *)propertyKeysByURITemplateKey;

@property (nonatomic, strong) void (^responseHandler)(ADNResponseEnvelope *response, NSError *error);

@end
