//
//  MontesdsoryLevel.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontesdsoryLevel.h"
#import "MontessoryLevel2.h"

NSString *const kMontessoryIdentifier = @"id";
NSString *const kMontessoryDescription =@"description";
NSString *const kMontessoryGroup = @"group";
NSString *const kMontessoryLevelItem = @"level2";


@interface MontesdsoryLevel ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MontesdsoryLevel
@synthesize levelItem = _levelItem;
@synthesize levelDescription = _levelDescription;
@synthesize levelGroup = _levelGroup;
@synthesize levelIdentifier = _levelIdentifier;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedLevelItem = [dict objectForKey:kMontessoryLevelItem];
        NSMutableArray *parsedLevelItem = [NSMutableArray array];
        if ([receivedLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedLevelItem addObject:[MontessoryLevel2 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedLevelItem addObject:[MontessoryLevel2 modelObjectWithDictionary:(NSDictionary *)receivedLevelItem]];
        }
        
        self.levelItem = [NSArray arrayWithArray:parsedLevelItem];
        self.levelIdentifier = [[self objectOrNilForKey:kMontessoryIdentifier fromDictionary:dict] doubleValue];
        self.levelDescription = [self objectOrNilForKey:kMontessoryDescription fromDictionary:dict];
        self.levelGroup = [self objectOrNilForKey:kMontessoryGroup fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForLevel = [NSMutableArray array];
    for (NSObject *subArrayObject in self.levelItem) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLevel addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLevel addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel] forKey:kMontessoryLevelItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelIdentifier] forKey:kMontessoryIdentifier];
    [mutableDict setValue:self.levelGroup forKey:kMontessoryGroup];
    [mutableDict setValue:self.levelDescription forKey:kMontessoryDescription];
    
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
    
    self.levelItem = [aDecoder decodeObjectForKey:kMontessoryLevelItem];
    self.levelIdentifier = [aDecoder decodeDoubleForKey:kMontessoryIdentifier];
    self.levelDescription = [aDecoder decodeObjectForKey:kMontessoryDescription];
    self.levelGroup = [aDecoder decodeObjectForKey:kMontessoryGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_levelItem forKey:kMontessoryLevelItem];
    [aCoder encodeDouble:_levelIdentifier forKey:kMontessoryIdentifier];
    [aCoder encodeObject:_levelDescription forKey:kMontessoryDescription];
    [aCoder encodeObject:_levelGroup forKey:kMontessoryGroup];
}

- (id)copyWithZone:(NSZone *)zone
{
    MontesdsoryLevel *copy = [[MontesdsoryLevel alloc] init];
    
    if (copy) {
        
        copy.levelItem = [self.levelItem copyWithZone:zone];
        copy.levelIdentifier = self.levelIdentifier;
        copy.levelDescription = [self.levelDescription copyWithZone:zone];
        copy.levelGroup = [self.levelGroup copyWithZone:zone];
    }
    
    return copy;
}




@end
