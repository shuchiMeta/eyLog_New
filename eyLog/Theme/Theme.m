//
//  Theme.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 23/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Theme.h"
#import "CustomToolBarButtons.h"
#import "AudioRecoderViewController.h"
#import "Media.h"
#import "WSAssetPicker.h"
#import "HomeViewController.h"
#import "NewObservationViewController.h"
#import "ChilderenViewController.h"
#import "CTAssetsPickerController.h"
#import "WYPopoverController.h"
#import "Utils.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "CustomBarButton_InOut.h"
#import "EYL_AppData.h"
@import MobileCoreServices;
@import MediaPlayer;
@import CoreAudio;
@import AVFoundation;

#import "DailyDiaryViewController.h"

@interface Theme ()<UINavigationControllerDelegate,  UIImagePickerControllerDelegate, AudioRecoderDelegate, WSAssetPickerControllerDelegate, CTAssetsPickerControllerDelegate, WYPopoverControllerDelegate,MBProgressHUDDelegate, CustomBarButton_InOutDelegate>
{
    BOOL recording;
    NSURL *tmpFile;
    AVAudioRecorder *recorder;
    NSMutableArray *deleteArray;
}

@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) WYPopoverController *popover;

@end

@implementation Theme
@synthesize myLabel;

static Theme *currentTheme = nil;

+ (Theme *)getTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!currentTheme) {
            currentTheme = [[super allocWithZone:NULL] init];
        }
    });
    return currentTheme;
}


- (instancetype)init {
    if (self = [super init]) {
    // Initializing Deleting Array For Deleting Video from Temp Directory.
        deleteArray = [NSMutableArray array];
    }
    return self;
}

- (void)resetTargetViewController:(UIViewController *)controller
{
    self.controller = controller;

    if([controller isKindOfClass:[NewObservationViewController class]])
    {
        NewObservationViewController *tmpRef = (NewObservationViewController *)controller;
        if (tmpRef.isEditView && tmpRef.isUploadQueue) {
            if([Reachability reachabilityForInternetConnection].isReachable)
            {
                NSMutableArray *toolbarButtons = [tmpRef.toolbarItems mutableCopy];

                [toolbarButtons removeObject:((UIBarButtonItem *)tmpRef.toolbarItems[0])];
                [toolbarButtons removeObject:((UIBarButtonItem *)[tmpRef.toolbarItems lastObject])];
                [tmpRef setToolbarItems:toolbarButtons animated:YES];
            }
        }
    }
}

- (void)addToolbarItemsToHomeViewController:(UIViewController *)controller
{
    self.controller = controller;
    [controller.navigationController setToolbarHidden:NO animated:YES];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:5];

    CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
    [gallary addTarget:controller forSelector:@selector(galleryButtonClicked:)];
    [gallary.titleLabel setText:@"GALLERY"];
    [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
    UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];

    CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
    [camera addTarget:controller forSelector:@selector(cameraButtonClicked:)];
    [camera.titleLabel setText:@"CAMERA"];
    [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];

    CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
    [video addTarget:controller forSelector:@selector(videoButtonClicked:)];
    [video.titleLabel setText:@"VIDEO"];
    [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
    UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];

    CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
    [audio addTarget:controller forSelector:@selector(audioButtonClicked:)];
    [audio.titleLabel setText:@"AUDIO"];
    [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];
    UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];
    NSArray *array = @[flexible, galleryButton, cameraButton, videoButton, audioButton, flexible];
    self.controller.toolbarItems = array;
}
-(void)showHud:(id)sender
{
    UIWindow *tempKeyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tempKeyboardWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Please tap on your photo and Login to view gallery.";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate =self;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        hud.yOffset=280;
    }
    else
    {
        hud.yOffset=420;
    }
    [hud hide:YES afterDelay:1];

}

-(void)showAlert:(id)sender
{
    NSString *title=((UIButton *)sender).titleLabel.text;
    NSString *message;
    if([title isEqualToString:@"GALLERY"])
    {
        message=@"Please tap on your photo and Login to view gallery.";
    }
    else if ([title isEqualToString:@"CAMERA"])
    {
        message=@"Please tap on your photo and Login to open camera.";
    }
    else if ([title isEqualToString:@"VIDEO"])
    {
        message=@"Please tap on your photo and Login to open video";
    }
    else if ([title isEqualToString:@"AUDIO"])
    {
        message=@"Please tap on your photo and login to open audio";
    }

    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alerView show];

}

