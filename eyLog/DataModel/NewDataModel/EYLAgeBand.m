//
//  EYLAgeBand.m
//  eyLog
//
//  Created by Shivank Agarwal on 27/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLAgeBand.h"

@implementation EYLAgeBand

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.ageIdentifier = [aDecoder decodeObjectForKey:@"ageIdentifier"];
    self.levelNumber = [aDecoder decodeObjectForKey:@"levelNumber"];
    self.rgbColor = [aDecoder decodeObjectForKey:@"rgbColor"];
    self.backgroundColor = [aDecoder decodeObjectForKey:@"backgroundColor"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ageIdentifier forKey:@"ageIdentifier"];
    [aCoder encodeObject:_levelNumber forKey:@"levelNumber"];
    [aCoder encodeObject:_rgbColor forKey:@"rgbColor"];
    [aCoder encodeObject:_backgroundColor forKey:@"backgroundColor"];
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ageIdentifier forKey:@"ageIdentifier"];
    [mutableDict setValue:self.levelNumber forKey:@"levelNumber"];
    [mutableDict setValue:self.rgbColor forKey:@"rgbColor"];
    [mutableDict setValue:self.backgroundColor forKey:@"backgroundColor"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}
@end
