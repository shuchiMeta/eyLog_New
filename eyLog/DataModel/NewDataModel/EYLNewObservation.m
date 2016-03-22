//
//  EYLNewObservation.m
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLNewObservation.h"
#import "DocumentFileHandler.h"
#import "ImageFile.h"
#import "VideoFile.h"
#import "AudioFile.h"

@implementation EYLNewObservation

@synthesize additionalNotes;
@synthesize analysis;
@synthesize childAge;
@synthesize childId;
@synthesize childName;
@synthesize nextSteps;
@synthesize observation;
@synthesize observationCreatedAt;
@synthesize observedBy;
@synthesize practitionerId;
@synthesize practitionerName;
@synthesize apiKey;
@synthesize apiPassword;
@synthesize practitionerPin;
@synthesize observationId;
@synthesize mode;
@synthesize quickObservation;
@synthesize scaleInvolvement;
@synthesize scaleWellBeing;
@synthesize ecatAssessmentLevel;
@synthesize ecatAssessment;
@synthesize coel;
@synthesize eyfsStatement;
@synthesize eyfsAgeBand;
@synthesize montessori;
@synthesize cfe;
@synthesize ecat;
@synthesize uniqueTabletOID;
@synthesize readyForUpload;
@synthesize isEditing;
@synthesize isUploading;
@synthesize checksums;
@synthesize childIdArray;


@synthesize isUploaded;

-(void)saveNewObservationWithChild:(Child *)child{

    NSManagedObjectContext * context = [AppDelegate context];

    NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
       
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.childIdArray];

    // TODO : check montessori data

    [NewObservation createNewObservationInContext:context withPractitionerId:self.practitionerId withChildId:child.childId withObservation:self.observation withAnalysis:self.analysis withNextSteps:self.nextSteps withAdditionalNotes:self.additionalNotes withChildAge:self.childAge withChildName:self.childName withObservationCreatedAt:self.observationCreatedAt withObservedBy:self.observedBy withPractitionerName:self.practitionerName withApiKey:self.apiKey withApiPassword:self.apiPassword withPractitionerPin:self.practitionerPin withObservationId:[NSNumber numberWithInteger:0] withMode:self.mode withQuickObservation:self.quickObservation withScaleInvolvement:self.scaleInvolvement withScaleWellBeing:self.scaleWellBeing withEcatAssessmentLevel:self.ecatAssessmentLevel withEcatAssessment:self.ecatAssessment withCoel:[NSKeyedUnarchiver unarchiveObjectWithData:self.coel] withEyfsStatement:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsStatement] withEyfsAgeBand:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsAgeBand] withMontessori:[NSKeyedUnarchiver unarchiveObjectWithData:self.montessori] withCfe:[NSKeyedUnarchiver unarchiveObjectWithData:self.cfe] withEcat:[NSKeyedUnarchiver unarchiveObjectWithData:self.ecat]  withUniqueTabletOID:uniqueTabletOIID isReadyForUpload:self.readyForUpload isEditing:self.isEditing isUploading:self.isUploading isUploaded:self.isUploaded  withchecksums:self.checksums withChildIdarray:arrayData withInternalNotes:self.internalNotes];


    for (EYLNewObservationAttachment * attachment in self.eylNewObservationAttachmentArray)
    {
        [attachment saveNewObservationAttachmentForChild:child withContext:context withUniqueTableOID:uniqueTabletOIID withIsaddedStatus:attachment.isAdded];
    }
    NSError * error = nil;
    BOOL save = [context save:&error];

    if (!error && save) {
        [[APICallManager sharedNetworkSingleton]checkReachibilityStatus];
    }
}

