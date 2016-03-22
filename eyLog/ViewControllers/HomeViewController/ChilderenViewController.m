//
//  ChilderenViewController.m
//  eyLog
//
//  Created by Ankit Khetrapal on 15/07/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChilderenViewController.h"
#import "ChilderenCell.h"
#import "ListViewController.h"
#import "Theme.h"
#import "ContainerViewController.h"
#import "GroupsViewController.h"
#import "DataModels.h"
#import "APICallManager.h"
#import "WYPopoverController.h"
#import "GridViewController.h"
#import "NewObservationViewController.h"
#import "DraftListViewController.h"
#import "Child.h"
#import "Utils.h"
#import "WebViewViewController.h"
#import "GroupsSearchView.h"
#import "DailyDiaryViewController.h"
#import "AppDelegate.h"
#import "EYLSummativeReportsViewController.h"
#import "UIView+Toast.h"
#import "Child.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LearningJourneyViewController.h"
#import "ObservationWithComentsViewController.h"
#import "NotificationsViewController.h"
#import "NotificationModel.h"
#import "DocumentFileHandler.h"
#import "NewObservationAttachment.h"
#import "ImageFile.h"
#import "AudioFile.h"
#import "VideoFile.h"
#import "eyLogNavigationViewController.h"



NSString *const KUSER_PRACTITIONER=@"practitioner";
@interface ChilderenViewController ()<GroupSelectionDelegate,UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,NotificationCellDelegate>
{
    OBMedia *media;
    MBProgressHUD *popOverHud;
    
    Theme *theme;
    BOOL thumbnailSelected;
    NSMutableArray *swipeViewArray;
    NSMutableArray *fixedMenuArray;
    NSMutableArray *restOfTabelViewArray;
    NSDictionary *swipeDictionary;
    
    NSArray *childrenListForTableView;
    NSMutableArray *childrenList;
    NSString *imageURL;
    NSMutableArray *tempChildrenArray;
    NSMutableDictionary *sortedChildrenDictionary;
    AppDelegate *appDelegate;
    BOOL IsFrameworkPopOverOpen;
    BOOL isInPressed;
    NSMutableArray *beforeInArray;
    
    
    BOOL isNotificationOpen;
    
    
}
@property (strong, nonatomic) IBOutlet GroupsSearchView *searchView;

@property (strong, nonatomic) GroupsViewController *popoverViewController;
@property (strong, nonatomic) WYPopoverController *popover;

@property (strong,nonatomic) GroupsViewController *frameWorkListViewContoller;
@property (strong,nonatomic) WYPopoverController *frameWorkPopOver;

@property (strong,nonatomic) GroupsViewController *popoverPractitionerProfile;
@property (strong,nonatomic) WYPopoverController *practitionerPopOver;

@property (nonatomic, strong) UIView *transitionView;
@property (nonatomic, strong) UIViewController *selectedViewController;

@end

@implementation ChilderenViewController

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
//-(void)fillDummyDataForNotification
//{
//    
//    
//    NotificationModel *model=[NotificationModel new];
//    model.title=@"New comment on observation";
//    model.content=@" One new comment added by parent on Emma jhonson observation";
//    model.observationID=[NSNumber numberWithInteger:[@"10724" integerValue]];
//    model.dateStr=@"3:00 PM";
//    model.type=@"Comment";
//    model.status=@"Unseen";
//    
//    NotificationModel *model1=[NotificationModel new];
//    model1.title=@"New observation published";
//    model1.content=@"New observation published by John Preston";
//    model1.observationID=[NSNumber numberWithInteger:[@"10724" integerValue]];
//    model1.dateStr=@"05:00 PM";
//    model1.type=@"obser";
//    model1.status=@"Unseen";
//    
//    NotificationModel *model2=[NotificationModel new];
//    model2.title=@"New comment on observation";
//    model2.content=@" One new comment added by parent on Eylog Ltd";
//    model2.observationID=[NSNumber numberWithInteger:[@"10724" integerValue]];
//    model2.dateStr=@"09:00 PM";
//    model2.type=@"Comment";
//    model2.status=@"Unseen";
//   
//    
//    NotificationModel *model3=[NotificationModel new];
//    model3.title=@"Note added in Daily diary";
//    model3.content=@"Note added in Dialy diary of Smith smith";
//    model3.observationID=[NSNumber numberWithInteger:[@"10724" integerValue]];
//    model3.dateStr=@"12:00 AM";
//    model3.type=@"diary";
//    model3.status=@"Unseen";
//   
//
//    NotificationModel *model4=[NotificationModel new];
//    model4.title=@"New comment on observation";
//    model4.content=@" One new comment added by parent on Emma jhonson observation";
//    model4.observationID=[NSNumber numberWithInteger:[@"10724" integerValue]];
//    model4.dateStr=@"10:00 AM";
//    model4.type=@"Comment";
//    model4.status=@"seen";
//    
//  
//    
//      [arrayForNotification addObject:model];
//      [arrayForNotification addObject:model1];
//      [arrayForNotification addObject:model2];
//      [arrayForNotification addObject:model3];
//      [arrayForNotification addObject:model4];
//    
//    
//    NSString *str=@"Unseen";
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.status== %@",str];
//    
//    NSArray *array1=[arrayForNotification filteredArrayUsingPredicate:predicate];
//   
//    [self.notification_Lbl setText:[NSString stringWithFormat:@"%lu",(unsigned long)array1.count]];
//    //[[NSUserDefaults standardUserDefaults] setObject:arrayForNotification forKey:@"DataForNotification"];
//   
//    
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *myDecodedObject = [userDefault objectForKey:@"DataForNotification"];
    NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    
    
    _arrayForNotification=[[NSMutableArray alloc] initWithArray:decodedArray];
    
    NSString *str=  [[NSUserDefaults standardUserDefaults] objectForKey:@"batchCount"];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
   
    
    if(![_controller isPopoverVisible])
    {
    if([str isEqualToString:@"0"]||[str rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        [self.notification_Lbl setHidden:YES];
        [self.messageHolderImage setHidden:YES];
        
    }
    else
    {
        [self.notification_Lbl setHidden:NO];
        [self.messageHolderImage setHidden:NO];
        
        [self.notification_Lbl setText:[NSString stringWithFormat:@"%@",str]];
    }
    }

    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selection"];
    NSMutableArray *array=[NSMutableArray new];
    
    for (NSInteger count=_swipeView.visibleItemViews.count; count < swipeViewArray.count; count++)
    {
        
        [array addObject:[swipeViewArray objectAtIndex:count]];
    }
    if(array.count>0)
    {
        [self.tableViewListButton setHidden:NO];
        
    }
    else
    {
        [self.tableViewListButton setHidden:YES];
        
    }
}
- (void)receiveNotification:(NSNotification *)notification1
{
    if ([[notification1 name] isEqualToString:@"myNotificationForBatch"]) {
       // NSDictionary *myDictionary = (NSDictionary *)notification1.object;
        
        NSString *str=  [[NSUserDefaults standardUserDefaults] objectForKey:@"batchCount"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([self.controller isPopoverVisible])
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            @autoreleasepool {
                                
                                
                                NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
                                
                                NSString *urlString=[NSString stringWithFormat:@"%@api/resetpracbatchcount",serverURL];
                                NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                                                [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",nil];
                                
                                [mapData setObject:[[APICallManager sharedNetworkSingleton] cachePractitioners].eylogUserId forKey:@"eylog_user_id"];
                                
                                NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                                      {
                                                                          
                                                                          if(error)
                                                                          {
                                                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                                              
                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                                               });
                                                                              
                                                                              return;
                                                                          }
                                                                          
                                                                          else
                                                                          {
                                                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                              
                                                                              if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                                                                              {
                                                                                  //[self.notification_Lbl setText:@"0"];
                                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"batchCount"];
                                                                                  //[[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationForBatch" object:nil];
                                                                                   });
                                                                                  
                                                                              }
                                                                              
                                                                          }
                                                                          
                                                                          
                                                                      }];
                                [postDataTask resume];
                                
                                
                                
                                
                            }
                            
                        });
                        
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        NSData *myDecodedObject = [userDefault objectForKey:@"DataForNotification"];
                        NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
                        self.arrayForNotification=[[NSMutableArray alloc] initWithArray:decodedArray];
                        self.notification.dataArray= self.arrayForNotification;
                        [self.notification.tableview reloadData];
                        
                        
                    }
                    else
                    {

                    if([str isEqualToString:@"0"])
                    {
                        [self.notification_Lbl setHidden:YES];
                        [self.messageHolderImage setHidden:YES];
                        
                    }
                    else
                    {
                        [self.notification_Lbl setHidden:NO];
                        [self.messageHolderImage setHidden:NO];
                        
                        [self.notification_Lbl setText:[NSString stringWithFormat:@"%@",str]];
                    }
                    }


                });

        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSData *myDecodedObject = [userDefault objectForKey: @"DataForNotification"];
        NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
        _arrayForNotification=[[NSMutableArray alloc] initWithArray:decodedArray];

        //doSomething here.
    }
}
-(void)launchMore:(NSNumber *)pageNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @autoreleasepool {
            
            if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
                NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
                
                NSString *urlString=[NSString stringWithFormat:@"%@api/nurserynotifications",serverURL];
                NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                                [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",pageNumber,@"page",@"10",@"per_page",nil];
                
                [mapData setObject:[[APICallManager sharedNetworkSingleton] cachePractitioners].eylogUserId forKey:@"eylog_user_id"];
                
                NSLog( @" launch more page number =%d",[pageNumber integerValue]);
                
                
                NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                      {
                                                          
                                                          if(error)
                                                          {
                                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                              
                                                              return;
                                                          }
                                                          else
                                                          {
                                                             
                                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                              
                                                               NSArray *arrayData=[jsonDict objectForKey:@"data"];
                                                              
                                                              if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
                                                              {
                                                                  
                                                                  [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:@"batchcount"] forKey:@"batchCount"];
                                                                  
                                                                  for(int i=0;i<arrayData.count;i++)
                                                                  {
                                                                      NotificationModel *model=[NotificationModel new];
                                                                      NSDictionary *dict=[arrayData objectAtIndex:i];
                                                                      model.childID=[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]];
                                                                      model.type=[dict objectForKey:@"notificationType"];
                                                                      model.tableID=[NSNumber numberWithInteger:[[dict objectForKey:@"notificationTableId"] integerValue]];
                                                                      model.dateStr=[dict objectForKey:@"date_added"];
                                                                      model.isRead=[[dict objectForKey:@"isRead"] integerValue];
                                                                      model.notificationId=[dict objectForKey:@"id"];
                                                                      
                                                                      NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]]];
                                                                      Child *child=[childArray lastObject];
                                                                      
                                                                      if([[dict objectForKey:@"notificationType"] isEqualToString:@"ddNotes"])
                                                                      {
                                                                          
                                                                          model.title=@"Note added in Daily diary";
                                                                          if(child)
                                                                          {
                                                                          model.content=[[[@"Note added in Dialy diary of " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                          }
                                                                          
                                                                      }
                                                                      else if([[dict objectForKey:@"notificationType"] isEqualToString:@"comment"])
                                                                          
                                                                      {
                                                                          model.title=@"New comment on observation";
                                                                          if(child)
                                                                          {
                                                                          model.content=[[[@"One new comment added by parent for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                          }
                                                                          
                                                                      }
                                                                      else
                                                                          
                                                                      {
                                                                          
                                                                          model.title=@"New observation published";
                                                                          if(child)
                                                                          {
                                                                          model.content=[[[@"New observation published for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                          }
                                                                          
                                                                      }
                                                                      if(child)
                                                                      {
                                                                      
                                                                      [_arrayForNotification addObject:model];
                                                                      }
                                                                  }
                                                                  
                                                                  NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                                                                  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_arrayForNotification];
                                                                  [userDefault setObject:myEncodedObject forKey:@"DataForNotification"];
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      if([self.controller isPopoverVisible])
                                                                      {
                                                                          [self.notification.tableview setScrollEnabled:YES];
                                                                          self.notification.dataArray= self.arrayForNotification;
                                                                          [self.notification.tableview reloadData];
                                                                          self.notification.tableview.tableFooterView=nil;
                                                                          if(_arrayForNotification.count>=10*([pageNumber integerValue]-1))
                                                                          {
                                                                          [self.notification.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:10*([pageNumber integerValue]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                                                          }
                                                                          self.notification.noMoreData=NO;
                                                                          int inte;
                                                                          
                                                                          if(_arrayForNotification.count*90 >self.view.frame.size.height/2)
                                                                          {
                                                                              inte=self.view.frame.size.height/2;
                                                                          }
                                                                          else
                                                                          {
                                                                              inte=_arrayForNotification.count*90;
                                                                          }
                                                                          
                                                                          _controller.popoverContentSize = CGSizeMake(330, inte);
                                                                      }
                                                                  });
                                                                  
                                                                  //[NSString stringWithFormat:@"%d",[[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId integerValue]]
                                                                }
                                                              else if([pageNumber integerValue]>1 &&[[jsonDict objectForKey:@"data"] isEqualToString:@""])
                                                              {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      if([self.controller isPopoverVisible])
                                                                      {
                                                                            self.notification.tableview.tableFooterView=nil;
                                                                            self.notification.noMoreData=YES;
                                                                           [self.notification.tableview setScrollEnabled:YES];

                                                                          
                                                                      }
                                                                  });
                                                              }
                                                              
                                                              
                                                          }
                                                          
                                                          
                                                      }];
                [postDataTask resume];
                
            }
            
            
        }
        
    });

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
//    if(_isComeFromNotificationToLoadNewObser)
//    {
//        UIView *view=[[UIView alloc] initWithFrame:self.view.frame];
//        [view setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:view];
//        popOverHud=[MBProgressHUD showHUDAddedTo:self.view  animated:YES];
//        [self loadData:_diaryID];
//        
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"myNotificationForBatch"
                                               object:nil];
    
  

    
    BOOL iSwipeViewChanged;
  
    if(swipeViewArray.count*87<=_swipeView.frame.size.width)
    {
        _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
        [_swipeView setFrame:CGRectMake(16, 0,swipeViewArray.count*87, 65)];
        iSwipeViewChanged=YES;
        
    }
    else if (swipeViewArray.count==6 && [APICallManager sharedNetworkSingleton].settingObject.dailyDiary==0)
    {
        
        _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
        [_swipeView setFrame:CGRectMake(16, 0,swipeViewArray.count*87, 65)];
        iSwipeViewChanged=YES;
    }
    
    else if (swipeViewArray.count>=6 )
    {
        UIInterfaceOrientation cachedOrientation = [self interfaceOrientation];
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationFaceUp ||
            orientation == UIDeviceOrientationFaceDown) {
            
            orientation = (UIDeviceOrientation)cachedOrientation;
        }
        
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
        {
            _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
            [_swipeView setFrame:CGRectMake(16, 0,6*87, 65)];
            iSwipeViewChanged=YES;
            
        }
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
          
            if ([APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
            {  [_swipeView setFrame:CGRectMake(16, 0,3*87, 65)];
            }
            else
            {
              [_swipeView setFrame:CGRectMake(16, 0,4*87, 65)];
            }
            
            iSwipeViewChanged=YES;
            
        }
        
    }
    
    if( iSwipeViewChanged)
    {
        if(fixedMenuArray.count*87<=_fixedMenuView.frame.size.width)
        {
            _fixedMenuView.translatesAutoresizingMaskIntoConstraints=YES;
            
            [_fixedMenuView setFrame:CGRectMake(_swipeView.frame.size.width, 0,fixedMenuArray.count*87, 65)];
        }
    }
    
    
    theme.onlyView=YES;
    [APICallManager sharedNetworkSingleton].cacheChildren = nil;
    [APICallManager sharedNetworkSingleton].cacheChild = nil;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;
    self.practitionerName.text=[NSString stringWithFormat:@"%@ %@",practitioner.firstName, practitioner.lastName];
    self.practitionerGroupName.text = practitioner.groupName;
    self.practitionerGroupName.text=practitioner.groupName;
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],practitioner.photo];
    self.teacherImage.image=[UIImage imageWithContentsOfFile:imagePath];
    self.teacherImage.contentMode = UIViewContentModeScaleAspectFit;

    self.navigationController.navigationBar.hidden=YES;

    // For Setting Group Button Text At Load Time according to setting and Diffrentiate between Loged user is Practitioner / Manager
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusUpdate:) name:@"RefreshSelectedStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];

    [self.navigationController setToolbarHidden:NO animated:YES];
    [theme resetTargetViewController:self];
    self.selectedStatus.layer.cornerRadius=15.0f;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearAction" object:nil];


}


