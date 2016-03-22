//
//  NewObservationAttachment.m
//  eyLog
//
//  Created by Qss on 10/20/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NewObservationAttachment.h"

@implementation NewObservationAttachment
@dynamic practitionerId;
@dynamic childId;
@dynamic attachmentName;
@dynamic attachmentType;
@dynamic attachmentPath;
@dynamic observationId;
@dynamic thumbnailPath;
@dynamic fileURL;
@dynamic deletePath;

+ (NewObservationAttachment *) createObservationInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:a_context];
}

+(NewObservationAttachment *) createChildInContext:(NSManagedObjectContext *)a_context
                                withPractitionerId:(NSNumber *)a_practitionerId
                                       withChildId:(NSNumber *)a_childId
                                withAttachmentName:(NSString *)a_attachmentName
                                withAttachmentType:(NSString *)a_attachmentType
                                withAttachmentPath:(NSString *)a_attachmentPath
                                 withObservationId:(NSString *)a_observationId
                                       withIsAdded:(BOOL)isAdded
                                     withIsDeleted:(BOOL)isDeleted
                                      withFilePath:(NSString *)filePath
                                 withThumbnailPath:(NSString *)thumbnailPath
                                    withDeletePath:(NSString *)deletePath
{
    
    NewObservationAttachment *_newObservationAttachment;
    NSError *_savingError = nil;
    
    _newObservationAttachment = [NewObservationAttachment createObservationInContext:a_context];
    if(_newObservationAttachment == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }
    _newObservationAttachment.childId=a_childId?:@(-1);
    _newObservationAttachment.practitionerId=a_practitionerId?:@(-1);
    _newObservationAttachment.attachmentName=a_attachmentName?:@"";
    _newObservationAttachment.attachmentType=a_attachmentType?:@"";
    _newObservationAttachment.attachmentPath=a_attachmentPath?:@"";
    _newObservationAttachment.observationId =a_observationId?:@"";
    _newObservationAttachment.isAdded = isAdded;
    _newObservationAttachment.isDeletedd = isDeleted;
    _newObservationAttachment.thumbnailPath = [thumbnailPath isEqual:[NSNull null]] ? [NSString string] : thumbnailPath;
    _newObservationAttachment.fileURL = [filePath isEqual:[NSNull null]] ? [NSString string] : filePath;
    _newObservationAttachment.deletePath = deletePath;
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservationAttachment : Saved Observation with child Id %@, practitioner Id %@.", [_newObservationAttachment childId], [_newObservationAttachment practitionerId]);
        return _newObservationAttachment;
    }
    else
    {
        //Saved failed
        NSLog(@"NewObservationAttachment : Failed Saving with child Id %@, practitioner Id %@.", [_newObservationAttachment childId], [_newObservationAttachment practitionerId]);
        return nil;
    }
}

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"practitionerId = %@ AND childId = %@", a_practitionerId,a_childId]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationId:(NSString *)a_observationId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicateObservationId=[NSPredicate predicateWithFormat:@"observationId = %@", a_observationId];
     NSPredicate *predicatePractitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@", a_practitionerId];
     NSPredicate *predicateChildId=[NSPredicate predicateWithFormat:@"childId = %@", a_childId];
     [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateObservationId,predicatePractitionerId,predicateChildId]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
    return results;
    
    return nil;
}
+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationId:(NSString *)a_observationId withIsAdded:(BOOL)isAdded andIsDeleted:(BOOL)isDeleted
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicateObservationId=[NSPredicate predicateWithFormat:@"observationId = %@", a_observationId];
    NSPredicate *predicatePractitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@", a_practitionerId];
    NSPredicate *predicateChildId=[NSPredicate predicateWithFormat:@"childId = %@", a_childId];
    NSPredicate *predicateAdded=[NSPredicate predicateWithFormat:@"isAdded = %d", isAdded];
    NSPredicate *predicateDeleted=[NSPredicate predicateWithFormat:@"isDeletedd = %d", isDeleted];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateObservationId,predicatePractitionerId,predicateChildId,predicateAdded,predicateDeleted]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    
    return nil;
}


