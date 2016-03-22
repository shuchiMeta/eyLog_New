//
//  CustomToolBarButtons.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 26/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CustomToolBarButtons.h"
#import <objc/runtime.h>

@interface CustomToolBarButtons ()  {
    SEL aSelector;
}

@property (strong, nonatomic) id target;

@end

@implementation CustomToolBarButtons

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
    [self.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoCondensedL size:13]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)addTarget:(id)target forSelector:(SEL) aSel {
    self.target = target;
    aSelector = aSel;
}

- (IBAction)buttonClicked:(id)sender {
    Method m = class_getInstanceMethod([self.target class], aSelector);
    const char *encoding = method_getTypeEncoding(m);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:encoding];
    NSUInteger allCount = [signature numberOfArguments];
    NSUInteger parameterCount = allCount - 2;
    switch (parameterCount)
    {
        case 1:
            [self.target performSelectorOnMainThread:aSelector withObject:self waitUntilDone:YES];
            break;
        default:
            [self.target performSelectorOnMainThread:aSelector withObject:nil waitUntilDone:YES];
            break;
    }
}

@end
