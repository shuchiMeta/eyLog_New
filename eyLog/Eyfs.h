//
//  Eyfs.h
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Eyfs : NSManagedObject

@property (nonatomic, retain) NSString * areaDesc;
@property (nonatomic, retain) NSString * shortDesc;
@property (nonatomic, retain) NSNumber * areaIdentifier;
@property (nonatomic, retain) NSString * frameworkType;
+ (Eyfs *) createEyfsInContext:(NSManagedObjectContext *)a_context
                     withAreaIdentifier:(NSNumber *)a_areaIdentifier
                      withFrameworkType:(NSString *)a_frameworkType
                          withShortDesc:(NSString *)a_shortDesc
                           withAreaDesc:(NSString *)a_areaDesc;
+(NSArray *) fetchALLEyfsInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchEyfsInContext:(NSManagedObjectContext *)a_context withAreaIdentifier:(NSNumber *)a_areaIdentifier withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
