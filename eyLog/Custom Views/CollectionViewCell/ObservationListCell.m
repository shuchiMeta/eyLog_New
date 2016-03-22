//
//  ObservationListCell.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ObservationListCell.h"

@implementation ObservationListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
             // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(editButtonAction:)];
    [self.textView addGestureRecognizer:singleFingerTap];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)editButtonAction:(id)sender
{
    [self.delegate editButtonClicked:self];
    
}
-(IBAction)addbuttonClicked:(id)sender
{
    [self.delegate addObservationButtonClicked:self];
}
@end
