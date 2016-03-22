//
//  Child.h
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Child : NSManagedObject

@property (nonatomic, retain) NSNumber * childId;
@property(nonatomic,retain) NSNumber *registryStatus;
@property (nonatomic, retain) NSString * dietaryRequirment;
@property (nonatomic, retain) NSDate   * dob;
@property (nonatomic, retain) NSNumber * englistAdditionalLanguage;
@property (nonatomic, retain) NSNumber * ethnicity;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSNumber * practitionerId;
@property (nonatomic, retain) NSString * religion;
@property (nonatomic, retain) NSNumber * shareTwoYearReport;
@property (nonatomic, retain) NSNumber * slt;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * specialEducationalNeeds;
@property (nonatomic, retain) NSNumber * pupilPremium;
@property (nonatomic, retain) NSDate   * startDate;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSNumber * twoYearFunding;
@property (nonatomic, retain) NSString * ageMonths;
@property (nonatomic, retain) NSString * inTime;
@property (nonatomic, retain) NSString * outTime;
@property (nonatomic, retain) NSString * currentDate;
@property (nonatomic, retain) NSData * registryArray;
@property(nonatomic,retain ) NSDictionary *childInoutDataWithDateAndChild;
@property (nonatomic , retain) NSString *photourl;





+ (Child *) createChildInContext:(NSManagedObjectContext *)a_context
                       withChild:(NSNumber *)a_childId
           withDietaryRequirment:(NSString *)a_dietaryRequirment
                         withDob:(NSDate *)a_dob
   withEnglishAdditionalLanguage:(NSNumber *)a_englishAdditionalLanguage
                   withEthnicity:(NSNumber *)a_Ethnicity
                   withFirstName:(NSString *)a_firstName
                      withGender:(NSString *)a_gender
                     withGroupId:(NSNumber *)a_groupId
                   withGroupName:(NSString *)a_groupName
                    withLanguage:(NSString *)a_language
                    withLastName:(NSString *)a_lastName
                  withMiddleName:(NSString *)a_middleName
                 withNationality:(NSString *)a_nationality
              withPractitionerId:(NSNumber *)a_practitionerId
                    withReligion:(NSString *)a_religion
          withShareTwoYearReport:(NSNumber *)a_shareTwoYearReport
                         withSLt:(NSNumber *)a_slt
      withSpecialEductionalNeeds:(NSNumber *)a_specialEducationalNeeds
                   withStartDate:(NSDate *)a_startDate
                       withPhoto:(NSString *)a_photo
              withTwoYearFunding:(NSNumber *)a_twoYearFunding
                   withAgeMonths:(NSString *)age_months
                      withInTime:(NSString *)inTime
                     withOutTime:(NSString *)outTime
                 withCurrentDate:(NSString *)date
                   registryArray:(NSData*)registryArray
                    pupilPremium:(NSNumber *)pupilPremium
                    withphotoUrl:(NSString *)photourl;

+(Child *)withChild:(NSNumber *)a_childId
withDietaryRequirment:(NSString *)a_dietaryRequirment
            withDob:(NSDate *)a_dob
withEnglishAdditionalLanguage:(NSNumber *)a_englishAdditionalLanguage
      withEthnicity:(NSNumber *)a_Ethnicity
      withFirstName:(NSString *)a_firstName
         withGender:(NSString *)a_gender
        withGroupId:(NSNumber *)a_groupId
      withGroupName:(NSString *)a_groupName
       withLanguage:(NSString *)a_language
       withLastName:(NSString *)a_lastName
     withMiddleName:(NSString *)a_middleName
    withNationality:(NSString *)a_nationality
 withPractitionerId:(NSNumber *)a_practitionerId
       withReligion:(NSString *)a_religion
withShareTwoYearReport:(NSNumber *)a_shareTwoYearReport
            withSLt:(NSNumber *)a_slt
withSpecialEductionalNeeds:(NSNumber *)a_specialEducationalNeeds
      withStartDate:(NSDate *)a_startDate
          withPhoto:(NSString *)a_photo
 withTwoYearFunding:(NSNumber *)a_twoYearFunding
      withAgeMonths:(NSString *)age_months
         withInTime:(NSString *)inTime
        withOutTime:(NSString *)outTime
    withCurrentDate:(NSString *)date
      registryArray:(NSData*)registryArray
       pupilPremium:(NSNumber *)pupilPremium
       withPhotoUrl:(NSString *)photourl
        forContext :(NSManagedObjectContext *) a_context;

+(NSArray *) fetchALLChildInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_eylogUserId;
+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withPractitionerGroupName:(NSString *)practitionerGroupName;

+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withChildId:(NSNumber *)a_childId;
+(BOOL) deleteChildInContext:(NSManagedObjectContext *)a_context;

+(Child *) updateChild : (NSNumber *) childID inTime :(NSString *) inTime andOutTime :(NSString *) outTime andRegistryStatus :(NSNumber *)registryStatus forContext :(NSManagedObjectContext *) a_context;
+(Child *)updateRegistryArrayForChild :(NSNumber *) childID :(NSMutableArray *)registryArray forContext:(NSManagedObjectContext *)a_context;

+(Child *)updateDictionaryDataForInoutTime:(NSMutableDictionary*)mutaDict  : (NSNumber *) childID forContext :(NSManagedObjectContext *) a_context;

+(NSString *) fetchALLChildandUpdateINOUTTime:(NSManagedObjectContext *)a_context;
@end
