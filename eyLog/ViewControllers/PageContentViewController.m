//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"
#import "MBProgressHUD.h"
#import <CoreMedia/CoreMedia.h>
#import "AudioViewController.h"
#import "DocumentFileHandler.h"
#import "ShowImageViewController.h"


@interface PageContentViewController ()<AVAudioPlayerDelegate,UIGestureRecognizerDelegate>
{
   MPMoviePlayerViewController *moviePlayer;
    MPMoviePlayerController *yourMoviePlayerController;
    NSURL *videoURl;
    NSData *imageData;
    
    
}
@end

@implementation PageContentViewController

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
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    tapGestureRecognizer.delegate = self;
    //self.backgroundImageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, 200)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:nil];
   
        /* Fetch the image from the server... */
        NSURL *url;
        
    

}
-(void)viewWillAppear:(BOOL)animated
{
    if([self.imageFile isEqualToString:@""]||self.imageFile==nil)
    {
        
        if(self.videoFile.length>0)
        {
            MBProgressHUD *hud=  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                NSURL *url = [NSURL URLWithString:[self.videoFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString* theFileName = [self.videoFile lastPathComponent];
                
                NSArray * words = [theFileName componentsSeparatedByString:@"?"];
                
                NSString * filePath   = [[DocumentFileHandler setTemporaryDirectoryforPath:documentsDirectory] stringByAppendingPathComponent:[words objectAtIndex:0]];
                NSLog(@"%@",filePath);
                [data writeToFile:filePath atomically:YES];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [hud hide:YES];
                    
                    NSURL *movieURL = [NSURL fileURLWithPath:filePath];
                    videoURl=movieURL;
                    
                    yourMoviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
                    yourMoviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
                    //yourMoviePlayerController.view.transform = CGAffineTransformConcat(yourMoviePlayerController.view.transform, CGAffineTransformMakeRotation(M_PI_2));
                    //UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
 [yourMoviePlayerController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30)];                    [self.view addSubview:yourMoviePlayerController.view];
                    [yourMoviePlayerController play];
                    
//                    moviePlayer = [[MPMoviePlayerViewController alloc]init];
//                    
//                    //[moviePlayer.moviePlayer setFullscreen:YES];
//                    
//                    [moviePlayer.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//                    [moviePlayer.view setFrame:self.view.frame];
//                    
//                    [moviePlayer.view setTranslatesAutoresizingMaskIntoConstraints:YES];
//                    moviePlayer.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
//                    
//                    [moviePlayer.moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
//                    [moviePlayer.moviePlayer setContentURL:url];
//                    //WithContentURL:[NSURL fileURLWithPath:filePath]
//                    [moviePlayer.moviePlayer play];
//                    
//                    [self addChildViewController:moviePlayer];
//                    
//                    [self.view addSubview:moviePlayer.view];
//                    [self addChildViewController:moviePlayer];
//                    [moviePlayer didMoveToParentViewController:self];
                    
                    
                });
                
            });
            
            
            
            //                self.theMoviPlayer = [[MPMoviePlayerController alloc]initWithContentURL:movieURL];
            //                self.theMoviPlayer.scalingMode=MPMovieScalingModeAspectFill;
            //                self.theMoviPlayer.movieSourceType = MPMovieSourceTypeStreaming;
            //
            //                [self.theMoviPlayer.view setFrame: self.backgroundImageView.bounds];
            //                [self.backgroundImageView addSubview: self.theMoviPlayer.view];
            //
            //                // Register for the playback finished notification.
            //
            //                [[NSNotificationCenter defaultCenter] addObserver:self
            //                                                         selector:@selector(myMovieFinishedCallback:)
            //                                                             name:MPMoviePlayerPlaybackDidFinishNotification
            //                                                           object:self.theMoviPlayer];
            //
            //                // Movie playback is asynchronous, so this method returns immediately.
            //                 [self.theMoviPlayer prepareToPlay];
            //                [self.theMoviPlayer play];
            //
            
            
            
            
        }
        else if(self.audioFile.length>0)
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [self.backgroundImageView setImage:[UIImage imageNamed:@"icon_audio"]];
            [self.backgroundImageView setContentMode:UIViewContentModeCenter];
            
            
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                NSURL *url = [NSURL URLWithString:[self.audioFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString* theFileName = [self.audioFile lastPathComponent];
                
                //NSArray * words = [theFileName componentsSeparatedByString:@"?"];
                
           
                NSString * attachmentNameee = [DocumentFileHandler getFileNameWithExtension:@"m4a"];
                NSString * str = [documentsDirectory stringByAppendingPathComponent:attachmentNameee];
       
                   // NSError *error=nil;
                
                BOOL write = [data writeToFile:str atomically:YES];
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [hud hide:YES];
                   
                    _audioViewController=[[AudioViewController alloc] init];
                    
                    _audioViewController.url = [NSURL URLWithString:str];
                    [_audioViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                      [_audioViewController.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-30)];
                    
                    [_audioViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
                    
                    [self addChildViewController:_audioViewController];
                    
                    [self.view addSubview:_audioViewController.view];
                    [self addChildViewController:_audioViewController];
                    [_audioViewController didMoveToParentViewController:self];
                    
                    
                });
                
            });
        }
        
    }
    else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"";
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSURL * url=[NSURL URLWithString:self.imageFile];
            
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                [hud hide:YES];
                ShowImageViewController *imageViewController = [[ShowImageViewController alloc] init];
                imageViewController.image = [[UIImage alloc] initWithData:data];
                imageData=data;
                
                [self addChildViewController:imageViewController];
                [imageViewController.view setFrame:self.view.frame];
                
                [self.view addSubview:imageViewController.view];
                [self addChildViewController:imageViewController];
                [imageViewController didMoveToParentViewController:self];
                
                
