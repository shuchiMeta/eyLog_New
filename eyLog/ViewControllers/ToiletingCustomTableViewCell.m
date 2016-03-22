//
//  ToiletingCustomTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ToiletingCustomTableViewCell.h"

NSString * const kToiletingCustomTableViewCell = @"kToiletingCustomTableViewCell";
//NSString * const kObservationsDailyDiaryCellTableViewCell = @"kObservationsDailyDiaryCellTableViewCell";
@implementation ToiletingCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonAction:(UIButton *) button
{
    [self.delegate buttonAction:button forToiletingCustomTableViewCell:self atIndexPath:self.indexPath];
}

@end
