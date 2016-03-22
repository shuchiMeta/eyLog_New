//
//  RegistryDataEntity.h
//  eyLog
//
//  Created by Shuchi on 02/03/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RegistryDataEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property(retain,nonatomic)NSNumber *uid;
@property(retain,nonatomic)NSData *jsonDict;
@property(retain,nonatomic)NSString *dateStr;
@property(retain,nonatomic)NSDate *date;
@property(retain,nonatomic)NSNumber *childId;
@property(assign,nonatomic)BOOL isUploading;

+(RegistryDataEntity *)createRowInContext:(NSManagedObjectContext*)context
                                  withUid:(NSNumber *)num
                             withJsonDict:(NSData *)data
                              withdateStr:(NSString *)datestr
                                 withDate:(NSDate *)date
                              withChildId:(NSNumber *)childId;

+(NSArray *)fetchAllEntriesInEntityWithContext:(NSManagedObjectContext *)context;

+(BOOL)deleteRowAndContext:(NSManagedObjectContext *)a_context;
+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID andDateStr:(NSString *)str;

@end


