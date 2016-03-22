//
//  SleepTimesTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "SleepTimesTableViewCell.h"

NSString * const kSleepTimesTableViewCell = @"kSleepTimesTableViewCell";

@implementation SleepTimesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)sleepTimeButtonAction:(UIButton *) button
{
    [self.delegate clickedButton:button forSleepTimesTableViewCell:self atIndexPath:self.indexPath];
}
@end