-(void)saveNewFucntionalityObservationWithChild:(Child *)child withlastItem:(BOOL) lastItem{

    NSManagedObjectContext * context = [AppDelegate context];

    NSString *uniqueTabletOIID = [[NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0] stringByAppendingString:[child.childId stringValue]];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.childIdArray];

        // TODO : check montessori data.

    NewObservation *obser=   [NewObservation createNewObservationInContext:context withPractitionerId:self.practitionerId withChildId:child.childId withObservation:self.observation withAnalysis:self.analysis withNextSteps:self.nextSteps withAdditionalNotes:self.additionalNotes withChildAge:[NSNumber new] withChildName:[child.firstName stringByAppendingString:child.lastName] withObservationCreatedAt:self.observationCreatedAt withObservedBy:self.observedBy withPractitionerName:self.practitionerName withApiKey:self.apiKey withApiPassword:self.apiPassword withPractitionerPin:self.practitionerPin withObservationId:[NSNumber numberWithInt:0] withMode:self.mode withQuickObservation:self.quickObservation withScaleInvolvement:self.scaleInvolvement withScaleWellBeing:self.scaleWellBeing withEcatAssessmentLevel:self.ecatAssessmentLevel withEcatAssessment:self.ecatAssessment withCoel:[NSKeyedUnarchiver unarchiveObjectWithData:self.coel] withEyfsStatement:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsStatement] withEyfsAgeBand:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsAgeBand] withMontessori:[NSKeyedUnarchiver unarchiveObjectWithData:self.montessori] withCfe:[NSKeyedUnarchiver unarchiveObjectWithData:self.cfe] withEcat:[NSKeyedUnarchiver unarchiveObjectWithData:self.ecat] withUniqueTabletOID:uniqueTabletOIID isReadyForUpload:YES isEditing:NO isUploading:NO isUploaded:NO withchecksums:self.checksums withChildIdarray:arrayData withInternalNotes:self.internalNotes];
    
    obser.isBefore=YES;
    self.isBefore=YES;
   // [self populateDataWithNewObservation:obser];
    
    OBMedia *mediaParam= _media;
    
    
    if (self.eylNewObservationAttachmentArray != nil && self.eylNewObservationAttachmentArray.count > 0)
    {
        NSMutableArray *array=[NSMutableArray new];
        
        for(ImageFile *image in mediaParam.images)
        {
            [array addObject:image.name];
            
            
        }
        for(AudioFile *audio in mediaParam.audios)
        {
            [array addObject:audio.name];
            
            
        }
        for(VideoFile *video in mediaParam.videos)
        {
            [array addObject:video.name];
            
            
        }
        
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
        obser.childIdArray=arrayData;
    
        
        
    }
    
  
    for (EYLNewObservationAttachment * attachment in self.eylNewObservationAttachmentArray) {
        [attachment saveNewObservationAttachmentForChild:child withContext:context withUniqueTableOID:uniqueTabletOIID withIsaddedStatus:attachment.isAdded];
    }
    NSError * error = nil;
    BOOL save = [context save:&error];

    if (!error && save && lastItem)
    {
     //   [[APICallManager sharedNetworkSingleton]checkReachibilityStatus];
    }
}
-(void)saveNewObservationWithChild:(Child *)child withlastItem:(BOOL) lastItem{
    
    NSManagedObjectContext * context = [AppDelegate context];
    
    NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.childIdArray];
    
    // TODO : check montessori data.
    
       [NewObservation createNewObservationInContext:context withPractitionerId:self.practitionerId withChildId:child.childId withObservation:self.observation withAnalysis:self.analysis withNextSteps:self.nextSteps withAdditionalNotes:self.additionalNotes withChildAge:self.childAge withChildName:self.childName withObservationCreatedAt:self.observationCreatedAt withObservedBy:self.observedBy withPractitionerName:self.practitionerName withApiKey:self.apiKey withApiPassword:self.apiPassword withPractitionerPin:self.practitionerPin withObservationId:self.observationId withMode:self.mode withQuickObservation:self.quickObservation withScaleInvolvement:self.scaleInvolvement withScaleWellBeing:self.scaleWellBeing withEcatAssessmentLevel:self.ecatAssessmentLevel withEcatAssessment:self.ecatAssessment withCoel:[NSKeyedUnarchiver unarchiveObjectWithData:self.coel] withEyfsStatement:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsStatement] withEyfsAgeBand:[NSKeyedUnarchiver unarchiveObjectWithData:self.eyfsAgeBand] withMontessori:[NSKeyedUnarchiver unarchiveObjectWithData:self.montessori] withCfe:[NSKeyedUnarchiver unarchiveObjectWithData:self.cfe] withEcat:[NSKeyedUnarchiver unarchiveObjectWithData:self.ecat] withUniqueTabletOID:uniqueTabletOIID isReadyForUpload:self.readyForUpload isEditing:self.isEditing isUploading:self.isUploading isUploaded:self.isUploaded withchecksums:self.checksums withChildIdarray:arrayData withInternalNotes:self.internalNotes];
    
        
    
    for (EYLNewObservationAttachment * attachment in self.eylNewObservationAttachmentArray) {
        [attachment saveNewObservationAttachmentForChild:child withContext:context withUniqueTableOID:uniqueTabletOIID withIsaddedStatus:attachment.isAdded];
    }
    NSError * error = nil;
    BOOL save = [context save:&error];
    
    if (!error && save && lastItem)
    {
        [[APICallManager sharedNetworkSingleton]checkReachibilityStatus];
    }
}