- (void)addToolbarItemsToViewCaontroller:(UIViewController *)controller
{
    if([controller isKindOfClass:[HomeViewController class]])
    {
        self.controller = controller;
        [controller.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedSpace setWidth:5];

        
        UIButton *submitButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [submitButton setFrame:CGRectMake(0, 0, 140, 36)];
        //[submitButton.titleLabel setFont:kSystemFontRobotoR;
        [submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [submitButton setBackgroundColor:darkYellowButtonColor];
        submitButton.layer.cornerRadius=10.0f;
        [submitButton setTintColor:[UIColor whiteColor]];
        [submitButton setTitle:@"Version 2.1.0" forState:UIControlStateNormal];
        
        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        //        [gallary addTarget:self forSelector:@selector(showAlert:)];
        [gallary addTarget:self forSelector:@selector(showHud:)];
        [gallary.titleLabel setText:@"GALLERY"];
        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];

        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [camera addTarget:self forSelector:@selector(cameraButtonGeneralClicked:)];
        [camera.titleLabel setText:@"CAMERA"];
        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];

        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];
        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [video addTarget:self forSelector:@selector(videoButtonGeneralClicked:)];
        [video.titleLabel setText:@"VIDEO"];
        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];

        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];
        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [audio addTarget:self forSelector:@selector(audioButtonGeneralClicked:)];
        [audio.titleLabel setText:@"AUDIO"];
        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];

        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];
          UIBarButtonItem *barsubmitButton = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
        NSArray *array = @[barsubmitButton,flexible, galleryButton, cameraButton, videoButton, audioButton, flexible];
        self.controller.toolbarItems = array;

        return;
    }
    if([controller isKindOfClass:[NewObservationViewController class]])
    {


        self.controller = controller;
        [controller.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [flexible setWidth:5];

        UIButton *submitButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [submitButton setFrame:CGRectMake(0, 0, 190, 36)];
        //[submitButton.titleLabel setFont:kSystemFontRobotoR;
        [submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [submitButton setBackgroundColor:darkYellowButtonColor];
        submitButton.layer.cornerRadius=10.0f;
        [submitButton setTintColor:[UIColor whiteColor]];
        [submitButton setImage:[UIImage imageNamed:@"icon_submitSmallButton"] forState:UIControlStateNormal];
        NewObservationViewController *newObser=(NewObservationViewController *)controller;
        if(newObser.isEditView==YES)
        {
            
            if([[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId isEqual:
                _observerID])
            {
               
                if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]) {
                    [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
                }
                else
                {
                    [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
                }
            }
            
            else
            {
                if ([[APICallManager sharedNetworkSingleton].cachePractitioners.groupLeader integerValue]) {
                    [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
                }
                else
                {
                    [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
       if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]) {
                [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
            }
            else
            {
                [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
            }
        }
        
       
        [submitButton addTarget:self action:@selector(submitObservation:) forControlEvents:UIControlEventTouchUpInside];


        UIBarButtonItem *barsubmitButton = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedSpace setWidth:5];
        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [gallary addTarget:self forSelector:@selector(galleryButtonClicked:)];
        [gallary.titleLabel setText:@"GALLERY"];
        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];

        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [camera addTarget:self forSelector:@selector(cameraButtonClicked:)];
        [camera.titleLabel setText:@"CAMERA"];
        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];

        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [video addTarget:self forSelector:@selector(videoButtonClicked:)];
        [video.titleLabel setText:@"VIDEO"];
        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];

        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [audio addTarget:self forSelector:@selector(audioButtonClicked:)];
        [audio.titleLabel setText:@"AUDIO"];
        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];

        UIButton *saveDraftButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveDraftButton.layer.cornerRadius=10.0f;
        [saveDraftButton setFrame:CGRectMake(0, 0, 190, 36)];
        [saveDraftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [saveDraftButton setBackgroundColor:darkYellowButtonColor];
        [saveDraftButton setTintColor:[UIColor whiteColor]];
        [saveDraftButton setImage:[UIImage imageNamed:@"icon_draftlist"] forState:UIControlStateNormal];
        [saveDraftButton setTitle:@"Save As Draft" forState:UIControlStateNormal];

        [saveDraftButton addTarget:self action:@selector(saveAsDraft:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barsaveDraftbutton = [[UIBarButtonItem alloc] initWithCustomView:saveDraftButton];

        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];

        NSArray *array = @[barsubmitButton,flexible, galleryButton, cameraButton, videoButton, audioButton,flexible,barsaveDraftbutton];

        self.controller.toolbarItems = array;
    }
    else if([controller isKindOfClass:[ChilderenViewController class]])
    {
        self.controller = controller;
        [controller.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [flexible setWidth:5];

        UIButton *selectButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [selectButton setFrame:CGRectMake(0, 0, 120, 36)];
        [selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [selectButton setBackgroundColor:darkYellowButtonColor];
        selectButton.layer.cornerRadius=10.0f;
        [selectButton setTintColor:[UIColor whiteColor]];
        [selectButton setTitle:@"  Selected" forState:UIControlStateNormal];
        selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        //[submitButton setImage:[UIImage imageNamed:@"icon_submitSmallButton"] forState:UIControlStateNormal];
        myLabel = [[UILabel alloc]initWithFrame:CGRectMake(85,7,25,25)];
        [myLabel setBackgroundColor:[UIColor whiteColor]];
        [myLabel setText:@"0"];
        myLabel.textAlignment =NSTextAlignmentCenter;
        myLabel.layer.cornerRadius = 12.5;
        myLabel.layer.masksToBounds =YES;
        //[[self view] addSubview:myLabel];
        [selectButton addSubview:myLabel];

        [selectButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];


        UIBarButtonItem *barselectButton = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedSpace setWidth:5];
        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [gallary addTarget:self forSelector:@selector(galleryButtonClicked:)];
        [gallary.titleLabel setText:@"GALLERY"];
        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];

        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [camera addTarget:self forSelector:@selector(cameraButtonClicked:)];
        [camera.titleLabel setText:@"CAMERA"];
        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];

        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [video addTarget:self forSelector:@selector(videoButtonClicked:)];
        [video.titleLabel setText:@"VIDEO"];
        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];

        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [audio addTarget:self forSelector:@selector(audioButtonClicked:)];
        [audio.titleLabel setText:@"AUDIO"];
        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];


        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];

        NSArray *array = @[barselectButton,flexible, galleryButton, cameraButton, videoButton, audioButton,flexible];

        self.controller.toolbarItems = array;
    }
