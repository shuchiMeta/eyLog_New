//
//  CfeFramework.h
//  eyLog
//
//  Created by shuchi on 03/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CfeFramework : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSString * frameworkType;

+(NSArray *)fetchCfeFrameworkInContext:(NSManagedObjectContext *)a_context withFramework:(NSString *)a_framework;

+(CfeFramework *)createCfeFrameworkInContext:(NSManagedObjectContext *)a_context
                                      withLevelIdentifier:(NSNumber *)a_levelIdentifier
                                        withFrameworkType:(NSString *)a_frameworkType
                                     withLevelDescription:(NSString *)a_levelDescription
                                           withLevelGroup:(NSString *)a_levelGroup;

+(NSArray *)fetchCfeFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
