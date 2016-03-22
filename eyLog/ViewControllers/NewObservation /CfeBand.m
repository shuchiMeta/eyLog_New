//
//  CfeBand.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeBand.h"

@implementation CfeBand


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.levelIdentifier = [aDecoder decodeObjectForKey:@"levelIdentifier"];
    self.levelNumber = [aDecoder decodeObjectForKey:@"levelNumber"];
    self.rgbColor = [aDecoder decodeObjectForKey:@"rgbColor"];
    self.backgroundColor = [aDecoder decodeObjectForKey:@"backgroundColor"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_levelIdentifier forKey:@"levelIdentifier"];
    [aCoder encodeObject:_levelNumber forKey:@"levelNumber"];
    [aCoder encodeObject:_rgbColor forKey:@"rgbColor"];
    [aCoder encodeObject:_backgroundColor forKey:@"backgroundColor"];
    
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.levelIdentifier forKey:@"levelIdentifier"];
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
