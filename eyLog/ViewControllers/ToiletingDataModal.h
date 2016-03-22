//
//  ToiletingDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToiletingDataModal : NSObject

@property (nonatomic, strong) NSString *str_When;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSDate *date_When;
@property (nonatomic, assign) BOOL toileting_today_visible;
@property (nonatomic, assign) NSString *age_group_toileting_today;
@property(nonatomic,strong)NSString *age_group_toileting_today_start;
@property(nonatomic,strong)NSString *aage_group_toileting_today_end;
@end
