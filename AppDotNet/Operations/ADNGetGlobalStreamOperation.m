//
//  ADNGetGlobalStreamOperation.m
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNGetGlobalStreamOperation.h"


@implementation ADNGetGlobalStreamOperation

#pragma mark - Endpoint

+ (NSString *)description
{
    return @"Retrieve the Global stream";
}

+ (NSString *)endpoint
{
    return @"posts/stream/global";
}

@end
