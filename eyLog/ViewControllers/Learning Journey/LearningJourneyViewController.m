//
//  LearningJourneyViewController.m
//  eyLog
//
//  Created by Shuchi on 31/12/15.
//  Copyright © 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LearningJourneyViewController.h"
#import "LearningJourneyTableViewCell.h"
#import "LJHeaderView.h"
#import "APICallManager.h"
#import "LearningJourneyModel.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "Practitioners.h"
#import "AppDelegate.h"
#import "Statement.h"
#import "Age.h"
#import "Aspect.h"
#import "Framework.h"
#import "Eyfs.h"
#import "Utils.h"
#import "MontessoryViewController.h"
#import "MontessoriFramework.h"
#import "OBCfe.h"
#import "CfeFramework.h"
#import "AppDelegate.h"
#import "Cfe.h"
#import "CfeLevelOne.h"
#import "CfeLevelTwo.h"
#import "CfeLevelThree.h"
#import "CfeLevelFour.h"
#import "CfeAssesmentDataBase.h"
#import "Montessori.h"
#import "MontessoriFramework.h"
#import "LevelTwo.h"
#import "LevelThree.h"
#import "LevelFour.h"
#import "MontessoryLevel2.h"
#import "MontessoryLevel4.h"
#import "MontesoryLevel3.h"
#import "MontesdsoryLevel.h"
#import "CFEAssessmentViewController.h"
#import "CfeFramework.h"
#import "ImageFile.h"
#import "VideoFile.h"
#import "AudioFile.h"
#import "Theme.h"
#import "ChildView.h"
#import "WYPopoverController.h"
#import "ImageViewerViewController.h"
#import "LeuvenScale.h"
#import "ComentsViewcontroller.h"
#import "OBEcat.h"
#import "OBCoel.h"
#import "Ecat.h"
#import "EcatStatement.h"
#import "EcatFramework.h"
#import "EcatArea.h"
#import "EcatAspect.h"
#import "EcatAreaClass.h"
#import "EcatAspectClass.h"
#import "EcatStatementClass.h"
#import "Framework.h"
#import "Aspect.h"
#import "Statement.h"
#import "COBaseClass.h"
#import "OBCoel.h"
#import "UIView+Toast.h"



@interface LearningJourneyViewController ()<LearningJourneyDelegate,WYPopoverControllerDelegate,UIPopoverControllerDelegate,CommentsDelegate>
{
    ComentsViewController *coments;
    NSMutableArray *dataArray;
    NSCache *memoryCache;
    LJHeaderView *lJView;
    NSInteger pageNumber;
    MBProgressHUD *hud;
    NSString  *Observation;
    NSString *frameowrk;
    Theme *theme;
    ChildView *containerView;
    NSInteger selectedInteger;
    UIRefreshControl *refresControl;
    BOOL isFooterView;
    NSMutableArray *obserArray;
    NSMutableArray *framworkArray;
    LearningJourneyModel *ljModel;
    BOOL isKeyboardVisible;
    
   
    
}

@end

@implementation LearningJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for( UIView *view in self.navigationController.navigationBar.subviews)
   {
       
       if([view isKindOfClass:[ChildView class]])
       {
       
       [view removeFromSuperview];
       }
       
       
   }
    
    theme = [Theme getTheme];
    [theme addToolbarItemsToViewCaontroller:self];
 
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;
    [framworkArray addObject:@""];
    [obserArray addObject:@""];
    
    dataArray=[NSMutableArray new];
    pageNumber=1;
    [self setEdgesForExtendedLayout];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LearningJourneyTableViewCell" bundle:nil] forCellReuseIdentifier:LearningJourneyTableViewCellReuseID];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    if(_isComeFromNotification)
    {
        [self loadData];
        
        
    
    }
    else
    {
    [self loadLearningJourney];
        refresControl = [[UIRefreshControl alloc] init];
        [refresControl addTarget:self action:@selector(tableViewDidRefreshed:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refresControl];
    }
    
   
    //_tableView.estimatedRowHeight = 376;
        // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    if([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%d/list",serverURL,[self.observationID integerValue]];
    
    NSLog(@"DraftList URL : %@", urlString);
    
    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];
    //    [mapData setObject:[[APICallManager sharedNetworkSingleton] cacheChild].childId forKey:@"child_id"];
    //mapData setObject:@""draft,pending_review,processing"" forKey:<#(nonnull id<NSCopying>)#>
    
    
    //        "child_id": "",
    //        "filter_type": "practitioner",
    //        "per_page": "20",
    //
    //        "type": "draft,pending_review,processing"
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                
                
            });
            
            return;
        }
        [self backgroundLoadData:data];
        
    }];
    
    [postDataTask resume];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"No network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}
-(void)backButtonClick
{

[self.navigationController popViewControllerAnimated:YES];

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
-(void)tableViewDidRefreshed:(UIRefreshControl *)refreshControl
{
    if ([Utils checkNetwork]) {
        pageNumber =0;
        [self loadLearningJourney];
        
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [refresControl endRefreshing];
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    containerView=[[[NSBundle mainBundle]loadNibNamed:@"ChildView" owner:self options:nil] objectAtIndex:0];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        
    {
        // appDelegate.ObservationFlag=1;
        NSLog(@"landscape");
        [UIView animateWithDuration:0.0 animations:^{
            
            containerView.frame=CGRectMake(self.view.frame.size.width-955, 0, 950, 40);
            containerView.hidden=NO;
        }];
    }
    else
    {
        NSLog(@"portrait");
        //appDelegate.ObservationFlag=1;
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-720, 0, 715, 40);
            
            containerView.hidden=NO;
        }];
    }
      containerView.firstLabel.text=@"Test";
   // [containerView.dateLabel setHidden:NO];
    //[containerView.dateLabel setText:@"Learning Journey"];
    [containerView.dateButton setHidden:YES];
  
    [containerView .dateLabel setHidden:YES];
    containerView.childName.hidden = NO;
    containerView.childGroup.hidden = NO;
    containerView.childNotificationLabel.hidden = YES;
    containerView.childImage.hidden = YES;
    containerView.childImageButton.hidden = YES;
    containerView.childDropDown.hidden = YES;
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if(!_isComeFromNotification)
    {
        containerView.childImage.hidden = NO;
        containerView.childImageButton.hidden = NO;
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(containerView.dateLabel.frame.origin.x+20, containerView.dateLabel.frame.origin.y, containerView.dateLabel.frame.size.width, containerView.dateLabel.frame.size.height)];
    
    navLabel.text = @"Learning Journey";
    navLabel.tag=1;
    navLabel.textColor = [UIColor whiteColor];
    [navLabel setBackgroundColor:[UIColor clearColor]];

    [containerView addSubview:navLabel];
    }
    
    
