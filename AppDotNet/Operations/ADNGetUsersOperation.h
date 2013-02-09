//
//  ADNGetUsersOperation.h
//  AppDotNet
//
//  Created by Me on 2/9/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNOperation.h"


/*
 * Retrieve multiple Users
 * GET /stream/0/users
 * Token: Any
 * http://developers.app.net/docs/resources/user/lookup/#retrieve-multiple-users
 */
@interface ADNGetUsersOperation : ADNOperation

@property (nonatomic, strong) NSArray *userIds;

@end
