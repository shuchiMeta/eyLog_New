//
//  INPractitioners.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INPhotos;

@interface INPractitioners : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) INPhotos *photos;
@property (nonatomic, assign) double totalResult;
@property (nonatomic, assign) double nurseryId;
@property (nonatomic, strong) NSArray *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
