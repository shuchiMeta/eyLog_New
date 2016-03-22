//
//  EYAspect.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EYAspect : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *age;
@property (nonatomic, assign) double aspectIdentifier;
@property (nonatomic, strong) NSString *aspectDescription;
@property (nonatomic, strong) NSString *shortDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
