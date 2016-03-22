//
//  INDiaryFields.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INDiaryFields.h"
#import "INSettings.h"

// Using Insetting Model to just fetch Key Value from  decitionaly

NSString *const kINDiaryFieldsSLEPTMINHOURS = @"SLEPT_MIN_HOURS";
NSString *const kINDiaryFieldsNOTESFROMPARENTS = @"NOTES_FROM_PARENTS";
NSString *const kINDiaryFieldsAT = @"AT";
NSString *const kINDiaryFieldsSNACKPMVISIBLE = @"SNACK_PM_VISIBLE";
NSString *const kINDiaryFieldsBREAKFASTVISIBLE = @"BREAKFAST_VISIBLE";
NSString *const kINDiaryFieldsWENTONTHEPOTTY = @"WENT_ON_THE_POTTY";
NSString *const kINDiaryFieldsBREAKFAST = @"BREAKFAST";
NSString *const kINDiaryFieldsDRANK = @"DRANK";
NSString *const kINDiaryFieldsSNACKAMVISIBLE = @"SNACK_AM_VISIBLE";
NSString *const kINDiaryFieldsPUDDINGAM = @"PUDDING_AM";
NSString *const kINDiaryFieldsAGEGROUPTOILETINGTODAY = @"AGE_GROUP_TOILETING_TODAY";
NSString *const kINDiaryFieldsNOTESTOPARENTS = @"NOTES_TO_PARENTS";
NSString *const kINDiaryFieldsTOILETINGWHEN = @"TOILETING_WHEN";
NSString *const kINDiaryFieldsAGEGROUPNAPPIES = @"AGE_GROUP_NAPPIES";
NSString *const kINDiaryFieldsPUDDINGPM = @"PUDDING_PM";
NSString *const kINDiaryFieldsITRIED = @"I_TRIED";
NSString *const kINDiaryFieldsPUDDINGAMVISIBLE = @"PUDDING_AM_VISIBLE";
NSString *const kINDiaryFieldsTEA = @"TEA";
NSString *const kINDiaryFieldsDRY = @"DRY";
NSString *const kINDiaryFieldsWHATIATETODAY = @"WHAT_I_ATE_TODAY";
NSString *const kINDiaryFieldsOBSERVATIONTEXT = @"OBSERVATION_TEXT";
NSString *const kINDiaryFieldsAGEGROUPWHATIATETODAY = @"AGE_GROUP_WHAT_I_ATE_TODAY";
NSString *const kINDiaryFieldsTEAVISIBLE = @"TEA_VISIBLE";
NSString *const kINDiaryFieldsAGEGROUPIHADMYBOTTLE = @"AGE_GROUP_I_HAD_MY_BOTTLE";
NSString *const kINDiaryFieldsSNACKAM = @"SNACK_AM";
NSString *const kINDiaryFieldsSNACKPM = @"SNACK_PM";
NSString *const kINDiaryFieldsSOILED = @"SOILED";
NSString *const kINDiaryFieldsAREASASSESSED = @"AREAS_ASSESSED";
NSString *const kINDiaryFieldsSLEEPTIMES = @"SLEEP_TIMES";
NSString *const kINDiaryFieldsLUNCH = @"LUNCH";
NSString *const kINDiaryFieldsOBSERVATIONSACHIEVEMENTS = @"OBSERVATIONS_ACHIEVEMENTS";
NSString *const kINDiaryFieldsLeftAt = @"Left_at";
NSString *const kINDiaryFieldsTOILETINGTODAY1 = @"TOILETING_TODAY_1";
NSString *const kINDiaryFieldsWOKEUP = @"WOKE_UP";
NSString *const kINDiaryFieldsAGEGROUPSLEEPTIMES = @"AGE_GROUP_SLEEP_TIMES";
NSString *const kINDiaryFieldsPUDDINGPMVISIBLE = @"PUDDING_PM_VISIBLE";
NSString *const kINDiaryFieldsLUNCHVISIBLE = @"LUNCH_VISIBLE";
NSString *const kINDiaryFieldsFELLASLEEP = @"FELL_ASLEEP";
NSString *const kINDiaryFieldsWENTONTHETOILET = @"WENT_ON_THE_TOILET";
NSString *const kINDiaryFieldsNAPPIES = @"NAPPIES";
NSString *const kINDiaryFieldsNAPPIESWHEN = @"NAPPIES_WHEN";
NSString *const kINDiaryFieldsCameInAt = @"Came_in_at";
NSString *const kINDiaryFieldsWET = @"WET";

NSString *const kRegistry=@"registry";
NSString *const kWhat_i_ate_today=@"what_i_ate_today";
NSString *const kSleepTime=@"sleep_times";
NSString *const kIhad_my_bottle = @"i_had_my_bottle";
NSString *const kNappies = @"nappies";
NSString *const kToiletting_today=@"toileting_today_1";
NSString *const kAdditionalNotes=@"additionalnotes";
NSString *const kObservationFields=@"observationfields";




