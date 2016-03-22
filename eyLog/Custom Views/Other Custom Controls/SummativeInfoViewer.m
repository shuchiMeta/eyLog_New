//
//  ChildView.m
//  eyLog
//
//  Created by Qss on 9/18/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "SummativeInfoViewer.h"
#import "Utils.h"
#import "NewObservationViewController.h"
#import "AppDelegate.h"
#import "DateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DraftLIstCell.h"
AppDelegate *appDelegate;
BOOL firstTime;
@implementation SummativeInfoViewer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
[self.childImage setBackgroundColor:[UIColor whiteColor]]; 
    if([Utils getChildImage]==nil)
    {
        self.childImage.image=[UIImage imageNamed:@"eylog_Logo"];
                  //[containerView.childImage setBackgroundColor:[UIColor blackColor]];
        
        //im,g
    }
    else
    {
        self.childImage.image=[Utils getChildImage];
    }

    self.childName.text=[Utils getChildName];
    self.childGroup.text=[Utils getChildGroupName];
    
    self.practionerImage.image=[Utils getPractionerImgae];
    self.practitionerName.text=[Utils getPractionerName];
    
    self.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];
    self.childGroup.font = [UIFont systemFontOfSize:10.0f];
    
    self.practitionerGroup.text =[Utils getPractitionerGroupName];
    

    self.childNotificationLabel.layer.cornerRadius=9.0f;
    self.childImage.layer.cornerRadius=14.0f;
    self.childImage.clipsToBounds = YES;
    
    [self.practionerImage.layer setCornerRadius:14.0f];
    self.practionerImage.clipsToBounds=YES;
}


@end
