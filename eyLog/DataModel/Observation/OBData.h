//
//  OBData.h
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBMedia.h"


@interface OBData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *analysis;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSArray *montessori;
@property (nonatomic, strong) NSArray *cfe;
@property (nonatomic, strong) NSArray *ecat;
@property (nonatomic, strong) NSString *observerId;
@property (nonatomic, strong) NSString *observationBy;
@property (nonatomic, strong) NSString *uniqueTabletOID;
@property (nonatomic, strong) NSString *scaleWellBeing;
@property (nonatomic, strong) NSNumber *ageMonths;
@property (nonatomic, strong) NSString *observationText;
@property (nonatomic, strong) NSString *nextSteps;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, assign) BOOL quickObservationTag;
@property (nonatomic, strong) NSString *ecatAssessment;
@property (nonatomic, strong) NSArray *eyfs;
@property (nonatomic, strong) NSArray *coel;
@property (nonatomic, strong) NSString *observationId;
@property (nonatomic, strong) NSString *childId;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *scaleInvolvement;
@property (nonatomic, strong) OBMedia *media;
@property(nonatomic,strong)NSString *strInternalNotes;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
