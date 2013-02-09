//
//  ADNSearchUsersOperation.m
//  AppDotNet
//
//  Created by Me on 2/9/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNSearchUsersOperation.h"


@implementation ADNSearchUsersOperation

#pragma mark - Endpoint

+ (NSString *)description
{
    return @"Search for Users";
}

+ (NSString *)endpoint
{
    return @"users/search";
}

+ (ADNTokenType)tokenType
{
    return ADNTokenTypeAny;
}


#pragma mark - Operation

- (void)main
{
    self.parameters = @{@"q": self.query};
    [super main];
}

@end
