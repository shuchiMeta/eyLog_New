//
//  ListViewCell.m
//  eyLog
//
//  Created by Qss on 8/13/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ListViewCell.h"
#import "Theme.h"
#import "EYL_AppData.h"
#import "UIView+Toast.h"


@implementation ListViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.childName.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:16];
    self.childAgecategory.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:15];
}

- (IBAction)btnTransparentAction:(UIButton *) button
{
    [self.delegate btnActionatIndexPath:self.indexPath];
}
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.childImage.image = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnInOutAction:(UIButton *) button 
{
   
 [self.delegate setDateForButton:self.btnOUT atIndexPath:self.indexPath];

    
//    if (button.tag==302 && [self.btnIN.titleLabel.text isEqualToString:@"IN 00:00"])
//    {
//        [self makeToast:@"Please Enter Child IN time" duration:1.0f position:CSToastPositionBottom];
//        return;
//    }
    }

- (IBAction)registrystatusBtnAction:(id)sender {
}
@end
