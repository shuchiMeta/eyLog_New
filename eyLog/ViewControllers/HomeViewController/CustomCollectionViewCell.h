//
//  CustomCollectionViewCell.h
//  eyLog
//
//  Created by Qss on 9/23/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCustomCollectionViewReuseId;

@protocol EYLogDeleteMediaDelegate <NSObject>

-(void) removeMediaObjectAtIndexPath:(NSIndexPath *) indexPath;

@end

@interface CustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id<EYLogDeleteMediaDelegate> delegate;

- (IBAction)deleteMedia:(UIButton *)sender;

@end
