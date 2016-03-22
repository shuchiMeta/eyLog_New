//
//  LeuvenScale.h
//  eyLog
//
//  Created by Qss on 11/5/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LeuvenScale : NSManagedObject

@property (nonatomic, retain) NSString * leuvenScaleType;
@property (nonatomic, retain) NSNumber * scale;
@property (nonatomic, retain) NSString * signals;

+ (LeuvenScale *) createPractitionersInContext:(NSManagedObjectContext *)a_context
                           withLeuvenScaleType:(NSString *)a_leuvenScaleType
                                     withScale:(NSNumber *)a_scale
                                   withSignals:(NSString *)a_signals;

+(NSArray *) fetchAllLeuvenScaleInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchLeuvenInContext:(NSManagedObjectContext *)a_context withLeuvenScaleType:(NSString *)a_LeuvenScaleType;

+(NSArray *) fetchLeuvenInContext:(NSManagedObjectContext *)a_context withLeuvenScaleType:(NSString *)a_LeuvenScaleType andLeuvenScale:(NSNumber*)scale;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context;

@end
