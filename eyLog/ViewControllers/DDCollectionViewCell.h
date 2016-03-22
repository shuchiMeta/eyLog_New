//
//  DDCollectionViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 16/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kDDCollectionViewCellReuseId;

@interface DDCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;

@end
