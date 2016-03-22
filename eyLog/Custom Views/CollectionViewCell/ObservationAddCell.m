//
//  ObservationAddCell.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ObservationAddCell.h"

@implementation ObservationAddCell
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"sticky"]];
        // Initialization code
    }
    return self;
}

-(IBAction)addbuttonClicked:(id)sender
{
    [delegate addObservationButtonClicked:self];
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
