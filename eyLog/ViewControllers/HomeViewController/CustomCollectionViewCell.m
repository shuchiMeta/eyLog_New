//
//  CustomCollectionViewCell.m
//  eyLog
//
//  Created by Qss on 9/23/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CustomCollectionViewCell.h"

NSString * const kCustomCollectionViewReuseId = @"kCustomCollectionViewReuseId";

@implementation CustomCollectionViewCell

- (IBAction)deleteMedia:(UIButton *)sender {
    
    [self.delegate removeMediaObjectAtIndexPath:self.indexPath];
    
}
-(void)layoutSubviews{
    [self bringSubviewToFront:self.deleteButton];
}
@end
