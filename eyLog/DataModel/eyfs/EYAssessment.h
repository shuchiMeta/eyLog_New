//
//  EYAssessment.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EYAssessment : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double levelId;
@property (nonatomic, assign) double ageStart;
@property (nonatomic, assign) double levelValue;
@property (nonatomic, strong) NSString *levelDescription;
@property (nonatomic, assign) double ageEnd;
@property (nonatomic, strong) id color;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
