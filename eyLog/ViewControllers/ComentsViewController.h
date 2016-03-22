//
//  ComentsViewController.h
//  eyLog
//
//  Created by Shuchi on 11/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningJourneyModel.h"

@protocol CommentsDelegate <NSObject>
-(void)CloseButton:(UIButton*)btn andTag:(NSNumber *)num andCount:(NSNumber *)count;
-(void)reloadTable;


@end


@interface ComentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)LearningJourneyModel *model;
@property(strong,nonatomic)NSNumber *countComents;
@property(strong,nonatomic)NSNumber *tag;
@property(strong,nonatomic)NSMutableArray *comentsArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
- (IBAction)sendButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtn:(id)sender;
@property(nonatomic,assign) id<CommentsDelegate> delegate;
@property(assign,nonatomic)BOOL isComeFromObservationWithComments;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(strong,nonatomic)NSNumber *obserID;
@end
