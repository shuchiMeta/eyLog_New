//
//  INObservation.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INObservation.h"


NSString *const kINObservationLabelObservation = @"label_observation";
NSString *const kINObservationLabelAnalysis = @"label_analysis";
NSString *const kINObservationLabelNextSteps = @"label_next_steps";
NSString *const kINObservationLabelComment = @"label_comment";
NSString *const kINObservationLabelAssessment = @"label_assessment";
NSString *const kINObservationQuickObservationTagLabel = @"quick_observation_tag_label";


@interface INObservation ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INObservation

@synthesize labelObservation = _labelObservation;
@synthesize labelAnalysis = _labelAnalysis;
@synthesize labelNextSteps = _labelNextSteps;
@synthesize labelComment = _labelComment;
@synthesize labelAssessment = _labelAssessment;
@synthesize quickObservationTagLabel = _quickObservationTagLabel;


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
            self.labelObservation = [self objectOrNilForKey:kINObservationLabelObservation fromDictionary:dict];
            self.labelAnalysis = [self objectOrNilForKey:kINObservationLabelAnalysis fromDictionary:dict];
            self.labelNextSteps = [self objectOrNilForKey:kINObservationLabelNextSteps fromDictionary:dict];
            self.labelComment = [self objectOrNilForKey:kINObservationLabelComment fromDictionary:dict];
            self.labelAssessment = [self objectOrNilForKey:kINObservationLabelAssessment fromDictionary:dict];
            self.quickObservationTagLabel = [self objectOrNilForKey:kINObservationQuickObservationTagLabel fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.labelObservation forKey:kINObservationLabelObservation];
    [mutableDict setValue:self.labelAnalysis forKey:kINObservationLabelAnalysis];
    [mutableDict setValue:self.labelNextSteps forKey:kINObservationLabelNextSteps];
    [mutableDict setValue:self.labelComment forKey:kINObservationLabelComment];
    [mutableDict setValue:self.labelAssessment forKey:kINObservationLabelAssessment];
    [mutableDict setValue:self.quickObservationTagLabel forKey:kINObservationQuickObservationTagLabel];

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

    self.labelObservation = [aDecoder decodeObjectForKey:kINObservationLabelObservation];
    self.labelAnalysis = [aDecoder decodeObjectForKey:kINObservationLabelAnalysis];
    self.labelNextSteps = [aDecoder decodeObjectForKey:kINObservationLabelNextSteps];
    self.labelComment = [aDecoder decodeObjectForKey:kINObservationLabelComment];
    self.labelAssessment = [aDecoder decodeObjectForKey:kINObservationLabelAssessment];
    self.quickObservationTagLabel = [aDecoder decodeObjectForKey:kINObservationQuickObservationTagLabel];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_labelObservation forKey:kINObservationLabelObservation];
    [aCoder encodeObject:_labelAnalysis forKey:kINObservationLabelAnalysis];
    [aCoder encodeObject:_labelNextSteps forKey:kINObservationLabelNextSteps];
    [aCoder encodeObject:_labelComment forKey:kINObservationLabelComment];
    [aCoder encodeObject:_labelAssessment forKey:kINObservationLabelAssessment];
    [aCoder encodeObject:_quickObservationTagLabel forKey:kINObservationQuickObservationTagLabel];
}

- (id)copyWithZone:(NSZone *)zone
{
    INObservation *copy = [[INObservation alloc] init];
    
    if (copy) {

        copy.labelObservation = [self.labelObservation copyWithZone:zone];
        copy.labelAnalysis = [self.labelAnalysis copyWithZone:zone];
        copy.labelNextSteps = [self.labelNextSteps copyWithZone:zone];
        copy.labelComment = [self.labelComment copyWithZone:zone];
        copy.labelAssessment = [self.labelAssessment copyWithZone:zone];
        copy.quickObservationTagLabel = [self.quickObservationTagLabel copyWithZone:zone];
    }
    
    return copy;
}


@end
