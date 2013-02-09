//
//  ADNGetUserOperation.h
//  AppDotNet
//
//  Created by Me on 2/9/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNOperation.h"


/*
 * Retrieve a User
 * GET /stream/0/users/[user_id]
 * Token: None
 * http://developers.app.net/docs/resources/user/lookup/#retrieve-a-user
 */
@interface ADNGetUserOperation : ADNOperation

@property (nonatomic, copy) NSString *userId;

@end
