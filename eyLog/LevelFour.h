//
//  LevelFour.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LevelFour : NSManagedObject

@property(nonatomic,retain)NSNumber * levelFourIdentifier;
@property (nonatomic, retain) NSNumber * levelThreeIdentifier;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property (nonatomic, retain) NSString * levelFourDescription;
@property (nonatomic, retain) NSString * levelFourGroup;
@property(nonatomic,retain) NSString * frameworkType;



+(LevelFour *)createLevelFourInContext:(NSManagedObjectContext *)a_context
                withLevelTwoidentifier:(NSNumber *)a_levelTwoIdentifier
                     withFrameworkType:(NSString *)a_frameworkType
              withLevelFourDescription:(NSString *)a_levelFourDescription
                    withLevelFourGroup:(NSString *)a_levelFourGroup
              withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier
               withLevelFourIdentifier:(NSNumber *)a_levelFourIdentifier;

+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withlevelFourIdentifier:(NSNumber *)a_levelFourIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_LevelThreeIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchLevelTwoInContext:(NSManagedObjectContext *)a_context withLevelTwoIdentifier:(NSNumber *)a_LevelTwoIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
