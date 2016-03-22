//
//  EYStatement.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYStatement.h"


NSString *const kEYStatementId = @"id";
NSString *const kEYStatementShortDescription = @"short_description";
NSString *const kEYStatementDescription = @"description";


@interface EYStatement ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYStatement

@synthesize statementIdentifier = _statementIdentifier;
@synthesize shortDescription = _shortDescription;
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
            self.statementIdentifier = [[self objectOrNilForKey:kEYStatementId fromDictionary:dict] doubleValue];
            self.shortDescription = [self objectOrNilForKey:kEYStatementShortDescription fromDictionary:dict];
            self.statementDescription = [self objectOrNilForKey:kEYStatementDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.statementIdentifier] forKey:kEYStatementId];
    [mutableDict setValue:self.shortDescription forKey:kEYStatementShortDescription];
    [mutableDict setValue:self.statementDescription forKey:kEYStatementDescription];

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

    self.statementIdentifier = [aDecoder decodeDoubleForKey:kEYStatementId];
    self.shortDescription = [aDecoder decodeObjectForKey:kEYStatementShortDescription];
    self.statementDescription = [aDecoder decodeObjectForKey:kEYStatementDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_statementIdentifier forKey:kEYStatementId];
    [aCoder encodeObject:_shortDescription forKey:kEYStatementShortDescription];
    [aCoder encodeObject:_statementDescription forKey:kEYStatementDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYStatement *copy = [[EYStatement alloc] init];
    
    if (copy) {

        copy.statementIdentifier = self.statementIdentifier;
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
        copy.statementDescription = [self.statementDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
