//
//  OBObservation.m
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "OBObservation.h"
#import "OBData.h"


NSString *const kOBObservationStatus = @"status";
NSString *const kOBObservationData = @"data";
NSString *const kOBObservationTotalCount = @"total_count";
NSString *const kOBObservationTotalRecords = @"total_records";


@interface OBObservation ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBObservation

@synthesize status = _status;
@synthesize data = _data;
@synthesize totalCount = _totalCount;
@synthesize totalRecords = _totalRecords;


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
        self.status = [self objectOrNilForKey:kOBObservationStatus fromDictionary:dict];
        NSObject *receivedOBData = [dict objectForKey:kOBObservationData];
        NSMutableArray *parsedOBData = [NSMutableArray array];
        if ([receivedOBData isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBData) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBData addObject:[OBData modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBData isKindOfClass:[NSDictionary class]]) {
            [parsedOBData addObject:[OBData modelObjectWithDictionary:(NSDictionary *)receivedOBData]];
        }
        
        self.data = [NSArray arrayWithArray:parsedOBData];
        self.totalCount = [self objectOrNilForKey:kOBObservationTotalCount fromDictionary:dict];
        self.totalRecords = [[self objectOrNilForKey:kOBObservationTotalRecords fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kOBObservationStatus];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kOBObservationData];
    [mutableDict setValue:self.totalCount forKey:kOBObservationTotalCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalRecords] forKey:kOBObservationTotalRecords];

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

    self.status = [aDecoder decodeObjectForKey:kOBObservationStatus];
    self.data = [aDecoder decodeObjectForKey:kOBObservationData];
    self.totalCount = [aDecoder decodeObjectForKey:kOBObservationTotalCount];
    self.totalRecords = [aDecoder decodeDoubleForKey:kOBObservationTotalRecords];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kOBObservationStatus];
    [aCoder encodeObject:_data forKey:kOBObservationData];
    [aCoder encodeObject:_totalCount forKey:kOBObservationTotalCount];
    [aCoder encodeDouble:_totalRecords forKey:kOBObservationTotalRecords];
}

- (id)copyWithZone:(NSZone *)zone
{
    OBObservation *copy = [[OBObservation alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.totalCount = [self.totalCount copyWithZone:zone];
        copy.totalRecords = self.totalRecords;
    }
    
    return copy;
}


@end
