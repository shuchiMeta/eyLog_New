//
//  EcatDetailsTableViewCell.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatDetailsTableViewCell.h"
 NSString *const ecatTableViewCellId=@"ecatTableViewCellId";
@implementation EcatDetailsTableViewCell
@synthesize selectedEcatIndexpath;
- (void)awakeFromNib {
    // Initialization code
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
