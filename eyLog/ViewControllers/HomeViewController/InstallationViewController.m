//
//  InstallationViewController.m
//  eyLog
//
//  Created by MDS_Abhijit on 08/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "InstallationViewController.h"
#import "Utils.h"
#import "APICallManager.h"

//#define key @"RQSC-4186-NAMK-6164"
//#define  pass @"WoodLodgeM"

@interface InstallationViewController ()

@end

@implementation InstallationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.installButton.layer.cornerRadius=10.0f;
    [self.installButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.installButton setBackgroundColor:darkYellowButtonColor];
    
    self.CancelButton.layer.cornerRadius=10.0f;
    [self.CancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.CancelButton setBackgroundColor:darkYellowButtonColor];
    
    //self.passwordTextField.text=pass;
    //self.keyTextField.text=key;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)installButtonClicked:(id)sender
{
      NSString *encoded = [[self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
     [[APICallManager sharedNetworkSingleton] getServerUrlWithKey:self.keyTextField.text andPassword:encoded fromController:self];
    
}


- (IBAction)CancelButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes" ,nil];
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 if(buttonIndex==1)
 {
     exit(0);
 }
    
}
@end
