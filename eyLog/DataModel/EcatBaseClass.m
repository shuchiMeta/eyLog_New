//
//  EcatBaseClass.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatBaseClass.h"
#import "EcatAreaClass.h"
NSString *const kecatArea=@"area";

@implementation EcatBaseClass
@synthesize AreaArray=_AreaArray;

+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSObject *receivedEcatArea = [dict objectForKey:kecatArea];
    
        NSMutableArray *parsedEcatArea = [NSMutableArray array];
        if ([receivedEcatArea isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedEcatArea) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedEcatArea addObject:[EcatAreaClass modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedEcatArea isKindOfClass:[NSDictionary class]]) {
            [parsedEcatArea addObject:[EcatAreaClass modelObjectWithDictionary:(NSDictionary *)receivedEcatArea]];
        }
        
        self.AreaArray = [NSArray arrayWithArray:parsedEcatArea];
    }
    return self;
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForArea = [NSMutableArray array];
    for (NSObject *subArrayObject in self.AreaArray) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForArea addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForArea addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kecatArea];
    
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
    self.AreaArray = [aDecoder decodeObjectForKey:kecatArea];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_AreaArray forKey:kecatArea];
}

- (id)copyWithZone:(NSZone *)zone
{
    EcatBaseClass *copy = [[EcatBaseClass alloc] init];
    
    if (copy) {
        copy.AreaArray = [self.AreaArray copyWithZone:zone];
    }
    
    return copy;
}

@end
