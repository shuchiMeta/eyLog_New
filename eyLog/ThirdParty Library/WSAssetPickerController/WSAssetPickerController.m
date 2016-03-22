//
//  WSAssetPickerController.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSAssetPickerController.h"
#import "WSAssetPickerState.h"
#import "WSAlbumTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define STATE_KEY @"state"
#define SELECTED_COUNT_KEY @"selectedCount"

@interface WSAssetPickerController ()
@property (nonatomic, strong) WSAssetPickerState *assetPickerState;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;
@end


@implementation WSAssetPickerController

@dynamic selectedAssets;

#pragma mark - Initialization

- (id)initWithAssetsLibrary:(ALAssetsLibrary *)assetsLibrary
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.assetPickerState.assetsLibrary = assetsLibrary;
    }
    
    return self;
}

- (id)initWithDelegate:(id <WSAssetPickerControllerDelegate>)delegate;
{
    self = [[[self class] alloc] initWithAssetsLibrary:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)commonInit
{
    WSAlbumTableViewController *albumTableViewController = [[WSAlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self setViewControllers:@[albumTableViewController] animated:NO];
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    albumTableViewController.assetPickerState = self.assetPickerState;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary
{
    NSParameterAssert(assetsLibrary);
    self.assetPickerState.assetsLibrary = assetsLibrary;
}

#pragma mark - Accessors -

- (WSAssetPickerState *)assetPickerState
{
    if (!_assetPickerState) {
        _assetPickerState = [[WSAssetPickerState alloc] init];
    }
    return _assetPickerState;
}

- (void)setSelectionLimit:(NSInteger)selectionLimit
{
    if (_selectionLimit != selectionLimit) {
        _selectionLimit = selectionLimit;
        self.assetPickerState.selectionLimit = _selectionLimit;
    }
}

- (NSArray *)selectedAssets
{
    return self.assetPickerState.selectedAssets;
}

#pragma mark - Overrides -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSAssert(self.assetPickerState.assetsLibrary, @"An assets library must be provided.");
    NSAssert(self.delegate, @"A delegate must be provided");
    
    self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // Start observing state changes and selectedCount changes.
    [_assetPickerState addObserver:self forKeyPath:STATE_KEY options:NSKeyValueObservingOptionNew context:NULL];
    [_assetPickerState addObserver:self forKeyPath:SELECTED_COUNT_KEY options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:YES];
    
    // Stop observing state changes and selectedCount changes.
    [_assetPickerState removeObserver:self forKeyPath:STATE_KEY];
    [_assetPickerState removeObserver:self forKeyPath:SELECTED_COUNT_KEY];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if (![object isEqual:self.assetPickerState]) return;
    
    if ([STATE_KEY isEqualToString:keyPath]) {     
        
        // Cast the delegate to the assetPickerDelegate.
        id <WSAssetPickerControllerDelegate> delegate = (id <WSAssetPickerControllerDelegate>)self.delegate;
        
        if (WSAssetPickerStatePickingCancelled == self.assetPickerState.state) {
            if ([delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)]) {
                [delegate assetPickerControllerDidCancel:self];
            }
        } else if (WSAssetPickerStatePickingDone == self.assetPickerState.state) {
            if ([delegate respondsToSelector:@selector(assetPickerController:didFinishPickingMediaWithAssets:)]) {
                [delegate assetPickerController:self didFinishPickingMediaWithAssets:self.assetPickerState.selectedAssets];
            }
        } else if (WSAssetPickerStateSelectionLimitReached == self.assetPickerState.state) {
            if ([delegate respondsToSelector:@selector(assetPickerControllerDidLimitSelection:)]) {
                [delegate assetPickerControllerDidLimitSelection:self];
            }
        }
    } else if ([SELECTED_COUNT_KEY isEqualToString:keyPath]) {
        
        self.selectedCount = self.assetPickerState.selectedCount;
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end