//
//  OBEyfs.m
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "OBEyfs.h"
#import "AppDelegate.h"
#import "Eyfs.h"
#import "Statement.h"

NSString *const kOBEyfsFrameworkItemId = @"framework_item_id";
NSString *const kOBEyfsAssessmentLevel = @"assessment_level";
NSString *const ageIdentifier = @"ageIdentifier";


@interface OBEyfs ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBEyfs

@synthesize frameworkItemId = _frameworkItemId;
@synthesize assessmentLevel = _assessmentLevel;
@synthesize age=_age;
@synthesize aspect=_aspect;


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
            self.frameworkItemId = [self objectOrNilForKey:kOBEyfsFrameworkItemId fromDictionary:dict];
            self.assessmentLevel = [self objectOrNilForKey:kOBEyfsAssessmentLevel fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.frameworkItemId forKey:kOBEyfsFrameworkItemId];
    [mutableDict setValue:self.assessmentLevel forKey:kOBEyfsAssessmentLevel];
    [mutableDict setValue:self.ageIdentifier forKey:ageIdentifier];

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

    self.frameworkItemId = [aDecoder decodeObjectForKey:kOBEyfsFrameworkItemId];
    self.assessmentLevel = [aDecoder decodeObjectForKey:kOBEyfsAssessmentLevel];
    self.ageIdentifier = [aDecoder decodeObjectForKey:ageIdentifier];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_frameworkItemId forKey:kOBEyfsFrameworkItemId];
    [aCoder encodeObject:_assessmentLevel forKey:kOBEyfsAssessmentLevel];
    [aCoder encodeObject:_ageIdentifier forKey:ageIdentifier];

}

- (id)copyWithZone:(NSZone *)zone
{
    OBEyfs *copy = [[OBEyfs alloc] init];
    
    if (copy) {

        copy.frameworkItemId = [self.frameworkItemId copyWithZone:zone];
        copy.assessmentLevel = [self.assessmentLevel copyWithZone:zone];
//        copy.statement = [self.statement copyWithZone:zone];
    }
    
    return copy;
}
-(NSNumber *)ageIdentifier{
    if (!_ageIdentifier) {
        _ageIdentifier = [[[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:self.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject] ageIdentifier];
        self.age=[[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:_ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] firstObject];
        self.aspect=[[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:self.age.aspectIdentifier withFrameWork:NSStringFromClass([Eyfs class])] firstObject];
        
        
    }
    return _ageIdentifier;
}

@end
