//
//  GroupsViewCell.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 25/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "GroupsViewCell.h"

@implementation GroupsViewCell

- (void)awakeFromNib
{
    // Initialization code
    UIView *selectionView = [[UIView alloc] initWithFrame:self.frame];
    selectionView.backgroundColor = UIColorFromRGM(83, 84, 39);
    self.selectedBackgroundView = selectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }else{
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoCondensedR size:18]];
}

@end
