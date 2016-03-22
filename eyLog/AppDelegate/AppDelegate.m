
//
//  AppDelegate.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 23/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "APICallManager.h"
#import "Utils.h"
#import "NSString+SHAHashing.h"
#import "Reachability.h"
#import "InstallationViewController.h"
#import "ChilderenViewController.h"
#import "UncaughtExceptionHandler.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ChildInOutTime.h"
#import "GridViewController.h"
#import "eyLogNavigationViewController.h"
#import "Child.h"
#import "RegistryDataModal.h"
#import "ChildInfoDataModal.h"
#import "ObservationWithComentsViewController.h"
#import "DailyDiaryViewController.h"
#import "HomeViewController.h"
#import "LearningJourneyViewController.h"
#import "UIView+Toast.h"
#import "DailyDiaryViewController.h"




@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize ObservationFlag;
@synthesize HomesearchFlag;
@synthesize searchClicked;
@synthesize ButtonHideFlag;


+ (NSManagedObjectContext *) context {
    //return the context

    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return  [delegate managedObjectContext];
}

+ (NSManagedObjectContext *) childContext {

    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return  [delegate childContextModel];
}

+ (void) resetChildContext {

    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate resetChildContextModel];
}

-(NSManagedObjectContext *)childContextModel{
    if (_childContextModel == nil) {
        _childContextModel = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_childContextModel setParentContext:self.managedObjectContext];
    }
    return _childContextModel;
}

-(void)resetChildContextModel{
    _childContextModel = nil;
//
//    [_childContextModel reset];
//    [self childContextModel];
}
- (BOOL)isMyAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"eylog"]];
}

- (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions


{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Data"];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"StilUploading"])
    {
        NSArray *array=[NewObservation fetchAllObservationInContext:[AppDelegate context] withUniqueTabletOID:[[NSUserDefaults standardUserDefaults] objectForKey:@"StilUploading"]];
        NewObservation *obser=[array firstObject];
        obser.isUploading=NO;
              
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uploadEntity"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StilUploading"];
    
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject]);
    
    [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
    [self logUser];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
   // pageControl.backgroundColor = [UIColor blueColor];
    
    self.window.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    //checking last opened controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentViewController:) name:@"CurrentViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendDataToWebIfNetwork) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"myNotificationForBatch"
                                               object:nil];
  
    application.applicationIconBadgeNumber = 0;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
     //  [NSTimer scheduledTimerWithTimeInterval:60.0 target:self
    //                               selector:@selector(triggerUpload) userInfo:nil repeats:YES];


//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [application registerForRemoteNotifications];
//    }
//    else
//    {
//        // iOS < 8 Notifications
//        [application registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//    }
//
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        NSLog(@"iOS 8 Requesting permission for push notifications..."); // iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound categories:nil];
        [UIApplication.sharedApplication registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        NSLog(@"iOS 7 Registering device for push notifications..."); // iOS 7 and earlier
        [UIApplication.sharedApplication registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[paths objectAtIndex:0]);
    //[[APICallManager sharedNetworkSingleton] in]
    
    return YES;
}
- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
   
//    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
//    [CrashlyticsKit setUserName:@"Test User"];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }}

- (void)handleCurrentViewController:(NSNotification *)notification {
    if([[notification userInfo] objectForKey:@"lastViewController"]) {
        lastViewController = [[notification userInfo] objectForKey:@"lastViewController"];
    }
}

-(void)triggerUpload
{
//    if([Reachability reachabilityForInternetConnection].isReachable)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [[APICallManager sharedNetworkSingleton] uploadObservations];
//        });
//    }
}

