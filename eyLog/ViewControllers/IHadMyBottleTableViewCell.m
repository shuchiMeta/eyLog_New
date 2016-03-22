//
//  IHadMyBottleTableViewCell.m
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "IHadMyBottleTableViewCell.h"

NSString * const kIHadMyBottleTableViewCell = @"kIHadMyBottleTableViewCell";

@implementation IHadMyBottleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 return [self.delegate textFieldShouldBeginEditing:textField andCell:self atIndexPath:self.indexPath];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textfieldDidBeginEditing:textField andCell:self atIndexPath:self.indexPath];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate textfieldDidEndEditing:textField andCell:self atIndexPath:self.indexPath];
    
}
- (IBAction)buttonAction:(UIButton *)sender
{
    [self.delegate btnAction:sender forTableVIewCell:self atIndexPath:self.indexPath];
}
@end
