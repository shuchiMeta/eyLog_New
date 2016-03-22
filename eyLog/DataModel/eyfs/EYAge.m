//
//  EYAge.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EYAge.h"
#import "EYStatement.h"


NSString *const kEYAgeShortDescription = @"short_description";
NSString *const kEYAgeId = @"id";
NSString *const kEYAgeAgeStart = @"age_start";
NSString *const kEYAgeAgeEnd = @"age_end";
NSString *const kEYAgeDescription = @"description";
NSString *const kEYAgeStatement = @"statement";


@interface EYAge ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EYAge

@synthesize shortDescription = _shortDescription;
@synthesize ageIdentifier = _ageIdentifier;
@synthesize ageStart = _ageStart;
@synthesize ageEnd = _ageEnd;
@synthesize ageDescription = _ageDescription;
@synthesize statement = _statement;


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
            self.shortDescription = [self objectOrNilForKey:kEYAgeShortDescription fromDictionary:dict];
            self.ageIdentifier = [[self objectOrNilForKey:kEYAgeId fromDictionary:dict] doubleValue];
            self.ageStart = [[self objectOrNilForKey:kEYAgeAgeStart fromDictionary:dict] doubleValue];
            self.ageEnd = [[self objectOrNilForKey:kEYAgeAgeEnd fromDictionary:dict] doubleValue];
            self.ageDescription = [self objectOrNilForKey:kEYAgeDescription fromDictionary:dict];
    NSObject *receivedEYStatement = [dict objectForKey:kEYAgeStatement];
    NSMutableArray *parsedEYStatement = [NSMutableArray array];
    if ([receivedEYStatement isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEYStatement) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEYStatement addObject:[EYStatement modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEYStatement isKindOfClass:[NSDictionary class]]) {
       [parsedEYStatement addObject:[EYStatement modelObjectWithDictionary:(NSDictionary *)receivedEYStatement]];
    }

    self.statement = [NSArray arrayWithArray:parsedEYStatement];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.shortDescription forKey:kEYAgeShortDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ageIdentifier] forKey:kEYAgeId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ageStart] forKey:kEYAgeAgeStart];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ageEnd] forKey:kEYAgeAgeEnd];
    [mutableDict setValue:self.ageDescription forKey:kEYAgeDescription];
    NSMutableArray *tempArrayForStatement = [NSMutableArray array];
    for (NSObject *subArrayObject in self.statement) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStatement addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStatement addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStatement] forKey:kEYAgeStatement];

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

    self.shortDescription = [aDecoder decodeObjectForKey:kEYAgeShortDescription];
    self.ageIdentifier = [aDecoder decodeDoubleForKey:kEYAgeId];
    self.ageStart = [aDecoder decodeDoubleForKey:kEYAgeAgeStart];
    self.ageEnd = [aDecoder decodeDoubleForKey:kEYAgeAgeEnd];
    self.ageDescription = [aDecoder decodeObjectForKey:kEYAgeDescription];
    self.statement = [aDecoder decodeObjectForKey:kEYAgeStatement];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_shortDescription forKey:kEYAgeShortDescription];
    [aCoder encodeDouble:_ageIdentifier forKey:kEYAgeId];
    [aCoder encodeDouble:_ageStart forKey:kEYAgeAgeStart];
    [aCoder encodeDouble:_ageEnd forKey:kEYAgeAgeEnd];
    [aCoder encodeObject:_ageDescription forKey:kEYAgeDescription];
    [aCoder encodeObject:_statement forKey:kEYAgeStatement];
}

- (id)copyWithZone:(NSZone *)zone
{
    EYAge *copy = [[EYAge alloc] init];
    
    if (copy) {

        copy.shortDescription = [self.shortDescription copyWithZone:zone];
        copy.ageIdentifier = self.ageIdentifier;
        copy.ageStart = self.ageStart;
        copy.ageEnd = self.ageEnd;
        copy.ageDescription = [self.ageDescription copyWithZone:zone];
        copy.statement = [self.statement copyWithZone:zone];
    }
    
    return copy;
}


@end
