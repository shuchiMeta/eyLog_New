//
//  GroupsViewController.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 25/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KCellTypeFrame @"cellTypeFramework"
#define KCellTypeGroup @"cellTypeGroup"
#define KCellTypePractitioner @"cellTypePractitioner"
#define KCellTypeObservationBy @"cellTypeObservationBy"
#define KCellTypeTag @"cellTypeTag"


@protocol GroupSelectionDelegate <NSObject>
- (void)groupDidSelected:(NSString *)group withCellType:(NSString *)cellType;
-(void)btnAction:(id)sender;

@end
@interface GroupsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) id <GroupSelectionDelegate> delegate;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong,nonatomic) id dataSoruce;
@property (strong,nonatomic) NSString *cellType;
@property(assign,nonatomic)CGFloat height;
@property(assign,nonatomic)BOOL isInRequired;


@end
