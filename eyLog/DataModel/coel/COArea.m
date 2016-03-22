//
//  COArea.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "COArea.h"
#import "COAspect.h"


NSString *const kCOAreaId = @"id";
NSString *const kCOAreaAspect = @"aspect";
NSString *const kCOAreaDescription = @"description";


@interface COArea ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation COArea

@synthesize areaIdentifier = _areaIdentifier;
@synthesize aspect = _aspect;
@synthesize areaDescription = _areaDescription;


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
            self.areaIdentifier = [[self objectOrNilForKey:kCOAreaId fromDictionary:dict] doubleValue];
    NSObject *receivedCOAspect = [dict objectForKey:kCOAreaAspect];
    NSMutableArray *parsedCOAspect = [NSMutableArray array];
    if ([receivedCOAspect isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCOAspect) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCOAspect addObject:[COAspect modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCOAspect isKindOfClass:[NSDictionary class]]) {
       [parsedCOAspect addObject:[COAspect modelObjectWithDictionary:(NSDictionary *)receivedCOAspect]];
    }

    self.aspect = [NSArray arrayWithArray:parsedCOAspect];
            self.areaDescription = [self objectOrNilForKey:kCOAreaDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaIdentifier] forKey:kCOAreaId];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAspect] forKey:kCOAreaAspect];
    [mutableDict setValue:self.areaDescription forKey:kCOAreaDescription];

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

    self.areaIdentifier = [aDecoder decodeDoubleForKey:kCOAreaId];
    self.aspect = [aDecoder decodeObjectForKey:kCOAreaAspect];
    self.areaDescription = [aDecoder decodeObjectForKey:kCOAreaDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_areaIdentifier forKey:kCOAreaId];
    [aCoder encodeObject:_aspect forKey:kCOAreaAspect];
    [aCoder encodeObject:_areaDescription forKey:kCOAreaDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    COArea *copy = [[COArea alloc] init];
    
    if (copy) {

        copy.areaIdentifier = self.areaIdentifier;
        copy.aspect = [self.aspect copyWithZone:zone];
        copy.areaDescription = [self.areaDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
