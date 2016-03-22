//
//  INObservation.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface INObservation : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *labelObservation;
@property (nonatomic, strong) NSString *labelAnalysis;
@property (nonatomic, strong) NSString *labelNextSteps;
@property (nonatomic, strong) NSString *labelComment;
@property (nonatomic, strong) NSString *labelAssessment;
@property (nonatomic, strong) NSString *quickObservationTagLabel;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
