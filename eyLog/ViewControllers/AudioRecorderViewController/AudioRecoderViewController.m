//
//  AudioRecoderViewController.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 10/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "AudioRecoderViewController.h"
#import "NewObservationAttachment.h"
#import "AppDelegate.h"
#import "APICallManager.h"
#import "AudioGalleryCell.h"
#import "Utils.h"
#import "AudioViewController.h"
#import "AudioGalleryCell.h"
#import "DocumentFileHandler.h"
#import "EYLAudio.h"
#import "Audio.h"

@import MobileCoreServices;
@import MediaPlayer;
//@import CoreAudio;
@import AVFoundation;


@interface AudioRecoderViewController ()<AVAudioRecorderDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AVAudioPlayerDelegate,AudioGalleryCellDelegate>
{
    BOOL recording;
    NSURL *tmpFile;
    NSURL *tmpSelectionFile;
    AVAudioRecorder *recorder;
    AVAudioSession * audioSession;
    
    NSDate *interviewStartDate;
    NSTimer *mTimer;
    NSDateFormatter *dateFormatter;
    NSNumber *duration;
    NSDate *pauseDate;
    
    NSMutableArray *allAudioAttachments;
    NSMutableArray *collectionData;
    NSIndexPath *currentPlayingIndex;
    BOOL isRecordingDone;
    
    NSMutableArray *selectedAudio;
}
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;
//- (IBAction)playPauseButtonClicked:(UIButton *)sender;
//- (IBAction)finishButtonClicked:(UIButton *)sender;
@end

@implementation AudioRecoderViewController
NSString* const kAudioRecoderStoryBoardID = @"AudioRecorderControllerSegueID";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedAudio = [[NSMutableArray alloc] init];
    isRecordingDone=NO;
    
    [self loadGalleryData];
    
    if(collectionData.count==0)
    {
        self.collectionView.hidden=YES;
    }
    audioSession = [AVAudioSession sharedInstance];
    [self.startButton setEnabled:YES];
    self.statusLabel.hidden=YES;
    [self.pauseButton setEnabled:NO];
    [self.finishButton setEnabled:NO];
    // Do any additional setup after loading the view.
}

-(void)loadGalleryData
{
    NSArray * array = [Audio fetchALLAudioInContext:[AppDelegate context] withIsDeleted:NO];
    allAudioAttachments = [NSMutableArray array];
    for (Audio * audio in array) {
        EYLAudio * eylAudio = [[EYLAudio alloc] init];
        eylAudio.name = audio.name;
        eylAudio.path = audio.path;
        [allAudioAttachments addObject:eylAudio];
    }
    collectionData = [allAudioAttachments mutableCopy];
}

-(void)perpareForRecord
{
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber  numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    if (self.isGallery) {
        NSString * tempDirectory = [DocumentFileHandler setTemporaryDirectoryforPath:[DocumentFileHandler getAudioPathForAudio:@"AudioFiles"]];
        tmpFile = [NSURL URLWithString:[tempDirectory stringByAppendingPathComponent:[DocumentFileHandler getFileNameWithExtension:@"m4a"]]];
        NSLog(@"tmpFile %@",tmpFile);
    }
    else
    {
        NSString * tempDirectory = [DocumentFileHandler setTemporaryDirectoryforPath:[DocumentFileHandler getObservationAudioPathForTempChild:@"Temp_Child"]];
        tmpFile = [NSURL URLWithString:[tempDirectory stringByAppendingPathComponent:[DocumentFileHandler getFileNameWithExtension:@"m4a"]]];
    }
    recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:recordSetting error:nil];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pauseButtonClicked:(UIBarButtonItem *)sender
{
    if([recorder isRecording])
    {
        pauseDate=[NSDate date];
        self.statusLabel.text=@"Pause";
        duration=0;
        [mTimer invalidate];
        [recorder pause];
        [self.startButton setEnabled:YES];
        [self.pauseButton setEnabled:NO];
        // [self.startButton setImage:[UIImage imageNamed:@"record_default"] forState:UIControlStateNormal];
    }
}

