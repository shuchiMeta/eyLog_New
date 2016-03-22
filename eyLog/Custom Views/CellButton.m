//
//  CellButton.m
//  TradeStone
//
//  Created by Lakshaya Chhabra on 20/03/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CellButton.h"

@implementation CellButton

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


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.tag == 10) {
        self.layer.cornerRadius = 15;
    }
}

- (void)dealloc {
    self.indexPath = nil;
}

@end