+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withAttachmentType:(NSString *)attachmentType
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicateAttachmentType=[NSPredicate predicateWithFormat:@"attachmentType = %@", attachmentType];
   // NSPredicate *predicatePractitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@", a_practitionerId];
   // NSPredicate *predicateChildId=[NSPredicate predicateWithFormat:@"childId = %@", a_childId];
   // [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateAttachmentType,predicatePractitionerId,predicateChildId]]];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateAttachmentType]]];
    

    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withAttachmentType:(NSString *)attachmentType withAttachmentName:(NSString *)attachmentName
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicateAttachmentType=[NSPredicate predicateWithFormat:@"attachmentType = %@", attachmentType];
    NSPredicate *predicatePractitionerId=[NSPredicate predicateWithFormat:@"practitionerId = %@", a_practitionerId];
    NSPredicate *predicateChildId=[NSPredicate predicateWithFormat:@"childId = %@", a_childId];
    NSPredicate *predicateAttachmentName=[NSPredicate predicateWithFormat:@"attachmentName = %@", attachmentName];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateAttachmentType,predicatePractitionerId,predicateChildId,predicateAttachmentName]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withObservationId:(NSString *)a_observationId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *predicateObservationId=[NSPredicate predicateWithFormat:@"observationId = %@", a_observationId];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateObservationId]]];
    //    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateAttachmentType]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchALLObservationAttachmentsInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId
{
    NSError *_savingError = nil;
    NSArray *observation = [NewObservationAttachment fetchObservationAttachmentInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId];
    
    if (observation.count > 0) {
        for (NewObservationAttachment *attachment in observation) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSRange textRange =[attachment.attachmentPath rangeOfString:@"assets-library"];
            if(textRange.location == NSNotFound) // if path is of assets-library
            {
                NSString *filePath = attachment.attachmentPath;
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                if (success) {
                    NSLog(@"%@ deleted Successfully",filePath);
                }
                else
                {
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
            }
            [a_context deleteObject:attachment];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservationAttachemnt : Deleted Observation Attachemnt with child Id %@", a_childId);
        return true;
    } else
    {
        //Saved failed
        NSLog(@"NewObservationAttachemnt : Delete Observation Attachemnt failed %@", a_childId);
        return false;
    }
}

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) observation
{
    NSError *_savingError = nil;
//    NSArray *observation = [NewObservationAttachment fetchObservationAttachmentInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId withObservationId:a_observationId];
    
    if (observation.count > 0) {
        for (NewObservationAttachment *attachment in observation) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSRange textRange =[attachment.attachmentPath rangeOfString:@"assets-library"];
            if(textRange.location == NSNotFound) // if path is not of assets-library
            {
                NSString *filePath = attachment.attachmentPath;
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                if (success) {
                    NSLog(@"%@ deleted Successfully",filePath);
                }
                else
                {
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
            }
            [a_context deleteObject:attachment];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservationAttachemnt : Deleted Observation Attachemnt");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"NewObservationAttachemnt : Unable to Delete Observation Attachemnt");
        return false;
    }
}

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withoutMediaObject:(NSArray *) observation
{
    NSError *_savingError = nil;
    //    NSArray *observation = [NewObservationAttachment fetchObservationAttachmentInContext:a_context withPractitionerId:a_practitionerId withChildId:a_childId withObservationId:a_observationId];
    
    if (observation.count > 0) {
        for (NewObservationAttachment *attachment in observation) {
            
            [a_context deleteObject:attachment];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"NewObservationAttachemnt : Deleted Observation Attachemnt");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"NewObservationAttachemnt : Unable to Delete Observation Attachemnt");
        return false;
    }
}


@end
