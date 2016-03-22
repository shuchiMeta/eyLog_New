//
//  OBData.m
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "OBData.h"
#import "OBMontessori.h"
#import "OBEyfs.h"
#import "OBCoel.h"
#import "OBEcat.h"
#import "OBCfe.h"

NSString *const kOBDataAnalysis = @"analysis";
NSString *const kOBDataComments = @"comments";
NSString *const kOBDataMontessori = @"montessori";
NSString *const kOBDatacfe = @"cfe";
NSString *const kOBDataScottish=@"scottish";

//scottish
//cfe
NSString *const kOBDataEcat = @"ecat";
NSString *const kOBDataObserverId = @"observer_id";
NSString *const kOBDataObservationBy = @"observation_by";
NSString *const kOBDataUniqueTabletOID = @"unique_tablet_OID";
NSString *const kOBDataScaleWellBeing = @"scale_well_being";
NSString *const kOBDataAgeMonths = @"age_months";
NSString *const kOBDataObservationText = @"observation_text";
NSString *const kOBDataNextSteps = @"next_steps";
NSString *const kOBDataMode = @"mode";
NSString *const kOBDataQuickObservationTag = @"quick_observation_tag";
NSString *const kOBDataEcatAssessment = @"ecat_assessment";
NSString *const kOBDataEyfs = @"eyfs";
NSString *const kOBDataCoel = @"coel";
NSString *const kOBDataObservationId = @"observation_id";
NSString *const kOBDataChildId = @"child_id";
NSString *const kOBDataDateTime = @"date_time";
NSString *const kOBDataScaleInvolvement = @"scale_involvement";
NSString *const kOBDataMedia = @"media";
NSString *const kObDataInternalNotes=@"staff_comments";

@interface OBData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OBData

