//
//  CustomToolBarButtons.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 26/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomToolBarButtons : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)addTarget:(id)target forSelector:(SEL) aSel;


@end
