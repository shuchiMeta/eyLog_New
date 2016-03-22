//
//  INEcat.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INEcat.h"


NSString *const kINEcatEcatLevelOne = @"ecat_level_one";
NSString *const kINEcatEcatLevelTwo = @"ecat_level_two";
NSString *const kINEcatEcatLevelThree = @"ecat_level_three";


@interface INEcat ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INEcat

@synthesize ecatLevelOne = _ecatLevelOne;
@synthesize ecatLevelTwo = _ecatLevelTwo;
@synthesize ecatLevelThree = _ecatLevelThree;


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
            self.ecatLevelOne = [self objectOrNilForKey:kINEcatEcatLevelOne fromDictionary:dict];
            self.ecatLevelTwo = [self objectOrNilForKey:kINEcatEcatLevelTwo fromDictionary:dict];
            self.ecatLevelThree = [self objectOrNilForKey:kINEcatEcatLevelThree fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ecatLevelOne forKey:kINEcatEcatLevelOne];
    [mutableDict setValue:self.ecatLevelTwo forKey:kINEcatEcatLevelTwo];
    [mutableDict setValue:self.ecatLevelThree forKey:kINEcatEcatLevelThree];

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

    self.ecatLevelOne = [aDecoder decodeObjectForKey:kINEcatEcatLevelOne];
    self.ecatLevelTwo = [aDecoder decodeObjectForKey:kINEcatEcatLevelTwo];
    self.ecatLevelThree = [aDecoder decodeObjectForKey:kINEcatEcatLevelThree];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ecatLevelOne forKey:kINEcatEcatLevelOne];
    [aCoder encodeObject:_ecatLevelTwo forKey:kINEcatEcatLevelTwo];
    [aCoder encodeObject:_ecatLevelThree forKey:kINEcatEcatLevelThree];
}

- (id)copyWithZone:(NSZone *)zone
{
    INEcat *copy = [[INEcat alloc] init];
    
    if (copy) {

        copy.ecatLevelOne = [self.ecatLevelOne copyWithZone:zone];
        copy.ecatLevelTwo = [self.ecatLevelTwo copyWithZone:zone];
        copy.ecatLevelThree = [self.ecatLevelThree copyWithZone:zone];
    }
    
    return copy;
}


@end
