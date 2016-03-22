//
//  LearningJourneyTableViewCell.h
//  eyLog
//
//  Created by Shuchi on 31/12/15.
//  Copyright © 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningJourneyModel.h"
#import "Assessment.h"

@protocol LearningJourneyDelegate <NSObject>

-(void)selectionOnFrameWorkCollection:(NSString *)frameworkSelection AndSelectionOnObservation:(NSString *)ObservationSelection andIndexpath:(NSIndexPath *)indexpath;
-(void)clickOnThumb:(UITableViewCell *)cell andModel:(LearningJourneyModel *)model;


@end

extern NSString* const LearningJourneyTableViewCellReuseID;

@interface LearningJourneyTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate>
{
//    NSMutableArray *selectedIndexPaths;
//    NSMutableArray *selectedIndexpathFramework;
  
  
    BOOL isFrameworkHeightCalculated;
    BOOL isObservationHeightCalculated;
    NSInteger width;
    NSMutableArray *observationTextCollectionArray;
    
    
}
-(void)dataSetup;
@property(strong,nonatomic)  NSMutableArray *observationCollectionArray;
@property(strong,nonatomic) NSMutableArray *frameworkcollectionArray;
@property(strong,nonatomic)  NSString *framework;
@property(strong,nonatomic) NSString *observation;
@property(strong,nonatomic)LearningJourneyModel *lJModel;
@property (nonatomic, assign) id<LearningJourneyDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UICollectionView *observationCollectioView;
@property (weak, nonatomic) IBOutlet UITextView *observationTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *frameworksCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *frameworkTextview;
@property(weak,nonatomic) CAGradientLayer *gradient;
@property(strong,nonatomic) NSIndexPath *indexpath;
@end