-(void)viewDidDisappear:(BOOL)animated
{
//     _notification=nil;
//    [_controller dismissPopoverAnimated:YES];
//
//    _controller=nil;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    _controller=nil;
    _notification=nil;
    
    self.navigationController.navigationBar.hidden=NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selection"];
    [self viewDidDisappear:animated];
}

-(void)statusUpdate:(NSNotification *)notification
{
    [self enableDisableActionsAsPerChilderenCount];

    if([notification.object intValue]==0)
        self.multipleChilderenLabel.text=@"You can select multiple children";
    else if([notification.object intValue]>0)
        self.multipleChilderenLabel.text=@"Clear All Selected Children";
    self.selectedStatus.text=notification.object;
    theme.myLabel.text=notification.object;
    
    // This API is to fetch all Registry IN/OUT time

}
-(void) enableDisableActionsAsPerChilderenCount
{
    [self.swipeView reloadData];
    [self.fixedMenuView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    
    //arrayForNotification=[NSMutableArray new];
    
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"Data"])
//    {
    //[self fillDummyDataForNotification];
    //}
    
    
    NSString *string;
    if([APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId!=nil)
    {
     string =[NSString stringWithFormat:@" and Practitioner ID = %@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId];
    }
    
    [CrashlyticsKit setUserName:string];
    
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_PRACTITIONER]==NSOrderedSame) {
        
        if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
        {
            [self.groupButton setTitle:@"Key Children" forState:UIControlStateNormal];
            
        }
        else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
        {
            
            [self.groupButton setTitle:[APICallManager sharedNetworkSingleton].cachePractitioners.groupName forState:UIControlStateNormal];
            
        }
        else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
        {
            [self.groupButton setTitle:@"All Groups" forState:UIControlStateNormal];
            
        }
    }
    else{
        [self.groupButton setTitle:@"All Groups" forState:UIControlStateNormal];
        
    }
    //swipeViewArray=@[@"Planning Sheet",@"Observation Tracker",@"Progress Check",@"EYFS Check",@"CoEL Summary",@"ECaT Summary",@"Summative Reports",@"Upload Queue"];

    // Edited By : Ankit Khetrapal
    // Reason : Removing eCat for now
    
    //NSArray *temArr=@[@"Planning Sheet",@"Observation Tracker",@"Progress Check",@"EYFS Check",@"Montessori Tracker",@"ECaT Summary",@"CoEL Summary",@"Summative Reports",@"Refresh In-Out",@"Upload Queue"];
    
    //swipeViewArray=[NSMutableArray arrayWithArray:temArr];
    
    swipeViewArray=[NSMutableArray new];
    
    [swipeViewArray addObject:@"Planning Sheet"];
    [swipeViewArray addObject:@"Observation Tracker"];
      [swipeViewArray addObject:@"Progress Check"];
    if ([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
    {
        [swipeViewArray addObject:@"EYFS Check"];
    }
    if ([APICallManager sharedNetworkSingleton].settingObject.montessori)
    {
      [swipeViewArray addObject:@"Montessori Tracker"];
    }
    if ([APICallManager sharedNetworkSingleton].settingObject.ecat)
    {
        [swipeViewArray addObject:@"ECaT Summary"];

    }
    if ([APICallManager sharedNetworkSingleton].settingObject.coel)
    {
        [swipeViewArray addObject:@"CoEL Summary"];

    }
   
    //[swipeViewArray addObject:@"Summative Reports"];
    if ([APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
    {
    [swipeViewArray addObject:@"Refresh In-Out"];
    }
    [swipeViewArray addObject:@"Upload Queue"];
    
       
    //fixedMenuArray=@[@"Draft List",@"Daily Diary",@"New Observation",@"Learning Journey"];

    // Edited By : Ankit Khetrapal
    // Reason : Removing Daily Diary for now
    
    NSArray *array_new=@[@"Summative Reports",@"Draft List",@"New Observation",@"Learning Journey"];
     fixedMenuArray=[NSMutableArray arrayWithArray:array_new];
    
     if ([APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
     {
         [fixedMenuArray insertObject:@"Daily Diary" atIndex:1];
     }
   
    
    swipeDictionary=@{@"Draft List": @"icon_draftlist",@"Observation Tracker":@"icon_obs-tracker",@"Progress Check":@"icon_progress-check",@"EYFS Check":@"icon_eyfs-check",@"Montessori Tracker":@"icon_montessori_tracker",@"Daily Diary":@"icon_daily-diary",@"New Observation":@"icon_new-obs",@"Learning Journey":@"icon_lerning-journey",@"Planning Sheet":@"icon_planning-sheet",@"ECaT Summary":@"icon_ecat-summary",@"CoEL Summary":@"icon_coel-summary",@"Summative Reports":@"icon_summative-report",@"Refresh In-Out":@"refresh",@"Upload Queue":@"icon_updoad-q"};


        NSString *practitionerGroupName=[APICallManager sharedNetworkSingleton].cachePractitioners.groupName;
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSLog(@"Checking Practitioner %@",[APICallManager sharedNetworkSingleton].cachePractitioners.userRole);

        if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_PRACTITIONER] == NSOrderedSame) {

            if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
            {
                childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
            }
            else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
            {
                childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:practitionerGroupName] mutableCopy];
            }
            else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
            {
                childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
            }
        }else{
            childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];

        }
    [APICallManager sharedNetworkSingleton].childArray=childrenList;
    sortedChildrenDictionary=[self sortChildren:childrenList];

    thumbnailSelected = true;
    self.multipleChilderenLabellHolder.layer.cornerRadius = 8;
    self.teacherImage.layer.cornerRadius = 22;
    self.teacherImage.layer.masksToBounds = YES;
    self.multipleChilderenLabel.font = [UIFont fontWithName:kSystemFontRobotoCondensedR size:15];
    self.thumbnailButton.layer.backgroundColor = thumbnailSelected ? [[UIColor whiteColor] CGColor] : [[UIColor clearColor] CGColor];
    self.thumbnailButton.imageView.image = [UIImage imageNamed:thumbnailSelected ? @"icon_thumbnail_selected" : @"icon_thumbnail"];

    self.listButton.layer.backgroundColor = thumbnailSelected ? [[UIColor clearColor] CGColor] : [[UIColor whiteColor] CGColor];


    //configure swipe view
    _swipeView.alignment =SwipeViewAlignmentEdge;
    _swipeView.pagingEnabled = YES;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage =NO;
    _swipeView.scrollEnabled=NO;
    
    _fixedMenuView.alignment =SwipeViewAlignmentEdge;
    _fixedMenuView.pagingEnabled = YES;
    _fixedMenuView.itemsPerPage = 1;
    _fixedMenuView.truncateFinalPage = YES;
    _fixedMenuView.scrollEnabled=NO;

    __block NSMutableDictionary *settingDictionary=[[NSMutableDictionary alloc]init];
    [[APICallManager sharedNetworkSingleton].baseClass.settings enumerateObjectsUsingBlock:^(INSettings *setting, NSUInteger idx, BOOL *stop)
     {
         [settingDictionary setObject:setting.value forKey:setting.key];
     }];

    [APICallManager sharedNetworkSingleton].settingObject = [[Setting alloc] initWithSettingDictionary:settingDictionary];

    [[APICallManager sharedNetworkSingleton] registerForPushNotifications];
}

