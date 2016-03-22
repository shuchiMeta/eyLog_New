//
//  OBMedia.m
//  eyLog
//
//  Created by MDS_Abhijit on 12/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "OBMedia.h"
#import "ImageFile.h"
#import "VideoFile.h"
#import "AudioFile.h"

NSString *const kOBMediaImages = @"image";
NSString *const kOBMediaVideos = @"video";
NSString *const kOBMediaAudios = @"audio";
NSString *const kOBMediaURL = @"url";
NSString *const kOBMediaName = @"delurl";

@implementation OBMedia

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
  
    if(self && [dict isKindOfClass:[NSDictionary class]]) {

        NSObject *receivedOBImages = [dict objectForKey:kOBMediaImages];
        NSMutableArray *parsedOBImages = [NSMutableArray array];
        if ([receivedOBImages isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBImages) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    ImageFile * imageFile = [[ImageFile alloc]init];
                    imageFile.url = [item objectForKey:kOBMediaURL];
                    imageFile.name = [item objectForKey:kOBMediaName];
                    [parsedOBImages addObject:imageFile];
                }
            }
        } else if ([receivedOBImages isKindOfClass:[NSDictionary class]]) {
            ImageFile * imageFile = [[ImageFile alloc]init];
            imageFile.url = [((NSDictionary *)receivedOBImages) objectForKey:kOBMediaURL];
            imageFile.name = @"";
            [parsedOBImages addObject:imageFile];
        }
        self.images = [NSArray arrayWithArray:parsedOBImages];
        
        NSObject *receivedOBVideos = [dict objectForKey:kOBMediaVideos];
        NSMutableArray *parsedOBVideos = [NSMutableArray array];
        
        if ([receivedOBVideos isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBVideos) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    VideoFile * videoFile = [[VideoFile alloc]init];
                    videoFile.url = [item objectForKey:kOBMediaURL];
                    videoFile.name = [item objectForKey:kOBMediaName];
                    [parsedOBVideos addObject:videoFile];
                }
            }
        } else if ([receivedOBVideos isKindOfClass:[NSDictionary class]]) {
            VideoFile * videoFile = [[VideoFile alloc]init];
            videoFile.url = [((NSDictionary *)receivedOBVideos) objectForKey:kOBMediaURL];
            videoFile.name = @"";
            [parsedOBVideos addObject:videoFile];
        }
        self.videos = [NSArray arrayWithArray:parsedOBVideos];
        
        NSObject *receivedOBAudios = [dict objectForKey:kOBMediaAudios];
        NSMutableArray *parsedOBAudios = [NSMutableArray array];
        if ([receivedOBAudios isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedOBAudios) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    AudioFile * audioFile = [[AudioFile alloc]init];
                    audioFile.url = [item objectForKey:kOBMediaURL];
                    audioFile.name = [item objectForKey:kOBMediaName];
                    [parsedOBAudios addObject:audioFile];
                }
            }
        } else if ([receivedOBAudios isKindOfClass:[NSDictionary class]]) {
            AudioFile * audioFile = [[AudioFile alloc]init];
            audioFile.url = [((NSDictionary *)receivedOBAudios) objectForKey:kOBMediaURL];
            audioFile.name = @"";
            [parsedOBAudios addObject:audioFile];

        }
        self.audios = [NSArray arrayWithArray:parsedOBAudios];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.images forKey:kOBMediaImages];
    [mutableDict setValue:self.videos forKey:kOBMediaVideos];
    [mutableDict setValue:self.audios forKey:kOBMediaAudios];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.images = [aDecoder decodeObjectForKey:kOBMediaImages];
    self.videos = [aDecoder decodeObjectForKey:kOBMediaVideos];
    self.audios = [aDecoder decodeObjectForKey:kOBMediaAudios];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_images forKey:kOBMediaImages];
    [aCoder encodeObject:_videos forKey:kOBMediaVideos];
    [aCoder encodeObject:_audios forKey:kOBMediaAudios];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    OBMedia *copy = [[OBMedia alloc] init];
    
    if (copy) {
        copy.images = [self.images copyWithZone:zone];
        copy.videos = [self.videos copyWithZone:zone];
        copy.audios = [self.audios copyWithZone:zone];
    }
    
    return copy;
}


@end
