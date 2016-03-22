//
//  MontessoriFramework.h
//  eyLog
//
//  Created by Shobhit on 27/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MontessoriFramework : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSString * frameworkType;

+(NSArray *)fetchMontessoryFrameworkInContext:(NSManagedObjectContext *)a_context withFramework:(NSString *)a_framework;

+(MontessoriFramework *)createMotessoriFrameworkInContext:(NSManagedObjectContext *)a_context
                                       withLevelIdentifier:(NSNumber *)a_levelIdentifier
                                        withFrameworkType:(NSString *)a_frameworkType
                                     withLevelDescription:(NSString *)a_levelDescription
                                           withLevelGroup:(NSString *)a_levelGroup;

+(NSArray *)fetchMontessoryFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;


@end
