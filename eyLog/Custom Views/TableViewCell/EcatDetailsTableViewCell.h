//
//  EcatDetailsTableViewCell.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcatDetailsTableViewCell : UITableViewCell
extern NSString *const ecatTableViewCellId;
@property(strong,nonatomic) NSIndexPath *selectedEcatIndexpath;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnSelected;
@property(assign,nonatomic) BOOL isRowSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblAssesment;

@end
