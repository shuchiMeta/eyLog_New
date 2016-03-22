//
//  CfePopUpTableControllerViewController.h
//  eyLog
//
//  Created by shuchi on 09/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CfeAssesmentDataBase.h"

@protocol CfePopUpTableDelegate <NSObject>
-(void)selectedAssesment:(CfeAssesmentDataBase *)database;
@end

@interface CfePopUpTableControllerViewController : UIViewController
{
 NSMutableArray *popUpArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray * assesmentArray;
@property(nonatomic,assign) id<CfePopUpTableDelegate> delegate;
@end