//  [self.navigationController.navigationBar addSubview:containerView];
//    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
//    {
//        [self.navigationController.navigationBar addSubview:containerView];
//    }
    [theme resetTargetViewController:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
 [memoryCache removeAllObjects];
}

-(void)selectionOnFrameWorkCollection:(NSString *)frameworkSelection AndSelectionOnObservation:(NSString *)ObservationSelection andIndexpath:(NSIndexPath *)indexpath
{
    if(ObservationSelection.length>0)
    {
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexpath.section],@"Key",ObservationSelection,@"Value", nil];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexpath.section]];
        
        NSArray *array=[obserArray filteredArrayUsingPredicate:predicate];
        
        NSInteger integer=[obserArray indexOfObject:[[obserArray filteredArrayUsingPredicate:predicate] firstObject]];
        
        
        [obserArray replaceObjectAtIndex:integer withObject:dict];
        
    // Observation=ObservationSelection;
    }
    if(frameworkSelection.length>0)
    {
        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexpath.section],@"Key",frameworkSelection,@"Value", nil];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexpath.section]];
        
        NSArray *array=[framworkArray filteredArrayUsingPredicate:predicate];
        
        NSInteger integer=[framworkArray indexOfObject:[[framworkArray filteredArrayUsingPredicate:predicate] firstObject]];


          [framworkArray replaceObjectAtIndex:integer withObject:dict];
    // frameowrk=frameworkSelection;
    }
    
    
    //self.view.
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    //  UIView.setAnimationsEnabled(true)
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationNone];
   // [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadLearningJourney
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    

    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/lists",serverURL];
    
    NSLog(@"DraftList URL : %@", urlString);
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"submitted,submitted_processing",@"type",@"All",@"observation_filter",@ "practitioner",@"filter_type", [APICallManager sharedNetworkSingleton].cacheChild.childId, @"child_id",[NSString stringWithFormat:@"%ld",(long)pageNumber],@"page", nil];
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                
                
            });

            return;
        }
        [self backgroundLoadData:data];
    
    }];
    
    [postDataTask resume];
}
-(void)reloadTable
{
    dataArray=[NSMutableArray new];
    
    [self loadData];
}
-(void)backgroundLoadData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
      
        
    });
    NSArray *comentArray;
    NSInteger inte = 0;
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"Draft List Response JSON : %@", jsonDict);

    NSArray *array=[jsonDict objectForKey:@"data"];
    
    if(array.count>0)
    {
    
    for (int i=0; i<array.count; i++) {
        
       ljModel=[[LearningJourneyModel alloc] init];
        NSDictionary *dict=[array objectAtIndex:i];
        ljModel.ageNumber =[NSNumber numberWithInteger:[[dict objectForKey:@"age_months"] integerValue]];
        ljModel.analysis=[dict objectForKey:@"analysis"];
        ljModel.child_id=[dict objectForKey:@"child_id"];
        ljModel.comments=[dict objectForKey:@"comments"];
        ljModel.date_time=[dict objectForKey:@"date_time"];
        ljModel.commentsCount=[dict objectForKey:@"commentsCount"];
        
        NSArray *arrayEcat=[dict objectForKey:@"ecat"];
        
        if(arrayEcat.count>0)
        {
            ljModel.ecat=[NSMutableArray new];
            
            for (int j =0; j<arrayEcat.count; j++) {
                NSDictionary *dict =[arrayEcat objectAtIndex:j];
                
                OBEcat * obEcat = [[OBEcat alloc]init];
                obEcat.ecatFrameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"ecat_id"]integerValue]];
                [ljModel.ecat addObject:obEcat];
                
                //obEcat.ecatFrameworkLevelNumber = @(0);
                //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                
                
            }
        }
        NSArray *arrayMon=[dict objectForKey:@"montessori"];
        
        if(arrayMon.count>0)
        {
            ljModel.montessory=[NSMutableArray new];
            
            for (int j =0; j<arrayMon.count; j++) {
                NSDictionary *dict =[arrayMon objectAtIndex:j];
                if(!([[dict objectForKey:@"montessori_framework_item_id"] integerValue]==0&&[[dict objectForKey:@"montessori_assessment"]integerValue]==0))
                {
                OBMontessori * obMon = [[OBMontessori alloc]init];
                obMon.montessoriFrameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"montessori_framework_item_id"]integerValue]];
                [ljModel.montessory addObject:obMon];
                }
                
                //obEcat.ecatFrameworkLevelNumber = @(0);
                //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                
                
            }
        }

        NSArray *arrayEyfs=[dict objectForKey:@"eyfs"];
        
        if(arrayEyfs.count>0)
        {
            ljModel.eyfs=[NSMutableArray new];
            
            for (int j =0; j<arrayEyfs.count; j++) {
                NSDictionary *dict =[arrayEyfs objectAtIndex:j];
                
                if(!([[dict objectForKey:@"framework_item_id"] integerValue]==0&&[[dict objectForKey:@"assessment_level"]integerValue]==0))
                {
                OBEyfs * obEyfs = [[OBEyfs alloc]init];
                obEyfs.frameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"framework_item_id"] integerValue]];
                obEyfs.assessmentLevel=[NSNumber numberWithInteger:[[dict objectForKey:@"assessment_level"]integerValue]];
                [ljModel.eyfs addObject:obEyfs];
                }
                //obEcat.ecatFrameworkLevelNumber = @(0);
                //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                
                
            }
        }
        if([[dict objectForKey:@"mode"] isEqualToString:@"processing"])
        {
            ljModel.media =nil;
            
        }
        else
        {
            
            NSDictionary *dictionary =[dict objectForKey:@"media"];
            
            OBMedia * obMedia = [[OBMedia alloc]initWithDictionary:dictionary];
            //        obMedia.images = [dictionary objectForKey:@"image"];
            //        obMedia.videos=[dictionary objectForKey:@"video"];
            //        obMedia.audios=[dictionary objectForKey:@"audio"];
            ljModel.media = obMedia;
        }
        
        
        
        
        NSArray *arrayCoel=[dict objectForKey:@"coel"];
        
        if(arrayCoel.count>0)
        {
            ljModel.coel=[NSMutableArray new];
            
            for (int j =0; j<arrayCoel.count; j++) {
                NSDictionary *dict =[arrayCoel objectAtIndex:j];
                
                OBCoel * obcoel = [[OBCoel alloc]init];
                obcoel.coelId = [NSNumber numberWithInteger:[[dict objectForKey:@"coel_id"]integerValue]];
               
                [ljModel.coel addObject:obcoel];
                
                
            }
        }

        ljModel.next_steps=[dict objectForKey:@"next_steps"];
        if ([dict objectForKey:@"observation_by"] == nil || [dict objectForKey:@"observation_by"] == (id)[NSNull null])
        {
        
        }
        else
        {
         ljModel.observation_by=[dict objectForKey:@"observation_by"];
        }
       
        ljModel.observation_id=[NSNumber numberWithInteger:[[dict objectForKey:@"observation_id"] integerValue]];
        ljModel.observation_text=[dict objectForKey:@"observation_text"];
        ljModel.observer_id=[NSNumber numberWithInteger:[[dict objectForKey:@"observer_id"] integerValue]];
        ljModel.quick_observation_tag=[NSNumber numberWithInteger:[[dict objectForKey:@"quick_observation_tag"] integerValue]];
        
        if([[dict objectForKey:@"scale_involvement"] integerValue]!=0)
        {
        ljModel.scale_involvement=[NSNumber numberWithInteger:[[dict objectForKey:@"scale_involvement"] integerValue]];
        }
        if([[dict objectForKey:@"scale_well_being"] integerValue]!=0)
        {
            ljModel.scale_well_being=[NSNumber numberWithInteger:[[dict objectForKey:@"scale_well_being"] integerValue]];

        }
        ljModel.unique_tablet_OID=[dict objectForKey:@"unique_tablet_OID"];
        
        [dataArray addObject:ljModel];
        comentArray=[dict objectForKey:@"comments_details"];
        inte=[[dict objectForKey:@"observation_id"] integerValue];
        
    }
        
        if(_isComeFromNotification)
        {
        
            coments=[[ComentsViewController alloc] initWithNibName:@"ComentsViewController" bundle:nil];
            coments.isComeFromObservationWithComments=YES;
            coments.obserID=[NSNumber numberWithInteger:inte];
           
            coments.delegate=self;
            
            
            NSMutableArray *comentsModelArray=[NSMutableArray new];
            
            if(comentArray.count>0)
            {
                
                
                for(int i=0;i<comentArray.count;i++)
                {
                    NSDictionary *dict=[comentArray objectAtIndex:i];
                    
                                    Comments *coment=[Comments new];
                                    coment.comment=[dict objectForKey:@"comment"];
                                    coment.commentSender=[dict objectForKey:@"commentSender"];
                                    coment.comment_id=[dict objectForKey:@"comment_id"];
                                    coment.date_time=[dict objectForKey:@"date_time"];
                                    coment.eylog_user_id=[dict objectForKey:@"eylog_user_id"];
                                    coment.last_modified_by=[dict objectForKey:@"last_modified_by"];
                                    coment.last_modified_date=[dict objectForKey:@"last_modified_date"];
                                    coment.observation_id=[dict objectForKey:@"observation_id"];
                                    coment.user_id=[dict objectForKey:@"user_id"];
                                    coment.user_role=[dict objectForKey:@"user_role"];
                                   [comentsModelArray addObject:coment];
                    
                    
                }
            }
            coments.comentsArray=comentsModelArray;
            //[coments.tableView reloadData];
            
        }
        
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
        obserArray=[[NSMutableArray alloc] initWithCapacity:dataArray.count];
        framworkArray=[[NSMutableArray alloc] initWithCapacity:dataArray.count];
        memoryCache=[[NSCache alloc] init];
        
        [refresControl endRefreshing];
        [self.tableView reloadData];
        
            if(_isComeFromNotification)
            {
                [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) animated:YES];
                
            }
        
       
        
    });
 
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
    
    if(dataArray.count==0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
               [self.view makeToast:@"Learning Journey not found" duration:2.0f position:CSToastPositionTop];
        });

    }

    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text;
    
    NSString *text2;

    LearningJourneyModel *model=[dataArray objectAtIndex:indexPath.section];
