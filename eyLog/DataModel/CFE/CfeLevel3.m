//
//  CfeLevel3.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeLevel3.h"
#import "CfeLevel4.h"


NSString *const kCfeThirdLevelItem =@"level4";
NSString *const kCfeThirdLEvelDescription =@"description";
NSString *const kCfeThirdLevelGroup = @"group";
NSString *const kCfeThirdLevelIdentifier =@"id";

@interface CfeLevel3 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CfeLevel3

@synthesize thirdLevelItem= _thirdLevelItem;
@synthesize thirdLevelDescription= _thirdLevelDescription;
@synthesize thirdLevelGroup = _thirdLevelGroup;
@synthesize thirdLevelIdentifier= _thirdLevelIdentifier;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

//-(instancetype)initWithDictionary:(NSDictionary *)dict{
//    self =[super init];
//    if(self && [dict isKindOfClass:[NSDictionary class]]){
//        NSObject *recivedObject = [dict objectForKey:kThirdLevelItem];
//        NSMutableArray *parsedLevelArray=[NSMutableArray array];
//        if([recivedObject isKindOfClass:[NSArray class]]){
//            for (NSDictionary *item in (NSArray *)recivedObject) {
//                if([item isKindOfClass:[NSDictionary class]]){
//                [parsedLevelArray addObject:[]]
//                }
//            }
//        }
//    }
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.thirdLevelDescription = [self objectOrNilForKey:kCfeThirdLEvelDescription fromDictionary:dict];
        self.thirdLevelIdentifier = [[self objectOrNilForKey:kCfeThirdLevelIdentifier fromDictionary:dict] doubleValue];
        self.thirdLevelGroup = [self objectOrNilForKey:kCfeThirdLevelGroup fromDictionary:dict];
        NSObject *receiveMontessoryLevel = [dict objectForKey:kCfeThirdLevelItem];
        NSMutableArray *parsedMontessory = [NSMutableArray array];
        if ([receiveMontessoryLevel isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receiveMontessoryLevel) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMontessory addObject:[CfeLevel4 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receiveMontessoryLevel isKindOfClass:[NSDictionary class]]) {
            [parsedMontessory addObject:[CfeLevel4 modelObjectWithDictionary:(NSDictionary *)receiveMontessoryLevel]];
        }
        
        self.thirdLevelItem = [NSArray arrayWithArray:parsedMontessory];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.thirdLevelDescription forKey:kCfeThirdLEvelDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.thirdLevelIdentifier] forKey:kCfeThirdLevelIdentifier];
    [mutableDict setValue:self.thirdLevelGroup forKey:kCfeThirdLevelGroup];
    NSMutableArray *tempArrayForStatement = [NSMutableArray array];
    for (NSObject *subArrayObject in self.thirdLevelItem) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStatement addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStatement addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStatement] forKey:kCfeThirdLevelItem];
    
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
    
    self.thirdLevelDescription = [aDecoder decodeObjectForKey:kCfeThirdLEvelDescription];
    self.thirdLevelIdentifier = [aDecoder decodeDoubleForKey:kCfeThirdLevelIdentifier];
    self.thirdLevelGroup = [aDecoder decodeObjectForKey:kCfeThirdLevelGroup];
    self.thirdLevelItem = [aDecoder decodeObjectForKey:kCfeThirdLevelItem];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_thirdLevelDescription forKey:kCfeThirdLEvelDescription];
    [aCoder encodeObject:_thirdLevelGroup forKey:kCfeThirdLevelGroup];
    [aCoder encodeDouble:_thirdLevelIdentifier forKey:kCfeThirdLevelIdentifier];
    [aCoder encodeObject:_thirdLevelItem forKey:kCfeThirdLevelItem];
}

- (id)copyWithZone:(NSZone *)zone
{
    CfeLevel3 *copy = [[CfeLevel3 alloc] init];
    
    if (copy) {
        
        copy.thirdLevelDescription = [self.thirdLevelDescription copyWithZone:zone];
        copy.thirdLevelIdentifier = self.thirdLevelIdentifier;
        copy.thirdLevelGroup = [self.thirdLevelGroup copyWithZone:zone];
        copy.thirdLevelItem = [self.thirdLevelItem copyWithZone:zone];
    }
    
    return copy;
}


@end
