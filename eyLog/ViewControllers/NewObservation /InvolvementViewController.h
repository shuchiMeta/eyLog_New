//
//  InvolvementViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYLNewObservation.h"
@protocol involvementPopoverDelegate <NSObject>
-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;
@end

@interface InvolvementViewController : UIViewController
@property(nonatomic,assign) id<involvementPopoverDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedInvolvementIndex;
@property (nonatomic, assign) NSInteger selectedWellBeingIndex;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) EYLNewObservation * eylNewObservation;
- (IBAction)doneAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@end
