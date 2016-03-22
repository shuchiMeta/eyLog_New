//
//  COELTableViewCell.m
//  eyLog
//
//  Created by Qss on 11/10/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "COELTableViewCell.h"

@implementation COELTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
- (IBAction)selectButtonAction:(id)sender {
    if(self.isSelected)
    {
        self.isSelected=NO;
        [self.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    }
    else
    {
        self.isSelected=YES;
        [self.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
    }
}
*/

@end
