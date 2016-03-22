//
//  CfeLevel4.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeLevel4.h"

NSString *const kCfeFourthLevelDescription =@"description";
NSString *const kCfeFourthLevelGroup = @"group";
NSString *const kCfeFourthLevelIdentifier =@"id";


@interface CfeLevel4 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CfeLevel4


@synthesize fourthLevelDescription= _fourthLevelDescription;
@synthesize fourthLevelGroup = _fourthLevelGroup;
@synthesize fourthLevelIdentifier= _fourthLevelIdentifier;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self =[super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.fourthLevelIdentifier=[[self objectOrNilForKey:kCfeFourthLevelIdentifier fromDictionary:dict]doubleValue];
        self.fourthLevelDescription=[self objectOrNilForKey:kCfeFourthLevelDescription fromDictionary:dict];
        self.fourthLevelGroup = [self objectOrNilForKey:kCfeFourthLevelGroup fromDictionary:dict];
    }
    return self;
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fourthLevelIdentifier] forKey:kCfeFourthLevelIdentifier];
    [mutableDict setValue:self.fourthLevelGroup forKey:kCfeFourthLevelGroup];
    [mutableDict setValue:self.fourthLevelDescription forKey:kCfeFourthLevelDescription];
    
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
    
    self.fourthLevelIdentifier = [aDecoder decodeDoubleForKey:kCfeFourthLevelIdentifier];
    self.fourthLevelGroup = [aDecoder decodeObjectForKey:kCfeFourthLevelGroup];
    self.fourthLevelDescription = [aDecoder decodeObjectForKey:kCfeFourthLevelDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeDouble:_fourthLevelIdentifier forKey:kCfeFourthLevelIdentifier];
    [aCoder encodeObject:_fourthLevelGroup forKey:kCfeFourthLevelGroup];
    [aCoder encodeObject:_fourthLevelDescription forKey:kCfeFourthLevelDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    CfeLevel4 *copy = [[CfeLevel4 alloc] init];
    
    if (copy) {
        
        copy.fourthLevelIdentifier = self.fourthLevelIdentifier;
        copy.fourthLevelGroup = [self.fourthLevelGroup copyWithZone:zone];
        copy.fourthLevelDescription = [self.fourthLevelDescription copyWithZone:zone];
    }
    
    return copy;
}


@end



