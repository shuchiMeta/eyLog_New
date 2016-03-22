//
//  ChilderenCell.m
//  eyLog
//
//  Created by Ankit Khetrapal on 15/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChilderenCell.h"
#import "Theme.h"
@implementation ChilderenCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.childName.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:19];
    self.childAgecategory.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:15];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
