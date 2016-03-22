//
//  PractitionerPinAndRegistryViewController.m
//  eyLog
//
//  Created by Shuchi on 11/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "PractitionerPinAndRegistryViewController.h"
#import "Utils.h"
#import "NSString+SHAHashing.h"

#import "UIVIew+Toast.h"



@interface PractitionerPinAndRegistryViewController ()

@end

@implementation PractitionerPinAndRegistryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.btnStr isEqualToString:@"IN"])
    {
    self.enterPinLabel.text=@"To mark yourself IN enter your Pin";
    }
    else
    {
    self.enterPinLabel.text=@"To mark yourself OUT enter your Pin";
        
    }
   
    
    self.practionerName.text=self.practitioner.name;
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],self.practitioner.photo];
    self.practitionerIamge.contentMode = UIViewContentModeCenter;
    
    UIImage *practitionerImage=[UIImage imageWithContentsOfFile:imagePath];
    self.practitionerIamge.image = practitionerImage;
    if (self.practitionerIamge.bounds.size.width > practitionerImage.size.width && self.practitionerIamge.bounds.size.height > practitionerImage.size.height) {
        self.practitionerIamge.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if(self.practitionerIamge.bounds.size.width < practitionerImage.size.width)
    {
        
        self.practitionerIamge.contentMode = UIViewContentModeScaleAspectFit;
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okBtnAction:(id)sender {
    if(self.pinTextfield.text.length>0)
    {
    
        if([self.pinTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [[self.pinTextfield.text sha256] isEqualToString:self.practitioner.pin])
        {
            [self.delegate okBtnAction:sender AndPinEntered:self.pinTextfield.text andBtn:self.btnStr];

        }
        else
        {
               [self.view makeToast:@"Please check and re-enter your pin" duration:2.0f position:CSToastPositionCenter];
        //Please check and re-enter your pin
        }
       }
    else
    {
        
        [self.view makeToast:@"Please enter your pin" duration:2.0f position:CSToastPositionCenter];
        
    }
    
    
}

- (IBAction)cancelBtnAction:(id)sender {
    [self.delegate cancelBtnAction:sender];
    
    
}
@end
