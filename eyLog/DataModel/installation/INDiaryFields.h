//
//  INDiaryFields.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface INDiaryFields : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *sLEPTMINHOURS;
@property (nonatomic, strong) NSString *nOTESFROMPARENTS;
@property (nonatomic, strong) NSString *aT;
@property (nonatomic, strong) NSString *sNACKPMVISIBLE;
@property (nonatomic, strong) NSString *bREAKFASTVISIBLE;
@property (nonatomic, strong) NSString *wENTONTHEPOTTY;
@property (nonatomic, strong) NSString *bREAKFAST;
@property (nonatomic, strong) NSString *dRANK;
@property (nonatomic, strong) NSString *sNACKAMVISIBLE;
@property (nonatomic, strong) NSString *pUDDINGAM;
@property (nonatomic, strong) NSString *aGEGROUPTOILETINGTODAY;
@property (nonatomic, strong) NSString *nOTESTOPARENTS;
@property (nonatomic, strong) NSString *tOILETINGWHEN;
@property (nonatomic, strong) NSString *aGEGROUPNAPPIES;
@property (nonatomic, strong) NSString *pUDDINGPM;
@property (nonatomic, strong) NSString *iTRIED;
@property (nonatomic, strong) NSString *pUDDINGAMVISIBLE;
@property (nonatomic, strong) NSString *tEA;
@property (nonatomic, strong) NSString *dRY;
@property (nonatomic, strong) NSString *wHATIATETODAY;
@property (nonatomic, strong) NSString *oBSERVATIONTEXT;
@property (nonatomic, strong) NSString *aGEGROUPWHATIATETODAY;
@property (nonatomic, strong) NSString *tEAVISIBLE;
@property (nonatomic, strong) NSString *aGEGROUPIHADMYBOTTLE;
@property (nonatomic, strong) NSString *sNACKAM;
@property (nonatomic, strong) NSString *sNACKPM;
@property (nonatomic, strong) NSString *sOILED;
@property (nonatomic, strong) NSString *aREASASSESSED;
@property (nonatomic, strong) NSString *sLEEPTIMES;
@property (nonatomic, strong) NSString *lUNCH;
@property (nonatomic, strong) NSString *oBSERVATIONSACHIEVEMENTS;
@property (nonatomic, strong) NSString *leftAt;
@property (nonatomic, strong) NSString *tOILETINGTODAY1;
@property (nonatomic, strong) NSString *wOKEUP;
@property (nonatomic, strong) NSString *aGEGROUPSLEEPTIMES;
@property (nonatomic, strong) NSString *iHADMYBOTTLE;
@property (nonatomic, strong) NSString *pUDDINGPMVISIBLE;
@property (nonatomic, strong) NSString *lUNCHVISIBLE;
@property (nonatomic, strong) NSString *fELLASLEEP;
@property (nonatomic, strong) NSString *wENTONTHETOILET;
@property (nonatomic, strong) NSString *nAPPIES;
@property (nonatomic, strong) NSString *nAPPIESWHEN;
@property (nonatomic, strong) NSString *cameInAt;
@property (nonatomic, strong) NSString *wET;

///    Added By Arpan nnn
@property (nonatomic, strong) NSDictionary *dict_Registry;
@property (nonatomic, strong) NSDictionary *dict_WhatIate;
@property (nonatomic, strong) NSDictionary *dict_SleepTimes;
@property (nonatomic, strong) NSDictionary *dict_IHadMyBottle;
@property (nonatomic, strong) NSMutableDictionary *dict_Nappies;
@property (nonatomic, strong) NSMutableDictionary *dict_Toileting;
@property (nonatomic, strong) NSMutableDictionary *dict_AdditionalNotes;
@property (nonatomic, strong) NSMutableDictionary *dict_ObservationFields;






+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
