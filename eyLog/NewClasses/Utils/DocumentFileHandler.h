//
//  DocumentFileHandler.h
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Child.h"

extern NSString *const kObservationVideos;
extern NSString *const kObservationAudios;
extern NSString *const kObservationImages;

@interface DocumentFileHandler : NSObject

+(NSString *)getTemporaryDirectory ;
+ (NSString *)getDocumentDirectoryPath ;
+(NSString *)getFileNameWithExtension:(NSString *)extension;
+ (NSString *)setTemporaryDirectoryforPath:(NSString *)path;
+(NSString *)getObservationImagesPathForTempChild:(NSString *)tempChild;
+(NSString *)getObservationVideosPathForTempChild:(NSString *)tempChild;
+(NSString *)getObservationAudioPathForTempChild:(NSString *)tempChild;
+ (NSString *)setDocumentDirectoryforPath:(NSString *)path;
+ (NSString *)getObservationVideosPathForChildId:(NSString *)childId;
+ (NSString *)getObservationAudiosPathForChildId:(NSString *)childId ;
+ (NSString *)getObservationImagesPathForChildId:(NSString *)childId;
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)filePath;
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)filePath;
+(BOOL)removeItemAtPath:(NSString *)path;
+(NSString *)getAudioPathForAudio:(NSString *)audio;

@end