//-(void)getServerUrl
//{
//    [[APICallManager sharedNetworkSingleton] getServerUrl];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    _becameActiveAfterNotication=NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _becameActiveAfterNotication=YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    _becameActiveAfterNotication=NO;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//     application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  
    if(![APICallManager sharedNetworkSingleton].newwObservationEntity.isUploaded)
    {
         [[NSUserDefaults standardUserDefaults] setObject:[APICallManager sharedNetworkSingleton].newwObservationEntity.uniqueTabletOID forKey:@"StilUploading"];
    }
   
    
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"eyLog" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"eyLog.sqlite"];

    NSError *error = nil;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSInferMappingModelAutomaticallyOption];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    return _persistentStoreCoordinator;
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
     NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *tokenStr = [deviceToken description];
//    NSString *pushToken =[[[tokenStr
//                              stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                             stringByReplacingOccurrencesOfString:@">" withString:@""]
//                            stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
  // [[[UIAlertView alloc] initWithTitle:@"title" message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [self application:application didReceiveRemoteNotification:userInfo];
      
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}
- (void)receiveNotification:(NSNotification *)notification1
{
    if ([[notification1 name] isEqualToString:@"myNotificationForBatch"]) {
        // NSDictionary *myDictionary = (NSDictionary *)notification1.object;
        UIViewController *vc = self.window.rootViewController;
        if([vc isKindOfClass:[eyLogNavigationViewController class]])
        {
            eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
            NSLog(@"%@", nav.viewControllers);
            
            if(nav.viewControllers.count>1)
            {
                if([[nav.viewControllers lastObject]isKindOfClass:[ChilderenViewController class]])
                {
                    ChilderenViewController *viewController=[nav.viewControllers lastObject];
                 NSString *str=  [[NSUserDefaults standardUserDefaults] objectForKey:@"batchCount"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(![viewController.controller isPopoverVisible])
                {
            if([str isEqualToString:@"0"])
            {
                [viewController.notification_Lbl setHidden:YES];
                [viewController.messageHolderImage setHidden:YES];
                
            }
            else
            {
                [viewController.notification_Lbl setHidden:NO];
                [viewController.messageHolderImage setHidden:NO];
                [viewController.notification_Lbl setText:[NSString stringWithFormat:@"%@",str]];
            }
                }
            
            
        });
        
//        
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        
//        NSData *myDecodedObject = [userDefault objectForKey: [NSString stringWithFormat:@"DataForNotification"]];
//        NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
          
                }
            }
        }
        //doSomething here.
    }
}