@synthesize analysis = _analysis;
@synthesize comments = _comments;
@synthesize montessori = _montessori;
@synthesize cfe = _cfe;
@synthesize ecat=_ecat;
@synthesize observerId = _observerId;
@synthesize observationBy = _observationBy;
@synthesize uniqueTabletOID = _uniqueTabletOID;
@synthesize scaleWellBeing = _scaleWellBeing;
@synthesize ageMonths = _ageMonths;
@synthesize observationText = _observationText;
@synthesize nextSteps = _nextSteps;
@synthesize mode = _mode;
@synthesize quickObservationTag = _quickObservationTag;
@synthesize ecatAssessment = _ecatAssessment;
@synthesize eyfs = _eyfs;
@synthesize observationId = _observationId;
@synthesize childId = _childId;
@synthesize dateTime = _dateTime;
@synthesize scaleInvolvement = _scaleInvolvement;
@synthesize media = _media;
@synthesize strInternalNotes=_strInternalNotes;


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
        self.analysis = [self objectOrNilForKey:kOBDataAnalysis fromDictionary:dict];
        self.comments = [self objectOrNilForKey:kOBDataComments fromDictionary:dict];
        NSObject *receivedOBMontessori = [dict objectForKey:kOBDataMontessori];
        NSMutableArray *parsedOBMontessori = [NSMutableArray array];
        if ([receivedOBMontessori isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBMontessori) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBMontessori addObject:[OBMontessori modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBMontessori isKindOfClass:[NSDictionary class]]) {
            [parsedOBMontessori addObject:[OBMontessori modelObjectWithDictionary:(NSDictionary *)receivedOBMontessori]];
        }
        NSObject *receivedOBCfe = [dict objectForKey:kOBDataScottish];
        NSMutableArray *parsedOBCfe = [NSMutableArray array];
        if ([receivedOBCfe isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBCfe) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBCfe addObject:[OBCfe modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBCfe isKindOfClass:[NSDictionary class]]) {
            [parsedOBCfe addObject:[OBCfe modelObjectWithDictionary:(NSDictionary *)receivedOBCfe]];
        }
        self.cfe = [NSArray arrayWithArray:parsedOBCfe];
        
        self.montessori = [NSArray arrayWithArray:parsedOBMontessori];
        self.observerId = [self objectOrNilForKey:kOBDataObserverId fromDictionary:dict];
        self.observationBy = [self objectOrNilForKey:kOBDataObservationBy fromDictionary:dict];
        self.uniqueTabletOID = [self objectOrNilForKey:kOBDataUniqueTabletOID fromDictionary:dict];
        self.scaleWellBeing = [self objectOrNilForKey:kOBDataScaleWellBeing fromDictionary:dict];
        self.ageMonths = [self objectOrNilForKey:kOBDataAgeMonths fromDictionary:dict];
        self.observationText = [self objectOrNilForKey:kOBDataObservationText fromDictionary:dict];
        self.nextSteps = [self objectOrNilForKey:kOBDataNextSteps fromDictionary:dict];
        self.mode = [self objectOrNilForKey:kOBDataMode fromDictionary:dict];
        self.quickObservationTag = [[self objectOrNilForKey:kOBDataQuickObservationTag fromDictionary:dict] boolValue];
        self.ecatAssessment = [self objectOrNilForKey:kOBDataEcatAssessment fromDictionary:dict];

        self.strInternalNotes = [self objectOrNilForKey:kObDataInternalNotes fromDictionary:dict];
        
        NSObject *receivedOBEcat = [dict objectForKey:kOBDataEcat];
        NSMutableArray *parsedOBEcat = [NSMutableArray array];
        if ([receivedOBEcat isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBEcat) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBEcat addObject:[OBEcat modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBEcat isKindOfClass:[NSDictionary class]]) {
            [parsedOBEcat addObject:[OBEcat modelObjectWithDictionary:(NSDictionary *)receivedOBEcat]];
        }

        self.ecat = [NSArray arrayWithArray:parsedOBEcat];


        NSObject *receivedOBEyfs = [dict objectForKey:kOBDataEyfs];
        NSMutableArray *parsedOBEyfs = [NSMutableArray array];
        if ([receivedOBEyfs isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBEyfs) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBEyfs addObject:[OBEyfs modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBEyfs isKindOfClass:[NSDictionary class]]) {
            [parsedOBEyfs addObject:[OBEyfs modelObjectWithDictionary:(NSDictionary *)receivedOBEyfs]];
        }

        self.eyfs = [NSArray arrayWithArray:parsedOBEyfs];

        NSObject *receivedOBCoel = [dict objectForKey:kOBDataCoel];
        NSMutableArray *parsedOBCoel = [NSMutableArray array];
        if ([receivedOBCoel isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBCoel) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedOBCoel addObject:[OBCoel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedOBCoel isKindOfClass:[NSDictionary class]]) {
            [parsedOBCoel addObject:[OBEyfs modelObjectWithDictionary:(NSDictionary *)receivedOBCoel]];
        }

        self.coel = [NSArray arrayWithArray:parsedOBCoel];
        self.observationId = [self objectOrNilForKey:kOBDataObservationId fromDictionary:dict];
        self.childId = [self objectOrNilForKey:kOBDataChildId fromDictionary:dict];
        self.dateTime = [self objectOrNilForKey:kOBDataDateTime fromDictionary:dict];
        self.scaleInvolvement = [self objectOrNilForKey:kOBDataScaleInvolvement fromDictionary:dict];
        self.media = [[OBMedia alloc] initWithDictionary:[self objectOrNilForKey:kOBDataMedia fromDictionary:dict]];
    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.analysis forKey:kOBDataAnalysis];
    [mutableDict setValue:self.comments forKey:kOBDataComments];
    NSMutableArray *tempArrayForMontessori = [NSMutableArray array];
    for (NSObject *subArrayObject in self.montessori) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMontessori addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMontessori addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMontessori] forKey:kOBDataMontessori];

    NSMutableArray *tempArrayForCfe = [NSMutableArray array];
    for (NSObject *subArrayObject in self.cfe) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCfe addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCfe addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCfe] forKey:kOBDataScottish];
    

    
    
    NSMutableArray *tempArrayForEcat = [NSMutableArray array];
    for (NSObject *subArrayObject in self.ecat) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEcat addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEcat addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEcat] forKey:kOBDataEcat];
    [mutableDict setValue:self.observerId forKey:kOBDataObserverId];
    [mutableDict setValue:self.observationBy forKey:kOBDataObservationBy];
    [mutableDict setValue:self.uniqueTabletOID forKey:kOBDataUniqueTabletOID];
    [mutableDict setValue:self.scaleWellBeing forKey:kOBDataScaleWellBeing];
    [mutableDict setValue:self.ageMonths forKey:kOBDataAgeMonths];
    [mutableDict setValue:self.observationText forKey:kOBDataObservationText];
    [mutableDict setValue:self.nextSteps forKey:kOBDataNextSteps];
    [mutableDict setValue:self.mode forKey:kOBDataMode];
    [mutableDict setValue:[NSNumber numberWithBool:self.quickObservationTag] forKey:kOBDataQuickObservationTag];
    [mutableDict setValue:self.ecatAssessment forKey:kOBDataEcatAssessment];
    [mutableDict setValue:self.strInternalNotes forKey:kObDataInternalNotes];
    
    NSMutableArray *tempArrayForEyfs = [NSMutableArray array];
    for (NSObject *subArrayObject in self.eyfs) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEyfs addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEyfs addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEyfs] forKey:kOBDataEyfs];
    [mutableDict setValue:self.observationId forKey:kOBDataObservationId];
    [mutableDict setValue:self.childId forKey:kOBDataChildId];
    [mutableDict setValue:self.dateTime forKey:kOBDataDateTime];
    [mutableDict setValue:self.scaleInvolvement forKey:kOBDataScaleInvolvement];
    [mutableDict setValue:self.media forKey:kOBDataMedia];

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

    self.analysis = [aDecoder decodeObjectForKey:kOBDataAnalysis];
    self.comments = [aDecoder decodeObjectForKey:kOBDataComments];
    self.montessori = [aDecoder decodeObjectForKey:kOBDataMontessori];
    self.cfe = [aDecoder decodeObjectForKey:kOBDataScottish];
    self.ecat =[aDecoder decodeObjectForKey:kOBDataEcat];
    self.observerId = [aDecoder decodeObjectForKey:kOBDataObserverId];
    self.observationBy = [aDecoder decodeObjectForKey:kOBDataObservationBy];
    self.uniqueTabletOID = [aDecoder decodeObjectForKey:kOBDataUniqueTabletOID];
    self.scaleWellBeing = [aDecoder decodeObjectForKey:kOBDataScaleWellBeing];
    self.ageMonths = [aDecoder decodeObjectForKey:kOBDataAgeMonths];
    self.observationText = [aDecoder decodeObjectForKey:kOBDataObservationText];
    self.nextSteps = [aDecoder decodeObjectForKey:kOBDataNextSteps];
    self.mode = [aDecoder decodeObjectForKey:kOBDataMode];
    self.quickObservationTag = [aDecoder decodeBoolForKey:kOBDataQuickObservationTag];
    self.ecatAssessment = [aDecoder decodeObjectForKey:kOBDataEcatAssessment];
    self.eyfs = [aDecoder decodeObjectForKey:kOBDataEyfs];
    self.observationId = [aDecoder decodeObjectForKey:kOBDataObservationId];
    self.childId = [aDecoder decodeObjectForKey:kOBDataChildId];
    self.dateTime = [aDecoder decodeObjectForKey:kOBDataDateTime];
    self.scaleInvolvement = [aDecoder decodeObjectForKey:kOBDataScaleInvolvement];
    self.media = [aDecoder decodeObjectForKey:kOBDataMedia];
    self.strInternalNotes=[aDecoder decodeObjectForKey:kObDataInternalNotes];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_analysis forKey:kOBDataAnalysis];
    [aCoder encodeObject:_comments forKey:kOBDataComments];
    [aCoder encodeObject:_montessori forKey:kOBDataMontessori];
      [aCoder encodeObject:_cfe forKey:kOBDataScottish];
    [aCoder encodeObject:_ecat forKey:kOBDataEcat];
    [aCoder encodeObject:_observerId forKey:kOBDataObserverId];
    [aCoder encodeObject:_observationBy forKey:kOBDataObservationBy];
    [aCoder encodeObject:_uniqueTabletOID forKey:kOBDataUniqueTabletOID];
    [aCoder encodeObject:_scaleWellBeing forKey:kOBDataScaleWellBeing];
    [aCoder encodeObject:_ageMonths forKey:kOBDataAgeMonths];
    [aCoder encodeObject:_observationText forKey:kOBDataObservationText];
    [aCoder encodeObject:_nextSteps forKey:kOBDataNextSteps];
    [aCoder encodeObject:_mode forKey:kOBDataMode];
    [aCoder encodeBool:_quickObservationTag forKey:kOBDataQuickObservationTag];
    [aCoder encodeObject:_ecatAssessment forKey:kOBDataEcatAssessment];
    [aCoder encodeObject:_eyfs forKey:kOBDataEyfs];
    [aCoder encodeObject:_observationId forKey:kOBDataObservationId];
    [aCoder encodeObject:_childId forKey:kOBDataChildId];
    [aCoder encodeObject:_dateTime forKey:kOBDataDateTime];
    [aCoder encodeObject:_scaleInvolvement forKey:kOBDataScaleInvolvement];
    [aCoder encodeObject:_media forKey:kOBDataMedia];
    [aCoder encodeObject:_strInternalNotes forKey:kObDataInternalNotes];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    OBData *copy = [[OBData alloc] init];

    if (copy) {

        copy.analysis = [self.analysis copyWithZone:zone];
        copy.comments = [self.comments copyWithZone:zone];
        copy.montessori = [self.montessori copyWithZone:zone];
         copy.cfe = [self.cfe copyWithZone:zone];
        copy.ecat=[self.ecat copyWithZone:zone];
        copy.observerId = [self.observerId copyWithZone:zone];
        copy.observationBy = [self.observationBy copyWithZone:zone];
        copy.uniqueTabletOID = [self.uniqueTabletOID copyWithZone:zone];
        copy.scaleWellBeing = [self.scaleWellBeing copyWithZone:zone];
        copy.ageMonths = [self.ageMonths copyWithZone:zone];
        copy.observationText = [self.observationText copyWithZone:zone];
        copy.nextSteps = [self.nextSteps copyWithZone:zone];
        copy.mode = [self.mode copyWithZone:zone];
        copy.quickObservationTag = self.quickObservationTag;
        copy.ecatAssessment = [self.ecatAssessment copyWithZone:zone];
        copy.eyfs = [self.eyfs copyWithZone:zone];
        copy.observationId = [self.observationId copyWithZone:zone];
        copy.childId = [self.childId copyWithZone:zone];
        copy.dateTime = [self.dateTime copyWithZone:zone];
        copy.scaleInvolvement = [self.scaleInvolvement copyWithZone:zone];
        copy.media = [self.media copyWithZone:zone];
        copy.strInternalNotes=[self.strInternalNotes copyWithZone:zone];
        
    }

    return copy;
}


@end
