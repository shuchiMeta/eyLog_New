//
//  ChildView.h
//  eyLog
//
//  Created by Qss on 9/18/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummativeInfoViewer : UIView
{
    SummativeInfoViewer *containerView;
}


@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UILabel *childGroup;
@property (strong, nonatomic) IBOutlet UIImageView *childImage;
@property (strong, nonatomic) IBOutlet UILabel *childNotificationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *practionerImage;
@property (strong, nonatomic) IBOutlet UILabel *practitionerName;
@property (strong, nonatomic) IBOutlet UILabel *practitionerGroup;


@end
