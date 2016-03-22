//
//  MontessoryBaseClass.m
//  eyLog
//
//  Created by Shobhit on 23/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryBaseClass.h"
#import "MontessoryAssesment.h"
#import "MontesdsoryLevel.h"

NSString *const kMontessoryClassLevelNumber  =@"level1";
NSString *const kMOntessoryClassAssesment = @"assessment";

@interface MontessoryBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end


@implementation MontessoryBaseClass

@synthesize assessment=_assessment;
@synthesize level1=_level1;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}


-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedMontessoryAssessment = [dict objectForKey:kMOntessoryClassAssesment];
        NSMutableArray *parsedMontessoryAssessment = [NSMutableArray array];
        if ([receivedMontessoryAssessment isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedMontessoryAssessment) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                
                    NSLog(@"check%@",item);
                    [parsedMontessoryAssessment addObject:[MontessoryAssesment modelObjectWithDictionary:item]];
                    
                    NSLog(@"test %@",item);
                }
            }
        } else if ([receivedMontessoryAssessment isKindOfClass:[NSDictionary class]]) {
            [parsedMontessoryAssessment addObject:[MontessoryAssesment modelObjectWithDictionary:(NSDictionary *)receivedMontessoryAssessment]];
        }
        
        self.assessment = [NSArray arrayWithArray:parsedMontessoryAssessment];
        NSObject *receivedMontessoryLevel = [dict objectForKey:kMontessoryClassLevelNumber];
        
        NSMutableArray *parsedMontessoryLevel = [NSMutableArray array];
        if ([receivedMontessoryLevel isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedMontessoryLevel) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMontessoryLevel addObject:[MontesdsoryLevel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedMontessoryLevel isKindOfClass:[NSDictionary class]]) {
            [parsedMontessoryLevel addObject:[MontesdsoryLevel modelObjectWithDictionary:(NSDictionary *)receivedMontessoryLevel]];
        }
        
        self.level1 = [NSArray arrayWithArray:parsedMontessoryLevel];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAssessment] forKey:kMOntessoryClassAssesment];
    NSMutableArray *tempArrayForArea = [NSMutableArray array];
    for (NSObject *subArrayObject in self.level1) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForArea addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForArea addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kMontessoryClassLevelNumber];
    
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
    
    self.assessment = [aDecoder decodeObjectForKey:kMOntessoryClassAssesment];
    self.level1 = [aDecoder decodeObjectForKey:kMontessoryClassLevelNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_assessment forKey:kMOntessoryClassAssesment];
    [aCoder encodeObject:_level1 forKey:kMontessoryClassLevelNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    MontessoryBaseClass *copy = [[MontessoryBaseClass alloc] init];
    
    if (copy) {
        
        copy.assessment = [self.assessment copyWithZone:zone];
        copy.level1 = [self.level1 copyWithZone:zone];
    }
    
    return copy;
}


@end
