//
//  ADNSearchUsersOperation.h
//  AppDotNet
//
//  Created by Me on 2/9/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNOperation.h"

/*
 * Search for Users
 * GET /stream/0/users/search
 * Token: Any
 * http://developers.app.net/docs/resources/user/lookup/#search-for-users
 */
@interface ADNSearchUsersOperation : ADNOperation

@property (nonatomic, copy) NSString *query;

@end
