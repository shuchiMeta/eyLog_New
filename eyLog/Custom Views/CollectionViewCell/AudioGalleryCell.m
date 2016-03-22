//
//  audioGalleryCell.m
//  eyLog
//
//  Created by Qss on 10/29/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "AudioGalleryCell.h"

@implementation AudioGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    [self.delegate deleteMediaForIndexPath:self.indexPath];
}

@end