//    if([controller isKindOfClass:[NewObservationViewController class]])
//    {
//
//        self.controller = controller;
//        [controller.navigationController setToolbarHidden:NO animated:YES];
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        [flexible setWidth:5];
//
//        UIButton *submitButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [submitButton setFrame:CGRectMake(0, 0, 190, 36)];
//        //[submitButton.titleLabel setFont:kSystemFontRobotoR;
//        [submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [submitButton setBackgroundColor:darkYellowButtonColor];
//        submitButton.layer.cornerRadius=10.0f;
//        [submitButton setTintColor:[UIColor whiteColor]];
//        [submitButton setImage:[UIImage imageNamed:@"icon_submitSmallButton"] forState:UIControlStateNormal];
//        if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]) {
//            [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
//        }
//        else
//        {
//            [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
//        }
//        [submitButton addTarget:self action:@selector(submitObservation:) forControlEvents:UIControlEventTouchUpInside];
//
//
//        UIBarButtonItem *barsubmitButton = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
//        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        [fixedSpace setWidth:5];
//        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [gallary addTarget:self forSelector:@selector(galleryButtonClicked:)];
//        [gallary.titleLabel setText:@"GALLERY"];
//        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
//        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];
//
//        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [camera addTarget:self forSelector:@selector(cameraButtonClicked:)];
//        [camera.titleLabel setText:@"CAMERA"];
//        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
//        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];
//
//        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [video addTarget:self forSelector:@selector(videoButtonClicked:)];
//        [video.titleLabel setText:@"VIDEO"];
//        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
//        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];
//
//        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [audio addTarget:self forSelector:@selector(audioButtonClicked:)];
//        [audio.titleLabel setText:@"AUDIO"];
//        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];
//
//        UIButton *saveDraftButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        saveDraftButton.layer.cornerRadius=10.0f;
//        [saveDraftButton setFrame:CGRectMake(0, 0, 190, 36)];
//        [saveDraftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [saveDraftButton setBackgroundColor:darkYellowButtonColor];
//        [saveDraftButton setTintColor:[UIColor whiteColor]];
//        [saveDraftButton setImage:[UIImage imageNamed:@"icon_draftlist"] forState:UIControlStateNormal];
//        [saveDraftButton setTitle:@"Save As Draft" forState:UIControlStateNormal];
//
//        [saveDraftButton addTarget:self action:@selector(saveAsDraft:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barsaveDraftbutton = [[UIBarButtonItem alloc] initWithCustomView:saveDraftButton];
//
//        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];
//
//        NSArray *array = @[barsubmitButton ,flexible, galleryButton, cameraButton, videoButton, audioButton,flexible,barsaveDraftbutton];
//
//        self.controller.toolbarItems = array;
//    }
    if([controller isKindOfClass:[DailyDiaryViewController class]])
    {
        /*
         
         This code was commented because this functionality was being changes and reported on 19 AUG
         
        self.controller = controller;
        [controller.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [flexible setWidth:5];

        UIButton *submitButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [submitButton setFrame:CGRectMake(0, 0, 190, 36)];
        [submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [submitButton setBackgroundColor:darkYellowButtonColor];
        submitButton.layer.cornerRadius=10.0f;
        [submitButton setTintColor:[UIColor whiteColor]];
        [submitButton setImage:[UIImage imageNamed:@"icon_submitSmallButton"] forState:UIControlStateNormal];
        if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]) {
            [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
        }
        else
        {
            [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
        }
        [submitButton addTarget:self action:@selector(submitObservation:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barsubmitButton= [[UIBarButtonItem alloc] initWithCustomView:submitButton];
        
        self.IN_button = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomBarButton_InOut class]) owner:self.controller options:nil] lastObject];
        [self.IN_button.lblName setText:@"IN Time : 00:00"];
        self.IN_button.btnTag=101;
        [self.IN_button.lblName setTextAlignment:NSTextAlignmentCenter];
        self.IN_button.childDelegate=self;
        UIBarButtonItem *buttonIN = [[UIBarButtonItem alloc] initWithCustomView:self.IN_button];
        
        self.OUT_button = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomBarButton_InOut class]) owner:self.controller options:nil] lastObject];
        [self.OUT_button.lblName setText:@"OUT Time : 00:00"];
        self.OUT_button.btnTag=102;
        self.OUT_button.childDelegate=self;
        [self.OUT_button.lblName setTextAlignment:NSTextAlignmentCenter];
        UIBarButtonItem *buttonOUT = [[UIBarButtonItem alloc] initWithCustomView:self.OUT_button];
        
        UIButton *saveDraftButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveDraftButton.layer.cornerRadius=10.0f;
        [saveDraftButton setFrame:CGRectMake(0, 0, 190, 36)];
        [saveDraftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [saveDraftButton setBackgroundColor:darkYellowButtonColor];
        [saveDraftButton setTintColor:[UIColor whiteColor]];
        [saveDraftButton setImage:[UIImage imageNamed:@"icon_draftlist"] forState:UIControlStateNormal];
        [saveDraftButton setTitle:@"Save As Draft" forState:UIControlStateNormal];

        [saveDraftButton addTarget:self action:@selector(saveAsDraft:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barsaveDraftbutton = [[UIBarButtonItem alloc] initWithCustomView:saveDraftButton];

        NSArray *array = @[barsubmitButton,flexible,buttonIN,flexible,buttonOUT,flexible,barsaveDraftbutton];

        self.controller.toolbarItems = array;
        
        */
        
        self.controller = controller;
        [controller.navigationController setToolbarHidden:NO animated:YES];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [flexible setWidth:5];
        
        UIButton *submitButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [submitButton setFrame:CGRectMake(0, 0, 190, 36)];
        //[submitButton.titleLabel setFont:kSystemFontRobotoR;
        [submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [submitButton setBackgroundColor:darkYellowButtonColor];
        submitButton.layer.cornerRadius=10.0f;
        [submitButton setTintColor:[UIColor whiteColor]];
        [submitButton setImage:[UIImage imageNamed:@"icon_submitSmallButton"] forState:UIControlStateNormal];
        //if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]) {
            [submitButton setTitle:@"Publish" forState:UIControlStateNormal];
      //  }
//        else
//        {
//            [submitButton setTitle:@"Submit for Review" forState:UIControlStateNormal];
//        }
        [submitButton addTarget:self action:@selector(submitObservation:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *barsubmitButton = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixedSpace setWidth:5];
        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [gallary addTarget:self forSelector:@selector(galleryButtonClicked:)];
        [gallary.titleLabel setText:@"GALLERY"];
        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];
        
        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [camera addTarget:self forSelector:@selector(cameraButtonClicked:)];
        [camera.titleLabel setText:@"CAMERA"];
        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];
        
        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [video addTarget:self forSelector:@selector(videoButtonClicked:)];
        [video.titleLabel setText:@"VIDEO"];
        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];
        
        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
        [audio addTarget:self forSelector:@selector(audioButtonClicked:)];
        [audio.titleLabel setText:@"AUDIO"];
        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];
        
        UIButton *saveDraftButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveDraftButton.layer.cornerRadius=10.0f;
        [saveDraftButton setFrame:CGRectMake(0, 0, 190, 36)];
        [saveDraftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [saveDraftButton setBackgroundColor:darkYellowButtonColor];
        [saveDraftButton setTintColor:[UIColor whiteColor]];
        [saveDraftButton setImage:[UIImage imageNamed:@"icon_draftlist"] forState:UIControlStateNormal];
        [saveDraftButton setTitle:@"Save As Draft" forState:UIControlStateNormal];
        
        [saveDraftButton addTarget:self action:@selector(saveAsDraft:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barsaveDraftbutton = [[UIBarButtonItem alloc] initWithCustomView:saveDraftButton];
        
        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];
        
        NSArray *array = @[barsubmitButton,flexible, galleryButton, cameraButton, videoButton, audioButton,flexible,barsaveDraftbutton];
        
        self.controller.toolbarItems = array;

    }
    else
    {
//        self.controller = controller;
//        [controller.navigationController setToolbarHidden:NO animated:YES];
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        [fixedSpace setWidth:5];
//        CustomToolBarButtons *gallary = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [gallary addTarget:self forSelector:@selector(galleryButtonGeneralClicked:)];
//        [gallary.titleLabel setText:@"GALLERY"];
//        [gallary.imageView setImage:[UIImage imageNamed:@"icon_gallery"]];
//        UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithCustomView:gallary];
//
//        CustomToolBarButtons *camera = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [camera addTarget:self forSelector:@selector(cameraButtonGeneralClicked:)];
//        [camera.titleLabel setText:@"CAMERA"];
//        [camera.imageView setImage:[UIImage imageNamed:@"icon_camera"]];
//        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithCustomView:camera];
//
//        CustomToolBarButtons *video = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [video addTarget:self forSelector:@selector(videoButtonGeneralClicked:)];
//        [video.titleLabel setText:@"VIDEO"];
//        [video.imageView setImage:[UIImage imageNamed:@"icon_video"]];
//        UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithCustomView:video];
//
//        CustomToolBarButtons *audio = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomToolBarButtons class]) owner:self.controller options:nil] lastObject];
//        [audio addTarget:self forSelector:@selector(audioButtonGeneralClicked:)];
//        [audio.titleLabel setText:@"AUDIO"];
//        [audio.imageView setImage:[UIImage imageNamed:@"icon_audio"]];
//        UIBarButtonItem *audioButton = [[UIBarButtonItem alloc] initWithCustomView:audio];
//        NSArray *array = @[flexible, galleryButton, cameraButton, videoButton, audioButton, flexible];
//        self.controller.toolbarItems = array;
    }
}
-(void)clearAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearAction" object:nil];
}
-(void)submitObservation:(id)sender
{

    if([self.controller isKindOfClass:[NewObservationViewController class]])
    {
        [self.themeDelegate submitObservationInNewObservationVC:sender];
        return;
        NewObservationViewController *tmpObservationController = (NewObservationViewController *) self.controller;

        if(tmpObservationController.observationViewController.textView.text == nil || [tmpObservationController.observationViewController.textView.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!!!" message:@"Observation Text cannot be Blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alert show];
        }
        else
        {
            if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue])
            {

                [((NewObservationViewController *) self.controller) saveObservation:@"submitted"];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info!!!" message:@"Observation is being Published." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

                [alert show];
            }
            else
            {
                [((NewObservationViewController *) self.controller) saveObservation:@"pending_review"];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info!!!" message:@"Observation is Pending for Review." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

                [alert show];
            }
            [self.controller.navigationController popViewControllerAnimated:YES];
        }
    }else if ([self.controller isKindOfClass:[DailyDiaryViewController class]])
    {
        [self.themeDelegate submitInDailyDiaryVC:sender];
    }
}

