//
//  Montessori.h
//  eyLog
//
//  Created by Shobhit on 27/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Montessori : NSManagedObject

@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * levelOneDescription;
@property (nonatomic, retain) NSString * levelOneGroup;
@property (nonatomic, retain) NSNumber * levelOneIdentifier;
@property (nonatomic ,retain) NSNumber *levelThreeIdentifier;

+ (Montessori *) createMontessoriInContext:(NSManagedObjectContext *)a_context
                    withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                         withFrameworkType:(NSString *)a_frameworkType
                         withLevelOneGroup:(NSString *)a_levelgroup
                   withlevelOneDescription:(NSString *)a_levelOneDescription;

+(NSArray *) fetchALLMontessoriInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelOneGroup:(NSNumber *)a_levelOneGroup withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelTwoGroup:(NSNumber *)a_levelTwoGroup withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
