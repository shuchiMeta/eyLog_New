//
//  Setting.m
//  eyLog
//
//  Created by Qss on 10/29/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Setting.h"

@implementation Setting

- (id)initWithSettingDictionary:(NSDictionary *)dict
{
    if (self)
    {
        self.childInvolvement=[[dict objectForKey:@"child_involvement"]integerValue];
        self.childMinder=[[dict objectForKey:@"childminder"]integerValue];
        self.dailyDiary=[[dict objectForKey:@"daily_diary"]integerValue];
        self.ecat=[[dict objectForKey:@"ecat"]integerValue];
        self.elg=[[dict objectForKey:@"elg"]integerValue];
        self.montessori=[[dict objectForKey:@"montessori"]integerValue];
        self.nurseryObservationPolicy=[[dict objectForKey:@"nursery_observation_policy"]integerValue];
        self.observationDateFormat=[[dict objectForKey:@"observation_date_format"]integerValue];
        self.montesoori_enable_Zero_to_three=[[dict objectForKey:@"montessori_enable_zero_to_three"]integerValue];
        self.frameworkType=[dict objectForKey:@"framework_type"];
        self.coel=[[dict objectForKey:@"coel"] integerValue];
    }
    return self;
}
@end
