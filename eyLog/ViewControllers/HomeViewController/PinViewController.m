//
//  PinViewController.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 17/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "PinViewController.h"
#import "Utils.h"
#import "NSString+SHAHashing.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "UIView+Toast.h"
@interface PinViewController () <UITextFieldDelegate ,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
- (IBAction)okButtonClicked:(UIButton *)sender;


@end

@implementation PinViewController
NSString* const kPopOverSegueID = @"kPopOverSegueID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.prectitioner.name;
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],self.prectitioner.photo];
    self.imageView.contentMode = UIViewContentModeCenter;

    UIImage *practitionerImage=[UIImage imageWithContentsOfFile:imagePath];
    self.imageView.image = practitionerImage;
    if (self.imageView.bounds.size.width > practitionerImage.size.width && self.imageView.bounds.size.height > practitionerImage.size.height) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

        if(self.imageView.bounds.size.width < practitionerImage.size.width)
    {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.btnOkay.layer.cornerRadius=5.0f;
    self.btnOkay.layer.masksToBounds=YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonClicked:(UIButton *)sender {
    [self.textField resignFirstResponder];
    [self proceedWithText:self.textField.text];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self proceedWithText:textField.text];
    return YES;
}

- (void)proceedWithText:(NSString *)text {
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [[text sha256] isEqualToString:self.prectitioner.pin]) {
        [self.delegate proceedWithPrectitioner:self.prectitioner];

    }else{
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Please check and re-enter your PIN";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//        {
//            hud.yOffset=-250;
//        }
//        else
//        {
//            hud.yOffset=-350;
//        }
//        [hud hide:YES afterDelay:1];
        [self.view.window makeToast:@"Please check and re-enter your PIN" duration:1.0f position:CSToastPositionTop];

    }
}

@end