@interface INDiaryFields ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INDiaryFields

@synthesize sLEPTMINHOURS = _sLEPTMINHOURS;
@synthesize nOTESFROMPARENTS = _nOTESFROMPARENTS;
@synthesize aT = _aT;
@synthesize sNACKPMVISIBLE = _sNACKPMVISIBLE;
@synthesize bREAKFASTVISIBLE = _bREAKFASTVISIBLE;
@synthesize wENTONTHEPOTTY = _wENTONTHEPOTTY;
@synthesize bREAKFAST = _bREAKFAST;
@synthesize dRANK = _dRANK;
@synthesize sNACKAMVISIBLE = _sNACKAMVISIBLE;
@synthesize pUDDINGAM = _pUDDINGAM;
@synthesize aGEGROUPTOILETINGTODAY = _aGEGROUPTOILETINGTODAY;
@synthesize nOTESTOPARENTS = _nOTESTOPARENTS;
@synthesize tOILETINGWHEN = _tOILETINGWHEN;
@synthesize aGEGROUPNAPPIES = _aGEGROUPNAPPIES;
@synthesize pUDDINGPM = _pUDDINGPM;
@synthesize iTRIED = _iTRIED;
@synthesize pUDDINGAMVISIBLE = _pUDDINGAMVISIBLE;
@synthesize tEA = _tEA;
@synthesize dRY = _dRY;
@synthesize wHATIATETODAY = _wHATIATETODAY;
@synthesize oBSERVATIONTEXT = _oBSERVATIONTEXT;
@synthesize aGEGROUPWHATIATETODAY = _aGEGROUPWHATIATETODAY;
@synthesize tEAVISIBLE = _tEAVISIBLE;
@synthesize aGEGROUPIHADMYBOTTLE = _aGEGROUPIHADMYBOTTLE;
@synthesize sNACKAM = _sNACKAM;
@synthesize sNACKPM = _sNACKPM;
@synthesize sOILED = _sOILED;
@synthesize aREASASSESSED = _aREASASSESSED;
@synthesize sLEEPTIMES = _sLEEPTIMES;
@synthesize lUNCH = _lUNCH;
@synthesize oBSERVATIONSACHIEVEMENTS = _oBSERVATIONSACHIEVEMENTS;
@synthesize leftAt = _leftAt;
@synthesize tOILETINGTODAY1 = _tOILETINGTODAY1;
@synthesize wOKEUP = _wOKEUP;
@synthesize aGEGROUPSLEEPTIMES = _aGEGROUPSLEEPTIMES;
@synthesize iHADMYBOTTLE = _iHADMYBOTTLE;
@synthesize pUDDINGPMVISIBLE = _pUDDINGPMVISIBLE;
@synthesize lUNCHVISIBLE = _lUNCHVISIBLE;
@synthesize fELLASLEEP = _fELLASLEEP;
@synthesize wENTONTHETOILET = _wENTONTHETOILET;
@synthesize nAPPIES = _nAPPIES;
@synthesize nAPPIESWHEN = _nAPPIESWHEN;
@synthesize cameInAt = _cameInAt;
@synthesize wET = _wET;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

//- (instancetype)initWithDictionary:(NSDictionary *)dict
//{
//    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
 //   if(self && [dict isKindOfClass:[NSDictionary class]]) {
