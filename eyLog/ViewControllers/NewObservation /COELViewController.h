//
//  COELViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol coelPopoverDelegate <NSObject>

-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;

@end
@interface COELViewController : UIViewController

@property(nonatomic,assign) id<coelPopoverDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedList;
@property (assign, nonatomic) BOOL isEditView;
@property (assign, nonatomic) BOOL isUploadQueue;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

-(IBAction)doneAction:(id)sender;
-(IBAction)closeAction:(id)sender;

@end
