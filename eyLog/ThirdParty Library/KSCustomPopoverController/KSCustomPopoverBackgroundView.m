//
//  KSPopoverBackgorundView.m
//
//  Created by Krzysztof Scianski on 12.02.2012.
//  Copyright (c) 2012 Krzysztof Scianski. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "KSCustomPopoverBackgroundView.h"

// Predefined arrow image width and height
#define ARROW_WIDTH 0
#define ARROW_HEIGHT 0


// Predefined content insets
#define TOP_CONTENT_INSET 00
#define LEFT_CONTENT_INSET 00
#define BOTTOM_CONTENT_INSET 00
#define RIGHT_CONTENT_INSET 00

#pragma mark - Private interface

@interface KSCustomPopoverBackgroundView ()
{    
    UIImage *_topArrowImage;
    UIImage *_leftArrowImage;
    UIImage *_rightArrowImage;
    UIImage *_bottomArrowImage;
}

@end

#pragma mark - Implementation

@implementation KSCustomPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset, arrowDirection = _arrowDirection, popoverBackgroundImageView = _popoverBackgroundImageView, arrowImageView = _arrowImageView;

#pragma mark - Overriden class methods

// The width of the arrow triangle at its base.
+ (CGFloat)arrowBase 
{
    return ARROW_WIDTH;
}

// The height of the arrow (measured in points) from its base to its tip.
+ (CGFloat)arrowHeight
{
    return ARROW_HEIGHT;
}

// The insets for the content portion of the popover.
+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(TOP_CONTENT_INSET, LEFT_CONTENT_INSET, BOTTOM_CONTENT_INSET, RIGHT_CONTENT_INSET);
}

+ (BOOL)wantsDefaultContentAppearance {
    return NO;
}
#pragma mark - Custom setters for updating layout

// Whenever arrow changes direction or position layout subviews will be called in order to update arrow and backgorund frames

-(void) setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

-(void) setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame 
{    
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

#pragma mark - Layout subviews
//
//-(void)layoutSubviews
//{    
//    [super layoutSubviews];
//    
//    CGFloat popoverImageOriginX = 0;
//    CGFloat popoverImageOriginY = 0;
//    
//    CGFloat popoverImageWidth = self.bounds.size.width;
//    CGFloat popoverImageHeight = self.bounds.size.height;
//    
//    CGFloat arrowImageOriginX = 0;
//    CGFloat arrowImageOriginY = 0;
//    
//    CGFloat arrowImageWidth = ARROW_WIDTH;
//    CGFloat arrowImageHeight = ARROW_HEIGHT;
//    
//    // Radius value you used to make rounded corners in your popover background image
//    CGFloat cornerRadius = 9;
//    
//    switch (self.arrowDirection) {
//            
//        case UIPopoverArrowDirectionUp:
//            
//            popoverImageOriginY = ARROW_HEIGHT - 2;
//            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT;
//            
//            // Calculating arrow x position using arrow offset, arrow width and popover width
//            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset);
//            
//            // If arrow image exceeds rounded corner arrow image x postion is adjusted 
//            arrowImageOriginX = MIN(arrowImageOriginX, self.bounds.size.width - ARROW_WIDTH - cornerRadius);
//            arrowImageOriginX = MAX(arrowImageOriginX, cornerRadius);
//            
//            // Setting arrow image for current arrow direction
//            
//            break; 
//            
//        case UIPopoverArrowDirectionDown:
//            
//            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT + 2;
//            
//            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset);
//            
//            arrowImageOriginX = MIN(arrowImageOriginX, self.bounds.size.width - ARROW_WIDTH - cornerRadius);
//            arrowImageOriginX = MAX(arrowImageOriginX, cornerRadius);
//            
//            arrowImageOriginY = popoverImageHeight - 2;
//            
//            break;
//            
//        case UIPopoverArrowDirectionLeft:
//            
//            popoverImageOriginX = ARROW_HEIGHT - 2;
//            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT;
//            
//            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);
//            
//            arrowImageOriginY = MIN(arrowImageOriginY, self.bounds.size.height - ARROW_WIDTH - cornerRadius);
//            arrowImageOriginY = MAX(arrowImageOriginY, cornerRadius);
//            
//            arrowImageWidth = ARROW_HEIGHT;
//            arrowImageHeight = ARROW_WIDTH;
//            
//            break;
//            
//        case UIPopoverArrowDirectionRight:
//            
//            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT + 2;
//            
//            arrowImageOriginX = popoverImageWidth - 2;
//            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);
//            
//            arrowImageOriginY = MIN(arrowImageOriginY, self.bounds.size.height - ARROW_WIDTH - cornerRadius);
//            arrowImageOriginY = MAX(arrowImageOriginY, cornerRadius);
//            
//            arrowImageWidth = ARROW_HEIGHT;
//            arrowImageHeight = ARROW_WIDTH;
//            
//            break;
//            
//        default:
//            
//            // For popovers without arrows (Thanks Martin!)
//            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT + 2;
//            
//            break;
//    }
//    
//    self.popoverBackgroundImageView.frame = CGRectMake(popoverImageOriginX, popoverImageOriginY, popoverImageWidth, popoverImageHeight);
//    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
//}

@end