-(void)saveAsDraft:(id)sender
{

    if([self.controller isKindOfClass:[NewObservationViewController class]])
    {
        [self.themeDelegate saveAsDraftInNewObservationVC:sender];
        return;
        NewObservationViewController *tmpObservationController = (NewObservationViewController *) self.controller;

        if(tmpObservationController.observationViewController.textView.text == nil || [tmpObservationController.observationViewController.textView.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!!!" message:@"Observation Text cannot be Blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alert show];
        }
        else
        {
            [((NewObservationViewController *) self.controller) saveObservation:@"draft"];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info!!!" message:@"Observation is being saved as a draft..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

            [alert show];

            //            if([Reachability reachabilityForInternetConnection].isReachable)
            //            {
            //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //                    [[APICallManager sharedNetworkSingleton] uploadObservations];
            //                });
            //            }
            [self.controller.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.controller isKindOfClass:[DailyDiaryViewController class]])
    {
        [self.themeDelegate saveAsDraftInDailyDiaryVC:sender];


    }
}


- (void)galleryButtonClicked:(id)sender
{

//    if (_onlyView) {
//        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//        [controller setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//        controller.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *)kUTTypeImage, nil];
//        [controller setAllowsEditing:YES];
//
//        controller.navigationBarHidden = YES;
//        controller.toolbarHidden = YES;
//        controller.navigationController.navigationBar.hidden=YES;
//        controller.navigationController.navigationController.toolbarHidden=YES;
//
//
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.controller presentViewController:controller animated:YES completion:nil];
//        }];
//        // controller.showsCameraControls=NO;
//        return;
//    }

    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];

    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = YES;
    picker.delegate             = self;
    picker.alwaysEnableDoneButton = YES;

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.controller presentViewController:picker animated:YES completion:nil];
        if (!_onlyView) {
            [picker.view makeToast:@"Large size videos can not be selected" duration:3.0f position:CSToastPositionCenter];

        }

    }];


}

