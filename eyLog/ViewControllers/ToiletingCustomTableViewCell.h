//
//  ToiletingCustomTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToiletingCustomTableViewCell;

extern NSString * const kToiletingCustomTableViewCell;
//extern NSString * const kObservationsDailyDiaryCellTableViewCell
@protocol ToiletingCustomTableViewCellDelegate

- (void) buttonAction :(UIButton *) button forToiletingCustomTableViewCell : (ToiletingCustomTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath;

@end

@interface ToiletingCustomTableViewCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UIButton *btn_When;
@property (nonatomic, retain) IBOutlet UIButton *btn_WentOnThePotty;
@property (nonatomic, retain) IBOutlet UIButton *btn_WentOnTheToilet;
@property (nonatomic, retain) IBOutlet UIButton *btn_ITried;
@property (nonatomic, retain) IBOutlet UIButton *btn_Add;
@property (nonatomic, retain) IBOutlet UIButton *btn_Delete;

@property (nonatomic, weak) id <ToiletingCustomTableViewCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;


- (IBAction)buttonAction:(UIButton *) button;


@end