- (IBAction)startButtonClicked:(UIBarButtonItem *)sender
{
    if(!isRecordingDone)
    {
        [self perpareForRecord];
    }
    
    isRecordingDone=YES;
    if (![recorder isRecording])
    {
        if(pauseDate!=nil)
        {
            //Timer
            NSDate *currentInterViewDate=interviewStartDate;
            NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:pauseDate];
            interviewStartDate=[currentInterViewDate dateByAddingTimeInterval:distanceBetweenDates];
        }
        else
        {
            interviewStartDate=[NSDate date];
        }
        self.statusLabel.hidden=NO;
        self.statusLabel.text=@"Recording";
        //interviewStartDate=[NSDate date];
        [self timerTick];
        mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
        
        [recorder record];
        [self.startButton setEnabled:NO];
        [self.pauseButton setEnabled:YES];
        [self.finishButton setEnabled:YES];
    }
}

-(IBAction)doneButtonClicked:(id)sender
{
    for (NSIndexPath *index in selectedAudio) {
        
        EYLAudio *eylAudio = [collectionData objectAtIndex:index.row];
        
        NSURL *filePath = [NSURL URLWithString:[[DocumentFileHandler setDocumentDirectoryforPath:eylAudio.path] stringByAppendingPathComponent:eylAudio.name]];
        NSString * tempDirectory = [DocumentFileHandler setTemporaryDirectoryforPath:[DocumentFileHandler getObservationAudioPathForTempChild:@"Temp_Child"]];
        tmpSelectionFile = [NSURL URLWithString:[tempDirectory stringByAppendingPathComponent:[DocumentFileHandler getFileNameWithExtension:@"m4a"]]];
        
        NSError *error=nil;
        NSData * videoData = [NSData dataWithContentsOfFile:[filePath absoluteString]options:NSDataReadingMappedAlways error:&error];
        
        BOOL write = [videoData writeToFile:tmpSelectionFile.absoluteString atomically:YES];
        
        //[DocumentFileHandler copyItemAtPath:[filePath absoluteString] toPath:tmpSelectionFile.absoluteString];
        if(write)
        NSLog(@"File path : %@",filePath);
        
        if ([self.delegate respondsToSelector:@selector(didFinishRecordingAudioToURL:)])
        {
            [self.delegate performSelector:@selector(didFinishRecordingAudioToURL:) withObject:tmpSelectionFile];
        }
    }
    
    if(isRecordingDone)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [audioSession setActive:NO error:nil];
        [recorder stop];
        
        [self saveAudioInDirectoryWithURL:tmpFile];
    }
    else
    {
        
        
        [audioSession setActive:NO error:nil];
        [recorder stop];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)saveAudioInDirectoryWithURL:(NSURL *)url{
    
    NSString * fileName = [[[url path] componentsSeparatedByString:@"/"] lastObject];
    NSString * path = [DocumentFileHandler getAudioPathForAudio:@"AudioFiles"];
    NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:path] stringByAppendingPathComponent:fileName];
    NSError *error=nil;
    NSData * videoData = [NSData dataWithContentsOfFile:[url absoluteString]options:NSDataReadingMappedAlways error:&error];
    
    BOOL write = [videoData writeToFile:filePath atomically:YES];
    
    //[DocumentFileHandler moveItemAtPath:[url absoluteString] toPath:filePath];
    
    EYLAudio * eylAudio = [[EYLAudio alloc]init];
    eylAudio.name = fileName;
    eylAudio.path = path;
    [eylAudio createAudioInContext:[AppDelegate context]];
    if (!allAudioAttachments) {
        allAudioAttachments = [NSMutableArray array];
    }
    [allAudioAttachments addObject:eylAudio];
    if (!collectionData) {
        collectionData = [NSMutableArray array];
    }
    [collectionData addObject:eylAudio];
    
    [self updateAudioInNewObservation:eylAudio];
    
    [self.collectionView reloadData];
    
}
-(void)updateAudioInNewObservation:(EYLAudio *)eylAudio{
    NSURL *filePath = [NSURL URLWithString:[[DocumentFileHandler setDocumentDirectoryforPath:eylAudio.path] stringByAppendingPathComponent:eylAudio.name]];
    NSString * tempDirectory = [DocumentFileHandler setTemporaryDirectoryforPath:[DocumentFileHandler getObservationAudioPathForTempChild:@"Temp_Child"]];
    tmpFile = [NSURL URLWithString:[tempDirectory stringByAppendingPathComponent:[DocumentFileHandler getFileNameWithExtension:@"m4a"]]];
    
    NSError *error=nil;
    NSData * videoData = [NSData dataWithContentsOfFile:[filePath absoluteString]options:NSDataReadingMappedAlways error:&error];
    
    BOOL write = [videoData writeToFile:tmpFile.absoluteString atomically:YES];
    
    //[DocumentFileHandler copyItemAtPath:[filePath absoluteString] toPath:tmpSelectionFile.absoluteString];
    if(write)
   // [DocumentFileHandler copyItemAtPath:[filePath absoluteString] toPath:tmpFile.absoluteString];
    
    NSLog(@"File path : %@",filePath);
    
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingAudioToURL:)])
    {
        [self.delegate performSelector:@selector(didFinishRecordingAudioToURL:) withObject:tmpFile];
    }
}
#pragma -mark timerMethod

