//
//  EYAge.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EYAge : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, assign) double ageIdentifier;
@property (nonatomic, assign) double ageStart;
@property (nonatomic, assign) double ageEnd;
@property (nonatomic, strong) NSString *ageDescription;
@property (nonatomic, strong) NSArray *statement;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
