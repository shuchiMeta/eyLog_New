//
//  ContainerViewController.m
//  EmbeddedSwapping
//
//  Created by Michael Luton on 11/13/12.
//  Copyright (c) 2012 Sandmoose Software. All rights reserved.
//  Heavily inspired by http://orderoo.wordpress.com/2012/02/23/container-view-controllers-in-the-storyboard/
//

#import "ContainerViewController.h"


#define SegueIdentifierFirst @"embedFirst"
#define SegueIdentifierSecond @"embedSecond"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    
    if ([segue.identifier isEqualToString:SegueIdentifierFirst])
    {
        
        self.listViewController = segue.destinationViewController;
    }
    if([segue.identifier isEqualToString:SegueIdentifierSecond])
    {
        self.gridViewController = segue.destinationViewController;
        self.gridViewController.parentVC = (ChilderenViewController *)self.parentViewController;
    }
    
    
    // If we're going to the first view controller.
    if([segue.identifier isEqualToString:SegueIdentifierFirst])
    {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0)
        {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.listViewController];
        }
        else
        {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond])
    {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.gridViewController];
    }
}


#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

    
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished)
    {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
        
    }];
}




-(void)showListViewController
{
    ((GridViewController *)[self.childViewControllers objectAtIndex:0]).tableView.hidden=NO;
    [((GridViewController *)[self.childViewControllers objectAtIndex:0]).tableView reloadData];
}

-(void)showGridViewController
{
    ((GridViewController *)[self.childViewControllers objectAtIndex:0]).tableView.hidden=YES;
    [((GridViewController *)[self.childViewControllers objectAtIndex:0]).collectionViewController reloadData];
}



- (void)swapViewControllers
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self.transitionInProgress) {
        return;
    }

    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) ? SegueIdentifierSecond : SegueIdentifierFirst;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.listViewController) {
   //  if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) {
        [self swapFromViewController:self.gridViewController toViewController:self.listViewController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) && self.gridViewController) {
    //if ([self.currentSegueIdentifier isEqualToString:SegueIdentifierSecond]) {
        [self swapFromViewController:self.listViewController toViewController:self.gridViewController];
        return;
    }

    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end
