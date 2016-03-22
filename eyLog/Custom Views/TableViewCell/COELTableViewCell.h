//
//  COELTableViewCell.h
//  eyLog
//
//  Created by Qss on 11/10/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COELTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CoelLabel;
@property (strong, nonatomic) IBOutlet UILabel *assessmentNumber;
@property (strong, nonatomic) IBOutlet UIButton *selectionButton;
@property (assign, nonatomic) BOOL selection_State;


@end
