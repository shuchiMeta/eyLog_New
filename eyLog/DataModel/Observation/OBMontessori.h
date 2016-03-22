//
//  OBMontessori.h
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OBMontessori : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *montessoriFrameworkLevelNumber;
@property (nonatomic, strong) NSNumber *montessoriFrameworkItemId;
@property (nonatomic, strong) NSNumber *levelTwoIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