- (void)galleryButtonGeneralClicked:(id)sender
{

//    if (_onlyView) {
//        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//        [controller setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//        controller.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *)kUTTypeImage, nil];
//        [controller setAllowsEditing:YES];
//
//        controller.navigationBarHidden = YES;
//        controller.toolbarHidden = YES;
//        controller.navigationController.navigationBar.hidden=YES;
//        controller.navigationController.navigationController.toolbarHidden=YES;
//
//
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.controller presentViewController:controller animated:YES completion:nil];
//        }];
//        // controller.showsCameraControls=NO;
//        return;
//    }


    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];

    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = YES;
    picker.delegate             = self;
    //    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    picker.alwaysEnableDoneButton = YES;

    [Theme getTheme].saveInGallery = YES;

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.controller presentViewController:picker animated:YES completion:nil];
    }];

}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)cameraButtonClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *mediaTypes = [NSArray arrayWithObjects: (NSString *)kUTTypeImage, nil];
        [controller setMediaTypes:mediaTypes];
        //        controller.allowsEditing = YES;
        [controller setDelegate:self];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.controller presentViewController:controller animated:YES completion:nil];
        }];
    }
}

- (void)videoButtonClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *mediaTypes = [NSArray arrayWithObjects: (NSString *)kUTTypeMovie, nil];
        [controller setMediaTypes:mediaTypes];
        controller.allowsEditing = YES;
        controller.videoQuality = UIImagePickerControllerQualityType640x480;
        controller.videoMaximumDuration = 100;
        [controller setDelegate:self];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.controller presentViewController:controller animated:YES completion:nil];
        }];
    }
}

