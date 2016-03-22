//
//  FrameworkBtnsCollectionViewCell.h
//  eyLog
//
//  Created by shuchi on 18/11/15.
//  Copyright © 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameworkBtnsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNotificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *seconNotificationLabel;

@end
