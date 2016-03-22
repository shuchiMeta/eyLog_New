//
//  NewObservation.m
//  eyLog
//
//  Created by MDS_Abhijit on 20/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NewObservation.h"
#import "APICallManager.h"


@implementation NewObservation

@dynamic additionalNotes;
@dynamic analysis;
@dynamic childAge;
@dynamic childId;
@dynamic childName;
@dynamic nextSteps;
@dynamic observation;
@dynamic observationCreatedAt;
@dynamic observedBy;
@dynamic practitionerId;
@dynamic practitionerName;
@dynamic apiKey;
@dynamic apiPassword;
@dynamic practitionerPin;
@dynamic observationId;
@dynamic mode;
@dynamic quickObservation;
@dynamic scaleInvolvement;
@dynamic scaleWellBeing;
@dynamic ecatAssessmentLevel;
@dynamic ecatAssessment;
@dynamic coel;
@dynamic eyfsStatement;
@dynamic eyfsAgeBand;
@dynamic uniqueTabletOID;
@dynamic readyForUpload;
@dynamic isEditing;
@dynamic isUploaded;
@dynamic isUploading;
@dynamic checksums;
@dynamic numberOFmedia;
@dynamic isBefore;
@dynamic strInternalNotes;


+ (NewObservation *) createObservationInContext:(NSManagedObjectContext *)a_context
{

    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:a_context];
}


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
                                          withEcat:(NSArray *) a_ecat
                               withUniqueTabletOID:(NSString *) a_uniqueTabletOID
                                  isReadyForUpload:(BOOL) a_readyForUpload
                                         isEditing:(BOOL)a_isEditing
                                       isUploading:(BOOL)a_isUploading
                                        isUploaded:(BOOL)a_isUploaded
                                     withchecksums:(NSString *) a_checksums
                                  withChildIdarray:(NSData *)childIdArray
                                        withInternalNotes:(NSString *)str

{

    NewObservation *_newObservation;
    NSError *_savingError = nil;
    NSArray *array =[NewObservation fetchObservationInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId withDeviceUUID:a_uniqueTabletOID];

    if(array.count>0)
        _newObservation=[array lastObject];
    else
    {
        _newObservation = [NewObservation createObservationInContext:a_context];
        _newObservation.uniqueTabletOID = a_uniqueTabletOID;
        _newObservation.childId = a_childId;
        _newObservation.practitionerId = a_practitionerId;
        _newObservation.observationCreatedAt = [NSDate date];
        _newObservation.mode = @"draft";
        _newObservation.readyForUpload = NO;
    }


    if(_newObservation == nil) {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }

    _newObservation.strInternalNotes=str==nil?@"":str;
    
    _newObservation.observation=a_observation==nil?@"":a_observation;
    _newObservation.analysis=a_analysis==nil?@"":a_analysis;
    _newObservation.nextSteps=a_nextSteps==nil?@"":a_nextSteps;
    _newObservation.additionalNotes=a_additionalNotes==nil?@"":a_additionalNotes;
    _newObservation.childAge = a_childAge == nil ? @(-1) : a_childAge;
//    _newObservation.childId = a_childId == nil ? _newObservation.childId : a_childId;
    _newObservation.childName = a_childName == nil ? @"" : a_childName;
    _newObservation.observationCreatedAt = a_observationCreatedAt == nil ?[NSDate date]: a_observationCreatedAt;
    _newObservation.observedBy = a_observedBy == nil ? @"" : a_observedBy;
//    _newObservation.practitionerId = a_practitionerId == nil ? _newObservation.practitionerId : a_practitionerId;
    _newObservation.practitionerName = a_practitionerName == nil ? @"" : a_practitionerName;
    _newObservation.apiKey = a_apiKey == nil ? @"" : a_apiKey;
    _newObservation.apiPassword = a_apiPassword == nil ? @"" : a_apiPassword;
    _newObservation.practitionerPin = a_practitionerPin == nil ? @"" : a_practitionerPin;
    _newObservation.observationId = a_observationId == nil ? @(-1) : a_observationId;
    _newObservation.mode = a_mode == nil ? @"" : a_mode;
    _newObservation.quickObservation = a_quickObservation == nil ? @(0) : a_quickObservation;
    _newObservation.scaleInvolvement = a_scaleInvolvement == nil ? @(-1) : a_scaleInvolvement;
    _newObservation.scaleWellBeing = a_scaleWellBeing == nil ? @(-1) : a_scaleWellBeing;
    _newObservation.ecatAssessmentLevel = a_ecatAssessmentLevel == nil ? @(-1) : a_ecatAssessmentLevel;
    _newObservation.ecatAssessment = a_ecatAssessment == nil ? @"" : a_ecatAssessment;
    _newObservation.readyForUpload = a_readyForUpload;
    _newObservation.isEditing = a_isEditing;
    _newObservation.isUploading = a_isUploading;
    _newObservation.isUploaded = a_isUploaded;
    _newObservation.checksums = a_checksums;
    _newObservation.childIdArray=childIdArray;
    

//    _newObservation.coel = a_coel == nil ? _newObservation.coel : a_coel;

    if (a_coel != nil && a_coel.count > 0)
    {
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:a_coel];
        _newObservation.coel = arrayData;
    }
    else
    {
        _newObservation.coel = _newObservation.coel;
    }

    if (a_eyfsStatement != nil && a_eyfsStatement.count > 0)
    {
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:a_eyfsStatement];
        _newObservation.eyfsStatement = arrayData;
    }
    else
    {
        _newObservation.eyfsStatement = _newObservation.eyfsStatement;
    }

    if (a_eyfsAgeBand != nil && a_eyfsAgeBand.count > 0)
    {

        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:a_eyfsAgeBand];
        _newObservation.eyfsAgeBand = arrayData;
    }
    else
    {
        _newObservation.eyfsAgeBand = _newObservation.eyfsAgeBand;
    }
    if (a_montessori != nil && a_montessori.count > 0)
    {

        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:a_montessori];
        _newObservation.montessori = arrayData;
    }
    
    else
    {
        _newObservation.montessori = _newObservation.montessori;
    }
    if (a_cfe != nil && a_cfe.count > 0)
    {
        
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:a_cfe];
        _newObservation.cfe = arrayData;
    }
    else
    {
         _newObservation.cfe = _newObservation.cfe;
    }
    if (a_ecat != nil && a_ecat.count>0) {
        NSData *arrayData=[NSKeyedArchiver archivedDataWithRootObject:a_ecat];
        _newObservation.ecat=arrayData;
    }
    else
    {
        _newObservation.ecat=_newObservation.ecat;
    }


    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservation : Saved Observation with child Id %@", [_newObservation childId]);

        return _newObservation;

    } else
    {
        //Saved failed
        NSLog(@"NewObservation : Failed Saving Observation with child Id %@", [_newObservation childId]);
        return nil;
    }
}

