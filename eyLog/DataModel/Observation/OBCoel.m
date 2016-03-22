//
//  OBCoel.m
//  eyLog
//
//  Created by MDS_Abhijit on 27/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "OBCoel.h"

NSString *const kOBCoelId = @"coel_id";

@implementation OBCoel

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
        self.coelId = [self objectOrNilForKey:kOBCoelId fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.coelId forKey:kOBCoelId];
    
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
    
    self.coelId = [aDecoder decodeObjectForKey:kOBCoelId];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_coelId forKey:kOBCoelId];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    OBCoel *copy = [[OBCoel alloc] init];
    
    if (copy) {
        
        copy.coelId = [self.coelId copyWithZone:zone];
    }
    
    return copy;
}


@end
