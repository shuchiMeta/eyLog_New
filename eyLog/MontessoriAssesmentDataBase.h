//
//  MontessoriAssesmentDataBase.h
//  eyLog
//
//  Created by Shobhit on 27/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MontessoriAssesmentDataBase : NSManagedObject

@property (nonatomic, retain) NSNumber * levelId;
@property (nonatomic, retain) NSString * levelDescription;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) UIColor * assesmentColor;

+ (MontessoriAssesmentDataBase *) createMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context
                                withLevelId:(NSNumber *)a_levelId
                              withLevelDescription:(NSString *)a_levelDescription
                                 withColor:(NSString *)a_color;

+(NSArray *) fetchAllMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context;
+(NSArray *)fetchMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context withlevelId:(NSNumber *)a_levelId;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context;

//+(NSArray *) fetchMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context withStartAge:(NSNumber *)a_ageStart withEndAge:(NSNumber *)a_ageEnd;
//+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withLevelValue:(NSNumber *)a_levelValue;

@end
