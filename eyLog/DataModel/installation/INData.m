//
//  INData.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INData.h"


NSString *const kINDataReligion = @"religion";
NSString *const kINDataPin = @"pin";
NSString *const kINDataGroupId = @"group_id";
NSString *const kINDataLanguage = @"language";
NSString *const kINDataActive = @"active";
NSString *const kINDataDob = @"dob";
NSString *const kINDataGroupName = @"group_name";
NSString *const kINDataShareTwoYearReport = @"share_two_year_report";
NSString *const kINDataSlt = @"slt";
NSString *const kINDataSpecialEducationalNeeds = @"special_educational_needs";
NSString *const kINDataMiddleName = @"middle_name";
NSString *const kINDataLastName = @"last_name";
NSString *const kINDataNationality = @"nationality";
NSString *const kINDataEylogUserId = @"eylog_user_id";
NSString *const kINDataGroupLeader = @"group_leader";
NSString *const kINDataGender = @"gender";
NSString *const kINDataTwoYearFunding = @"two_year_funding";
NSString *const kINDataAllowSubmit = @"allow_submit";
NSString *const kINDataChildId = @"child_id";
NSString *const kINDataEthnicity = @"ethnicity";
NSString *const kINDataEnglishAdditionalLanguage = @"english_additional_language";
NSString *const kINDataStartDate = @"start_date";
NSString *const kINDataPractitionerId = @"practitioner_id";
NSString *const kINDataPhoto = @"photo";
NSString *const kINDataFirstName = @"first_name";
NSString *const kINDataUserRole = @"user_role";
NSString *const kINDataDietaryRequirments = @"dietary_requirments";
NSString *const kINDataAgeMonths = @"age_months";
NSString *const kINDataPupilPremium = @"pupilpremium";
NSString *const kINDataPhotoUrl = @"photourl";



@interface INData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INData

