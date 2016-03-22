//
//  MediaObservationCell.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCell.h"

@protocol MDSGridViewCellDataSource <UICollectionViewDataSource>

@end

@protocol MDSGridViewCellDelegate <UICollectionViewDelegate>


@end

@protocol MediaObservationCellDatasource;

static NSString *CollectionViewCellIdentifier = @"mediaCellIdentifier";
@interface MediaObservationCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    BOOL nibMyCellloaded;
}

@property(nonatomic,strong) UICollectionView *collectionView;
extern NSString* const kMDSGridViewTableCellID;
@property (assign, nonatomic) id <MDSGridViewCellDelegate> delegate;
@property (assign, nonatomic) id <MDSGridViewCellDataSource> dataSource;
@property (strong, nonatomic) NSMutableArray * tableData;

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL isEditView;
@property (assign, nonatomic) BOOL isProcessingMedia;
@property (assign, nonatomic) BOOL isDraft;
@property (strong, nonatomic) NSNumber *childIdParam;
@property (strong, nonatomic) NSNumber *practitionerIdParam;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) UIViewController *controller;
@property (weak, nonatomic) id <MediaObservationCellDatasource> cellDatasource;
@property (strong, nonatomic) IBOutlet UIButton * addPlusClicked;
@property (strong, nonatomic) IBOutlet UILabel * addMediaLbl;

@property (strong, nonatomic) NSMutableArray * thumbnailsArray;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

-(void)loadObservationAttachment;
-(void)loadAddedMedia;
-(void)loadThumbnails;
-(void)hideSubViews;
@end
@protocol MediaObservationCellDatasource <NSObject>

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath forCustomCollectionViewCelll:(CustomCollectionViewCell *)cell;
-(void)notifyMediaDelete;
@end