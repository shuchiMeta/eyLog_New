//
//  OBCfe.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBCfe : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *cfeFrameworkLevelNumber;
@property (nonatomic, strong) NSNumber *cfeFrameworkItemId;
@property (nonatomic, strong) NSNumber *levelTwoIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end