//
//  EYLNewObservationAttachment.h
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewObservationAttachment.h"
#import "EYLMedia.h"
#import "Child.h"

@interface EYLNewObservationAttachment : NSObject <EYLMediaDelegate>

@property (strong, nonatomic) NSNumber * practitionerId;
@property (strong, nonatomic) NSString * attachmentName;
@property (strong, nonatomic) NSString * attachmentType;
@property (strong, nonatomic) NSString * attachmentPath;
@property (strong, nonatomic) NSString * observationId;
@property (strong, nonatomic) NSString *thumbnailPath;
@property (strong, nonatomic) NSString *tempPath;
@property (strong, nonatomic) NSString *tempName;

@property (strong, nonatomic) NSString *fileURL;
@property (assign, nonatomic) BOOL isAdded;
@property (assign, nonatomic) BOOL isDeleted;

@property (strong, nonatomic) EYLMedia * eylMedia;
@property (weak, nonatomic) Child * child;
@property (strong, nonatomic) NewObservationAttachment * newwObservationAttachment;

-(void)saveNewObservationAttachmentForChild:(Child *)child withContext:(NSManagedObjectContext *)context withUniqueTableOID:(NSString *)OID withIsaddedStatus:(BOOL)isadded;
-(void)saveMediaInTempDirectory:(NSData *)data;
-(EYLNewObservationAttachment *)populateDataWithNewObservationAttachment:(NewObservationAttachment *)newObservationAttachment;
-(void)updateNewObservationAttachment:(EYLNewObservationAttachment *)newObservationAttachment;
@end