//            self.sLEPTMINHOURS = [self objectOrNilForKey:kINDiaryFieldsSLEPTMINHOURS fromDictionary:dict];
//            self.nOTESFROMPARENTS = [self objectOrNilForKey:kINDiaryFieldsNOTESFROMPARENTS fromDictionary:dict];
//            self.aT = [self objectOrNilForKey:kINDiaryFieldsAT fromDictionary:dict];
//            self.sNACKPMVISIBLE = [self objectOrNilForKey:kINDiaryFieldsSNACKPMVISIBLE fromDictionary:dict];
//            self.bREAKFASTVISIBLE = [self objectOrNilForKey:kINDiaryFieldsBREAKFASTVISIBLE fromDictionary:dict];
//            self.wENTONTHEPOTTY = [self objectOrNilForKey:kINDiaryFieldsWENTONTHEPOTTY fromDictionary:dict];
//            self.bREAKFAST = [self objectOrNilForKey:kINDiaryFieldsBREAKFAST fromDictionary:dict];
//            self.dRANK = [self objectOrNilForKey:kINDiaryFieldsDRANK fromDictionary:dict];
//            self.sNACKAMVISIBLE = [self objectOrNilForKey:kINDiaryFieldsSNACKAMVISIBLE fromDictionary:dict];
//            self.pUDDINGAM = [self objectOrNilForKey:kINDiaryFieldsPUDDINGAM fromDictionary:dict];
//            self.aGEGROUPTOILETINGTODAY = [self objectOrNilForKey:kINDiaryFieldsAGEGROUPTOILETINGTODAY fromDictionary:dict];
//            self.nOTESTOPARENTS = [self objectOrNilForKey:kINDiaryFieldsNOTESTOPARENTS fromDictionary:dict];
//            self.tOILETINGWHEN = [self objectOrNilForKey:kINDiaryFieldsTOILETINGWHEN fromDictionary:dict];
//            self.aGEGROUPNAPPIES = [self objectOrNilForKey:kINDiaryFieldsAGEGROUPNAPPIES fromDictionary:dict];
//            self.pUDDINGPM = [self objectOrNilForKey:kINDiaryFieldsPUDDINGPM fromDictionary:dict];
//            self.iTRIED = [self objectOrNilForKey:kINDiaryFieldsITRIED fromDictionary:dict];
//            self.pUDDINGAMVISIBLE = [self objectOrNilForKey:kINDiaryFieldsPUDDINGAMVISIBLE fromDictionary:dict];
//            self.tEA = [self objectOrNilForKey:kINDiaryFieldsTEA fromDictionary:dict];
//            self.dRY = [self objectOrNilForKey:kINDiaryFieldsDRY fromDictionary:dict];
//            self.wHATIATETODAY = [self objectOrNilForKey:kINDiaryFieldsWHATIATETODAY fromDictionary:dict];
//            self.oBSERVATIONTEXT = [self objectOrNilForKey:kINDiaryFieldsOBSERVATIONTEXT fromDictionary:dict];
//            self.aGEGROUPWHATIATETODAY = [self objectOrNilForKey:kINDiaryFieldsAGEGROUPWHATIATETODAY fromDictionary:dict];
//            self.tEAVISIBLE = [self objectOrNilForKey:kINDiaryFieldsTEAVISIBLE fromDictionary:dict];
//            self.aGEGROUPIHADMYBOTTLE = [self objectOrNilForKey:kINDiaryFieldsAGEGROUPIHADMYBOTTLE fromDictionary:dict];
//            self.sNACKAM = [self objectOrNilForKey:kINDiaryFieldsSNACKAM fromDictionary:dict];
//            self.sNACKPM = [self objectOrNilForKey:kINDiaryFieldsSNACKPM fromDictionary:dict];
//            self.sOILED = [self objectOrNilForKey:kINDiaryFieldsSOILED fromDictionary:dict];
//            self.aREASASSESSED = [self objectOrNilForKey:kINDiaryFieldsAREASASSESSED fromDictionary:dict];
//            self.sLEEPTIMES = [self objectOrNilForKey:kINDiaryFieldsSLEEPTIMES fromDictionary:dict];
//            self.lUNCH = [self objectOrNilForKey:kINDiaryFieldsLUNCH fromDictionary:dict];
//            self.oBSERVATIONSACHIEVEMENTS = [self objectOrNilForKey:kINDiaryFieldsOBSERVATIONSACHIEVEMENTS fromDictionary:dict];
//            self.leftAt = [self objectOrNilForKey:kINDiaryFieldsLeftAt fromDictionary:dict];
//            self.tOILETINGTODAY1 = [self objectOrNilForKey:kINDiaryFieldsTOILETINGTODAY1 fromDictionary:dict];
//            self.wOKEUP = [self objectOrNilForKey:kINDiaryFieldsWOKEUP fromDictionary:dict];
//            self.aGEGROUPSLEEPTIMES = [self objectOrNilForKey:kINDiaryFieldsAGEGROUPSLEEPTIMES fromDictionary:dict];
//            self.iHADMYBOTTLE = [self objectOrNilForKey:kINDiaryFieldsIHADMYBOTTLE fromDictionary:dict];
//            self.pUDDINGPMVISIBLE = [self objectOrNilForKey:kINDiaryFieldsPUDDINGPMVISIBLE fromDictionary:dict];
//            self.lUNCHVISIBLE = [self objectOrNilForKey:kINDiaryFieldsLUNCHVISIBLE fromDictionary:dict];
//            self.fELLASLEEP = [self objectOrNilForKey:kINDiaryFieldsFELLASLEEP fromDictionary:dict];
//            self.wENTONTHETOILET = [self objectOrNilForKey:kINDiaryFieldsWENTONTHETOILET fromDictionary:dict];
//            self.nAPPIES = [self objectOrNilForKey:kINDiaryFieldsNAPPIES fromDictionary:dict];
//            self.nAPPIESWHEN = [self objectOrNilForKey:kINDiaryFieldsNAPPIESWHEN fromDictionary:dict];
//            self.cameInAt = [self objectOrNilForKey:kINDiaryFieldsCameInAt fromDictionary:dict];
//            self.wET = [self objectOrNilForKey:kINDiaryFieldsWET fromDictionary:dict];

