//
//  NotificationsViewController.h
//  eyLog
//
//  Created by Shuchi on 02/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTableViewCell.h"
#import "NotificationModel.h"

@protocol NotificationCellDelegate <NSObject>

-(void)rowSelectedForCell:(NotificationTableViewCell *)cell andID:(NSNumber *)id_num andModel:(NotificationModel *)model andArray:(NSMutableArray *)array;
-(void)launchMore:(NSNumber *)pageNumber;


@end

@interface NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)id<NotificationCellDelegate>delegate;
@property(assign,nonatomic)BOOL noMoreData;

@end
