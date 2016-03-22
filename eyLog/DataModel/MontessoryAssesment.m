//
//  MontessoryAssesment.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryAssesment.h"

NSString *const kMontessoryLevelID=@"level_id";
NSString *const kMontessoryLevelDescription = @"level_description";
NSString *const kMontessoryColor =@"color";

@interface MontessoryAssesment ()

@end


@implementation MontessoryAssesment 

@synthesize levelID = _levelID;
@synthesize levelDescription = _levelDescription;
@synthesize color = _color;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self  = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]){
        self.levelID = [[self objectOrNilForKey:kMontessoryLevelID fromDictionary:dict ]doubleValue];
        self.levelDescription = [self objectOrNilForKey:kMontessoryLevelDescription fromDictionary:dict];
        self.color = [self objectOrNilForKey:kMontessoryColor fromDictionary:dict];
    }
    return self;
}

-(NSDictionary *)dictionaryRepresentation{

    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.levelID] forKey:kMontessoryLevelID];
    [mutableDict setValue:self.levelDescription forKey:kMontessoryLevelDescription];
    [mutableDict setValue:self.color forKey:kMontessoryColor];
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
    self.levelID = [aDecoder decodeDoubleForKey:kMontessoryLevelID];
    self.levelDescription = [aDecoder decodeObjectForKey:kMontessoryLevelDescription];
    self.color =[aDecoder decodeObjectForKey:kMontessoryColor];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:_levelID forKey:kMontessoryLevelID];
    [aCoder encodeObject:_levelDescription forKey:kMontessoryLevelDescription];
    [aCoder encodeObject:_color forKey:kMontessoryColor];
}

-(id)copyWithZone:(NSZone *)zone{
    MontessoryAssesment *copy = [[MontessoryAssesment alloc]init];
    if(copy){
        copy.levelID= self.levelID;
        copy.levelDescription = self.levelDescription;
        copy.color = self.color;
    }
    return copy;
}

@end
