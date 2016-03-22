//
//  Label.h
//  eyLog
//
//  Created by Qss on 11/5/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ASSESSMENT)
{
    assessment_level_developing=1,
    assessment_level_emerging,
    assessment_level_secure,
};

typedef NS_ENUM(NSInteger, ECAT) {
    ecat_level_one=1,
    ecat_level_two,
    ecat_level_three,
};

typedef NS_ENUM(NSInteger, OBSERVATION)
{
    label_analysis=1,
    label_assessment,
    label_comment,
    label_next_steps,
    label_observation,
    quick_observation_tag_label,
};

@interface Label : NSObject
@property(nonatomic,assign) OBSERVATION observation;
@property(nonatomic,assign) ECAT ecat;
@property(nonatomic,assign) ASSESSMENT assessment;
@end