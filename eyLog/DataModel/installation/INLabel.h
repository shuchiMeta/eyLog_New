//
//  INLabel.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INObservation, INEcat;

@interface INLabel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) INObservation *observation;
@property (nonatomic, strong) INEcat *ecat;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
