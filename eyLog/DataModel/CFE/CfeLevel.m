//
//  CfeLevel.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeLevel.h"

#import "CfeLevel2.h"

NSString *const kCfeIdentifier = @"id";
NSString *const kCfeDescription =@"description";
NSString *const kCfeGroup = @"group";
NSString *const kCfeLevelItem = @"level2";


@interface  CfeLevel ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CfeLevel
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
        NSObject *receivedLevelItem = [dict objectForKey:kCfeLevelItem];
        NSMutableArray *parsedLevelItem = [NSMutableArray array];
        if ([receivedLevelItem isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedLevelItem) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedLevelItem addObject:[CfeLevel2 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedLevelItem isKindOfClass:[NSDictionary class]]) {
            [parsedLevelItem addObject:[CfeLevel2 modelObjectWithDictionary:(NSDictionary *)receivedLevelItem]];
        }
        
        self.levelItem = [NSArray arrayWithArray:parsedLevelItem];
        self.levelIdentifier = [[self objectOrNilForKey:kCfeIdentifier fromDictionary:dict] doubleValue];
        self.levelDescription = [self objectOrNilForKey:kCfeDescription fromDictionary:dict];
        self.levelGroup = [self objectOrNilForKey:kCfeGroup fromDictionary:dict];
        
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLevel] forKey:kCfeLevelItem];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelIdentifier] forKey:kCfeIdentifier];
    [mutableDict setValue:self.levelGroup forKey:kCfeGroup];
    [mutableDict setValue:self.levelDescription forKey:kCfeDescription];
    
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
    
    self.levelItem = [aDecoder decodeObjectForKey:kCfeLevelItem];
    self.levelIdentifier = [aDecoder decodeDoubleForKey:kCfeIdentifier];
    self.levelDescription = [aDecoder decodeObjectForKey:kCfeDescription];
    self.levelGroup = [aDecoder decodeObjectForKey:kCfeGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_levelItem forKey:kCfeLevelItem];
    [aCoder encodeDouble:_levelIdentifier forKey:kCfeIdentifier];
    [aCoder encodeObject:_levelDescription forKey:kCfeDescription];
    [aCoder encodeObject:_levelGroup forKey:kCfeGroup];
}

- (id)copyWithZone:(NSZone *)zone
{
    CfeLevel *copy = [[CfeLevel alloc] init];
    
    if (copy) {
        
        copy.levelItem = [self.levelItem copyWithZone:zone];
        copy.levelIdentifier = self.levelIdentifier;
        copy.levelDescription = [self.levelDescription copyWithZone:zone];
        copy.levelGroup = [self.levelGroup copyWithZone:zone];
    }
    
    return copy;
}




@end
