//
//  OBEcat.h
//  eyLog
//
//  Created by Arpan Dixit on 14/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBEcat : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *ecatFrameworkLevelNumber;
@property (nonatomic, strong) NSNumber *ecatFrameworkItemId;
@property (nonatomic, strong) NSNumber *levelTwoIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
