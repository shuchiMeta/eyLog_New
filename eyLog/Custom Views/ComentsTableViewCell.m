//
//  ComentsTableViewCell.m
//  eyLog
//
//  Created by Shuchi on 11/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ComentsTableViewCell.h"
NSString *const ComentsTableViewCellReuseID=@"ComentsTableViewCellReuseID";

@implementation ComentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)edit_btn:(id)sender {
    [self.delegate editButton:sender andCell:self];
    
}
- (IBAction)delete_btn:(id)sender {
    [self.delegate deleteButton:sender andCell:self];
    
}
@end
