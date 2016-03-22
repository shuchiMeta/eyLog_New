//
//  INPractitioners.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INPractitioners.h"
#import "INPhotos.h"
#import "INData.h"


NSString *const kINPractitionersPhotos = @"photos";
NSString *const kINPractitionersTotalResult = @"total_result";
NSString *const kINPractitionersNurseryId = @"nursery_id";
NSString *const kINPractitionersData = @"data";


@interface INPractitioners ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INPractitioners

@synthesize photos = _photos;
@synthesize totalResult = _totalResult;
@synthesize nurseryId = _nurseryId;
@synthesize data = _data;


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
            self.photos = [INPhotos modelObjectWithDictionary:[dict objectForKey:kINPractitionersPhotos]];
            self.totalResult = [[self objectOrNilForKey:kINPractitionersTotalResult fromDictionary:dict] doubleValue];
            self.nurseryId = [[self objectOrNilForKey:kINPractitionersNurseryId fromDictionary:dict] doubleValue];
    NSObject *receivedINData = [dict objectForKey:kINPractitionersData];
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

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.photos dictionaryRepresentation] forKey:kINPractitionersPhotos];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalResult] forKey:kINPractitionersTotalResult];
    [mutableDict setValue:[NSNumber numberWithDouble:self.nurseryId] forKey:kINPractitionersNurseryId];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kINPractitionersData];

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

    self.photos = [aDecoder decodeObjectForKey:kINPractitionersPhotos];
    self.totalResult = [aDecoder decodeDoubleForKey:kINPractitionersTotalResult];
    self.nurseryId = [aDecoder decodeDoubleForKey:kINPractitionersNurseryId];
    self.data = [aDecoder decodeObjectForKey:kINPractitionersData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_photos forKey:kINPractitionersPhotos];
    [aCoder encodeDouble:_totalResult forKey:kINPractitionersTotalResult];
    [aCoder encodeDouble:_nurseryId forKey:kINPractitionersNurseryId];
    [aCoder encodeObject:_data forKey:kINPractitionersData];
}

- (id)copyWithZone:(NSZone *)zone
{
    INPractitioners *copy = [[INPractitioners alloc] init];
    
    if (copy) {

        copy.photos = [self.photos copyWithZone:zone];
        copy.totalResult = self.totalResult;
        copy.nurseryId = self.nurseryId;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
