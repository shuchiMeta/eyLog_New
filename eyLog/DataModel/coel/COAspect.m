//
//  COAspect.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "COAspect.h"
#import "COStatement.h"


NSString *const kCOAspectId = @"id";
NSString *const kCOAspectStatement = @"statement";
NSString *const kCOAspectDescription = @"description";


@interface COAspect ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation COAspect

@synthesize aspectIdentifier = _aspectIdentifier;
@synthesize statement = _statement;
@synthesize aspectDescription = _aspectDescription;


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
            self.aspectIdentifier = [[self objectOrNilForKey:kCOAspectId fromDictionary:dict] doubleValue];
    NSObject *receivedCOStatement = [dict objectForKey:kCOAspectStatement];
    NSMutableArray *parsedCOStatement = [NSMutableArray array];
    if ([receivedCOStatement isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCOStatement) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCOStatement addObject:[COStatement modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCOStatement isKindOfClass:[NSDictionary class]]) {
       [parsedCOStatement addObject:[COStatement modelObjectWithDictionary:(NSDictionary *)receivedCOStatement]];
    }

    self.statement = [NSArray arrayWithArray:parsedCOStatement];
            self.aspectDescription = [self objectOrNilForKey:kCOAspectDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.aspectIdentifier] forKey:kCOAspectId];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStatement] forKey:kCOAspectStatement];
    [mutableDict setValue:self.aspectDescription forKey:kCOAspectDescription];

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

    self.aspectIdentifier = [aDecoder decodeDoubleForKey:kCOAspectId];
    self.statement = [aDecoder decodeObjectForKey:kCOAspectStatement];
    self.aspectDescription = [aDecoder decodeObjectForKey:kCOAspectDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_aspectIdentifier forKey:kCOAspectId];
    [aCoder encodeObject:_statement forKey:kCOAspectStatement];
    [aCoder encodeObject:_aspectDescription forKey:kCOAspectDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    COAspect *copy = [[COAspect alloc] init];
    
    if (copy) {

        copy.aspectIdentifier = self.aspectIdentifier;
        copy.statement = [self.statement copyWithZone:zone];
        copy.aspectDescription = [self.aspectDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
