//
//  EyfsDetailTableViewCell.m
//  eyLog
//
//  Created by Qss on 11/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EyfsDetailTableViewCell.h"
NSString* const eyfsDetailTableViewCellId = @"eyfsDetailTableViewCellId";
@implementation EyfsDetailTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.statementTextView.frame = CGRectMake(18, 7, self.frame.size.width - 110, self.frame.size.height - 14);
        self.countDisplayLabel.frame = CGRectMake(self.frame.size.width - 90, (self.frame.size.height-40)/2, 40, 40);
        self.selectButton.frame = CGRectMake(self.frame.size.width - 45, (self.frame.size.height-40)/2, 40, 40);
    } completion:^(BOOL finished) {
        self.statementTextView.frame = CGRectMake(18, 7, self.frame.size.width - 110, self.frame.size.height - 14);
        self.countDisplayLabel.frame = CGRectMake(self.frame.size.width - 90, (self.frame.size.height-40)/2, 40, 40);
        self.selectButton.frame = CGRectMake(self.frame.size.width - 45, (self.frame.size.height-40)/2, 40, 40);
    }];
    
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
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    }
    else
    {
        self.isSelected=YES;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
    }
}
 */

@end
