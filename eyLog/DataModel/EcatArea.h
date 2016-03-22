//
//  EcatArea.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EcatArea : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;

+ (EcatArea *)createEcatAreaInContext:(NSManagedObjectContext *)a_context
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
              withFrameworkIdentifier:(NSString *)a_frameworkType
              withLevelOneDescription:(NSString *)a_levelOneDescription;

+(NSArray *)fetchAllEcatAreaInContext:(NSManagedObjectContext *)a_context;

+(NSArray *)fetchEcatAreaInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
