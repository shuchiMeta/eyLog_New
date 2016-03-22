//
//  RegistryCustomTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 17/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "RegistryCustomTableViewCell.h"

NSString * const kRegistryCustomTableViewCell = @"kRegistryCustomTableViewCell";

@implementation RegistryCustomTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)tableViewCellButtonAction:(UIButton *) button
{
    [self.delegate clickedBtn:button forRegistryCustomTableViewCell:self atIndexPath:self.indexPath];


   
}
@end
