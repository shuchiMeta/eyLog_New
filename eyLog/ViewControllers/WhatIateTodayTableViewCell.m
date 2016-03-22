//
//  WhatIateTodayTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "WhatIateTodayTableViewCell.h"

NSString * const kWhatIateTodayTableViewCell = @"kWhatIateTodayTableViewCell";

@implementation WhatIateTodayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)TableViewButtonAction:(UIButton *)button
{
    [self.ateDelegate buttonAction:button forWhatIateTodayIndexPath:self atIndexPath:self.indexPath];
}

@end
