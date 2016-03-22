//
//  LevelTwo.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LevelTwo : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelTwoDescription;
@property (nonatomic, retain) NSString * levelTwoGroup;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property(nonatomic,retain) NSString * frameworkType;


+ (LevelTwo *)createLevelTwoInContext:(NSManagedObjectContext *)a_context
               withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                    withlevelTwoGroup:(NSString *)a_levelTwoGroup
              withlevelTwoDescription:(NSString *)a_levelTwoDescription
                    withFrameWorkType:(NSString *)a_frameworkType;

+(NSArray *)fetchLvelTwoInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;

+(NSArray *)fetchLevelTwoInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
