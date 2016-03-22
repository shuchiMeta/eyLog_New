//
//  RegistryCustomTableViewHeader.h
//  eyLog
//
//  Created by Arpan Dixit on 18/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistryCustomTableViewHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *cameInLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *notBookedLbl;
@property (weak, nonatomic) IBOutlet UILabel *sickLbl;
@property (weak, nonatomic) IBOutlet UILabel *holidayLabl;
@property (weak, nonatomic) IBOutlet UILabel *absentLbl;
@end
