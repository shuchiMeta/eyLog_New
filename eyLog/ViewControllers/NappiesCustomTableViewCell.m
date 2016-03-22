//
//  NappiesCustomTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NappiesCustomTableViewCell.h"

NSString * const kNappiesCustomTableViewCell = @"kNappiesCustomTableViewCell";


@implementation NappiesCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonAction:(UIButton *)sender
{
    [self.delegate buttonAction:sender onNappiesCustomTableViewCell:self atIndexPath:self.indexPath];
}


@end
