//
//  CfeLevelTwo.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CfeLevelTwo : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelTwoDescription;
@property (nonatomic, retain) NSString * levelTwoGroup;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property(nonatomic,retain) NSString * frameworkType;


+ (CfeLevelTwo *)createCfeLevelTwoInContext:(NSManagedObjectContext *)a_context
               withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                    withlevelTwoGroup:(NSString *)a_levelTwoGroup
              withlevelTwoDescription:(NSString *)a_levelTwoDescription
                    withFrameWorkType:(NSString *)a_frameworkType;

+(NSArray *)fetchCfeLvelTwoInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;

+(NSArray *)fetchCfeLevelTwoInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