- (void)sortDataWithArray:(NSArray *)dataArray {
    [self.searchView.searchBar resignFirstResponder];
    if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
    {
        //childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
        [self.groupButton setTitle:@"Key Childeren" forState:UIControlStateNormal];

    }
    else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
    {
        // childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId withPractitionerGroupName:practitionerGroupName] mutableCopy];
        //  [tempChildrenArray addObject:@"All Groups"];
    }
    else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
    {
        //childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
        [self.groupButton setTitle:@"All Groups" forState:UIControlStateNormal];

    }
    [childrenList removeAllObjects];
    [childrenList addObjectsFromArray:dataArray];
    sortedChildrenDictionary=[self sortChildren:childrenList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectedStatus" object:[NSString stringWithFormat:@"%lu",(unsigned long)0]];
 
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

-(void)refresh
{
    isInPressed=NO;
    [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)frameworkList:(id)sender
{
        restOfTabelViewArray=[NSMutableArray new];
        self.frameWorkListViewContoller = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
        self.frameWorkListViewContoller.delegate = self;
        self.frameWorkListViewContoller.cellType=KCellTypeFrame;
        self.frameWorkListViewContoller.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _frameWorkPopOver = [[WYPopoverController alloc] initWithContentViewController:self.frameWorkListViewContoller];
        self.frameWorkPopOver.theme.tintColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.fillTopColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.fillBottomColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.glossShadowColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.outerShadowColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.outerStrokeColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.innerShadowColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.innerStrokeColor = [UIColor clearColor];
        self.frameWorkPopOver.theme.overlayColor = [UIColor clearColor];

        self.frameWorkPopOver.theme.glossShadowBlurRadius = 0.0f;
        self.frameWorkPopOver.theme.borderWidth = 0.0f;
        self.frameWorkPopOver.theme.arrowBase = 0.0f;
        self.frameWorkPopOver.theme.arrowHeight = 0.0f;
        self.frameWorkPopOver.theme.outerShadowBlurRadius = 0.0f;
        self.frameWorkPopOver.theme.outerCornerRadius = 0.0f;
        self.frameWorkPopOver.theme.minOuterCornerRadius = 0.0f;
        self.frameWorkPopOver.theme.innerShadowBlurRadius = 0.0f;
        self.frameWorkPopOver.theme.innerCornerRadius = 0.0f;
        self.frameWorkPopOver.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.frameWorkPopOver.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.frameWorkPopOver.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.frameWorkPopOver.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.frameWorkPopOver.wantsDefaultContentAppearance = NO;

        self.frameWorkPopOver.theme.arrowHeight = 10.0f;
        self.frameWorkPopOver.theme.arrowBase = 0;
    int height=0;

    for (NSInteger count=_swipeView.visibleItemViews.count; count < swipeViewArray.count; count++)
    {
        height=height+45;
        [restOfTabelViewArray addObject:[swipeViewArray objectAtIndex:count]];
    }
    self.frameWorkListViewContoller.tableView.scrollEnabled=YES;
    self.frameWorkListViewContoller.dataArray=[restOfTabelViewArray copy];
    self.frameWorkListViewContoller.dataSoruce=swipeDictionary;
    self.frameWorkPopOver.popoverContentSize = CGSizeMake(230, height);

    CGRect rect = ((UIButton *)sender).frame;
    rect.origin.y += 45;
    rect.origin.x += 70;
    [self.frameWorkPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}
- (IBAction)clearButtonAction:(id)sender
{
    self.multipleChilderenLabel.text=@"You can select multiple children";
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearAction" object:nil];
}



- (IBAction)backButton:(id)sender
{
    UIAlertView *logout=[[UIAlertView alloc]initWithTitle:@"Log-out" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logout show];
}

- (IBAction)notificationBtnAction:(id)sender {
    
    
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"batchCount"]isEqualToString:@"0"])
    {
    if([APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        [self.messageHolderImage setHidden:YES];
        [self.notification_Lbl setHidden:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            @autoreleasepool {
                
               
                    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
                    
                    NSString *urlString=[NSString stringWithFormat:@"%@api/resetpracbatchcount",serverURL];
                    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                                    [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",nil];
                    
                    [mapData setObject:[[APICallManager sharedNetworkSingleton] cachePractitioners].eylogUserId forKey:@"eylog_user_id"];
                    
                    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                          {
                                                              
                                                              if(error)
                                                              {
                                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                                  
                                                                  
                                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                                  
                                                                  return;
                                                              }
                                                              
                                                              else
                                                              {
                                                               NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                  
                                                                  if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                                                                  {
                                                                      //[self.notification_Lbl setText:@"0"];
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"batchCount"];
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationForBatch" object:nil];
                                                                  }
                                                                  
                                                              }
                                                              
                                                              
                                                          }];
                    [postDataTask resume];
                    
                
              
                
            }
            
        });
      
    }
 }
    if([APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        if(_arrayForNotification.count>0)
        {
        _notification=[[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSData *myDecodedObject = [userDefault objectForKey:@"DataForNotification"];
        NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
        
        _arrayForNotification=[[NSMutableArray alloc] initWithArray:decodedArray];
        _notification.dataArray=_arrayForNotification;
    [_notification setDelegate:self];
    _controller =[[WYPopoverController alloc] initWithContentViewController:_notification];

    _controller.theme.tintColor = [UIColor clearColor];
    _controller.theme.fillTopColor = [UIColor clearColor];
    _controller.theme.fillBottomColor = [UIColor clearColor];
    _controller.theme.glossShadowColor = [UIColor clearColor];
    _controller.theme.outerShadowColor = [UIColor clearColor];
    _controller.theme.outerStrokeColor = [UIColor clearColor];
    _controller.theme.innerShadowColor = [UIColor clearColor];
    _controller.theme.innerStrokeColor = [UIColor clearColor];
    _controller.theme.overlayColor = [UIColor clearColor];
    _controller.theme.glossShadowBlurRadius = 0.0f;
    _controller.theme.borderWidth = 0.0f;
    _controller.theme.arrowBase = 0.0f;
    _controller.theme.arrowHeight = 0.0f;
    _controller.theme.outerShadowBlurRadius = 0.0f;
    _controller.theme.outerCornerRadius = 0.0f;
    _controller.theme.minOuterCornerRadius = 0.0f;
    _controller.theme.innerShadowBlurRadius = 0.0f;
    _controller.theme.innerCornerRadius = 0.0f;
    _controller.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    _controller.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    _controller.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    _controller.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _controller.wantsDefaultContentAppearance = NO;
    _controller.theme.arrowHeight = 10.0f;
    _controller.theme.arrowBase = 0;
    NSInteger inte;
    
    if(_arrayForNotification.count*90 >self.view.frame.size.height/2)
    {
        inte=self.view.frame.size.height/2;
    }
    else
    {
        inte=_arrayForNotification.count*90;
    }
    
    _controller.popoverContentSize = CGSizeMake(330, inte);
        
       // Get the location and size of the control (button that says "Drinks")
    CGRect rect = ((UIButton *)sender).frame;
    
    // Set the width to 1, this will put the anchorpoint on the left side
    // of the control
    //rect.size.width = 1;
    
    // Reduce the available screen for the popover by creating a left margin
    // The popover controller will assume that left side of the screen starts
    // at rect.origin.x
    _controller.popoverLayoutMargins = UIEdgeInsetsMake(0, rect.origin.x, 0, 0);
    
    int offsetX = 500;
    int offsetY = 15;
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
    {
        offsetX = 240+500;
        offsetY = 15;
    }

    
    rect.origin.y +=  offsetY;
    rect.origin.x += offsetX;
    [_controller presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
        else
            
        {
            [self.view makeToast:@"No notification for you" duration:2.0f position:CSToastPositionBottom];

        }
    
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:NO cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)rowSelectedForCell:(NotificationTableViewCell *)cell andID:(NSNumber *)id_num andModel:(NotificationModel *)model andArray:(NSMutableArray *)array
{
    
  
  if(model.isRead==NO)
  {
    
    if([APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            @autoreleasepool {
                
                
                NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
                
                NSString *urlString=[NSString stringWithFormat:@"%@api/resetnotificationreadstatus",serverURL];
                NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                                [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",nil];
                
                [mapData setObject:model.notificationId forKey:@"notification_id"];
                
                NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                      {
                                                          
                                                          if(error)
                                                          {
                                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                              
                                                              
//                                                              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                              
                                                              return;
                                                          }
                                                          
                                                          else
                                                          {
                                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                              
                                                              if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                                                              {
                                                                  //[self.notification_Lbl setText:@"0"];
                                                                  model.isRead=YES;
                                                                  cell.backgroundColor=[UIColor whiteColor];
                                                                  
                                                                  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                                                  
                                                                  NSData *myDecodedObject = [userDefault objectForKey:@"DataForNotification"];
                                                                  NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
                                                                  
                                                                  _arrayForNotification=[[NSMutableArray alloc] initWithArray:decodedArray];
                                                                  
//                                                                  NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.notificationId.intValue== %d",[model.notificationId intValue]];
//                                                                  NSArray array=[_arrayForNotification filteredArrayUsingPredicate:predicate];
                                                                  
                                                                  [_arrayForNotification replaceObjectAtIndex:cell.indexpath.row withObject:model];
                                                                  
                                                                 
                                                                  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:_arrayForNotification];
                                                                  [userDefault setObject:myEncodedObject forKey:@"DataForNotification"];
                                                                  
                                                              
                                                              }
                                                              
                                                          }
                                                          
                                                          
                                                      }];
                [postDataTask resume];
                
                
                
                
            }
            
        });
        
        
    }
}
    if([APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
    if([model.type isEqualToString:@"comment"])
    {
        [_controller dismissPopoverAnimated:YES];
        _controller=nil;
        LearningJourneyViewController *view=[[LearningJourneyViewController alloc] initWithNibName:@"LearningJourneyViewController" bundle:nil];
        [view setObservationID:[NSNumber numberWithInt:[model.tableID intValue]]];
        view.isComeFromNotification=YES;
        [self.navigationController pushViewController:view animated:YES];
        
        
    }
    
    if([model.type isEqualToString:@"ddNotes"])
    {
        [_controller dismissPopoverAnimated:YES];
        _controller=nil;
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DailyDiaryViewController *dd=[storyboard instantiateViewControllerWithIdentifier:@"DailyDiaryIdentifier"];
        dd.isComeFromNotesNotifcation=YES;
        [dd setStrCurrentDate:model.dateStr];
        
        //   DailyDiaryViewController *dd=[[DailyDiaryViewController alloc] initWithNibName:@"DailyDiaryViewController" bundle:nil];
        [dd setDiaryID:[NSNumber numberWithInt:[model.tableID intValue]]];
        [dd setChildID:[NSNumber numberWithInt:[model.childID intValue]]];
        [self.navigationController pushViewController:dd animated:YES];
        
        
    }
    if([model.type isEqualToString:@"observation"])
    {
        popOverHud=[MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        [popOverHud setActivityIndicatorColor:[UIColor grayColor]];
        [popOverHud setColor:[UIColor clearColor]];
        
        
        [self loadData:model.tableID];
        
    }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:NO cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    
    }
    
    
}
-(void)loadData:(NSNumber *)observationID
{
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerID=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%d/list",serverURL,[observationID integerValue]];
    
    NSLog(@"DraftList URL : %@", urlString);
    
    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerID,@"practitioner_id", nil];
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[hud hide:YES];
                [popOverHud hide:YES];
                for( MBProgressHUD *hud in appDelegate.window.rootViewController.view.subviews)
                {
                    [hud removeFromSuperview];
                    
                    
                }
                
            });
            
            return;
        }
        [self backgroundLoadData:data];
        
    }];
    
    [postDataTask resume];
}
-(void)backgroundLoadData:(NSData *)data
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    NewObservationViewController *controllerNew = [storyboard instantiateViewControllerWithIdentifier:@"NewObservationIdentifier"];
    controllerNew.isComeFromNotification=YES;
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Draft List Response JSON : %@", jsonDict);
    OBObservation *observation=[[OBObservation alloc]initWithDictionary:jsonDict];
    OBData * obData;
    Child * child;
    if([observation.status isEqualToString:@"success"])
    {
        NSArray *array=[observation.data mutableCopy];
         obData= (OBData *)[array firstObject];
        NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[obData.childId integerValue]]];
         child= [childArray firstObject];
        [self createNewObservation:obData withChild:child];
        controllerNew.notificationChild=child;
        
    }
    
   // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
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
                isNoError = [self createNewObservationAttachmentWithObdata:obData andChild:child];
                if (!isNoError) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
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
                        controllerNew.eylNewObservation = [self populateDataInEylNewObservation:newObservation];
                    }
                    
                            [_controller dismissPopoverAnimated:YES];
                            _controller=nil;
                    [self pushToViewController:controllerNew];
                }
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            });
        }
        else{
            NewObservation * newObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:obData.uniqueTabletOID];
            if (newObservation) {
                controllerNew.eylNewObservation = [self populateDataInEylNewObservation:newObservation];
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
            if(self.navigationController ==nil)
            {
                UIViewController *vc = appDelegate.window.rootViewController;
                if([vc isKindOfClass:[eyLogNavigationViewController class]])
                {
                    
                    eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                    [nav pushViewController:controllerNew animated:YES];

                }

                return ;
                
            }
            
                    [_controller dismissPopoverAnimated:YES];
                    _controller=nil;
            [self.navigationController pushViewController:controllerNew animated:YES];
        }

        
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [_controller dismissPopoverAnimated:YES];
//        _controller=nil;
        for(UIView *view in appDelegate.window.subviews)
        {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
        }
        [popOverHud hide:YES];
       

    });
  
}
-(void)pushToViewController:(NewObservationViewController *)controller1{
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
    
    if(self.navigationController ==nil)
    {
        UIViewController *vc = appDelegate.window.rootViewController;
        if([vc isKindOfClass:[eyLogNavigationViewController class]])
        {
            eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
            [nav pushViewController:controller1 animated:YES];
            
        }
        
        return ;
        
    }
    [self.navigationController pushViewController:controller1 animated:YES];
}
-(EYLNewObservation *)populateDataInEylNewObservation:(NewObservation *)newObservation{
    
    EYLNewObservation * eylNewObservation = [[EYLNewObservation alloc]init];
    [eylNewObservation populateDataWithNewObservation:newObservation];
    eylNewObservation.media=media;
    
    return eylNewObservation;
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
            
        }
    }
    NSArray * allObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:NO withEditing:NO withUploading:NO withUploaded:NO];
    NSLog(@"count %lu",(unsigned long)allObservation.count);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=[alertView cancelButtonIndex])
    {
        [APICallManager sharedNetworkSingleton].cacheChild = nil;
        [APICallManager sharedNetworkSingleton].cacheChildren = nil;
        [APICallManager sharedNetworkSingleton].cachePractitioners = nil;
        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"batchCount"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DataForNotification"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pageNumber"];
        
        
        
    }
}