-(void)editObservationWithChild:(Child *)child {

    NSManagedObjectContext * context = [AppDelegate context];
    NewObservation * newObservation = [[NewObservation fetchAllObservationInContext:context withUniqueTabletOID:self.uniqueTabletOID] lastObject];
    
    [self updateNewObservation:newObservation];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isAdded == %d AND isDeleted == %d",YES,NO];

    NSArray * newAttachmentArray = [self.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    NSArray * newObservationAttachmentArray = [NewObservationAttachment fetchObservationAttachmentInContext:context withObservationId:newObservation.uniqueTabletOID];
    for (NewObservationAttachment *attachment in newObservationAttachmentArray) {
        if (attachment.isDeletedd) {
            continue;
        }
        [context deleteObject:attachment];
    }
    for (EYLNewObservationAttachment * attachment in newAttachmentArray) {
        [attachment saveNewObservationAttachmentForChild:child withContext:context withUniqueTableOID:self.uniqueTabletOID withIsaddedStatus:attachment.isAdded];
    }
    predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",YES];

    NSArray * deletedArray = [self.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];

    for (EYLNewObservationAttachment * attachment in deletedArray) {
        @try {
            [attachment updateNewObservationAttachment:attachment];
        }@catch (NSException *exception) {}
    }

    NSError * error = nil;
    BOOL save = [context save:&error];

    if (!error && save ) {
        [[APICallManager sharedNetworkSingleton]checkReachibilityStatus];
    }
}
-(void)updateNewObservation:(NewObservation *)newObservation{

    newObservation.additionalNotes = self.additionalNotes?:@"";
    newObservation.analysis = self.analysis?:@"";
    newObservation.childAge = self.childAge?:[NSNumber numberWithInteger:0];
    newObservation.childId = self.childId?:[NSNumber numberWithInteger:0];
    newObservation.childName = self.childName?:@"";
    newObservation.nextSteps = self.nextSteps?:@"";
    newObservation.observation = self.observation?:@"";
    newObservation.observationCreatedAt = self.observationCreatedAt?:nil;
    newObservation.observedBy = self.observedBy?:@"";
    newObservation.practitionerId = self.practitionerId?:[NSNumber numberWithInteger:0];
    newObservation.practitionerName = self.practitionerName?:@"";
    newObservation.apiKey = self.apiKey?:@"";
    newObservation.apiPassword = self.apiPassword?:@"";
    newObservation.practitionerPin = self.practitionerPin?:@"";
    newObservation.observationId = self.observationId?:[NSNumber numberWithInteger:0];
    newObservation.mode =self.mode?:@"";
    newObservation.quickObservation = self.quickObservation?:[NSNumber numberWithInteger:0];
    newObservation.scaleInvolvement = self.scaleInvolvement?:[NSNumber numberWithInteger:0];
    newObservation.scaleWellBeing = self.scaleWellBeing?:[NSNumber numberWithInteger:0];
    newObservation.ecatAssessmentLevel = self.ecatAssessmentLevel?:[NSNumber numberWithInteger:0];
    newObservation.ecatAssessment = self.ecatAssessment?:@"";
    newObservation.coel = self.coel?:[NSData data];
    newObservation.eyfsStatement = self.eyfsStatement?:[NSData data];
    newObservation.eyfsAgeBand = self.eyfsAgeBand?:[NSData data];
    newObservation.montessori = self.montessori?:[NSData data];
    newObservation.cfe = self.cfe?:[NSData data];
    newObservation.ecat = self.ecat?:[NSData data];
    newObservation.uniqueTabletOID = self.uniqueTabletOID?:@"";
    newObservation.readyForUpload = self.readyForUpload?:NO;
    newObservation.isEditing = self.isEditing?:NO;
    newObservation.isUploading = NO;
    newObservation.isUploaded = NO;
    newObservation.checksums = self.checksums;
    newObservation.strInternalNotes=self.internalNotes;
    
}

-(void)populateDataWithNewObservation:(NewObservation *)newObservation{
    
    self.newwObservation = newObservation;
    self.additionalNotes = newObservation.additionalNotes?:@"";
    self.analysis = newObservation.analysis?:@"";
    self.childAge = newObservation.childAge?:[NSNumber numberWithInteger:0];
    self.childId = newObservation.childId?:[NSNumber numberWithInteger:0];
    self.childName = newObservation.childName?:@"";
    self.nextSteps = newObservation.nextSteps?:@"";
    self.observation = newObservation.observation?:@"";
    self.observationCreatedAt = newObservation.observationCreatedAt?:nil;
    self.observedBy = newObservation.observedBy?:@"";
    self.practitionerId = newObservation.practitionerId?:[NSNumber numberWithInteger:0];
    self.practitionerName = newObservation.practitionerName?:@"";
    self.apiKey = newObservation.apiKey?:@"";
    self.apiPassword = newObservation.apiPassword?:@"";
    self.practitionerPin = newObservation.practitionerPin?:@"";
    self.observationId = newObservation.observationId?:[NSNumber numberWithInteger:0];
    self.mode =newObservation.mode?:@"";
    self.quickObservation = newObservation.quickObservation?:[NSNumber numberWithInteger:0];
    self.scaleInvolvement = newObservation.scaleInvolvement?:[NSNumber numberWithInteger:0];
    self.scaleWellBeing = newObservation.scaleWellBeing?:[NSNumber numberWithInteger:0];
    self.ecatAssessmentLevel = newObservation.ecatAssessmentLevel?:[NSNumber numberWithInteger:0];
    self.ecatAssessment = newObservation.ecatAssessment?:@"";
    self.coel = newObservation.coel?:[NSData data];
    self.eyfsStatement = newObservation.eyfsStatement?:[NSData data];
    self.eyfsAgeBand = newObservation.eyfsAgeBand?:[NSData data];
    self.montessori = newObservation.montessori?:[NSData data];
    self.cfe = newObservation.cfe?:[NSData data];
    self.ecat = newObservation.ecat?:[NSData data];
    self.uniqueTabletOID = newObservation.uniqueTabletOID?:@"";
    self.readyForUpload = newObservation.readyForUpload?:NO;
    self.isEditing = newObservation.readyForUpload?:NO;
    self.isUploading = newObservation.readyForUpload?:NO;
    self.isUploaded = newObservation.readyForUpload?:NO;
    self.attachmentData=newObservation.childIdArray;
    self.internalNotes=newObservation.strInternalNotes;
    
    

    NSArray * newObservationAttachmentArray = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withObservationId:newObservation.uniqueTabletOID];
    for (NewObservationAttachment * attachment in newObservationAttachmentArray) {
        EYLNewObservationAttachment * eylNewObservation = [[EYLNewObservationAttachment alloc]init];
        if (!self.eylNewObservationAttachmentArray) {
            self.eylNewObservationAttachmentArray = [[NSMutableArray alloc]init];
        }
        [self.eylNewObservationAttachmentArray addObject:[eylNewObservation populateDataWithNewObservationAttachment:attachment]];
    }
}
@end
