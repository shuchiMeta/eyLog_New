//
//  LSBaseClass.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LSBaseClass.h"


NSString *const kLSBaseClassScale = @"scale";
NSString *const kLSBaseClassSignals = @"signals";
NSString *const kLSBaseClassLeuvenScaleType = @"leuven_scale_type";


@interface LSBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LSBaseClass

@synthesize scale = _scale;
@synthesize signals = _signals;
@synthesize leuvenScaleType = _leuvenScaleType;


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
            self.scale = [self objectOrNilForKey:kLSBaseClassScale fromDictionary:dict];
            self.signals = [self objectOrNilForKey:kLSBaseClassSignals fromDictionary:dict];
            self.leuvenScaleType = [self objectOrNilForKey:kLSBaseClassLeuvenScaleType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.scale forKey:kLSBaseClassScale];
    [mutableDict setValue:self.signals forKey:kLSBaseClassSignals];
    [mutableDict setValue:self.leuvenScaleType forKey:kLSBaseClassLeuvenScaleType];

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

    self.scale = [aDecoder decodeObjectForKey:kLSBaseClassScale];
    self.signals = [aDecoder decodeObjectForKey:kLSBaseClassSignals];
    self.leuvenScaleType = [aDecoder decodeObjectForKey:kLSBaseClassLeuvenScaleType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_scale forKey:kLSBaseClassScale];
    [aCoder encodeObject:_signals forKey:kLSBaseClassSignals];
    [aCoder encodeObject:_leuvenScaleType forKey:kLSBaseClassLeuvenScaleType];
}

- (id)copyWithZone:(NSZone *)zone
{
    LSBaseClass *copy = [[LSBaseClass alloc] init];
    
    if (copy) {

        copy.scale = [self.scale copyWithZone:zone];
        copy.signals = [self.signals copyWithZone:zone];
        copy.leuvenScaleType = [self.leuvenScaleType copyWithZone:zone];
    }
    
    return copy;
}


@end
