//
//  ChildrenPopupViewController.h
//  eyLog
//
//  Created by MDS_Abhijit on 19/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"

@protocol ChildrenPopupViewDelegate;

@interface ChildrenPopupViewController : UIViewController

@property (strong,nonatomic) WYPopoverController *childSelectionPopOver;
@property (strong, nonatomic) NSString *deviceUUID;
@property (weak, nonatomic) id <ChildrenPopupViewDelegate> delegate;
- (IBAction)doneButtonClicked:(id)sender;

@end
@protocol ChildrenPopupViewDelegate <NSObject>

-(void)doneBtnClicked:(id)sender forChildrenPopupViewController:(ChildrenPopupViewController *)viewController;

@end