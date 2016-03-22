//
//  EyfsDetailTableViewCell.h
//  eyLog
//
//  Created by Qss on 11/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString* const eyfsDetailTableViewCellId;
@interface EyfsDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *statementTextView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *countDisplayLabel;
@property (assign, nonatomic) BOOL isSelected;
//- (IBAction)selectButtonAction:(id)sender;

@end
