//
//  DocumentFileHandler.m
//  eyLog
//
//  Created by Shivank Agarwal on 20/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "DocumentFileHandler.h"

 NSString *const kObservationVideos = @"ObservationVideos";
 NSString *const kObservationAudios = @"ObservationAudios";
 NSString *const kObservationImages = @"ObservationImages";
NSString *const kAudios = @"Audios";

@implementation DocumentFileHandler

+(NSString *)getTemporaryDirectory {
    return  NSTemporaryDirectory();
}
+ (NSString *)getDocumentDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+(NSString *)getFileNameWithExtension:(NSString *)extension
{
    NSString * fileName = [NSString stringWithFormat: @"%.0f.%@",[NSDate timeIntervalSinceReferenceDate] * 1000.0,extension];
    return fileName;
}
+(NSString *)getAudioPathForAudio:(NSString *)audio{
    if (!audio) {
        return nil;
    }
    NSString *filePath = [kAudios stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",audio]];
    return filePath;
}

+(NSString *)getObservationAudioPathForTempChild:(NSString *)tempChild{
    if (!tempChild) {
        return nil;
    }
    NSString *filePath = [kObservationAudios stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempChild]];
    return filePath;
}
+(NSString *)getObservationVideosPathForTempChild:(NSString *)tempChild{
    if (!tempChild) {
        return nil;
    }
    NSString *filePath = [kObservationVideos stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempChild]];
    return filePath;
}
+(NSString *)getObservationImagesPathForTempChild:(NSString *)tempChild{
    if (!tempChild) {
        return nil;
    }
    NSString *filePath = [kObservationImages stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempChild]];
    return filePath;
}
+ (NSString *)setTemporaryDirectoryforPath:(NSString *)path {
    if (!path) {
        return nil;
    }
    NSString *filePath = [[self getTemporaryDirectory] stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
       
        NSLog(@"Temporary directory already present.");
        return filePath;
    }
    else{
        NSError *error = nil;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for user.");
        }
    }
    return filePath;
}

+ (NSString *)setDocumentDirectoryforPath:(NSString *)path {
    if (!path) {
        return nil;
    }
    NSString *filePath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"Document directory already present.");
        return filePath;
    }
    else{
        NSError *error = nil;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"Unable to create directory for user.");
        }
    }
    return filePath;
}
+ (NSString *)getObservationVideosPathForChildId:(NSString *)childId {
    if (!childId) {
        return nil;
    }
    NSString *filePath = [kObservationVideos stringByAppendingPathComponent:[NSString stringWithFormat:@"Child-%@",childId]];
    return filePath;
}
+ (NSString *)getObservationAudiosPathForChildId:(NSString *)childId {
    if (!childId) {
        return nil;
    }
    NSString *filePath = [kObservationAudios stringByAppendingPathComponent:[NSString stringWithFormat:@"Child-%@",childId]];
    return filePath;
}
+ (NSString *)getObservationImagesPathForChildId:(NSString *)childId {
    if (!childId) {
        return nil;
    }
    NSString *filePath = [kObservationImages stringByAppendingPathComponent:[NSString stringWithFormat:@"Child-%@",childId]];
    return filePath;
}
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)filePath
{
    NSError * error = nil;
    BOOL move = [[NSFileManager defaultManager] moveItemAtPath:path toPath:filePath error:&error];
    NSLog(@"error %@",error);
    return move;
}
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)filePath
{
    NSError * error = nil;
    BOOL move = [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:path] toURL:[NSURL fileURLWithPath:filePath] error:&error];
    NSLog(@"error %@",error);
    return move;
}
+(BOOL)removeItemAtPath:(NSString *)path
{
    NSError * error = nil;
    BOOL move = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    NSLog(@"error %@",error);
    return move;
}

@end
