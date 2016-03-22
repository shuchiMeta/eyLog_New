//
//  MontessoryTableViewCell.m
//  eyLog
//
//  Created by Shobhit on 21/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryTableViewCell.h"

#import "MontessoryViewController.h"
#import "MontessoryPopUpTableController.h"

NSString* const montessoryTableCellId = @"montessoryTableCellId";



@implementation MontessoryTableViewCell
@synthesize selectedMontessoryIndexPath;

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
       // self.lblStatement.frame = CGRectMake(10, 7, self.frame.size.width - 180, self.frame.size.height - 14);
     //   self.lblNumber.frame = CGRectMake(self.lblStatement.frame.origin.x+self.lblStatement.frame.size.width+4, (self.frame.size.height-40)/2, 40, 40);
        //self.btnAssesment.frame=CGRectMake(self.lblNumber.frame.origin.x+self.lblNumber.frame.size.width+4, (self.frame.size.height-40)/2, 75,30);
       // self.btnSelectedButton.frame = CGRectMake(self.btnAssesment.frame.origin.x+self.btnAssesment.frame.size.width+4, (self.frame.size.height-40)/2, 35, 35);
            } completion:^(BOOL finished) {
      //  self.lblStatement.frame = CGRectMake(10, 7, self.frame.size.width - 180, self.frame.size.height - 14);
      //  self.lblNumber.frame = CGRectMake(self.lblStatement.frame.origin.x+self.lblStatement.frame.size.width+4, (self.frame.size.height-40)/2, 40, 40);
     //   self.btnAssesment.frame=CGRectMake(self.lblNumber.frame.origin.x+self.lblNumber.frame.size.width+4, (self.frame.size.height-40)/2, 80,30);
       // self.btnSelectedButton.frame = CGRectMake(self.btnAssesment.frame.origin.x+self.btnAssesment.frame.size.width+4, (self.frame.size.height-40)/2, 35, 35);
                
    }];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnPopBtn:(id)sender {
     NSLog(@"btnCLicked");
    //[self.delegate openTable];
   [self.delegate openTable:sender];

}


@end
