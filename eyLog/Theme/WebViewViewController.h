//
//  WebViewViewController.h
//  eyLog
//
//  Created by MDS_Abhijit on 07/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *strURL;
@property (assign,nonatomic) BOOL isSingleEntity;
@property (assign,nonatomic) BOOL loadedFromSummativeReport;
@property (strong, nonatomic) NSString *titleString;

- (void)addNavbarItemsToViewCaontroller:(UIViewController *)controller;

@end