@synthesize religion = _religion;
@synthesize pin = _pin;
@synthesize groupId = _groupId;
@synthesize language = _language;
@synthesize active = _active;
@synthesize dob = _dob;
@synthesize groupName = _groupName;
@synthesize shareTwoYearReport = _shareTwoYearReport;
@synthesize slt = _slt;
@synthesize specialEducationalNeeds = _specialEducationalNeeds;
@synthesize middleName = _middleName;
@synthesize lastName = _lastName;
@synthesize nationality = _nationality;
@synthesize eylogUserId = _eylogUserId;
@synthesize groupLeader = _groupLeader;
@synthesize gender = _gender;
@synthesize twoYearFunding = _twoYearFunding;
@synthesize allowSubmit = _allowSubmit;
@synthesize childId = _childId;
@synthesize ethnicity = _ethnicity;
@synthesize englishAdditionalLanguage = _englishAdditionalLanguage;
@synthesize startDate = _startDate;
@synthesize practitionerId = _practitionerId;
@synthesize photo = _photo;
@synthesize firstName = _firstName;
@synthesize userRole = _userRole;
@synthesize dietaryRequirments = _dietaryRequirments;
@synthesize ageMonths = _ageMonths;
@synthesize pupilPremium = _pupilPremium;
@synthesize photoUrl = _photoUrl;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.religion = [self objectOrNilForKey:kINDataReligion fromDictionary:dict];
            self.pin = [self objectOrNilForKey:kINDataPin fromDictionary:dict];
            self.groupId = [self objectOrNilForKey:kINDataGroupId fromDictionary:dict];
            self.language = [self objectOrNilForKey:kINDataLanguage fromDictionary:dict];
            self.active = [[self objectOrNilForKey:kINDataActive fromDictionary:dict] doubleValue];
            self.dob = [self objectOrNilForKey:kINDataDob fromDictionary:dict];
            self.groupName = [self objectOrNilForKey:kINDataGroupName fromDictionary:dict];
            self.shareTwoYearReport = [[self objectOrNilForKey:kINDataShareTwoYearReport fromDictionary:dict] boolValue];
            self.slt = [[self objectOrNilForKey:kINDataSlt fromDictionary:dict] boolValue];
            self.specialEducationalNeeds = [[self objectOrNilForKey:kINDataSpecialEducationalNeeds fromDictionary:dict] boolValue];
            self.middleName = [self objectOrNilForKey:kINDataMiddleName fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kINDataLastName fromDictionary:dict];
            self.nationality = [self objectOrNilForKey:kINDataNationality fromDictionary:dict];
            self.eylogUserId = [self objectOrNilForKey:kINDataEylogUserId fromDictionary:dict];
            self.groupLeader = [[self objectOrNilForKey:kINDataGroupLeader fromDictionary:dict] boolValue];
            self.gender = [self objectOrNilForKey:kINDataGender fromDictionary:dict];
            self.twoYearFunding = [[self objectOrNilForKey:kINDataTwoYearFunding fromDictionary:dict] boolValue];
            self.allowSubmit = [[self objectOrNilForKey:kINDataAllowSubmit fromDictionary:dict] boolValue];
            self.childId = [self objectOrNilForKey:kINDataChildId fromDictionary:dict];
            self.ethnicity = [self objectOrNilForKey:kINDataEthnicity fromDictionary:dict];
            self.englishAdditionalLanguage = [[self objectOrNilForKey:kINDataEnglishAdditionalLanguage fromDictionary:dict] boolValue];
            self.startDate = [self objectOrNilForKey:kINDataStartDate fromDictionary:dict];
            self.practitionerId = [[self objectOrNilForKey:kINDataPractitionerId fromDictionary:dict] doubleValue];
            self.photo = [self objectOrNilForKey:kINDataPhoto fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kINDataFirstName fromDictionary:dict];
            self.userRole = [self objectOrNilForKey:kINDataUserRole fromDictionary:dict];
            self.dietaryRequirments = [self objectOrNilForKey:kINDataDietaryRequirments fromDictionary:dict];
            self.ageMonths = [self objectOrNilForKey:kINDataAgeMonths fromDictionary:dict];
            self.pupilPremium = [[self objectOrNilForKey:kINDataPupilPremium fromDictionary:dict] boolValue];
            self.photoUrl=[self objectOrNilForKey:kINDataPhotoUrl fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.religion forKey:kINDataReligion];
    [mutableDict setValue:self.pin forKey:kINDataPin];
    [mutableDict setValue:self.groupId forKey:kINDataGroupId];
    [mutableDict setValue:self.language forKey:kINDataLanguage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.active] forKey:kINDataActive];
    [mutableDict setValue:self.dob forKey:kINDataDob];
    [mutableDict setValue:self.groupName forKey:kINDataGroupName];
    [mutableDict setValue:[NSNumber numberWithBool:self.shareTwoYearReport] forKey:kINDataShareTwoYearReport];
    [mutableDict setValue:[NSNumber numberWithBool:self.slt] forKey:kINDataSlt];
    [mutableDict setValue:[NSNumber numberWithBool:self.specialEducationalNeeds] forKey:kINDataSpecialEducationalNeeds];
    [mutableDict setValue:self.middleName forKey:kINDataMiddleName];
    [mutableDict setValue:self.lastName forKey:kINDataLastName];
    [mutableDict setValue:self.nationality forKey:kINDataNationality];
    [mutableDict setValue:self.eylogUserId forKey:kINDataEylogUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.groupLeader] forKey:kINDataGroupLeader];
    [mutableDict setValue:self.gender forKey:kINDataGender];
    [mutableDict setValue:[NSNumber numberWithBool:self.twoYearFunding] forKey:kINDataTwoYearFunding];
    [mutableDict setValue:[NSNumber numberWithBool:self.allowSubmit] forKey:kINDataAllowSubmit];
    [mutableDict setValue:self.childId forKey:kINDataChildId];
    [mutableDict setValue:self.ethnicity forKey:kINDataEthnicity];
    [mutableDict setValue:[NSNumber numberWithBool:self.englishAdditionalLanguage] forKey:kINDataEnglishAdditionalLanguage];
    [mutableDict setValue:self.startDate forKey:kINDataStartDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.practitionerId] forKey:kINDataPractitionerId];
    [mutableDict setValue:self.photo forKey:kINDataPhoto];
    [mutableDict setValue:self.firstName forKey:kINDataFirstName];
    [mutableDict setValue:self.userRole forKey:kINDataUserRole];
    [mutableDict setValue:self.dietaryRequirments forKey:kINDataDietaryRequirments];
    [mutableDict setValue:self.ageMonths forKey:kINDataAgeMonths];
   [mutableDict setValue:[NSNumber numberWithBool:self.pupilPremium] forKey:kINDataPupilPremium];
    [mutableDict setValue:self.photoUrl forKey:kINDataPhotoUrl];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.religion = [aDecoder decodeObjectForKey:kINDataReligion];
    self.pin = [aDecoder decodeObjectForKey:kINDataPin];
    self.groupId = [aDecoder decodeObjectForKey:kINDataGroupId];
    self.language = [aDecoder decodeObjectForKey:kINDataLanguage];
    self.active = [aDecoder decodeDoubleForKey:kINDataActive];
    self.dob = [aDecoder decodeObjectForKey:kINDataDob];
    self.groupName = [aDecoder decodeObjectForKey:kINDataGroupName];
    self.shareTwoYearReport = [aDecoder decodeBoolForKey:kINDataShareTwoYearReport];
    self.slt = [aDecoder decodeBoolForKey:kINDataSlt];
    self.specialEducationalNeeds = [aDecoder decodeBoolForKey:kINDataSpecialEducationalNeeds];
    self.middleName = [aDecoder decodeObjectForKey:kINDataMiddleName];
    self.lastName = [aDecoder decodeObjectForKey:kINDataLastName];
    self.nationality = [aDecoder decodeObjectForKey:kINDataNationality];
    self.eylogUserId = [aDecoder decodeObjectForKey:kINDataEylogUserId];
    self.groupLeader = [aDecoder decodeBoolForKey:kINDataGroupLeader];
    self.gender = [aDecoder decodeObjectForKey:kINDataGender];
    self.twoYearFunding = [aDecoder decodeBoolForKey:kINDataTwoYearFunding];
    self.allowSubmit = [aDecoder decodeBoolForKey:kINDataAllowSubmit];
    self.childId = [aDecoder decodeObjectForKey:kINDataChildId];
    self.ethnicity = [aDecoder decodeObjectForKey:kINDataEthnicity];
    self.englishAdditionalLanguage = [aDecoder decodeBoolForKey:kINDataEnglishAdditionalLanguage];
    self.startDate = [aDecoder decodeObjectForKey:kINDataStartDate];
    self.practitionerId = [aDecoder decodeDoubleForKey:kINDataPractitionerId];
    self.photo = [aDecoder decodeObjectForKey:kINDataPhoto];
    self.firstName = [aDecoder decodeObjectForKey:kINDataFirstName];
    self.userRole = [aDecoder decodeObjectForKey:kINDataUserRole];
    self.dietaryRequirments = [aDecoder decodeObjectForKey:kINDataDietaryRequirments];
    self.ageMonths = [aDecoder decodeObjectForKey:kINDataAgeMonths];
    self.pupilPremium = [aDecoder decodeObjectForKey:kINDataPupilPremium];
    self.photoUrl =[aDecoder decodeObjectForKey:kINDataPhotoUrl];
    

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_religion forKey:kINDataReligion];
    [aCoder encodeObject:_pin forKey:kINDataPin];
    [aCoder encodeObject:_groupId forKey:kINDataGroupId];
    [aCoder encodeObject:_language forKey:kINDataLanguage];
    [aCoder encodeDouble:_active forKey:kINDataActive];
    [aCoder encodeObject:_dob forKey:kINDataDob];
    [aCoder encodeObject:_groupName forKey:kINDataGroupName];
    [aCoder encodeBool:_shareTwoYearReport forKey:kINDataShareTwoYearReport];
    [aCoder encodeBool:_slt forKey:kINDataSlt];
    [aCoder encodeBool:_specialEducationalNeeds forKey:kINDataSpecialEducationalNeeds];
    [aCoder encodeObject:_middleName forKey:kINDataMiddleName];
    [aCoder encodeObject:_lastName forKey:kINDataLastName];
    [aCoder encodeObject:_nationality forKey:kINDataNationality];
    [aCoder encodeObject:_eylogUserId forKey:kINDataEylogUserId];
    [aCoder encodeBool:_groupLeader forKey:kINDataGroupLeader];
    [aCoder encodeObject:_gender forKey:kINDataGender];
    [aCoder encodeBool:_twoYearFunding forKey:kINDataTwoYearFunding];
    [aCoder encodeBool:_allowSubmit forKey:kINDataAllowSubmit];
    [aCoder encodeObject:_childId forKey:kINDataChildId];
    [aCoder encodeObject:_ethnicity forKey:kINDataEthnicity];
    [aCoder encodeBool:_englishAdditionalLanguage forKey:kINDataEnglishAdditionalLanguage];
    [aCoder encodeObject:_startDate forKey:kINDataStartDate];
    [aCoder encodeDouble:_practitionerId forKey:kINDataPractitionerId];
    [aCoder encodeObject:_photo forKey:kINDataPhoto];
    [aCoder encodeObject:_firstName forKey:kINDataFirstName];
    [aCoder encodeObject:_userRole forKey:kINDataUserRole];
    [aCoder encodeObject:_dietaryRequirments forKey:kINDataDietaryRequirments];
    [aCoder encodeObject:_ageMonths forKey:kINDataAgeMonths];
    [aCoder encodeBool:_pupilPremium forKey:kINDataPupilPremium];
    [aCoder encodeObject:_photoUrl forKey:kINDataPhotoUrl];
    


}

