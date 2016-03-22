//
//  audioGalleryCell.h
//  eyLog
//
//  Created by Qss on 10/29/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioGalleryCellDelegate <NSObject>

-(void)deleteMediaForIndexPath:(NSIndexPath *)indexPath;

@end

@interface AudioGalleryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *insideImage;
@property (weak, nonatomic) IBOutlet UIImageView *audioSelected;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (nonatomic, assign) id<AudioGalleryCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel * nameLbl;
@property (strong, nonatomic) IBOutlet UILabel * nameLbl2;
- (IBAction)deleteButtonClicked:(UIButton *)sender;
@end
