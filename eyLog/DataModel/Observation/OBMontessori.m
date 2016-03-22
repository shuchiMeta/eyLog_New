//
//  OBMontessori.m
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "OBMontessori.h"
#import "AppDelegate.h"
#import "Montessori.h"
#import "LevelFour.h"
#import "LevelThree.h"
#import "MontessoriAssesmentDataBase.h"

//TODO : test this .. 
NSString *const kOBMontessoriMontessoriFrameworkLevelNumber = @"montessori_assessment";//@"montessori_framework_level_number";
NSString *const kOBMontessoriMontessoriFrameworkItemId = @"montessori_framework_item_id";
NSString *const kOBMontessoriLevelTwoItemId = @"montessori_level_two_item_id";
NSString *const kColor = @"color";

//NSString *const kOBMontessoriLevelThreeIDentifier =@"";

@interface OBMontessori ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBMontessori

@synthesize montessoriFrameworkLevelNumber = _montessoriFrameworkLevelNumber;
@synthesize montessoriFrameworkItemId = _montessoriFrameworkItemId;
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
        self.montessoriFrameworkLevelNumber = [self objectOrNilForKey:kOBMontessoriMontessoriFrameworkLevelNumber fromDictionary:dict];
        self.montessoriFrameworkItemId = [self objectOrNilForKey:kOBMontessoriMontessoriFrameworkItemId fromDictionary:dict];
        LevelFour * levelFour = [[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:self.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])] firstObject];
        if (levelFour) {
            self.levelTwoIdentifier = levelFour.levelTwoIdentifier;
        }
        else{
            LevelThree * levelThree = [[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:self.montessoriFrameworkItemId withFramework:NSStringFromClass([Montessori class])] firstObject];
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
    [mutableDict setValue:self.montessoriFrameworkLevelNumber forKey:kOBMontessoriMontessoriFrameworkLevelNumber];
    [mutableDict setValue:self.montessoriFrameworkItemId forKey:kOBMontessoriMontessoriFrameworkItemId];
    [mutableDict setValue:self.levelTwoIdentifier forKey:kOBMontessoriLevelTwoItemId];

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

    self.montessoriFrameworkLevelNumber = [aDecoder decodeObjectForKey:kOBMontessoriMontessoriFrameworkLevelNumber];
    self.montessoriFrameworkItemId = [aDecoder decodeObjectForKey:kOBMontessoriMontessoriFrameworkItemId];
    self.levelTwoIdentifier = [aDecoder decodeObjectForKey:kOBMontessoriLevelTwoItemId];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_montessoriFrameworkLevelNumber forKey:kOBMontessoriMontessoriFrameworkLevelNumber];
    [aCoder encodeObject:_montessoriFrameworkItemId forKey:kOBMontessoriMontessoriFrameworkItemId];
    [aCoder encodeObject:_levelTwoIdentifier forKey:kOBMontessoriLevelTwoItemId];

}

- (id)copyWithZone:(NSZone *)zone
{
    OBMontessori *copy = [[OBMontessori alloc] init];
    
    if (copy) {

        copy.montessoriFrameworkLevelNumber = [self.montessoriFrameworkLevelNumber copyWithZone:zone];
        copy.montessoriFrameworkItemId = [self.montessoriFrameworkItemId copyWithZone:zone];
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
