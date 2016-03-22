//
//  EYLSummativeReportsViewController.m
//  eyLog
//
//  Created by Shivank Agarwal on 22/02/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLSummativeReportsViewController.h"
#import "APICallManager.h"
#import "EYLSummativReportsList.h"
#import "EYLSummativeReportsCellTableViewCell.h"
#import "WebViewViewController.h"
#import "SummativeInfoViewer.h"
#import "Utils.h"
#import "WYPopoverController.h"
#import "GroupsViewController.h"
NSString *const kEYLSummativeReportsSegueID = @"kEYLSummativeReportsSegueID";

@interface EYLSummativeReportsViewController ()<WYPopoverControllerDelegate,GroupSelectionDelegate>
{
    SummativeInfoViewer *containerView;
    BOOL isRefreshing;
    UIRefreshControl *refreshControl;
    BOOL isTypePopOverRect;
    
}
@property (strong, nonatomic) IBOutlet UIView *HeaderView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong,nonatomic) NSMutableArray *tempTableData;
@property (strong, nonatomic) IBOutlet UILabel *childName;
@property (strong, nonatomic) IBOutlet UILabel *nameOfReports;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *dateOfReports;
@property (strong, nonatomic) GroupsViewController *popoverViewController;
@property (strong, nonatomic) WYPopoverController *popover;
@end

@implementation EYLSummativeReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Summative Reports";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EYLSummativeReportsCellTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kEYLSummativeReportsCellTableViewCellReuseId];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    isRefreshing = NO;
    isTypePopOverRect=NO;
    [self refreshView];
    
    [self.HeaderView addSubview:self.childName];
    [self.HeaderView addSubview:self.nameOfReports];
    [self.HeaderView addSubview:self.dateOfReports];
    [self.HeaderView addSubview:self.status];
    
    
    //[self loadSummativeReportsData];
    [self performSelectorOnMainThread:@selector(loadSummativeReportsData) withObject:nil waitUntilDone:NO];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    // Do any additional setup after loading the view.
}

-(void)refreshView
{
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        self.childName.frame = CGRectMake(5, 0, 180, 60);
        self.nameOfReports.frame = CGRectMake(210, 0, 270, 60);
        self.dateOfReports.frame =CGRectMake(450, 0, 200, 60);
        self.status.frame =CGRectMake(930, 0, 200, 60);
    }else{
        self.childName.frame = CGRectMake(5, 0, 180, 60);
        self.nameOfReports.frame = CGRectMake(195, 0, 200, 60);
        self.dateOfReports.frame =CGRectMake(350, 0, 180, 60);
        self.status.frame =CGRectMake(680, 0, 100, 60);
        
    }
}

-(void)refreshTable
{
    isRefreshing = YES;
    [self loadSummativeReportsData];
}

-(void)addChildView{
    
    containerView=[[[NSBundle mainBundle]loadNibNamed:@"SummativeInfoViewer" owner:self options:nil] objectAtIndex:0];
    containerView.hidden = YES;
    
    
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
    
    if([Utils getChildImage]==nil)
    {
        containerView.childImage.image=[UIImage imageNamed:@"eylog_Logo"];
        
        //[containerView.childImage setBackgroundColor:[UIColor blackColor]];
        NSLog(@"%@",containerView.childImage);
        
        //im,g
    }
    else
    {
        containerView.childImage.image=[Utils getChildImage];
    }
    if([APICallManager sharedNetworkSingleton].cacheChildren.count==1)
    {
        containerView.childImage.hidden=NO;

    }
    else
    {
    containerView.childImage.hidden=YES;
    }
     containerView.childName.text=[Utils getChildName];
    containerView.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];
    
    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
    {
        [self.navigationController.navigationBar addSubview:containerView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self addChildView];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;
}
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadSummativeReportsData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    [[APICallManager sharedNetworkSingleton] getSummativeReportsListWithSuccessBlock:^(NSDictionary *dict) {
        [self populateArrayWithData:dict[@"data"]];
        
    } andFailureBlock:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
}
-(void)populateArrayWithData:(NSArray *)array{
    _tableData = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict  in array) {
        EYLSummativReportsList *list = [[EYLSummativReportsList alloc]init];
        list.reportId = dict[@"report_id"];
        list.reportName = dict[@"report_name"];
        list.reportDate = dict[@"report_date"];
        list.mode = dict[@"mode"];
        list.childId = dict[@"child_id"];
        list.childName = dict[@"child_name"];
        [_tableData addObject:list];
    }
    //_tempTableData=_tableData;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mode like %@",@"draft"];
    self.tempTableData=[self.tableData filteredArrayUsingPredicate:predicate];
    [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    if(isRefreshing)
    {
        isRefreshing = NO;
        [refreshControl endRefreshing];
    }
}

