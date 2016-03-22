//
//  SleepTimesTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 19/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SleepTimesTableViewCell;


@protocol SleepTimesTableViewCellDelegate

@required

- (void) clickedButton : (UIButton *) btn forSleepTimesTableViewCell : (SleepTimesTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath;

@end

extern NSString * const kSleepTimesTableViewCell;

@interface SleepTimesTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btn_FellAsleep;
@property (strong, nonatomic) IBOutlet UIButton *btn_WokeUp;
@property (strong, nonatomic) IBOutlet UIButton *btn_SleeptMins;
@property (strong, nonatomic)IBOutlet UIButton *btn_AddRow;
@property (strong, nonatomic)IBOutlet UIButton *btn_DeleteRow;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id <SleepTimesTableViewCellDelegate> delegate;

-(IBAction)sleepTimeButtonAction:(UIButton *) button;

@end
