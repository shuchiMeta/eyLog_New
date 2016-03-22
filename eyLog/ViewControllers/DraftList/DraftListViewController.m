//
//  DraftListViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "DraftListViewController.h"
#import "DraftLIstCell.h"
#import "Theme.h"
#import "ChildView.h"
#import "NewObservationViewController.h"
#import "MBProgressHUD.h"
#import "APICallManager.h"
#import "Child.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "GroupsViewController.h"
#import "NewObservation.h"
#import "NewObservationAttachment.h"
#import "OBData.h"
#import "OBCoel.h"
#import "GroupFilterAndSearchView.h"
#import "Reachability.h"
#import "EYLNewObservation.h"
#import "Media.h"
#import "DocumentFileHandler.h"
#import "EYLConstant.h"
#import "UIView+Toast.h"
#import "ImageFile.h"
#import "VideoFile.h"
#import "AudioFile.h"

@interface DraftListViewController ()<UITableViewDataSource,UITableViewDelegate,GroupSelectionDelegate,UITextFieldDelegate,WYPopoverControllerDelegate,MBProgressHUDDelegate>
{
    Theme *theme;
    ChildView *containerView;
    GroupFilterAndSearchView *groupSearchView;
    NSMutableArray *observationArray;
    NSMutableArray *groupNames;
    NSMutableArray *observedByNames;
    NSArray *originalArray;
    NSArray *practitionerIDArray;
    BOOL isRefreshing;
    UIRefreshControl *refreshControl;
    BOOL isTypePopOverRect;
    BOOL isObservationPopover;
    NSString * _listType;

    NSString * uploadingPerc;
    NewObservation * newObservationE;
    NSString * observationText;
    float uploadPercentageValue;
    NSString *selectedObserver;
    NSString *statusType;
    NSInteger pageNumber;
    BOOL avoidDoubleInstance;
    OBMedia *media;
}
@property (strong, nonatomic) GroupsViewController *popoverViewController;
@property (strong, nonatomic) WYPopoverController *popover;


@end
AppDelegate *appDelegate;
@implementation DraftListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    theme = [Theme getTheme];
    [theme addToolbarItemsToViewCaontroller:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    theme.onlyView=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDraftList) name:@"refreshDraftList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshUploadQueueAfterUploadedObservation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllHUDD) name:@"NetworkUnreachable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadingPercentage:) name:@"UploadingPercentage" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processingVideo:) name:@"ProcessingVideo" object:nil];
      
   
    //[self getDraftListWithType:@"draft,pending_review"];
    [containerView setHidden:NO];
    [groupSearchView setHidden:NO];


    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;

    containerView=[[[NSBundle mainBundle]loadNibNamed:@"ChildView" owner:self options:nil] objectAtIndex:0];
    containerView.frame=CGRectMake(self.view.frame.size.width-400, 0, 200, 40);
    containerView.firstLabel.text=@"Test";
    [containerView.dateLabel setHidden:YES];
    containerView.childName.hidden = YES;
    containerView.childGroup.hidden = YES;
    containerView.childNotificationLabel.hidden = YES;
    containerView.childImage.hidden = YES;
    containerView.childImageButton.hidden = YES;
    containerView.childDropDown.hidden = YES;
  
  //  [self.navigationController.navigationBar addSubview:containerView];

    [theme resetTargetViewController:self];
    NSLog(@"%@",self.navigationController.navigationBar.subviews);
    
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
//    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
//    {
//        [self.navigationController.navigationBar addSubview:containerView];
//    }

    if(!_isUploadQueue)
        [self.navigationItem setTitle:@"Draft List"];
    else
        [self.navigationItem setTitle:@"Upload Queue"];
    
    avoidDoubleInstance=false;
}

-(void)reloadDraftList{
    [self groupDidSelected:groupSearchView.groupPopup.groupsButton.titleLabel.text withCellType:KCellTypeGroup];
    [self.tableView reloadData];
}

-(void)uploadingPercentage:(NSNotification *)ntfc{

    NSDictionary * dict = [ntfc valueForKey:@"object"];
    uploadingPerc = [NSString stringWithFormat:@"%f",[[dict valueForKey:@"progress"] doubleValue]];
    uploadPercentageValue=[[dict valueForKey:@"progress"] floatValue];
    newObservationE = [dict valueForKey:@"NewObservationEntity"];
    observationText = newObservationE.observation?:@"";
}

//-(void)processingVideo:(NSNotification *)ntfc
//{
//    uploadingPerc = @"Processing Video";
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshUploadQueueAfterUploadedObservation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkUnreachable" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadingPercentage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProcessingVideo" object:nil];


    isTypePopOverRect = NO;
    isObservationPopover = NO;
    [containerView removeFromSuperview];
    [groupSearchView setHidden:YES];
}

-(void)backButtonClick
{
    NSArray * array = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:NO withEditing:NO withUploading:NO withUploaded:NO];
    for (NewObservation * observation in array) {
        NSArray * objects = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withPractitionerId:observation.practitionerId withChildId:observation.childId withObservationId:observation.uniqueTabletOID withIsAdded:NO andIsDeleted:NO];
        for (NewObservationAttachment * attachment in objects) {
            NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:attachment.attachmentPath] stringByAppendingPathComponent:attachment.attachmentName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [DocumentFileHandler removeItemAtPath:filePath];
            }
        }
        [NewObservationAttachment deleteObservationAttachmentInContext:[AppDelegate context] withObject:objects];
    }
    NSLog(@"count %ld",(unsigned long)array.count);

    if (array) {
        [NewObservation deleteObservationInContext:[AppDelegate context] withObject:array];
    }



    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // [self getDraftListWithType:@"draft"];
    
    groupSearchView=[[[NSBundle mainBundle]loadNibNamed:@"GroupFilterAndSearchView" owner:self options:nil] objectAtIndex:0];
    groupSearchView.frame=CGRectMake(60, 5, 355, 34);
    
    [groupSearchView.groupPopup.groupsButton addTarget:self action:@selector(togglePopover:) forControlEvents:UIControlEventTouchUpInside];
    groupSearchView.groupSearch.searchBar.delegate = self;
 
    if (!self.isUploadQueue) {
        [self.navigationController.navigationBar addSubview:groupSearchView];
    }


    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    appDelegate.ObservationFlag=0;

    if(appDelegate.ButtonHideFlag==1)
    {
        self.observationButton.userInteractionEnabled=NO;
        self.TypeButton.userInteractionEnabled =NO;
        [self.observationButton setImage:nil forState:UIControlStateNormal];
        [self.TypeButton setImage:nil forState:UIControlStateNormal];
    }

    uploadingPerc = @"Processing Video";
    
    pageNumber=1;
 
    appDelegate.ObservationFlag=0;
    statusType=@"draft,pending_review,processing";

    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    selectedObserver=@"My";
    isRefreshing = NO;
   [self getDraftListWithType];
}
-(void)refreshData{
    // Temporarily closing this for now
    [self getDraftListWithType];

}
-(void)refreshTable
{
    //    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    hud.labelText = @"Reloading....";
    //
    isRefreshing = YES;

    [self getDraftListWithType];

}

