//
//  GridViewController.h
//  eyLog
//
//  Created by Qss on 8/20/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "InOutSeparateManagementEntity.h"


@protocol GridViewControllerDelegate ;
@class ChilderenViewController;
@interface GridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
{
    NSMutableArray *selectedChildrenList;
    NSMutableArray *childrenList;
    NSString *imageURL;
    NSMutableArray *tempChildrenArray;
    NSMutableDictionary *sortedChildrenDictionary;
}
-(void)refreshChildren;
@property(assign,nonatomic)BOOL isComeFromNotification;
-(void)updateData;
-(void)updateChildData;
@property (weak, nonatomic) IBOutlet UIButton *refreshChilData;
- (IBAction)refreshChildData:(id)sender;
-(void)saveAllChildrenPhotosAtBackground;

-(void)closeAlert;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewController;
@property (strong,nonatomic) NSArray *childrenListForTableView;
@property (weak, nonatomic) ChilderenViewController *parentVC;
@property (assign, nonatomic) BOOL isPopUp;
@property (weak, nonatomic) id <GridViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *lastCameIN;
@property (nonatomic, strong) NSString *lastLeftAT;

@property (nonatomic, retain) UIImage *captureImage;
@property (assign,nonatomic)BOOL isRefreshedFromPullToRefresh;


@property (nonatomic, strong) NSMutableArray *array_childIDs;
-(void)getRegistryINOUT;
@end
@protocol GridViewControllerDelegate <NSObject>

-(void)didselectItemAtIndexPath:(NSIndexPath *)indexPath;




@end