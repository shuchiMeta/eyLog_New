//
//  EYLSummativeReportsCellTableViewCell.m
//  eyLog
//
//  Created by Shivank Agarwal on 22/02/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLSummativeReportsCellTableViewCell.h"

NSString *const kEYLSummativeReportsCellTableViewCellReuseId = @"kEYLSummativeReportsCellTableViewCellReuseId";

@implementation EYLSummativeReportsCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        _childName.frame = CGRectMake(5, 0, 180, 60);
        _nameOfReports.frame = CGRectMake(205, 0, 270, 60);
        _dateOfReports.frame =CGRectMake(550, 0, 200, 60);
       _status.frame =CGRectMake(760, 0, 220, 60);
    }else{
        _childName.frame = CGRectMake(5, 0, 180, 60);
        _nameOfReports.frame = CGRectMake(190, 0, 200, 60);
        _dateOfReports.frame =CGRectMake(435, 0, 180, 60);
        _status.frame =CGRectMake(600, 0, 120, 60);

    }
}

@end
