//
//  WhatIateTodayTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kWhatIateTodayTableViewCell;

@class WhatIateTodayTableViewCell;
@protocol WhatIateTodayTableViewCellDelegate <NSObject>

@required
-(void)buttonAction :(UIButton *)button forWhatIateTodayIndexPath :(WhatIateTodayTableViewCell *)cell atIndexPath :(NSIndexPath *)indexPath;

@end

@interface WhatIateTodayTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btn_None;
@property (strong, nonatomic) IBOutlet UIButton *btn_Some;
@property (strong, nonatomic) IBOutlet UIButton *btn_Most;
@property (strong, nonatomic) IBOutlet UIButton *btn_All;
@property (strong, nonatomic) IBOutlet UIButton *btn_na;

@property (weak, nonatomic) id <WhatIateTodayTableViewCellDelegate> ateDelegate;
@property (strong, nonatomic) NSIndexPath *indexPath;


-(IBAction)TableViewButtonAction:(UIButton *)button;

@end
