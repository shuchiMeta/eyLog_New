//
//  MontesoryLevel3.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontesoryLevel3.h"
#import "MontessoryLevel4.h"


NSString *const kThirdLevelItem =@"level4";
NSString *const kThirdLEvelDescription =@"description";
NSString *const kThirdLevelGroup = @"group";
NSString *const kThirdLevelIdentifier =@"id";


@interface MontesoryLevel3 ()

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MontesoryLevel3

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
        self.thirdLevelDescription = [self objectOrNilForKey:kThirdLEvelDescription fromDictionary:dict];
        self.thirdLevelIdentifier = [[self objectOrNilForKey:kThirdLevelIdentifier fromDictionary:dict] doubleValue];
        self.thirdLevelGroup = [self objectOrNilForKey:kThirdLevelGroup fromDictionary:dict];
        NSObject *receiveMontessoryLevel = [dict objectForKey:kThirdLevelItem];
        NSMutableArray *parsedMontessory = [NSMutableArray array];
        if ([receiveMontessoryLevel isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receiveMontessoryLevel) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMontessory addObject:[MontessoryLevel4 modelObjectWithDictionary:item]];
                }
            }
        } else if ([receiveMontessoryLevel isKindOfClass:[NSDictionary class]]) {
            [parsedMontessory addObject:[MontessoryLevel4 modelObjectWithDictionary:(NSDictionary *)receiveMontessoryLevel]];
        }
        
        self.thirdLevelItem = [NSArray arrayWithArray:parsedMontessory];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.thirdLevelDescription forKey:kThirdLEvelDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.thirdLevelIdentifier] forKey:kThirdLevelIdentifier];
    [mutableDict setValue:self.thirdLevelGroup forKey:kThirdLevelGroup];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStatement] forKey:kThirdLevelItem];
    
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
    
    self.thirdLevelDescription = [aDecoder decodeObjectForKey:kThirdLEvelDescription];
    self.thirdLevelIdentifier = [aDecoder decodeDoubleForKey:kThirdLevelIdentifier];
    self.thirdLevelGroup = [aDecoder decodeObjectForKey:kThirdLevelGroup];
    self.thirdLevelItem = [aDecoder decodeObjectForKey:kThirdLevelItem];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_thirdLevelDescription forKey:kThirdLEvelDescription];
    [aCoder encodeObject:_thirdLevelGroup forKey:kThirdLevelGroup];
    [aCoder encodeDouble:_thirdLevelIdentifier forKey:kThirdLevelIdentifier];
    [aCoder encodeObject:_thirdLevelItem forKey:kThirdLevelItem];
}

- (id)copyWithZone:(NSZone *)zone
{
    MontesoryLevel3 *copy = [[MontesoryLevel3 alloc] init];
    
    if (copy) {
        
        copy.thirdLevelDescription = [self.thirdLevelDescription copyWithZone:zone];
        copy.thirdLevelIdentifier = self.thirdLevelIdentifier;
        copy.thirdLevelGroup = [self.thirdLevelGroup copyWithZone:zone];
        copy.thirdLevelItem = [self.thirdLevelItem copyWithZone:zone];
    }
    
    return copy;
}


@end
