//
//  DraftLIstCell.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftLIstCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UIImageView *childImageView;
@property (strong, nonatomic) IBOutlet UILabel *childAge;
@property (strong, nonatomic) IBOutlet UILabel *observationDate;
@property (strong, nonatomic) IBOutlet UILabel *observationTime;
@property (strong, nonatomic) IBOutlet UILabel *observationText;
@property (strong, nonatomic) IBOutlet UILabel *observationBy;
@property (strong, nonatomic) IBOutlet UILabel *observationType;


@end
