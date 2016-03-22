//
//  EcatAspectClass.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatAspectClass.h"
#import "EcatStatementClass.h"
NSString *const kEcatStatementItem =@"statement";
NSString *const kEcatAspectDescription =@"description";
NSString *const kEcatAspectIdentifier =@"id";

@interface EcatAspectClass ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EcatAspectClass
@synthesize secondLevelItem=_secondLevelItem;
@synthesize secondLevelIdentifier=_secondLevelIdentifier;
@synthesize secondLevelDescription=_secondLevelDescription;



+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {

        NSObject *receivedSecondLevelItem = [dict objectForKey:kEcatStatementItem];
        NSMutableArray *parsedSecondLevelItem = [NSMutableArray array];
        if ([receivedSecondLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSecondLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSecondLevelItem addObject:[EcatStatementClass modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedSecondLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedSecondLevelItem addObject:[EcatStatementClass modelObjectWithDictionary:(NSDictionary *)receivedSecondLevelItem]];
        }

        self.secondLevelItem = [NSArray arrayWithArray:parsedSecondLevelItem];
        self.secondLevelIdentifier = [[self objectOrNilForKey:kEcatAspectIdentifier fromDictionary:dict] doubleValue];
        self.secondLevelDescription = [self objectOrNilForKey:kEcatAspectDescription fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel3] forKey:kEcatStatementItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.secondLevelIdentifier] forKey:kEcatAspectIdentifier];
    [mutableDict setValue:self.secondLevelDescription forKey:kEcatAspectDescription];

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

    self.secondLevelItem = [aDecoder decodeObjectForKey:kEcatStatementItem];
    self.secondLevelIdentifier = [aDecoder decodeDoubleForKey:kEcatAspectIdentifier];
    self.secondLevelDescription = [aDecoder decodeObjectForKey:kEcatAspectDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_secondLevelItem forKey:kEcatStatementItem];
    [aCoder encodeDouble:_secondLevelIdentifier forKey:kEcatAspectIdentifier];
    [aCoder encodeObject:_secondLevelDescription forKey:kEcatAspectDescription];

}

- (id)copyWithZone:(NSZone *)zone
{
    EcatAspectClass *copy = [[EcatAspectClass alloc] init];

    if (copy) {

        copy.secondLevelItem = [self.secondLevelItem copyWithZone:zone];
        copy.secondLevelIdentifier = self.secondLevelIdentifier;
        copy.secondLevelDescription = [self.secondLevelDescription copyWithZone:zone];
        
    }

    return copy;
}


@end
