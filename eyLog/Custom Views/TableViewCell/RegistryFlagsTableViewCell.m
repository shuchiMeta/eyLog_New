//
//  RegistryFlagsTableViewCell.m
//  eyLog
//
//  Created by Shuchi on 24/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "RegistryFlagsTableViewCell.h"

NSString * const kRegistryFlagsTableViewCell = @"kRegistryFlagsTableViewCell";

@implementation RegistryFlagsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)tableViewButtonAction:(UIButton *) button
{
    [self.delegate clickedBtn:button forRegistryFlagsTableViewCell:self atIndexPath:self.indexPath];
    
    
    
}

@end
