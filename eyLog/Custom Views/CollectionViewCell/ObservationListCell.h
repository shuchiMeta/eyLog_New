//
//  ObservationListCell.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol observationListDelegate <NSObject>

-(void)editButtonClicked:(NSObject *)object;
-(void)addObservationButtonClicked:(id)sender;

@end

@interface ObservationListCell : UICollectionViewCell
@property (nonatomic,assign) id<observationListDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIButton * plusBtn;
@property (strong, nonatomic) IBOutlet UILabel  * plusLabel;


- (IBAction)editButtonAction:(id)sender;
-(IBAction)addbuttonClicked:(id)sender;

@end
