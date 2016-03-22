//
//  OBEyfs.h
//
//  Created by Qss  on 11/5/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Age.h"
#import "Aspect.h"

@interface OBEyfs : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSNumber *frameworkItemId;
@property (nonatomic, strong) NSNumber *assessmentLevel;
@property (nonatomic, strong) NSNumber *ageIdentifier;
@property(nonatomic,strong)Age *age;
@property(nonatomic,strong)Aspect *aspect;


// *statement =

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
