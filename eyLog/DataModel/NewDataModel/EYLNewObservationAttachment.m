//
//  EYLNewObservationAttachment.m
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLNewObservationAttachment.h"
#import "DocumentFileHandler.h"

@implementation EYLNewObservationAttachment

@synthesize practitionerId;
@synthesize attachmentName;
@synthesize attachmentType;
@synthesize attachmentPath;
@synthesize observationId;

-(void)saveNewObservationAttachmentForChild:(Child *)child withContext:(NSManagedObjectContext *)context withUniqueTableOID:(NSString *)OID withIsaddedStatus:(BOOL)isadded{
    self.child = child;

    [self moveItemInDocDirectoryFromTempDirectory];
    if (self.isDeleted) {
        return;
    }
    self.newwObservationAttachment = [NewObservationAttachment createChildInContext:context withPractitionerId:self.practitionerId withChildId:child.childId withAttachmentName:self.attachmentName withAttachmentType:self.attachmentType withAttachmentPath:self.attachmentPath withObservationId:OID withIsAdded:isadded withIsDeleted:NO withFilePath:[NSNull null] withThumbnailPath:[NSNull null] withDeletePath:@""];
}
-(void)moveItemInDocDirectoryFromTempDirectory{
    [self.eylMedia moveItemInDocDirectoryFromTempDirectoryWithChildId:[NSString stringWithFormat:@"%@",self.child.childId]];
}
-(void)saveMediaInTempDirectory:(NSData *)data{
    [self.eylMedia saveMediaInTempDirectory:data];
}
-(EYLNewObservationAttachment *)populateDataWithNewObservationAttachment:(NewObservationAttachment *)newObservationAttachment{
    self.practitionerId = newObservationAttachment.practitionerId;
    self.attachmentName = newObservationAttachment.attachmentName;
    self.attachmentType = newObservationAttachment.attachmentType;
    self.attachmentPath = newObservationAttachment.attachmentPath;
    self.observationId = newObservationAttachment.observationId;
    self.isAdded = newObservationAttachment.isAdded;
    self.isDeleted = newObservationAttachment.isDeletedd;
    self.thumbnailPath = newObservationAttachment.thumbnailPath;
    self.fileURL = newObservationAttachment.fileURL;
    self.newwObservationAttachment = newObservationAttachment;
    return self;
}
-(EYLMedia *)eylMedia{
    if (!_eylMedia) {
        _eylMedia = [[EYLMedia alloc]initWithMediaAttachmentType:self.attachmentType];
        _eylMedia.attachmentName = self.attachmentName;
        _eylMedia.attachmentPath = self.attachmentPath;
        _eylMedia.attachmentType = self.attachmentType;
        _eylMedia.thumbnailPath = self.thumbnailPath;
        _eylMedia.fileURL = self.fileURL;
        _eylMedia.delegate = self;
        _eylMedia.tempPath = self.tempPath;
        _eylMedia.tempName = self.tempName;
    }
    return _eylMedia;
}
#pragma mark - EYLMediaDelegate
-(void)updateAttachmentPath:(NSString *)attchmentPath withName:(NSString *)name{
    self.attachmentPath = attchmentPath;
    self.attachmentName = name;
}
-(void)updateNewObservationAttachment:(EYLNewObservationAttachment *)observation{
    NewObservationAttachment * attachment = observation.newwObservationAttachment;
    attachment.practitionerId = observation.practitionerId;
    attachment.attachmentName = observation.attachmentName;
    attachment.attachmentType = observation.attachmentType;
    attachment.attachmentPath = observation.attachmentPath;
    attachment.observationId = observation.observationId;
    attachment.thumbnailPath = observation.thumbnailPath;
    attachment.fileURL = observation.fileURL;
    attachment.isAdded = observation.isAdded;
    attachment.isDeletedd = observation.isDeleted;
}

- (void)setIsDeleted:(BOOL)isDeleted {
    _isDeleted = isDeleted;
    self.newwObservationAttachment.isDeletedd = isDeleted;
}

@end