- (void)cameraButtonGeneralClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *mediaTypes = [NSArray arrayWithObjects: (NSString *)kUTTypeImage, nil];
        [controller setMediaTypes:mediaTypes];
        //        controller.allowsEditing = YES;
        [controller setDelegate:self];
        [Theme getTheme].saveInGallery = YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.controller presentViewController:controller animated:YES completion:nil];
        }];
    }
}

- (void)videoButtonGeneralClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *mediaTypes = [NSArray arrayWithObjects: (NSString *)kUTTypeMovie, nil];
        [controller setMediaTypes:mediaTypes];
        controller.allowsEditing = YES;
        controller.videoQuality = UIImagePickerControllerQualityType640x480;
        controller.videoMaximumDuration = 100;
        [controller setDelegate:self];
        [Theme getTheme].saveInGallery = YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.controller presentViewController:controller animated:YES completion:nil];
        }];
    }
}

#pragma clang diagnostic pop
- (void)audioButtonGeneralClicked:(id)sender
{

    AudioRecoderViewController *controller = [self.controller.storyboard instantiateViewControllerWithIdentifier:kAudioRecoderStoryBoardID];
    controller.delegate = self;
    controller.isGallery = YES;
    [Theme getTheme].saveInGallery = YES;

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.controller presentViewController:controller animated:YES completion:^{

        }];
    }];
}

- (void)audioButtonClicked:(id)sender {
    AudioRecoderViewController *controller = [self.controller.storyboard instantiateViewControllerWithIdentifier:kAudioRecoderStoryBoardID];
    controller.delegate = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.controller presentViewController:controller animated:YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControllerDeleagte

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
//    if (_onlyView) {
//        //   UIView *view=[UIView alloc]initWithFrame:CGRectMake(20, 120,, <#CGFloat height#>)
//
//        return;
//    }

    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString: (NSString *) kUTTypeImage])
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[[[APICallManager sharedNetworkSingleton] resizeImage:[info objectForKey:UIImagePickerControllerOriginalImage] toRect:CGRectMake(0, 0, 1024, 768)] CGImage] orientation:(ALAssetOrientation)[[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                NSLog(@"URL : %@", assetURL);
                Media *media = [[Media alloc] initWithType:MediaTypeImage data:nil assetPath:assetURL];
                [self.delegate didFinishPickingMedia:@[media]];

                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    NSLog(@"ALAsset : %@",myasset);
                    NSLog(@"Path : %@",myasset.defaultRepresentation.url);

                };
                // This block will handle errors:
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
                    // Do something to handle the error
                };


                // Use the url to get the asset from ALAssetsLibrary,
                // the blocks that we just created will handle results
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:assetURL
                               resultBlock:resultblock
                              failureBlock:failureblock];

            }
        }];
        if ([self.delegate isKindOfClass:[NewObservationViewController class]]) {
            UIImage * image = [self scaleAndRotateImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            [self.delegate saveImageInDirectory:image];
            [Theme getTheme].saveInGallery = false;
        }
    }else{
        NSString *sourcePath = [info[UIImagePickerControllerMediaURL] relativePath];

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:sourcePath] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"error");
            } else {
            // Deleting File after Save from Temp Directory
                NSURL *fileURL = info[UIImagePickerControllerMediaURL];
                if ([deleteArray containsObject:fileURL]) {
                    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                    [deleteArray removeObject:fileURL];
                }
                NSLog(@"URL : %@", assetURL);
                Media *media = [[Media alloc] initWithType:MediaTypeMovie data:nil assetPath:assetURL];
                [self.delegate didFinishPickingMedia:@[media]];
            }
        }];
        if ([self.delegate isKindOfClass:[NewObservationViewController class]]) {
            NSURL *fileURL = info[UIImagePickerControllerMediaURL];
            [self.delegate saveRecordedVideoInDirectory:fileURL];
        }else {
        // Deleting File after Save from Temp Directory
            NSURL *fileURL = info[UIImagePickerControllerMediaURL];
            [deleteArray addObject:fileURL];
        }
    }
}

