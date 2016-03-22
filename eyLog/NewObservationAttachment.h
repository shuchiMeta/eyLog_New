//
//  NewObservationAttachment.h
//  eyLog
//
//  Created by Qss on 10/20/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewObservationAttachment : NSManagedObject

@property (nonatomic, retain) NSNumber * practitionerId;
@property (nonatomic, retain) NSNumber * childId;
@property (nonatomic, retain) NSString * attachmentName;
@property (nonatomic, retain) NSString * attachmentType;
@property (nonatomic, retain) NSString * attachmentPath;
@property (nonatomic, retain) NSString * observationId;
@property (nonatomic, retain) NSString * thumbnailPath;
@property (nonatomic, retain) NSString * fileURL;
@property (nonatomic, retain) NSString * deletePath;
@property (assign, nonatomic) BOOL  isAdded;
@property (assign, nonatomic) BOOL  isDeletedd;


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
                                    withDeletePath:(NSString *)deletePath;


+(NSArray *) fetchALLObservationAttachmentsInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withObservationId:(NSString *)a_observationId;

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_eylogUserId withChildId:(NSNumber *)a_childId;

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId
                              withAttachmentType:(NSString *)attachmentType;
+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationId:(NSString *)a_observationId;

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withAttachmentType:(NSString *)attachmentType withAttachmentName:(NSString *)attachmentName;

+(NSArray *) fetchObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId withObservationId:(NSString *)a_observationId withIsAdded:(BOOL)isAdded andIsDeleted:(BOOL)isDeleted;

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withChildId:(NSNumber *)a_childId;

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) observation;

+(BOOL) deleteObservationAttachmentInContext:(NSManagedObjectContext *)a_context withoutMediaObject:(NSArray *) observation;

@end
