//
//  CfeLevelOne.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CfeLevelOne : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;

+ (CfeLevelOne *)createCfeLevelOneInContext:(NSManagedObjectContext *)a_context
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
              withFrameworkIdentifier:(NSString *)a_frameworkType
              withLevelOneDescription:(NSString *)a_levelOneDescription
                    withLevelOneGroup:(NSString *)a_levelOneGroup;

+(NSArray *)fetchAllCfeLevelOneInContext:(NSManagedObjectContext *)a_context;

+(NSArray *)fetchCfeLevelOneInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
