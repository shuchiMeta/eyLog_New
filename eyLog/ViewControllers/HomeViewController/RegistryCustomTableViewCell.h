//
//  RegistryCustomTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 17/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//
// Sumit Sharma

#import <UIKit/UIKit.h>

extern NSString * const kRegistryCustomTableViewCell;

@class RegistryCustomTableViewCell;
@protocol RegistryCustomTableViewCellDelegate <NSObject>

@required
-(void)clickedBtn:(UIButton *)btn forRegistryCustomTableViewCell:(RegistryCustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@interface RegistryCustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btn_CameIn;
@property (strong, nonatomic) IBOutlet UIButton *btn_LeftAt;
@property (strong, nonatomic) IBOutlet UIButton *btn_Absent;
@property (strong, nonatomic) IBOutlet UIButton *btn_Holiday;
@property (strong, nonatomic) IBOutlet UIButton *btn_Sick;
@property (strong, nonatomic) IBOutlet UIButton *btn_NoBooks;
@property (strong, nonatomic) IBOutlet UIButton *btn_Add;
@property (strong, nonatomic) IBOutlet UIButton *btn_Delete;

@property (weak, nonatomic) id <RegistryCustomTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath * indexPath;

-(IBAction)tableViewCellButtonAction:(UIButton *) button;
@end
