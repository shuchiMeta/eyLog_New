//
//  HomeViewController.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 24/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICallManager.h"
#import "AsyncImageView.h"


@interface HomeViewController : UICollectionViewController<NSURLSessionDelegate, NSURLSessionDataDelegate>
{
    APICallManager *manager;
}
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *HomeName;
- (IBAction)updateAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *groupSelectionButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (nonatomic, strong) UILabel *lblnurseryChainName;
-(void)loadNotificationsHistory :(Practitioners *)practitioner;

@end