#pragma mark - AudioRecoderDelegate

- (void)didFinishRecordingAudioToURL:(NSURL *)recordingURL
{
    if ([Theme getTheme].saveInGallery) {
        [Theme getTheme].saveInGallery = false;
        //        Media *media = [[Media alloc] initWithType:MediaTypeAudio data:[NSData dataWithContentsOfURL:recordingURL] path:[recordingURL path]];
        //        [self.delegate didFinishPickingMedia:@[media]];
    }
    else
    {
        [self.delegate saveAudioInDirectory:recordingURL];

        //        Media *media = [[Media alloc] initWithType:MediaTypeAudio data:[NSData dataWithContentsOfURL:recordingURL] path:[recordingURL path]];
        //        [self.delegate didFinishPickingMedia:@[media]];
    }
}

#pragma mark - WSAssetPickerControllerDelegate

- (void)assetPickerController:(WSAssetPickerController *)pickerController didFinishPickingMediaWithAssets:(NSArray *)assets
{
    NSMutableArray *mediaArray = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
        {
            UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            NSData *data = UIImagePNGRepresentation(img);
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@",[NSDate timeIntervalSinceReferenceDate] * 1000.0,@"png"]];

            [data writeToFile:filePath atomically:YES];

            Media *media = [[Media alloc] initWithType:MediaTypeImage data:data path:filePath];
            [mediaArray addObject:media];

        }
        else if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])
        {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            UIImage *thumbnailImage=[Utils generateThumbImage:[rep url]];
            NSData *pngData = UIImagePNGRepresentation(thumbnailImage);
            NSString *dateTimeName=[NSString stringWithFormat:@"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];

            Byte *buffer = (Byte*)malloc((unsigned int)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned int)rep.size error:nil];

            NSString *thumbnailPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",dateTimeName,@"png"]];

            [pngData writeToFile:thumbnailPath atomically:YES];

            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];

            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.%@",dateTimeName,@"mp4"]];

            [data writeToFile:filePath atomically:YES];

            Media *media = [[Media alloc] initWithType:MediaTypeMovie data:data path:filePath];
            [mediaArray addObject:media];
        }
        else
        {
            // Unknown Media Type
        }
    }
    [self.delegate didFinishPickingMedia:mediaArray];
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

//
//-(UIImage *)generateThumbImage : (NSURL *)url
//{
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//    CMTime time = [asset duration];
//    time.value = 0;
//    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
//    return thumbnail;
//}

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];
}

-(void)popOverInView:(UIView *)view withButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select option"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Gallery", @"Camera",@"Video",@"Audio", nil];
    CGRect rect=[(UIButton *)sender frame];
    rect.origin.y=rect.origin.y+60;
    rect.origin.x=rect.origin.x+20;
    [actionSheet showFromRect:rect inView:view animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{


    if(buttonIndex==0)
        [self galleryButtonClicked:actionSheet];
    else if (buttonIndex==1)
        [self cameraButtonClicked:actionSheet];
    else if(buttonIndex==2)
        [self videoButtonClicked:actionSheet];
    else if(buttonIndex==3)
        [self audioButtonClicked:actionSheet];

    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 300) {
        NSLog(@"From didDismissWithButtonIndex - Selected Color: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{

    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.assets = [NSMutableArray arrayWithArray:assets];
    NSLog(@"%@",self.assets);
    [self.popover dismissPopoverAnimated:YES];

    if (!self.saveInGallery) {

        for (ALAsset *asset in self.assets)
        {

            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo])
            {
                //[self videoUrlPathForAssestURL:asset];
                [self.delegate saveVideoInDirectory:asset.defaultRepresentation.url];

                //                Media *media = [[Media alloc] initWithType:MediaTypeMovie data:nil assetPath:asset.defaultRepresentation.url];
                //                [self.delegate didFinishPickingMedia:@[media]];
            }
            else if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
                [self.delegate saveImageInDirectory:image];
            }
        }
    }
    else
    {
        [Theme getTheme].saveInGallery = false;
    }
}
-(void)videoUrlPathForAssestURL:(ALAsset *)asset{

    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:[[asset defaultRepresentation] url] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        // [self.delegate saveAssestVideoInDirectory:data];
    } failureBlock:^(NSError *err) {
        NSLog(@"Error: %@",[err localizedDescription]);
    }];

}
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    BOOL result = YES;
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {

        ALAssetRepresentation *rep = [asset defaultRepresentation];
        long long filesize = [rep size];
#pragma mark  warning Rewort This
        if (filesize >= (30 * 1024 *1024))
        {
            result = NO;
        }
    }
    return result;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 10)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Please select not more than 10 assets";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            hud.yOffset=280;
        }
        else
        {
            hud.yOffset=400;
        }
        [hud hide:YES afterDelay:1];
        //        UIAlertView *alertView =
        //        [[UIAlertView alloc] initWithTitle:@"Attention"
        //                                   message:@"Please select not more than 10 assets"
        //                                  delegate:nil
        //                         cancelButtonTitle:nil
        //                         otherButtonTitles:@"OK", nil];
        //
        //        [alertView show];
    }

    if (!asset.defaultRepresentation)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Your asset has not yet been downloaded to your device";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;
        [hud hide:YES afterDelay:1];

        //        UIAlertView *alertView =
        //        [[UIAlertView alloc] initWithTitle:@"Attention"
        //                                   message:@"Your asset has not yet been downloaded to your device"
        //                                  delegate:nil
        //                         cancelButtonTitle:nil
        //                         otherButtonTitles:@"OK", nil];
        //
        //        [alertView show];
    }

    return (picker.selectedAssets.count < 10 && asset.defaultRepresentation != nil);
}

