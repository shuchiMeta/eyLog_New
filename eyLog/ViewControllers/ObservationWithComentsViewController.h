//
//  ObservationWithComentsViewController.h
//  eyLog
//
//  Created by Shuchi on 29/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObservationWithComentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UICollectionView *observationCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *observationTextview;
@property (weak, nonatomic) IBOutlet UICollectionView *frameworkCollection;
@property (weak, nonatomic) IBOutlet UITextView *frameworkTextview;


@property(strong,nonatomic)  NSString *framework;
@property(strong,nonatomic) NSString *observation;

@property(strong,nonatomic)  NSMutableArray *observationCollectionArray;
@property(strong,nonatomic) NSMutableArray *frameworkcollectionArray;
@property(strong,nonatomic)NSNumber *observationID;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
