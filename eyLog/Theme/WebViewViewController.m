//
//  WebViewViewController.m
//  eyLog
//
//  Created by MDS_Abhijit on 07/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "WebViewViewController.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "ChildView.h"
#import "Utils.h"

@interface WebViewViewController ()
{
    ChildView *containerView;
    NSString *JSHandler;
}
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.navigationController.toolbarHidden=YES;
    
    [self addChildView];
    
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:self.strURL];
  //  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    [self.webview loadRequest:theRequest];
//    [self.webview loadHTMLString:self.strURL baseURL:nil];
    self.webview.scalesPageToFit = YES;
    
    JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ajaxHandler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];

}
-(void)addChildView{
    
    // Hack to fix the cache child issue
    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 0 && !self.loadedFromSummativeReport)
    {
        [APICallManager sharedNetworkSingleton].cacheChild = nil;
    }
    
    containerView=[[[NSBundle mainBundle]loadNibNamed:@"ChildView" owner:self options:nil] objectAtIndex:0];
    containerView.hidden = YES;
    containerView.childDropDown.hidden = YES;
    containerView.dateLabel.hidden = YES;
    if([APICallManager sharedNetworkSingleton].cacheChildren.count <= 1)
    {
        containerView.childNotificationLabel.text = nil;
        [containerView.childNotificationLabel setHidden:YES];
    }
    else
    {
        [containerView.childNotificationLabel setHidden:NO];
        containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count];
    }
    if([APICallManager sharedNetworkSingleton].cacheChildren.count==1)
    {
        containerView.childImage.hidden=NO;
        
    }
    else
    {
        containerView.childImage.hidden=YES;
    }
    if(self.loadedFromSummativeReport)
    {
    containerView.childImage.hidden=NO;
    }
    
    containerView.childImage.image=[Utils getChildImage];
    containerView.childName.text=[Utils getChildName];
    containerView.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];
    
    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
    {
        [self.navigationController.navigationBar addSubview:containerView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)    {
        NSLog(@"landscape");
        [UIView animateWithDuration:0.0 animations:^{
            
            containerView.frame=CGRectMake(self.view.frame.size.width-955, 0, 950, 40);
            containerView.hidden=NO;
        }];
    }
    else
        
    {
        NSLog(@"portrait");
        [UIView animateWithDuration:0.0 animations:^{
        containerView.frame =CGRectMake(self.view.frame.size.width-720, 0, 715, 40);
        containerView.hidden=NO;
        }];
    }
    containerView.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;
}
-(void)dealloc{
    
    [_webview stopLoading];
    [_webview setDelegate:nil];
    // so that it retains child id in case the child was allocated from list data from the server
    if(self.isSingleEntity)
        [APICallManager sharedNetworkSingleton].cacheChild = nil;
    [containerView removeFromSuperview];
   
}

-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// Edited by Ankit Khetrapal : Fix for app crashing on clicking dropdown on web view
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_USEC), dispatch_get_main_queue(),
                   ^{
                       [super presentViewController:viewControllerToPresent animated:flag completion:completion];
                   });
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   // [_webview stringByEvaluatingJavaScriptFromString:JSHandler];

    if ([[[request URL] scheme] isEqual:@"myAjaxHandler"]) {
        NSString *requestedURLString = [[[request URL] absoluteString] substringFromIndex:[JSHandler length] + 3];
        
        NSLog(@"ajax request: %@", requestedURLString);
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText= [NSString stringWithFormat:@"Loading %@...",self.titleString];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