//    if(Observation.length==0)
//    {
       Observation=@"Observation";
    
   // }
//    if(frameowrk.length==0)
//    {
    if(model.eyfs.count>0)
    {
        if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
        {
            
            frameowrk=@"EYFS";
        }
        
    }
    else if(model.coel.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.coel)
        {
            frameowrk=@"CoEL";
        }
        
    }
    else  if(model.ecat.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.ecat)
        {
            
            frameowrk=@"ECaT";
        }
        
    }
    else    if(model.montessory.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.montessori)
        {
            frameowrk=@"Montessori";
        }
        
    }
    else   if(model.scale_involvement!=nil)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
        {
            frameowrk=@"Involvement";
        }
        
    }
    else if(model.scale_well_being !=nil)
    {
        
        if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
        {
            
            frameowrk=@"Well Being";
        }
        
        }
    
    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.section],@"Key",Observation,@"Value", nil];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *array=[obserArray filteredArrayUsingPredicate:predicate];
    
    if(array.count==0)
    {
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.section],@"Key",Observation,@"Value", nil];
        
        [obserArray addObject:dict];
    }
    else
    {
//        NSInteger integer=[obserArray indexOfObject:[[obserArray filteredArrayUsingPredicate:predicate] firstObject]];
//        
//        
//        [obserArray replaceObjectAtIndex:integer withObject:dict];
    }
    
  
    NSDictionary *dict1=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.section],@"Key",frameowrk,@"Value", nil];
    NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *array1=[framworkArray filteredArrayUsingPredicate:predicate1];
    
    if(array1.count==0)
    {
        NSDictionary *dict2=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.section],@"Key",frameowrk,@"Value", nil];
        
        [framworkArray addObject:dict2];
    }
    else
    {
//        NSInteger integer=[framworkArray indexOfObject:[[framworkArray filteredArrayUsingPredicate:predicate1] firstObject]];
//        
//        
//        [framworkArray replaceObjectAtIndex:integer withObject:dict1];
    }
    
        
 //   }
   
    NSPredicate *predicateNew=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *arrayNew=[framworkArray filteredArrayUsingPredicate:predicateNew];
    
    NSDictionary *dictNew=[arrayNew firstObject];
    
    
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"EYFS"])
    {
        for (OBEyfs *obEyfs in model.eyfs) {
            Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:statement.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
            
            Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
            
            text2 = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",text2,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc, statement.statementDesc];
        }
 
    }
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"CoEL"])
    {
        for (OBCoel *obCoel in model.coel) {
            
            NSArray *array=[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obCoel.coelId withFrameWork:@"COEL"];
            Statement *statement=[array lastObject];
            
            NSArray *new=[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:statement.aspectIdentifier withFrameWork:@"COEL"];
            
            Aspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"COEL" ];
            
            Framework *eact=[ecatarray lastObject];
            
            text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,eact.areaDesc,aspect.aspectDesc,statement.statementDesc];
            
        }

    }
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"ECaT"])
    {
     
        
        for (OBEcat *obecat in model.ecat) {
            
            NSArray *array=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:obecat.ecatFrameworkItemId withFramework:@"Ecat"];
            EcatStatement *statement=[array lastObject];
            
            NSArray *new=[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withlevelTwoIdentifier:statement.levelTwoIdentifier withFramework:@"Ecat"];
            
            EcatAspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withLevelIdentifier:aspect.levelOneIdentifier withFramework:@"Ecat"];
            
            
            EcatFramework *eact=[ecatarray lastObject];
            
            text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,eact.levelOneDescription,aspect.levelTwoDescription,statement.levelThreeDescription];
            
        }

    }
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"Montessori"])
    {
        for (OBMontessori *obMonte in model.montessory) {
            BOOL isLevelThree;
            isLevelThree=NO;
            LevelFour *lvlfour=[[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:obMonte.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])]lastObject];
            LevelThree *lvlThree;
            if (lvlfour) {
                isLevelThree=NO;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:lvlfour.levelThreeIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            }else{
                isLevelThree=YES;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:obMonte.montessoriFrameworkItemId withFramework:NSStringFromClass([Montessori class])] lastObject];
            }
            
            
            LevelTwo *lvlTwo=[[LevelTwo fetchLevelTwoInContext:[AppDelegate context] withlevelTwoIdentifier:lvlThree.levelTwoIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            
            MontessoriFramework *lvlOne=[[MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withLevelIdentifier:lvlTwo.levelOneIdentifier withFramework:NSStringFromClass([Montessori class])]lastObject];
            
            if (isLevelThree) {
                text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
            }else{
                text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",text2,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
            }
            
        }
        
    }
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"Involvement"])
    {
        if([model.scale_involvement integerValue]>0)
        {
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"involvement" andLeuvenScale:model.scale_involvement];
            LeuvenScale *scale=[array lastObject];
            
            text2=scale.signals;
            
        }

    }
    if([[dictNew objectForKey:@"Value"] isEqualToString:@"Well Being"])
    {
        if([model.scale_well_being integerValue]>0)
        {
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"well_being" andLeuvenScale:model.scale_well_being];
            LeuvenScale *scale=[array lastObject];
            
            text2=scale.signals;
            
        }
        
    }
    NSPredicate *predicateOb=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *arrayOb=[obserArray filteredArrayUsingPredicate:predicateOb];
    
    NSDictionary *dictOb=[arrayOb firstObject];
    
    if([[dictOb objectForKey:@"Value"] isEqualToString:@"Observation"])
    {
        text=model.observation_text;
        
    }
    if([[dictOb objectForKey:@"Value"] isEqualToString:@"Analysis"])
    {
         text=model.analysis;
    }
    if([[dictOb objectForKey:@"Value"] isEqualToString:@"Next Steps"])
    {
         text=model.next_steps;
    }
    if([[dictOb objectForKey:@"Value"] isEqualToString:@"Additional comments"])
    {
         text=model.comments;
    }
    
    NSLog(@"%f",self.view.frame.size.width-18-254);
    
      CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.view.frame.size.width-18-254, 1000.0f)];
      CGSize textSize2 = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 10 * 3, 1000.0f)];
    if(textSize.height<134)
    {
        textSize=CGSizeMake(textSize.width, 134);
        
    }
    if(text2.length>0)
    {
    if(textSize2.height<134)
    {
        textSize2=CGSizeMake(textSize2.width, 134);
        
    }
    }
    
    if(textSize2.height==0)
    {
   return textSize.height+textSize2.height+20+30;
    }
    else
    {
      return textSize.height+textSize2.height+50+20+30;
    }
 
}

