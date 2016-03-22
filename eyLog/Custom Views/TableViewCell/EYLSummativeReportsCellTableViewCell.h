//
//  EYLSummativeReportsCellTableViewCell.h
//  eyLog
//
//  Created by Shivank Agarwal on 22/02/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kEYLSummativeReportsCellTableViewCellReuseId;

@interface EYLSummativeReportsCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UILabel *nameOfReports;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *dateOfReports;

@end
