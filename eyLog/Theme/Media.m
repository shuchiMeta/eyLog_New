//
//  Medai.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 10/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Media.h"
@import AVFoundation;

#define KUnknownMedia @"KUnknown";
#define KImageType @"KImage";
#define KVideoType @"KVideoType";
#define KAudioType @"KAudioType";

@implementation Media

- (instancetype)initWithType:(MediaType)type data:(NSData *)data path:(NSString *)path {
    if (self = [super init]) {
        self.type = type;
        self.data = data;
        self.fileLocation = [NSURL fileURLWithPath:path];
        UIImage *image = nil;
        switch (type) {
            case MediaTypeUnknown: {
                image = nil;
                self.typeName=KUnknownMedia;
            }
                break;
            case MediaTypeImage: {
                image = [UIImage imageWithData:data];
                self.typeName=KImageType;
            }
                break;
            case MediaTypeAudio: {
                image = nil;
                self.typeName=KAudioType;
            }
                break;
            case MediaTypeMovie: {
                self.typeName=KVideoType;
                image = [self loadImage];
            }
                break;
                
            default:
                break;
        }
        self.thumbNail = image;
    }
    return self;
}

- (instancetype)initWithType:(MediaType)type data:(NSData *)data assetPath:(NSURL *)path
{
    if (self = [super init]) {
        self.type = type;
        self.data = data;
        self.fileLocation = path;
        UIImage *image = nil;
        switch (type) {
            case MediaTypeUnknown: {
                image = nil;
                self.typeName=KUnknownMedia;
            }
                break;
            case MediaTypeImage: {
                image = [UIImage imageWithData:data];
                self.typeName=KImageType;
            }
                break;
            case MediaTypeAudio: {
                image = nil;
                self.typeName=KAudioType;
            }
                break;
            case MediaTypeMovie: {
                self.typeName=KVideoType;
                image = [self loadImage];
            }
                break;
                
            default:
                break;
        }
        self.thumbNail = image;
    }
    return self;
}


- (UIImage*)loadImage {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.fileLocation options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
//    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    
    return [[UIImage alloc] initWithCGImage:imgRef];
    
}


@end
