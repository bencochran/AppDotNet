//
//  ADNGetUsersOperation.m
//  AppDotNet
//
//  Created by Me on 2/9/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNGetUsersOperation.h"


@implementation ADNGetUsersOperation

#pragma mark - Endpoint

+ (NSString *)description
{
    return @"Retrieve multiple Users";
}

+ (NSString *)endpoint
{
    return @"users";
}

+ (ADNTokenType)tokenType
{
    return ADNTokenTypeAny;
}


#pragma mark - Operation

- (void)main
{
    self.parameters = @{@"ids": [self.userIds componentsJoinedByString:@","]};
    [super main];
}

@end