//                self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
//                self.backgroundImageView.clipsToBounds = YES;
//                self.backgroundImageView.image = img;
                
            });
            
        });
    }

}
-(void)viewDidDisappear:(BOOL)animated
{

    [yourMoviePlayerController stop];
    [yourMoviePlayerController.view removeFromSuperview];
    yourMoviePlayerController=nil;
    
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)movieLoadStateDidChange:(id)sender{
    [moviePlayer.moviePlayer stop];
    [moviePlayer.moviePlayer play];
    NSLog(@"STATE CHANGED");
    if(MPMovieLoadStatePlaythroughOK ) {
        NSLog(@"State is Playable OK");
        NSLog(@"Enough data has been buffered for playback to continue uninterrupted..");
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    
    }
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
[_audioPlayer stop];
NSLog(@"Finished Playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.theMoviPlayer];
    
   // self.theMoviPlayer.view.frame = CGRectMake(0, 0, 0, 0);
    // Release the movie instance created in playMovieAtURL
    
    
}
-(void)viewDidLayoutSubviews
{
   //[yourMoviePlayerController stop];
    
    yourMoviePlayerController.view.frame = self.view.frame;
   // [yourMoviePlayerController play];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(_audioViewController)
        
    {
     [_audioViewController.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-30)];
    }
    
    if(yourMoviePlayerController)
    {
        [yourMoviePlayerController stop];
//        [yourMoviePlayerController.view removeFromSuperview];
//        yourMoviePlayerController=nil;
//        
//        
//        yourMoviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURl];
//        yourMoviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
//        //yourMoviePlayerController.view.transform = CGAffineTransformConcat(yourMoviePlayerController.view.transform, CGAffineTransformMakeRotation(M_PI_2));
//        //UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
//        [yourMoviePlayerController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30)];
//        [self.view addSubview:yourMoviePlayerController.view];
        [yourMoviePlayerController play];

    }
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIViewController *controller = [self.childViewControllers firstObject];
    
    if([controller isKindOfClass:[ShowImageViewController class]])
    {
        [controller removeFromParentViewController];
        
        
        ShowImageViewController *imageViewController = [[ShowImageViewController alloc] init];
        imageViewController.image = [[UIImage alloc] initWithData:imageData];
        
        [self addChildViewController:imageViewController];
        [imageViewController.view setFrame:self.view.frame];
        
        [self.view addSubview:imageViewController.view];
        [self addChildViewController:imageViewController];
        [imageViewController didMoveToParentViewController:self];

    }
}
@end
