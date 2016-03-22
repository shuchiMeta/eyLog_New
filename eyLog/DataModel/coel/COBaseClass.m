//
//  COBaseClass.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "COBaseClass.h"
#import "COArea.h"


NSString *const kCOBaseClassArea = @"area";


@interface COBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation COBaseClass

@synthesize area = _area;


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
    NSObject *receivedCOArea = [dict objectForKey:kCOBaseClassArea];
    NSMutableArray *parsedCOArea = [NSMutableArray array];
    if ([receivedCOArea isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCOArea) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCOArea addObject:[COArea modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCOArea isKindOfClass:[NSDictionary class]]) {
       [parsedCOArea addObject:[COArea modelObjectWithDictionary:(NSDictionary *)receivedCOArea]];
    }

    self.area = [NSArray arrayWithArray:parsedCOArea];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForArea = [NSMutableArray array];
    for (NSObject *subArrayObject in self.area) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForArea addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForArea addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kCOBaseClassArea];

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

    self.area = [aDecoder decodeObjectForKey:kCOBaseClassArea];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_area forKey:kCOBaseClassArea];
}

- (id)copyWithZone:(NSZone *)zone
{
    COBaseClass *copy = [[COBaseClass alloc] init];
    
    if (copy) {

        copy.area = [self.area copyWithZone:zone];
    }
    
    return copy;
}


@end
