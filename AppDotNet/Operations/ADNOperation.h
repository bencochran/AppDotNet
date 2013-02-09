//
//  ADNOperation.h
//  AppDotNet
//
//  Created by Me on 2/8/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNResponseEnvelope.h"


@interface ADNOperation : NSOperation

@property (nonatomic, strong) void (^responseHandler)(ADNResponseEnvelope *response, NSError *error);

@end
