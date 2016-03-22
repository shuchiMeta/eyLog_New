//
//  INLabel.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INLabel.h"
#import "INObservation.h"
#import "INEcat.h"


NSString *const kINLabelObservation = @"observation";
NSString *const kINLabelEcat = @"ecat";


@interface INLabel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INLabel

@synthesize observation = _observation;
@synthesize ecat = _ecat;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.observation = [INObservation modelObjectWithDictionary:[dict objectForKey:kINLabelObservation]];
            self.ecat = [INEcat modelObjectWithDictionary:[dict objectForKey:kINLabelEcat]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.observation dictionaryRepresentation] forKey:kINLabelObservation];
    [mutableDict setValue:[self.ecat dictionaryRepresentation] forKey:kINLabelEcat];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.observation = [aDecoder decodeObjectForKey:kINLabelObservation];
    self.ecat = [aDecoder decodeObjectForKey:kINLabelEcat];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_observation forKey:kINLabelObservation];
    [aCoder encodeObject:_ecat forKey:kINLabelEcat];
}

- (id)copyWithZone:(NSZone *)zone
{
    INLabel *copy = [[INLabel alloc] init];
    
    if (copy) {

        copy.observation = [self.observation copyWithZone:zone];
        copy.ecat = [self.ecat copyWithZone:zone];
    }
    
    return copy;
}


@end
