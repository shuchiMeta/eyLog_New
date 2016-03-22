//
//  Framework.h
//  eyLog
//
//  Created by Qss on 11/13/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Framework : NSManagedObject

@property (nonatomic, retain) NSString * areaDesc;
@property (nonatomic, retain) NSNumber * areaIdentifier;
@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * shortDesc;

+(NSArray *) fetchframeworkInContext:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;



+ (Framework *) createFrameworkInContext:(NSManagedObjectContext *)a_context
                      withAreaIdentifier:(NSNumber *)a_areaIdentifier
                       withFrameworkType:(NSString *)a_frameworkType
                           withShortDesc:(NSString *)a_shortDesc
                            withAreaDesc:(NSString *)a_areaDesc;

+(NSArray *) fetchFrameworkInContext:(NSManagedObjectContext *)a_context withAreaIdentifier:(NSNumber *)a_areaIdentifier withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
