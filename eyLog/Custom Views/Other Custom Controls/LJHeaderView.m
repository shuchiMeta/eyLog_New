//
//  LJHeaderView.m
//  eyLog
//
//  Created by Shuchi on 05/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LJHeaderView.h"

@implementation LJHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
//    
    // Drawing code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
    }
    
    return self;
}

@end
