//
//  AudioRecoderViewController.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 10/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioRecoderDelegate <NSObject>

@optional
- (void)didFinishRecordingAudioToURL:(NSURL *)recordingURL;

@end

@interface AudioRecoderViewController : UIViewController
extern NSString* const kAudioRecoderStoryBoardID;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) id <AudioRecoderDelegate> delegate;
@property (nonatomic, assign) BOOL isGallery;

-(IBAction)doneButtonClicked:(id)sender;
-(IBAction)startButtonClicked:(UIBarButtonItem *)sender;
//-(IBAction)pauseButtonClicked:(UIBarButtonItem *)sender;
-(IBAction)cancelButtonClicked:(id)sender;

@end
