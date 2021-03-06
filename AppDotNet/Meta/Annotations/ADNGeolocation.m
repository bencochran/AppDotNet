//
//  ADNGeolocation.m
//  AppDotNet
//
//  Created by Me on 12/25/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNGeolocation.h"


NSString * const ADNAnnotationTypeGeolocation = @"net.app.core.geolocation";


@implementation ADNGeolocation

- (id)init
{
    self = [super init];
    if (self) {
        self.type = ADNAnnotationTypeGeolocation;
        // Negative accuracy values are flags for bad data
        self.horizontalAccuracy = -1;
        self.verticalAccuracy = -1;
    }
    return self;
}

// When building from a dictionary, intercept the "value" key
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString: ADNFieldValue]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self setValue:value];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

// When converting to a dictionary, intercept the "value" key
- (id)valueForKey:(NSString *)key
{
    if ([key isEqualToString: ADNFieldValue]) {
        return [self value];
    } else {
        return [super valueForKey:key];
    }
}

- (NSDictionary *)value
{
    return [self dictionaryWithValuesForKeys:@[@"latitude", @"longitude", @"altitude", @"horizontal_accuracy",  @"vertical_accuracy"]];
}

- (void)setValue:(NSDictionary *)value
{
    [self setValuesForKeysWithDictionary:value];
}


// Don't allow the type to change
- (void)setType:(NSString *)type
{
    if ([type isEqualToString:ADNAnnotationTypeGeolocation]) {
        [super setType:ADNAnnotationTypeGeolocation];
    } else {
        NSLog(@"%@ has a fixed type of %@", self.class, ADNAnnotationTypeGeolocation);
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"horizontal_accuracy"]) {
        [self setValue:value forKey:@"horizontalAccuracy"];
    } else if ([key isEqualToString:@"vertical_accuracy"]) {
        [self setValue:value forKey:@"verticalAccuracy"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"horizontal_accuracy"]) {
        return [self valueForKey:@"horizontalAccuracy"];
    } else if ([key isEqualToString:@"vertical_accuracy"]) {
        return [self valueForKey:@"verticalAccuracy"];
    } else {
        return [super valueForUndefinedKey:key];
    }
}


#pragma mark -

+ (id)instanceFromCoreLocation:(CLLocation *)location
{
    ADNGeolocation *instance = [[self alloc] init];
    [instance setAttributesFromCoreLocation:location];
    return instance;
}

- (void)setAttributesFromCoreLocation:(CLLocation *)location
{
    if (![location isKindOfClass:[CLLocation class]])
        return;
    
    self.latitude           = location.coordinate.latitude;
    self.longitude          = location.coordinate.longitude;
    self.altitude           = location.altitude;
    self.horizontalAccuracy = location.horizontalAccuracy;
    self.verticalAccuracy   = location.verticalAccuracy;
}

- (CLLocation *)toCoreLocation
{
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) altitude:self.altitude horizontalAccuracy:self.horizontalAccuracy verticalAccuracy:self.verticalAccuracy timestamp:nil];
}

@end
