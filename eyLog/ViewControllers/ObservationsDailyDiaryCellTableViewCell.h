//
//  ObservationsDailyDiaryCellTableViewCell.h
//  eyLog
//
//  Created by shuchi on 05/11/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kObservationsDailyDiaryCellTableViewCell;


@interface ObservationsDailyDiaryCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *observation_text;
@property (weak, nonatomic) IBOutlet UILabel *area_accessed;
@end
