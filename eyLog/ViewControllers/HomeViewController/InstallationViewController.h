//
//  InstallationViewController.h
//  eyLog
//
//  Created by MDS_Abhijit on 08/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *installButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

- (IBAction)installButtonClicked:(id)sender;
- (IBAction)CancelButtonClicked:(id)sender;


@end