- (id)copyWithZone:(NSZone *)zone
{
    INData *copy = [[INData alloc] init];
    
    if (copy) {

        copy.religion = [self.religion copyWithZone:zone];
        copy.pin = [self.pin copyWithZone:zone];
        copy.groupId = [self.groupId copyWithZone:zone];
        copy.language = [self.language copyWithZone:zone];
        copy.active = self.active;
        copy.dob = [self.dob copyWithZone:zone];
        copy.groupName = [self.groupName copyWithZone:zone];
        copy.shareTwoYearReport = self.shareTwoYearReport;
        copy.slt = self.slt;
        copy.specialEducationalNeeds = self.specialEducationalNeeds;
        copy.middleName = [self.middleName copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.nationality = [self.nationality copyWithZone:zone];
        copy.eylogUserId = [self.eylogUserId copyWithZone:zone];
        copy.groupLeader = self.groupLeader;
        copy.gender = [self.gender copyWithZone:zone];
        copy.twoYearFunding = self.twoYearFunding;
        copy.allowSubmit = self.allowSubmit;
        copy.childId = [self.childId copyWithZone:zone];
        copy.ethnicity = [self.ethnicity copyWithZone:zone];
        copy.englishAdditionalLanguage = self.englishAdditionalLanguage;
        copy.startDate = [self.startDate copyWithZone:zone];
        copy.practitionerId = self.practitionerId;
        copy.photo = [self.photo copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.userRole = [self.userRole copyWithZone:zone];
        copy.dietaryRequirments = [self.dietaryRequirments copyWithZone:zone];
        copy.ageMonths = [self.ageMonths copyWithZone:zone];
        copy.pupilPremium = self.pupilPremium;
        copy.photoUrl=[self.photoUrl copyWithZone:zone];
        


    }
    
    return copy;
}

- (NSString *)name {
    if (!_name) {
        
        _name = [NSString string];
        if (self.firstName) {
            _name = [_name stringByAppendingString:[self.firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        if (self.lastName) {
            _name = [_name stringByAppendingFormat:@" %@", [self.lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
    return _name;
}


@end
