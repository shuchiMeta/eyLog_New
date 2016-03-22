//
//  ContainerViewController.h
//  EmbeddedSwapping
//
//  Created by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.
//
#import "ListViewController.h"
#import "GridViewController.h"
@class ChilderenViewController;
@interface ContainerViewController : UIViewController
@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) ListViewController *listViewController;
@property (strong, nonatomic) GridViewController *gridViewController;
@property (assign, nonatomic) BOOL transitionInProgress;
-(void)swapViewControllers;
-(void)showListViewController;
-(void)showGridViewController;
@end
