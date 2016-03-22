//
//  CustomBarButton_InOut.h
//  eyLog
//
//  Created by Arpan Dixit on 11/08/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomBarButton_InOutDelegate <NSObject>

- (void) setTimeForButtonWithTag : (NSInteger) tag andValue :(NSString *) value;

-(void) updateContext;


@end


@interface CustomBarButton_InOut : UIView

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIButton *btnInOutAction;
@property (nonatomic) NSUInteger btnTag;


@property (nonatomic, weak) id<CustomBarButton_InOutDelegate> childDelegate;


-(IBAction)btnInOutAction:(UIButton *)sender;
@end
