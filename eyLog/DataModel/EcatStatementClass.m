
//
//  EcatStatementClass.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatStatementClass.h"

NSString *const kEcatStatementDescription =@"description";
NSString *const kEcatStatementIdentifier =@"id";

@interface EcatStatementClass ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EcatStatementClass
@synthesize thirdLevelIdentifier=_thirdLevelIdentifier;
@synthesize thirdLevelDescription=_thirdLevelDescription;



+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self =[super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.thirdLevelIdentifier=[[self objectOrNilForKey:kEcatStatementIdentifier fromDictionary:dict]doubleValue];
        self.thirdLevelDescription=[self objectOrNilForKey:kEcatStatementDescription fromDictionary:dict];
    }
    return self;
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.thirdLevelIdentifier] forKey:kEcatStatementIdentifier];
    [mutableDict setValue:self.thirdLevelDescription forKey:kEcatStatementDescription];

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

    self.thirdLevelIdentifier = [aDecoder decodeDoubleForKey:kEcatStatementIdentifier];
    self.thirdLevelDescription = [aDecoder decodeObjectForKey:kEcatStatementDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_thirdLevelIdentifier forKey:kEcatStatementIdentifier];
    [aCoder encodeObject:_thirdLevelDescription forKey:kEcatStatementDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    EcatStatementClass *copy = [[EcatStatementClass alloc] init];

    if (copy) {

        copy.thirdLevelIdentifier = self.thirdLevelIdentifier;
        copy.thirdLevelDescription = [self.thirdLevelDescription copyWithZone:zone];
    }

    return copy;
}

@end
