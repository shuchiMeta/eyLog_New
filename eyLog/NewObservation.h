//
//  NewObservation.h
//  eyLog
//
//  Created by MDS_Abhijit on 20/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OBMedia.h"


@interface NewObservation : NSManagedObject

@property (nonatomic, retain) NSString * additionalNotes;
@property (nonatomic, retain) NSString * analysis;
@property (nonatomic, retain) NSNumber * childAge;
@property (nonatomic, retain) NSNumber * childId;
@property (nonatomic, retain) NSString * childName;
@property (nonatomic, retain) NSString * nextSteps;
@property (nonatomic, retain) NSString * observation;
@property (nonatomic, retain) NSDate * observationCreatedAt;
@property (nonatomic, retain) NSString * observedBy;
@property (nonatomic, retain) NSNumber * practitionerId;
@property (nonatomic, retain) NSString * practitionerName;
@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * apiPassword;
@property (nonatomic, retain) NSString * practitionerPin;
@property (nonatomic, retain) NSNumber * observationId;
@property (nonatomic, retain) NSString * mode;
@property (nonatomic, retain) NSNumber * quickObservation;
@property (nonatomic, retain) NSNumber * scaleInvolvement;
@property (nonatomic, retain) NSNumber * scaleWellBeing;
@property (nonatomic, retain) NSNumber * ecatAssessmentLevel;
@property (nonatomic, retain) NSString * ecatAssessment;
@property (nonatomic, retain) NSData * coel;
@property (nonatomic, retain) NSData * eyfsStatement;
@property (nonatomic, retain) NSData * eyfsAgeBand;
@property (nonatomic, retain) NSData * montessori;
@property (nonatomic, retain) NSData * cfe;
@property (nonatomic, retain) NSData * ecat;
@property (nonatomic, retain) NSString * uniqueTabletOID;
@property (nonatomic, assign) BOOL readyForUpload;
@property (nonatomic, retain) NSNumber *numberOFmedia;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) BOOL isUploading;
@property (nonatomic) BOOL isUploaded;
@property (nonatomic, retain) NSString * checksums;
@property (nonatomic, retain) NSData * childIdArray;
@property(nonatomic)BOOL isBefore;
@property(nonatomic)BOOL isProccessed;
@property(nonatomic,retain)NSString *strInternalNotes;






+ (NewObservation *) createNewObservationInContext:(NSManagedObjectContext *)a_context
                                withPractitionerId:(NSNumber *) a_practitionerId
                                       withChildId:(NSNumber *) a_childId
                                   withObservation:(NSString *) a_observation
                                      withAnalysis:(NSString *) a_analysis
                                     withNextSteps:(NSString *) a_nextSteps
                               withAdditionalNotes:(NSString *) a_additionalNotes
                                      withChildAge:(NSNumber *) a_childAge
                                     withChildName:(NSString *) a_childName
                          withObservationCreatedAt:(NSDate *) a_observationCreatedAt
                                    withObservedBy:(NSString *) a_observedBy
                              withPractitionerName:(NSString *) a_practitionerName
                                        withApiKey:(NSString *) a_apiKey
                                   withApiPassword:(NSString *) a_apiPassword
                               withPractitionerPin:(NSString *) a_practitionerPin
                                 withObservationId:(NSNumber *) a_observationId
                                          withMode:(NSString *) a_mode
                              withQuickObservation:(NSNumber *) a_quickObservation
                              withScaleInvolvement:(NSNumber *) a_scaleInvolvement
                                withScaleWellBeing:(NSNumber *) a_scaleWellBeing
                           withEcatAssessmentLevel:(NSNumber *) a_ecatAssessmentLevel
                                withEcatAssessment:(NSString *) a_ecatAssessment
                                          withCoel:(NSArray *) a_coel
                                 withEyfsStatement:(NSArray *) a_eyfsStatement
                                   withEyfsAgeBand:(NSArray *) a_eyfsAgeBand
                                   withMontessori:(NSArray *) a_montessori
                                           withCfe:(NSArray *) a_cfe
                                          withEcat:(NSArray *)a_ecat
                               withUniqueTabletOID:(NSString *) a_uniqueTabletOID
                                  isReadyForUpload:(BOOL) a_readyForUpload
                                    isEditing:(BOOL)a_isEditing
                                       isUploading:(BOOL)a_isUploading
                                        isUploaded:(BOOL)a_isUploaded
                                     withchecksums:(NSString *) a_checksums
                                  withChildIdarray:(NSData *)childIdArray
                                     withInternalNotes:(NSString *)str;

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationid:(NSNumber *) a_observationId;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withDeviceUUID:(NSString *) a_deviceUUID;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withDeviceUUID:(NSString *) a_deviceUUID;
+(NSArray *) fetchALLObservationsInContext:(NSManagedObjectContext *)a_context;
+(BOOL) deleteObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId;
+(BOOL) deleteObservationInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) observation;

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withReadyForUpload:(BOOL) a_readyForUpload withUploading:(BOOL)a_isUploading withUploaded:(BOOL)a_isUploaded;
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withReadyForUpload:(BOOL)a_isReadyForUpload withEditing:(BOOL) a_isEditing withUploading:(BOOL)a_isUploading withUploaded:(BOOL)a_isUploaded;
+(NewObservation *)fetchObservationInContext:(NSManagedObjectContext *)a_context withUniqueTabletOID:(NSString *)a_uniqueTabletOID;
+(NSArray *) fetchAllObservationInContext:(NSManagedObjectContext *)a_context withUniqueTabletOID:(NSString *)a_uniqueTabletOID;
+(NSArray *) fetchALLObservationsInContext:(NSManagedObjectContext *)a_context andReadyForUpload:(BOOL)a_ReadyForUpload;
@end