- (void)timerTick
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm:ss a";  // very simple format  "8:47:22 AM"
    }
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:interviewStartDate];
    NSInteger timeDifference=(NSInteger)distanceBetweenDates;
    
    duration=[NSNumber numberWithInteger:timeDifference];
   self.timer.text=[self timeFormatted:[duration intValue]];
   
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60);
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}

#pragma mark - collectionViewDelegateMethods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudioGalleryCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"audioCellIdentifier" forIndexPath:indexPath];
    EYLAudio * eylAudio =  [collectionData objectAtIndex:indexPath.row];
    cell.indexPath=indexPath;
    cell.insideImage.image=[UIImage imageNamed:@"play"];
    cell.delegate = self;
    cell.audioSelected.hidden=([selectedAudio containsObject:indexPath])?NO:YES;
    
    NSTimeInterval timeInterval = [[[eylAudio.name componentsSeparatedByString:@"."] firstObject] doubleValue]/1000;
    
    cell.nameLbl.numberOfLines = 0;
    cell.nameLbl.textColor = [UIColor whiteColor];
    cell.nameLbl2.numberOfLines = 0;
    cell.nameLbl2.textColor = [UIColor whiteColor];
    NSArray * array = [[Utils dateWithTimeInterval:timeInterval] componentsSeparatedByString:@" "];
    cell.nameLbl.text = [array firstObject];
    cell.nameLbl2.text = [array lastObject];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"LongPress Detected.");
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        AudioGalleryCell *cell = (AudioGalleryCell *)[gesture view];
        
        EYLAudio *eylAudio = [collectionData objectAtIndex:cell.indexPath.row];
        
        NSURL *filePath = [NSURL URLWithString:[[DocumentFileHandler setDocumentDirectoryforPath:eylAudio.path] stringByAppendingPathComponent:eylAudio.name]];
        
        AudioViewController *audioViewController = [[AudioViewController alloc] init];
        audioViewController.url = filePath;
        [self presentViewController:audioViewController animated:YES completion:nil];
    }
    
}

- (void)collectionViewDidRefreshed:(UIRefreshControl *)sender
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([selectedAudio containsObject:indexPath])
    {
        [selectedAudio removeObject:indexPath];
    }
    else
    {
        [selectedAudio addObject:indexPath];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - AudioGalleryCellDelegate

-(void)deleteMediaForIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alertView show];
    alertView.tag = indexPath.row;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        EYLAudio *eylAudio = [collectionData objectAtIndex:alertView.tag];
        
        NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:eylAudio.path] stringByAppendingPathComponent:eylAudio.name];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        BOOL fileExist = [fileManager fileExistsAtPath:filePath];
        if (!fileExist) {
            filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:eylAudio.path] stringByAppendingPathComponent:eylAudio.name];
        }
        
        NSError *error;
        
        BOOL remove = [fileManager removeItemAtPath:filePath error:&error];
        
        if (!remove) {
            NSLog(@"Could not delete media file at Index A: %d",alertView.tag);
        }
        else
        {
            eylAudio.isDeleted = YES;
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",YES];
            NSArray * array = [allAudioAttachments filteredArrayUsingPredicate:predicate];
            for (EYLAudio * eylAudio in array){
                [eylAudio deleteAudio:@[eylAudio]];
            }
            [collectionData removeObject:eylAudio];
            for(NSIndexPath * path in selectedAudio)
            {
                if(path.row == alertView.tag)
                {
                    [selectedAudio removeObject:path];
                    break;
                }
            }
            //  [eylAudio updateAudio];
            [self.collectionView reloadData];
        }
        if (collectionData.count == 0) {
            self.collectionView.hidden = YES;
        }
 
    }
}
-(void)playAudioFile:(NSString *)fileName
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
    player.delegate=self;
    player.numberOfLoops = -1;
    [player play];
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) flag
{
   
}

- (IBAction)cancelButtonClicked:(id)sender {
//        [audioSession setActive:NO error:nil];
//        if (recorder)
//        {
//            [recorder stop];
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end