- (IBAction)thumbnailButtonClick:(id)sender
{
    [self.containerViewController showGridViewController];
    if(!thumbnailSelected)
    {
        self.thumbnailButton.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        self.thumbnailButton.imageView.image = [UIImage imageNamed:@"icon_thumbnail_selected"];
        self.listButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
        [self.listButton setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
        [self.listButton setSelected:NO];
        thumbnailSelected = true;
    }
}

#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    BOOL iSwipeViewChanged;
    
    if(swipeViewArray.count*87<=(_swipeView.frame.size.width-9))
    {
        _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
        [_swipeView setFrame:CGRectMake(16, 0,swipeViewArray.count*87, 65)];
        iSwipeViewChanged=YES;
        
    }
    else if (swipeViewArray.count==6 && [APICallManager sharedNetworkSingleton].settingObject.dailyDiary==0)
    {
        
        _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
        [_swipeView setFrame:CGRectMake(16, 0,swipeViewArray.count*87, 65)];
        iSwipeViewChanged=YES;
    }
    
    else if (swipeViewArray.count>=6 )
    {
        UIInterfaceOrientation cachedOrientation = [self interfaceOrientation];
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        if (orientation == UIDeviceOrientationUnknown ||
            orientation == UIDeviceOrientationFaceUp ||
            orientation == UIDeviceOrientationFaceDown) {
            
            orientation = (UIDeviceOrientation)cachedOrientation;
        }
        
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
        {
            _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
            [_swipeView setFrame:CGRectMake(16, 0,6*87, 65)];
            iSwipeViewChanged=YES;
            
        }
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            _swipeView.translatesAutoresizingMaskIntoConstraints=YES;
            
            if ([APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
            {  [_swipeView setFrame:CGRectMake(16, 0,3*87, 65)];
            }
            else
            {
                [_swipeView setFrame:CGRectMake(16, 0,4*87, 65)];
            }
            
            iSwipeViewChanged=YES;
            
        }
        
        
    }
    
    if( iSwipeViewChanged)
    {
        if(fixedMenuArray.count*87<=_fixedMenuView.frame.size.width)
        {
            _fixedMenuView.translatesAutoresizingMaskIntoConstraints=YES;
            
            [_fixedMenuView setFrame:CGRectMake(_swipeView.frame.size.width, 0,fixedMenuArray.count*87, 65)];
        }
    }
    


    if([self.frameWorkPopOver isPopoverVisible])
    {
        IsFrameworkPopOverOpen=YES;
        [self.frameWorkPopOver dismissPopoverAnimated:YES];
    }
    else if ([self.practitionerPopOver isPopoverVisible])
    {
        [self.practitionerPopOver dismissPopoverAnimated:YES];
    }
    else if ([self.popover isPopoverVisible])
    {
        [self.popover dismissPopoverAnimated:YES];

    }
    
    else
    {
        IsFrameworkPopOverOpen=NO;
    }
    
    
    if([_controller isPopoverVisible])
    
    {
        isNotificationOpen=YES;
        [_controller dismissPopoverAnimated:YES];
        
        
    }
    else
    {
        isNotificationOpen=NO;
        
    }
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
       if(IsFrameworkPopOverOpen)
    {
        [self frameworkList:self.tableViewListButton];
    }
    
    if(isNotificationOpen)
    {
        [self notificationBtnAction:self.notification_btn];
        
    }
    [self viewDidAppear:YES];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.containerViewController = segue.destinationViewController;
    }
}

- (IBAction)practitionerProfileAction:(id)sender
{
        self.popoverPractitionerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
        self.popoverPractitionerProfile.delegate = self;
        self.popoverPractitionerProfile.cellType=KCellTypePractitioner;

        self.practitionerPopOver = [[WYPopoverController alloc] initWithContentViewController:self.popoverPractitionerProfile];

        self.practitionerPopOver.theme.tintColor = [UIColor clearColor];
        self.practitionerPopOver.theme.fillTopColor = [UIColor clearColor];
        self.practitionerPopOver.theme.fillBottomColor = [UIColor clearColor];
        self.practitionerPopOver.theme.glossShadowColor = [UIColor clearColor];
        self.practitionerPopOver.theme.outerShadowColor = [UIColor clearColor];
        self.practitionerPopOver.theme.outerStrokeColor = [UIColor clearColor];
        self.practitionerPopOver.theme.innerShadowColor = [UIColor clearColor];
        self.practitionerPopOver.theme.innerStrokeColor = [UIColor clearColor];
        self.practitionerPopOver.theme.overlayColor = [UIColor clearColor];
        self.practitionerPopOver.theme.glossShadowBlurRadius = 0.0f;
        self.practitionerPopOver.theme.borderWidth = 0.0f;
        self.practitionerPopOver.theme.arrowBase = 0.0f;
        self.practitionerPopOver.theme.arrowHeight = 0.0f;
        self.practitionerPopOver.theme.outerShadowBlurRadius = 0.0f;
        self.practitionerPopOver.theme.outerCornerRadius = 0.0f;
        self.practitionerPopOver.theme.minOuterCornerRadius = 0.0f;
        self.practitionerPopOver.theme.innerShadowBlurRadius = 0.0f;
        self.practitionerPopOver.theme.innerCornerRadius = 0.0f;
        self.practitionerPopOver.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.practitionerPopOver.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.practitionerPopOver.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
        self.practitionerPopOver.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.practitionerPopOver.wantsDefaultContentAppearance = NO;

        self.practitionerPopOver.theme.arrowHeight = 0.0f;
        self.practitionerPopOver.theme.arrowBase = 0;
    int height=0;
    self.popoverPractitionerProfile.dataArray=@[@"View Profile",@"Logout"];
    for (int count=0;count<self.popoverPractitionerProfile.dataArray.count; count++)
    {
        height=height+45;
    }
    CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];

    self.popoverPractitionerProfile.tableView.scrollEnabled=YES;
    self.practitionerPopOver.popoverContentSize = CGSizeMake(230, height);
    CGRect rect=((UIButton *)sender).frame;
    int offsetX = 0;
    int offsetY = -4;
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
    {
        offsetX = 240;
        offsetY = 60;
    }

    rect.origin.y += originInSuperview.y + offsetY;
    rect.origin.x = originInSuperview.x + offsetX;          // to add padding for the removed thumbnail and list icon

    [self.practitionerPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

}

