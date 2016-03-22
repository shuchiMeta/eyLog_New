//
//  ChildInOutTime.h
//  eyLog
//
//  Created by Arpan Dixit on 27/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChildInOutTime : NSManagedObject

@property (nonatomic, retain) NSNumber * childID;
@property (nonatomic, retain) NSString * currentDate;
@property (nonatomic, retain) NSString * inTime;
@property (nonatomic, retain) NSString * outTime;
@property (nonatomic, retain) NSNumber * uploadFlag;
@property (nonatomic, retain) NSNumber * uniqueTabletOID;
@property (nonatomic, retain) NSNumber * timeDifference;

+ (instancetype) createChildInOutTimeContext:(NSManagedObjectContext *) context;

+ (instancetype) createChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary;

+ (instancetype) updateChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forChild :(NSNumber *) childID withDate:(NSString *)dateString;

+ (instancetype) updateOrCreateChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forChild :(NSNumber *) childID withDate:(NSString *)dateString;

+(instancetype) fetchChildINOutInfo:(NSManagedObjectContext *)context withChildID:(NSNumber *)childID withDate:(NSString *)dateString;

+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context;


// This method is used to check if record exist

+ (int) isChildExist: (NSNumber *) childID withDate :(NSString *)dateString context :(NSManagedObjectContext *) context;

+ (void) deleteRecordForChild : (NSNumber *) childID withDate : (NSString *) dateString andDetails : (NSDictionary *) dictionary andContext : (NSManagedObjectContext *) context;
+(BOOL)updateRecord:(NSManagedObjectContext *)a_context withChildID:(NSNumber *)childID withDate:(NSString *)recordDate withInTimeValue:(NSString *)inTime withOutTimeValue:(NSString *)outTime withUploadFlag:(NSNumber *)uploadFlag;

+(NSArray *)fetchAllRecordsWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)a_context ;
+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID;
+(void)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context beforeDate:(NSString*)date;

+ (NSArray *) fetchSimilarRecordsForDate : (NSString *) dateString andChildID :(NSNumber *) childID andContext : (NSManagedObjectContext *) managedObjectcontext;


+ (void) deleteRecordForChildWithTimeDifference : (NSNumber *) timeDifference andContext : (NSManagedObjectContext *) context;

// New created by sumit
+(instancetype) fetchAllRecordsandUpdate:(NSManagedObjectContext *) context withChildDetails :(NSDictionary *) childInfo;
@end
