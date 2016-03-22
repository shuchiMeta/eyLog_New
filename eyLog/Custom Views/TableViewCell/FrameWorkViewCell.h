//
//  FrameWorkViewCell.h
//  eyLog
//
//  Created by Qss on 9/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameWorkViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *frameworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end
