//
//  ShowImageViewController.h
//  eyLog
//
//  Created by Qss on 10/9/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIImage *image;
-(IBAction)doneAction:(id)sender;
@end
