//
//  MontessoryTableViewCell.h
//  eyLog
//
//  Created by Shobhit on 21/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MontessoryPopUpTableController.h"
#import "WYPopoverController.h"
#import "CustomButton.h"

@protocol montessoryPopUpTabel <NSObject>
//-(void)openTable;
-(void)openTable:(id)sender;
@end

@interface MontessoryTableViewCell : UITableViewCell
extern NSString* const montessoryTableCellId;

@property(strong,nonatomic) NSIndexPath *selectedMontessoryIndexPath;
@property(nonatomic,assign) id<montessoryPopUpTabel> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatement;
- (IBAction)btnPopBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *popOverButton;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet CustomButton *btnAssesment;

@property(assign,nonatomic) BOOL isRowSelected;
@end
