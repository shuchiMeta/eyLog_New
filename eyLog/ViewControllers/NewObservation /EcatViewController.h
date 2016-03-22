//
//  EcatViewController.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 11/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"


@protocol ecatPopOverDelegate <NSObject>
-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;
@end

@interface EcatViewController : UIViewController
@property(strong,nonatomic) id<ecatPopOverDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnShowCurrentAssesment;
- (IBAction)showCurrent:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btndone;
- (IBAction)actionBtnCancel:(id)sender;
- (IBAction)actionBtnDone:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray *ecatArray;
@property(nonatomic,strong) NSMutableArray *selectedList;
@property(nonatomic,strong) NSNumber* selectedLevel;
@property (strong, nonatomic) NSMutableArray * tempArray;
@property(nonatomic,assign) NSInteger ecatNotification;
- (IBAction)segmentValuechanged:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ecatSegment;

@end
