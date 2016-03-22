//
//  CfeTableViewCell.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "CustomButton.h"

//@protocol montessoryPopUpTabel <NSObject>
////-(void)openTable;
//-(void)openTable:(id)sender;
//@end

@interface CfeTableViewCell : UITableViewCell
extern NSString* const CfeTableCellId;

@property(strong,nonatomic) NSIndexPath *selectedCfeIndexPath;
//@property(nonatomic,assign) id<montessoryPopUpTabel> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatement;
- (IBAction)AssesmentPopup:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet CustomButton *btnAssesment;

@property(assign,nonatomic) BOOL isRowSelected;
@end
