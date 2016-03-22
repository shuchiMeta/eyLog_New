//
//  CfeLevelThree.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CfeLevelThree : NSManagedObject

@property (nonatomic, retain) NSString * levelThreeDescription;
@property (nonatomic, retain) NSString * levelThreeGroup;
@property (nonatomic, retain) NSNumber * levelThreeIdentifier;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property(nonatomic,retain)   NSString * frameworkType;

+ (CfeLevelThree *)createCfeLevelThreeInContext:(NSManagedObjectContext *)a_context
                 withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier
                   withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
                      withlevelThreeGroup:(NSString *)a_levelThreeGroup
                withlevelThreeDescription:(NSString *)a_levelThreeDescription
                        withFrameWorkType:(NSString *)a_frameworkType;

+(NSArray *)fetchCfeLevelTwoInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFramework:(NSString *)a_framework;

+(NSArray *)fetchCfeLevelThreeInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;


@end