//        self.wHATIATETODAY=[self objectOrNilForKey:kWhat_i_ate_today fromDictionary:dict];
//        self.sLEEPTIMES=[self objectOrNilForKey:kSleepTime fromDictionary:dict];
//        self.ihad_my_Bottle=[self objectOrNilForKey:kIhad_my_bottle fromDictionary:dict];
//        self.nAPPIES=[self objectOrNilForKey:kNappies fromDictionary:dict];
//        self.toileting_today=[self objectOrNilForKey:kToiletting_today fromDictionary:dict];
//        self.additionalnotes=[self objectOrNilForKey:kAdditionalNotes fromDictionary:dict];
//        self.observationFields=[self objectOrNilForKey:kObservationFields fromDictionary:dict];


        //Edited by Arpan
//        NSObject *receivedINRegistry = [dict objectForKey:kRegistry];
//
//        NSDictionary *registryDict = [NSDictionary dictionaryWithObject:[dict valueForKey:@"registry"] forKey:@"registry"];
//
//        self.dict_Registry = [[NSMutableDictionary alloc] initWithDictionary:[dict valueForKey:@"registry"]];
//        self.dict_Times = [[NSMutableDictionary alloc] initWithDictionary:[dict valueForKey:@"registry"]];
//
//        NSMutableArray *parsedINRegistry = [NSMutableArray array];
//        if ([receivedINRegistry isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *item in (NSArray *)receivedINRegistry) {
//                if ([item isKindOfClass:[NSDictionary class]]) {
//                    [parsedINRegistry addObject:[INSettings modelObjectWithDictionary:item]];
//                }
//            }
//        } else if ([receivedINRegistry isKindOfClass:[NSDictionary class]]) {
//            [parsedINRegistry addObject:[INSettings modelObjectWithDictionary:(NSDictionary *)receivedINRegistry]];
//        }
//        self.Registry=[NSMutableArray arrayWithArray:parsedINRegistry];
//
//
//        NSObject *receivedINwhatIate = [dict objectForKey:kWhat_i_ate_today];
//
//        NSMutableArray *parsedINWhatIate = [NSMutableArray array];
//        if ([receivedINwhatIate isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *item in (NSArray *)receivedINwhatIate) {
//                if ([item isKindOfClass:[NSDictionary class]]) {
//                    [parsedINWhatIate addObject:[INSettings modelObjectWithDictionary:item]];
//                }
//            }
//        } else if ([receivedINwhatIate isKindOfClass:[NSDictionary class]]) {
//            [parsedINWhatIate addObject:[INSettings modelObjectWithDictionary:(NSDictionary *)receivedINwhatIate]];
//        }
//        self.wha_I_Ate=[NSMutableArray arrayWithArray:parsedINWhatIate];
//
//
//
//        NSObject *receivedINSleep = [dict objectForKey:kSleepTime];
//        NSMutableArray *parsedINSleep = [NSMutableArray array];
//        if ([receivedINSleep isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *item in (NSArray *)receivedINSleep) {
//                if ([item isKindOfClass:[NSDictionary class]]) {
//                    [parsedINSleep addObject:[INSettings modelObjectWithDictionary:item]];
//                }
//            }
//        } else if ([receivedINSleep isKindOfClass:[NSDictionary class]]) {
//            [parsedINSleep addObject:[INSettings modelObjectWithDictionary:(NSDictionary *)receivedINSleep]];
//        }
//        self.sleepTimes=[NSMutableArray arrayWithArray:parsedINSleep];
//



//    }
//
//    return self;
//
//}


