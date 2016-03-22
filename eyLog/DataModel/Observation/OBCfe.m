//
//  OBCfe.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "OBCfe.h"
#import "AppDelegate.h"
#import "Cfe.h"
#import "CfeLevelFour.h"
#import "CfeLevelThree.h"
#import "CfeAssesmentDataBase.h"

//TODO : test this ..
NSString *const kOBCfeCfeFrameworkLevelNumber = @"scottish_assessment";//@"montessori_framework_level_number";
NSString *const kOBCfeCfeFrameworkItemId = @"scottish_framework_item_id";
NSString *const kOBCfeLevelTwoItemId = @"cfe_level_two_item_id";
NSString *const kOBCfeColor = @"color";
//
//NSString *const kOBMontessoriLevelThreeIDentifier =@"";

@interface OBCfe ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBCfe

@synthesize cfeFrameworkLevelNumber = _cfeFrameworkLevelNumber;
@synthesize cfeFrameworkItemId = _cfeFrameworkItemId;
@synthesize levelTwoIdentifier = _levelTwoIdentifier;

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
        self.cfeFrameworkLevelNumber = [self objectOrNilForKey:kOBCfeCfeFrameworkLevelNumber fromDictionary:dict];
        self.cfeFrameworkItemId = [self objectOrNilForKey:kOBCfeCfeFrameworkItemId fromDictionary:dict];
        CfeLevelFour * levelFour = [[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:self.cfeFrameworkItemId withFrameWork:NSStringFromClass([Cfe class])] firstObject];
        if (levelFour) {
            self.levelTwoIdentifier = levelFour.levelTwoIdentifier;
        }
        else{
            CfeLevelThree * levelThree = [[CfeLevelThree fetchCfeLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:self.cfeFrameworkItemId withFramework:NSStringFromClass([Cfe class])] firstObject];
            if (levelThree) {
                self.levelTwoIdentifier = levelThree.levelTwoIdentifier;
            }
        }
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cfeFrameworkLevelNumber forKey:kOBCfeCfeFrameworkLevelNumber];
    [mutableDict setValue:self.cfeFrameworkItemId forKey:kOBCfeCfeFrameworkItemId];
    [mutableDict setValue:self.levelTwoIdentifier forKey:kOBCfeLevelTwoItemId];
    
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
    
    self.cfeFrameworkLevelNumber = [aDecoder decodeObjectForKey:kOBCfeCfeFrameworkLevelNumber];
    self.cfeFrameworkItemId = [aDecoder decodeObjectForKey:kOBCfeCfeFrameworkItemId];
    self.levelTwoIdentifier = [aDecoder decodeObjectForKey:kOBCfeLevelTwoItemId];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cfeFrameworkLevelNumber forKey:kOBCfeCfeFrameworkLevelNumber];
    [aCoder encodeObject:_cfeFrameworkItemId forKey:kOBCfeCfeFrameworkItemId];
    [aCoder encodeObject:_levelTwoIdentifier forKey:kOBCfeLevelTwoItemId];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    OBCfe *copy = [[OBCfe alloc] init];
    
    if (copy) {
        
        copy.cfeFrameworkLevelNumber = [self.cfeFrameworkLevelNumber copyWithZone:zone];
        copy.cfeFrameworkItemId = [self.cfeFrameworkItemId copyWithZone:zone];
        copy.levelTwoIdentifier = [self.levelTwoIdentifier copyWithZone:zone];
        
    }
    
    return copy;
}
//-(NSNumber *)levelThreeIdentifier{
//    if (!_levelThreeIdentifier) {
////        _levelThreeIdentifier = [[[LevelFour fetchStatementInContext:[AppDelegate context] withStatementIdentifier:self.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject] ageIdentifier];
// _levelThreeIdentifier = [[[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:self.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])]lastObject]levelThreeIdentifier];
//    }
//    return _levelThreeIdentifier;
//}

@end