+(NSArray *) fetchALLObservationsInContext:(NSManagedObjectContext *)a_context andReadyForUpload:(BOOL)a_ReadyForUpload{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];

    NSPredicate *observationId=[NSPredicate predicateWithFormat:@"readyForUpload = %d",a_ReadyForUpload];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[observationId]]];


    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0) {
        return results;
    }
    return nil;
}

+(NSArray *) fetchALLObservationsInContext:(NSManagedObjectContext *)a_context {
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0) {
        return results;
    }
    return nil;
}



+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withDeviceUUID:(NSString *) a_deviceUUID
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];

    NSPredicate *observationId=[NSPredicate predicateWithFormat:@"uniqueTabletOID = %@",a_deviceUUID];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[observationId]]];

    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchAllObservationInContext:(NSManagedObjectContext *)a_context withUniqueTabletOID:(NSString *)a_uniqueTabletOID
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];

    NSPredicate *observationId=[NSPredicate predicateWithFormat:@"uniqueTabletOID = %@",a_uniqueTabletOID];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[observationId]]];

    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NewObservation *)fetchObservationInContext:(NSManagedObjectContext *)a_context withUniqueTabletOID:(NSString *)a_uniqueTabletOID{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uniqueTabletOID = %@",a_uniqueTabletOID];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return [results firstObject];
    return nil;
}

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"childId = %@",a_childId];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationid:(NSNumber *) a_observationId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"childId = %@",a_childId];
    NSPredicate *observationId=[NSPredicate predicateWithFormat:@"observationId = %@",a_observationId];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId,observationId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withDeviceUUID:(NSString *) a_deviceUUID
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"childId = %@",a_childId];
    NSPredicate *deviceUUID=[NSPredicate predicateWithFormat:@"uniqueTabletOID = %@",a_deviceUUID];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId,deviceUUID]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(BOOL) deleteObservationInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId
{
    NSError *_savingError = nil;
    NSArray *observation = [NewObservation fetchObservationInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId];

    if (observation.count > 0) {
        [a_context deleteObject:[observation lastObject]];
    }

    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservation : Deleted Observation with child Id %@", a_childId);
        return true;
    } else
    {
        //Saved failed
        NSLog(@"NewObservation : Delete Observation failed %@", a_childId);
        return false;
    }
}

+(BOOL) deleteObservationInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) observation
{
    NSError *_savingError = nil;
    //    NSArray *observation = [NewObservationAttachment fetchObservationAttachmentInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId withObservationId:a_observationId];

    if (observation.count > 0) {
        for (NewObservation *item in observation) {

            [a_context deleteObject:item];
        }
    }

    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservation : Deleted Observation");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"NewObservation : Unable to Delete Observation");
        return false;
    }
}

+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withReadyForUpload:(BOOL) a_readyForUpload withUploading:(BOOL)a_isUploading withUploaded:(BOOL)a_isUploaded
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];

    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"readyForUpload == %d AND isUploading == %d AND isUploaded == %d",a_readyForUpload,a_isUploading,a_isUploaded];

    a_isUploaded=YES;
    
    // NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"readyForUpload == %d",a_isUploaded];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];

    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withReadyForUpload:(BOOL)a_isReadyForUpload withEditing:(BOOL) a_isEditing withUploading:(BOOL)a_isUploading withUploaded:(BOOL)a_isUploaded
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];

    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"readyForUpload == %d AND isEditing == %d AND isUploading == %d AND isUploaded == %d",a_isReadyForUpload,a_isEditing,a_isUploading,a_isUploaded];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];

    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
@end
