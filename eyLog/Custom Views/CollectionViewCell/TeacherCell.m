//
//  TeacherCell.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 24/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "TeacherCell.h"
#import "Theme.h"

@implementation TeacherCell

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
    self.titleLabel.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:19];
    self.detaillabel.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:15];
    self.loginButton.layer.cornerRadius = 5.0f;
    @try
    {
        [self.passwordTextField setBackground:[[UIImage imageNamed:@"bg_TextField_Password"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch]];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

- (IBAction)inAction:(id)sender {
    if([self.outBtn.currentTitle isEqualToString:@"OUT 00 : 00"]&&[self.inBtn.currentTitle isEqualToString:@"IN 00 : 00"])
    {
      [self.delegate btnActionAtIndexpath:self.indepath andBtn:sender];
        
    }
    else
    {
    
    if(![self.outBtn.currentTitle isEqualToString:@"OUT 00 : 00"])
    {
    [self.delegate btnActionAtIndexpath:self.indepath andBtn:sender];
    }
    else
    {
     [self outAction:self.outBtn];
    }
    }
    
    
}

- (IBAction)outAction:(id)sender {
    
    if([self.outBtn.currentTitle isEqualToString:@"OUT 00 : 00"]&&[self.inBtn.currentTitle isEqualToString:@"IN 00 : 00"])
    {
        [self inAction:self.inBtn];
        
    }
    else
    {
        
    
    if(![self.inBtn.currentTitle isEqualToString:@"IN 00 : 00"]&&[self.outBtn.currentTitle isEqualToString:@"OUT 00 : 00"])
    {
    [self.delegate btnActionAtIndexpath:self.indepath andBtn:sender];
    }
    else{
        [self inAction:self.inBtn];
        
    }
    }

}
@end