//    return self;
//
//}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//    [mutableDict setValue:self.sLEPTMINHOURS forKey:kINDiaryFieldsSLEPTMINHOURS];
//    [mutableDict setValue:self.nOTESFROMPARENTS forKey:kINDiaryFieldsNOTESFROMPARENTS];
//    [mutableDict setValue:self.aT forKey:kINDiaryFieldsAT];
//    [mutableDict setValue:self.sNACKPMVISIBLE forKey:kINDiaryFieldsSNACKPMVISIBLE];
//    [mutableDict setValue:self.bREAKFASTVISIBLE forKey:kINDiaryFieldsBREAKFASTVISIBLE];
//    [mutableDict setValue:self.wENTONTHEPOTTY forKey:kINDiaryFieldsWENTONTHEPOTTY];
//    [mutableDict setValue:self.bREAKFAST forKey:kINDiaryFieldsBREAKFAST];
//    [mutableDict setValue:self.dRANK forKey:kINDiaryFieldsDRANK];
//    [mutableDict setValue:self.sNACKAMVISIBLE forKey:kINDiaryFieldsSNACKAMVISIBLE];
//    [mutableDict setValue:self.pUDDINGAM forKey:kINDiaryFieldsPUDDINGAM];
//    [mutableDict setValue:self.aGEGROUPTOILETINGTODAY forKey:kINDiaryFieldsAGEGROUPTOILETINGTODAY];
//    [mutableDict setValue:self.nOTESTOPARENTS forKey:kINDiaryFieldsNOTESTOPARENTS];
//    [mutableDict setValue:self.tOILETINGWHEN forKey:kINDiaryFieldsTOILETINGWHEN];
//    [mutableDict setValue:self.aGEGROUPNAPPIES forKey:kINDiaryFieldsAGEGROUPNAPPIES];
//    [mutableDict setValue:self.pUDDINGPM forKey:kINDiaryFieldsPUDDINGPM];
//    [mutableDict setValue:self.iTRIED forKey:kINDiaryFieldsITRIED];
//    [mutableDict setValue:self.pUDDINGAMVISIBLE forKey:kINDiaryFieldsPUDDINGAMVISIBLE];
//    [mutableDict setValue:self.tEA forKey:kINDiaryFieldsTEA];
//    [mutableDict setValue:self.dRY forKey:kINDiaryFieldsDRY];
//    [mutableDict setValue:self.wHATIATETODAY forKey:kINDiaryFieldsWHATIATETODAY];
//    [mutableDict setValue:self.oBSERVATIONTEXT forKey:kINDiaryFieldsOBSERVATIONTEXT];
//    [mutableDict setValue:self.aGEGROUPWHATIATETODAY forKey:kINDiaryFieldsAGEGROUPWHATIATETODAY];
//    [mutableDict setValue:self.tEAVISIBLE forKey:kINDiaryFieldsTEAVISIBLE];
//    [mutableDict setValue:self.aGEGROUPIHADMYBOTTLE forKey:kINDiaryFieldsAGEGROUPIHADMYBOTTLE];
//    [mutableDict setValue:self.sNACKAM forKey:kINDiaryFieldsSNACKAM];
//    [mutableDict setValue:self.sNACKPM forKey:kINDiaryFieldsSNACKPM];
//    [mutableDict setValue:self.sOILED forKey:kINDiaryFieldsSOILED];
//    [mutableDict setValue:self.aREASASSESSED forKey:kINDiaryFieldsAREASASSESSED];
//    [mutableDict setValue:self.sLEEPTIMES forKey:kINDiaryFieldsSLEEPTIMES];
//    [mutableDict setValue:self.lUNCH forKey:kINDiaryFieldsLUNCH];
//    [mutableDict setValue:self.oBSERVATIONSACHIEVEMENTS forKey:kINDiaryFieldsOBSERVATIONSACHIEVEMENTS];
//    [mutableDict setValue:self.leftAt forKey:kINDiaryFieldsLeftAt];
//    [mutableDict setValue:self.tOILETINGTODAY1 forKey:kINDiaryFieldsTOILETINGTODAY1];
//    [mutableDict setValue:self.wOKEUP forKey:kINDiaryFieldsWOKEUP];
//    [mutableDict setValue:self.aGEGROUPSLEEPTIMES forKey:kINDiaryFieldsAGEGROUPSLEEPTIMES];
//    [mutableDict setValue:self.iHADMYBOTTLE forKey:kINDiaryFieldsIHADMYBOTTLE];
//    [mutableDict setValue:self.pUDDINGPMVISIBLE forKey:kINDiaryFieldsPUDDINGPMVISIBLE];
//    [mutableDict setValue:self.lUNCHVISIBLE forKey:kINDiaryFieldsLUNCHVISIBLE];
//    [mutableDict setValue:self.fELLASLEEP forKey:kINDiaryFieldsFELLASLEEP];
//    [mutableDict setValue:self.wENTONTHETOILET forKey:kINDiaryFieldsWENTONTHETOILET];
//    [mutableDict setValue:self.nAPPIES forKey:kINDiaryFieldsNAPPIES];
//    [mutableDict setValue:self.nAPPIESWHEN forKey:kINDiaryFieldsNAPPIESWHEN];
//    [mutableDict setValue:self.cameInAt forKey:kINDiaryFieldsCameInAt];
//    [mutableDict setValue:self.wET forKey:kINDiaryFieldsWET];
    //[mutableDict setValue:self.Registry forKey:kRegistry];

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

