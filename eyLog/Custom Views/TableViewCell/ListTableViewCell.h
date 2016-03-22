//
//  ListTableViewCell.h
//  eyLog
//
//  Created by Qss on 9/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *practitionerName;
@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic) IBOutlet UIImageView *childImage;
@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UILabel *childAgecategory;
@property (strong, nonatomic) IBOutlet UIView *customView;
@end
