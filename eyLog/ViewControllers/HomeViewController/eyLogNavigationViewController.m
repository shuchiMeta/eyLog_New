//
//  eyLogNavigationViewController.m
//  eyLog
//
//  Created by MDS_Abhijit on 12/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "eyLogNavigationViewController.h"
#import "Utils.h"
#import "APICallManager.h"

@interface eyLogNavigationViewController ()

@end

@implementation eyLogNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id rootController;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSLog(@"Storyboard : %@", self.storyboard);
    
    if ([filemgr fileExistsAtPath: [Utils getInstallationData]])
    {
        NSMutableDictionary *installationData;
        
        installationData = [NSKeyedUnarchiver unarchiveObjectWithFile: [Utils getInstallationData]];
        
        [APICallManager sharedNetworkSingleton].apiKey = [installationData objectForKey:@"apiKey"];
        [APICallManager sharedNetworkSingleton].apiPassword = [installationData objectForKey:@"apiPassword"];
        [APICallManager sharedNetworkSingleton].serverURL = [installationData objectForKey:@"serverURL"];
        [APICallManager sharedNetworkSingleton].nurseryId = [installationData objectForKey:@"nurseryId"];
               
//        [self performSegueWithIdentifier: @"HomeViewControllerSegueID" sender: self];
        
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"next_vc"];
    }
    else {
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstallationViewControllerId"];
    }
    self.viewControllers = [NSArray arrayWithObjects:rootController, nil];
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
