//
//  OBEcat.m
//  eyLog
//
//  Created by Arpan Dixit on 14/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "OBEcat.h"
#import "AppDelegate.h"
#import "Ecat.h"
#import "EcatStatement.h"
#import "EcatAspect.h"
#import "MontessoriAssesmentDataBase.h"

NSString *const kOBEcatFrameworkLevelNumber = @"ecat_framework_level_number";//@"montessori_assessment";//@"montessori_framework_level_number";
NSString *const kOBEcatFrameworkItemId = @"ecat_id";
NSString *const kOBEcatLevelTwoItemId = @"ecat_level_two_item_id";

@interface OBEcat ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBEcat

@synthesize ecatFrameworkLevelNumber = _ecatFrameworkLevelNumber;
@synthesize ecatFrameworkItemId = _ecatFrameworkItemId;
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
        self.ecatFrameworkLevelNumber = [self objectOrNilForKey:kOBEcatFrameworkLevelNumber fromDictionary:dict];
        self.ecatFrameworkItemId = [self objectOrNilForKey:kOBEcatFrameworkItemId fromDictionary:dict];
 //       LevelFour * levelFour = [[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:self.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])] firstObject];
        EcatStatement *levelFour=[[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:self.ecatFrameworkItemId withFramework:@"Ecat"] firstObject];
        if (levelFour) {
            self.levelTwoIdentifier = levelFour.levelTwoIdentifier;
        }
        else{
            EcatAspect *levelThree=[[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withlevelTwoIdentifier:self.ecatFrameworkItemId withFramework:@"Ecat"] firstObject];
           // LevelThree * levelThree = [[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:self.montessoriFrameworkItemId withFramework:NSStringFromClass([Montessori class])] firstObject];
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
    [mutableDict setValue:self.ecatFrameworkLevelNumber forKey:kOBEcatFrameworkLevelNumber];
    [mutableDict setValue:self.ecatFrameworkItemId forKey:kOBEcatFrameworkItemId];
    [mutableDict setValue:self.levelTwoIdentifier forKey:kOBEcatLevelTwoItemId];

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

    self.ecatFrameworkLevelNumber = [aDecoder decodeObjectForKey:kOBEcatFrameworkLevelNumber];
    self.ecatFrameworkItemId = [aDecoder decodeObjectForKey:kOBEcatFrameworkItemId];
    self.levelTwoIdentifier = [aDecoder decodeObjectForKey:kOBEcatLevelTwoItemId];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ecatFrameworkLevelNumber forKey:kOBEcatFrameworkLevelNumber];
    [aCoder encodeObject:_ecatFrameworkItemId forKey:kOBEcatFrameworkItemId];
    [aCoder encodeObject:_levelTwoIdentifier forKey:kOBEcatLevelTwoItemId];

}

- (id)copyWithZone:(NSZone *)zone
{
    OBEcat *copy = [[OBEcat alloc] init];

    if (copy) {

        copy.ecatFrameworkLevelNumber = [self.ecatFrameworkLevelNumber copyWithZone:zone];
        copy.ecatFrameworkItemId = [self.ecatFrameworkItemId copyWithZone:zone];
        copy.levelTwoIdentifier = [self.levelTwoIdentifier copyWithZone:zone];

    }

    return copy;
}


@end
