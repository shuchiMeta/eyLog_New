//
//  MontessoryLevel2.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryLevel2.h"
#import "MontesoryLevel3.h"


NSString *const kSecondLevelItem =@"level3";
NSString *const kSecondLevelDescription =@"description";
NSString *const kSecondLevelGroup = @"group";
NSString *const kSecondLevelIdentifier =@"id";


@interface MontessoryLevel2 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MontessoryLevel2

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
        NSObject *receivedSecondLevelItem = [dict objectForKey:kSecondLevelItem];
        NSMutableArray *parsedSecondLevelItem = [NSMutableArray array];
        if ([receivedSecondLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSecondLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSecondLevelItem addObject:[MontesoryLevel3 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedSecondLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedSecondLevelItem addObject:[MontesoryLevel3 modelObjectWithDictionary:(NSDictionary *)receivedSecondLevelItem]];
        }
        
        self.secondLevelItem = [NSArray arrayWithArray:parsedSecondLevelItem];
        self.secondLevelIdentifier = [[self objectOrNilForKey:kSecondLevelIdentifier fromDictionary:dict] doubleValue];
        self.secondLevelDescription = [self objectOrNilForKey:kSecondLevelDescription fromDictionary:dict];
        self.secondLevelGroup = [self objectOrNilForKey:kSecondLevelGroup fromDictionary:dict];
        
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel3] forKey:kSecondLevelItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.secondLevelIdentifier] forKey:kSecondLevelIdentifier];
    [mutableDict setValue:self.secondLevelGroup forKey:kSecondLevelGroup];
    [mutableDict setValue:self.secondLevelDescription forKey:kSecondLevelDescription];
    
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
    
    self.secondLevelItem = [aDecoder decodeObjectForKey:kSecondLevelItem];
    self.secondLevelIdentifier = [aDecoder decodeDoubleForKey:kSecondLevelIdentifier];
    self.secondLevelDescription = [aDecoder decodeObjectForKey:kSecondLevelDescription];
    self.secondLevelGroup = [aDecoder decodeObjectForKey:kSecondLevelGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_secondLevelItem forKey:kSecondLevelItem];
    [aCoder encodeDouble:_secondLevelIdentifier forKey:kSecondLevelIdentifier];
    [aCoder encodeObject:_secondLevelDescription forKey:kSecondLevelDescription];
    [aCoder encodeObject:_secondLevelGroup forKey:kSecondLevelGroup];
}

- (id)copyWithZone:(NSZone *)zone
{
    MontessoryLevel2 *copy = [[MontessoryLevel2 alloc] init];
    
    if (copy) {
        
        copy.secondLevelItem = [self.secondLevelItem copyWithZone:zone];
        copy.secondLevelIdentifier = self.secondLevelIdentifier;
        copy.secondLevelDescription = [self.secondLevelDescription copyWithZone:zone];
        copy.secondLevelGroup = [self.secondLevelGroup copyWithZone:zone];
    }
    
    return copy;
}




@end
