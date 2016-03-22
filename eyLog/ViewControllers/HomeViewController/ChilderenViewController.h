//
//  ChilderenViewController.h
//  eyLog
//
//  Created by Ankit Khetrapal on 15/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "ContainerViewController.h"
#import "WYPopoverController.h"
#import "NotificationsViewController.h"
@protocol ChildrenDelegate <NSObject>

- (void)sortCollectionAfterGroupDidSelected:(NSString *)group;

@end

@interface ChilderenViewController : UIViewController <SwipeViewDelegate, SwipeViewDataSource,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *practitionerName;
@property (strong, nonatomic) IBOutlet UILabel *practitionerGroupName;
@property (strong, nonatomic) IBOutlet UIView *profileSuperView;
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UILabel *selectedStatus;
@property (nonatomic, strong)  ContainerViewController *containerViewController;
@property (strong, nonatomic) IBOutlet UIButton *childButton;
@property (assign, nonatomic) id <ChildrenDelegate> delegate;
@property (nonatomic, strong) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIView *multipleChilderenLabellHolder;
@property (strong, nonatomic) IBOutlet UILabel *multipleChilderenLabel;
@property (strong, nonatomic) IBOutlet UIImageView *teacherImage;
@property (strong, nonatomic) IBOutlet UIButton *thumbnailButton;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) IBOutlet UIButton *groupButton;
@property (strong, nonatomic) IBOutlet UIButton *tableViewListButton;
@property (strong, nonatomic) IBOutlet SwipeView *fixedMenuView;
@property(nonatomic,assign)BOOL isComeFromNotificationToLoadNewObser;
@property(nonatomic,strong)NSNumber *diaryID;
@property(strong,nonatomic)WYPopoverController *controller;
@property(strong,nonatomic)NSMutableArray *arrayForNotification;
@property(strong,nonatomic)NotificationsViewController *notification;

-(void)loadData:(NSNumber *)observationID;



@property (strong, nonatomic) NSString *randNumber;
- (void)sortDataWithArray:(NSArray *)dataArray;
- (IBAction)practitionerProfileAction:(id)sender;
- (IBAction)listButtonClicked:(id)sender;
- (IBAction)togglePopover:(UIButton *)sender;
- (IBAction)thumbnailButtonClick:(id)sender;
- (IBAction)frameworkList:(id)sender;
- (IBAction)clearButtonAction:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)notificationBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *notification_Lbl;
@property (weak, nonatomic) IBOutlet UIImageView *messageHolderImage;

@property (weak, nonatomic) IBOutlet UIButton *notification_btn;
@end
