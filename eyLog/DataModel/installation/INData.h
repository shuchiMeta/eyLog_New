//
//  INData.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface INData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *religion;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, assign) double active;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, assign) BOOL shareTwoYearReport;
@property (nonatomic, assign) BOOL slt;
@property (nonatomic, assign) BOOL specialEducationalNeeds;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *eylogUserId;
@property (nonatomic, assign) BOOL groupLeader;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) BOOL twoYearFunding;
@property (nonatomic, assign) BOOL allowSubmit;
@property (nonatomic, strong) NSString *childId;
@property (nonatomic, strong) NSString *ethnicity;
@property (nonatomic, assign) BOOL englishAdditionalLanguage;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, assign) double practitionerId;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *dietaryRequirments;
@property (nonatomic, strong) NSString *ageMonths;
@property (nonatomic, assign) BOOL pupilPremium;
@property ( nonatomic,strong) NSString *photoUrl;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