//Your app receives push notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    NSMutableArray *validateArray=[NSMutableArray new];
    
    validateArray=[[userInfo objectForKey:@"managersId"] mutableCopy];
    [validateArray addObject:[userInfo objectForKey:@"practitionerId"]];
    
    
    
    if(_becameActiveAfterNotication)
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self.intValue ==%d",[[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId integerValue]];
        
        NSArray *aary=[validateArray filteredArrayUsingPredicate:predicate];
        
        if(aary.count>0)
        {

            
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *home=[storyboard instantiateViewControllerWithIdentifier:@"next_vc"];
            [home loadNotificationsHistory:[APICallManager sharedNetworkSingleton].cachePractitioners];
        
        
        
            if([APICallManager sharedNetworkSingleton].isNetworkReachable)
            {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    @autoreleasepool {
                        
                        
                        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
                        
                        NSString *urlString=[NSString stringWithFormat:@"%@api/resetnotificationreadstatus",serverURL];
                        NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                                        [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",nil];
                        
                        [mapData setObject:[userInfo objectForKey:@"notification_id"] forKey:@"notification_id"];
                        
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
//                                                                          
//                                                                          NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                                                                          
//                                                                          NSData *myDecodedObject = [userDefault objectForKey:@"DataForNotification"];
//                                                                          NSArray *decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
//                                                                          
//                                                                          
//                                                                          NSMutableArray *array=[[NSMutableArray alloc] initWithArray:decodedArray];
//                                                                          NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.notificationId.intValue == %d",[[userInfo objectForKey:@"notification_id"] intValue]];
//                                                                          NSArray *new=[array filteredArrayUsingPredicate:predicate];
//                                                                          
//                                                                         NotificationModel *model= [new firstObject];
//                                                                         model.isRead=1;
//                                                                          
//                                                                          [array replaceObjectAtIndex:[array indexOfObject:[[array filteredArrayUsingPredicate:predicate] firstObject]] withObject:model];
//                                                                          
//                                                                         
//                                                                          NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
//                                                                          [userDefault setObject:myEncodedObject forKey:@"DataForNotification"];
 
                                                                          
                                                                          //[self.notification_Lbl setText:@"0"];
                                                                    }
                                                                      
                                                                  }
                                                                  
                                                                  
                                                              }];
                        [postDataTask resume];
                        
                        
                        
                        
                    }
                    
                });
                
                
            }
        dispatch_async(dispatch_get_main_queue(), ^{
        if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"comment"])
        {
           
            UIViewController *vc = self.window.rootViewController;
            if([vc isKindOfClass:[eyLogNavigationViewController class]])
            {
                eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                NSLog(@"%@", nav.viewControllers);
                
                if(nav.viewControllers.count>1)
                {
                    
                        LearningJourneyViewController *view=[[LearningJourneyViewController alloc] initWithNibName:@"LearningJourneyViewController" bundle:nil];
                        [view setObservationID:[NSNumber numberWithInt:[[userInfo objectForKey:@"observationId"] intValue]]];
                        view.isComeFromNotification=YES;
                        [nav pushViewController:view animated:YES];
  
                        
                    
                }
            }
            
            
            
        }
        
        if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"ddNotes"])
        {
             UIViewController *vc = self.window.rootViewController;
            if([vc isKindOfClass:[eyLogNavigationViewController class]])
            {
                eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                NSLog(@"%@", nav.viewControllers);
                
                if(nav.viewControllers.count>1)
                {
                    
                        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        DailyDiaryViewController *dd=[storyboard instantiateViewControllerWithIdentifier:@"DailyDiaryIdentifier"];
                        dd.isComeFromNotesNotifcation=YES;
                   // dd.strCurrentDate=
                        //   DailyDiaryViewController *dd=[[DailyDiaryViewController alloc] initWithNibName:@"DailyDiaryViewController" bundle:nil];
                        [dd setDiaryID:[NSNumber numberWithInt:[[userInfo objectForKey:@"observationId"] intValue]]];
                        [dd setChildID:[NSNumber numberWithInt:[[userInfo objectForKey:@"childid"] intValue]]];
                        [nav pushViewController:dd animated:YES];
                }
            }

            
        }
        if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"observation"])
        {
            
        
            UIViewController *vc = self.window.rootViewController;
            if([vc isKindOfClass:[eyLogNavigationViewController class]])
            {
                eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                NSLog(@"%@", nav.viewControllers);
                
                if(nav.viewControllers.count>1)
                {
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ChilderenViewController *dd=[storyboard instantiateViewControllerWithIdentifier:@"ChilderenViewController"];
                    [self.window.rootViewController.view setAlpha:0.5];
                    
                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
                    [hud setLabelText:@"Loading Observation"];
                    
//                    dd.isComeFromNotificationToLoadNewObser = YES;
//                    [dd viewWillAppear:YES];
                    
                    
                    [dd loadData:[NSNumber numberWithInt:[[userInfo objectForKey:@"observationId"] intValue]]];
                    
                    
//                    dd.isComeFromNotificationToLoadNewObser=YES;
//                    //   DailyDiaryViewController *dd=[[DailyDiaryViewController alloc] initWithNibName:@"DailyDiaryViewController" bundle:nil];
//                    [dd setDiaryID:[NSNumber numberWithInt:[[userInfo objectForKey:@"observationId"] intValue]]];
//                  
//                    [nav pushViewController:dd animated:YES];
//
                    
                    //ChilderenViewController
                }
                }
   
            
        }
        });
        
    }
        else
        {
            UIViewController *vc = self.window.rootViewController;
            if([vc isKindOfClass:[eyLogNavigationViewController class]])
            {
                eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                NSLog(@"%@", nav.viewControllers);
                if(![[userInfo objectForKey:@"notificationType"] isEqualToString:@"New Registry"]||[[userInfo objectForKey:@"notificationType"] isEqualToString:@"registryPublished"])
                
                {
                [self.window.rootViewController.view makeToast:@"Not for you" duration:2.0f position:CSToastPositionBottom];
                }
                
              
                
            }
        
        }
        
        
    }
    else
    {
    
    NSLog(@"Notification Recieved");
    if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"comment"]||[[userInfo objectForKey:@"notificationType"] isEqualToString:@"ddNotes"]||[[userInfo objectForKey:@"notificationType"] isEqualToString:@"observation"])
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self.intValue ==%d",[[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId integerValue]];
        
        NSArray *aary=[validateArray filteredArrayUsingPredicate:predicate];
        
     if(aary.count>0)
    {
       
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *home=[storyboard instantiateViewControllerWithIdentifier:@"next_vc"];
        [home loadNotificationsHistory:[APICallManager sharedNetworkSingleton].cachePractitioners];
        
    }
        
    }
    else if([userInfo objectForKey:@"registryPublished"])
    {
     NSDictionary *dataDict=[userInfo objectForKey:@"registryData"];
     NSArray *registry=[dataDict objectForKey:@"registry"];
    NSNumber *num=[NSNumber numberWithInteger:[[dataDict objectForKey:@"child_id"] integerValue]];
    NSDictionary *lastEntry= [registry lastObject];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:[dataDict objectForKey:@"date"]];
    
    NSString *string = [dateFormatter2 stringFromDate:dateFromString];
     
    NSTimeInterval uniqueTabletOIID = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: uniqueTabletOIID];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter3 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    NSLog(@"Current Date Time:%@",currentTime);
    
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    // Set the hour, minute, second to be zero
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // Create the date
    NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
    NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
    
    // Now Calculating the time difference
    NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
    NSDate *newDate = [dateFormatter dateFromString:currentTime];
    NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  num,@"childid",
                                  string,@"date",
                                  [lastEntry objectForKey:@"came_in_at"],@"intime",
                                  [lastEntry objectForKey:@"left_at"],@"outtime",
                                  @"1", @"uploadedflag",
                                  [NSNumber numberWithInteger:diff],@"timedifference",
                                  timeStampObj,@"uniqueTableID",nil];
     [Child updateRegistryArrayForChild:num :[NSMutableArray arrayWithArray:registry] forContext:[AppDelegate context]];
     NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:registry,string, nil];
    [Child updateDictionaryDataForInoutTime:dictionary :num forContext:[AppDelegate context]];
     //   NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];
    // create new entry for that date
     NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
     [dateFormatterNew setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *neWdate = [dateFormatter dateFromString:[dataDict objectForKey:@"date"]];
    NSString *newStr=[dateFormatterNew stringFromDate:neWdate];
    
    //
    if([newStr isEqualToString:[dateFormatterNew stringFromDate:[NSDate date]]])
    {
        [Child updateChild:num inTime:[lastEntry objectForKey:@"came_in_at"] andOutTime: [lastEntry objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
    
    [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:num withDate:string];
    }

    UIViewController *vc = self.window.rootViewController;
    if([vc isKindOfClass:[eyLogNavigationViewController class]])
    {
        eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
        NSLog(@"%@", nav.viewControllers);
        
        if(nav.viewControllers.count>1)
        {
            if([[nav.viewControllers lastObject]isKindOfClass:[ChilderenViewController class]])
            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"title" message:[userInfo objectForKey:@"registryData"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
                ChilderenViewController *view=(ChilderenViewController*)[nav.viewControllers lastObject];
                GridViewController*grid=   (GridViewController *)[view.containerViewController.childViewControllers objectAtIndex:0];
                NSMutableArray *gridArray=[NSMutableArray arrayWithArray:grid.childrenListForTableView];
                for(Child *child in gridArray)
                {
                if([child.childId integerValue]==[num integerValue])
                {
                    
                    if([newStr isEqualToString:[dateFormatterNew stringFromDate:[NSDate date]]])
                    {
                    child.inTime= [lastEntry objectForKey:@"came_in_at"];
                    child.outTime= [lastEntry objectForKey:@"left_at"];
                    child.currentDate = string;
                    grid.childrenListForTableView=[NSArray arrayWithArray:gridArray];
                    
                    NSIndexPath *indepath=[NSIndexPath indexPathForItem:[gridArray indexOfObject:child] inSection:0];
                    NSArray *indexpathArray=[NSArray arrayWithObject:indepath];
                    [grid.collectionViewController reloadItemsAtIndexPaths:indexpathArray];
                        
                        
                    }
                    
                }
                    
                                
                }
                
               
                
            }
        }
        
        NSLog(@"new");
        
    }
    
    if(application.applicationState==UIApplicationStateActive)
    {
     NSLog(@"Foreground");
    }
    else if(application.applicationState==UIApplicationStateInactive)
    {
     NSLog(@"come from Background");
    }
    }
        else if([[userInfo objectForKey:@"notificationType"]isEqualToString:@"New Registry"])
        {
            
            NSDictionary *dataDict = [userInfo objectForKey:@"registryData"];
            NSDictionary *registry = [dataDict objectForKey:@"registry"];
            
            NSNumber *num = [NSNumber numberWithInteger:[[dataDict objectForKey:@"child_id"] integerValue]];
        
            NSString *clientTimeStamp;
            
            if([registry objectForKey:@"clienttimestamp"]!=nil ||[registry objectForKey:@"clienttimestamp"]!=[NSNull null]|| ![[registry objectForKey:@"clienttimestamp"]isEqualToString:@"null"])
            {
                clientTimeStamp=[registry objectForKey:@"clienttimestamp"];
            }
            
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate *dateFromString = [[NSDate alloc] init];
                // voila!
                dateFromString = [dateFormatter dateFromString:[dataDict objectForKey:@"date"]];
                NSString *string = [dateFormatter2 stringFromDate:dateFromString];
                NSTimeInterval uniqueTabletOIID = [[NSDate date] timeIntervalSince1970];
                // NSTimeInterval is defined as double
                NSNumber *timeStampObj = [NSNumber numberWithDouble: uniqueTabletOIID];
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
                // display in HH:mm:ss local time zone
                [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
                [dateFormatter3 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
                NSString *currentTime = [dateFormatter stringFromDate:date];
                NSLog(@"Current Date Time:%@",currentTime);
                
                // Get the year, month, day from the date
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
                // Set the hour, minute, second to be zero
                components.hour = 0;
                components.minute = 0;
                components.second = 0;
                // Create the date
                NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
                
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                // display in HH:mm:ss local time zone
                [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
                [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
                NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
                NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
                
                // Now Calculating the time difference
                NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
                NSDate *newDate = [dateFormatter dateFromString:currentTime];
                NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
//                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                              num,@"childid",
//                                              string,@"date",
//                                              [registrystatus objectForKey:@"came_in_at"],@"intime",
//                                              @"00:00",@"outtime",
//                                              @"1", @"uploadedflag",
//                                              [NSNumber numberWithInteger:diff],@"timedifference",
//                                              timeStampObj,@"uniqueTableID",nil];
                //[Child updateRegistryArrayForChild:num :[NSMutableArray arrayWithArray:registry] forContext:[AppDelegate context]];
               // NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:registry,string, nil];
               // [Child updateDictionaryDataForInoutTime:dictionary :num forContext:[AppDelegate context]];
                //   NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];
                // create new entry for that date
//                NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
//                [dateFormatterNew setDateFormat:@"yyyy-mm-dd"];
//                
//                NSDate *neWdate = [dateFormatter dateFromString:[dataDict objectForKey:@"date"]];
//                NSString *newStr=[dateFormatterNew stringFromDate:neWdate];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
            NSString *dateStr = [dateformate stringFromDate:[NSDate date]];
            
                if([[dataDict objectForKey:@"date"] isEqualToString:dateStr])
                {
                    if([registry objectForKey:@"came_in_at"]&&[registry objectForKey:@"left_at"])
                    {
                        
                        if([[registry objectForKey:@"left_at"] isEqualToString:@"00:00"] ||[[registry objectForKey:@"left_at"] isEqualToString:@""])
                        {
                            [Child updateChild:num inTime:[registry objectForKey:@"came_in_at"] andOutTime:[registry objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
                            
                            NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                            NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                            
                            [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[dataDict objectForKey:@"date"] withDate:nil withChildId:[NSNumber numberWithInteger:[[dataDict objectForKey:@"child_id"] integerValue]] withInTime:[registry objectForKey:@"came_in_at"] withOutTime:[registry objectForKey:@"left_at"] withisInUploaded:YES withIsOutUploaded:NO withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[registry objectForKey:@"clienttimestamp"]];
                            
                        }
                        else
                        {
                            [Child updateChild:num inTime:[registry objectForKey:@"came_in_at"] andOutTime:[registry objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
                            
                            NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                            NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                            
                            [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[dataDict objectForKey:@"date"] withDate:nil withChildId:[NSNumber numberWithInteger:[[dataDict objectForKey:@"child_id"] integerValue]] withInTime:[registry objectForKey:@"came_in_at"] withOutTime:[registry objectForKey:@"left_at"] withisInUploaded:YES withIsOutUploaded:YES withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[registry objectForKey:@"clienttimestamp"]];
                        }
                        
                    }
                    else  if([registry objectForKey:@"came_in_at"])
                        
                    {
                        [Child updateChild:num inTime:[registry objectForKey:@"came_in_at"] andOutTime:@"" andRegistryStatus:nil  forContext:[AppDelegate context]];
                        
                        NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                        NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                        [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[dataDict objectForKey:@"date"] withDate:nil withChildId:[NSNumber numberWithInteger:[[dataDict objectForKey:@"child_id"] integerValue]] withInTime:[registry objectForKey:@"came_in_at"] withOutTime:@"00:00" withisInUploaded:YES withIsOutUploaded:NO withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[registry objectForKey:@"clienttimestamp"]];
                        
                    }
                    else  if([registry objectForKey:@"left_at"])
                    {
                        InOutSeparateManagementEntity *enity= [InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withChildId:num andClientTimestamp:[registry objectForKey:@"clienttimestamp"] andDateStr:[dataDict objectForKey:@"date"]];
                        
                        [InOutSeparateManagementEntity deleteRecordWithUniqueID:enity.uid];
                        NSArray *array=   [Child fetchChildInContext:[AppDelegate context] withChildId:num];
                        Child *child=[array firstObject];
                        
                        if(![child.inTime isEqualToString:@"00:00"]||![child.inTime isEqualToString:@""])
                        {
                        [Child updateChild:num inTime:child.inTime andOutTime:[registry objectForKey:@"left_at"] andRegistryStatus:[NSNumber numberWithInteger:[[registry objectForKey:@"registrystatus"] integerValue]]  forContext:[AppDelegate context]];
                        }
                      
                        
                    }
                    else if ([registry objectForKey:@"registrystatus"])
                    {
                        
                         [Child updateChild:num inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:[NSNumber numberWithInteger:[[registry objectForKey:@"registrystatus"] integerValue]]  forContext:[AppDelegate context]];
                    }
                    
                    
                   // [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:num withDate:string];
                
                
                
                UIViewController *vc = self.window.rootViewController;
                if([vc isKindOfClass:[eyLogNavigationViewController class]])
                {
                    eyLogNavigationViewController *nav=(eyLogNavigationViewController*)vc;
                    NSLog(@"%@", nav.viewControllers);
                    
                    if(nav.viewControllers.count>1)
                    {
                        if([[nav.viewControllers lastObject]isKindOfClass:[ChilderenViewController class]])
                        {
                            //  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"title" message:[userInfo objectForKey:@"registryData"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            //                [alert show];
                            ChilderenViewController *view=(ChilderenViewController*)[nav.viewControllers lastObject];
                            GridViewController*grid=   (GridViewController *)[view.containerViewController.childViewControllers objectAtIndex:0];
                            NSMutableArray *gridArray=[NSMutableArray arrayWithArray:grid.childrenListForTableView];
                            for(Child *child in gridArray)
                            {
                                if([child.childId integerValue]==[num integerValue])
                                {
                                    
                                    if([[dataDict objectForKey:@"date"] isEqualToString:dateStr])
                                    {
                                        if([registry objectForKey:@"came_in_at"])
                                            
                                        {
                                             child.inTime= [registry objectForKey:@"came_in_at"];
                                            child.registryStatus=nil;
                                        }
                                        else if([registry objectForKey:@"left_at"])
                                        {
                                            child.outTime= [registry objectForKey:@"left_at"];
                                            child.registryStatus=nil;
                                            
                                        }
                                        else if([registry objectForKey:@"registrystatus"])
                                        {
                                           
                                            child.registryStatus=[NSNumber numberWithInteger:[[registry objectForKey:@"registrystatus"] integerValue]];
                                            
                                            
                                        }

//
                                        child.currentDate = string;
                                        grid.childrenListForTableView=[NSArray arrayWithArray:gridArray];
                                        
                                        NSIndexPath *indepath=[NSIndexPath indexPathForItem:[gridArray indexOfObject:child] inSection:0];
                                        NSArray *indexpathArray=[NSArray arrayWithObject:indepath];
                                        [grid.collectionViewController reloadItemsAtIndexPaths:indexpathArray];
                                        
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                    }
                    
                    NSLog(@"new");
                    
                }
        }
        
                if(application.applicationState==UIApplicationStateActive)
                {
                    NSLog(@"Foreground");
                }
                else if(application.applicationState==UIApplicationStateInactive)
                {
                    NSLog(@"come from Background");
                }
            
        }
    }
    //NSLog(@"NOtification Recieved : %@",userInfo);
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - BackgroundUploadHandler

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    self.backgroundSessionCompletionHandler = completionHandler;

    //add notification
//    [self presentNotification];
}

-(void)presentNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Upload Complete!";
    localNotification.alertAction = @"Successfully Uploaded the Observation!";

    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    //increase the badge number of application plus 1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
-(void)sendRegistryData
{
    [[APICallManager sharedNetworkSingleton] insertRegistryData];
    
}
-(void)SendDataToWebIfNetwork
{
    
    [self performSelectorOnMainThread:@selector(sendRegistryData) withObject:nil waitUntilDone:YES];
    

    NSMutableArray *dummyArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedData"]];
    Reachability *reachability;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus != NotReachable)
    {
        if([APICallManager sharedNetworkSingleton].cachePractitioners!=nil)
        {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *home=[storyboard instantiateViewControllerWithIdentifier:@"next_vc"];
        [home loadNotificationsHistory:[APICallManager sharedNetworkSingleton].cachePractitioners];
        }
    }
    
    if(remoteHostStatus !=NotReachable)
    {
        
        if(dummyArray.count>0)
        {
            for (int i=0; i<dummyArray.count; i++) {
                NSDictionary *dict=[dummyArray objectAtIndex:i];
                NSURL *myObjectURL = [NSURL URLWithString:[dict objectForKey:@"child"]];
                NSManagedObjectID *myObjectID = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:myObjectURL];
                
                NSError *error = nil;
                ChildInOutTime *myObject = [[AppDelegate context] existingObjectWithID:myObjectID error:&error];
                [[APICallManager sharedNetworkSingleton] uploadRandomInOutTimeRecord:[dict objectForKey:@"array"] andChildInOut:myObject andViewController:nil];
                NSMutableArray *array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedData"]];
               
                [array removeObject:dict];
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                [standardUserDefaults setObject:array forKey:@"storedData"];
            }
            
        }
    }
    NSMutableArray *Array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedDataForDailyDiary"]];
 
    if(remoteHostStatus !=NotReachable)
    {
        if(Array.count>0)
        {
            for (int i=0; i<Array.count; i++) {
                
                [self postDailyDiaryObservations:[Array objectAtIndex:i]];
                
            }
        }
        
    }
    
}
-(void)postDailyDiaryObservations : (NSDictionary *) inputDictionary
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    NSLog(@"Current Date Time:%@",currentTime);
    
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    // Set the hour, minute, second to be zero
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // Create the date
    NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
    NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
    
    
    // Now Calculating the time difference
    NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
    NSDate *newDate = [dateFormatter dateFromString:currentTime];
    NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
    // NSInteger timeDiff = diff;
    // NSLog(@"Time Difference %ld", (long)x);
    
    dateFormatter = nil;
    dateFormatter1=nil;
    
    NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
    NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        //Internet is Available
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary",serverURL];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to post data on the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
                if ([self.eyl_AppDaya.savePickerDate isEqualToString:[self.eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [self.eyl_AppDaya.array_Registry lastObject];
                    [Child updateChild:[NSNumber numberWithInt:[self.eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt andRegistryStatus:nil forContext:[AppDelegate context]];
                    
                    obk=nil;
                }
                
                
                return;
            }
            
          
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               // [self.window makeToast:@"Daily Diary saved Successfully" duration:1.0 position:CSToastPositionCenter];
                self.strCurrentDate=[inputDictionary objectForKey:@"date_time"];
                
                //[containerView clearText];
                // Here Delete the Records from local Database because they are already updated to the server
                self.eyl_AppDaya = [EYL_AppData sharedEYL_AppData];
                                [self deleteRecordFromLocalDB];
                
                if ([self.strCurrentDate isEqualToString:[self.eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [self.eyl_AppDaya.array_Registry lastObject];
                    NSDictionary *dic= [[[inputDictionary objectForKey:@"data"]objectForKey:@"registry"] lastObject];
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[self.eyl_AppDaya.selectedChild intValue]],@"childid",
                                                  self.strCurrentDate,@"date",
                                                  [dic objectForKey:@"came_in_at"],@"intime",
                                                  [dic objectForKey:@"left_at"],@"outtime",
                                                  @"1", @"uploadedflag",
                                                  [NSNumber numberWithInteger:diff],@"timedifference",
                                                  [NSNumber numberWithInt:[uniqueTabletOIID intValue]],@"uniqueTableID",nil];
                    
                    
                    [Child updateChild:[NSNumber numberWithInt:[self.eyl_AppDaya.selectedChild intValue]] inTime: [dic objectForKey:@"came_in_at"] andOutTime:[dic objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
                    
                    [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:[NSNumber numberWithInt:[self.eyl_AppDaya.selectedChild intValue]] withDate:self.strCurrentDate];
                    obk=nil;
                }
                
                NSMutableArray *array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedDataForDailyDiary"]];
                
                [array removeObject:inputDictionary];
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                [standardUserDefaults setObject:array forKey:@"storedDataForDailyDiary"];

                
            });
            
        }];
        [postDataTask resume];
        
    }
    else
    {
        // Internet Not Avaialable
        [[EYL_AppData sharedEYL_AppData] showAlertWithOneButton:@"OOPS, Internet not available"];
    }
}

-(void) deleteRecordFromLocalDB
{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];
    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"childID == %@", self.eyl_AppDaya.selectedChild];
    NSPredicate *specificDate = [NSPredicate predicateWithFormat:@"currentDate == %@",self.strCurrentDate];
    
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificChildID,specificDate]]];
    
    NSError *fetchError=nil;
    NSArray *results = [[AppDelegate context] executeFetchRequest:request error:&fetchError];
    
    //error handling goes here
    for (NSManagedObject *car in results) {
        [[AppDelegate context] deleteObject:car];
    }
    NSError *saveError = nil;
    [[AppDelegate context] save:&saveError];
    //more error handling here
}
@end