-(void)ReloadData
{
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempTableData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EYLSummativeReportsCellTableViewCell *cell = (EYLSummativeReportsCellTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kEYLSummativeReportsCellTableViewCellReuseId forIndexPath:indexPath];
    EYLSummativReportsList *list = [self.tempTableData objectAtIndex:indexPath.row];
    cell.childName.text = list.childName;
    cell.nameOfReports.text = list.reportName;
    cell.dateOfReports.text = list.reportDate;
    cell.status.text = list.mode;
    
    if([cell.status.text isEqualToString:@"draft"])
        cell.status.text = [NSString stringWithFormat:@"Draft"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![APICallManager sharedNetworkSingleton].isNetworkReachable)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please check network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    EYLSummativReportsList *list = [self.tempTableData objectAtIndex:indexPath.row];
    
//    NSString *strPassword= [APICallManager sharedNetworkSingleton].apiPassword;
//    strPassword=[strPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * practionerId = [NSString stringWithFormat:@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId];;//@"300";//[APICallManager sharedNetworkSingleton].cacheChild.practitionerId
    
    NSString *string =[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    
    CFStringRef practionerPin = CFURLCreateStringByAddingPercentEscapes (
                                                                     
                                                                     NULL,
                                                                     
                                                                     (CFStringRef)string,
                                                                     
                                                                     NULL,
                                                                     
                                                                     CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                     
                                                                     kCFStringEncodingUTF8
                                                                     
                                                                     );
    
   
    NSString * passStr =[APICallManager sharedNetworkSingleton].apiPassword;
    
    CFStringRef passwordString = CFURLCreateStringByAddingPercentEscapes (

                                                                          NULL,
                                                                          (CFStringRef)passStr,

                                                                          NULL,
                                                                          
                                                                          CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"),
                                                                          
                                                                          kCFStringEncodingUTF8
                                                                          
                                                                          );

    
    WebViewViewController *webViewController = [[WebViewViewController alloc] init];
    webViewController.strURL = [NSString stringWithFormat:@"%@api/webview/summative-report-form.php?api_key=%@&api_password=%@&child_id=%@&report_id=%@&practitioner_id=%@&practitioner_pin=%@",
                                [APICallManager sharedNetworkSingleton].serverURL,[APICallManager sharedNetworkSingleton].apiKey,passwordString,list.childId,list.reportId, practionerId,practionerPin];
    
    // Edited By : Ankit Khetrapal
    // Reason : So that if no child is selected the child is selected on the basis of id form the data and then work is done accordingly
    if([APICallManager sharedNetworkSingleton].cacheChild == nil)
    {
        for (Child *child in [APICallManager sharedNetworkSingleton].childArray)
        {
            if([[child.childId stringValue] isEqualToString:list.childId])
            {
                [APICallManager sharedNetworkSingleton].cacheChild = child;
                webViewController.isSingleEntity = YES;
                break;
            }
        }
    }
    else
    {
        webViewController.isSingleEntity = NO;
    }
    
    webViewController.loadedFromSummativeReport = YES;
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
    webViewController.titleString =@"Summary Report";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[self updateViewConstraints];
    [self refreshView];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self refreshView];
    [self.tableView reloadData];
   
}
//-(void)updateViewConstraints{
//    [super updateViewConstraints];
//    [self.tableView reloadData];
//}
- (IBAction)actionStatus:(id)sender {

    self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
    self.popoverViewController.delegate = self;
    self.popoverViewController.cellType=KCellTypePractitioner;
    
    _popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];
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
    self.popover.popoverContentSize = CGSizeMake(150, 180);
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.arrowBase = 0;
    
    self.popoverViewController.dataArray=@[@"All",@"Draft",@"Pending Review",@"Completed"];
    [self typePopOverRect];

}
-(void)typePopOverRect{
    isTypePopOverRect = YES;
   
    CGRect rect;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        rect = CGRectMake(self.view.frame.size.width,self.HeaderView.frame.size.height+self.HeaderView.frame.origin.y+90, 0, 0);
    }
    else{
        rect = CGRectMake(self.view.frame.size.width,self.HeaderView.frame.size.height+self.HeaderView.frame.origin.y+90, 0, 0);
    }
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
   // [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFade];
}
-(void)reloadTableData{
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [containerView removeFromSuperview];
}

