//
//  EYAssessment.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYAssessment.h"


NSString *const kEYAssessmentLevelId = @"level_id";
NSString *const kEYAssessmentAgeStart = @"age_start";
NSString *const kEYAssessmentLevelValue = @"level_value";
NSString *const kEYAssessmentLevelDescription = @"level_description";
NSString *const kEYAssessmentAgeEnd = @"age_end";
NSString *const kEYAssessmentColor = @"color";


@interface EYAssessment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYAssessment

@synthesize levelId = _levelId;
@synthesize ageStart = _ageStart;
@synthesize levelValue = _levelValue;
@synthesize levelDescription = _levelDescription;
@synthesize ageEnd = _ageEnd;
@synthesize color = _color;


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
            self.levelId = [[self objectOrNilForKey:kEYAssessmentLevelId fromDictionary:dict] doubleValue];
            self.ageStart = [[self objectOrNilForKey:kEYAssessmentAgeStart fromDictionary:dict] doubleValue];
            self.levelValue = [[self objectOrNilForKey:kEYAssessmentLevelValue fromDictionary:dict] doubleValue];
            self.levelDescription = [self objectOrNilForKey:kEYAssessmentLevelDescription fromDictionary:dict];
            self.ageEnd = [[self objectOrNilForKey:kEYAssessmentAgeEnd fromDictionary:dict] doubleValue];
            self.color = [self objectOrNilForKey:kEYAssessmentColor fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelId] forKey:kEYAssessmentLevelId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ageStart] forKey:kEYAssessmentAgeStart];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelValue] forKey:kEYAssessmentLevelValue];
    [mutableDict setValue:self.levelDescription forKey:kEYAssessmentLevelDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ageEnd] forKey:kEYAssessmentAgeEnd];
    [mutableDict setValue:self.color forKey:kEYAssessmentColor];

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

    self.levelId = [aDecoder decodeDoubleForKey:kEYAssessmentLevelId];
    self.ageStart = [aDecoder decodeDoubleForKey:kEYAssessmentAgeStart];
    self.levelValue = [aDecoder decodeDoubleForKey:kEYAssessmentLevelValue];
    self.levelDescription = [aDecoder decodeObjectForKey:kEYAssessmentLevelDescription];
    self.ageEnd = [aDecoder decodeDoubleForKey:kEYAssessmentAgeEnd];
    self.color = [aDecoder decodeObjectForKey:kEYAssessmentColor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_levelId forKey:kEYAssessmentLevelId];
    [aCoder encodeDouble:_ageStart forKey:kEYAssessmentAgeStart];
    [aCoder encodeDouble:_levelValue forKey:kEYAssessmentLevelValue];
    [aCoder encodeObject:_levelDescription forKey:kEYAssessmentLevelDescription];
    [aCoder encodeDouble:_ageEnd forKey:kEYAssessmentAgeEnd];
    [aCoder encodeObject:_color forKey:kEYAssessmentColor];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYAssessment *copy = [[EYAssessment alloc] init];
    
    if (copy) {

        copy.levelId = self.levelId;
        copy.ageStart = self.ageStart;
        copy.levelValue = self.levelValue;
        copy.levelDescription = [self.levelDescription copyWithZone:zone];
        copy.ageEnd = self.ageEnd;
        copy.color = [self.color copyWithZone:zone];
    }
    
    return copy;
}


@end
