//
//  Ecat.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface Ecat : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;


+ (Ecat *) createEcatInContext:(NSManagedObjectContext *)a_context
                    withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                         withFrameworkType:(NSString *)a_frameworkType
                   withlevelOneDescription:(NSString *)a_levelOneDescription;

+(NSArray *) fetchALLEcatInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchEcatInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameWork:(NSString *)a_framework;

//+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelOneGroup:(NSNumber *)a_levelOneGroup withFrameWork:(NSString *)a_framework;
//+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelTwoGroup:(NSNumber *)a_levelTwoGroup withFrameWork:(NSString *)a_framework;
//+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFrameWork:(NSString *)a_framework;

+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
