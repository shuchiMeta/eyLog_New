//
//  RegistryFlagsTableViewCell.h
//  eyLog
//
//  Created by Shuchi on 24/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kRegistryFlagsTableViewCell;

@class RegistryFlagsTableViewCell;
@protocol RegistryFlagsTableViewCellDelegate <NSObject>

@required
-(void)clickedBtn:(UIButton *)btn forRegistryFlagsTableViewCell:(RegistryFlagsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface RegistryFlagsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btn_Absent;
@property (strong, nonatomic) IBOutlet UIButton *btn_Holiday;
@property (strong, nonatomic) IBOutlet UIButton *btn_Sick;
@property (strong, nonatomic) IBOutlet UIButton *btn_NoBooks;
@property (weak, nonatomic) id <RegistryFlagsTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath * indexPath;

-(IBAction)tableViewButtonAction:(UIButton *) button;
@end
