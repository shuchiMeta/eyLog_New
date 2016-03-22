 //
//  MediaObservationCell.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MediaObservationCell.h"
#import "CustomCollectionViewCell.h"
#import "APICallManager.h"
#import "NewObservationAttachment.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ShowImageViewController.h"
#import "Reachability.h"
#import "AudioViewController.h"
#import "NewObservationViewController.h"
#import "EYLNewObservation.h"
#import "EYLMedia.h"
#import "EYLConstant.h"
#import "DocumentFileHandler.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface MediaObservationCell() <EYLogDeleteMediaDelegate, UIAlertViewDelegate>
{
    BOOL isEditable;
    BOOL isVideo;
}
@end

@implementation MediaObservationCell
{
    NSMutableArray *observation;
    NSArray *thumbnailNames;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.thumbnailsArray = [NSMutableArray array];
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.collectionView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.itemSize =CGSizeMake(90,90);
        //layout.itemSize = CGSizeMake(190, 190);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, 320, 220) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = YES;
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kCustomCollectionViewReuseId];

        self.collectionView.backgroundColor=[UIColor clearColor];

        [self loadObservationAttachment];
    }


}

-(void)loadObservationAttachment
{
    if (self.isEditView) {
        observation = [[NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate childContext] withPractitionerId:self.practitionerIdParam withChildId:self.childIdParam withObservationId:self.deviceUUID] mutableCopy];
                if (self.isDraft) {
                    [self loadThumbnails];
        }
    }
    else
    {
        self.childIdParam = [APICallManager sharedNetworkSingleton].cacheChild.childId;
        self.practitionerIdParam = [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        //        observation=[NewObservationAttachment fetchObservationInContext:[AppDelegate context] withPractitionerId:self.practitionerIdParam withChildId:self.childIdParam];
    }
    if (self.isDraft) {
        if([Reachability reachabilityForInternetConnection].isReachable)
        {
            isEditable = NO;
        }
        else
        {
            isEditable = YES;
        }
    }


    [self.collectionView reloadData];
}

