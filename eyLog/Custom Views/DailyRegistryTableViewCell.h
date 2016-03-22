//
//  DailyRegistryTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 27/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyRegistryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnCame;

@property (strong, nonatomic) IBOutlet UIButton *btnLeftAt;
@property (strong, nonatomic) IBOutlet UIButton *btnAbsent;
@property (strong, nonatomic) IBOutlet UIButton *btnHoliday;
@property (strong, nonatomic) IBOutlet UIButton *btnSick;
@property (strong, nonatomic) IBOutlet UIButton *btnNoBooks;
@end
