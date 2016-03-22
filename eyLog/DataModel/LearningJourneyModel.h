//
//  LearningJourneyModel.h
//  eyLog
//
//  Created by Shuchi on 06/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBEyfs.h"
#import "OBEcat.h"
#import "OBMedia.h"
#import "OBMontessori.h"
#import "OBCoel.h"

@interface LearningJourneyModel : NSObject
@property(strong,nonatomic)NSNumber *ageNumber;
@property(strong,nonatomic)NSString *analysis;
@property(strong,nonatomic)NSNumber *child_id;
@property(strong,nonatomic)NSString *comments;
@property(strong,nonatomic)NSString *date_time;
@property(strong,nonatomic)NSMutableArray *eyfs;
@property(strong,nonatomic)NSMutableArray *ecat;
@property(strong,nonatomic)OBMedia *media;
@property(strong,nonatomic)NSString *next_steps;
@property(strong,nonatomic)NSMutableArray *montessory;
@property(strong,nonatomic)NSString *observation_by;
@property(strong,nonatomic)NSNumber *observation_id;
@property(strong,nonatomic)NSString *observation_text;
@property(strong,nonatomic)NSNumber *observer_id;
@property(strong,nonatomic)NSNumber *quick_observation_tag;
@property(strong,nonatomic)NSNumber *scale_involvement;
@property(strong,nonatomic)NSNumber *scale_well_being;
@property(strong,nonatomic)NSString *unique_tablet_OID;
@property(strong,nonatomic)NSMutableArray *coel;
@property(strong,nonatomic)NSNumber *commentsCount;

@end
