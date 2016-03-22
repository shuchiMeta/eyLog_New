//
//  AudioViewController.m
//  eyLog
//
//  Created by MDS_Abhijit on 18/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stopButton.hidden = YES;
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:self.url
                    error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
        self.startTime.text = @"00:00";
        
        int totalSeconds = self.audioPlayer.duration;
        
        int seconds = totalSeconds % 60;
        int minutes = (totalSeconds / 60) % 60;
//        int hours = totalSeconds / 3600;
        
        self.endTime.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0];
        
        self.seekbar.minimumValue = 0;
        self.seekbar.maximumValue = self.audioPlayer.duration;
        [_audioPlayer prepareToPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)adjustVolume:(id)sender {
    if (_audioPlayer != nil)
    {
        _audioPlayer.volume = _volumeControl.value;
    }
}

- (IBAction)playAudio:(id)sender {
    self.playButton.hidden = YES;
    self.stopButton.hidden = NO;
    [_audioPlayer play];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSeekBar) userInfo:nil repeats:YES];
}

- (IBAction)stopAudio:(id)sender {
    self.playButton.hidden = NO;
    self.stopButton.hidden = YES;
    [_audioPlayer stop];
}

- (void)updateSeekBar{
    
    int totalSeconds = self.audioPlayer.currentTime;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
    float progress = self.audioPlayer.currentTime;
    [self.seekbar setValue:progress];
}

- (IBAction)seekTime:(id)sender {
    
    self.audioPlayer.currentTime = self.seekbar.value;
    
}

- (IBAction)doneButtonClicked:(UIButton *)sender
{
    [self stopAudio:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.playButton.hidden = NO;
    self.stopButton.hidden = YES;
//  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
