//
//  Medai.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 10/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypeUnknown = 0,
    MediaTypeImage,
    MediaTypeAudio,
    MediaTypeMovie,
};

@interface Media : NSObject

@property (strong, nonatomic) NSURL *fileLocation;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) UIImage *thumbNail;
@property (assign, nonatomic) MediaType type;
@property (strong,nonatomic) NSString *typeName;

- (instancetype)initWithType:(MediaType)type data:(NSData *)data path:(NSString *)path;
- (instancetype)initWithType:(MediaType)type data:(NSData *)data assetPath:(NSURL *)path;

@end
