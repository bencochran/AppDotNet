//
//  ADNAccessControlList.h
//  AppDotNet
//
//  Created by Matt Rubin on 12/18/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNAccessControlList : NSObject

@property (nonatomic, assign) BOOL anyUser;
@property (nonatomic, assign) BOOL immutable;
@property (nonatomic, assign) BOOL public;
@property (nonatomic, assign) BOOL you;
@property (nonatomic, copy)   NSArray *userIDs;


+ (ADNAccessControlList *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end