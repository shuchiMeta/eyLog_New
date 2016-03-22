//
//  SleepTimesDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepTimesDataModal : NSObject

@property (strong, nonatomic) NSString *strFellAsleep;
@property (strong, nonatomic) NSString *strWokeUp;
@property (strong, nonatomic) NSDate *date_FellAsleep;
@property (strong, nonatomic) NSDate *date_WokeUp;
@property (strong, nonatomic) NSString *strSleptMins;
@property (nonatomic, assign) BOOL sleep_times_visible;
@property (nonatomic, assign) NSString *age_group_sleep_times;
@property(nonatomic,strong)NSString *age_group_sleep_times_start;
@property(nonatomic,strong)NSString *age_group_sleep_times_end;



@end
