//
//  ListViewCell.h
//  eyLog
//
//  Created by Qss on 8/13/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageview.h"


@protocol ListViewCellDelegate <NSObject>

-(void) btnActionatIndexPath : (NSIndexPath *) indexPath;
- (void) setDateForButton :(UIButton *) button atIndexPath :(NSIndexPath *) indexPath;

@end

@interface ListViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet AsyncImageView *childImage;
@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UILabel *childAgecategory;
@property (strong, nonatomic) IBOutlet UILabel *childGroup;
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnTransparent;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIButton *btnIN;
@property (strong, nonatomic) IBOutlet UIButton *btnOUT;
@property (nonatomic, weak) id <ListViewCellDelegate>delegate;
- (IBAction)btnTransparentAction:(UIButton *) button;
- (IBAction)btnInOutAction:(UIButton *) button;

@property (weak, nonatomic) IBOutlet UIButton *registryStatusBtn;
- (IBAction)registrystatusBtnAction:(id)sender;



@end
