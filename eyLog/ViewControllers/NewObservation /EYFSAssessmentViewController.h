//
//  EYFSAssessmentViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationViewController.h"
@protocol eyfsPopOverDelegate <NSObject>
-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;
@end


@interface EYFSAssessmentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property(nonatomic,assign) id<eyfsPopOverDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) NSMutableArray *selectedList;
@property (nonatomic, strong) NSMutableArray *selectedAgeBandAssessmentList;
@property (strong, nonatomic, readonly) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tmpSelectedArray;
@property BOOL isFromNextSteps;
- (IBAction)doneAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)showCurrentAssessment:(id)sender;
-(void)reloadTableData;

@end
