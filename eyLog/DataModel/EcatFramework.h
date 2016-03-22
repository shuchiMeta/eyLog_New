//
//  EcatFramework.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EcatFramework : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * frameworkType;

+(NSArray *)fetchEcatFrameworkInContext:(NSManagedObjectContext *)a_context withFramework:(NSString *)a_framework;

+(EcatFramework *)createEcatFrameworkInContext:(NSManagedObjectContext *)a_context
                                      withLevelIdentifier:(NSNumber *)a_levelIdentifier
                                        withFrameworkType:(NSString *)a_frameworkType
                                     withLevelDescription:(NSString *)a_levelDescription;

+(NSArray *)fetchEcatFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
