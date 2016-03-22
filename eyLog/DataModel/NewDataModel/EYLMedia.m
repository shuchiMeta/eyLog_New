//
//  EYLMediaAttachment.m
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLMedia.h"
#import "DocumentFileHandler.h"
#import "Utils.h"
#import <MediaPlayer/MPMoviePlayerController.h>

@implementation EYLMedia

-(instancetype)initWithMediaAttachmentType:(NSString *)attachmentType{
    if (self = [super init]) {
        self.attachmentType = attachmentType;
    }
    return self;
}
#pragma mark -==============================================================================
-(void)saveMediaInTempDirectory:(NSData *)data{
    self.data = data;
    if ([self.attachmentType isEqualToString:kUTTypeImageType]) {
        self.image = [UIImage imageWithData:data];
        [self saveImageInTempDirectory];
    }
    else if ([self.attachmentType isEqualToString:kUTTypeAudioType]){
        
    }
    else if ([self.attachmentType isEqualToString:kUTTypeVideoType]){
        [self saveVideoInTempDirectory:data];
    }
}
-(NSData *)data{
    if (!_data) {
        NSString * fileName = [[DocumentFileHandler setDocumentDirectoryforPath:self.attachmentPath] stringByAppendingPathComponent:self.attachmentName];
        BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
        if (!fileExist) {
            fileName = [[DocumentFileHandler setTemporaryDirectoryforPath:self.attachmentPath] stringByAppendingPathComponent:self.attachmentName];
        }
        if ([self.attachmentType isEqualToString:kUTTypeImageType]) {
            _data = [NSData dataWithContentsOfFile:fileName];
        }
        else if ([self.attachmentType isEqualToString:kUTTypeAudioType]){
            _data = [NSData dataWithContentsOfFile:fileName];
        }
        else if ([self.attachmentType isEqualToString:kUTTypeVideoType]){
            _data = [NSData dataWithContentsOfFile:fileName];
        }
    }
    return _data;
}
-(UIImage *)image{
    if (!_image) {
        if (self.thumbnailPath.length > 0) {
            
            NSString *docDirFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            if ([[NSFileManager defaultManager] fileExistsAtPath:self.thumbnailPath]) {
                NSLog(@"Yes");
            }else{
                NSLog(@"NO");
            }
            NSData *data = [NSData dataWithContentsOfFile:[docDirFile stringByAppendingString:self.thumbnailPath]];
            _image = [UIImage imageWithData:data];
            if (!_image) {
                _image = [UIImage imageNamed:@"mic-9090"];
            }
        }else {
            if ([self.attachmentType isEqualToString:kUTTypeImageType]) {
                _image = [UIImage imageWithData:self.data];
            }
            else if ([self.attachmentType isEqualToString:kUTTypeAudioType]){
                _image = [UIImage imageNamed:@"mic-9090"];
            }
            else if ([self.attachmentType isEqualToString:kUTTypeVideoType]){
                NSString * fileName = [[DocumentFileHandler setDocumentDirectoryforPath:self.attachmentPath] stringByAppendingPathComponent:self.attachmentName];
                BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
                if (!fileExist) {
                    fileName = [[DocumentFileHandler setTemporaryDirectoryforPath:self.attachmentPath] stringByAppendingPathComponent:self.attachmentName];
                }
                fileExist = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
                if (fileName) {
                    _image = [self thumbImageFromURL:[NSURL fileURLWithPath:fileName]];
                }else{
                    _image = [UIImage imageWithData:nil];
                }
            }
        }
        }
        
    return _image;
}
-(void)saveImageInTempDirectory{
    [self.data writeToFile:[self tempDirectoryPath] atomically:YES];
}
-(void)saveVideoInTempDirectory:(NSData *)data{
    [self.data writeToFile:[self tempDirectoryPath] atomically:YES];
}
-(NSString *)tempDirectoryPath{
    NSString * str = [DocumentFileHandler setTemporaryDirectoryforPath:self.tempPath];
    str = [str stringByAppendingPathComponent:self.tempName];
    return str;
}
#pragma mark -==============================================================================
-(void)moveItemInDocDirectoryFromTempDirectoryWithChildId:(NSString *)childId{
    self.childId = childId;
    if ([self.attachmentType isEqualToString:kUTTypeImageType]) {
        [self moveImageInDocDir];
    }
    else if ([self.attachmentType isEqualToString:kUTTypeAudioType]){
        [self moveAudioInDocDir];
    }
    else if ([self.attachmentType isEqualToString:kUTTypeVideoType]){
        [self moveVideoInDocDir];
    }
}
-(void)moveImageInDocDir{
    
    NSString * imagePath = [DocumentFileHandler getObservationImagesPathForChildId:self.childId];
    NSString * docDirPath = [DocumentFileHandler setDocumentDirectoryforPath:imagePath];
    NSString * attachmentNameee = [DocumentFileHandler getFileNameWithExtension:@"png"];
    NSString * str = [docDirPath stringByAppendingPathComponent:attachmentNameee];
    
    
    if ([self tempDirectoryPath]) {
        NSError *error=nil;
        
        NSData * videoData = [NSData dataWithContentsOfFile:[self tempDirectoryPath]options:NSDataReadingMappedAlways error:&error];
  
          BOOL write = [videoData writeToFile:str atomically:YES];
       // BOOL move = [DocumentFileHandler copyItemAtPath:[self tempDirectoryPath] toPath:str];
        if (write) {
            self.attachmentPath = imagePath;
            self.attachmentName = attachmentNameee;
            [self.delegate updateAttachmentPath:self.attachmentPath withName:attachmentNameee];
        }
    }
    
}
-(void)moveVideoInDocDir{
    NSString * videoPath = [DocumentFileHandler getObservationVideosPathForChildId:self.childId];
    NSString * docDirPath = [DocumentFileHandler setDocumentDirectoryforPath:videoPath];
    NSString * attachmentNameee = [DocumentFileHandler getFileNameWithExtension:@"MP4"];

    NSString * str = [docDirPath stringByAppendingPathComponent:attachmentNameee];
    NSError *error=nil;
    if([self tempDirectoryPath].length>0)
    {
    NSData * videoData = [NSData dataWithContentsOfFile:[self tempDirectoryPath]options:NSDataReadingMappedAlways error:&error];
    
    BOOL write = [videoData writeToFile:str atomically:YES];
    if (write) {
        self.attachmentPath = videoPath;
        self.attachmentName = attachmentNameee;
        [self.delegate updateAttachmentPath:self.attachmentPath withName:attachmentNameee];
    }
    }

}
-(void)moveAudioInDocDir{
    
    NSString * audioPath = [DocumentFileHandler getObservationAudiosPathForChildId:self.childId];
    NSString * docDirPath = [DocumentFileHandler setDocumentDirectoryforPath:audioPath];
    NSString * attachmentNameee = [DocumentFileHandler getFileNameWithExtension:@"m4a"];
    NSString * str = [docDirPath stringByAppendingPathComponent:attachmentNameee];
    if ([self tempDirectoryPath]) {
          NSError *error=nil;
        NSData * videoData = [NSData dataWithContentsOfFile:[self tempDirectoryPath]options:NSDataReadingMappedAlways error:&error];
        
        BOOL write = [videoData writeToFile:str atomically:YES];
        // BOOL move = [DocumentFileHandler copyItemAtPath:[self tempDirectoryPath] toPath:str];
        if (write) {
            self.attachmentPath = audioPath;
            self.attachmentName = attachmentNameee;
            [self.delegate updateAttachmentPath:self.attachmentPath withName:attachmentNameee];
        }
    }
    
}
-(UIImage *)thumbImageFromURL:(NSURL *)url {
    UIImage *thumbnail = nil;
    thumbnail = [Utils generateThumbImage:url];
    return thumbnail;
    return [UIImage imageWithData:[NSData data]];
    
}

@end
