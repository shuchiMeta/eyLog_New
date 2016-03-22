//
//  COStatement.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "COStatement.h"


NSString *const kCOStatementId = @"id";
NSString *const kCOStatementDescription = @"description";


@interface COStatement ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation COStatement

@synthesize statementIdentifier = _statementIdentifier;
@synthesize statementDescription = _statementDescription;


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
            self.statementIdentifier = [[self objectOrNilForKey:kCOStatementId fromDictionary:dict] doubleValue];
            self.statementDescription = [self objectOrNilForKey:kCOStatementDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.statementIdentifier] forKey:kCOStatementId];
    [mutableDict setValue:self.statementDescription forKey:kCOStatementDescription];

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

    self.statementIdentifier = [aDecoder decodeDoubleForKey:kCOStatementId];
    self.statementDescription = [aDecoder decodeObjectForKey:kCOStatementDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_statementIdentifier forKey:kCOStatementId];
    [aCoder encodeObject:_statementDescription forKey:kCOStatementDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    COStatement *copy = [[COStatement alloc] init];
    
    if (copy) {

        copy.statementIdentifier = self.statementIdentifier;
        copy.statementDescription = [self.statementDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
