//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioViewController.h"


@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property NSString *audioFile;
@property NSString *videoFile;
@property(strong,nonatomic)MPMoviePlayerController *theMoviPlayer;
@property(strong,nonatomic)AVAudioPlayer *audioPlayer;
@property(strong,nonatomic)AudioViewController *audioViewController;


@end