- (IBAction)listButtonClicked:(id)sender
{
    [self.containerViewController showListViewController];
    self.thumbnailButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.thumbnailButton.imageView.image = [UIImage imageNamed:@"icon_thumbnail"];
    self.listButton.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    [self.listButton setImage:[UIImage imageNamed:@"icon_list_selected"] forState:UIControlStateNormal];
    [self.listButton setSelected:self.listButton.isSelected];

    thumbnailSelected = false;
}

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{

    if(swipeView.tag==1)
    {
      return swipeViewArray.count;
    }
    else
    {
        return fixedMenuArray.count;
    }
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(swipeView.tag==1)
    {
        if (!view)
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil][0];
        }

        for (UIView *subview in view.subviews)
        {
            if([subview isKindOfClass:[UILabel class]])
            {
                NSString *tempString = [swipeViewArray objectAtIndex:index];
                ((UILabel *)subview).text=[swipeViewArray objectAtIndex:index];

                if([tempString isEqualToString:@"Planning Sheet"])
                {
                    ((UILabel *)subview).text= @"Planning\nSheet";
                }
               else if([tempString isEqualToString:@"Progress Check"])
               {
                   ((UILabel *)subview).text= @"Progress\nCheck";
               }

                // Temporary HACK needed to be fixed later
                if([tempString isEqualToString:@"EYFS Check"])
                {
                    if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
                    {
                    
                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    {
                        [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:YES];

                    }
                    else
                    {
                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:NO];
                    }
                    }
                    else
                    {
                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:NO];
                    }
                }
                else if ([tempString isEqualToString:@"Montessori Tracker"]){
                    
                    if ([APICallManager sharedNetworkSingleton].settingObject.montessori)
                    {
                        if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                        {
                            [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                            [((UILabel *)subview) setUserInteractionEnabled:YES];
                            
                        }
                        else
                        {
                            [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                            [((UILabel *)subview) setUserInteractionEnabled:NO];
                        }

                     }
                    else
                    {
                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:NO];
                    
                    }
                    
             }
                else if ([tempString isEqualToString:@"ECaT Summary"]){
                    
                    // Ecat to be enabled every time whether a child/multiple children/no child is selected.
                    
                    
//                    if ([APICallManager sharedNetworkSingleton].settingObject.ecat)
//                    {
//                        if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
//                        {
                            [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                            [((UILabel *)subview) setUserInteractionEnabled:YES];
                            
//                        }
//                        else
//                        {
//                            [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                            [((UILabel *)subview) setUserInteractionEnabled:NO];
//                        }
//
//                    }
//                    else
//                    {
//                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                        [((UILabel *)subview) setUserInteractionEnabled:NO];
//
//                    }
                    }
                if([tempString isEqualToString:@"CoEL Summary"])
                {
                    // Ecat to be enabled every time whether a child/multiple children/no child is selected.
                    
                    //                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    //                    {
                    [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                    [((UILabel *)subview) setUserInteractionEnabled:YES];
                    //                    }
                    //                    else
                    //                    {
                    //                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                    //                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    //                    }
                }

                else if([tempString isEqualToString:@"Observation Tracker"]  || [tempString isEqualToString:@"Planning Sheet"])
                {
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 0)
//                    {
                        [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:YES];

//                    }
//                    else
//                    {
//                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                        [((UILabel *)subview) setUserInteractionEnabled:NO];
//                    }
                }
                // Permanently disabling ecat for now
//                else if( [tempString isEqualToString:@"ECaT Summary"])
//                {
//                    [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                    [((UILabel *)subview) setUserInteractionEnabled:NO];
//                }
               else if([tempString isEqualToString:@"Progress Check"])
               {
//                   if([APICallManager sharedNetworkSingleton].cacheChildren.count <= 1)
//                   {
                       [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                       [((UILabel *)subview) setUserInteractionEnabled:YES];

//                   }
//                   else
//                   {
//                       [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                       [((UILabel *)subview) setUserInteractionEnabled:NO];
//                   }
               }


            }
            if([subview isKindOfClass:[UIButton class]])
            {
                NSString *tempString = [swipeViewArray objectAtIndex:index];
                [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                
                ((UIButton *)subview).superview.tag=1;
                if([tempString isEqualToString:@"Summative Reports"])
                {
                   ((UIButton *)subview).tag=211;
                }
                if([tempString isEqualToString:@"Refresh In-Out"])
                {
                    ((UIButton *)subview).tag=212;
                }
                if([tempString isEqualToString:@"Upload Queue"])
                {
                    ((UIButton *)subview).tag=213;
                }
          
                //
                 // Temporary HACK needed to be fixed later
                if([tempString isEqualToString:@"EYFS Check"])
                {
                  ((UIButton *)subview).tag=201;
                    if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
                    {
                        
                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                         [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                         [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    }
                       
                    }
                    else
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    }
                    
                }
                if([tempString isEqualToString:@"Montessori Tracker"])
                {
                    ((UIButton *)subview).tag=202;
                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    }
                }
                if([tempString isEqualToString:@"ECaT Summary"])
                {
                    ((UIButton *)subview).tag=203;
                      // Ecat to be enabled every time whether a child/multiple children/no child is selected.
                    
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
//                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
//                    }
//                    else
//                    {
//                        [((UIButton *)subview) setUserInteractionEnabled:NO];
//                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
//                    }
                }
                if([tempString isEqualToString:@"CoEL Summary"])
                {
                    ((UIButton *)subview).tag=204;
                    // Ecat to be enabled every time whether a child/multiple children/no child is selected.
                    
                    //                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    //                    {
                    [((UIButton *)subview) setUserInteractionEnabled:YES];
                    [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                    //                    }
                    //                    else
                    //                    {
                    //                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                    //                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    //                    }
                }

//|| [tempString isEqualToString:@"CoEL Summary"]
                else if([tempString isEqualToString:@"Observation Tracker"]   || [tempString isEqualToString:@"Planning Sheet"])
                {
                    if([tempString isEqualToString:@"Observation Tracker"])
                       {
                        ((UIButton *)subview).tag=206;
                       }
                    if([tempString isEqualToString:@"Planning Sheet"])
                    {
                     ((UIButton *)subview).tag=207;
                    }
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 0)
//                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];

//                    }
//                    else
//                    {
//                        [((UIButton *)subview) setUserInteractionEnabled:NO];
//                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
//                    }
                }
                else if( [tempString isEqualToString:@"ECaT Summary"])
                {
                    [((UIButton *)subview) setUserInteractionEnabled:YES];
                    [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                }
                else if([tempString isEqualToString:@"Progress Check"])
                {
                    ((UIButton *)subview).tag=205;
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count <= 1)
//                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index] ]] forState:UIControlStateNormal];

//                    }
//                    else
//                    {
//                        [((UIButton *)subview) setUserInteractionEnabled:NO];
//                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[swipeViewArray objectAtIndex:index]]]] forState:UIControlStateNormal];
//                    }
                }

            }
        }
    }
    else
    {
        if (!view)
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"ItemView" owner:self options:nil][0];
        }

        for (UIView *subview in view.subviews)
        {
            ;
            // [self openSummativeReportsVC];

            
            if([subview isKindOfClass:[UILabel class]])
            {
                ((UILabel *)subview).text=[fixedMenuArray objectAtIndex:index];

                // Temporary hack to disable Daily Diary Button while it is under development
                NSString *tempString = [fixedMenuArray objectAtIndex:index];
                if([tempString isEqualToString:@"Daily Diary"])
                {
                   
                    if (![APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
                    {
                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:NO];
                        
                    }
                      // [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
else
{
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1||[APICallManager sharedNetworkSingleton].cacheChildren.count>1)
//                    {
                        [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:YES];
}

                //    }
//                    else
//                    {
//                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
//                        [((UILabel *)subview) setUserInteractionEnabled:NO];
//                    }
                }
              else  if([tempString isEqualToString:@"Summative Reports"])
                {
                    
                
                        [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:YES];
                    
                    
                }

                else if([tempString isEqualToString:@"Learning Journey"])
                {
                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    {
                        [((UILabel *)subview) setTextColor:[UIColor blackColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:YES];

                    }
                    else
                    {
                        [((UILabel *)subview) setTextColor:[UIColor lightGrayColor]];
                        [((UILabel *)subview) setUserInteractionEnabled:NO];
                    }
                }

            }
            if([subview isKindOfClass:[UIButton class]])
            {
                
                [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index] ]] forState:UIControlStateNormal];

                 // Temporary hack to disable Daily Diary Button while it is under development
                NSString *tempString = [fixedMenuArray objectAtIndex:index];
                if([tempString isEqualToString:@"Daily Diary"])
                {
                    ((UIButton *)subview).tag=107;
                    if (![APICallManager sharedNetworkSingleton].settingObject.dailyDiary)
                    {
                       
                         [((UIButton *)subview) setUserInteractionEnabled:NO];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                    //[((UIButton *)subview) setUserInteractionEnabled:NO];
//                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1||[APICallManager sharedNetworkSingleton].cacheChildren.count>1)
//                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                    }
//                    }
//                    else
//                    {
//                        [((UIButton *)subview) setUserInteractionEnabled:NO];
//                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index]]]] forState:UIControlStateNormal];
//                    }
//
                }
                else  if([tempString isEqualToString:@"Summative Reports"])
                {
                    
                    ((UIButton *)subview).tag=211;
             
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                

                    
                }
                else if([tempString isEqualToString:@"Learning Journey"])
                {
                    ((UIButton *)subview).tag=108;
                    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:YES];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index] ]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [((UIButton *)subview) setUserInteractionEnabled:NO];
                        [((UIButton *)subview) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[swipeDictionary objectForKey:[fixedMenuArray objectAtIndex:index]]]] forState:UIControlStateNormal];
                    }
                }
                else if([tempString isEqualToString:@"Draft List"])
                {
                  ((UIButton *)subview).tag=110;
                }
                else if([tempString isEqualToString:@"New Observation"])
                {
                   ((UIButton *)subview).tag=109;
                    
                }
                
                ((UIButton *)subview).superview.tag=2;

            }
        }

    }
    
   
    return view;
}

#pragma mark -
#pragma mark Control events

