//
//  OBMedia.h
//  eyLog
//
//  Created by MDS_Abhijit on 12/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBMedia : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *videos;
@property (strong, nonatomic) NSArray *audios;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
