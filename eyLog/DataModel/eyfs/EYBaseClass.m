//
//  EYBaseClass.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYBaseClass.h"
#import "EYAssessment.h"
#import "EYArea.h"


NSString *const kEYBaseClassAssessment = @"assessment";
NSString *const kEYBaseClassArea = @"area";


@interface EYBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYBaseClass

@synthesize assessment = _assessment;
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
    NSObject *receivedEYAssessment = [dict objectForKey:kEYBaseClassAssessment];
    NSMutableArray *parsedEYAssessment = [NSMutableArray array];
    if ([receivedEYAssessment isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEYAssessment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEYAssessment addObject:[EYAssessment modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEYAssessment isKindOfClass:[NSDictionary class]]) {
       [parsedEYAssessment addObject:[EYAssessment modelObjectWithDictionary:(NSDictionary *)receivedEYAssessment]];
    }

    self.assessment = [NSArray arrayWithArray:parsedEYAssessment];
    NSObject *receivedEYArea = [dict objectForKey:kEYBaseClassArea];
    NSMutableArray *parsedEYArea = [NSMutableArray array];
    if ([receivedEYArea isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEYArea) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEYArea addObject:[EYArea modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEYArea isKindOfClass:[NSDictionary class]]) {
       [parsedEYArea addObject:[EYArea modelObjectWithDictionary:(NSDictionary *)receivedEYArea]];
    }

    self.area = [NSArray arrayWithArray:parsedEYArea];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForAssessment = [NSMutableArray array];
    for (NSObject *subArrayObject in self.assessment) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAssessment addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAssessment addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAssessment] forKey:kEYBaseClassAssessment];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kEYBaseClassArea];

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

    self.assessment = [aDecoder decodeObjectForKey:kEYBaseClassAssessment];
    self.area = [aDecoder decodeObjectForKey:kEYBaseClassArea];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_assessment forKey:kEYBaseClassAssessment];
    [aCoder encodeObject:_area forKey:kEYBaseClassArea];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYBaseClass *copy = [[EYBaseClass alloc] init];
    
    if (copy) {

        copy.assessment = [self.assessment copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
    }
    
    return copy;
}


@end
