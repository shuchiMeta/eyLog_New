//
//  LevelOne.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LevelOne : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;

+ (LevelOne *)createLevelOneInContext:(NSManagedObjectContext *)a_context
                    withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                    withFrameworkIdentifier:(NSString *)a_frameworkType
                    withLevelOneDescription:(NSString *)a_levelOneDescription
                    withLevelOneGroup:(NSString *)a_levelOneGroup;

+(NSArray *)fetchAllLevelOneInContext:(NSManagedObjectContext *)a_context;

+(NSArray *)fetchLevelOneInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
