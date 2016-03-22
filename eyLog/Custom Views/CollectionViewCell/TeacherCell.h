//
//  TeacherCell.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 24/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol TeacherCellDelegate <NSObject>

-(void)btnActionAtIndexpath:(NSIndexPath *)indexPath andBtn:(UIButton *)btn;
    

@end
@interface TeacherCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet AsyncImageView *imageView;
@property(strong,nonatomic)id<TeacherCellDelegate>delegate;
@property(strong,nonatomic)NSIndexPath *indepath;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detaillabel;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *inBtn;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
- (IBAction)inAction:(id)sender;
- (IBAction)outAction:(id)sender;
@end
