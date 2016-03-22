//
//  EcatAspect.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface EcatAspect : NSManagedObject

@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic, retain) NSString * levelTwoDescription;
@property (nonatomic, retain) NSNumber * levelTwoIdentifier;
@property(nonatomic,retain) NSString * frameworkType;


+ (EcatAspect *)createEcatAspectInContext:(NSManagedObjectContext *)a_context
               withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
              withlevelTwoDescription:(NSString *)a_levelTwoDescription
                    withFrameWorkType:(NSString *)a_frameworkType;

+(NSArray *)fetchEcatAspectInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework;

+(NSArray *)fetchEcatAspectInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