#pragma mark - GroupSelectionDelegate
- (void)groupDidSelected:(NSString *)group withCellType:(NSString *)cellType
{
    isTypePopOverRect = NO;
    NSLog(@"Selected %@",group);
    if([cellType isEqualToString:KCellTypePractitioner])
    {
        [self.popover dismissPopoverAnimated:YES];
        if([group caseInsensitiveCompare:@"All"]==NSOrderedSame)
        {
           
            //[self getDraftListWithType:@"draft,pending_review"];
            self.tempTableData=self.tableData;
        }
        else if([group caseInsensitiveCompare:@"Draft"]==NSOrderedSame)
        {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mode like %@",@"draft"];
            self.tempTableData=[self.tableData filteredArrayUsingPredicate:predicate];
            [self reloadTableData];
            
        }
        else if ([group caseInsensitiveCompare:@"Pending Review"]==NSOrderedSame)
        {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mode BEGINSWITH %@",@"Pending"];
            self.tempTableData=[self.tableData filteredArrayUsingPredicate:predicate];
            [self reloadTableData];
        }
        else if ([group caseInsensitiveCompare:@"Completed"]==NSOrderedSame)
        {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mode like %@",@"Completed"];
            self.tempTableData=[self.tableData filteredArrayUsingPredicate:predicate];
            [self reloadTableData];
        }
        
    }
//    else if([cellType isEqualToString:KCellTypeGroup])
//    {
//        [groupSearchView.groupPopup.groupsButton setTitle:group forState:UIControlStateNormal];
//        if([group caseInsensitiveCompare:@"ALL Groups"]==NSOrderedSame)
//        {
//            observationArray=[originalArray copy];
//        }
//        else
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            
//            for (NewObservation *observationItr in observationArray) {
//                NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:observationItr.childId];
//                
//                if([((Child *)[childArray objectAtIndex:0]).groupName isEqualToString:group])
//                {
//                    if (observationItr) {
//                        [tempArray addObject:observationItr];
//                    }
//                }
//            }
//            observationArray = tempArray;
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.popover dismissPopoverAnimated:YES];
//            [self.tableView reloadData];
//        });
//    }
//    else if([cellType isEqualToString:KCellTypeObservationBy])
//    {
//        //[groupSearchView.groupPopup.groupsButton setTitle:group forState:UIControlStateNormal];
//        if([group caseInsensitiveCompare:@"ALL"]==NSOrderedSame)
//        {
//            observationArray=[originalArray copy];
//        }
//        else
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            
//            for (OBData *observationItr in originalArray) {
//                if([group caseInsensitiveCompare:observationItr.observationBy]==NSOrderedSame)
//                {
//                    if (observationItr) {
//                        [tempArray addObject:observationItr];
//                    }
//                    
//                }
//            }
//            observationArray = tempArray;
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popover dismissPopoverAnimated:YES];
            [self.tableView reloadData];
        });
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController{
    isTypePopOverRect = NO;
    }
- (void) orientationChanged:(NSNotification *)note
{
    
    UIDevice * device = note.object;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"check width %f and checking Height %f",screenWidth,screenHeight);
    [self.popover dismissPopoverAnimated:YES];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            if (isTypePopOverRect) {
                [self actionStatus:nil];
            }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            if (isTypePopOverRect) {
              //  [self.popover dismissPopoverAnimated:YES];
                [self actionStatus:nil];
            }
            
            
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (isTypePopOverRect) {
                //[self.popover dismissPopoverAnimated:YES];
                [self actionStatus:nil];
            }

            break;
        case UIDeviceOrientationLandscapeRight:
            if (isTypePopOverRect) {
               // [self.popover dismissPopoverAnimated:YES];
                [self actionStatus:nil];
            }
  
            break;
        default:
            break;
    };
   
    
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
