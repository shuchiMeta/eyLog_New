//
//  InOutSeparateManagementEntity.h
//  eyLog
//
//  Created by Shuchi on 02/03/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface InOutSeparateManagementEntity : NSManagedObject

@property(strong,nonatomic)NSNumber *uid;
@property(retain,nonatomic)NSString *dateStr;
@property(retain,nonatomic)NSDate *date;
@property(retain,nonatomic)NSNumber *childId;
@property(retain,nonatomic)NSString *inTime;
@property(retain,nonatomic)NSString *outTime;
@property(assign,nonatomic)BOOL isInUploaded;
@property(assign,nonatomic)BOOL isOutUploaded;
@property(assign,nonatomic)BOOL isInUploading;
@property(assign,nonatomic)BOOL isOutUploading;

@property(retain,nonatomic)NSNumber *practitionerId;
@property(retain,nonatomic)NSString *practitionerPin;
@property(retain,nonatomic)NSString *timeStamp;

// Insert code here to declare functionality of your managed object subclass
+ (InOutSeparateManagementEntity *) createInRowContext:(NSManagedObjectContext *)a_context
                                               withUid:(NSNumber *)uid
                                           withDateStr:(NSString *)dateStr
                                              withDate:(NSDate *)date
                                           withChildId:(NSNumber *)childId
                                            withInTime:(NSString *)inTime
                                           withOutTime:(NSString *)outTime
                                      withisInUploaded:(BOOL )isInUploaded
                                     withIsOutUploaded:(BOOL )isOutUploaded
                                   withPractitionerPin:(NSString *)practitionerPin
                                    withPractitionerId:(NSNumber *)practitionerId
                                         withtimeStamp:(NSString *)timeStamp;

+(NSArray *) fetchAllDataInContext:(NSManagedObjectContext *)a_context;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded ;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded withIsOutUploaded:(BOOL)isOutUploaded andOutTime:(NSString *)outTime;
+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID;
+ (instancetype) updateInContext:(NSManagedObjectContext *) context withisInUploaded :(BOOL ) isInUploaded forChild :(NSNumber *) childID withDate:(NSString *)dateString andClientTimestamp:(NSString *)timestamp andUid:(NSNumber *)uid;
+(InOutSeparateManagementEntity *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded withChildID:(NSNumber *)childID andDateStr:(NSString *)str andInTime:(NSString *)inTime;
+(InOutSeparateManagementEntity *)fetchObservationInContext:(NSManagedObjectContext *)a_context withChildId:(NSNumber *)num andClientTimestamp:(NSString *)timestamp andDateStr:(NSString *)str;

+ (instancetype) updateInContext:(NSManagedObjectContext *) context withInOutSeparateManagementEntity:(InOutSeparateManagementEntity *)entity;
+(BOOL) deleteInContext:(NSManagedObjectContext *)a_context;


@end


