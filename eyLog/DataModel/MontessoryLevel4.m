//
//  MontessoryLevel4.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryLevel4.h"

NSString *const kFourthLevelDescription =@"description";
NSString *const kFourthLevelGroup = @"group";
NSString *const kFourthLevelIdentifier =@"id";


@interface MontessoryLevel4 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MontessoryLevel4


@synthesize fourthLevelDescription= _fourthLevelDescription;
@synthesize fourthLevelGroup = _fourthLevelGroup;
@synthesize fourthLevelIdentifier= _fourthLevelIdentifier;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self =[super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.fourthLevelIdentifier=[[self objectOrNilForKey:kFourthLevelIdentifier fromDictionary:dict]doubleValue];
        self.fourthLevelDescription=[self objectOrNilForKey:kFourthLevelDescription fromDictionary:dict];
        self.fourthLevelGroup = [self objectOrNilForKey:kFourthLevelGroup fromDictionary:dict];
    }
    return self;
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fourthLevelIdentifier] forKey:kFourthLevelIdentifier];
    [mutableDict setValue:self.fourthLevelGroup forKey:kFourthLevelGroup];
    [mutableDict setValue:self.fourthLevelDescription forKey:kFourthLevelDescription];
    
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
    
    self.fourthLevelIdentifier = [aDecoder decodeDoubleForKey:kFourthLevelIdentifier];
    self.fourthLevelGroup = [aDecoder decodeObjectForKey:kFourthLevelGroup];
    self.fourthLevelDescription = [aDecoder decodeObjectForKey:kFourthLevelDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeDouble:_fourthLevelIdentifier forKey:kFourthLevelIdentifier];
    [aCoder encodeObject:_fourthLevelGroup forKey:kFourthLevelGroup];
    [aCoder encodeObject:_fourthLevelDescription forKey:kFourthLevelDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    MontessoryLevel4 *copy = [[MontessoryLevel4 alloc] init];
    
    if (copy) {
        
        copy.fourthLevelIdentifier = self.fourthLevelIdentifier;
        copy.fourthLevelGroup = [self.fourthLevelGroup copyWithZone:zone];
        copy.fourthLevelDescription = [self.fourthLevelDescription copyWithZone:zone];
    }
    
    return copy;
}


@end