- (IBAction)pressedButton:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    
       // Fixed Menu Buttons
    if(((UIButton *)sender).tag==110 && ((UIButton *)sender).superview.tag==2)
    {
        [self loadDraftList];
    }
     else if(((UIButton *)sender).tag==107 && ((UIButton *)sender).superview.tag==2)
    {
       // [self loadNewObservation];
       //
        [self loadDiary];

    }
    else if(((UIButton *)sender).tag==109 && ((UIButton *)sender).superview.tag==2)
    {
        
        [self loadNewObservation];
       // [self loadLearningJourney];
    }
    else if(((UIButton *)sender).tag==108 && ((UIButton *)sender).superview.tag==2)
    {
        [self loadLearningJourney];
    }
  
    // Swipe Menu Buttons
    else if(((UIButton *)sender).tag==207 && ((UIButton *)sender).superview.tag==1)
    {
        [self loadPlanningSheet];
    }
    else if(((UIButton *)sender).tag==206 && ((UIButton *)sender).superview.tag==1)
    {
        [self loadObservationTracker];
    }
    else if(((UIButton *)sender).tag==205 && ((UIButton *)sender).superview.tag==1)
    {
        [self loadProgressCheck];
    }
    else if(((UIButton *)sender).tag==201 && ((UIButton *)sender).superview.tag==1)
    {
        [self loadEYFSLog];
    }
    else if(((UIButton *)sender).tag==202 && ((UIButton *)sender).superview.tag==1)
    {
        //[self loadCoelSummary];
        [self loadMontessoriTracker];
    }
    else if(((UIButton *)sender).tag==203 && ((UIButton *)sender).superview.tag==1)
    {
        [self loadEcatSummary];
    }
   else if(((UIButton *)sender).tag==204 && ((UIButton *)sender).superview.tag==1)
   {
        [self loadCoelSummary];
    }
   else if(((UIButton *)sender).tag==211 && ((UIButton *)sender).superview.tag==2)
   {
    [self openSummativeReportsVC];
   }
   else if(((UIButton *)sender).tag==212 && ((UIButton *)sender).superview.tag==1)
   {
       GridViewController *grid= ((GridViewController *)[self.containerViewController.childViewControllers objectAtIndex:0]);
       Reachability *reachability;
       reachability = [Reachability reachabilityForInternetConnection];
       NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
       if(remoteHostStatus == NotReachable) {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"No Data Network Available. Please turn Data Network On and than Try Again Later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
           [alert show];
       }
       else
       {
           
           MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:grid.view animated:YES];
           [grid getRegistryINOUT];
           
       }
   }
   else if(((UIButton *)sender).tag==213 && ((UIButton *)sender).superview.tag==1)
   {
       appDelegate.ButtonHideFlag =1;
       
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
       DraftListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DraftListViewControllerId"];
       controller.isUploadQueue = YES;
       [self.practitionerPopOver dismissPopoverAnimated:NO];
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

-(void) loadDraftList
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"draftList");
    appDelegate.ButtonHideFlag=0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    DraftListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DraftListViewControllerId"];
    controller.isUploadQueue = NO;
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

-(void) loadEYFSLog
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"EYFS Log");
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Please Select at least a Child";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//        {
//            hud.yOffset=280;
//        }
//        else
//        {
//            hud.yOffset=400;
//        }
//
//        [hud hide:YES afterDelay:1];
        //[self.view makeToast:@"Please Select at least a Child"];


        [self.view makeToast:@"Please Select a Child and then click on this menu option" duration:1.0f position:CSToastPositionBottom];
    }
    else
    {
        NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

        CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                         NULL,

                                                                         (CFStringRef)PinunsafeString,

                                                                         NULL,

                                                                         CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                         kCFStringEncodingUTF8

                                                                         );
        NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

        CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (

                                                                              NULL,

                                                                              (CFStringRef)passWordunsafeString,

                                                                              NULL,

                                                                              CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                              kCFStringEncodingUTF8

                                                                              );
        NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
        strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        WebViewViewController *webViewController = [[WebViewViewController alloc] init];
        webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/eyfs.php?practitioner_id=%@&practitioner_pin=%@&api_key=%@&api_password=%@&child_id=%@&version_number=2",[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString, [APICallManager sharedNetworkSingleton].apiKey,PassWordString, [APICallManager sharedNetworkSingleton].cacheChild.childId];
        for(UIView *view in self.view.subviews)
        {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
        }
        [self.navigationController pushViewController:webViewController animated:YES];
        webViewController.titleString =@"EYFS Check";

        NSLog(@"Cheking URL For EYFS %@",webViewController.strURL);
    }
}
 

-(void) loadNewObservation
{
    NSLog(@"NewObserVation");
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count > 0) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        NewObservationViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewObservationIdentifier"];
        controller.parentVC = self;
        controller.isEditingAllowed=YES;
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
    else
    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Please Select At Least One Child to Add Observations.";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//        {
//            hud.yOffset=280;
//        }
//        else
//        {
//            hud.yOffset=400;
//        }
//        [hud hide:YES afterDelay:1];
       // [self.view makeToast:@"Please Select At Least One Child to Add Observations."];


        [self.view makeToast:@"Please Select At Least One Child to Add Observations." duration:1.0f position:CSToastPositionBottom];
    }
}

-(void)loadDiary{
  
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Daily Diary");
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count==1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        DailyDiaryViewController  *controller = [storyboard instantiateViewControllerWithIdentifier:@"DailyDiaryIdentifier"];
       //controller.parentVC = self;
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
    else //if([APICallManager sharedNetworkSingleton].cacheChildren.count>1)
    {
       // https://demo.eylog.co.uk/trunk//wp-content/themes/responsive-child/mobile/diary_group_view.php?nursery_id=5&group_id=0&practitioner_id=300&practitioner_pin=3093
        NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
        
        CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (
                                                                         
                                                                         NULL,
                                                                         
                                                                         (CFStringRef)PinunsafeString,
                                                                         
                                                                         NULL,
                                                                         
                                                                         CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                         
                                                                         kCFStringEncodingUTF8
                                                                         
                                                                         );
        NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;
        
        CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (
                                                                              
                                                                              NULL,
                                                                              
                                                                              (CFStringRef)passWordunsafeString,
                                                                              
                                                                              NULL,
                                                                              
                                                                              CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                              
                                                                              kCFStringEncodingUTF8
                                                                              
                                                                              );
        NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
        strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        WebViewViewController *webViewController = [[WebViewViewController alloc] init];
        webViewController.strURL = [NSString stringWithFormat:@"%@/api/webview/diary_group_view.php?nursery_id=%@&group_id=0&practitioner_id=%@&practitioner_pin=%@&&api_key=%@&api_password=%@",[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].nurseryId,
      [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString,[APICallManager sharedNetworkSingleton].apiKey,PassWordString];
        for(UIView *view in self.view.subviews)
        {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
        }
        [self.navigationController pushViewController:webViewController animated:YES];
        webViewController.titleString =@"Daily Diary";
    }
}

-(void) loadPlanningSheet
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Planning Sheet");

    NSMutableArray *childIds = [[NSMutableArray alloc] init];

    for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren) {
        [childIds addObject:child.childId];
    }
    NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

    CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                     NULL,

                                                                     (CFStringRef)PinunsafeString,

                                                                     NULL,

                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                     kCFStringEncodingUTF8

                                                                     );
    NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

    CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (

                                                                          NULL,

                                                                          (CFStringRef)passWordunsafeString,

                                                                          NULL,

                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                          kCFStringEncodingUTF8

                                                                          );
    NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
    strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Edited by Ankit Khetrapal as pe inputs from prashant
    WebViewViewController *webViewController = [[WebViewViewController alloc] init];
    webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/planning_sheet.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@",
                                [APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].apiKey, PassWordString,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString ];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:webViewController animated:YES];


//    webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/planning_sheet.php?api_key=%@&api_password=%@&group_id=%@&practitioner_id=%@&practitioner_pin=%@",
//                                [APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].apiKey, PassWordString,[APICallManager sharedNetworkSingleton].cachePractitioners.groupId,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString ];
//    [self.navigationController pushViewController:webViewController animated:YES];

    webViewController.titleString =@"Planning Sheet";
}


-(void) loadLearningJourney
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Learning Journey");
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count != 1) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Please select only one Child";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//        {
//            hud.yOffset=280;
//        }
//        else
//        {
//            hud.yOffset=400;
//        }
//        [hud hide:YES afterDelay:3];
        //[self.view makeToast:@"Please select only one Child"];
        [self.view makeToast:@"Please select only one Child" duration:1.0f position:CSToastPositionBottom];
    }
    else
    {
        LearningJourneyViewController *view=[[LearningJourneyViewController alloc] initWithNibName:@"LearningJourneyViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
        
        
//        
//        NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
//
//        CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (
//
//                                                                         NULL,
//
//                                                                         (CFStringRef)PinunsafeString,
//
//                                                                         NULL,
//
//                                                                         CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
//
//                                                                         kCFStringEncodingUTF8
//
//                                                                         );
//        NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;
//
//        CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (
//
//                                                                              NULL,
//
//                                                                              (CFStringRef)passWordunsafeString,
//
//                                                                              NULL,
//
//                                                                              CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
//
//                                                                              kCFStringEncodingUTF8
//
//                                                                              );
//        NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
//        strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//         [[NSURLCache sharedURLCache] removeAllCachedResponses];
//        WebViewViewController *webViewController = [[WebViewViewController alloc] init];
//
//
////        webViewController.strURL = [NSString stringWithFormat:@"%@api/learning_journey.php?practitioner_id=%@&practitioner_pin=%@&api_key=%@&api_password=%@&child_id=%@&version_number=2",[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString, [APICallManager sharedNetworkSingleton].apiKey, PassWordString, [APICallManager sharedNetworkSingleton].cacheChild.childId];
//
//    // To be revoked later
//
//    //int r=arc4random_uniform(512);
//    webViewController.strURL = [NSString stringWithFormat:@"%@LearningJourneyWebview/index.html?practitioner_id=%@&practitioner_pin=%@&api_key=%@&api_password=%@&child_id=%@&version_number=%@",[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString, [APICallManager sharedNetworkSingleton].apiKey, PassWordString, [APICallManager sharedNetworkSingleton].cacheChild.childId,self.randNumber];
//        for(UIView *view in self.view.subviews)
//        {
//            if([view isKindOfClass:[MBProgressHUD class]])
//            {
//                MBProgressHUD *hud=(MBProgressHUD *)view;
//                [hud removeFromSuperview];
//                hud=nil;
//                
//            }
//        }
//        [self.navigationController pushViewController:webViewController animated:YES];
//        webViewController.titleString =@"Learning Journey";
   }
}


-(void) loadCoelSummary
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"COEL Summary");

    //        if ([APICallManager sharedNetworkSingleton].cacheChildren == nil || [APICallManager sharedNetworkSingleton].cacheChildren.count <= 0) {
    //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //            hud.mode = MBProgressHUDModeText;
    //            hud.labelText = @"Please Select at least a Child";
    //            hud.margin = 10.f;
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
    //            [hud hide:YES afterDelay:3];
    //        }
    //        else
    //        {
    NSMutableArray *childIds = [[NSMutableArray alloc] init];

    for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren) {
        [childIds addObject:child.childId];
    }
    NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;



    CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (



                                                                     NULL,



                                                                     (CFStringRef)PinunsafeString,



                                                                     NULL,



                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),



                                                                     kCFStringEncodingUTF8



                                                                     );

    NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;



    CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (



                                                                          NULL,



                                                                          (CFStringRef)passWordunsafeString,



                                                                          NULL,



                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),



                                                                          kCFStringEncodingUTF8



                                                                          );

    NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;

    strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];





    WebViewViewController *webViewController = [[WebViewViewController alloc] init];

    webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/coel.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@",

                                [APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].apiKey,PassWordString, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString  ];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:webViewController animated:YES];

    webViewController.titleString =@"CoEL Summary";

    //   }
}

