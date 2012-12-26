//
//  ADNObject.m
//  AppDotNet
//
//  Created by Me on 12/19/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNObject.h"

#import <objc/runtime.h>
#import "ADNHelper.h"
#import "ADNAnnotationCollection.h"


@interface ADNObject ()

- (Class)propertyClassForKey:(NSString *)key;

- (void)setConvertedValue:(id)value forKey:(NSString *)key;
- (void)setValue:(id)value toClass:(Class)keyClass forKey:(NSString *)key;

@end


@implementation ADNObject

+ (id)instanceFromDictionary:(NSDictionary *)dictionary
{
    ADNObject *instance = [[self alloc] init];
    [instance setAttributesFromDictionary:dictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]])
        return;
    
    [self setValuesForKeysWithDictionary:dictionary];
}

- (NSDictionary *)toDictionary
{
    return [self dictionaryWithValuesForKeys:self.exportKeys];
}

- (NSArray *)exportKeys
{
    return @[];
}

- (NSSet *)conversionKeys
{
    return [NSSet set];
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([self.conversionKeys containsObject:key]) {
        [self setConvertedValue:value forKey:key];
        return;
    }
    Class class = [self propertyClassForKey:key];
    if (class && ![value isKindOfClass:class]) {
        [NSException raise:@"InvalidPropertyAssignment" format:@"Trying to assign an object of type %@ to a property of type %@ (%@.%@)", [value class], class, [self class], key];
    }
    [super setValue:value forKey:key];
}

- (Class)propertyClassForKey:(NSString *)key
{
    Class class = nil;
    
    objc_property_t property = class_getProperty([self class], [key UTF8String]);
    if (property) {
        // The property exists
        char *typeEncoding = property_copyAttributeValue(property, "T");
        if (typeEncoding[0] == '@' && strlen(typeEncoding) >= 3) {
            // The type is a class
            char *className = strndup(typeEncoding+2, strlen(typeEncoding)-3);
            class = NSClassFromString([NSString stringWithUTF8String:className]);
            free(className);
        }
        free(typeEncoding);
    }
    
    return class;
}

- (void)setConvertedValue:(id)value forKey:(NSString *)key
{
    [self setValue:value toClass:[self propertyClassForKey:key] forKey:key];
}
- (void)setValue:(id)value toClass:(Class)keyClass forKey:(NSString *)key
{
    id newValue = nil;
    if ([value isKindOfClass:[NSDictionary class]]) {
        newValue = [keyClass instanceFromDictionary:value];
    } else if ([value isKindOfClass:[NSString class]]) {
        if (keyClass == [NSDate class]) {
            newValue = [[ADNHelper dateFormatter] dateFromString:value];
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        if (keyClass == [ADNAnnotationCollection class]) {
            newValue = [ADNAnnotationCollection instanceFromArray:value];
        }
    }
    
    if (newValue)
        [super setValue:newValue forKey:key];
}


/////

- (id)valueForKey:(NSString *)key
{
    if ([self.conversionKeys containsObject:key]) {
        return [self convertedValueForKey:key];
    } else {
        return [super valueForKey:key];
    }
}

- (id)convertedValueForKey:(NSString *)key
{
    id value = [super valueForKey:key];
    
    if ([value isKindOfClass:[ADNObject class]]) {
        return  [value toDictionary];
    } else if ([value isKindOfClass:[NSDate class]]) {
        return [[ADNHelper dateFormatter] stringFromDate:value];
    } else if ([value isKindOfClass:[ADNAnnotationCollection class]]) {
        return [value toArray];
    }
    // fallback
    return value;
}



- (NSDictionary *)alteredKeys
{
    return @{};
}

- (NSArray *)ignoredKeys
{
    return @[];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([self.ignoredKeys containsObject:key]) {
        return;
    }
    
    id newKey = [self.alteredKeys objectForKey:key];
    if (newKey) {
        [self setValue:value forKey:newKey];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    id newKey = [self.alteredKeys objectForKey:key];
    if (newKey) {
        return [self valueForKey:newKey];
    } else {
        return [super valueForUndefinedKey:key];
    }
}

@end