-(void)getDraftListWithType
{
    //_listType = statusType;
    if (!self.isUploadQueue) {
        
        if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Loading..";
        

        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

        NSMutableArray *childIds = [[NSMutableArray alloc] init];
        for (Child *child  in [APICallManager sharedNetworkSingleton].cacheChildren) {
            if (child.childId) {
                [childIds addObject:child.childId];
            }
        }
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        NSString *urlString=[NSString stringWithFormat:@"%@api/observations/lists",serverURL];
        NSLog(@"DraftList URL : %@", urlString);

        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",statusType,@"type",selectedObserver,@"observation_filter",@ "practitioner",@"filter_type", [childIds componentsJoinedByString:@","], @"child_id", @"20", @"per_page", nil];

        NSLog(@"DraftList Parameters : %@",mapData);

        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                if (!isRefreshing) {
                    //  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                    
                }
                else
                {
                    [refreshControl endRefreshing];
                    //  [self performSelector:@selector(hideAllHUDD) withObject:nil afterDelay:1.0f];
                }

               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];

                return;
            }
            if (!isRefreshing) {
                //  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
            }
            else
            {
                [refreshControl endRefreshing];
                isRefreshing = NO;
                // [self performSelector:@selector(hideAllHUDD) withObject:nil afterDelay:1.0f];

            }

            [self performSelectorOnMainThread:@selector(backgroundLoadData:) withObject:data waitUntilDone:YES];
        }];

        [postDataTask resume];
        }
        else{
            //[observationArray removeAllObjects];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [refreshControl endRefreshing];
            
            [self.tableView reloadData];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

    }
    else
    {
        [self loadObservationList];
        if (isRefreshing) {
            [refreshControl endRefreshing];
            isRefreshing = NO;
            //  [self performSelector:@selector(hideAllHUDD) withObject:nil afterDelay:1.0f];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }

}
-(void)hideAllHUDD{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)getDraftMedia:(NSNumber *)observationId withUUID:(NSString *)uuid forViewController:(NewObservationViewController *)controller
{
    NSLog(@"%@",observationId);

    UIViewController *topVC = self.navigationController;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hud.labelText=@"Downloading Observation Media...";

    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

    //    NSString *serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *serverURL = [APICallManager sharedNetworkSingleton].serverURL;


    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%@/thumbnails",serverURL,observationId];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword, @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];


    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                              if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"]) {
                                                  NSLog(@"No Media Found.");

                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      UIViewController *topVC = self.navigationController;
                                                      [MBProgressHUD hideHUDForView:topVC.view animated:YES];
                                                      for(UIView *view in self.view.subviews)
                                                      {
                                                          if([view isKindOfClass:[MBProgressHUD class]])
                                                          {
                                                              MBProgressHUD *hud=(MBProgressHUD *)view;
                                                              [hud removeFromSuperview];
                                                              hud=nil;
                                                              
                                                          }
                                                      }
                                                      [self.navigationController pushViewController:controller animated:YES];
                                                  });

                                                  return;
                                              }

                                              NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/DraftMedia.zip"];
                                              NSString *staffFolder=[[Utils getDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[Utils getDraftMediaImages],uuid]];

                                              if([data writeToFile:yourArtPath atomically:YES])
                                              {

                                                  if([SSZipArchive unzipFileAtPath:yourArtPath toDestination:staffFolder])
                                                  {
                                                      NSLog(@"Successfully unarchived Observation Media");

                                                      NSError * error;
                                                      NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:staffFolder error:&error];

                                                      for (NSString *path in directoryContents) {
                                                          NSLog(@"%@", path);
                                                      }

                                                      dispatch_async(dispatch_get_main_queue(), ^{

                                                          UIViewController *topVC = self.navigationController;
                                                          [MBProgressHUD hideHUDForView:topVC.view animated:YES];
                                                          for(UIView *view in self.view.subviews)
                                                          {
                                                              if([view isKindOfClass:[MBProgressHUD class]])
                                                              {
                                                                  MBProgressHUD *hud=(MBProgressHUD *)view;
                                                                  [hud removeFromSuperview];
                                                                  hud=nil;
                                                                  
                                                              }
                                                          }
                                                          [self.navigationController pushViewController:controller animated:YES];
                                                      });
                                                  }
                                              }
                                              else
                                              {
                                                  NSLog(@"Error while unarchiving Observation Media");
                                              }
                                          }];

    [postDataTask resume];

}

-(void)getDraftMediaFromURL:(OBData *)data forViewController:(NewObservationViewController *)controller
{
    NSString *observationId = data.observationId;

    NSLog(@"%@",observationId);

    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

    for (int i=0; i<data.media.images.count; i++)
    {
        NSString *urlString = data.media.images[i];

        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword, @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];

        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {
                                                  NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                                                  NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                  if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"]) {
                                                      NSLog(@"No Media Found.");
                                                      return;
                                                  }

                                              }];

        [postDataTask resume];
    }

    for (int i=0; i<data.media.videos.count; i++)
    {
        NSString *urlString = data.media.videos[i];

        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword, @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];

        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"]) {
                NSLog(@"No Media Found.");
                return;
            }

            NSString *staffFolder=[Utils getDraftMediawithObservationID:observationId];

            NSString *mediaName = [NSString stringWithFormat:@"video%d.mp4",i];
            if([data writeToFile:[staffFolder stringByAppendingPathComponent:mediaName] atomically:YES])
            {
                NSLog(@"%@ video stored at path : %@",mediaName,staffFolder);

                NSURL *fileURL = [NSURL URLWithString:[staffFolder stringByAppendingPathComponent:mediaName]];
                UIImage *thumbnailImage=[Utils generateThumbImage:fileURL];
                NSData *pngData = UIImagePNGRepresentation(thumbnailImage);
                NSString *thumbnailPath = [[[staffFolder stringByAppendingPathComponent:mediaName] stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
                NSLog(@"Thumbnail Path : %@",thumbnailPath);

                [self.delegate refreshMediaCell];
            }
            else
            {
                NSLog(@"Error writing Video Media");
            }
        }];

        [postDataTask resume];
    }

    for (int i=0; i<data.media.audios.count; i++)
    {
        NSString *urlString = data.media.audios[i];

        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword, @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];

        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {
                                                  NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                                                  NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                  if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"]) {
                                                      NSLog(@"No Media Found.");
                                                      return;
                                                  }
                                              }];

        [postDataTask resume];
    }

}

