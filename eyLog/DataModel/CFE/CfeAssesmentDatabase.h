//
//  CfeAssesmentDatabase.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CfeAssesmentDataBase : NSManagedObject

@property (nonatomic, retain) NSNumber * levelId;
@property (nonatomic, retain) NSString * levelDescription;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) UIColor * assesmentCfeColor;

+ (CfeAssesmentDataBase *) createCfeAssessmentInContext:(NSManagedObjectContext *)a_context
                                                          withLevelId:(NSNumber *)a_levelId
                                                 withLevelDescription:(NSString *)a_levelDescription
                                                            withColor:(NSString *)a_color;

+(NSArray *) fetchAllCfeAssessmentInContext:(NSManagedObjectContext *)a_context;
+(NSArray *)fetchCfeAssessmentInContext:(NSManagedObjectContext *)a_context withlevelId:(NSNumber *)a_levelId;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
//+(NSArray *) fetchMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context withStartAge:(NSNumber *)a_ageStart withEndAge:(NSNumber *)a_ageEnd;
//+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withLevelValue:(NSNumber *)a_levelValue;

@end
