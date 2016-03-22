//
//  EcatAreaClass.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatAreaClass.h"
#import "EcatAspectClass.h"
NSString *const kEcatIdentifier = @"id";
NSString *const kEcatDescription =@"description";
NSString *const kEcatAspectItem = @"aspect";

@interface EcatAreaClass ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EcatAreaClass
@synthesize levelItem=_levelItem;
@synthesize levelIdentifier=_levelIdentifier;
@synthesize levelDescription=_levelDescription;

+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedLevelItem = [dict objectForKey:kEcatAspectItem];
        NSMutableArray *parsedLevelItem = [NSMutableArray array];
        if ([receivedLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedLevelItem addObject:[EcatAspectClass modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedLevelItem addObject:[EcatAspectClass modelObjectWithDictionary:(NSDictionary *)receivedLevelItem]];
        }

        self.levelItem = [NSArray arrayWithArray:parsedLevelItem];
        self.levelIdentifier = [[self objectOrNilForKey:kEcatIdentifier fromDictionary:dict] doubleValue];
        self.levelDescription = [self objectOrNilForKey:kEcatDescription fromDictionary:dict];

    }

    return self;

}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForLevel3 = [NSMutableArray array];
    for (NSObject *subArrayObject in self.levelItem) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLevel3 addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLevel3 addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel3] forKey:kEcatAspectItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelIdentifier] forKey:kEcatIdentifier];
    [mutableDict setValue:self.levelDescription forKey:kEcatDescription];

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

    self.levelItem = [aDecoder decodeObjectForKey:kEcatAspectItem];
    self.levelIdentifier = [aDecoder decodeDoubleForKey:kEcatIdentifier];
    self.levelDescription = [aDecoder decodeObjectForKey:kEcatDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_levelItem forKey:kEcatAspectItem];
    [aCoder encodeDouble:_levelIdentifier forKey:kEcatIdentifier];
    [aCoder encodeObject:_levelDescription forKey:kEcatDescription];

}

- (id)copyWithZone:(NSZone *)zone
{
    EcatAreaClass *copy = [[EcatAreaClass alloc] init];

    if (copy) {

        copy.levelItem = [self.levelItem copyWithZone:zone];
        copy.levelIdentifier = self.levelIdentifier;
        copy.levelDescription = [self.levelDescription copyWithZone:zone];
    }

    return copy;
}





@end
