//
//  Ethnicity.h
//  eyLog
//
//  Created by shuchi on 14/10/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Ethnicity : NSManagedObject
@property (nonatomic, retain) NSString * ethnicityDesc;
@property (nonatomic, retain) NSNumber * ethnicityId;
@property (nonatomic ,retain) NSNumber *parent;
@property (nonatomic, retain) NSNumber * ethnicitychildid;
//ethnicitychildid

+ (Ethnicity *) createInContext:(NSManagedObjectContext *)a_context
      withethnicityDesc:(NSString *)ethnicityDesc
           withethnicityId:(NSNumber *)ethnicityId
                        withparent:(NSNumber *)parent
           withEthnicityChildid:(NSNumber *)ethnicitychildid;
+(Ethnicity *) fetchInContext:(NSManagedObjectContext *)a_context withethnicitychildid:(NSNumber *)ethnicitychildid ;


+(Ethnicity *) fetchInContext:(NSManagedObjectContext *)a_context withethnicityId:(NSNumber *)ethnicityId;
+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context;
@end