-(void)loadAddedMedia
{
    NSLog(@"UUID in loadAddedMedia : %@", self.deviceUUID);
    observation=[[NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate childContext] withPractitionerId:self.practitionerIdParam withChildId:self.childIdParam withObservationId:self.deviceUUID] mutableCopy];
    [self.collectionView reloadData];
}
-(void)loadThumbnails{
    NSError *error;
    NSString *thumbnailPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[Utils getDraftMediaImages],self.deviceUUID]];
    thumbnailNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:thumbnailPath error:&error];
}
-(void)setThumbnailsArray:(NSMutableArray *)thumbnailsArray{

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];

    NSArray *array = [thumbnailsArray filteredArrayUsingPredicate:predicate];

    _thumbnailsArray = [NSMutableArray arrayWithArray:array];

    _tableData = [_thumbnailsArray mutableCopy];
    [self.collectionView reloadData];
}
-(void)hideSubViews{
    if (self.tableData.count > 0){
        self.collectionView.hidden = NO;
        self.addPlusClicked.hidden = YES;
        self.addMediaLbl.hidden = YES;
    }
    else{
        if(_isProcessingMedia)
        {
            [self.addPlusClicked setBackgroundImage:[UIImage imageNamed:@"ic_processing_grey"] forState:UIControlStateNormal];
            
            
            self.addMediaLbl.text=@"Processing Media ... ";
        }

        
        self.collectionView.hidden = YES;
        self.addPlusClicked.hidden = NO;
        self.addMediaLbl.hidden = NO;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self hideSubViews];

    if (self.tableData.count >0) {
        if(![[self.tableData firstObject] isKindOfClass:[EYLNewObservationAttachment class]])
        {
            return self.tableData.count;
        }
            
        
        return self.tableData.count +1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCollectionViewReuseId forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    switch (indexPath.row) {
        case 0:
        {
            
            cell.imageView.image = [UIImage imageNamed:@"icon_add"];
            cell.imageView.contentMode = UIViewContentModeCenter;
            [cell.playButton setHidden:YES];
            [cell.deleteButton setHidden:YES];
            
        }
            break;
        default:{
           
            EYLNewObservationAttachment * eylNewObservationAttachment = [self.tableData objectAtIndex:indexPath.row -1];
            EYLMedia * eylMedia = eylNewObservationAttachment.eylMedia;
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            if (eylMedia.image) {
              cell.imageView.image = eylMedia.image;
            }else{
                cell.imageView.image=[UIImage imageNamed:@"eylog_Logo"];
            }

            [cell.deleteButton setHidden:NO];
            if ([eylMedia.attachmentType isEqualToString:kUTTypeImageType]) {
                cell.playButton.hidden = YES;
            }
            else{
                cell.playButton.hidden = NO;
            }
        }
    
            break;
    }
    return cell;
}

-(UIImage *)thumbnailFromMovieAtURL:(NSString *)url
{
    UIImage *image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@.png",[url stringByDeletingPathExtension]]];

    return image;
}
- (void)collectionViewDidRefreshed:(UIRefreshControl *)sender
{

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IndexPath %@",indexPath);

    
   
    switch (indexPath.row) {
        case 0:
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
            NSArray * array = [self.tableData filteredArrayUsingPredicate:predicate];
            if (array.count > 19) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
                [self.window makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
                return;
            }
            CustomCollectionViewCell * cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [self.cellDatasource didSelectItemAtIndexPath:indexPath forCustomCollectionViewCelll:cell];

        }
            break;
        default:{
            EYLNewObservationAttachment * eylNewObservationAttachment = [self.tableData objectAtIndex:indexPath.row -1];


            NSString * filePath;

            // not aware of how it handles other attachments than images so not changing anything on the older code for other attachments
            if([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeImageType] || [eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeVideoType]
               || [eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeAudioType])
            {
                // to check wheter we are editing this in new observation mode or draft list mode
                if(eylNewObservationAttachment.attachmentPath.length > 0)
                    filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:eylNewObservationAttachment.attachmentPath] stringByAppendingPathComponent:eylNewObservationAttachment.attachmentName];
                else
                    filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:eylNewObservationAttachment.tempPath] stringByAppendingPathComponent:eylNewObservationAttachment.tempName];
            }
            else
            {
                filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:eylNewObservationAttachment.attachmentPath] stringByAppendingPathComponent:eylNewObservationAttachment.attachmentName];
            }



            BOOL fileExist = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
            if (!fileExist)
            {
                if (![[APICallManager sharedNetworkSingleton] isNetworkReachable])
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];

                    return;
                }

                if (eylNewObservationAttachment.fileURL.length > 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
                        hud.labelText = @"Downloading Media...";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                            NSURL *url = [NSURL URLWithString:[eylNewObservationAttachment.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            NSURLRequest *request = [NSURLRequest requestWithURL:url];
                            NSURLResponse *response = nil;
                            NSError *error = nil;
                            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                            NSLog(@"%@",filePath);
                            [data writeToFile:filePath atomically:YES];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [hud hide:YES];
                                if([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeImageType])
                                {
                                    ShowImageViewController *imageViewController = [[ShowImageViewController alloc] init];
                                    imageViewController.image = [UIImage imageWithContentsOfFile:filePath];
                                    [self.controller presentViewController:imageViewController animated:YES completion:nil];
                                }
                                else if ([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeVideoType])
                                {
                                    MPMoviePlayerViewController *moviePlayer;
                                    moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]];
                                    [self performSelectorOnMainThread:@selector(presentMovieVC:) withObject:moviePlayer waitUntilDone:YES];
                                }
                                else if ([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeAudioType])
                                {
                                    AudioViewController *audioViewController = [[AudioViewController alloc] init];
                                    audioViewController.url = [NSURL URLWithString:filePath];
                                    [self.controller presentViewController:audioViewController animated:YES completion:nil];
                                }

                            });

                        });
                    });
                    return;
                }
                else{
                    filePath = [[DocumentFileHandler setDocumentDirectoryforPath:eylNewObservationAttachment.attachmentPath] stringByAppendingPathComponent:eylNewObservationAttachment.attachmentName];
                }
            }

            if([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeImageType])
            {
                ShowImageViewController *imageViewController = [[ShowImageViewController alloc] init];
                imageViewController.image = [UIImage imageWithContentsOfFile:filePath];
                [self.controller presentViewController:imageViewController animated:YES completion:nil];
            }
            else if ([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeVideoType])
            {
                MPMoviePlayerViewController *moviePlayer;
                moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]];
                [self performSelectorOnMainThread:@selector(presentMovieVC:) withObject:moviePlayer waitUntilDone:YES];
            }
            else if ([eylNewObservationAttachment.attachmentType isEqualToString:kUTTypeAudioType])
            {
                AudioViewController *audioViewController = [[AudioViewController alloc] init];
                audioViewController.url = [NSURL URLWithString:filePath];
                [self.controller presentViewController:audioViewController animated:YES completion:nil];
            }
        }
            break;
    }
    
}

- (void)presentVC:(UIViewController *)vc {
    [self.controller presentViewController:vc animated:YES completion:nil];
}

- (void)presentMovieVC:(MPMoviePlayerViewController *)vc {
    [self.controller presentMoviePlayerViewControllerAnimated:vc];
}

-(void) removeMediaObjectAtIndexPath:(NSIndexPath *) indexPath
{
    UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:@"Warning!" message:@"Do you want to delete media?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.tag = indexPath.row -1;
    [alert show];
}

-(void)closeAlert
{
    UIViewController *topVC = self.controller.navigationController;
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
       
}

#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //testing is pending for this issue but stil comiting for now
    if (buttonIndex == 0) {
        EYLNewObservationAttachment * attachment = [self.thumbnailsArray objectAtIndex:alertView.tag];
        if (attachment.newwObservationAttachment) {
            attachment.isDeleted = YES;
            // To fix the image not getting deleted bug
            [self.thumbnailsArray removeObject:attachment];
        }
        else{
            attachment.isDeleted = YES;
            [self.thumbnailsArray removeObject:attachment];
        }

        [self.tableData removeObject:attachment];
        [self.collectionView reloadData];

        // Inform NewObservationViewController that a media is delted so that it updates this automatically
        [self.cellDatasource notifyMediaDelete];

    }
}

@end
