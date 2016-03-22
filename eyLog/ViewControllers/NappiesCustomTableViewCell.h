//
//  NappiesCustomTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NappiesCustomTableViewCell;

extern NSString * const kNappiesCustomTableViewCell;

@protocol NappiesCustomTableViewCellDelegate

@required
- (void) buttonAction : (UIButton *) button onNappiesCustomTableViewCell : (NappiesCustomTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath;

@end


@interface NappiesCustomTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *btn_When;
@property (nonatomic, strong) IBOutlet UIButton *btn_Dry;
@property (nonatomic, strong) IBOutlet UIButton *btn_Wet;
@property (nonatomic, strong) IBOutlet UIButton *btn_Soiled;
@property (nonatomic, strong) IBOutlet UIButton *btn_NappyRash;
@property (nonatomic, strong) IBOutlet UIButton *btn_CreamApplied;
@property (nonatomic, strong) IBOutlet UIButton *btn_Add;
@property (nonatomic, strong) IBOutlet UIButton *btn_Delete;

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, weak) id <NappiesCustomTableViewCellDelegate> delegate;


- (IBAction)buttonAction:(UIButton *)sender;
@end
