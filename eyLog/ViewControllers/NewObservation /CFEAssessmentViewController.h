//
//  CFEAssessmentViewController.h
//  eyLog
//
//  Created by shuchi on 03/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"WYPopoverController.h"
#import "CfePopUpTableControllerViewController.h"
@protocol cfePopOverDelegate <NSObject>
-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;
@end
@interface CFEAssessmentViewController : UIViewController<cfePopOverDelegate,CfePopUpTableDelegate>
@property (weak, nonatomic) IBOutlet UITableView *masterTableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *detailTableview;
@property(nonatomic,strong) NSMutableArray *selectedList;
@property(nonatomic,strong) NSMutableArray *cfeArray;
@property (nonatomic, strong) NSMutableArray *tempSelectedList;
@property (strong,nonatomic) WYPopoverController *cfeTablePopOver;
@property(strong,nonatomic) CfePopUpTableControllerViewController *cfePopUpTableViewController;
@property(nonatomic,assign) id<cfePopOverDelegate> delegate;
- (IBAction)showCurrentAssessment:(id)sender;
@property BOOL isFromNextSteps;
@property (weak, nonatomic) IBOutlet UIButton *showCurrentAssessment;
@property (weak, nonatomic) IBOutlet UIButton *done_btn;
- (IBAction)done_action:(id)sender;
@property (nonatomic,assign) BOOL showAssesment;
@property (nonatomic,assign) BOOL fromNextStep;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
- (IBAction)cancel_action:(id)sender;
- (IBAction)segmentedControlAction:(id)sender;
@property(nonatomic,assign) NSInteger cfeNotification;
-(void)filterDataBaseOnSegment;
@end