//    self.sLEPTMINHOURS = [aDecoder decodeObjectForKey:kINDiaryFieldsSLEPTMINHOURS];
//    self.nOTESFROMPARENTS = [aDecoder decodeObjectForKey:kINDiaryFieldsNOTESFROMPARENTS];
//    self.aT = [aDecoder decodeObjectForKey:kINDiaryFieldsAT];
//    self.sNACKPMVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsSNACKPMVISIBLE];
//    self.bREAKFASTVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsBREAKFASTVISIBLE];
//    self.wENTONTHEPOTTY = [aDecoder decodeObjectForKey:kINDiaryFieldsWENTONTHEPOTTY];
//    self.bREAKFAST = [aDecoder decodeObjectForKey:kINDiaryFieldsBREAKFAST];
//    self.dRANK = [aDecoder decodeObjectForKey:kINDiaryFieldsDRANK];
//    self.sNACKAMVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsSNACKAMVISIBLE];
//    self.pUDDINGAM = [aDecoder decodeObjectForKey:kINDiaryFieldsPUDDINGAM];
//    self.aGEGROUPTOILETINGTODAY = [aDecoder decodeObjectForKey:kINDiaryFieldsAGEGROUPTOILETINGTODAY];
//    self.nOTESTOPARENTS = [aDecoder decodeObjectForKey:kINDiaryFieldsNOTESTOPARENTS];
//    self.tOILETINGWHEN = [aDecoder decodeObjectForKey:kINDiaryFieldsTOILETINGWHEN];
//    self.aGEGROUPNAPPIES = [aDecoder decodeObjectForKey:kINDiaryFieldsAGEGROUPNAPPIES];
//    self.pUDDINGPM = [aDecoder decodeObjectForKey:kINDiaryFieldsPUDDINGPM];
//    self.iTRIED = [aDecoder decodeObjectForKey:kINDiaryFieldsITRIED];
//    self.pUDDINGAMVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsPUDDINGAMVISIBLE];
//    self.tEA = [aDecoder decodeObjectForKey:kINDiaryFieldsTEA];
//    self.dRY = [aDecoder decodeObjectForKey:kINDiaryFieldsDRY];
//    self.wHATIATETODAY = [aDecoder decodeObjectForKey:kINDiaryFieldsWHATIATETODAY];
//    self.oBSERVATIONTEXT = [aDecoder decodeObjectForKey:kINDiaryFieldsOBSERVATIONTEXT];
//    self.aGEGROUPWHATIATETODAY = [aDecoder decodeObjectForKey:kINDiaryFieldsAGEGROUPWHATIATETODAY];
//    self.tEAVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsTEAVISIBLE];
//    self.aGEGROUPIHADMYBOTTLE = [aDecoder decodeObjectForKey:kINDiaryFieldsAGEGROUPIHADMYBOTTLE];
//    self.sNACKAM = [aDecoder decodeObjectForKey:kINDiaryFieldsSNACKAM];
//    self.sNACKPM = [aDecoder decodeObjectForKey:kINDiaryFieldsSNACKPM];
//    self.sOILED = [aDecoder decodeObjectForKey:kINDiaryFieldsSOILED];
//    self.aREASASSESSED = [aDecoder decodeObjectForKey:kINDiaryFieldsAREASASSESSED];
//    self.sLEEPTIMES = [aDecoder decodeObjectForKey:kINDiaryFieldsSLEEPTIMES];
//    self.lUNCH = [aDecoder decodeObjectForKey:kINDiaryFieldsLUNCH];
//    self.oBSERVATIONSACHIEVEMENTS = [aDecoder decodeObjectForKey:kINDiaryFieldsOBSERVATIONSACHIEVEMENTS];
//    self.leftAt = [aDecoder decodeObjectForKey:kINDiaryFieldsLeftAt];
//    self.tOILETINGTODAY1 = [aDecoder decodeObjectForKey:kINDiaryFieldsTOILETINGTODAY1];
//    self.wOKEUP = [aDecoder decodeObjectForKey:kINDiaryFieldsWOKEUP];
//    self.aGEGROUPSLEEPTIMES = [aDecoder decodeObjectForKey:kINDiaryFieldsAGEGROUPSLEEPTIMES];
//    self.iHADMYBOTTLE = [aDecoder decodeObjectForKey:kINDiaryFieldsIHADMYBOTTLE];
//    self.pUDDINGPMVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsPUDDINGPMVISIBLE];
//    self.lUNCHVISIBLE = [aDecoder decodeObjectForKey:kINDiaryFieldsLUNCHVISIBLE];
//    self.fELLASLEEP = [aDecoder decodeObjectForKey:kINDiaryFieldsFELLASLEEP];
//    self.wENTONTHETOILET = [aDecoder decodeObjectForKey:kINDiaryFieldsWENTONTHETOILET];
//    self.nAPPIES = [aDecoder decodeObjectForKey:kINDiaryFieldsNAPPIES];
//    self.nAPPIESWHEN = [aDecoder decodeObjectForKey:kINDiaryFieldsNAPPIESWHEN];
//    self.cameInAt = [aDecoder decodeObjectForKey:kINDiaryFieldsCameInAt];
//    self.wET = [aDecoder decodeObjectForKey:kINDiaryFieldsWET];
   // self.Registry=[aDecoder decodeObjectForKey:kRegistry];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