-(void) loadObservationTracker
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"ObserVation Tracker");
    if ([APICallManager sharedNetworkSingleton].cacheChildren <= 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Please Select at least a Child";
//        hud.margin = 10.f;
//        hud.userInteractionEnabled=YES;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//        {
//            hud.yOffset=280;
//        }
//        else
//        {
//            hud.yOffset=400;
//        }
//        [hud hide:YES afterDelay:1];
        //[self.view makeToast:@"Please Select at least a Child"];

        [self.view makeToast:@"Please Select a Child and then click on this menu option" duration:1.0f position:CSToastPositionBottom];
    }
    else
    {
        NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

        CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                         NULL,

                                                                         (CFStringRef)PinunsafeString,

                                                                         NULL,

                                                                         CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                         kCFStringEncodingUTF8

                                                                         );
        NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

        CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (

                                                                              NULL,

                                                                              (CFStringRef)passWordunsafeString,

                                                                              NULL,

                                                                              CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                              kCFStringEncodingUTF8

                                                                              );
        NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
        strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        WebViewViewController *webViewController = [[WebViewViewController alloc] init];
        webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/observation.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@" ,
                                    [APICallManager sharedNetworkSingleton].serverURL, [APICallManager sharedNetworkSingleton].apiKey, PassWordString,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString];

        // to append child id to the url id there is any selection from the previous layot if not we will show the entire data
        if([APICallManager sharedNetworkSingleton].cacheChildren.count > 0)
        {
            webViewController.strURL = [webViewController.strURL stringByAppendingString:@"&child_ids="];
            int counter = 1;
            for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren)
            {
                webViewController.strURL = [webViewController.strURL stringByAppendingString:[NSString stringWithFormat:@"%@%@",child.childId,counter < [APICallManager sharedNetworkSingleton].cacheChildren.count? @",": @""]];
                counter++;
            }
        }

        NSLog(@"%@",webViewController.strURL);

        for(UIView *view in self.view.subviews)
        {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
        }

        [self.navigationController pushViewController:webViewController animated:YES];
        webViewController.titleString =@"Observation Tracker";
    }
}

-(void) loadProgressCheck
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Progress Check");
    WebViewViewController *webViewController = [[WebViewViewController alloc] init];
    NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

    CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                     NULL,

                                                                     (CFStringRef)PinunsafeString,

                                                                     NULL,

                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                     kCFStringEncodingUTF8

                                                                     );
    NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

    CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (

                                                                          NULL,

                                                                          (CFStringRef)passWordunsafeString,

                                                                          NULL,

                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                          kCFStringEncodingUTF8

                                                                          );
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count > 0) {

        NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;

        webViewController.strURL = [NSString stringWithFormat: @"%@api/tracker/GroupProgressTracker.php?api_key=%@&api_password=%@&child_id=%@&practitioner_id=%@&practitioner_pin=%@"
                                    ,[APICallManager sharedNetworkSingleton].serverURL, [APICallManager sharedNetworkSingleton].apiKey,PassWordString,childID, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString];
    }
    else
    {

        webViewController.strURL = [NSString stringWithFormat: @"%@api/tracker/GroupProgressTracker.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@"
                                    ,[APICallManager sharedNetworkSingleton].serverURL, [APICallManager sharedNetworkSingleton].apiKey,PassWordString, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString];
    }

    NSLog(@"Progress check URL %@",webViewController.strURL);
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.titleString=@"Progress Check";
}

-(void)loadMontessoriTracker{

    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Progress Check");
    WebViewViewController *webViewController = [[WebViewViewController alloc] init];
    NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                     NULL,

                                                                     (CFStringRef)PinunsafeString,

                                                                     NULL,

                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                     kCFStringEncodingUTF8

                                                                     );
    NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

    CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (
                                                                          NULL,

                                                                          (CFStringRef)passWordunsafeString,

                                                                          NULL,

                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                          kCFStringEncodingUTF8

                                                                          );
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count > 0) {

        NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;
        webViewController.strURL = [NSString stringWithFormat: @"%@api/tracker/montessoriTracker.php?api_key=%@&api_password=%@&child_id=%@&practitioner_id=%@&practitioner_pin=%@"
                                    ,[APICallManager sharedNetworkSingleton].serverURL, [APICallManager sharedNetworkSingleton].apiKey,PassWordString,childID, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString];
    }

    NSLog(@"Checking Server URL %@",webViewController.strURL);
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.titleString=@"Montessori Tracker";

}

-(void)loadEcatSummary{

    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSLog(@"Progress Check");
    WebViewViewController *webViewController = [[WebViewViewController alloc] init];
    NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                     NULL,

                                                                     (CFStringRef)PinunsafeString,

                                                                     NULL,

                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                     kCFStringEncodingUTF8

                                                                     );
    NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

    CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (
                                                                          NULL,

                                                                          (CFStringRef)passWordunsafeString,

                                                                          NULL,

                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                          kCFStringEncodingUTF8

                                                                          );
   // if ([APICallManager sharedNetworkSingleton].cacheChildren.count > 0) {

        NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;
        webViewController.strURL = [NSString stringWithFormat: @"%@api/tracker/ecat.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@"
                                    ,[APICallManager sharedNetworkSingleton].serverURL, [APICallManager sharedNetworkSingleton].apiKey,PassWordString, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId,PinString];
   // }

    NSLog(@"Checking Server URL %@",webViewController.strURL);
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud=(MBProgressHUD *)view;
            [hud removeFromSuperview];
            hud=nil;
            
        }
    }
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController.titleString=@"ECaT Summary";

}

-(NSMutableDictionary *)sortChildren:(NSArray *)childrenArray
{
    tempChildrenArray=[[NSMutableArray alloc]init];

    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_PRACTITIONER]==NSOrderedSame) {

            if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
            {
                //childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
            }
            else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
            {
               // childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId withPractitionerGroupName:practitionerGroupName] mutableCopy];
               //  [tempChildrenArray addObject:@"All Groups"];
            }
            else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
            {
                //childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
                 [tempChildrenArray addObject:@"All Groups"];
            }
    }else{
        [tempChildrenArray addObject:@"All Groups"];
    }


    NSMutableDictionary *childrenDict=[[NSMutableDictionary alloc]init];
    for (int count=0; count<childrenArray.count; count++)
    {
        Child *child=[childrenArray objectAtIndex:count];
        if([childrenDict objectForKey:child.groupName] == nil && ![child.groupName isEqualToString:@""])
        {
            @try
            {
                NSMutableArray *array = [NSMutableArray arrayWithObject:child];
                [childrenDict setObject:array forKey:child.groupName];
                [tempChildrenArray addObject:child.groupName];
            }
            @catch (NSException *exception)
            {
                NSLog(@"EXCEPTION IS %@",exception);
            }
        }else{
            NSMutableArray *array = [childrenDict objectForKey:child.groupName];
            [array addObject:child];
        }

    }
    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_PRACTITIONER] == NSOrderedSame) {
        if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
        {
            //childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
            [tempChildrenArray addObject:@"Key Children"];

        }else{
            [tempChildrenArray addObject:@"Key Children"];

        }
    }else{
        [tempChildrenArray addObject:@"Key Children"];
    }
   
    self.popoverViewController.dataArray=[tempChildrenArray mutableCopy];
    return [childrenDict mutableCopy];
}

- (IBAction)togglePopover:(UIButton *)sender
{
//    if (!self.popover)
//    {
        self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
        self.popoverViewController.delegate = self;
        self.popoverViewController.dataArray=[tempChildrenArray mutableCopy];
        self.popoverViewController.cellType=KCellTypeGroup;
        self.popoverViewController.isInRequired=YES;
    
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
        int height=0;
    
    for(int i=0;i<tempChildrenArray.count;i++)
    {
        height=height+45;
        
    }
    if([APICallManager sharedNetworkSingleton].settingObject.dailyDiary==1)
    {
        height=height+45;
    }
    if(height>self.view.frame.size.height/2)
    {
        height=self.view.frame.size.height/2+20;
        self.popoverViewController.tableView.scrollEnabled=YES;
    }
    else
    {
     self.popoverViewController.tableView.scrollEnabled=NO;
    }
        self.popover.popoverContentSize = CGSizeMake(230, height);
        self.popover.theme.arrowHeight = 0.0f;
        self.popover.theme.arrowBase = 0;
   
    CGRect rect = sender.frame;
    rect.origin.y += 35;
    rect.origin.x += 60;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}
