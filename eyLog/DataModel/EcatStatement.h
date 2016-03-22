//
//  EcatStatement.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@interface EcatStatement : NSManagedObject

@property (nonatomic, retain) NSString * levelThreeDescription;
@property (nonatomic, retain) NSNumber * levelThreeIdentifier;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property(nonatomic,retain) NSString * frameworkType;

+ (EcatStatement *)createEcatStatementInContext:(NSManagedObjectContext *)a_context
                 withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier
                   withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
                withlevelThreeDescription:(NSString *)a_levelThreeDescription
                        withFrameWorkType:(NSString *)a_frameworkType;

+(NSArray *)fetchEcatStatementInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFramework:(NSString *)a_framework;

+(NSArray *)fetchEcatStatementInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
