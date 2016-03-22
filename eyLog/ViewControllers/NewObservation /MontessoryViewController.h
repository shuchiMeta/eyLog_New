//
//  MontessoryViewController.h
//  eyLog
//
//  Created by Shobhit on 20/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MontessoryPopUpTableController.h"
#import "WYPopoverController.h"
#import "MontessoryTableViewCell.h"


@protocol montessoryPopOverDelegate <NSObject>
-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;
@end


@interface MontessoryViewController : UIViewController<assesmentPopoverDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic ,readwrite) IBOutlet UITableView *detailTableView;
@property(nonatomic,assign) id<montessoryPopOverDelegate> delegate;
@property (nonatomic, strong) NSArray *montessoriArray;

@property (nonatomic,assign) BOOL showAssesment;
@property (nonatomic,assign) BOOL fromNextStep;
@property(nonatomic,strong) NSMutableArray *selectedList;
@property (nonatomic, strong) NSMutableArray *tempSelectedList;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnDone:(id)sender;
- (IBAction)btnShowCurrentAssesment:(id)sender;
@property(strong,nonatomic) MontessoryPopUpTableController *montessoryPopUpTableViewController;
@property (strong,nonatomic) WYPopoverController *montessoryTablePopOver;
- (IBAction)btnSagmentSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sagmentController;

@property (weak, nonatomic) IBOutlet UIButton *showCurrentAssesment;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property(nonatomic,assign) NSInteger montessoryNotification;
-(void)filterDataBaseOnSegment;

@property (weak, nonatomic) IBOutlet UIButton *btnZeroToSix;
@end
