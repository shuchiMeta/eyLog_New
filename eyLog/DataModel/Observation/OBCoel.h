//
//  OBCoel.h
//  eyLog
//
//  Created by MDS_Abhijit on 27/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBCoel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *coelId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
