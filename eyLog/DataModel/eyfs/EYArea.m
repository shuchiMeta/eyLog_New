//
//  EYArea.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYArea.h"
#import "EYAspect.h"


NSString *const kEYAreaId = @"id";
NSString *const kEYAreaAspect = @"aspect";
NSString *const kEYAreaDescription = @"description";
NSString *const kEYAreaShortDescription = @"short_description";


@interface EYArea ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYArea

@synthesize areaIdentifier = _areaIdentifier;
@synthesize aspect = _aspect;
@synthesize areaDescription = _areaDescription;
@synthesize shortDescription = _shortDescription;


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
            self.areaIdentifier = [[self objectOrNilForKey:kEYAreaId fromDictionary:dict] doubleValue];
    NSObject *receivedEYAspect = [dict objectForKey:kEYAreaAspect];
    NSMutableArray *parsedEYAspect = [NSMutableArray array];
    if ([receivedEYAspect isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEYAspect) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEYAspect addObject:[EYAspect modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEYAspect isKindOfClass:[NSDictionary class]]) {
       [parsedEYAspect addObject:[EYAspect modelObjectWithDictionary:(NSDictionary *)receivedEYAspect]];
    }

    self.aspect = [NSArray arrayWithArray:parsedEYAspect];
            self.areaDescription = [self objectOrNilForKey:kEYAreaDescription fromDictionary:dict];
            self.shortDescription = [self objectOrNilForKey:kEYAreaShortDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaIdentifier] forKey:kEYAreaId];
    NSMutableArray *tempArrayForAspect = [NSMutableArray array];
    for (NSObject *subArrayObject in self.aspect) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAspect addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAspect addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAspect] forKey:kEYAreaAspect];
    [mutableDict setValue:self.areaDescription forKey:kEYAreaDescription];
    [mutableDict setValue:self.shortDescription forKey:kEYAreaShortDescription];

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

    self.areaIdentifier = [aDecoder decodeDoubleForKey:kEYAreaId];
    self.aspect = [aDecoder decodeObjectForKey:kEYAreaAspect];
    self.areaDescription = [aDecoder decodeObjectForKey:kEYAreaDescription];
    self.shortDescription = [aDecoder decodeObjectForKey:kEYAreaShortDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_areaIdentifier forKey:kEYAreaId];
    [aCoder encodeObject:_aspect forKey:kEYAreaAspect];
    [aCoder encodeObject:_areaDescription forKey:kEYAreaDescription];
    [aCoder encodeObject:_shortDescription forKey:kEYAreaShortDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYArea *copy = [[EYArea alloc] init];
    
    if (copy) {

        copy.areaIdentifier = self.areaIdentifier;
        copy.aspect = [self.aspect copyWithZone:zone];
        copy.areaDescription = [self.areaDescription copyWithZone:zone];
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
