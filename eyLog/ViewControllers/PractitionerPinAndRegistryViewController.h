//
//  PractitionerPinAndRegistryViewController.h
//  eyLog
//
//  Created by Shuchi on 11/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Practitioners.h"

@protocol PractitionerPinAndRegistryDelegate<NSObject>

-(void)okBtnAction:(UIButton*)button AndPinEntered:(NSString *)pinStr andBtn:(NSString *)btnStr;

-(void)cancelBtnAction:(UIButton*)button ;

@end

@interface PractitionerPinAndRegistryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *practionerName;

@property (weak, nonatomic) IBOutlet UIImageView *practitionerIamge;
@property (weak, nonatomic) IBOutlet UILabel *enterPinLabel;
@property (weak, nonatomic) IBOutlet UITextField *pinTextfield;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property(nonatomic,strong)id<PractitionerPinAndRegistryDelegate>delegate;
@property (strong, nonatomic) Practitioners *practitioner;
@property(strong,nonatomic)NSString *btnStr;

- (IBAction)okBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;


@end
