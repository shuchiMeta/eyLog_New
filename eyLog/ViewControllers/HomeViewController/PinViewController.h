//
//  PinViewController.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 17/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Practitioners.h"

@protocol PinViewControllerDelegate <NSObject>

- (void)proceedWithPrectitioner:(Practitioners *)practitioner;

@end

@interface PinViewController : UIViewController
extern NSString* const kPopOverSegueID;

@property (weak, nonatomic) IBOutlet UIButton *btnOkay;

@property (weak, nonatomic) id <PinViewControllerDelegate> delegate;
@property (strong, nonatomic) Practitioners *prectitioner;
@end
