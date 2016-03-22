//
//  InvolvementTableViewCell.h
//  eyLog
//
//  Created by Qss on 11/10/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvolvementTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *selectionButton;
@property (strong, nonatomic) IBOutlet UITextView *involvementText;
@property (assign, nonatomic) BOOL isSelected;

@end