- (void)keyboardDidShow: (NSNotification *) notif{
    if (isKeyboardVisible) {
        return;
    }
    isKeyboardVisible = YES;
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int height = MIN(kbSize.height,kbSize.width);
    int width = MAX(kbSize.height,kbSize.width);
    
    NSLog(@"Keyboard Show Height: %d Width: %d", height, width);
    
    // move the view up by 30 pts
    CGRect frame = self.tableView.frame;
    frame.size.height -= height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    }];
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    isKeyboardVisible = NO;
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int height = MIN(kbSize.height,kbSize.width);
    int width = MAX(kbSize.height,kbSize.width);
    
    NSLog(@"Keyboard Hide Height: %d Width: %d", height, width);
    
    // move the view up by 30 pts
    CGRect frame = self.tableView.frame;
    frame.size.height += height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    LearningJourneyTableViewCell *cell = (LearningJourneyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LearningJourneyTableViewCellReuseID];
    if (!cell) {
        cell = [[LearningJourneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LearningJourneyTableViewCellReuseID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lJModel=[dataArray objectAtIndex:indexPath.section];
    cell.delegate=self;
    cell.indexpath=indexPath;
       
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0f]];
   
    if(cell.lJModel.media.images.count==0&&cell.lJModel.media.videos.count==0&&cell.lJModel.media.audios.count==0&&cell.lJModel.media!=nil)
    {
        [cell.thumbView setHidden:YES];
        [cell.observationCollectioView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.observationCollectioView setFrame:CGRectMake(8, cell.observationCollectioView.frame.origin.y, cell.contentView.frame.size.width-20, cell.observationCollectioView.frame.size.height)];
        [cell.observationCollectioView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [cell.observationTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSInteger hGT;
        NSString *str;
        NSPredicate *predicateObservation=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        
        NSArray *arrayObservation=[obserArray filteredArrayUsingPredicate:predicateObservation];
        
        NSDictionary *dictObservation=[arrayObservation firstObject];
        
        
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Observation"])
        {
            str=cell.lJModel.observation_text;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Analysis"])
        {
            str=cell.lJModel.analysis;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Next Steps"])
        {
            str=cell.lJModel.next_steps;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Additional Notes"])
        {
            str=cell.lJModel.comments;
        }

         CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(cell.observationTextView.frame.size.width, 1000.0f)];
        if(textSize.height<134)
        {
            hGT=134;
            
        }
        else
        {
            hGT=textSize.height;
            
        }
        
        if(textSize.height>134)
        {
          
            [cell.observationTextView sizeThatFits:CGSizeMake(cell.observationTextView.frame.size.width,hGT )];
          
        }
        
        [cell.observationTextView setFrame:CGRectMake(8, cell.observationTextView.frame.origin.y, self.view.frame.size.width-35, hGT)];
        [cell.observationTextView setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    else
    {
        [cell.thumbView setHidden:NO];
        [cell.thumbView setImage:[UIImage imageNamed:@"eylog_Logo"]];
        [cell.thumbView setContentMode:UIViewContentModeCenter];
        if(cell.lJModel.media==nil)
        {
            UILabel *processing=[[UILabel alloc] initWithFrame:CGRectMake(70, cell.thumbView.frame.size.height-40, cell.thumbView.frame.size.width, 30)];
            processing.text=@"Processing Media ... ";
            processing.font=[UIFont systemFontOfSize:11.0];
            
            processing.textColor=[UIColor darkGrayColor];
            [cell.thumbView addSubview:processing];
                        
            [cell.thumbView setImage:[UIImage imageNamed:@"ic_processing"]];
            [cell.thumbView setContentMode:UIViewContentModeCenter];
            
        }
        else
        {
            [cell.thumbView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.thumbView setFrame:CGRectMake(cell.thumbView.frame.origin.x, cell.thumbView.frame.origin.y, 251, cell.thumbView.frame.size.height)];
            [cell.thumbView setTranslatesAutoresizingMaskIntoConstraints:YES];
            
            if(cell.lJModel.media.images.count>0)
            {
                ImageFile *image=[cell.lJModel.media.images firstObject];
                
                NSString* theFileName = [image.url lastPathComponent];
                
                NSArray * words = [theFileName componentsSeparatedByString:@"?"];
                if([memoryCache objectForKey:[words objectAtIndex:0]]!=nil)
                {
                    NSData *data = [memoryCache objectForKey:[words objectAtIndex:0]];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    cell.thumbView.image = img;
                    [cell.thumbView setContentMode:UIViewContentModeScaleAspectFit];
                }
                else
                {
                
                dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(q, ^{
                    /* Fetch the image from the server... */
                    NSURL *url;
                    
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud=[MBProgressHUD showHUDAddedTo:cell.thumbView animated:YES];
                        [hud setColor:[UIColor clearColor]];
                        
                        
                    });
                    
                    url=[NSURL URLWithString:image.url];
                    
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    NSString* theFileName = [image.url lastPathComponent];
                    
                    NSArray * words = [theFileName componentsSeparatedByString:@"?"];
                    if (data) {
                        
                        // STORE IN FILESYSTEM
                        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *file = [cachesDirectory stringByAppendingPathComponent:[words objectAtIndex:0]];
                        [data writeToFile:file atomically:YES];
                        
                        // STORE IN MEMORY
                        [memoryCache setObject:data forKey:[words objectAtIndex:0]];
                        
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:cell.thumbView animated:YES];
                        
                        
                        /* This is the main thread again, where we set the tableView's image to
                         be what we just fetched. */
                        cell.thumbView.image = img;
                        [cell.thumbView setContentMode:UIViewContentModeScaleAspectFit];
                        
                    });
                });
                }
                
            }
            
          else  if(cell.lJModel.media.videos.count>0)
            {
                [cell.thumbView setBackgroundColor:[UIColor blackColor]];
                
                cell.thumbView.image = [UIImage imageNamed:@"play_new"];
                [cell.thumbView setContentMode:UIViewContentModeCenter];

            }
           else if (cell.lJModel.media.audios.count>0)
           {
               cell.thumbView.image = [UIImage imageNamed:@"icon_audio"];
               [cell.thumbView setContentMode:UIViewContentModeCenter];

           }
        }
        
        [cell.observationCollectioView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.observationCollectioView setFrame:CGRectMake(cell.thumbView.frame.origin.x+cell.thumbView.frame.size.width+8, cell.observationCollectioView.frame.origin.y, self.view.frame.size.width-45-cell.thumbView.frame.size.width, cell.observationCollectioView.frame.size.height)];
        [cell.observationCollectioView setTranslatesAutoresizingMaskIntoConstraints:YES];
        NSInteger hGT;
        
        NSString *str;
        NSPredicate *predicateObservation=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];

        NSArray *arrayObservation=[obserArray filteredArrayUsingPredicate:predicateObservation];
        NSDictionary *dictObservation=[arrayObservation firstObject];
        
        
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Observation"])
        {
            str=cell.lJModel.observation_text;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Analysis"])
        {
            str=cell.lJModel.analysis;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Next Steps"])
        {
            str=cell.lJModel.next_steps;
        }
        if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Additional Notes"])
        {
            str=cell.lJModel.comments;
        }
        
        CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(cell.observationTextView.frame.size.width, 1000.0f)];
        if(textSize.height<134)
        {
            hGT=134;
            
        }
        else
        {
            hGT=textSize.height;
            
        }
        [cell.observationTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.observationTextView setFrame:CGRectMake(cell.thumbView.frame.origin.x+cell.thumbView.frame.size.width+8, cell.observationTextView.frame.origin.y, self.view.frame.size.width-35-cell.thumbView.frame.size.width, hGT)];
        [cell.observationTextView setTranslatesAutoresizingMaskIntoConstraints:YES];

        
    }
    cell.frameworkcollectionArray=[NSMutableArray new];
    cell.observationCollectionArray=[NSMutableArray new];
    
    if(cell.lJModel.eyfs.count>0)
    {
        if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
        {
        [cell.frameworkcollectionArray addObject:@"EYFS"];
        }
        
    }
    if(cell.lJModel.coel.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.coel)
        {
        [cell.frameworkcollectionArray addObject:@"CoEL"];
        }
        
    }
    if(cell.lJModel.ecat.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.ecat)
        {
        [cell.frameworkcollectionArray addObject:@"ECaT"];
        }
        
    }
    if(cell.lJModel.montessory.count>0)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.montessori)
        {
        [cell.frameworkcollectionArray addObject:@"Montessori"];
        }
        
    }
    if(cell.lJModel.scale_involvement!=nil)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
        {
        [cell.frameworkcollectionArray addObject:@"Involvement"];
        }
        
    }
    if(cell.lJModel.scale_well_being !=nil)
    {
        if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
        {
        [cell.frameworkcollectionArray addObject:@"Well Being"];
        }
        
    }
    
    if(cell.lJModel.observation_text.length>0)
    {
        [cell.observationCollectionArray addObject:@"Observation"];
        
    }
    if(cell.lJModel.analysis.length>0)
    {
        [cell.observationCollectionArray addObject:@"Analysis"];
        
    }
    if(cell.lJModel.next_steps.length>0)
    {
        [cell.observationCollectionArray addObject:@"Next Steps"];
        
    }
    if(cell.lJModel.comments.length>0)
    {
        [cell.observationCollectionArray addObject:@"Additional Notes"];
        
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *array=[framworkArray filteredArrayUsingPredicate:predicate];
    
    NSDictionary *dict=[array firstObject];

    
    
//    if(frameowrk.length==0)
//    {
//        if(cell.frameworkcollectionArray.count>0)
//        {
//        cell.framework=[cell.frameworkcollectionArray objectAtIndex:0];
//        }
//        
//    }
//    else
//    {
        cell.framework=[dict objectForKey:@"Value"];
        
 //   }
//    if(Observation.length==0)
//    {
//        
//        cell.observation=[cell.observationCollectionArray objectAtIndex:0];
//        
//    }
//    else
//    {
    
   // }
    [cell dataSetup];
    [cell.observationCollectioView.collectionViewLayout invalidateLayout];
    [cell.frameworksCollectionView.collectionViewLayout invalidateLayout];
    
    NSString *text2;
    
    if([[dict objectForKey:@"Value"] isEqualToString:@"Well Being"])
    {
        if([cell.lJModel.scale_well_being integerValue]>0)
        {
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"well_being" andLeuvenScale:cell.lJModel.scale_well_being];
            LeuvenScale *scale=[array lastObject];
            
            text2=scale.signals;
            
        }
        
    }
    if([[dict objectForKey:@"Value"] isEqualToString:@"EYFS"])
    {
        for (OBEyfs *obEyfs in cell.lJModel.eyfs) {
            Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:statement.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
            
            Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
         
            text2 = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",text2,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc, statement.statementDesc];
           
            
        }
        
    }
    if([[dict objectForKey:@"Value"] isEqualToString:@"CoEL"])
    {
        for (OBCoel *obCoel in cell.lJModel.coel) {
            
            NSArray *array=[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obCoel.coelId withFrameWork:@"COEL"];
            Statement *statement=[array lastObject];
            
            NSArray *new=[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:statement.aspectIdentifier withFrameWork:@"COEL"];
            
            Aspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"COEL" ];
            
            Framework *eact=[ecatarray lastObject];
            
            text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,eact.areaDesc,aspect.aspectDesc,statement.statementDesc];
            
        }
        
    }
    if([[dict objectForKey:@"Value"] isEqualToString:@"ECaT"])
    {
        
        
        for (OBEcat *obecat in cell.lJModel.ecat) {
            
            NSArray *array=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:obecat.ecatFrameworkItemId withFramework:@"Ecat"];
            EcatStatement *statement=[array lastObject];
            
            NSArray *new=[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withlevelTwoIdentifier:statement.levelTwoIdentifier withFramework:@"Ecat"];
            
            EcatAspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withLevelIdentifier:aspect.levelOneIdentifier withFramework:@"Ecat"];
            
            
            EcatFramework *eact=[ecatarray lastObject];
            
            text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,eact.levelOneDescription,aspect.levelTwoDescription,statement.levelThreeDescription];
            
        }
        
    }
    if([[dict objectForKey:@"Value"] isEqualToString:@"Montessori"])
    {
        for (OBMontessori *obMonte in cell.lJModel.montessory) {
            BOOL isLevelThree;
            isLevelThree=NO;
            LevelFour *lvlfour=[[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:obMonte.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])]lastObject];
            LevelThree *lvlThree;
            if (lvlfour) {
                isLevelThree=NO;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:lvlfour.levelThreeIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            }else{
                isLevelThree=YES;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:obMonte.montessoriFrameworkItemId withFramework:NSStringFromClass([Montessori class])] lastObject];
            }
            
            
            LevelTwo *lvlTwo=[[LevelTwo fetchLevelTwoInContext:[AppDelegate context] withlevelTwoIdentifier:lvlThree.levelTwoIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            
            MontessoriFramework *lvlOne=[[MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withLevelIdentifier:lvlTwo.levelOneIdentifier withFramework:NSStringFromClass([Montessori class])]lastObject];
            
            if (isLevelThree) {
                text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",text2,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
            }else{
                text2=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",text2,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
            }
            
        }
        
    }
    if([[dict objectForKey:@"Value"] isEqualToString:@"Involvement"])
    {
        if([cell.lJModel.scale_involvement integerValue]>0)
        {
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"involvement" andLeuvenScale:cell.lJModel.scale_involvement];
            LeuvenScale *scale=[array lastObject];
            
            text2=scale.signals;
            
        }
        
    }
    NSString *str;
    
    NSPredicate *predicateObservation=[NSPredicate predicateWithFormat:@"SELF.Key == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    NSArray *arrayObservation=[obserArray filteredArrayUsingPredicate:predicateObservation];
    
    NSDictionary *dictObservation=[arrayObservation firstObject];
    
    
    if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Observation"])
    {
        str=cell.lJModel.observation_text;
    }
    if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Analysis"])
    {
        str=cell.lJModel.analysis;
    }
    if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Next Steps"])
    {
        str=cell.lJModel.next_steps;
    }
    if([[dictObservation objectForKey:@"Value"] isEqualToString:@"Additional Notes"])
    {
        str=cell.lJModel.comments;
    }
    cell.observation=[dictObservation objectForKey:@"Value"];
    
    NSInteger hGT;
    CGSize textSize = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(cell.frameworkTextview.frame.size.width, 1000.0f)];
    if(textSize.height<134)
    {
        hGT=134;
        
    }
    else
    {
        hGT=textSize.height;
        
    }
    [cell.frameworksCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.frameworksCollectionView setFrame:CGRectMake(cell.frameworksCollectionView.frame.origin.x, cell.observationTextView.frame.origin.y+cell.observationTextView.frame.size.height+8, self.view.frame.size.width-35, cell.frameworksCollectionView.frame.size.height)];
    [cell.frameworksCollectionView setTranslatesAutoresizingMaskIntoConstraints:YES];

    
      [cell.frameworkTextview setTranslatesAutoresizingMaskIntoConstraints:NO];
      [cell.frameworkTextview setFrame:CGRectMake(cell.frameworkTextview.frame.origin.x, cell.frameworksCollectionView.frame.origin.y+cell.frameworksCollectionView.frame.size.height, self.view.frame.size.width-35, hGT)];
      [cell.frameworkTextview setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    
    [cell.observationCollectioView reloadData];
    [cell.frameworksCollectionView reloadData];
    UIView *border = [UIView new];
    ;
    border.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
    border.frame = CGRectMake(0, 0, 2, cell.contentView.frame.size.height+2);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [cell.contentView addSubview:border];
    
    
    UIView *border1 = [UIView new];
    border1.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
    [border1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border1.frame = CGRectMake(cell.contentView.frame.size.width - 2, 0, 2, cell.contentView.frame.size.height+2);
    [cell.contentView addSubview:border1];
    
    
//    UIView *border2 = [UIView new];
//    border2.backgroundColor = [UIColor lightGrayColor];
//    border2.frame = CGRectMake(cell.observationTextView.frame.origin.x, cell.observationTextView.frame.origin.y, 2, cell.observationTextView.frame.size.height);
//    [border2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
//    [cell.contentView addSubview:border2];
    
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.observationTextView.bounds];
        cell.observationTextView.layer.masksToBounds = NO;
        cell.observationTextView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.observationTextView.layer.shadowOffset = CGSizeMake(0.0, 2.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
        cell.observationTextView.layer.shadowOpacity = 0.8f;
        cell.observationTextView.layer.shadowPath = shadowPath.CGPath;
    
    
    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:cell.frameworkTextview.bounds];
    cell.frameworkTextview.layer.masksToBounds = NO;
    cell.frameworkTextview.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.frameworkTextview.layer.shadowOffset = CGSizeMake(0.0, 2.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    cell.frameworkTextview.layer.shadowOpacity = 0.8f;
    cell.frameworkTextview.layer.shadowPath = shadowPath1.CGPath;
    
    
    
    return cell;
    

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     LearningJourneyModel *model= [dataArray objectAtIndex:section];
    
    lJView=[[[NSBundle mainBundle]loadNibNamed:@"LJHeaderView" owner:self options:nil] objectAtIndex:0];
    [lJView setTranslatesAutoresizingMaskIntoConstraints:YES];
     lJView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
    [lJView setFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    lJView.nameLabel.text=model.observation_by;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [formatter dateFromString:model.date_time];
//    
//    [formatter setDateFormat:@"dd"];
//    NSString* day = [formatter stringFromDate:date];
//    [formatter setDateFormat:@"MMM yyyy"];
//    NSDateFormatter *newFormatter=[NSDateFormatter new];
//    
//    [newFormatter setDateFormat:@"hh:mm:ss a"];
//    NSString *timestr=[newFormatter stringFromDate:date];
//    
//    
//    NSString* monthAndYear = [formatter stringFromDate:date];
//    NSString* dateStr = [NSString stringWithFormat:@"%@th %@ at %@", day, monthAndYear,timestr];
    
    lJView.dateLabel.text=model.date_time;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *array= [Practitioners fetchPractitionersInContext:[AppDelegate context] withPractitionerId:model.observer_id];
        Practitioners *pract=[array lastObject];
        
        
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],pract.photo];
        
        UIImage *practitionerImage=[UIImage imageWithContentsOfFile:imagePath];
        
        
            lJView.iconImage.layer.cornerRadius = 25;
            lJView.iconImage.layer.masksToBounds = YES;
            lJView.iconImage.image =[UIImage imageNamed:@"eylog_Logo"];
            if(practitionerImage!=nil)
            {
                lJView.iconImage.image = practitionerImage;
            }
            
      
        
    //});
    //[lJView setTranslatesAutoresizingMaskIntoConstraints:YES];

    UIView *border = [UIView new];
    border.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
    border.frame = CGRectMake(0, 0, 2, lJView.frame.size.height+2);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [lJView addSubview:border];
    
    
    UIView *border1 = [UIView new];
    border1.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
    [border1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border1.frame = CGRectMake(lJView.frame.size.width - 2, 0, 2, lJView.frame.size.height+2);
    [lJView addSubview:border1];
    
    UIView *border2 = [UIView new];
    border2.backgroundColor =[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
    [border2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border2.frame = CGRectMake(0, 0, lJView.frame.size.width, 2);
    [lJView addSubview:border2];
    
    
    CGRect bounds = lJView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    lJView.layer.mask = maskLayer;

    
    return lJView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LearningJourneyModel *model=[dataArray objectAtIndex:section];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65)];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
    [view setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0f]];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-30, 10, 80, 30)];
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [label setTextColor:[UIColor darkGrayColor]];
    
    label.text =@"Comments";
    
    [view addSubview:label];
    
    UILabel *labelRound;
    labelRound=[[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2+50, 15, 20, 20)];
    labelRound.layer.cornerRadius =10.0;
    labelRound.layer.masksToBounds = YES;
    labelRound.font=[UIFont systemFontOfSize:11.0f];
    [labelRound setTextAlignment:NSTextAlignmentCenter];
    [labelRound setBackgroundColor:[UIColor colorWithRed:154.0/255.0 green:155.0/255.0 blue:36.0/255.0 alpha:1.0f]];
    
    labelRound.text=[NSString stringWithFormat:@"%d", [model.commentsCount integerValue]];
    [view addSubview:labelRound];

    
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2-70, 10, 30, 30)];
    [imageview setImage:[UIImage imageNamed:@"ic_comment"]];
    [view addSubview:imageview];
    
    
    
    
    
    view.layer.borderColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f].CGColor;
    CGRect bounds = view.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    [view1 addSubview:view];
  
    [view1 setUserInteractionEnabled:YES];
    [view setUserInteractionEnabled:YES];
    [label setUserInteractionEnabled:YES];
    [labelRound setUserInteractionEnabled:YES];
    [imageview setUserInteractionEnabled:YES];
    
    if(!_isComeFromNotification)
    {
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnFooter:)];
    selectedInteger=section;
    [view setTag:section];
    
    [view addGestureRecognizer:tap];
    }
    else
    {
        labelRound.text=[NSString stringWithFormat:@"%d",coments.comentsArray.count];
        
    }
    
    UIView *commentsView=[[UIView alloc] initWithFrame:CGRectMake(-10, view.frame.size.height+10, self.tableView.frame.size.width-40, coments.view.frame.size.height)];
    
    
    [coments.tableView reloadData];
    [coments.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGFloat height=0.0;
    
//    for(int i=0;i<coments.comentsArray.count;i++)
//    {
//        Comments *coment=[coments.comentsArray objectAtIndex:i];
//        
//        NSString *text=coment.comment;
//        
//        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(302, 1000.0f)];
//        if(textSize.height<60)
//        {
//            textSize.height=60;
//            
//        }
//        height=textSize.height+height+10;
//        
//    }
    
    [coments.tableView setFrame:CGRectMake(coments.tableView.frame.origin.x, coments.tableView.frame.origin.y, coments.tableView.frame.size.width, coments.tableView.contentSize.height+60)];
    [coments.footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [coments.footerView setFrame:CGRectMake(coments.footerView.frame.origin.x, coments.tableView.frame.origin.y+coments.tableView.contentSize.height+60, coments.footerView.frame.size.width, coments.footerView.frame.size.height)];
    
    
    [coments.view setFrame:CGRectMake(0,0,self.tableView.frame.size.width, coments.tableView.contentSize.height+60)];
    [commentsView setFrame:CGRectMake(0, commentsView.frame.origin.y,self.tableView.frame.size.width, coments.view.frame.size.height+65)];
    [commentsView addSubview:coments.view];
    [commentsView setUserInteractionEnabled:YES];
    
    if(_isComeFromNotification)
    {
        [view1 addSubview:commentsView];
        [view1 setFrame:CGRectMake(view1.frame.origin.x, view1.frame.origin.y, view1.frame.size.width, commentsView.frame.size.height)];

        UIView *border = [UIView new];
        border.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        border.frame = CGRectMake(0, 0, 2, coments.tableView.contentSize.height+coments.footerView.frame.size.height+2+60);
        [border setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [view1 addSubview:border];
        
        UIView *border1 = [UIView new];
        border1.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        [border1 setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin];
        border1.frame = CGRectMake(view1.frame.size.width - 2, 0, 2, coments.tableView.contentSize.height+coments.footerView.frame.size.height+60+2);
        [view1 addSubview:border1];
        
        UIView *border2 = [UIView new];
        border2.backgroundColor =[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        [border2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        border2.frame = CGRectMake(0, coments.tableView.contentSize.height+coments.footerView.frame.size.height+60+2-2, view1.frame.size.width, 2);
        [view1 addSubview:border2];
    
    }
    else
    {
        UIView *border = [UIView new];
        border.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        border.frame = CGRectMake(0, 0, 2, view1.frame.size.height+2);
        [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        [view1 addSubview:border];
        
        UIView *border1 = [UIView new];
        border1.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        [border1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
        border1.frame = CGRectMake(view1.frame.size.width - 2, 0, 2, view1.frame.size.height+2);
        [view1 addSubview:border1];
        
        UIView *border2 = [UIView new];
        border2.backgroundColor =[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:141.0/255.0 alpha:1.0f];
        [border2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        border2.frame = CGRectMake(0, view1.frame.origin.y+view1.frame.size.height-2, view1.frame.size.width, 2);
        [view1 addSubview:border2];
    }
   
    return view1;
   
    
}
-(void)tapOnFooter:(UITapGestureRecognizer*)sender
{
    isFooterView=YES;
   UIView *view = (UIView*)sender.view;
    
    ComentsViewController *coments=[[ComentsViewController alloc] initWithNibName:@"ComentsViewController" bundle:nil];
    coments.model=[dataArray objectAtIndex:view.tag];
    coments.delegate=self;
    coments.tag=[NSNumber numberWithInteger:view.tag];
       _popover= [[UIPopoverController alloc] initWithContentViewController:coments];
        _popover.delegate=self;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation==UIDeviceOrientationPortrait ||orientation==UIDeviceOrientationPortraitUpsideDown ||orientation==UIDeviceOrientationFaceUp)
    {
        [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-280, self.view.frame.size.height-200) animated:NO];
        
    }
    else if(orientation==UIDeviceOrientationLandscapeRight ||orientation==UIDeviceOrientationLandscapeLeft)
    {
        [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-200, self.view.frame.size.height-280) animated:NO];
    }

    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];

}
-(void)CloseButton:(UIButton *)btn andTag:(NSNumber *)num andCount:(NSNumber *)count
{
    
    LearningJourneyModel *model=[dataArray objectAtIndex:[num integerValue]];
    model.commentsCount=count;
    
    [dataArray replaceObjectAtIndex:[num integerValue] withObject:model];
    [self.tableView reloadData];
    
    
    [_popover dismissPopoverAnimated:YES];
    
    
}
-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    isFooterView=NO;
    
    //[popoverController dismissPopoverAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_isComeFromNotification)
    {
        
        [coments.tableView setFrame:CGRectMake(coments.tableView.frame.origin.x, coments.tableView.frame.origin.y, coments.tableView.frame.size.width, coments.tableView.contentSize.height+60)];
        [coments.footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [coments.footerView setFrame:CGRectMake(coments.footerView.frame.origin.x, coments.tableView.frame.origin.y+coments.tableView.contentSize.height+60, coments.footerView.frame.size.width, coments.footerView.frame.size.height)];
        
        
        [coments.view setFrame:CGRectMake(0,0,self.tableView.frame.size.width, coments.tableView.contentSize.height+60)];
        return coments.view.frame.size.height+70;
        
    }
    return 70.0f;
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}
- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

   if(orientation==UIDeviceOrientationPortrait ||orientation==UIDeviceOrientationPortraitUpsideDown ||orientation==UIDeviceOrientationFaceUp)
    {
        [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-280, self.view.frame.size.height-200) animated:NO];
        
    }
    else if(orientation==UIDeviceOrientationLandscapeRight ||orientation==UIDeviceOrientationLandscapeLeft)
    {
        [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-200, self.view.frame.size.height-280) animated:NO];
        
        
    }
   
    *rect =  CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    *view = self.view;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    for(UILabel *lbl in containerView.subviews)
    {
        if(lbl.tag==1)
        {
            [lbl removeFromSuperview];
            
        }
    }
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:containerView.dateLabel.frame];
    navLabel.text = @"Learning Journey";
    navLabel.tag=1;
    navLabel.textColor = [UIColor whiteColor];
    [navLabel setBackgroundColor:[UIColor clearColor]];
    
    [containerView addSubview:navLabel];

