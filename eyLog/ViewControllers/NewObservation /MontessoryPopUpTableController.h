//
//  MontessoryPopUpTableController.h
//  eyLog
//
//  Created by Shobhit on 23/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MontessoriAssesmentDataBase.h"

@protocol assesmentPopoverDelegate <NSObject>
-(void)selectedAssesment:(MontessoriAssesmentDataBase *)database;

@end
@interface MontessoryPopUpTableController : UIViewController
{
    NSMutableArray *popUpArray;
}
@property (strong, nonatomic) NSArray * assesmentArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign) id<assesmentPopoverDelegate> delegate;
@end
