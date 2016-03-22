//
//  Cfe.h
//  eyLog
//
//  Created by shuchi on 03/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Cfe : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic ,retain) NSNumber *levelThreeIdentifier;

+ (Cfe *) createCfeInContext:(NSManagedObjectContext *)a_context
                    withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                         withFrameworkType:(NSString *)a_frameworkType
                         withLevelOneGroup:(NSString *)a_levelgroup
                   withlevelOneDescription:(NSString *)a_levelOneDescription;

+(NSArray *) fetchALLCfeInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchCfeInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchCfeInContext:(NSManagedObjectContext *)a_context withlevelOneGroup:(NSNumber *)a_levelOneGroup withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchCfeInContext:(NSManagedObjectContext *)a_context withlevelTwoGroup:(NSNumber *)a_levelTwoGroup withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchCfeInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