-(WYPopoverController *)setPopoverProperties:(WYPopoverController *)popover
{

    popover.theme.tintColor = [UIColor clearColor];
    popover.theme.fillTopColor = [UIColor clearColor];
    popover.theme.fillBottomColor = [UIColor clearColor];

    popover.theme.glossShadowColor = [UIColor clearColor];
    popover.theme.outerShadowColor = [UIColor clearColor];
    popover.theme.outerStrokeColor = [UIColor clearColor];
    popover.theme.innerShadowColor = [UIColor clearColor];
    popover.theme.innerStrokeColor = [UIColor clearColor];
    popover.theme.overlayColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:0.6f];
    popover.delegate=self;
    popover.theme.glossShadowBlurRadius = 0.0f;
    popover.theme.borderWidth = 0.0f;
    popover.theme.arrowBase = 0.0f;
    popover.theme.arrowHeight = 0.0f;
    popover.theme.outerShadowBlurRadius = 0.0f;
    popover.theme.outerCornerRadius = 0.0f;
    popover.theme.minOuterCornerRadius = 0.0f;
    popover.theme.innerShadowBlurRadius = 0.0f;
    popover.theme.innerCornerRadius = 0.0f;
    popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.viewContentInsets = UIEdgeInsetsMake(80, 0, 0, 0);
    popover.wantsDefaultContentAppearance = NO;

    popover.theme.arrowHeight = 0.0f;
    popover.theme.arrowBase = 0;
    return popover;
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {

    int kMaxResolution = 640; // Or whatever

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);


    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;

    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}


+ (BOOL)isDateGreaterThanDate:(NSDate*)greaterDate and:(NSDate*)lesserDate{

    NSTimeInterval greaterDateInterval = [greaterDate timeIntervalSince1970];
    NSTimeInterval lesserDateInterval = [lesserDate timeIntervalSince1970];

    if (greaterDateInterval > lesserDateInterval)
        return YES;

    return NO;
}
+ (NSString *) getMinuteAndHoursFromNSDate :(NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}

- (void) setTimeForButtonWithTag : (NSInteger) tag andValue :(NSString *) value
{

    if (tag==101)
    {
        // button IN
     [self.IN_button.lblName setText:[NSString stringWithFormat:@"IN Time : %@", value]];
    }
    else
    {
        // Button OUT
      [self.OUT_button.lblName setText:[NSString stringWithFormat:@"OUT Time : %@", value]];
    }

    NSString *currentDate = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
    int num = [ChildInOutTime isChildExist:[EYL_AppData sharedEYL_AppData].selectedChild withDate:currentDate context:[AppDelegate context]];
    
    if (num)
    {
        // Delete the existing record and insert the new values
        //[ChildInOutTime deleteRecordForChild:children.childId withDate:currentDate andDetails:dict andContext:context];
        BOOL isUpdated=[ChildInOutTime updateRecord:[AppDelegate context] withChildID:[EYL_AppData sharedEYL_AppData].selectedChild withDate:currentDate withInTimeValue:[self.IN_button.lblName.text substringFromIndex:self.IN_button.lblName.text.length-5] withOutTimeValue:[self.OUT_button.lblName.text substringFromIndex:self.OUT_button.lblName.text.length-5] withUploadFlag:[NSNumber numberWithInt:0]];
        NSLog(@"%hhd",isUpdated);
    }
    else
    {
        NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[EYL_AppData sharedEYL_AppData].selectedChild,@"childid",
                                      currentDate,@"date",
                                      [self.IN_button.lblName.text substringFromIndex:self.IN_button.lblName.text.length-5],@"intime",
                                      self.OUT_button.lblName.text,@"outtime",
                                      @"0", @"uploadedflag",
                                      [NSNumber numberWithInt:[uniqueTabletOIID integerValue]],@"uniqueTableID",nil];
        
        // create new entry for that date
        [ChildInOutTime createChildInOutTimeContext:[AppDelegate context] withDictionary:dict];
    }

}
@end
