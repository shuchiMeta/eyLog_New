//
//  LearningJourneyViewController.h
//  eyLog
//
//  Created by Shuchi on 31/12/15.
//  Copyright © 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments.h"


@interface LearningJourneyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) UIPopoverController *popover;
@property(assign,nonatomic)BOOL isComeFromNotification;
@property(strong,nonatomic)NSNumber *observationID;

@end