//    [aCoder encodeObject:_sLEPTMINHOURS forKey:kINDiaryFieldsSLEPTMINHOURS];
//    [aCoder encodeObject:_nOTESFROMPARENTS forKey:kINDiaryFieldsNOTESFROMPARENTS];
//    [aCoder encodeObject:_aT forKey:kINDiaryFieldsAT];
//    [aCoder encodeObject:_sNACKPMVISIBLE forKey:kINDiaryFieldsSNACKPMVISIBLE];
//    [aCoder encodeObject:_bREAKFASTVISIBLE forKey:kINDiaryFieldsBREAKFASTVISIBLE];
//    [aCoder encodeObject:_wENTONTHEPOTTY forKey:kINDiaryFieldsWENTONTHEPOTTY];
//    [aCoder encodeObject:_bREAKFAST forKey:kINDiaryFieldsBREAKFAST];
//    [aCoder encodeObject:_dRANK forKey:kINDiaryFieldsDRANK];
//    [aCoder encodeObject:_sNACKAMVISIBLE forKey:kINDiaryFieldsSNACKAMVISIBLE];
//    [aCoder encodeObject:_pUDDINGAM forKey:kINDiaryFieldsPUDDINGAM];
//    [aCoder encodeObject:_aGEGROUPTOILETINGTODAY forKey:kINDiaryFieldsAGEGROUPTOILETINGTODAY];
//    [aCoder encodeObject:_nOTESTOPARENTS forKey:kINDiaryFieldsNOTESTOPARENTS];
//    [aCoder encodeObject:_tOILETINGWHEN forKey:kINDiaryFieldsTOILETINGWHEN];
//    [aCoder encodeObject:_aGEGROUPNAPPIES forKey:kINDiaryFieldsAGEGROUPNAPPIES];
//    [aCoder encodeObject:_pUDDINGPM forKey:kINDiaryFieldsPUDDINGPM];
//    [aCoder encodeObject:_iTRIED forKey:kINDiaryFieldsITRIED];
//    [aCoder encodeObject:_pUDDINGAMVISIBLE forKey:kINDiaryFieldsPUDDINGAMVISIBLE];
//    [aCoder encodeObject:_tEA forKey:kINDiaryFieldsTEA];
//    [aCoder encodeObject:_dRY forKey:kINDiaryFieldsDRY];
//    [aCoder encodeObject:_wHATIATETODAY forKey:kINDiaryFieldsWHATIATETODAY];
//    [aCoder encodeObject:_oBSERVATIONTEXT forKey:kINDiaryFieldsOBSERVATIONTEXT];
//    [aCoder encodeObject:_aGEGROUPWHATIATETODAY forKey:kINDiaryFieldsAGEGROUPWHATIATETODAY];
//    [aCoder encodeObject:_tEAVISIBLE forKey:kINDiaryFieldsTEAVISIBLE];
//    [aCoder encodeObject:_aGEGROUPIHADMYBOTTLE forKey:kINDiaryFieldsAGEGROUPIHADMYBOTTLE];
//    [aCoder encodeObject:_sNACKAM forKey:kINDiaryFieldsSNACKAM];
//    [aCoder encodeObject:_sNACKPM forKey:kINDiaryFieldsSNACKPM];
//    [aCoder encodeObject:_sOILED forKey:kINDiaryFieldsSOILED];
//    [aCoder encodeObject:_aREASASSESSED forKey:kINDiaryFieldsAREASASSESSED];
//    [aCoder encodeObject:_sLEEPTIMES forKey:kINDiaryFieldsSLEEPTIMES];
//    [aCoder encodeObject:_lUNCH forKey:kINDiaryFieldsLUNCH];
//    [aCoder encodeObject:_oBSERVATIONSACHIEVEMENTS forKey:kINDiaryFieldsOBSERVATIONSACHIEVEMENTS];
//    [aCoder encodeObject:_leftAt forKey:kINDiaryFieldsLeftAt];
//    [aCoder encodeObject:_tOILETINGTODAY1 forKey:kINDiaryFieldsTOILETINGTODAY1];
//    [aCoder encodeObject:_wOKEUP forKey:kINDiaryFieldsWOKEUP];
//    [aCoder encodeObject:_aGEGROUPSLEEPTIMES forKey:kINDiaryFieldsAGEGROUPSLEEPTIMES];
//    [aCoder encodeObject:_iHADMYBOTTLE forKey:kINDiaryFieldsIHADMYBOTTLE];
//    [aCoder encodeObject:_pUDDINGPMVISIBLE forKey:kINDiaryFieldsPUDDINGPMVISIBLE];
//    [aCoder encodeObject:_lUNCHVISIBLE forKey:kINDiaryFieldsLUNCHVISIBLE];
//    [aCoder encodeObject:_fELLASLEEP forKey:kINDiaryFieldsFELLASLEEP];
//    [aCoder encodeObject:_wENTONTHETOILET forKey:kINDiaryFieldsWENTONTHETOILET];
//    [aCoder encodeObject:_nAPPIES forKey:kINDiaryFieldsNAPPIES];
//    [aCoder encodeObject:_nAPPIESWHEN forKey:kINDiaryFieldsNAPPIESWHEN];
//    [aCoder encodeObject:_cameInAt forKey:kINDiaryFieldsCameInAt];
//    [aCoder encodeObject:_wET forKey:kINDiaryFieldsWET];
  //  [aCoder encodeObject:_Registry forKey:kRegistry];
}

