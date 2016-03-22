//
//  EYLMediaAttachment.h
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EYLMediaDelegate <NSObject>

-(void)updateAttachmentPath:(NSString *)attchmentPath withName:(NSString *)name;

@end

@interface EYLMedia : NSObject

@property (strong, nonatomic) NSString * attachmentType;
@property (strong, nonatomic) NSString * attachmentPath;
@property (strong, nonatomic) NSString * attachmentName;
@property (strong, nonatomic) NSString *fileURL;
@property (strong, nonatomic) NSString *thumbnailPath;
@property (strong, nonatomic) NSString *tempPath;
@property (strong, nonatomic) NSString *tempName;

@property (strong, nonatomic) UIImage  * image;
@property (strong, nonatomic) NSData * data;
@property (weak, nonatomic) id <EYLMediaDelegate> delegate;
@property (strong, nonatomic) NSString * childId;

-(instancetype)initWithMediaAttachmentType:(NSString *)attachmentType;
-(void)saveMediaInTempDirectory:(NSData *)data;
-(void)moveItemInDocDirectoryFromTempDirectoryWithChildId:(NSString *)childId;

@end
