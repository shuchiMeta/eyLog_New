//
//  CfeBaseClass.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeBaseClass.h"

#import "CfeAssesment.h"
#import "CfeLevel.h"

NSString *const kCfeClassLevelNumber  =@"level1";
NSString *const kCfeClassAssesment = @"assessment";

@interface CfeBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end


@implementation CfeBaseClass

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
        NSObject *receivedCfeAssessment = [dict objectForKey:kCfeClassAssesment];
        NSMutableArray *parsedCfeAssessment = [NSMutableArray array];
        if ([receivedCfeAssessment isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedCfeAssessment) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    
                    NSLog(@"check%@",item);
                    [parsedCfeAssessment addObject:[CfeAssesment modelObjectWithDictionary:item]];
                    
                    NSLog(@"test %@",item);
                }
            }
        } else if ([receivedCfeAssessment isKindOfClass:[NSDictionary class]]) {
            [parsedCfeAssessment addObject:[CfeAssesment modelObjectWithDictionary:(NSDictionary *)receivedCfeAssessment]];
        }
        
        self.assessment = [NSArray arrayWithArray:parsedCfeAssessment];
        NSObject *receivedCfeLevel = [dict objectForKey:kCfeClassLevelNumber];
        
        NSMutableArray *parsedCfeLevel = [NSMutableArray array];
        if ([receivedCfeLevel isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedCfeLevel) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedCfeLevel addObject:[CfeLevel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedCfeLevel isKindOfClass:[NSDictionary class]]) {
            [parsedCfeLevel addObject:[CfeLevel modelObjectWithDictionary:(NSDictionary *)receivedCfeLevel]];
        }
        
        self.level1 = [NSArray arrayWithArray:parsedCfeLevel];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAssessment] forKey:kCfeClassAssesment];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kCfeClassLevelNumber];
    
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
    
    self.assessment = [aDecoder decodeObjectForKey:kCfeClassAssesment];
    self.level1 = [aDecoder decodeObjectForKey:kCfeClassLevelNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_assessment forKey:kCfeClassAssesment];
    [aCoder encodeObject:_level1 forKey:kCfeClassLevelNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    CfeBaseClass *copy = [[CfeBaseClass alloc] init];
    
    if (copy) {
        
        copy.assessment = [self.assessment copyWithZone:zone];
        copy.level1 = [self.level1 copyWithZone:zone];
    }
    
    return copy;
}


@end