//    if(isFooterView)
//    {
//        if(fromInterfaceOrientation==UIDeviceOrientationPortrait ||fromInterfaceOrientation==UIDeviceOrientationPortraitUpsideDown)
//        {
//             [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-280, self.view.frame.size.height-200) animated:NO];
//
//        }
//        else if(fromInterfaceOrientation==UIDeviceOrientationLandscapeRight ||fromInterfaceOrientation==UIDeviceOrientationLandscapeLeft)
//        {
//            [_popover setPopoverContentSize:CGSizeMake(self.view.frame.size.width-200, self.view.frame.size.height-280) animated:NO];
//           
//
//        }
//       CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
//        [_popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:NO];
//        //
//    }
     [self.tableView reloadData];
}
-(void)clickOnThumb:(UITableViewCell *)cell andModel:(LearningJourneyModel *)model
{
    
    if(model.media==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Media is currently under processing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else
    {
    
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ImageViewerViewController *view=[storyBoard instantiateViewControllerWithIdentifier:@"ViewControllerID"];
    
//    WYPopoverController *pop = [[WYPopoverController alloc]initWithContentViewController:view];
//    pop.delegate=self;
//    
//    pop.popoverContentSize = CGSizeMake(150,132);
    NSMutableArray *array=[NSMutableArray new];
     NSMutableArray *media=[NSMutableArray new];
    for(int i=0;i<model.media.images.count;i++)
    {
        ImageFile *file=[model.media.images objectAtIndex:i];
        [array addObject:file.url];
        [media addObject:file.url];
        
    }
    for(int i=0;i<model.media.videos.count;i++)
    {
        [array addObject:@"video"];
        VideoFile *file=[model.media.videos objectAtIndex:i];
        [media addObject:file.url];
        
    }
    for(int i=0;i<model.media.audios.count;i++)
    {
         [array addObject:@"audio"];
        AudioFile *file=[model.media.audios objectAtIndex:i];
        [media addObject:file.url];
    }
    
    view.pageImages = array;
    view.pageMedia=media;
    
    
    [self.navigationController pushViewController:view animated:YES];
    }
    

    return;
    
}
//- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [UIView new];
//    border.backgroundColor = color;
//    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
//    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
//    [self addSubview:border];
//}
//
//- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [UIView new];
//    border.backgroundColor = color;
//    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
//    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
//    [self addSubview:border];reload
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
       
    }
    
    if(!_isComeFromNotification)
    {
    if (indexPath.section==dataArray.count-1) {
        pageNumber++;
        [self loadLearningJourney];
    }
    }
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
if(popoverController==_popover)
{
    return NO;
    
}
    return YES;
}
@end
