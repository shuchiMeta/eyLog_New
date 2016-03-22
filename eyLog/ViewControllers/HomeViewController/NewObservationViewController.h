//
//  NewObservationViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "ObservationAddCell.h"
#import "WYPopoverController.h"
#import "Theme.h"
#import "EYFSAssessmentViewController.h"
#import "NewObservation.h"
#import "DraftListViewController.h"
#import "OBMedia.h"
#import "ObservationViewController.h"
#import "Child.h"
#import "CellButton.h"
#import "EYLNewObservation.h"
#import "CFEAssessmentViewController.h"
#import "GroupsViewController.h"


@class ChilderenViewController;

@protocol DatePickerDelegate <NSObject>
-(void)setTextDate:(id)sender;
@end

@interface NewObservationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,observationDelegate,WYPopoverControllerDelegate,LibraryActionsDelegate , EYLogNewObservationViewControllerDelegate,cfePopOverDelegate,GroupSelectionDelegate>
{
    UIButton *btn;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UIButton *InvolvementButton;
@property (strong, nonatomic) IBOutlet UILabel *involvementNotificationLabel;
@property (strong, nonatomic) IBOutlet UIButton *wellBeingButton;
@property (strong, nonatomic) IBOutlet UILabel *wellBeingNotificationLabel;
@property (strong, nonatomic) IBOutlet UIButton *coelButton;
@property (strong, nonatomic) IBOutlet UILabel *coelNotificationLabel;
@property (strong, nonatomic) IBOutlet UIButton *ecatButton;
@property (strong, nonatomic) IBOutlet UILabel *ecatNotificationLabel;
@property (strong, nonatomic) IBOutlet UIButton *mantessori;
@property (strong, nonatomic) IBOutlet UILabel *mantessoriNotificationLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectOptionButton;
@property (assign, nonatomic) BOOL fromUpload;
@property (weak, nonatomic) ChilderenViewController *parentVC;

@property(strong,nonatomic)NSNumber  *observerID;
@property(assign,nonatomic)BOOL isProcessingMedia;

@property (assign, nonatomic) BOOL isEditingAllowed;
@property (assign, nonatomic) BOOL isEditView;
@property (assign, nonatomic) BOOL isUploadQueue;
@property (strong, nonatomic) NSNumber *childIdParam;
@property (strong, nonatomic) NSNumber *practitionerIdParam;
@property (strong, nonatomic) NSNumber *observationIdParam;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) OBMedia *media;
@property (strong,nonatomic) ObservationViewController *observationViewController;
@property (strong, nonatomic) NSString *originalDeviceUUID;
@property (weak, nonatomic) IBOutlet UISwitch *spontaneousObservation;

@property (strong, nonatomic) Child * childEntity;
@property(nonatomic,weak)id<DatePickerDelegate>delegate;
@property (strong, nonatomic) IBOutlet CellButton *plusBtn;
@property (strong, nonatomic) IBOutlet UILabel *plusLabel;
@property (strong, nonatomic) EYLNewObservation * eylNewObservation;

@property (strong,nonatomic) GroupsViewController *tagsViewContoller;
@property (strong,nonatomic) WYPopoverController *tagPopOver;
@property(assign,nonatomic) BOOL isComeFromNotification;
@property(strong,nonatomic)Child *notificationChild;




- (IBAction)MediaButtonClicked:(id)sender;
- (IBAction)btnMontessotiClick:(id)sender;

- (IBAction)selectOptionAction:(id)sender;
-(IBAction)coelAction:(id)sender;
-(IBAction)involvementAndWelBeingAction:(id)sender;
-(void)saveObservation:(NSString *)mode;
//-(void)uploadObservations;
- (IBAction)spontaneousObservationValueChanged:(UISwitch *)sender;
- (IBAction)btnEcat:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *frameworkBtnsCollectionView;

@end
