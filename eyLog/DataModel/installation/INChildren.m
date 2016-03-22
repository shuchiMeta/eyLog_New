//
//  INChildren.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INChildren.h"
#import "INData.h"
#import "INPhotos.h"



NSString *const kINChildrenData = @"data";
NSString *const kINChildrenPhotos = @"photos";



@interface INChildren ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INChildren

@synthesize data = _data;
@synthesize photos = _photos;

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
    NSObject *receivedINData = [dict objectForKey:kINChildrenData];
    NSMutableArray *parsedINData = [NSMutableArray array];
    if ([receivedINData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedINData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedINData addObject:[INData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedINData isKindOfClass:[NSDictionary class]]) {
       [parsedINData addObject:[INData modelObjectWithDictionary:(NSDictionary *)receivedINData]];
    }

            self.data = [NSArray arrayWithArray:parsedINData];
            self.photos = [INPhotos modelObjectWithDictionary:[dict objectForKey:kINChildrenPhotos]];
        


    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kINChildrenData];
    [mutableDict setValue:[self.photos dictionaryRepresentation] forKey:kINChildrenPhotos];
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

    self.data = [aDecoder decodeObjectForKey:kINChildrenData];
    self.photos = [aDecoder decodeObjectForKey:kINChildrenPhotos];
       return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kINChildrenData];
    [aCoder encodeObject:_photos forKey:kINChildrenPhotos];
 
    
}

- (id)copyWithZone:(NSZone *)zone
{
    INChildren *copy = [[INChildren alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
        copy.photos = [self.photos copyWithZone:zone];
           }
    
    return copy;
}


@end
