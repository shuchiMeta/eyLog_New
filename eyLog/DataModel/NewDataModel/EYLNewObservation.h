//
//  EYLNewObservation.h
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewObservation.h"
#import "Child.h"
#import "AppDelegate.h"
#import "EYLNewObservationAttachment.h"
#import "APICallManager.h"

@interface EYLNewObservation : NSObject

@property (strong, nonatomic) NSString * additionalNotes;
@property (strong, nonatomic) NSString * analysis;
@property (strong, nonatomic) NSNumber * childAge;
@property (strong, nonatomic) NSNumber * childId;
@property (strong, nonatomic) NSString * childName;
@property (strong, nonatomic) NSString * nextSteps;
@property (strong, nonatomic) NSString * observation;
@property (strong, nonatomic) NSDate * observationCreatedAt;
@property (strong, nonatomic) NSString * observedBy;
@property (strong, nonatomic) NSNumber * practitionerId;
@property (strong, nonatomic) NSString * practitionerName;
@property (strong, nonatomic) NSString * apiKey;
@property (strong, nonatomic) NSString * apiPassword;
@property (strong, nonatomic) NSString * practitionerPin;
@property (strong, nonatomic) NSNumber * observationId;
@property (strong, nonatomic) NSString * mode;
@property (strong, nonatomic) NSNumber * quickObservation;
@property (strong, nonatomic) NSNumber * scaleInvolvement;
@property (strong, nonatomic) NSNumber * scaleWellBeing;
@property (strong, nonatomic) NSNumber * ecatAssessmentLevel;
@property (strong, nonatomic) NSString * ecatAssessment;
@property (strong, nonatomic) NSData * coel;
@property (strong, nonatomic) NSData * eyfsStatement;
@property (strong, nonatomic) NSData * eyfsAgeBand;
@property (strong, nonatomic) NSData * montessori;
@property (strong, nonatomic) NSData * cfe;
@property (strong, nonatomic) NSData * ecat;
@property (strong, nonatomic) NSString * uniqueTabletOID;
@property (assign, nonatomic) BOOL readyForUpload;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isUploading;
@property (assign, nonatomic) BOOL isUploaded;
@property (assign, nonatomic) BOOL isBefore;
@property (strong, nonatomic) NSString* checksums;
@property(strong,nonatomic) NSMutableArray *childIdArray;
@property(strong,nonatomic)NSData *attachmentData;
@property(strong,nonatomic)NSString *UniqueID;
@property(strong,nonatomic)OBMedia *media;
@property(strong,nonatomic)NSString *internalNotes;






@property (strong, nonatomic) NewObservation * newwObservation;

//@property (strong, nonatomic) NewObservation * newObservation;

@property (strong, nonatomic) NSMutableArray * eylNewObservationAttachmentArray;
@property (strong, nonatomic) NSMutableArray * deletedObjectsOfeylNewObservationAttachment;

-(void)saveNewObservationWithChild:(Child *)child;
-(void)saveNewObservationWithChild:(Child *)child withlastItem:(BOOL) lastItem;
-(void)editObservationWithChild:(Child *)child;
-(void)editObservationWithChild:(Child *)child withlastItem:(BOOL) lastItem;
//&& lastItem

-(void)populateDataWithNewObservation:(NewObservation *)newObservation;
-(void)saveNewFucntionalityObservationWithChild:(Child *)child withlastItem:(BOOL) lastItem;


@end
