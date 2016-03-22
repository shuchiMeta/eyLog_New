//
//  GroupsPopoverView.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 25/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "GroupsPopoverView.h"
#import "Theme.h"
@implementation GroupsPopoverView

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
    [self.groupsButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoCondensedR size:20]];
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