- (id)copyWithZone:(NSZone *)zone
{
    INDiaryFields *copy = [[INDiaryFields alloc] init];

   if (copy) {
//
//        copy.sLEPTMINHOURS = [self.sLEPTMINHOURS copyWithZone:zone];
//        copy.nOTESFROMPARENTS = [self.nOTESFROMPARENTS copyWithZone:zone];
//        copy.aT = [self.aT copyWithZone:zone];
//        copy.sNACKPMVISIBLE = [self.sNACKPMVISIBLE copyWithZone:zone];
//        copy.bREAKFASTVISIBLE = [self.bREAKFASTVISIBLE copyWithZone:zone];
//        copy.wENTONTHEPOTTY = [self.wENTONTHEPOTTY copyWithZone:zone];
//        copy.bREAKFAST = [self.bREAKFAST copyWithZone:zone];
//        copy.dRANK = [self.dRANK copyWithZone:zone];
//        copy.sNACKAMVISIBLE = [self.sNACKAMVISIBLE copyWithZone:zone];
//        copy.pUDDINGAM = [self.pUDDINGAM copyWithZone:zone];
//        copy.aGEGROUPTOILETINGTODAY = [self.aGEGROUPTOILETINGTODAY copyWithZone:zone];
//        copy.nOTESTOPARENTS = [self.nOTESTOPARENTS copyWithZone:zone];
//        copy.tOILETINGWHEN = [self.tOILETINGWHEN copyWithZone:zone];
//        copy.aGEGROUPNAPPIES = [self.aGEGROUPNAPPIES copyWithZone:zone];
//        copy.pUDDINGPM = [self.pUDDINGPM copyWithZone:zone];
//        copy.iTRIED = [self.iTRIED copyWithZone:zone];
//        copy.pUDDINGAMVISIBLE = [self.pUDDINGAMVISIBLE copyWithZone:zone];
//        copy.tEA = [self.tEA copyWithZone:zone];
//        copy.dRY = [self.dRY copyWithZone:zone];
//        copy.wHATIATETODAY = [self.wHATIATETODAY copyWithZone:zone];
//        copy.oBSERVATIONTEXT = [self.oBSERVATIONTEXT copyWithZone:zone];
//        copy.aGEGROUPWHATIATETODAY = [self.aGEGROUPWHATIATETODAY copyWithZone:zone];
//        copy.tEAVISIBLE = [self.tEAVISIBLE copyWithZone:zone];
//        copy.aGEGROUPIHADMYBOTTLE = [self.aGEGROUPIHADMYBOTTLE copyWithZone:zone];
//        copy.sNACKAM = [self.sNACKAM copyWithZone:zone];
//        copy.sNACKPM = [self.sNACKPM copyWithZone:zone];
//        copy.sOILED = [self.sOILED copyWithZone:zone];
//        copy.aREASASSESSED = [self.aREASASSESSED copyWithZone:zone];
//        copy.sLEEPTIMES = [self.sLEEPTIMES copyWithZone:zone];
//        copy.lUNCH = [self.lUNCH copyWithZone:zone];
//        copy.oBSERVATIONSACHIEVEMENTS = [self.oBSERVATIONSACHIEVEMENTS copyWithZone:zone];
//        copy.leftAt = [self.leftAt copyWithZone:zone];
//        copy.tOILETINGTODAY1 = [self.tOILETINGTODAY1 copyWithZone:zone];
//        copy.wOKEUP = [self.wOKEUP copyWithZone:zone];
//        copy.aGEGROUPSLEEPTIMES = [self.aGEGROUPSLEEPTIMES copyWithZone:zone];
//        copy.iHADMYBOTTLE = [self.iHADMYBOTTLE copyWithZone:zone];
//        copy.pUDDINGPMVISIBLE = [self.pUDDINGPMVISIBLE copyWithZone:zone];
//        copy.lUNCHVISIBLE = [self.lUNCHVISIBLE copyWithZone:zone];
//        copy.fELLASLEEP = [self.fELLASLEEP copyWithZone:zone];
//        copy.wENTONTHETOILET = [self.wENTONTHETOILET copyWithZone:zone];
//        copy.nAPPIES = [self.nAPPIES copyWithZone:zone];
//        copy.nAPPIESWHEN = [self.nAPPIESWHEN copyWithZone:zone];
//        copy.cameInAt = [self.cameInAt copyWithZone:zone];
//        copy.wET = [self.wET copyWithZone:zone];
     //  copy.Registry=[self.Registry copyWithZone:zone];
    }

    return copy;
}


@end
