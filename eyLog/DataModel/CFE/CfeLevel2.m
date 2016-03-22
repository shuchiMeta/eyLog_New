//
//  CfeLevel2.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeLevel2.h"

#import "CfeLevel3.h"


NSString *const kCfeSecondLevelItem =@"level3";
NSString *const kCfeSecondLevelDescription =@"description";
NSString *const kCfeSecondLevelGroup = @"group";
NSString *const kCfeSecondLevelIdentifier =@"id";


@interface CfeLevel2 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CfeLevel2

@synthesize secondLevelItem= _secondLevelItem;
@synthesize secondLevelDescription= _secondLevelDescription;
@synthesize secondLevelGroup = _secondLevelGroup;
@synthesize secondLevelIdentifier= _secondLevelIdentifier;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedSecondLevelItem = [dict objectForKey:kCfeSecondLevelItem];
        NSMutableArray *parsedSecondLevelItem = [NSMutableArray array];
        if ([receivedSecondLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSecondLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSecondLevelItem addObject:[CfeLevel3 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedSecondLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedSecondLevelItem addObject:[CfeLevel3 modelObjectWithDictionary:(NSDictionary *)receivedSecondLevelItem]];
        }
        
        self.secondLevelItem = [NSArray arrayWithArray:parsedSecondLevelItem];
        self.secondLevelIdentifier = [[self objectOrNilForKey:kCfeSecondLevelIdentifier fromDictionary:dict] doubleValue];
        self.secondLevelDescription = [self objectOrNilForKey:kCfeSecondLevelDescription fromDictionary:dict];
        self.secondLevelGroup = [self objectOrNilForKey:kCfeSecondLevelGroup fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForLevel3 = [NSMutableArray array];
    for (NSObject *subArrayObject in self.secondLevelItem) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLevel3 addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLevel3 addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel3] forKey:kCfeSecondLevelItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.secondLevelIdentifier] forKey:kCfeSecondLevelIdentifier];
    [mutableDict setValue:self.secondLevelGroup forKey:kCfeSecondLevelGroup];
    [mutableDict setValue:self.secondLevelDescription forKey:kCfeSecondLevelDescription];
    
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
    
    self.secondLevelItem = [aDecoder decodeObjectForKey:kCfeSecondLevelItem];
    self.secondLevelIdentifier = [aDecoder decodeDoubleForKey:kCfeSecondLevelIdentifier];
    self.secondLevelDescription = [aDecoder decodeObjectForKey:kCfeSecondLevelDescription];
    self.secondLevelGroup = [aDecoder decodeObjectForKey:kCfeSecondLevelGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_secondLevelItem forKey:kCfeSecondLevelItem];
    [aCoder encodeDouble:_secondLevelIdentifier forKey:kCfeSecondLevelIdentifier];
    [aCoder encodeObject:_secondLevelDescription forKey:kCfeSecondLevelDescription];
    [aCoder encodeObject:_secondLevelGroup forKey:kCfeSecondLevelGroup];
}

- (id)copyWithZone:(NSZone *)zone
{
    CfeLevel2 *copy = [[CfeLevel2 alloc] init];
    
    if (copy) {
        
        copy.secondLevelItem = [self.secondLevelItem copyWithZone:zone];
        copy.secondLevelIdentifier = self.secondLevelIdentifier;
        copy.secondLevelDescription = [self.secondLevelDescription copyWithZone:zone];
        copy.secondLevelGroup = [self.secondLevelGroup copyWithZone:zone];
    }
    
    return copy;
}




@end
