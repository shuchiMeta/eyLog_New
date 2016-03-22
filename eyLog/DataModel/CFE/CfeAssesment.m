//
//  CfeAssesment.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeAssesment.h"

NSString *const kCfeLevelID=@"level_id";
NSString *const kCfeLevelDescription = @"level_description";
NSString *const kCfeColor =@"color";

@interface CfeAssesment ()

@end


@implementation CfeAssesment

@synthesize levelID = _levelID;
@synthesize levelDescription = _levelDescription;
@synthesize color = _color;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self  = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.levelID = [[self objectOrNilForKey:kCfeLevelID fromDictionary:dict ]doubleValue];
        self.levelDescription = [self objectOrNilForKey:kCfeLevelDescription fromDictionary:dict];
        self.color = [self objectOrNilForKey:kCfeColor fromDictionary:dict];
    }
    return self;
}

-(NSDictionary *)dictionaryRepresentation{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelID] forKey:kCfeLevelID];
    [mutableDict setValue:self.levelDescription forKey:kCfeLevelDescription];
    [mutableDict setValue:self.color forKey:kCfeColor];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

#pragma mark Helper Method

-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null ]] ? nil :object;
}

#pragma mark -NSCoding Method

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.levelID = [aDecoder decodeDoubleForKey:kCfeLevelID];
    self.levelDescription = [aDecoder decodeObjectForKey:kCfeLevelDescription];
    self.color =[aDecoder decodeObjectForKey:kCfeColor];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:_levelID forKey:kCfeLevelID];
    [aCoder encodeObject:_levelDescription forKey:kCfeLevelDescription];
    [aCoder encodeObject:_color forKey:kCfeColor];
}

-(id)copyWithZone:(NSZone *)zone{
    CfeAssesment *copy = [[CfeAssesment alloc]init];
    if(copy){
        copy.levelID= self.levelID;
        copy.levelDescription = self.levelDescription;
        copy.color = self.color;
    }
    return copy;
}

@end
