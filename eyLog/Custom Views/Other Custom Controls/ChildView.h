//
//  ChildView.h
//  eyLog
//
//  Created by Qss on 9/18/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChilderenViewController;
@class DailyDiaryViewController;

@protocol ChildrenSelectionPopoverDelegate <NSObject>

-(void)showDateTimePicker:(id)sender toolbar:(UIToolbar *)toolbar;
-(void)showPopOverChildrenSelection:(id)sender;
- (void)setDate:(NSDate *)date;
@end

@interface ChildView : UIView
{
//    UIDatePicker *datePicker ;
    UIToolbar *toolbar;
    ChildView *containerView;

}

@property (nonatomic, assign) id<ChildrenSelectionPopoverDelegate> delegate;

@property (nonatomic,retain) UIPopoverController *categoryPickerPopover;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (strong, nonatomic) IBOutlet UILabel     *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel     *practitionerGroup;
@property (weak,   nonatomic) IBOutlet UILabel     *childName;
@property (weak,   nonatomic) IBOutlet UILabel     *childGroup;
@property (strong, nonatomic) IBOutlet UIImageView *practionerImage;
@property (strong, nonatomic) IBOutlet UILabel     *practitionerName;
@property (strong, nonatomic) IBOutlet UIImageView *childImage;
@property (strong, nonatomic) IBOutlet UILabel     *childNotificationLabel;
@property (weak,   nonatomic) IBOutlet UIButton    *childImageButton;
@property (weak,   nonatomic) IBOutlet UIButton    *childDropDown;
@property (weak,   nonatomic) IBOutlet UILabel     *dateLabel;
@property (weak,   nonatomic) IBOutlet UILabel     *lbl_MenuOption;
@property(nonatomic,assign)BOOL isComeFromDailyDiary;
@property(nonatomic,strong)NSString *dateStringSavedForDD;
@property  (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic, strong) NSDate *lastPickerDate;

- (IBAction)childImageClicked:(id)sender;
- (IBAction)DatePick:(id)sender;
//- (void) clearText;

- (void) setLabelMenu :(NSString *) name;

-(void) resetDate :(NSNotification *) notification;
@end