- (IBAction)practitionerProfileAction:(id)sender
{

    //    if (!self.popover)
    //    {
    self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
    self.popoverViewController.delegate = self;
    self.popoverViewController.cellType=KCellTypePractitioner;

    self.popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];
    self.popover.delegate = self;
    self.popover.theme.tintColor = [UIColor clearColor];
    self.popover.theme.fillTopColor = [UIColor clearColor];
    self.popover.theme.fillBottomColor = [UIColor clearColor];
    self.popover.theme.glossShadowColor = [UIColor clearColor];
    self.popover.theme.outerShadowColor = [UIColor clearColor];
    self.popover.theme.outerStrokeColor = [UIColor clearColor];
    self.popover.theme.innerShadowColor = [UIColor clearColor];
    self.popover.theme.innerStrokeColor = [UIColor clearColor];
    self.popover.theme.overlayColor = [UIColor clearColor];
    self.popover.theme.glossShadowBlurRadius = 0.0f;
    self.popover.theme.borderWidth = 0.0f;
    self.popover.theme.arrowBase = 0.0f;
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.outerShadowBlurRadius = 0.0f;
    self.popover.theme.outerCornerRadius = 0.0f;
    self.popover.theme.minOuterCornerRadius = 0.0f;
    self.popover.theme.innerShadowBlurRadius = 0.0f;
    self.popover.theme.innerCornerRadius = 0.0f;
    self.popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.wantsDefaultContentAppearance = NO;
    self.popover.popoverContentSize = CGSizeMake(130, 180);
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.arrowBase = 0;
    self.popoverViewController.tableView.scrollEnabled=NO;
    self.popoverViewController.dataArray=@[@"All",@"Draft",@"Pending Review",@"Processing"];


    [self typePopOverRect];
}
-(void)typePopOverRect{
    isTypePopOverRect = YES;
    isObservationPopover = NO;
    CGRect rect;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        rect = CGRectMake(770, 145, 0, 0);
    }
    else{
        rect = CGRectMake(1020, 145, 0, 0);
    }
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:NO];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    containerView.hidden=YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (isTypePopOverRect) {
        [self typePopOverRect];
    }
    else if(isObservationPopover){
        [self observationByPopOverRect];
    }
    [UIView animateWithDuration:0.0 animations:^{
        containerView.frame=CGRectMake(self.view.frame.size.width-400, 0, 400, 40);
        containerView.hidden=NO;
    }];


}
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController{
    isTypePopOverRect = NO;
    isObservationPopover = NO;
}
- (IBAction)observationByAction:(id)sender {

    //    if (!self.popover)
    //    {
    self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
    self.popoverViewController.delegate = self;
    self.popoverViewController.cellType=KCellTypeObservationBy;
  //  self.popoverViewController.dataArray=[observedByNames mutableCopy];
    self.popoverViewController.dataArray=[NSArray arrayWithObjects:@"My Observations",@"All Observations",@"Parent Observations",nil];

    self.popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];
    self.popover.delegate = self;
    self.popover.theme.tintColor = [UIColor clearColor];
    self.popover.theme.fillTopColor = [UIColor clearColor];
    self.popover.theme.fillBottomColor = [UIColor clearColor];
    self.popover.theme.glossShadowColor = [UIColor clearColor];
    self.popover.theme.outerShadowColor = [UIColor clearColor];
    self.popover.theme.outerStrokeColor = [UIColor clearColor];
    self.popover.theme.innerShadowColor = [UIColor clearColor];
    self.popover.theme.innerStrokeColor = [UIColor clearColor];
    self.popover.theme.overlayColor = [UIColor clearColor];
    self.popover.theme.glossShadowBlurRadius = 0.0f;
    self.popover.theme.borderWidth = 0.0f;
    self.popover.theme.arrowBase = 0.0f;
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.outerShadowBlurRadius = 0.0f;
    self.popover.theme.outerCornerRadius = 0.0f;
    self.popover.theme.minOuterCornerRadius = 0.0f;
    self.popover.theme.innerShadowBlurRadius = 0.0f;
    self.popover.theme.innerCornerRadius = 0.0f;
    self.popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.wantsDefaultContentAppearance = NO;
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.popoverContentSize = CGSizeMake(150, 135);
    self.popoverViewController.tableView.scrollEnabled=NO;
    self.popover.theme.arrowBase = 0;

    [self observationByPopOverRect];
}
-(void)observationByPopOverRect{
    isTypePopOverRect = NO;
    isObservationPopover = YES;
    CGRect rect;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        rect = CGRectMake(570, 0, 0, 0);
    }
    else{
        rect = CGRectMake(890, 65, 0, 0);
    }
    CGRect rect1 = rect;
    rect1.origin.y += 55+44;
   //15+55+441

    [self.popover presentPopoverFromRect:rect1 inView:self.navigationController.navigationBar permittedArrowDirections:WYPopoverArrowDirectionAny animated:NO];

}
- (IBAction)togglePopover:(UIButton *)sender
{
    NSLog(@"Toggle Popover");
    //    if (!self.popover)
    //    {
    self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
    self.popoverViewController.delegate = self;
    self.popoverViewController.dataArray=[groupNames mutableCopy];
    self.popoverViewController.cellType=KCellTypeGroup;

    _popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];

    self.popover.theme.tintColor = [UIColor clearColor];
    self.popover.theme.fillTopColor = [UIColor clearColor];
    self.popover.theme.fillBottomColor = [UIColor clearColor];
    self.popover.theme.glossShadowColor = [UIColor clearColor];
    self.popover.theme.outerShadowColor = [UIColor clearColor];
    self.popover.theme.outerStrokeColor = [UIColor clearColor];
    self.popover.theme.innerShadowColor = [UIColor clearColor];
    self.popover.theme.innerStrokeColor = [UIColor clearColor];
    self.popover.theme.overlayColor = [UIColor clearColor];
    self.popover.theme.glossShadowBlurRadius = 0.0f;
    self.popover.theme.borderWidth = 0.0f;
    self.popover.theme.arrowBase = 0.0f;
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.outerShadowBlurRadius = 0.0f;
    self.popover.theme.outerCornerRadius = 0.0f;
    self.popover.theme.minOuterCornerRadius = 0.0f;
    self.popover.theme.innerShadowBlurRadius = 0.0f;
    self.popover.theme.innerCornerRadius = 0.0f;
    self.popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.wantsDefaultContentAppearance = NO;
    //        self.popover.popoverContentSize = CGSizeMake(230, 350);
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.arrowBase = 0;
    //    }
    int height=0;
    for (int count=0;count<self.popoverViewController.dataArray.count; count++)
    {
        height=height+45;
          self.popoverViewController.tableView.scrollEnabled=NO;
    }

   if(height>self.view.frame.size.height/2)
   {
       height=self.view.frame.size.height/2;
         self.popoverViewController.tableView.scrollEnabled=YES;
   }

    self.popover.popoverContentSize = CGSizeMake(230, height);
  
    CGRect rect = sender.frame;
    rect.origin.y += 15;
    rect.origin.x += 60;
    [self.popover presentPopoverFromRect:rect inView:self.navigationController.navigationBar permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

-(void)closeAlert
{
    UIViewController *topVC = self.navigationController;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
}

-(void)loadObservationList
{
    NSArray *data = [NewObservation fetchALLObservationsInContext:[AppDelegate context] andReadyForUpload:YES];
    NSMutableArray *temp = [[NSMutableArray alloc] init];

    for (NewObservation *observation in data) {
        OBData *obData = [[OBData alloc] init];
        obData.childId = observation.childId.stringValue;
        obData.ageMonths = observation.childAge;
        obData.observationBy = observation.observedBy;
        obData.observationText = observation.observation;
        obData.observerId = observation.practitionerId.stringValue;
       
        obData.observationId = [NSString stringWithFormat:@"%@",observation.observationId];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        obData.dateTime = [formatter stringFromDate:observation.observationCreatedAt];
        obData.mode = observation.mode;
        obData.uniqueTabletOID = observation.uniqueTabletOID;
        if (observation.readyForUpload) {
            if (obData) {
                [temp addObject:obData];
            }
        }
    }
    observationArray = temp;
}

-(void)backgroundLoadData:(NSData *)data
{
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Draft List Response JSON : %@", jsonDict);
    OBObservation *observation=[[OBObservation alloc]initWithDictionary:jsonDict];

    if([observation.status isEqualToString:@"success"])
    {
        observationArray=[observation.data mutableCopy];
        originalArray = [observationArray copy];

        groupNames = [[NSMutableArray alloc] init];
        observedByNames = [[NSMutableArray alloc] init];

        [groupNames addObject:@"All Groups"];
        [observedByNames addObject:@"All"];

        for (int i=0; i<[observationArray count]; i++)
        {
            OBData * obData = (OBData *)[observationArray objectAtIndex:i];
            NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[obData.childId integerValue]]];
            Child * child = [childArray firstObject];
            //    child.ageMonths = [NSString stringWithFormat:@"%@",obData.ageMonths];
            //   NSError *error = nil;
            //   [[AppDelegate context] save:&error];

            [self createNewObservation:obData withChild:child];
            NSString *tmpGroupName = child.groupName;
            if( tmpGroupName != nil && ![tmpGroupName isEqualToString:@""])
            {
                if (![groupNames containsObject:tmpGroupName]) {
                    [groupNames addObject:tmpGroupName];
                }
            }
            NSString *tmpObservedByName = obData.observationBy;
            if( tmpObservedByName != nil && ![tmpObservedByName isEqualToString:@""])
            {
                if (![observedByNames containsObject:tmpObservedByName]) {
                    [observedByNames addObject:tmpObservedByName];
                }
            }
        }

        // to store the contnets into orignal array after items currently in upload queue are removed
        originalArray = [observationArray copy];
        
//        if([selectedObserver caseInsensitiveCompare:@"All Observations"]==NSOrderedSame)
//        {
//            observationArray=[originalArray copy];
//        }
//        else if ([selectedObserver caseInsensitiveCompare:@"My Observations"]==NSOrderedSame){
//                  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//                     for (OBData *observationItr in originalArray) {
//                            if([[APICallManager sharedNetworkSingleton].cachePractitioners.name caseInsensitiveCompare:observationItr.observationBy]==NSOrderedSame)
//                            {
//                                if (observationItr) {
//                                    [tempArray addObject:observationItr];
//                                }
//                   }
//            }
//            observationArray = tempArray;
//        }
//        else
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            for (OBData *observationItr in originalArray) {
//                if([selectedObserver caseInsensitiveCompare:observationItr.observationBy]==NSOrderedSame)
//                {
//                    if (observationItr) {
//                        [tempArray addObject:observationItr];
//                    }
//                    
//                }
//            }
//            observationArray = tempArray;
//        }
       

        [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
-(void)createNewObservation:(OBData *)obData withChild:(Child *)child{

    NSString * practitionersName = [NSString stringWithFormat:@"%@ %@",[APICallManager sharedNetworkSingleton].cachePractitioners.firstName, [APICallManager sharedNetworkSingleton].cachePractitioners.lastName];
    NSString * apiKey = [APICallManager sharedNetworkSingleton].apiKey;
    NSString * apiPassword = [APICallManager sharedNetworkSingleton].apiPassword;
    NSString * practitionerPin = [APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;

    NewObservation * newwObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:obData.uniqueTabletOID];
      if (!newwObservation.readyForUpload && newwObservation) {
        [NewObservation deleteObservationInContext:[AppDelegate context] withObject:@[newwObservation]];
        newwObservation = nil;
    }

    if (!newwObservation) {

        // TODO : Pass montessori data from the server

        [NewObservation createNewObservationInContext:[AppDelegate context] withPractitionerId:practitionerId withChildId:child.childId withObservation:obData.observationText withAnalysis:obData.analysis withNextSteps:obData.nextSteps withAdditionalNotes:obData.comments withChildAge:nil withChildName:[NSString stringWithFormat:@"%@ %@",child.firstName,child.lastName] withObservationCreatedAt:[Utils getDateFromString:obData.dateTime] withObservedBy:obData.observationBy withPractitionerName:practitionersName withApiKey:apiKey withApiPassword:apiPassword withPractitionerPin:practitionerPin withObservationId:@([obData.observationId intValue]) withMode:obData.mode withQuickObservation:[NSNumber numberWithBool:obData.quickObservationTag] withScaleInvolvement:@([obData.scaleInvolvement integerValue]) withScaleWellBeing:@([obData.scaleWellBeing integerValue]) withEcatAssessmentLevel:nil withEcatAssessment:obData.ecatAssessment withCoel:obData.coel withEyfsStatement:obData.eyfs withEyfsAgeBand:nil withMontessori:obData.montessori withCfe:obData.cfe withEcat:obData.ecat withUniqueTabletOID:obData.uniqueTabletOID isReadyForUpload:NO isEditing:NO isUploading:NO isUploaded:NO withchecksums:nil withChildIdarray:[NSData new]withInternalNotes:obData.strInternalNotes];
        
    }
    else{
        if (newwObservation.readyForUpload) {
            [observationArray removeObject:obData];
        }
    }
    NSArray * allObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:NO withEditing:NO withUploading:NO withUploaded:NO];
    NSLog(@"count %lu",(unsigned long)allObservation.count);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)setEdgesForExtendedLayout
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return observationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *draftListCellId = @"DraftListCellID";

    DraftLIstCell *cell = [tableView dequeueReusableCellWithIdentifier:draftListCellId];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DraftLIstCell" owner:self options:nil] lastObject];
    }

    NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[((OBData *)[observationArray objectAtIndex:indexPath.row]).childId integerValue]]];

    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],((Child *)[childArray objectAtIndex:0]).photo];
    UIImage *childrenImage=[UIImage imageWithContentsOfFile:imagePath];
    if(childrenImage==nil)
    {
        NSLog(@"%@",[UIImage imageNamed:@"eylog_Logo"]);
        
        cell.childImageView.image=[UIImage imageNamed:@"eylog_Logo"];
        
    }
    else
    {
          cell.childImageView.image=childrenImage;
    }
    //        dispatch_async(dispatch_get_main_queue(), ^{
      //        });
    //    });
    Child * child = [childArray objectAtIndex:0];
    NSString *Fname =child.firstName;
    NSString *Lname =child.lastName;
    NSString *Name =[NSString stringWithFormat:@"%@ %@",Fname,Lname];
    cell.childName.text =Name;
    cell.childAge.text = [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:child.ageMonths],child.groupName.length>0?[NSString stringWithFormat:@", %@",child.groupName]:@""];

    cell.observationBy.text=((OBData *)[observationArray objectAtIndex:indexPath.row]).observationBy;
    cell.observationText.text=((OBData *)[observationArray objectAtIndex:indexPath.row]).observationText;

    NSArray *dateArray=[[Utils getValidDateString:((OBData *)[observationArray objectAtIndex:indexPath.row]).dateTime] componentsSeparatedByString:@" "];

    // code hack
    NSString *tempTypeString = ((OBData *)[observationArray objectAtIndex:indexPath.row]).mode;
    if([tempTypeString isEqualToString:@"draft"])
    {
        tempTypeString = [NSString stringWithFormat:@"Draft"];
    }

    if([tempTypeString isEqualToString:@"pending_review"])
    {
        tempTypeString = [NSString stringWithFormat:@"Pending Review"];
    }

    if([tempTypeString isEqualToString:@"pending"])
    {
        tempTypeString = [NSString stringWithFormat:@"Pending Review"];
    }

    if([tempTypeString isEqualToString:@"processing"])
    {
        tempTypeString = [NSString stringWithFormat:@"Processing"];
    }

    if([tempTypeString isEqualToString:@"submitted"])
    {
        tempTypeString = [NSString stringWithFormat:@"Published"];
    }

    cell.observationType.text= tempTypeString;
    NSLog(@"cell.observationType.text %@",cell.observationType.text);


    cell.observationDate.text=[dateArray objectAtIndex:0];
    cell.observationTime.text=[dateArray objectAtIndex:1];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(BOOL)createNewObservationAttachmentWithObdata:(OBData *)obData andChild:(Child *)child{

    NSArray * attachments = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withObservationId:obData.uniqueTabletOID];
    [attachments enumerateObjectsUsingBlock:^(NewObservationAttachment *obj, NSUInteger idx, BOOL *stop) {
        [[AppDelegate context] deleteObject:obj];
        [[AppDelegate context] save:nil];
    }];
    attachments = nil;
    if (attachments.count == 0) {

        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

        // NSString *serverURL=@"https://demo.eylog.co.uk/trunk/";
        NSString *serverURL = [APICallManager sharedNetworkSingleton].serverURL;


        NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%@/thumbnails",serverURL,obData.observationId];
        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword, @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];

        NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/DraftMedia.zip"];
        NSString *staffFolder= [NSString stringWithFormat:@"%@%@",[Utils getDraftMediaImages],obData.observationId];

        NSURLRequest *request = [[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString];
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *zipData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary *jsonDict = nil;
        if (zipData.length > 0) {
            jsonDict =[NSJSONSerialization JSONObjectWithData:zipData options:0 error:nil];
        }else {
            if (zipData.length == 0 && error) {
                return NO;
            }
        }

        if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"]) {
            return YES;
        }else {
            [zipData writeToFile:yourArtPath atomically:YES];
            BOOL b = [SSZipArchive unzipFileAtPath:yourArtPath toDestination:staffFolder];
            if (b) {
                NSLog(@"Yes");
            }else{
                NSLog(@"No");
            }
        }
        for (int i = 0; i < [obData.media.images count]; i++) {

            NSData * data = nil;//[NSData dataWithContentsOfURL:[NSURL URLWithString:[obData.media.images objectAtIndex:i]]];

            NSString * attachmentName = [DocumentFileHandler getFileNameWithExtension:@"png"];
            NSString * attachmentPath = [DocumentFileHandler getObservationImagesPathForChildId:[NSString stringWithFormat:@"%@",child.childId]];
            NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:attachmentPath] stringByAppendingPathComponent:attachmentName];

            // NSString * fileName = [

            [data writeToFile:filePath atomically:YES];

            ImageFile * imageFile = [obData.media.images objectAtIndex:i];

            // Temporary hack to adapt to different url on cloud and local server
            NSString *tempImagePath = [[imageFile.url componentsSeparatedByString:@"?"]firstObject];

            NSString *filePathTemp = [staffFolder stringByAppendingPathComponent:[tempImagePath lastPathComponent]];
            filePathTemp = [filePathTemp stringByReplacingOccurrencesOfString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] withString:[NSString string]];
            [NewObservationAttachment createChildInContext:[AppDelegate context] withPractitionerId:practitionerId withChildId:child.childId withAttachmentName:attachmentName withAttachmentType:kUTTypeImageType withAttachmentPath:attachmentPath withObservationId:obData.uniqueTabletOID withIsAdded:NO withIsDeleted:NO withFilePath:imageFile.url withThumbnailPath:filePathTemp withDeletePath:imageFile.name];

        }
        for (int i = 0; i < [obData.media.videos count]; i++) {
            NSData * data = nil;//[NSData dataWithContentsOfURL:[NSURL URLWithString:[obData.media.videos objectAtIndex:i]]];

            NSString * attachmentName = [DocumentFileHandler getFileNameWithExtension:@"mp4"];
            NSString * attachmentPath = [DocumentFileHandler getObservationVideosPathForChildId:[NSString stringWithFormat:@"%@",child.childId]];
            NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:attachmentPath] stringByAppendingPathComponent:attachmentName];

            [data writeToFile:filePath atomically:YES];

            VideoFile * videoFile = [obData.media.videos objectAtIndex:i];


            NSString *filePathTemp = [staffFolder stringByAppendingPathComponent:[[[videoFile.url lastPathComponent] stringByDeletingPathExtension]stringByAppendingPathExtension:@"jpg"]];
            filePathTemp = [filePathTemp stringByReplacingOccurrencesOfString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] withString:[NSString string]];

            [NewObservationAttachment createChildInContext:[AppDelegate context] withPractitionerId:practitionerId withChildId:child.childId withAttachmentName:attachmentName withAttachmentType:kUTTypeVideoType withAttachmentPath:attachmentPath withObservationId:obData.uniqueTabletOID withIsAdded:NO withIsDeleted:NO withFilePath:videoFile.url withThumbnailPath:filePathTemp withDeletePath:videoFile.name];


        }
        for (int i = 0; i < [obData.media.audios count]; i++) {
            NSData * data = nil;//[NSData dataWithContentsOfURL:[NSURL URLWithString:[obData.media.audios objectAtIndex:i]]];

            NSString * attachmentName = [DocumentFileHandler getFileNameWithExtension:@"m4a"];
            NSString * attachmentPath = [DocumentFileHandler getObservationAudiosPathForChildId:[NSString stringWithFormat:@"%@",child.childId]];
            NSString * filePath = [[DocumentFileHandler setDocumentDirectoryforPath:attachmentPath] stringByAppendingPathComponent:attachmentName];

            [data writeToFile:filePath atomically:YES];

            AudioFile * audioFile = [obData.media.audios objectAtIndex:i];

            NSString *filePathTemp = [staffFolder stringByAppendingPathComponent:[audioFile.url lastPathComponent]];
            filePathTemp = [filePathTemp stringByReplacingOccurrencesOfString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] withString:[NSString string]];

            [NewObservationAttachment createChildInContext:[AppDelegate context] withPractitionerId:practitionerId withChildId:child.childId withAttachmentName:attachmentName withAttachmentType:kUTTypeAudioType withAttachmentPath:attachmentPath withObservationId:obData.uniqueTabletOID withIsAdded:NO withIsDeleted:NO withFilePath:audioFile.url withThumbnailPath:filePathTemp withDeletePath:audioFile.name];

        }
    }
    return YES;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isUploadQueue){
        if (observationArray.count<18) {
           // [self.view makeToast:@"No more content" duration:<#(NSTimeInterval)#> position:<#(id)#>]
            return;
        }
    if (indexPath.row == [observationArray count]-1) {
        // This is the last cell
       // [self loadMore];
       // [self getDraftListContentMore];
    }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    NewObservationViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewObservationIdentifier"];
    DraftLIstCell *temp = (DraftLIstCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([temp.observationType.text isEqualToString:@"Processing"])
    {
         controller.isProcessingMedia=YES;
         controller.isEditingAllowed = NO;

//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Observation is being processed on the server and cannot be opened";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        [hud hide:YES afterDelay:2];
        //[self.view makeToast:@"Observation is being processed on the server and cannot be opened"];
       // [self.view makeToast:@"Observation is being processed on the server and cannot be opened" duration:1.0f position:CSToastPositionBottom];
       // return;
    }
    else{
     controller.isEditView=YES;
    }
    

   
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    
    
    // Just to avoid intentionally multiple click on cell within a seccond.(Upload Queue)
    // Reason reading data from core data need some time in executing fetch request.
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"Seconds --------> %f",[[NSDate date] timeIntervalSinceDate: app.draftInterval]);
    float sec=[[NSDate date] timeIntervalSinceDate:app.draftInterval];
    if (sec<0.7) {
        NSLog(@"Return ");
        app.draftInterval=[NSDate date];
        return;
    }
    app.draftInterval=[NSDate date];
    
    NSArray *childArray;
    OBData *obData;
    if ([observationArray objectAtIndex:indexPath.row]) {
    
    obData = (OBData *)[observationArray objectAtIndex:indexPath.row];
        
        
        
    childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[obData.childId integerValue]]];
    }else{
        return;
    }
    [APICallManager sharedNetworkSingleton].cacheChild = [childArray objectAtIndex:0];
    if(_isUploadQueue)
    {
        if ([[APICallManager sharedNetworkSingleton]isNetworkReachable]) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"Observations are being uploaded and cannot be edited";
            NSString *title=@"Observation is being uploaded and cannot be edited";
            NSString *progressText;
            //DraftLIstCell *
            temp = (DraftLIstCell *)[tableView cellForRowAtIndexPath:indexPath];

        if (observationText.length >0)
        {
            progressText = @"Currently Processing ";
            progressText = [progressText stringByAppendingString:observationText.length > 8?[observationText substringToIndex:8]:observationText];
            progressText = [progressText stringByAppendingFormat:@" %.2f%%", [uploadingPerc doubleValue]*100.0f];
            //hud.detailsLabelText = progressText;
            [self.view makeToast:progressText duration:1.0f position:CSToastPositionBottom title:title];
            }
                        // Hack Hack : So that when no observation is in queue it show the percentage for the last one started with its own observation text
        else if(temp.observationText.text.length > 0)
        {
             progressText = [NSString stringWithFormat:@"Currently processing %@ %0.2f%%",temp.observationText.text.length > 8?[temp.observationText.text substringToIndex:8]:temp.observationText.text,[uploadingPerc doubleValue]*100.0f];
            [self.view makeToast:progressText duration:1.0f position:CSToastPositionBottom title:title];
                        }


//            hud.margin = 10.f;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            [hud hide:YES afterDelay:2];
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
            return;
        }else {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"Observations are being uploaded and cannot be edited";
//            hud.margin = 10.f;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            [hud hide:YES afterDelay:3];
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
//            return;
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"uploadEntity"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"uploadEntity"] isEqualToString:obData.uniqueTabletOID]) {
            
            [self.view makeToast:@"This Observation is partially uploaded so cannot be Edited." duration:1.0f position:CSToastPositionBottom];
            return;
        }
    }
    
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable] == FALSE || _isUploadQueue == FALSE) {

        if ([newObservationE.uniqueTabletOID isEqualToString:obData.uniqueTabletOID]) {
        if (uploadPercentageValue>.01) {

//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"This Observation is partially uploaded so cannot be Edited.";
//            hud.margin = 10.f;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            [hud hide:YES afterDelay:3];
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
            [self.view makeToast:@"This Observation is partially uploaded so cannot be Edited." duration:1.0f position:CSToastPositionBottom];
        }
            return;
        }
        
        if (!avoidDoubleInstance) {
            avoidDoubleInstance=YES;
        }else{
            return;
        }
        if([temp.observationType.text isEqualToString:@"Pending Review"])
        {
            if([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]==0)
            {
                controller.isEditingAllowed = NO;
            
            }
            else
            {
                 controller.isEditingAllowed = YES;
            }
        }
        else
        {
        //isEditingAllowed
            controller.isEditingAllowed = YES;

    
        }
       // controller.isUploadQueue = _isUploadQueue;
        controller.isEditView = YES;
        controller.isUploadQueue=NO;
        controller.childIdParam = [NSNumber numberWithInteger:[obData.childId integerValue]];
        controller.practitionerIdParam = [NSNumber numberWithInteger:[obData.observationId integerValue]];
        controller.observerID= [NSNumber numberWithInteger:[obData.observerId integerValue]];

        self.delegate = controller;
        if (obData.media.images.count >0 || obData.media.videos.count >0 || obData.media.audios.count >0) {

            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText = @"Downloading Media Files.....";

            dispatch_group_t group = dispatch_group_create();
            __block BOOL isNoError = YES;
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
                // block1
            });
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
                // block2
                isNoError = [self createNewObservationAttachmentWithObdata:obData andChild:[childArray firstObject]];
                if (!isNoError) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        [observationArray removeAllObjects];
                        [tableView reloadData];
                    });
                    return;
                }
            });
            dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
                // block3
                NSLog(@"Block3");
                if (isNoError) {
                    NewObservation * newObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:obData.uniqueTabletOID];
                    media=obData.media;
                    
                    
                    if (newObservation) {
                        controller.eylNewObservation = [self populateDataInEylNewObservation:newObservation];
                    }
                    [self pushToViewController:controller];
                }
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            });
        }
        else{
            NewObservation * newObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:obData.uniqueTabletOID];
            if (newObservation) {
                controller.eylNewObservation = [self populateDataInEylNewObservation:newObservation];
            }
            for(UIView *view in self.view.subviews)
            {
                if([view isKindOfClass:[MBProgressHUD class]])
                {
                    MBProgressHUD *hud=(MBProgressHUD *)view;
                    [hud removeFromSuperview];
                    hud=nil;
                    
                }
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }

}
-(void)pushToViewController:(NewObservationViewController *)controller{
    NSLog(@"%@", self.navigationController.viewControllers);
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:controller animated:YES];
}
-(EYLNewObservation *)populateDataInEylNewObservation:(NewObservation *)newObservation{
    
    EYLNewObservation * eylNewObservation = [[EYLNewObservation alloc]init];
    [eylNewObservation populateDataWithNewObservation:newObservation];
    eylNewObservation.media=media;
    
    return eylNewObservation;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isUploadQueue) {

        // Edited by : Ankit Khetrapal
        // So that even if the observations are being uploaded they can be deleted and removed
        if([Reachability reachabilityForInternetConnection].isReachable)// || [APICallManager sharedNetworkSingleton].uploadTask)
        {

//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"Observations are being uploaded and cannot be Deleted.";
//            hud.margin = 10.f;
//            hud.userInteractionEnabled=TRUE;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            [hud hide:YES afterDelay:2];
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
         //   [self.view makeToast:@"Observations are being uploaded and cannot be Deleted."];
            [self.view makeToast:@"Observations are being uploaded and cannot be Deleted." duration:1.0f position:CSToastPositionBottom];
            [tableView reloadData];

            return;
        }

        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;

        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];

        OBData *data = ((OBData *)[observationArray objectAtIndex:indexPath.row]);

        if ([data.observerId isEqualToString:practitionerId.stringValue])
        {
            NewObservation *tmpObservation = [[NewObservation fetchObservationInContext:[AppDelegate context] withPractitionerId:[numberFormatter numberFromString:data.observerId] withChildId:[numberFormatter numberFromString:data.childId] withDeviceUUID:data.uniqueTabletOID] lastObject];

            NSArray *tmpAttachments = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withPractitionerId:[numberFormatter numberFromString:data.observerId] withChildId:[numberFormatter numberFromString:data.childId] withObservationId:data.uniqueTabletOID];

            [NewObservationAttachment deleteObservationAttachmentInContext:[AppDelegate context] withObject:tmpAttachments];
            if (tmpObservation) {
                [NewObservation deleteObservationInContext:[AppDelegate context] withObject:@[tmpObservation]];
            }

            [observationArray removeObjectAtIndex:indexPath.row];

            // Edited by : Ankit Khetrapal
            // Once the item is deleted its assosciated upload call should also be removed
            if([APICallManager sharedNetworkSingleton].uploadTask)
            {
                [[APICallManager sharedNetworkSingleton].uploadTask cancel];
                [APICallManager sharedNetworkSingleton].uploadTask = nil;
            }
        }
        else
        {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"You cannot delete observation created by other Practitioners.";
//            hud.margin = 10.f;
//            hud.userInteractionEnabled=YES;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
//            [hud hide:YES afterDelay:2];
            [self.view makeToast:@"You cannot delete observation created by other Practitioners." duration:1.0f position:CSToastPositionBottom];
        }

        [tableView reloadData];

    }
    else
    {
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

        OBData *selDraft = ((OBData*)observationArray[indexPath.row]);

        if ([selDraft.observerId isEqualToString:practitionerId.stringValue])
        {

            UIViewController *topVC = self.navigationController;
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
            hud.labelText=@"Deleting..";

            //            NSString *serverURL=@"https://demo.eylog.co.uk/trunk/";
            NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;

            NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%@",serverURL,selDraft.observationId];

            //        NSLog(@"Delete URL : %@", urlString);

            NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",nil];

            NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableDeleteRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                if(error)
                {
                    [self performSelectorInBackground:@selector(closeAlert) withObject:nil];

                    // Displaying Hardcoded Error message for now to be changed later
                    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];


                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                    //                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //                    hud.mode = MBProgressHUDModeText;
                    //                    hud.labelText = @"No Data Network Available. Please turn Data Network On and than Try Again Later.";
                    //                    hud.margin = 10.f;
                    //                    hud.removeFromSuperViewOnHide = YES;
                    //                    hud.delegate =self;
                    //                    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                    //                    {
                    //                        hud.yOffset=280;
                    //                    }
                    //                    else
                    //                    {
                    //                        hud.yOffset=400;
                    //                    }
                    //                    [hud hide:YES afterDelay:3];
                    return;
                }
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];

                NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"%@",jsonDict);
                if([jsonDict isKindOfClass:[NSDictionary class]]) {

                    NSString *object = [jsonDict objectForKey:@"status"];
                    NSLog(@"%@",[object isEqual:[NSNull null]] ? nil : object);

                    if ([object isEqualToString:@"success"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [observationArray removeObjectAtIndex:indexPath.row];
                            [self getDraftListWithType];
                            [tableView reloadData];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView reloadData];
                        });
                    }
                }

            }];

            [postDataTask resume];
        }
        else
        {
            //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"You cannot delete  observation created by other Practitioners." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //
            //            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = "You cannot delete  observation created by other Practitioners.";
//            hud.margin = 10.f;
//            hud.userInteractionEnabled=YES;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.delegate =self;
//            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//            {
//                hud.yOffset=280;
//            }
//            else
//            {
//                hud.yOffset=400;
//            }
//            [hud hide:YES afterDelay:2];
            [self.view makeToast:@"You cannot delete  observation created by other Practitioners." duration:1.0f position:CSToastPositionBottom];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
        }
    }
}


