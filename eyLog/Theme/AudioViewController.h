//
//  AudioViewController.h
//  eyLog
//
//  Created by MDS_Abhijit on 18/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UISlider *volumeControl;
@property (strong, nonatomic) IBOutlet UISlider *seekbar;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

- (IBAction)adjustVolume:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)stopAudio:(id)sender;
- (IBAction)doneButtonClicked:(UIButton *)sender;


@end
