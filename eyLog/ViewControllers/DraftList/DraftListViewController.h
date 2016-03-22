//
//  DraftListViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EYLogNewObservationViewControllerDelegate <NSObject>

-(void)refreshMediaCell;

@end

@interface DraftListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isUploadQueue;
@property (strong, nonatomic) id<EYLogNewObservationViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *observationButton;
@property (weak, nonatomic) IBOutlet UIButton *TypeButton;

- (IBAction)practitionerProfileAction:(id)sender;
- (IBAction)observationByAction:(id)sender;

@end
