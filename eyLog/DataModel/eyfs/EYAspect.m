//
//  EYAspect.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYAspect.h"
#import "EYAge.h"


NSString *const kEYAspectAge = @"age";
NSString *const kEYAspectId = @"id";
NSString *const kEYAspectDescription = @"description";
NSString *const kEYAspectShortDescription = @"short_description";


@interface EYAspect ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYAspect

@synthesize age = _age;
@synthesize aspectIdentifier = _aspectIdentifier;
@synthesize aspectDescription = _aspectDescription;
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
    NSObject *receivedEYAge = [dict objectForKey:kEYAspectAge];
    NSMutableArray *parsedEYAge = [NSMutableArray array];
    if ([receivedEYAge isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEYAge) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEYAge addObject:[EYAge modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEYAge isKindOfClass:[NSDictionary class]]) {
       [parsedEYAge addObject:[EYAge modelObjectWithDictionary:(NSDictionary *)receivedEYAge]];
    }

    self.age = [NSArray arrayWithArray:parsedEYAge];
            self.aspectIdentifier = [[self objectOrNilForKey:kEYAspectId fromDictionary:dict] doubleValue];
            self.aspectDescription = [self objectOrNilForKey:kEYAspectDescription fromDictionary:dict];
            self.shortDescription = [self objectOrNilForKey:kEYAspectShortDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForAge = [NSMutableArray array];
    for (NSObject *subArrayObject in self.age) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAge addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAge addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAge] forKey:kEYAspectAge];
    [mutableDict setValue:[NSNumber numberWithDouble:self.aspectIdentifier] forKey:kEYAspectId];
    [mutableDict setValue:self.aspectDescription forKey:kEYAspectDescription];
    [mutableDict setValue:self.shortDescription forKey:kEYAspectShortDescription];

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

    self.age = [aDecoder decodeObjectForKey:kEYAspectAge];
    self.aspectIdentifier = [aDecoder decodeDoubleForKey:kEYAspectId];
    self.aspectDescription = [aDecoder decodeObjectForKey:kEYAspectDescription];
    self.shortDescription = [aDecoder decodeObjectForKey:kEYAspectShortDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_age forKey:kEYAspectAge];
    [aCoder encodeDouble:_aspectIdentifier forKey:kEYAspectId];
    [aCoder encodeObject:_aspectDescription forKey:kEYAspectDescription];
    [aCoder encodeObject:_shortDescription forKey:kEYAspectShortDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYAspect *copy = [[EYAspect alloc] init];
    
    if (copy) {

        copy.age = [self.age copyWithZone:zone];
        copy.aspectIdentifier = self.aspectIdentifier;
        copy.aspectDescription = [self.aspectDescription copyWithZone:zone];
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
