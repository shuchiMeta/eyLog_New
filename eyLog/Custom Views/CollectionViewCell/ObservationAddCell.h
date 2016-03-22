//
//  ObservationAddCell.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationAddCell.h"

@protocol observationDelegate <NSObject>

-(void)addObservationButtonClicked:(NSObject *)object;

@end
@interface ObservationAddCell : UICollectionViewCell
@property (nonatomic,assign) id<observationDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *addButtonLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

@property (strong,nonatomic) IBOutlet UIImageView *playImage;

@property (strong,nonatomic) NSIndexPath *indexPath;
-(IBAction)addbuttonClicked:(id)sender;
@end