#pragma mark - GroupSelectionDelegate
- (void)groupDidSelected:(NSString *)group withCellType:(NSString *)cellType
{
    isTypePopOverRect = NO;
    isObservationPopover = NO;
    pageNumber=1;
    if([cellType isEqualToString:KCellTypePractitioner])
    {
        [self.popover dismissPopoverAnimated:YES];
        if([group caseInsensitiveCompare:@"Draft"]==NSOrderedSame)
        {
            statusType=@"draft";
            [self getDraftListWithType];
        }
        else if ([group caseInsensitiveCompare:@"Pending Review"]==NSOrderedSame)
        {
            statusType=@"pending_review";
            [self getDraftListWithType];
        }
        else if ([group caseInsensitiveCompare:@"Processing"]==NSOrderedSame)
        {
            statusType=@"processing";
            [self getDraftListWithType];
        }else if ([group caseInsensitiveCompare:@"All"]==NSOrderedSame){
            statusType=@"draft,pending_review,processing";
            [self getDraftListWithType];
        }

    }
    else if([cellType isEqualToString:KCellTypeGroup])
    {
        [groupSearchView.groupPopup.groupsButton setTitle:group forState:UIControlStateNormal];
        if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
        {
            observationArray=[originalArray copy];
        }
        else
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];

            for (NewObservation *observationItr in originalArray) {
                NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:observationItr.childId];

                if([((Child *)[childArray objectAtIndex:0]).groupName isEqualToString:group])
                {
                    if (observationItr) {
                        [tempArray addObject:observationItr];
                    }
                }
            }
            observationArray = tempArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popover dismissPopoverAnimated:YES];
             [self.tableView setContentOffset:CGPointZero animated:YES];
            [self.tableView reloadData];
        });
    }
    else if([cellType isEqualToString:KCellTypeObservationBy])
    {
        //[groupSearchView.groupPopup.groupsButton setTitle:group forState:UIControlStateNormal];
        if([group caseInsensitiveCompare:@"All Observations"]==NSOrderedSame)
        {
            selectedObserver=@"All";
            [self getDraftListWithType];
         }else if ([group caseInsensitiveCompare:@"My Observations"]==NSOrderedSame){
            selectedObserver=@"My";
             [self getDraftListWithType];
        }
        else
        {
            selectedObserver=@"Parent";
            [self getDraftListWithType];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popover dismissPopoverAnimated:YES];
            [self.tableView setContentOffset:CGPointZero animated:YES];
            [self.tableView reloadData];
        });
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        [self groupDidSelected:groupSearchView.groupPopup.groupsButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    else
    {
        [self searchChild:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        [self groupDidSelected:groupSearchView.groupPopup.groupsButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    else
    {
        [self searchChild:textField.text];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==1 && [string isEqualToString:@""])
    {
        [self groupDidSelected:groupSearchView.groupPopup.groupsButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    return YES;
}



-(void)searchChild:(NSString *)practitionerString
{
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@", practitionerString];
    NSArray *currentGroup;
    NSString *group=groupSearchView.groupPopup.groupsButton.titleLabel.text;
    if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
    {
        currentGroup=[originalArray copy];
    }
    else
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NewObservation *observationItr in originalArray) {
            NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:observationItr.childId];

            if([((Child *)[childArray objectAtIndex:0]).groupName isEqualToString:group])
            {
                if (observationItr) {
                    [tempArray addObject:observationItr];
                }

            }
        }
        currentGroup = tempArray;
    }

    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (NewObservation *obItr in currentGroup) {
        NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:obItr.childId];

        Child *tmpChild = ((Child *)[childArray objectAtIndex:0]);
        if ([[NSString stringWithFormat:@"%@ %@", tmpChild.firstName, tmpChild.lastName] rangeOfString:practitionerString options:NSCaseInsensitiveSearch].location != NSNotFound) {
            if (obItr) {
                [filteredArray addObject:obItr];
            }
        }
    }

    if(filteredArray.count>0)
    {
        observationArray = [filteredArray mutableCopy];
    }
    else
    {
        observationArray = [[NSMutableArray alloc] init];
    }
    [self.tableView reloadData];

}


# pragma Get Load More Content

-(void)getDraftListContentMore
{
    //_listType = statusType;
    isRefreshing=YES;
    pageNumber=pageNumber+1;
    if (!self.isUploadQueue) {
        
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
        
        NSMutableArray *childIds = [[NSMutableArray alloc] init];
        for (Child *child  in [APICallManager sharedNetworkSingleton].cacheChildren) {
            if (child.childId) {
                [childIds addObject:child.childId];
            }
        }
        
        //   UIViewController *topVC = self.navigationController;
        
        if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Loading more..";
        }
        else{
            [observationArray removeAllObjects];
            [self.tableView reloadData];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        
        NSString *urlString=[NSString stringWithFormat:@"%@api/observations/lists",serverURL];
        
        NSLog(@"DraftList URL : %@", urlString);
        
        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",statusType,@"type",selectedObserver,@"observation_filter",@ "practitioner",@"filter_type", [childIds componentsJoinedByString:@","], @"child_id", @"20", @"per_page",[NSString stringWithFormat:@"%ld",(long)pageNumber],@"page", nil];
        
        NSLog(@"DraftList Parameters : %@",mapData);
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                
                // Displaying Hardcoded Error message for now to be changed later
                //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
                return;
            }
            //            [self backgroundLoadData:data];
            [self performSelectorOnMainThread:@selector(parseMoreData:) withObject:data waitUntilDone:YES];
        }];
        
        [postDataTask resume];
    }
    else
    {
        [self loadObservationList];
        if (isRefreshing) {
            [refreshControl endRefreshing];
            isRefreshing = NO;
            //  [self performSelector:@selector(hideAllHUDD) withObject:nil afterDelay:1.0f];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}


-(void)parseMoreData:(NSData *)data
{
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"Draft List Response JSON : %@", jsonDict);
    
    OBObservation *observation=[[OBObservation alloc]initWithDictionary:jsonDict];
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    
    if([observation.status isEqualToString:@"success"])
    {
        tempArray=[observation.data mutableCopy];
        
        //originalArray = [observationArray copy];
        
        groupNames = [[NSMutableArray alloc] init];
        observedByNames = [[NSMutableArray alloc] init];
        
        [groupNames addObject:@"All Groups"];
        [observedByNames addObject:@"All"];
        
        for (int i=0; i<[tempArray count]; i++)
        {
            OBData * obData = (OBData *)[tempArray objectAtIndex:i];
            NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[obData.childId integerValue]]];
            Child * child = [childArray firstObject];
            //            child.ageMonths = [NSString stringWithFormat:@"%@",obData.ageMonths];
            //            NSError *error = nil;
            //            [[AppDelegate context] save:&error];
            
            [self createNewObservation:obData withChild:child];
            NSString *tmpGroupName = child.groupName;
            if( tmpGroupName != nil && ![tmpGroupName isEqualToString:@""])
            {
                if (![groupNames containsObject:tmpGroupName]) {
                    [groupNames addObject:tmpGroupName];
                }
            }
            NSString *tmpObservedByName = obData.observationBy;
            if( tmpObservedByName != nil && ![tmpObservedByName isEqualToString:@""])
            {
                if (![observedByNames containsObject:tmpObservedByName]) {
                    [observedByNames addObject:tmpObservedByName];
                }
            }
        }
        
        [observationArray addObjectsFromArray:tempArray];
        // to store the contnets into orignal array after items currently in upload queue are removed
        originalArray = [observationArray copy];
        
        isRefreshing=NO;
        [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.tableView.contentOffset.y<0){
        //it means table view is pulled down like refresh
         NSLog(@"bottom Refresh!");
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height+100)) {
        NSLog(@"bottom!");
       // NSLog(@"%@", [self getLastMessageID]);
       // [self getMoreStuff:[self getLastMessageID]];
        if (isRefreshing) {
            return;
        }
//        if (observationArray.count<18) {
//            // [self.view makeToast:@"No more content" duration:<#(NSTimeInterval)#> position:<#(id)#>]
//            return;
//        }else{
//             [self getDraftListContentMore];
//
//        }
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -60) {
            NSLog(@"reload");
             [self getDraftListContentMore];
        }

    }
}
#pragma mark - Orientation Changes
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    containerView.hidden=YES;
//}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [UIView animateWithDuration:0.0 animations:^{
//        containerView.frame=CGRectMake(self.view.frame.size.width-400, 0, 400, 40);
//        containerView.hidden=NO;
//    }];
//}


/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
