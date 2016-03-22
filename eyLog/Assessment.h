//
//  Assessment.h
//  eyLog
//
//  Created by Qss on 11/5/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Assessment : NSManagedObject

@property (nonatomic, retain) NSNumber * ageEnd;
@property (nonatomic, retain) NSNumber * ageStart;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * levelDescription;
@property (nonatomic, retain) NSNumber * levelId;
@property (nonatomic, retain) NSNumber * levelValue;
@property (nonatomic, retain) NSNumber * weightage;

+ (Assessment *) createAssessmentInContext:(NSManagedObjectContext *)a_context
                                   withAgeEnd:(NSNumber *)a_ageEnd
                                 withAgeStart:(NSNumber *)a_ageStart
                                    withColor:(NSString *)a_color
                         withLevelDescription:(NSString *)a_levelDescription
                                  withLevelId:(NSNumber *)a_levelId
                               withLevelValue:(NSNumber *)a_levelValue
                                withWeightage:(NSNumber *)a_weightage;

+(NSArray *) fetchAllAssessmentInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withStartAge:(NSNumber *)a_ageStart withEndAge:(NSNumber *)a_ageEnd;
+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withLevelValue:(NSNumber *)a_levelValue;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context ;

@end
