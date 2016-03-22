//
//  AppDelegate.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 23/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildInOutTime.h"
#import "EYL_AppData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLSessionDelegate>
{
id lastViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *childContextModel;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (copy) void (^backgroundSessionCompletionHandler)();
@property(nonatomic,readwrite)NSInteger ObservationFlag;
@property(nonatomic,readwrite)NSInteger HomesearchFlag;
@property(nonatomic,readwrite)NSInteger searchClicked;
@property(nonatomic,readwrite) NSInteger ButtonHideFlag;
@property(nonatomic,strong) NSDate *interval;
@property(nonatomic,strong) NSDate *draftInterval;
@property(nonatomic,strong)ChildInOutTime *childInOutEntity;
@property(nonatomic,strong) EYL_AppData   *eyl_AppDaya ;
@property(nonatomic,strong)NSString *strCurrentDate;
@property(nonatomic,assign)BOOL becameActiveAfterNotication;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (NSManagedObjectContext *) context;
+ (NSManagedObjectContext *) childContext;
+ (void) resetChildContext;

@end