-(void)openSummativeReportsVC
{
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self performSegueWithIdentifier:kEYLSummativeReportsSegueID sender:self];
}
#pragma mark - GroupSelectionDelegate
-(void)btnAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if([btn isSelected])
    {
    NSArray *array;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"NOT SELF.inTime ==%@ AND SELF.outTime ==%@ OR SELF.outTime ==%@ ",@"00:00",@"00:00",@"00:00:00"];
    if(childrenListForTableView==nil)
    {
        childrenListForTableView=[childrenList mutableCopy];
      
    }
    array =[childrenListForTableView filteredArrayUsingPredicate:predicate];
    
    beforeInArray=[NSMutableArray arrayWithArray:childrenListForTableView];
    childrenListForTableView=[array mutableCopy];
    NSDictionary *viewData=@{@"data": childrenListForTableView};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
      }
    else
    {
          childrenListForTableView=[NSMutableArray arrayWithArray:beforeInArray];
        NSDictionary *viewData=@{@"data": childrenListForTableView};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
        
    }

}
- (void)groupDidSelected:(NSString *)group withCellType:(NSString *)cellType
{
    if([cellType isEqualToString:KCellTypeGroup])
    {
         // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selection"];
        if ([group caseInsensitiveCompare:@"IN"]==NSOrderedSame) {
           
        }
        else
        {

        if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
        {
            childrenListForTableView=[childrenList copy];
            beforeInArray=[NSMutableArray arrayWithArray:childrenListForTableView];
            [self.popover dismissPopoverAnimated:YES];
        
        }
        else
        {
            if(childrenListForTableView==nil)
            {
                childrenListForTableView=[NSMutableArray new];
            }
                childrenListForTableView=[sortedChildrenDictionary objectForKey:group];
             beforeInArray=[NSMutableArray arrayWithArray:childrenListForTableView];
        }
        if ([group caseInsensitiveCompare:@"Key Children"]==NSOrderedSame) {
            
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
            childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
             beforeInArray=[NSMutableArray arrayWithArray:childrenListForTableView];
            if (childrenListForTableView.count==0) {
                [self.view makeToast:@"No Key Children for this practitioner." duration:1.0 position:CSToastPositionBottom];
                
                [self.popover dismissPopoverAnimated:YES];
                return;
            }
        }
        if(childrenListForTableView.count>0)
        {
            NSDictionary *viewData=@{@"data": childrenListForTableView};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
             beforeInArray=[NSMutableArray arrayWithArray:childrenListForTableView];
            [self.popover dismissPopoverAnimated:YES];
       }
        [self.groupButton setTitle:group forState:UIControlStateNormal];
        [self clearButtonAction:self];
            
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"selection"])
        {
            NSArray *array;
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"NOT SELF.inTime ==%@ AND SELF.outTime ==%@ OR SELF.outTime ==%@ ",@"00:00",@"00:00",@"00:00:00"];
            if(childrenListForTableView==nil)
            {
                childrenListForTableView=[childrenList mutableCopy];
            }
            array =[childrenListForTableView filteredArrayUsingPredicate:predicate];
            
            childrenListForTableView=[array mutableCopy];
            NSDictionary *viewData=@{@"data": childrenListForTableView};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
        }
            
        }

    }
    else if([cellType isEqualToString:KCellTypeFrame])
    {

        [self.frameWorkPopOver dismissPopoverAnimated:YES];
        if([group isEqualToString:@"New Observation"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            NewObservationViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewObservationIdentifier"];
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
        if([group isEqualToString:@"Refresh In-Out"])
        {
        GridViewController *grid= ((GridViewController *)[self.containerViewController.childViewControllers objectAtIndex:0]);
            Reachability *reachability;
            reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
            if(remoteHostStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"No Data Network Available. Please turn Data Network On and than Try Again Later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {

             MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:grid.view animated:YES];
             [grid getRegistryINOUT];
          
            }
            
       // [((GridViewController *)[self.containerViewController.childViewControllers objectAtIndex:0]).collectionViewController reloadData];
        }
        //Refresh In-Out
        else if ([group isEqualToString:@"Montessori Tracker"])
        {
            [self loadMontessoriTracker];
        }
        else if ([group isEqualToString:@"ECaT Summary"])
        {
            [self loadEcatSummary];
        }
        else if ([group isEqualToString:@"Upload Queue"])
        {
            appDelegate.ButtonHideFlag =1;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            DraftListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DraftListViewControllerId"];
            controller.isUploadQueue = YES;
            [self.practitionerPopOver dismissPopoverAnimated:NO];
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
        else if ([group isEqualToString:@"Summative Reports"])
        {

            [self openSummativeReportsVC];
            return;

//            if ([APICallManager sharedNetworkSingleton].cacheChildren.count <= 0) {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"Please Select at least a Child";
//                hud.margin = 10.f;
//                hud.removeFromSuperViewOnHide = YES;
//                hud.delegate =self;
//                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//                {
//                    hud.yOffset=280;
//                }
//                else
//                {
//                    hud.yOffset=400;
//                }
//                [hud hide:YES afterDelay:3];            }
//            else
//            {
//                NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
//
//                CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (
//
//                                                                                 NULL,
//
//                                                                                 (CFStringRef)PinunsafeString,
//
//                                                                                 NULL,
//
//                                                                                 CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
//
//                                                                                 kCFStringEncodingUTF8
//
//                                                                                 );
//                NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;
//
//                CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (
//
//                                                                                      NULL,
//
//                                                                                      (CFStringRef)passWordunsafeString,
//
//                                                                                      NULL,
//
//                                                                                      CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
//
//                                                                                      kCFStringEncodingUTF8
//
//                                                                                      );
//                NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
//                strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//
//
//                WebViewViewController *webViewController = [[WebViewViewController alloc] init];
//                webViewController.strURL = [NSString stringWithFormat:@"%@api/learning_journey.php?practitioner_id=%@&practitioner_pin=%@&api_key=%@&api_password=%@&child_id=%@&version_number=2",[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString, [APICallManager sharedNetworkSingleton].apiKey, PassWordString, [APICallManager sharedNetworkSingleton].cacheChild.childId];
//                [self.navigationController pushViewController:webViewController animated:YES];
//                webViewController.titleString =@"Summative Reports";
//            }
        }
        else if ([group isEqualToString:@"CoEL Summary"])
        {
            [self loadCoelSummary];
        }
        else if ([group isEqualToString:@"ECat Summary"])
        {
            NSMutableArray *childIds = [[NSMutableArray alloc] init];

            for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren) {
                [childIds addObject:child.childId];
            }


//            if ([APICallManager sharedNetworkSingleton].cacheChildren.count > 0) {
////                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
////                hud.mode = MBProgressHUDModeText;
////                hud.labelText = @"Please unselect the child";
////                hud.margin = 10.f;
////                hud.userInteractionEnabled=YES;
////                hud.removeFromSuperViewOnHide = YES;
////                hud.delegate =self;
////                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
////                {
////                    hud.yOffset=280;
////                }
////                else
////                {
////                    hud.yOffset=400;
////                }
////                [hud hide:YES afterDelay:1];
//                //[self.view makeToast:@"Please unselect the child"];
//                [self.view makeToast:@"Please unselect the child" duration:1.0f position:CSToastPositionBottom];
//            }
//            else
//            {
                NSString *PinunsafeString =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;

                CFStringRef PinString = CFURLCreateStringByAddingPercentEscapes (

                                                                                 NULL,

                                                                                 (CFStringRef)PinunsafeString,

                                                                                 NULL,

                                                                                 CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                                 kCFStringEncodingUTF8

                                                                                 );
                NSString *passWordunsafeString =[APICallManager sharedNetworkSingleton].apiPassword;

                CFStringRef PassWordString = CFURLCreateStringByAddingPercentEscapes (

                                                                                      NULL,

                                                                                      (CFStringRef)passWordunsafeString,

                                                                                      NULL,

                                                                                      CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),

                                                                                      kCFStringEncodingUTF8

                                                                                      );
                NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
                strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


                WebViewViewController *webViewController = [[WebViewViewController alloc] init];
                webViewController.strURL = [NSString stringWithFormat:@"%@api/tracker/ecat.php?api_key=%@&api_password=%@&practitioner_id=%@&practitioner_pin=%@"
                                            ,[APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].apiKey, PassWordString, [APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId, PinString];
            for(UIView *view in self.view.subviews)
            {
                if([view isKindOfClass:[MBProgressHUD class]])
                {
                    MBProgressHUD *hud=(MBProgressHUD *)view;
                    [hud removeFromSuperview];
                    hud=nil;
                    
                }
            }
                [self.navigationController pushViewController:webViewController animated:YES];
                webViewController.titleString =@"ECaT Summary";
           // }
        }
        else if ([group isEqualToString:@"Planning Sheet"])
        {
            [self loadPlanningSheet];
        }
        else if ([group isEqualToString:@"EYFS Check"])
        {
            [self loadEYFSLog];
        }
        else if ([group isEqualToString:@"Progress Check"])
        {
            [self loadProgressCheck];
        }
    }
    else if([cellType isEqualToString:KCellTypePractitioner])
    {
        if([group isEqualToString:@"Logout"])
        {
            [self.practitionerPopOver dismissPopoverAnimated:YES];
            [self backButton:self];
        }
        else
        {
            [self.practitionerPopOver dismissPopoverAnimated:YES];
        }
    }
  
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        isInPressed=NO;
        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup];
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
        isInPressed=NO;
        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup ];
    }
    else
    {
        [self searchChild:textField.text];
    }
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==1 && [string isEqualToString:@""])
    {
        isInPressed=NO;
        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup ];
    }
    return YES;
}

-(void)searchChild:(NSString *)practitionerString
{

    NSPredicate *firstNamePred = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@", practitionerString];

    NSPredicate *lastNamePred = [NSPredicate predicateWithFormat:@"SELF.lastName contains[cd] %@", practitionerString];

    NSArray *predicates = @[firstNamePred, lastNamePred];

    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];

    NSArray *currentGroup;
    NSString *group=self.groupButton.titleLabel.text;
    if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
    {
        currentGroup=[childrenList copy];
    }
    else if([tempChildrenArray containsObject:group])
    {
        currentGroup=[sortedChildrenDictionary objectForKey:group];
    }

    NSArray *filteredArray = [currentGroup filteredArrayUsingPredicate:compoundPredicate];
    if(filteredArray.count>0)
    {
        childrenListForTableView=[filteredArray mutableCopy];
        NSDictionary *viewData=@{@"data": childrenListForTableView};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
    }
    else
    {
        childrenListForTableView=@[];
        NSDictionary *viewData=@{@"data": childrenListForTableView};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
    }

     [self clearButtonAction:self];
}
//-(void)loadNotificationsHistory :(Practitioners *)practitioner
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        @autoreleasepool {
//            
//            if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
//                NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
//                
//                NSString *urlString=[NSString stringWithFormat:@"%@api/nurserynotifications",serverURL];
//                NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
//                                                [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",@"1",@"page",@"10",@"per_page",nil];
//                
//                [mapData setObject:practitioner.eylogUserId forKey:@"eylog_user_id"];
//                
//                NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                                      {
//                                                          
//                                                          if(error)
//                                                          {
//                                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
//                                                              
//                                                              
//                                                              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                                              
//                                                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//                                                              
//                                                              return;
//                                                          }
//                                                          [self saveNotificationHistoryData:data];
//                                                          
//                                                          
//                                                          
//                                                      }];
//                [postDataTask resume];
//                
//            }
//            else
//            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//                
//            }
//            
//        }
//        
//    });
//    
//}
//-(void)saveNotificationHistoryData:(NSData *)data
//{
//    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSMutableArray *arrayNotification=[NSMutableArray new];
//    
//    if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
//    {
//        NSArray *arrayData=[jsonDict objectForKey:@"data"];
//        [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:@"batchcount"] forKey:@"batchCount"];
//        
//        for(int i=0;i<arrayData.count;i++)
//        {
//            NotificationModel *model=[NotificationModel new];
//            NSDictionary *dict=[arrayData objectAtIndex:i];
//            model.childID=[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]];
//            model.type=[dict objectForKey:@"notificationType"];
//            model.tableID=[NSNumber numberWithInteger:[[dict objectForKey:@"notificationTableId"] integerValue]];
//            model.dateStr=[dict objectForKey:@"date_added"];
//            model.isRead=[[dict objectForKey:@"isRead"] integerValue];
//            
//            NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]]];
//            Child *child=[childArray lastObject];
//            
//            if([[dict objectForKey:@"notificationType"] isEqualToString:@"ddNotes"])
//            {
//                
//                model.title=@"Note added in Daily diary";
//                model.content=[[[@"Note added in Dialy diary of " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
//                
//            }
//            else if([[dict objectForKey:@"notificationType"] isEqualToString:@"comment"])
//                
//            {
//                model.title=@"New comment on observation";
//                model.content=[[[@"One new comment added by parent for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
//                
//            }
//            else
//                
//            {
//                
//                model.title=@"New observation published";
//                model.content=[[[@"New observation published for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
//                
//            }
//            
//            
//            [arrayNotification addObject:model];
//        }
//        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayNotification];
//        [userDefault setObject:myEncodedObject forKey:[NSString stringWithFormat:@"DataForNotification"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationForBatch" object:nil];
//    }
//    
//}

@end
