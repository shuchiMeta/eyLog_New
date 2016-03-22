//
//  WhatIateTodayModal.h
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhatIateTodayModal : NSObject

@property (nonatomic, strong) NSString *strKey;
@property (strong, nonatomic) NSString *strName;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) BOOL what_i_ate_today_visible;
@property (nonatomic, assign) NSString *age_group_what_i_ate_today;
@property(nonatomic,strong)NSString *age_group_what_i_ate_today_start;
@property(nonatomic,strong)NSString *age_group_what_i_ate_today_end;

@property (nonatomic, assign) BOOL breakfast_visible;
@property (nonatomic, assign) BOOL snack_am_visible;
@property (nonatomic, assign) BOOL lunch_visible;
@property (nonatomic, assign) BOOL pudding_am_visible;
@property (nonatomic, assign) BOOL snack_pm_visible;
@property (nonatomic, assign) BOOL tea_visible;
@property (nonatomic, assign) BOOL pudding_pm_visible;

@end
