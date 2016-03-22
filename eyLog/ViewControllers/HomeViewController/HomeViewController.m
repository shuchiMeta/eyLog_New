//
//  HomeViewController.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 24/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "TeacherCell.h"
#import "GroupsViewController.h"
#import "WYPopoverController.h"
#import "ChilderenViewController.h"
#import "DataModels.h"
#import "Theme.h"
#import "APICallManager.h"
#import "Utils.h"
#import "Practitioners.h"
#import "AppDelegate.h"
#import "Child.h"
#import "Nursery.h"
#import "Practitioners.h"
#import "Setting.h"
#import "LeuvenScale.h"
#import "Assessment.h"
#import "NSString+SHAHashing.h"
#import "MontessoryAssesment.h"
#import "MontessoriAssesmentDataBase.h"
#import "MontessoriFramework.h"
#import "Framework.h"
#import "Eyfs.h"
#import "Montessori.h"
#import "Aspect.h"
#import "Age.h"
#import "Statement.h"
#import "LevelOne.h"
#import "LevelTwo.h"
#import "LevelThree.h"
#import "LevelFour.h"
#import "Reachability.h"
#import "GroupsSearchView.h"
#import "MontessoryBaseClass.h"
#import "PinViewController.h"
#import "UIView+Toast.h"
#import "EcatBaseClass.h"
#import "EcatAreaClass.h"
#import "EcatAspectClass.h"
#import "EcatStatementClass.h"
#import "Ecat.h"
#import "EcatFramework.h"
#import "EcatArea.h"
#import "EcatAspect.h"
#import "EcatStatement.h"
#import "CfeBaseClass.h"
#import "Cfe.h"
#import "CfeAssesment.h"
#import "CfeAssesmentDatabase.h"
#import "CfeLevelOne.h"
#import "CfeLevelTwo.h"
#import "CfeLevelThree.h"
#import "CfeLevelFour.h"
#import "CfeFramework.h"
#import "CfeLevel.h"
#import "CfeLevel2.h"
#import "CfeLevel3.h"
#import "CfeLevel4.h"
#import "Ethnicity.h"
#import <Crashlytics/Crashlytics.h>
#import "PractitionerPinAndRegistryViewController.h"
#import "NotificationModel.h"

//#define TICK   NSDate *startTime = [NSDate date]
//#define TOCK   NSDate *stopTime = [NSDate date]

//#import "EYL_RegistryModel.h"

// Sumit Sharma
#import "DiaryEntity.h"
#import "EYL_AppData.h"


NSString *const KServerURL=@"server_url";
NSString *const KMessage=@"message";
NSString *const KStatus=@"status";
NSString *const KNurseryId=@"nursery_id";
NSString *const KSuccess=@"success";


NSString *const KFrameworkCOEL=@"COEL";
NSString *const KFrameworkEYFS=@"EYFS";
NSString *const KFrameworkCFE=@"Cfe";
NSString *const kFrameworkMontessori=@"Montessori";
NSString *const kFrameworkEcat=@"Ecat";
UILabel *nurseryNameLabel;
BOOL isCollectionViewLoaded;
BOOL isAllDataLoaded;


// BOOL searchClick;

@interface HomeViewController () <GroupSelectionDelegate, UITextFieldDelegate, PinViewControllerDelegate,MBProgressHUDDelegate,WYPopoverControllerDelegate,TeacherCellDelegate,UIAlertViewDelegate,PractitionerPinAndRegistryDelegate>
{
    NSFileManager *fileManager;
    NSTimer *timer;
    NSTimer *waitForServerUrlTimer;
    NSIndexPath *lastPathIndex;
    Theme *theme;
    UITextField *currentTextField;
    NSArray *practitionerListForTableView;
    NSMutableArray *practitionerList;
    NSString *imageURL;
    NSMutableArray *tempPractitionerArray;
    NSMutableDictionary *sortedPractitionerDictionary;
    __block INBaseClass *baseObject;
    NSDateFormatter *dateFormatter;
    WYPopoverController *_pinPopoverController;
    UIRefreshControl *refresControl;
    BOOL isKeyboardVisible;
    BOOL alreadyHaveApp;
    UIButton *btnUpdateSettings;
    UIView *viewRight;
    NSMutableArray *childrenArray;
    PinViewController *vc;
    NSDate *startTime;
    NSDate *stopTime;
    NSIndexPath *selectedIndexpath;
    

    int a;
    
}
@property(strong, nonatomic) GroupsViewController *popoverViewController;
@property(strong, nonatomic) WYPopoverController *popover;
@property (strong, nonatomic) IBOutlet GroupsSearchView *groupSearchView;
@property(strong,nonatomic)WYPopoverController *PinRegistryPopOver;
@property(strong,nonatomic)PractitionerPinAndRegistryViewController *PinRegistryViewController;



-(IBAction)togglePopover:(UIButton *)sender;

@end
AppDelegate *appDelegate;


@implementation HomeViewController
@synthesize HomeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    theme = [Theme getTheme];
    [theme addToolbarItemsToViewCaontroller:self];
    theme.myLabel.text=@"Version 2.1.0";
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
       a=2;
    NSLog(@"%d",a);
    
    INBaseClass * inBaseClass = (INBaseClass *)[NSKeyedUnarchiver unarchiveObjectWithFile:[Utils getLabelPath]];
    NSString *string;
    if(inBaseClass.nurseryChainName.length!=0&&inBaseClass.nurseryName.length!=0)
    {
     string=[@"Nursery chain name ="stringByAppendingString:[inBaseClass.nurseryChainName stringByAppendingString:[@" Nursery Name = " stringByAppendingString:inBaseClass.nurseryName]]];
    }
    
    [CrashlyticsKit setUserIdentifier:string];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingHappens:) name:@"notificationName" object:nil];
    [theme addToolbarItemsToViewCaontroller:self];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.HomesearchFlag=1;
    appDelegate.searchClicked=0;
    
    self.navigationController.navigationBar.hidden=NO;
    
    nurseryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20.0f)];
    nurseryNameLabel.textColor = [UIColor whiteColor];
    nurseryNameLabel.numberOfLines=0;
    nurseryNameLabel.font = [UIFont systemFontOfSize:12.0f];
    nurseryNameLabel.textAlignment = NSTextAlignmentRight;
    
    
    // New Label Added By Sumit
    self.lblnurseryChainName = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 140, 20.0f)];
    self.lblnurseryChainName.textColor = [UIColor whiteColor];
    self.lblnurseryChainName.numberOfLines=0;
    self.lblnurseryChainName.font = [UIFont systemFontOfSize:12.0f];
    self.lblnurseryChainName.textAlignment = NSTextAlignmentRight;
    
    [viewRight setUserInteractionEnabled:YES];
    
    viewRight=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 40)];
    btnUpdateSettings=[[UIButton alloc]initWithFrame:CGRectMake(nurseryNameLabel.frame.size.width+3, 3, 40, 40)];
    [btnUpdateSettings setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [btnUpdateSettings addTarget:self action:@selector(updateSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewRight addSubview:nurseryNameLabel];
    [viewRight addSubview:self.lblnurseryChainName];
    [viewRight addSubview:btnUpdateSettings];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewRight];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    
    // self.HomeName.text=@"xyz";
    
    fileManager=[[NSFileManager alloc]init];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ChildrenNewData"])
    {
        
    }
    
    manager=[APICallManager sharedNetworkSingleton];
    practitionerList=[[Practitioners fetchALLPractitionersInContext:[AppDelegate context]] mutableCopy];
    
    
    if(practitionerList.count>0)
    {
        [APICallManager sharedNetworkSingleton].settingObject=[[Setting alloc]initWithSettingDictionary:[NSDictionary dictionaryWithContentsOfFile:[Utils getSettingPath]]];
        
        practitionerListForTableView=[practitionerList copy];
        
        sortedPractitionerDictionary=[self sortPractitionerDB:practitionerList];
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotoPract"] isEqualToString:@"completed"])
        {
           
        [self saveAllPractitionersPhotosAtBackground];
            
        }
        

        NSError *parentError;
//        long practitionerCount = [fileManager contentsOfDirectoryAtPath:[Utils getChildrenImages] error:&parentError].count;
//        
//        if( !(practitionerCount > 0))
//        {
//            [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
//        }
        
        if([fileManager fileExistsAtPath:[Utils getLabelPath]])
        {
            INBaseClass * inBaseClass = (INBaseClass *)[NSKeyedUnarchiver unarchiveObjectWithFile:[Utils getLabelPath]];
            [APICallManager sharedNetworkSingleton].baseClass = inBaseClass;
            nurseryNameLabel.text = inBaseClass.nurseryName;
            self.lblnurseryChainName.text = inBaseClass.nurseryChainName;
            
        }
        
        if ([Utils checkNetwork])
        {
            if([[[APICallManager sharedNetworkSingleton] settingObject].frameworkType isEqualToString:@"cfe"])
            {
                if(!([CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withFramework:KFrameworkCFE].count > 0)){
                    
                    if (alreadyHaveApp) {
                        UIViewController *topVC = self.navigationController;
                        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
                        hud.labelText=@"Loading..";
                    }
                    [self getCFEWithCompletion:^(BOOL success) {
                        
                    }];
                }
                
                
                
            }
            else
            {
                if (!([Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:KFrameworkEYFS].count > 0 ))
                {
                    [self getEyfsWithCompletion:^(BOOL success) {
                        
                    }];
                }else{
                    alreadyHaveApp=YES;
                }
                
            }
            
            if (!([Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:KFrameworkCOEL].count > 0 ))
            {
                [self getCoelWithCompletion:^(BOOL success) {
                    
                }];
            }
            
            if (!([LeuvenScale fetchAllLeuvenScaleInContext:[AppDelegate context]].count > 0 ))
            {
                [self getleuvenScaleWithCompletion:^(BOOL success) {
                    
                }];
            }
            if(!([MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withFramework:kFrameworkMontessori].count > 0)){
                
                if (alreadyHaveApp) {
                    UIViewController *topVC = self.navigationController;
                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
                    hud.labelText=@"Loading..";
                }
                [self getMontessoryWithCompletion:^(BOOL success) {
                    
                }];
            }
            else
            {
                
                [self closeAlert];
                
            }
            
                if (![EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withFramework:kFrameworkEcat].count>0) {
                UIViewController *topVC = self.navigationController;
                MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
                hud.labelText=@"Loading..";
                [self getEcatWithCompletion:^(BOOL success) {
                    
                }];
            }
            else
            {
                [self closeAlert];
                
            }
            if( [APICallManager sharedNetworkSingleton].childArray.count==0)
            {
                [APICallManager sharedNetworkSingleton].childArray=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
            }
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstTimeRegistry"])
            {
                [[APICallManager sharedNetworkSingleton] getRegistryINOUTTime];
                
            }
            
            
        }
    }
    else
    {
        if ([Utils checkNetwork])
        {
            [self getInstallation];
        }
    }
    //  [self getEyfs];
    
    
    UIView *view = self.collectionView.superview;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    refresControl = [[UIRefreshControl alloc] init];
    [refresControl addTarget:self action:@selector(collectionViewDidRefreshed:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refresControl];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [ChildInOutTime deleteAllHistoryRecords:[AppDelegate context] beforeDate:[Utils getDateStringFromDateInYYYYMMDD:[NSDate date]]];
    
    //    EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
    //    //[objEYL_AppData.array_SegmentControlTitle
    //
    //
    //    if(![objEYL_AppData.array_SegmentControlTitle containsObject:@"observationfields"])
    //    {
    //        [objEYL_AppData.array_SegmentControlTitle addObject:@"observationEyfs"];
    //
    //    }
    if([DiaryEntity fetchAllRecords:[AppDelegate context]].count==7)
    {
        NSDictionary *dict_Registry = [NSDictionary dictionaryWithObject:@"observationEyfs" forKey:@"observationEyfs"];
        
        [DiaryEntity createEYL_DiaryEntityContext:[AppDelegate context] withDictionary:dict_Registry forEntityName:@"observationEyfs"];
    }
    
    
    //    {
    //    observationfields =     (
    //                             {
    //                                 key = "observations_achievements";
    //                                 value = Observations;
    //                             },
    //                             {
    //                                 key = "observation_text";
    //                                 value = "Observation text";
    //                             },
    //                             {
    //                                 key = "areas_assessed";
    //                                 value = "Areas Assessed";
    //                             }
    //                             );
    //}
}
-(void)saveAllPractitionersPhotosAtBackground
{
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
         NSArray *array= [Practitioners fetchALLPractitionersInContext:[AppDelegate context]];
         
         if(array.count>0)
         {
         
         for(int i= 0;i<[Practitioners fetchALLPractitionersInContext:[AppDelegate context]].count;i++)
         {
             Practitioners *pract=[[Practitioners fetchALLPractitionersInContext:[AppDelegate context]] objectAtIndex:i];
             
     fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        BOOL directoryExists = [fileManager fileExistsAtPath:[Utils getPractionerImages] isDirectory:&isDirectory];
        if (directoryExists) {
            //NSLog(@"isDirectory: %d", isDirectory);
        } else {
            NSError *error = nil;
            BOOL success = [fileManager createDirectoryAtPath:[Utils getPractionerImages] withIntermediateDirectories:NO attributes:nil error:&error];
            if (!success) {
                NSLog(@"Failed to create directory with error: %@", [error description]);
            }
        }
        
        
        NSString *filePath = [[Utils getPractionerImages] stringByAppendingPathComponent:pract.photo];
        NSError *error = nil;
        UIImage *practitionerImage=[UIImage imageWithContentsOfFile:filePath];
        if(practitionerImage == nil)
        {
                NSURL *url;
            url=[NSURL URLWithString:pract.photourl];
            NSError *downloadError = nil;
            // Create an NSData object from the contents of the given URL.
            NSData *data = [NSData dataWithContentsOfURL:url
                                                 options:kNilOptions
                                                   error:&downloadError];
            if(downloadError)
            {
                NSLog(@"%@",[downloadError localizedDescription]);
            }
            BOOL success = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
            if (!success) {
                NSLog(@"Failed to write to file with error: %@", [error description]);
            }
            UIImage *imagePract=[UIImage imageWithData:data];
            
            
        }
             dispatch_async(dispatch_get_main_queue(), ^{
                 if( [self.collectionView.indexPathsForVisibleItems containsObject:[NSIndexPath indexPathForItem:i inSection:0]])
                 {
                     
                     [self.collectionView reloadItemsAtIndexPaths:[NSMutableArray arrayWithObjects:[NSIndexPath indexPathForItem:i inSection:0], nil]];
                 }
             });
             

             if(i== practitionerList.count-1)
             {
                 [[NSUserDefaults standardUserDefaults] setObject:@"completed" forKey:@"PhotoPract"];
                 
             }
             
         }
         
     }
        //
              
    });

}
-(void)somethingHappens:(NSNotification*)notification
{
    
    [self closeAlert];
    
}

-(void)refresh
{
    [self groupDidSelected:self.groupSelectionButton.titleLabel.text withCellType:KCellTypeGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    appDelegate.HomesearchFlag=1;
    appDelegate.searchClicked=0;
    
    
    //self.navigationItem setRightBarButtonItem:r animated:<#(BOOL)#>
    [theme resetTargetViewController:self];
    if(practitionerListForTableView.count>0)
    {
        [self.collectionView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.navigationItem.rightBarButtonItem=nil;
    viewRight=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 40)];
    btnUpdateSettings=[[UIButton alloc]initWithFrame:CGRectMake(nurseryNameLabel.frame.size.width+3, 3, 40, 40)];
    [btnUpdateSettings setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [btnUpdateSettings addTarget:self action:@selector(updateSettings:) forControlEvents:UIControlEventTouchUpInside];
    [viewRight addSubview:nurseryNameLabel];
    
    
    [viewRight addSubview:self.lblnurseryChainName];
    [viewRight addSubview:btnUpdateSettings];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewRight];
    NSMutableArray *array=[[Practitioners fetchALLPractitionersInContext:[AppDelegate context]] mutableCopy];
    if(array.count>0)
    {
//        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UpdateSettings"])
//        {
//            [self getSettings];
//        }
//        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UpdateSettingsVersion2.0.2"])
//        {
//            [self getSettings];
//        }
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UpdateSettingsVersion2.1.0"])
      {
       [self getSettings];
      }

        // [[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"NewEthnicity"];
        else if(![[NSUserDefaults standardUserDefaults] objectForKey:@"NewEthnicity"])
        {
            [self getSettings];
        }
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loginButtonClicked:(id)sender
{
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return practitionerListForTableView.count;
}
-(void)btnActionAtIndexpath:(NSIndexPath *)indexPath andBtn:(UIButton *)btn
{
    selectedIndexpath=indexPath;
    
if(btn.tag==0)
{
    self.PinRegistryViewController =[[PractitionerPinAndRegistryViewController alloc] initWithNibName:@"PractitionerPinAndRegistryViewController" bundle:nil];
    
    Practitioners * practitionerObject=[practitionerListForTableView objectAtIndex:indexPath.row];
    self.PinRegistryViewController.practitioner = practitionerObject;
    self.PinRegistryViewController.delegate = self;

    self.PinRegistryViewController.btnStr=@"IN";
    _PinRegistryPopOver = [[WYPopoverController alloc] initWithContentViewController:self.PinRegistryViewController];
    _PinRegistryPopOver.delegate=self;
    
    
    
    [_PinRegistryPopOver setPopoverContentSize:CGSizeMake(400, 193)];
    [_PinRegistryPopOver presentPopoverAsDialogAnimated:YES];
    [self.PinRegistryViewController.pinTextfield becomeFirstResponder];
    
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you mark this Practitioner In?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//     [alert show];
//    alert.tag=btn.tag;
    
}
    else
    {
        
        self.PinRegistryViewController =[[PractitionerPinAndRegistryViewController alloc] initWithNibName:@"PractitionerPinAndRegistryViewController" bundle:nil];
        
        Practitioners * practitionerObject=[practitionerListForTableView objectAtIndex:indexPath.row];
        self.PinRegistryViewController.practitioner = practitionerObject;
        self.PinRegistryViewController.delegate = self;
        self.PinRegistryViewController.btnStr=@"Out";
        _PinRegistryPopOver = [[WYPopoverController alloc] initWithContentViewController:self.PinRegistryViewController];
        _PinRegistryPopOver.delegate=self;
        
        [_PinRegistryPopOver setPopoverContentSize:CGSizeMake(400, 193)];
        [_PinRegistryPopOver presentPopoverAsDialogAnimated:YES];
        [self.PinRegistryViewController.pinTextfield becomeFirstResponder];
        
        
//      UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you mark this Practitioner Out?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//         alert.tag=btn.tag;
//        [alert show];
    }

}
-(void)okBtnAction:(UIButton *)button AndPinEntered:(NSString *)pinStr andBtn:(NSString *)btnStr
{
    if([btnStr isEqualToString:@"IN"])
    {
    
    TeacherCell *cell=(TeacherCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
    
    EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
    NSString *strCurrentTime = [objEYL_AppData getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
    [cell.inBtn setTitle:[@"IN" stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
    cell.inBtn.backgroundColor=KGREENCOLOR;
    cell.outBtn.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
    }
    else
    {
                TeacherCell *cell=(TeacherCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
        
                EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
                NSString *strCurrentTime = [objEYL_AppData getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
                [cell.outBtn setTitle:[@"OUT" stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
                cell.inBtn.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
                cell.outBtn.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
    }
     [self.PinRegistryPopOver dismissPopoverAnimated:YES];
    
}
-(void)cancelBtnAction:(UIButton *)button
{
    [self.PinRegistryPopOver dismissPopoverAnimated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
if(alertView.tag==0)
{

    
}
    else
    {
//        TeacherCell *cell=(TeacherCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
//        
//        EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
//        NSString *strCurrentTime = [objEYL_AppData getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
//        [cell.outBtn setTitle:[@"OUT" stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
//        cell.inBtn.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
//        cell.outBtn.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
   
    }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        static NSString *cellID = @"TeacherCellID";
        TeacherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.delegate=self;
        cell.indepath=indexPath;
        [cell.inBtn setTag:0];
        [cell.outBtn setTag:1];
        cell.inBtn.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
        cell.outBtn.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
        
        [cell.passwordTextField setDelegate:self];
        [cell.passwordView setHidden:YES];
        cell.passwordTextField.tag = indexPath.row;
        [cell.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginButton.tag = indexPath.row;
        
        Practitioners * practitionerObject=[practitionerListForTableView objectAtIndex:indexPath.row];
        NSError *error = nil;
        practitionerObject = (Practitioners *)[[AppDelegate context] existingObjectWithID:practitionerObject.objectID error:&error];
        cell.titleLabel.text=[NSString stringWithFormat:@"%@ %@",practitionerObject.firstName, practitionerObject.lastName];
        if ([practitionerObject.userRole isEqualToString:@"nursery_manager"]) {
            cell.detaillabel.text = @"Manager";
        }
        else if ([practitionerObject.userRole isEqualToString:@"practitioner"]){
            cell.detaillabel.text = practitionerObject.groupName;
        }
        else {
            cell.detaillabel.text = @"No Group Assign";
        }
        
         cell.imageView.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
         cell.imageView.showActivityIndicator=YES;        
        
            NSString *filePath = [[Utils getPractionerImages] stringByAppendingPathComponent:practitionerObject.photo];
            UIImage *practitionerImage=[UIImage imageWithContentsOfFile:filePath];
        
        if(practitionerImage == nil)
        {
            
            cell.imageView.image=nil;
            UIActivityIndicatorView *view=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            view.center = CGPointMake(cell.imageView.bounds.size.width/2.0, cell.imageView.bounds.size.height / 2.0);
            // view.center=cell.childImage.center;
            [view startAnimating];
            
            if(cell.imageView.subviews.count==0)
            {
                [cell.imageView addSubview:view];
            }
            else
            {
                for (id object in cell.imageView.subviews) {
                    if ([object isKindOfClass:[UIActivityIndicatorView class]]) {
                        
                    }
                    else
                    {
                        [cell.imageView addSubview:view];
                    }
                }
            }
        }
        else
        {
            
            for(UIActivityIndicatorView *view in cell.imageView.subviews)
            {
                [view stopAnimating];
                
            }
                cell.imageView.image=practitionerImage;
                if (cell.imageView.bounds.size.width > practitionerImage.size.width && cell.imageView.bounds.size.height > practitionerImage.size.height) {
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
                if(cell.imageView.bounds.size.width < practitionerImage.size.width)
                {
                    
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
        }
        

        return cell;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Catch %@",exception);
    }
}


- (void)collectionViewDidRefreshed:(UIRefreshControl *)sender
{
    //    if ([[NSFileManager defaultManager] removeItemAtPath:[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff.zip"] error:nil]) {
    //        if ([[NSFileManager defaultManager] removeItemAtPath:[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff"] error:nil]) {
    //            [self getTeacherImage];
    //            [self refreshPractitioners];
    //        }
    //    }
    
    if ([Utils checkNetwork]) {
       // [self getTeacherImage];
        [self refreshPractitioners];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [refresControl endRefreshing];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     vc= [self.storyboard instantiateViewControllerWithIdentifier:kPopOverSegueID];
    Practitioners * practitionerObject=[practitionerListForTableView objectAtIndex:indexPath.row];
    vc.prectitioner = practitionerObject;
    vc.delegate = self;
    _pinPopoverController = [[WYPopoverController alloc] initWithContentViewController:vc];
    _pinPopoverController.delegate=self;
    
    [_pinPopoverController setPopoverContentSize:CGSizeMake(400, 200)];
    [_pinPopoverController presentPopoverAsDialogAnimated:YES];
      return;
    TeacherCell *cell = (TeacherCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.passwordView.isHidden == FALSE) {
        return;
    }
    [currentTextField resignFirstResponder];
    [cell.passwordView setHidden:NO];
    //    [currentTextField setText:@""];
    lastPathIndex=indexPath;
    [cell.passwordTextField becomeFirstResponder];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self resetCellWithIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGSize mElementSize = CGSizeMake(185, 185);
        return mElementSize;
    }
    else
    {
        CGSize mElementSize = CGSizeMake(198, 198);
        return mElementSize;
    }
}

-(void)resetCellWithIndexPath:(NSIndexPath *)indexPath
{
    TeacherCell *lastCell = (TeacherCell *)[self.collectionView cellForItemAtIndexPath:lastPathIndex];
    lastCell.passwordTextField.text = @"";
    [lastCell.passwordView setHidden:YES];
    [lastCell.passwordTextField resignFirstResponder];
}

#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.versionLabel setNeedsUpdateConstraints];
    
    [self.popover dismissPopoverAnimated:YES];
    [currentTextField resignFirstResponder];
    [self.collectionView reloadData];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}


#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popoverViewController = nil;
    _pinPopoverController=nil;
    vc=nil;
    self.popover=nil;
    
    
    
}
- (void)dismissPopoverAnimated:(BOOL)animated
{


}

- (IBAction)togglePopover:(UIButton *)sender
{
    if (!self.popover)
    {
        self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
        self.popoverViewController.delegate = self;
        self.popoverViewController.cellType=KCellTypeGroup;
        
        
    }
    
    self.popoverViewController.dataArray=[tempPractitionerArray mutableCopy];
    _popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];
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
    self.popover.theme.arrowBase = 10.0f;
    self.popover.theme.arrowHeight = 10.0f;
    self.popover.theme.outerShadowBlurRadius = 5.0f;
    self.popover.theme.outerCornerRadius = 0.0f;
    self.popover.theme.minOuterCornerRadius = 0.0f;
    self.popover.theme.innerShadowBlurRadius = 0.0f;
    self.popover.theme.innerCornerRadius = 0.0f;
    self.popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.wantsDefaultContentAppearance = NO;
    int height=0;
       
    for(int i=0;i<tempPractitionerArray.count;i++)
    {
        height=height+45;
        
    }
    if(height>self.view.frame.size.height/2)
    {
        height=self.view.frame.size.height/2;
        self.popoverViewController.tableView.scrollEnabled=YES;

    }
    else
    {
        self.popoverViewController.tableView.scrollEnabled=NO;

    }
    
    self.popover.popoverContentSize = CGSizeMake(230, height);
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.arrowBase = 20;
      CGRect rect = sender.frame;
    rect.origin.y += 35;
    rect.origin.x += 70;
    [self resetCellWithIndexPath:lastPathIndex];
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}


#pragma mark - GroupSelectionDelegate
- (void)groupDidSelected:(NSString *)group withCellType:(NSString *)cellType
{
    if ([group caseInsensitiveCompare:@"Update Settings"]==NSOrderedSame) {
        NSLog(@"Update settings called");
        [self getSettings];
        
    }else{
        if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
        {
            practitionerListForTableView=[practitionerList copy];
        }
        else if([tempPractitionerArray containsObject:group])
        {
            practitionerListForTableView=[sortedPractitionerDictionary objectForKey:group];
        }
        [self.groupSelectionButton setTitle:group forState:UIControlStateNormal];
    }
    [self.collectionView reloadData];
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        currentTextField = textField;
    }];
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [currentTextField resignFirstResponder];
    currentTextField = nil;
    if(textField.tag==11)
    {
        if([textField.text isEqualToString:@""])
            [self groupDidSelected:self.groupSelectionButton.titleLabel.text withCellType:KCellTypeGroup];
        else
            [self searchPractitioner:textField.text];
    }
    else
    {
        @try
        {
            
            [self resetCellWithIndexPath:lastPathIndex];
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception occured%@",exception);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([textField isEqual:self.groupSearchView.searchBar] == FALSE) {
        [APICallManager sharedNetworkSingleton].cachePractitioners=[practitionerListForTableView objectAtIndex:lastPathIndex.row];
        if([[APICallManager sharedNetworkSingleton].cachePractitioners.pin isEqualToString:[currentTextField.text sha256]]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            ChilderenViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChilderenViewController"];
            self.navigationController.navigationBar.hidden=YES;
            for(UIView *view in self.view.subviews)
            {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
            
            }
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            
            // UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            //            hud.mode = MBProgressHUDModeText;
            //            hud.labelText = @"Please check and re-enter your PIN";
            //            hud.margin = 10.f;
            //            hud.removeFromSuperViewOnHide = YES;
            //            hud.delegate =self;
            //            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation ==                                                   UIInterfaceOrientationLandscapeRight)
            //            {
            //                hud.yOffset=280;
            //            }
            //            else
            //            {
            //                hud.yOffset=400;
            //            }
            //            [hud hide:YES afterDelay:1];
            AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [app.window makeToast:@"Incorrect Pin" duration:1.0f position:CSToastPositionTop];
         //Please check and re-enter your PIN
        }
    }else{
        [self searchPractitioner:textField.text];
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==1 && [string isEqualToString:@" "])
    {
        [self groupDidSelected:self.groupSelectionButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    
    
    
    return YES;
}

-(void)searchPractitioner:(NSString *)practitionerString
{
    NSString *searchString = [practitionerString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchString.length <= 0) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchString];
    
    NSArray *currentGroup;
    NSString *group=self.groupSelectionButton.titleLabel.text;
    if([group caseInsensitiveCompare:@"All Groups"]==NSOrderedSame)
    {
        currentGroup=[practitionerList copy];
    }
    else if([tempPractitionerArray containsObject:group])
    {
        currentGroup=[sortedPractitionerDictionary objectForKey:group];
    }
    
    NSArray *filteredArray = [currentGroup filteredArrayUsingPredicate:predicate];
    practitionerListForTableView=[filteredArray mutableCopy];
    [self.collectionView reloadData];
}


-(NSMutableDictionary *)sortPractitionerDB:(NSArray *)practitionerArray
{
    tempPractitionerArray=[[NSMutableArray alloc]init];
    [tempPractitionerArray addObject:@"All Groups"];
    NSMutableDictionary *practitionerDict=[[NSMutableDictionary alloc]init];
    for (int count=1; count<practitionerArray.count; count++)
    {
        Practitioners *practitioner=[practitionerArray objectAtIndex:count];
        if([practitionerDict objectForKey:practitioner.groupName] == nil && ![practitioner.groupName isEqualToString:@""])
        {
            @try
            {
                NSMutableArray *array = [NSMutableArray arrayWithObject:practitioner];
                [practitionerDict setObject:array forKey:practitioner.groupName];
                [tempPractitionerArray addObject:practitioner.groupName];
            }
            @catch (NSException *exception)
            {
                NSLog(@"EXCEPTION IS %@",exception);
            }
        }else{
            NSMutableArray *temp = [practitionerDict objectForKey:practitioner.groupName];
            [temp addObject:practitioner];
        }
    }
    self.popoverViewController.dataArray=[tempPractitionerArray mutableCopy];
    return [practitionerDict mutableCopy];
    
}

#pragma mark - KeyboardHandling

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
    CGRect frame = self.collectionView.frame;
    frame.size.height -= height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.frame = frame;
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
    CGRect frame = self.collectionView.frame;
    frame.size.height += height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.frame = frame;
    }];
}

#pragma mark - JSONFetchDataServices

-(void)getleuvenScaleWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
    NSString *serverURL= [APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/framework/leuven_scale",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",
                             [manager apiPassword], @"api_password",
                             nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession] dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"LeuvenScale JSON : %@",jsonDict);
                                              
                                              if (jsonDict == nil) {
                                                  [self getleuvenScaleWithCompletion:^(BOOL success) {
                                                      return ;
                                                  }];
                                                  
                                              }
                                              
                                              NSArray *jsonArray=[jsonDict objectForKey:@"leuven_scale"];
                                              if (!([LeuvenScale fetchAllLeuvenScaleInContext:[AppDelegate context]].count > 0 ))
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *leuvenScaleDict, NSUInteger idx, BOOL *stop)
                                                       {
                                                           LSBaseClass *leuvenScaleBaseObject=[[LSBaseClass alloc]initWithDictionary:leuvenScaleDict];
                                                           [LeuvenScale createPractitionersInContext:[AppDelegate context] withLeuvenScaleType:leuvenScaleBaseObject.leuvenScaleType withScale:[NSNumber numberWithInteger:[leuvenScaleBaseObject.scale integerValue]] withSignals:leuvenScaleBaseObject.signals];
                                                       }];
                                                  });
                                              }
                                              
                                              //[self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                              
                                              NSLog(@"Loaded Leuven Framework");
                                               completion(YES);
                                              //[self getMontessory];
                                          }];
    [postDataTask resume];
            
           
        });
    });

}



    
            

- (void)getMontessoryWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
    NSString *serverUrl = [APICallManager sharedNetworkSingleton].serverURL;
    NSString *urlString = [NSString stringWithFormat:@"%@api/framework/montessori",serverUrl];
    NSDictionary *mapData = [[NSDictionary alloc]initWithObjectsAndKeys:[manager apiKey],@"api_key",[manager apiPassword],@"api_password", nil];
    NSURLSessionDataTask *postDataTask = [[manager getSession]dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString]completionHandler:^(NSData *data , NSURLResponse *response ,NSError *error){
        if(error){
            NSLog(@"%@",error.localizedDescription);
        }
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Montessory : %@ ",jsonDict);
        if(jsonDict == nil){
            [self getMontessoryWithCompletion:^(BOOL success) {
                return ;
            }];
            
        }
        if(!([MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withFramework:kFrameworkMontessori].count > 0)){
            MontessoryBaseClass *montBaseClassObject = [[MontessoryBaseClass alloc]initWithDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (montBaseClassObject.assessment.count>1) {
                    [montBaseClassObject.assessment enumerateObjectsUsingBlock:^(MontessoryAssesment *assesment ,NSUInteger idx,BOOL *stop){
                        [MontessoriAssesmentDataBase createMontessoriAssessmentInContext:[AppDelegate context] withLevelId:[NSNumber numberWithDouble:assesment.levelID] withLevelDescription:assesment.levelDescription withColor:assesment.color];
                    }];
                    
                }
                
                [montBaseClassObject.level1 enumerateObjectsUsingBlock:^(MontesdsoryLevel *obj ,NSUInteger idx,BOOL *stop){
                    [MontessoriFramework createMotessoriFrameworkInContext:[AppDelegate context] withLevelIdentifier:[NSNumber numberWithDouble:[obj levelIdentifier]] withFrameworkType:@"Montessori" withLevelDescription:obj.levelDescription withLevelGroup:obj.levelGroup];
                    
                    [obj.levelItem enumerateObjectsUsingBlock:^(MontessoryLevel2 *levelTwoObj , NSUInteger idx , BOOL *stop){
                        [LevelTwo createLevelTwoInContext:[AppDelegate context ] withLevelTwoIdentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier] withLevelOneIdentifier:[NSNumber numberWithDouble:obj.levelIdentifier] withlevelTwoGroup:levelTwoObj.secondLevelGroup withlevelTwoDescription:levelTwoObj.secondLevelDescription withFrameWorkType:@"Montessori"];
                        
                        [levelTwoObj.secondLevelItem enumerateObjectsUsingBlock:^(MontesoryLevel3 *levelThreeObj,NSUInteger idx ,BOOL *stop){
                            [LevelThree createLevelThreeInContext:[AppDelegate context] withLevelThreeIdentifier:[NSNumber numberWithDouble:levelThreeObj.thirdLevelIdentifier] withLevelTwoIdentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier]withlevelThreeGroup:levelThreeObj.thirdLevelGroup withlevelThreeDescription:levelThreeObj.thirdLevelDescription withFrameWorkType:NSStringFromClass([Montessori class])];
                            
                            [levelThreeObj.thirdLevelItem enumerateObjectsUsingBlock:^(MontessoryLevel4 *levelFourObj ,NSUInteger idx ,BOOL *stop){
                                
                                [LevelFour createLevelFourInContext:[AppDelegate context] withLevelTwoidentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier] withFrameworkType:NSStringFromClass([Montessori class]) withLevelFourDescription:levelFourObj.fourthLevelDescription withLevelFourGroup:levelFourObj.fourthLevelGroup withLevelThreeIdentifier:[NSNumber numberWithDouble:levelThreeObj.thirdLevelIdentifier] withLevelFourIdentifier:[NSNumber numberWithDouble:levelFourObj.fourthLevelIdentifier]];
                            }];
                        }];
                        
                    }];
                    
                    
                }];
            });
        }
        
        // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        NSLog(@"Montessory Data Loaded");
        completion(YES);
        
        //[self getEcat];
    }];
    // }
    [postDataTask resume];
            
        });
    });
}
-(void)getEcatWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
    
    
    NSString *serverUrl = [APICallManager sharedNetworkSingleton].serverURL;
    NSString *urlString = [NSString stringWithFormat:@"%@api/framework/ecat",serverUrl];
    NSDictionary *mapData = [[NSDictionary alloc]initWithObjectsAndKeys:[manager apiKey],@"api_key",[manager apiPassword],@"api_password", nil];
    NSURLSessionDataTask *postDataTask = [[manager getSession]dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString]completionHandler:^(NSData *data , NSURLResponse *response ,NSError *error){
        if(error){
            NSLog(@"%@",error.localizedDescription);
        }
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Ecat : %@ ",jsonDict);
        if(jsonDict == nil){
            [self getEcatWithCompletion:^(BOOL success) {
                return ;
            }];
            
        }
        
        if (![EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withFramework:kFrameworkEcat].count>0)
        {
            EcatBaseClass *ecatBaseClassObject=[[EcatBaseClass alloc]initWithDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ecatBaseClassObject.AreaArray enumerateObjectsUsingBlock:^(EcatAreaClass *obj,NSUInteger idx,BOOL *stop){
                    [EcatFramework createEcatFrameworkInContext:[AppDelegate context] withLevelIdentifier:[NSNumber numberWithDouble:[obj levelIdentifier]] withFrameworkType:@"Ecat" withLevelDescription:obj.levelDescription];
                    
                    [obj.levelItem enumerateObjectsUsingBlock:^(EcatAspectClass *aspectObj,NSUInteger idx,BOOL *stop){
                        [EcatAspect createEcatAspectInContext:[AppDelegate context] withLevelTwoIdentifier:[NSNumber numberWithDouble:aspectObj.secondLevelIdentifier] withLevelOneIdentifier:[NSNumber numberWithDouble:obj.levelIdentifier] withlevelTwoDescription:aspectObj.secondLevelDescription withFrameWorkType:NSStringFromClass([Ecat class])];
                        NSLog(@"Check Identifier %@",[NSNumber numberWithDouble:aspectObj.secondLevelIdentifier]);
                        [aspectObj.secondLevelItem enumerateObjectsUsingBlock:^(EcatStatementClass *stateObj,NSUInteger idx,BOOL *stop){
                            
                            [EcatStatement createEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:[NSNumber numberWithDouble:stateObj.thirdLevelIdentifier] withLevelTwoIdentifier:[NSNumber numberWithDouble:aspectObj.secondLevelIdentifier] withlevelThreeDescription:stateObj.thirdLevelDescription withFrameWorkType:NSStringFromClass([Ecat class])];
                        }];
                    }];
                    
                }];
            });
        }
        
        // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        NSLog(@"Ecat Data Loaded");
         completion(YES);
       
              //[self getCFE];
    }];
    
    [postDataTask resume];
           
            
        });
    });

    
}

-(void)getEyfsWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
    NSString *serverURL= [APICallManager sharedNetworkSingleton].serverURL;
    NSString *urlString=[NSString stringWithFormat:@"%@api/framework/eyfs",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",
                             [manager apiPassword], @"api_password",
                             nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession] dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"EYFS JSON : %@",jsonDict);
                                              if (jsonDict == nil) {
                                                  [self getEcatWithCompletion:^(BOOL success) {
                                                      return ;
                                                  }];
                                                 
                                              }
                                              
                                              EYBaseClass *eyfsBaseObject=[[EYBaseClass alloc]initWithDictionary:jsonDict];
                                              if (!([Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:KFrameworkEYFS].count > 0 ))
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [eyfsBaseObject.assessment enumerateObjectsUsingBlock:^(EYAssessment *assessment, NSUInteger idx, BOOL *stop)
                                                       {
                                                           [Assessment createAssessmentInContext:[AppDelegate context] withAgeEnd:[NSNumber numberWithDouble:assessment.ageEnd] withAgeStart:[NSNumber numberWithInteger:assessment.ageStart] withColor:assessment.color withLevelDescription:assessment.levelDescription withLevelId:[NSNumber numberWithDouble:assessment.levelId] withLevelValue:[NSNumber numberWithDouble:assessment.levelValue] withWeightage:[NSNumber numberWithInt:1]];
                                                           
                                                       }];
                                                      
                                                      
                                                      [eyfsBaseObject.area enumerateObjectsUsingBlock:^(EYArea *obj, NSUInteger idx, BOOL *stop)
                                                       {
                                                           
                                                           [Framework createFrameworkInContext:[AppDelegate context] withAreaIdentifier:[NSNumber numberWithDouble:[obj areaIdentifier]]  withFrameworkType:@"EYFS"  withShortDesc:obj.shortDescription withAreaDesc:obj.areaDescription];
                                                           
                                                           
                                                           
                                                           
                                                           [obj.aspect enumerateObjectsUsingBlock:^(EYAspect *aspectObj, NSUInteger idx, BOOL *stop)
                                                            {
                                                                
                                                                
                                                                [Aspect createAspectInContext:[AppDelegate context] withAspectIdentifier:[NSNumber numberWithDouble:aspectObj.aspectIdentifier] withAreaIdentifier:[NSNumber numberWithDouble:obj.areaIdentifier] withAspectDesc:aspectObj.aspectDescription withStatements:@""withFrameworkType:@"EYFS"];
                                                                
                                                                [aspectObj.age enumerateObjectsUsingBlock:^(EYAge *ageObj, NSUInteger idx, BOOL *stop)
                                                                 {
                                                                     
                                                                     [Age createAgeInContext:[AppDelegate context] withAgeIdentifier:[NSNumber numberWithDouble:ageObj.ageIdentifier] withAgeStart:[NSNumber numberWithDouble:ageObj.ageStart] withShortDesc:ageObj.shortDescription withAgeEnd:[NSNumber numberWithDouble:ageObj.ageEnd] withFrameworkType:NSStringFromClass([Eyfs class]) withAgeDesc:ageObj.ageDescription withAspectIdentifier:[NSNumber numberWithDouble:aspectObj.aspectIdentifier]];
                                                                     
                                                                     
                                                                     [ageObj.statement enumerateObjectsUsingBlock:^(EYStatement *statementObj, NSUInteger idx, BOOL *stop)
                                                                      {
                                                                          
                                                                          [Statement createStatementInContext:[AppDelegate context] withAgeIdentifier:[NSNumber numberWithDouble:ageObj.ageIdentifier] withFrameworkType:NSStringFromClass([Eyfs class]) withStatementDesc:statementObj.statementDescription withShortDesc:statementObj.shortDescription withstatementIdentifier:[NSNumber numberWithDouble:statementObj.statementIdentifier] withAspectIdentifier:[NSNumber numberWithInt:0]];
                                                                          
                                                                      }];
                                                                     
                                                                     
                                                                 }];
                                                                
                                                            }];
                                                           
                                                           
                                                           
                                                       }];
                                                  });
                                              }
                                              NSLog(@"Loaded EYFS Framework");
                                                 completion(YES);
                                              
                                              //[self getCoel];
                                          }];
    
    [postDataTask resume];
         
            
            
        });
    });
    

}


- (void)getCoelWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{

    NSString *serverURL= [APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/framework/coel",serverURL];
    NSDictionary *mapData =[[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",[manager apiPassword], @"api_password",nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession] dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (error) {
                                                  NSLog(@"%@",error.localizedDescription);
                                              }
                                              
                                              NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"COEL JSON : %@",jsonDict);
                                              
                                              if (jsonDict == nil) {
                                                  [self getCoelWithCompletion:^(BOOL success) {
                                                    return;
                                                  }];
                                                  
                                              }
                                              
                                              COBaseClass *coelBaseObject=[[COBaseClass alloc]initWithDictionary:jsonDict];
                                              if (!([Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:KFrameworkCOEL].count > 0 ))
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [coelBaseObject.area enumerateObjectsUsingBlock:^(COArea *obj, NSUInteger idx, BOOL *stop)
                                                       {
                                                           
                                                           if([Framework createFrameworkInContext:[AppDelegate context] withAreaIdentifier:[NSNumber numberWithDouble:obj.areaIdentifier] withFrameworkType:KFrameworkCOEL withShortDesc:@"" withAreaDesc:obj.areaDescription])
                                                           {
                                                               NSLog(@"COEL Framework inserted successfully");
                                                           }
                                                           
                                                           
                                                           [obj.aspect enumerateObjectsUsingBlock:^(COAspect *aspectObj, NSUInteger idx, BOOL *stop)
                                                            {
                                                                if(aspectObj.statement.count>0)
                                                                {
                                                                    [Aspect createAspectInContext:[AppDelegate context] withAspectIdentifier:[NSNumber numberWithDouble:aspectObj.aspectIdentifier] withAreaIdentifier:[NSNumber numberWithDouble:obj.areaIdentifier] withAspectDesc:aspectObj.aspectDescription withStatements:@"" withFrameworkType:KFrameworkCOEL];
                                                                    
                                                                    [aspectObj.statement enumerateObjectsUsingBlock:^(COStatement *statement, NSUInteger idx, BOOL *stop)
                                                                     {
                                                                         [Statement createStatementInContext:[AppDelegate context] withAgeIdentifier:[NSNumber numberWithInt:0] withFrameworkType:KFrameworkCOEL withStatementDesc:statement.statementDescription withShortDesc:@"" withstatementIdentifier:[NSNumber numberWithDouble:statement.statementIdentifier] withAspectIdentifier:[NSNumber numberWithDouble:aspectObj.aspectIdentifier]];
                                                                         
                                                                     }];
                                                                }
                                                            }];
                                                       }];
                                                  });
                                              }
                                              NSLog(@"Loaded COEL Framework");
                                              completion(YES);
                                              //[self getleuvenScale];
                                              
                                          }];
            [postDataTask resume];
            
        });
    });
    
    
}
-(void)getCFEWithCompletion:(void (^)(BOOL success))completion

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
    
    NSString *serverURL= [APICallManager sharedNetworkSingleton].serverURL;
    NSString *urlString=[NSString stringWithFormat:@"%@api/framework/scottish",serverURL];
    NSDictionary *mapData =[[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",[manager apiPassword], @"api_password",nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession]dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString]completionHandler:^(NSData *data , NSURLResponse *response ,NSError *error){
        if(error){
            NSLog(@"%@",error.localizedDescription);
        }
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"cfe : %@ ",jsonDict);
        if(jsonDict == nil){
            if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
                [self getCFEWithCompletion:^(BOOL success) {
                    
                }];
            }
            
            return ;
        }
        CfeBaseClass *CfeClassObject = [[CfeBaseClass alloc]initWithDictionary:jsonDict];
        if(!([CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withFramework:KFrameworkCFE].count > 0)){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (CfeClassObject.assessment.count>1) {
                    [CfeClassObject.assessment enumerateObjectsUsingBlock:^(CfeAssesment *assesment ,NSUInteger idx,BOOL *stop){
                        [CfeAssesmentDataBase createCfeAssessmentInContext:[AppDelegate context] withLevelId:[NSNumber numberWithDouble:assesment.levelID] withLevelDescription:assesment.levelDescription withColor:assesment.color];
                    }];
                    
                }
                
                [CfeClassObject.level1 enumerateObjectsUsingBlock:^(CfeLevel *obj ,NSUInteger idx,BOOL *stop){
                    [CfeFramework createCfeFrameworkInContext:[AppDelegate context] withLevelIdentifier:[NSNumber numberWithDouble:[obj levelIdentifier]] withFrameworkType:@"Cfe" withLevelDescription:obj.levelDescription withLevelGroup:obj.levelGroup];
                    
                    [obj.levelItem enumerateObjectsUsingBlock:^(CfeLevel2 *levelTwoObj , NSUInteger idx , BOOL *stop){
                        [CfeLevelTwo createCfeLevelTwoInContext:[AppDelegate context ] withLevelTwoIdentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier] withLevelOneIdentifier:[NSNumber numberWithDouble:obj.levelIdentifier] withlevelTwoGroup:levelTwoObj.secondLevelGroup withlevelTwoDescription:levelTwoObj.secondLevelDescription withFrameWorkType:@"Cfe"];
                        if([levelTwoObj.secondLevelDescription isEqualToString:@"Classifications"])
                        {
                            NSLog(@"Found");
                            
                        }
                        
                        [levelTwoObj.secondLevelItem enumerateObjectsUsingBlock:^(CfeLevel3 *levelThreeObj,NSUInteger idx ,BOOL *stop){
                            [CfeLevelThree createCfeLevelThreeInContext:[AppDelegate context] withLevelThreeIdentifier:[NSNumber numberWithDouble:levelThreeObj.thirdLevelIdentifier] withLevelTwoIdentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier]withlevelThreeGroup:levelThreeObj.thirdLevelGroup withlevelThreeDescription:levelThreeObj.thirdLevelDescription withFrameWorkType:NSStringFromClass([Cfe class])];
                            
                            [levelThreeObj.thirdLevelItem enumerateObjectsUsingBlock:^(CfeLevel4 *levelFourObj ,NSUInteger idx ,BOOL *stop){
                                
                                [CfeLevelFour createCfeLevelFourInContext:[AppDelegate context] withLevelTwoidentifier:[NSNumber numberWithDouble:levelTwoObj.secondLevelIdentifier] withFrameworkType:NSStringFromClass([Cfe class]) withLevelFourDescription:levelFourObj.fourthLevelDescription withLevelFourGroup:levelFourObj.fourthLevelGroup withLevelThreeIdentifier:[NSNumber numberWithDouble:levelThreeObj.thirdLevelIdentifier] withLevelFourIdentifier:[NSNumber numberWithDouble:levelFourObj.fourthLevelIdentifier]];
                            }];
                        }];
                        
                    }];
                    
                    
                }];
            });
        }
        
        // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        NSLog(@"CFE Data Loaded");
        completion(YES);

     
        
        //[self getCoel];
        
        // [self getEcat];
    }];
    [postDataTask resume];
                   });
    });

    //[self performSelectorInBackground:@selector(closeAlert) withObject:nil];
}

-(INBaseClass *)getInstallation
{
    UIViewController *topVC = self.navigationController;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hud.labelText=@"Loading..";
    
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/installation",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",
                             [manager apiPassword], @"api_password",
                             nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession] dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  
                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  
                                                  return;
                                              }
                                              
                                              [self backgroundLoadData:data];
                                              
                                              
                                              //  [[APICallManager sharedNetworkSingleton] performSelectorOnMainThread:@selector(getAllChildrenImages) withObject:nil waitUntilDone:YES];
                                              //[self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                              
                                          }];
    
    [postDataTask resume];
    return baseObject;
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}
-(void)closeAlert
{
    UIViewController *topVC = self.navigationController;
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
    
    if(isAllDataLoaded)
    {
    [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
    
    }
    
    if(!isCollectionViewLoaded)
    {
        [self.collectionView reloadData];
        isCollectionViewLoaded=YES;
        
    }
    
}

-(void)refreshPractitioners
{
    [self.groupSearchView.searchBar resignFirstResponder];
    [self.groupSearchView.searchBar setText:[NSString string]];
    [refresControl endRefreshing];
    UIViewController *topVC = self.navigationController;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hud.labelText=@"Loading Practitioner Data...";
    
    //  NSString *serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/staff/lists",serverURL];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password", nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  
                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  return;
                                              }
//                                              NSFileManager *fileManager1 = [NSFileManager defaultManager];
//                                              
//                                              if ([fileManager1 fileExistsAtPath:[Utils getPractionerImages]]) { // Directory exists
//                                                  NSArray *listOfFiles = [fileManager1 contentsOfDirectoryAtPath:[Utils getPractionerImages] error:nil];
//                                                  if(listOfFiles.count>0)
//                                                  {
//                                                      //[self closeAlert];
//                                                  }
//                                              }
                                               [self closeAlert];
                                              [self loadPractitionerData:data];
                                          }];
    
    [postDataTask resume];
    
}

-(void)getTeacherImage
{
    
    
    // serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *urlString=[NSString stringWithFormat:@"%@api/staff/photos",[APICallManager sharedNetworkSingleton].serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                             [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",
                             nil];
    
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (error || data.length <= 0) {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  return ;
                                              }
                                              
                                              NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff.zip"];
                                              NSString *staffFolder=[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff"];
                                              if([data writeToFile:yourArtPath atomically:YES])
                                              {
                                                  [[NSFileManager defaultManager] removeItemAtPath:[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff"] error:nil];
                                                  if([SSZipArchive unzipFileAtPath:yourArtPath toDestination:staffFolder])
                                                  {
                                                      NSLog(@"Successfully unarchived Practitioner Images");
                                                      NSFileManager *fileManager1 = [NSFileManager defaultManager];
                                                      
                                                      if ([fileManager1 fileExistsAtPath:[Utils getPractionerImages]]) { // Directory exists
                                                          NSArray *listOfFiles = [fileManager1 contentsOfDirectoryAtPath:[Utils getPractionerImages] error:nil];
                                                          if(listOfFiles.count>0)
                                                          {
                                                               //[self.collectionView reloadData];
                                                               [self closeAlert];
                                                          }
                                                      }
                                                      
                                                      // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                      
                                                  }
                                                  else
                                                  {
                                                     // [self performSelectorInBackground:@selector(getTeacherImage) withObject:nil];
                                                      NSLog(@"Error while unarchiving Practitioner Images");
                                                  }
                                              }
                                          }];
    
    [postDataTask resume];
    
}

-(void)loadPractitionerData:(NSData *)data
{
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Practitioner Data : %@", jsonDict);
    NSMutableArray *imagesArray=[NSMutableArray new];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: [Utils getPractionerImages]];
    
    for (INData *pract in practitionerList)
        
    {
        
        [imagesArray addObject:pract.photo];
        
    }
    
    
    
    for(NSString *str in directoryContent)
        
    {
        
        
        
        if(![imagesArray containsObject:str])
            
        {
            
            NSString *filePath = [[Utils getPractionerImages] stringByAppendingPathComponent:str]
            
            ;
            
            NSError *error;
            
            BOOL success = [[NSFileManager defaultManager]  removeItemAtPath:filePath error:&error];
            
            if (success) {
                
                
                
            }
            
            else
                
            {
                
                NSLog(@"%@",[error localizedDescription]);
                
            }
            
            
            
        }
        
        
        
    }
    
    if (jsonDict == nil) {
        [self refreshPractitioners];
        return;
    }
    
    practitionerList = [[INPractitioners modelObjectWithDictionary:[jsonDict objectForKey:@"practitioners"]].data mutableCopy];
    
    [self storeDataWithCompletion:^(BOOL success){
        if(success)
        {
       
            for (INData *practitionerData in practitionerList)
            {
                [Practitioners createPractitionersInContext:[AppDelegate context] withFirstName:practitionerData.firstName withGroupId:[NSNumber numberWithInteger:[practitionerData.groupId integerValue]] withGroupLeader:[NSNumber numberWithBool:practitionerData.groupLeader] withGroupName:practitionerData.groupName withLastName:practitionerData.lastName withPhotoName:practitionerData.photo withPin:practitionerData.pin withUserRole:practitionerData.userRole withActive:[NSNumber numberWithDouble:practitionerData.active] withAllowSubmit:[NSNumber numberWithBool:practitionerData.allowSubmit] withEylogUserId:[NSNumber numberWithInteger:[practitionerData.eylogUserId integerValue]] withPhotoUrl:practitionerData.photoUrl];
            }
            
            practitionerListForTableView = [Practitioners fetchALLPractitionersInContext:[AppDelegate context]];
            practitionerList = [practitionerListForTableView mutableCopy];
            [self performSelectorOnMainThread:@selector(setTextOnButton) withObject:nil waitUntilDone:YES];
            sortedPractitionerDictionary=[self sortPractitionerDB:practitionerListForTableView];
           
        }

    }];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [refresControl endRefreshing];
        UIViewController *topVC = self.navigationController;
        [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
        [self saveAllPractitionersPhotosAtBackground];
        
       
    });
   }
- (void)storeDataWithCompletion:(void (^)(BOOL success))completion
{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([Practitioners deletePractitionersInContext:[AppDelegate context]]);
            
            
            
        });
    });
  }

// Calling storeDataWithCompletion...

- (void)setTextOnButton {
    [self.groupSelectionButton setTitle:@"All Groups" forState:UIControlStateNormal];
}

-(void)backgroundLoadData:(NSData *)data
{
    @try
    {
        NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Installation Data : %@", jsonDict);
        
        if (jsonDict == nil) {
            [self getInstallation];
            return;
        }
        NSMutableArray *ethnicityArray=[[jsonDict objectForKey:@"children"] objectForKey:@"ethnicity"];
        
        for (int i=0; i<ethnicityArray.count; i++) {
            NSDictionary *dict=[ethnicityArray objectAtIndex:i];
            
            [Ethnicity createInContext:[AppDelegate context] withethnicityDesc:[dict objectForKey:@"ethnicity"] withethnicityId:[NSNumber numberWithInteger:[[dict objectForKey:@"ethnicity_id"]integerValue]] withparent:[NSNumber numberWithInteger:[[dict objectForKey:@"parent"]integerValue]]withEthnicityChildid:[NSNumber numberWithInteger:[[dict objectForKey:@"ethnicitychildid"] integerValue]]];
            [[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"NewEthnicity"];
            
        }
        baseObject=[[INBaseClass alloc]initWithDictionary:jsonDict];
        
        if([NSKeyedArchiver archiveRootObject:baseObject toFile:[Utils getLabelPath]])
        {
            NSLog(@"Base Object Archived");
        }
        
        [APICallManager sharedNetworkSingleton].baseClass=baseObject;
        practitionerList=[baseObject.practitioners.data mutableCopy];
       
        __block NSMutableDictionary *settingDictionary=[[NSMutableDictionary alloc]init];
        NSMutableArray *mutableArray=[baseObject.settings mutableCopy];

        [mutableArray enumerateObjectsUsingBlock:^(INSettings *setting, NSUInteger idx, BOOL *stop)
         {
             [settingDictionary setObject:setting.value forKey:setting.key];
         }];
        
        if([settingDictionary writeToFile: [Utils getSettingPath] atomically:YES])
        {
            NSLog(@"Setting saved correctly");
            //[[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"UpdateSettings"];
             [[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"UpdateSettingsVersion2.1.0"];
            //UpdateSettingsVersion2.0.2
        }
        
        // By Sumit Sharma
        
        EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
        [objEYL_AppData.array_SegmentControlTitle addObjectsFromArray:[[jsonDict valueForKey:@"diary_fields"] allKeys]];
        
        
        NSString *currentDate = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
        
        for (NSString *str_Key in objEYL_AppData.array_SegmentControlTitle)
        {
            //            if ([str_Key isEqualToString:@"observationfields"])
            //            {
            //                // Ignore this tag from Webservice. Not to save in database
            //            }
            //            else
            //            {
            NSDictionary *dict_Registry = [NSDictionary dictionaryWithObject:[[jsonDict valueForKey:@"diary_fields"] valueForKey:str_Key] forKey:str_Key];
            
            [DiaryEntity createEYL_DiaryEntityContext:[AppDelegate context] withDictionary:dict_Registry forEntityName:str_Key];
            // }
        }
        
        //        NSDictionary *dict_Registry = [NSDictionary dictionaryWithObject:[[jsonDict valueForKey:@"diary_fields"] valueForKey:@"registry"] forKey:@"registry"];
        //
        //
        //        [DiaryEntity createEYL_DiaryEntityContext:[AppDelegate context] withDictionary:dict_Registry forEntityName:@"registry"];
        
        
        
        //        [baseObject.diaryFields.Registry enumerateObjectsUsingBlock:^(INSettings *keyVal,NSUInteger idx,BOOL *stop){
        //            NSLog(@"Priting Registry Key =%@ & Value =%@",keyVal.key,keyVal.value);
        //            [EYL_RegistryModel createEcatInContext:[AppDelegate context] withKey:keyVal.key withValue:keyVal.value];
        //
        //        }];
        //
        //        [baseObject.diaryFields.wha_I_Ate enumerateObjectsUsingBlock:^(INSettings *keyVal,NSUInteger idx,BOOL *stop){
        //            NSLog( @"Printing What I today Kay=%@ and Value=%@",keyVal.key,keyVal.value);
        //            NSLog(@"Print");
        //        }];
        
        
        [Nursery createNurseryInContext:[AppDelegate context] withNurseryChain:[NSNumber numberWithInteger:[baseObject.nurseryChainId integerValue]] withNurseryChainName:baseObject.nurseryChainName withNurseryId:[NSNumber numberWithInteger:[baseObject.nurseryId integerValue]] withNurseryName:baseObject.nurseryName];
        
        
        for (INData *practitionerData in practitionerList)
        {
            [Practitioners createPractitionersInContext:[AppDelegate context] withFirstName:practitionerData.firstName withGroupId:[NSNumber numberWithInteger:[practitionerData.groupId integerValue]] withGroupLeader:[NSNumber numberWithBool:practitionerData.groupLeader] withGroupName:practitionerData.groupName withLastName:practitionerData.lastName withPhotoName:practitionerData.photo withPin:practitionerData.pin withUserRole:practitionerData.userRole withActive:[NSNumber numberWithDouble:practitionerData.active] withAllowSubmit:[NSNumber numberWithBool:practitionerData.allowSubmit] withEylogUserId:[NSNumber numberWithInteger:[practitionerData.eylogUserId integerValue]]withPhotoUrl:practitionerData.photoUrl];
        }
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotoPract"] isEqualToString:@"completed"])
        {
            
            [self saveAllPractitionersPhotosAtBackground];
            
        }
        NSArray *childrens=[baseObject.children.data copy];
        childrenArray=[baseObject.children.data copy];
        NSString *practitionerGroupName=[APICallManager sharedNetworkSingleton].cachePractitioners.groupName;
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        
        for(INData *children in childrens)
        {
            if (!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"dd-MM-yyyy"; //very simple format  "8:47:22 AM"
            }
            
            NSLog(@"Practitioner Id %@",[NSNumber numberWithDouble:children.practitionerId]);
            NSLog(@"Practitioner Id %f",children.practitionerId);
            
            
            NSDate *dob=[dateFormatter dateFromString:children.dob];
            NSDate *startDate=[dateFormatter dateFromString:children.startDate];
            [Child createChildInContext:[AppDelegate context] withChild:[NSNumber numberWithInteger:[children.childId integerValue]] withDietaryRequirment:children.dietaryRequirments withDob:dob withEnglishAdditionalLanguage:[NSNumber numberWithBool:children.englishAdditionalLanguage] withEthnicity:[NSNumber numberWithInteger:[children.ethnicity integerValue]] withFirstName:children.firstName withGender:children.gender withGroupId:[NSNumber numberWithInteger:[children.groupId integerValue]] withGroupName:children.groupName withLanguage:children.language withLastName:children.lastName withMiddleName:children.middleName withNationality:children.nationality withPractitionerId:[NSNumber numberWithDouble:children.practitionerId] withReligion:children.religion withShareTwoYearReport:[NSNumber numberWithBool:children.shareTwoYearReport] withSLt:[NSNumber numberWithBool:children.slt] withSpecialEductionalNeeds:[NSNumber numberWithBool:children.specialEducationalNeeds] withStartDate:startDate withPhoto:children.photo withTwoYearFunding:[NSNumber numberWithBool:children.twoYearFunding] withAgeMonths:children.ageMonths withInTime:@"00:00" withOutTime:@"00:00" withCurrentDate:currentDate registryArray:[NSData new] pupilPremium:[NSNumber numberWithBool:children.pupilPremium]withphotoUrl:children.photoUrl];
        }
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GridViewController *grid=[storyboard instantiateViewControllerWithIdentifier:@"gridViewControllerID"];
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotoChild"] isEqualToString:@"completed"])
            {
                [grid saveAllChildrenPhotosAtBackground];
        
            }

        
        
        practitionerList=[[Practitioners fetchALLPractitionersInContext:[AppDelegate context]] mutableCopy];
        if(practitionerList.count>0)
        {
            practitionerListForTableView=[practitionerList copy];
            // [self.collectionView reloadData];
            sortedPractitionerDictionary=[self sortPractitionerDB:practitionerList];
            
//            if(![fileManager fileExistsAtPath:[Utils getPractionerImages]])
//            {
//                [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
//            }
//            
            [APICallManager sharedNetworkSingleton].settingObject=[[Setting alloc]initWithSettingDictionary:[NSDictionary dictionaryWithContentsOfFile:[Utils getSettingPath]]];
            
        }
        if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:@"practitioner"] == NSOrderedSame) {
            
            if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
            {
                [APICallManager sharedNetworkSingleton].childArray=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
            }
            else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
            {
                [APICallManager sharedNetworkSingleton].childArray=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:practitionerGroupName] mutableCopy];
            }
            else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
            {
                [APICallManager sharedNetworkSingleton].childArray=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
            }
        }
        else{
            [APICallManager sharedNetworkSingleton].childArray=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
            
        }
        if( [APICallManager sharedNetworkSingleton].childArray.count==0)
        {
            [APICallManager sharedNetworkSingleton].childArray=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
        }
        [[APICallManager sharedNetworkSingleton] getRegistryINOUTTime];
        [self showNurseryName];
        
        
        dispatch_group_t group = dispatch_group_create();
        
//        dispatch_group_enter(group);
//        [self getAllChildrenImagesWithCompletion:^(BOOL success) {
//            dispatch_group_leave(group);
//            
//        }];
        if([APICallManager sharedNetworkSingleton].settingObject.coel)
        {
            dispatch_group_enter(group);
            [self getCoelWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
                
            }];
        }
        if([APICallManager sharedNetworkSingleton].settingObject.ecat)
        {
            dispatch_group_enter(group);
            [self getEcatWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
                
            }];
        }
        if([APICallManager sharedNetworkSingleton].settingObject.montessori)
        {
            dispatch_group_enter(group);
            [self getMontessoryWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
            }];
        }
        if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
        {
            dispatch_group_enter(group);
            [self getleuvenScaleWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
                
            }];
        }
        if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
        {
            dispatch_group_enter(group);
            [self getEyfsWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
                
            }];
        }
        else
        {
            dispatch_group_enter(group);
            [self getCFEWithCompletion:^(BOOL success) {
                dispatch_group_leave(group);
                
            }];
        }
        
    
//        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *topVC = self.navigationController;
                [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
                [self.collectionView reloadData];
                
            });
            
            
        });
        
        

        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Catched %@",exception);
    }
}
- (void)getAllChildrenImagesWithCompletion:(void (^)(BOOL success))completion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSString *urlString=[NSString stringWithFormat:@"%@api/children/photos",[APICallManager sharedNetworkSingleton].serverURL];
            NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                     [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",
                                     nil];
            
            NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                  {
                                                      if (error || data.length <= 0) {
                                                          return ;
                                                      }
                                                      NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Children.zip"];
                                                      NSString *childrenFolder=[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Children"];
                                                      
                                                      if([data writeToFile:yourArtPath atomically:YES])
                                                      {
                                                          [[NSFileManager defaultManager] removeItemAtPath:[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Children"] error:nil];
                                                          
                                                          if([SSZipArchive unzipFileAtPath:yourArtPath toDestination:childrenFolder])
                                                          {
                                                              NSLog(@"Successfully unarchived Children Images");
                                                              completion(YES);
                                                              
                                                              dispatch_sync(dispatch_get_main_queue(), ^{
                                                                 
                                                                  //                                                          [self.collectionViewController reloadData];
                                                                  //                                                          [self.tableView reloadData];
                                                                  
                                                              });
                                                              // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                          }
                                                          else
                                                          {
                                                              //  [self performSelectorInBackground:@selector(getChildrenImages) withObject:nil];
                                                              NSLog(@"Error while unarchiving Children Images");
                                                              completion(YES);
                                                          }
                                                      }
                                                  }];
            [postDataTask resume];

        });
    });
    
    
    //  serverURL=@"https://demo.eylog.co.uk/trunk/";
   }

-(void)showNurseryName
{
    if([fileManager fileExistsAtPath:[Utils getLabelPath]])
    {
        INBaseClass * inBaseClass = (INBaseClass *)[NSKeyedUnarchiver unarchiveObjectWithFile:[Utils getLabelPath]];
        [APICallManager sharedNetworkSingleton].baseClass = inBaseClass;
        nurseryNameLabel.text = inBaseClass.nurseryName;
        self.lblnurseryChainName.text = inBaseClass.nurseryChainName;
    }
}


-(void)startTimer
{
    UIViewController *topVC = self.navigationController;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hud.labelText=@"Please wait, downloading practitioner images..";
    
    timer=[NSTimer scheduledTimerWithTimeInterval:3.00
                                           target:self
                                         selector:@selector(targetMethod)
                                         userInfo:nil
                                          repeats:YES];
}
-(void)targetMethod
{
    if([fileManager fileExistsAtPath:[Utils getPractionerImages]])
    {
        UIViewController *topVC = self.navigationController;
        [MBProgressHUD hideHUDForView:topVC.view animated:YES];
        [timer invalidate];
        [self.collectionView reloadData];
        if(!isCollectionViewLoaded)
        {
            isCollectionViewLoaded=YES;
        }
    }
}


- (IBAction)updateAction:(id)sender
{
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    //    ChilderenViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChilderenViewController"];
    //    [self.navigationController pushViewController:controller animated:YES];
}

- (void)proceedWithPrectitioner:(Practitioners *)practitioner
{
    [self loadNotificationsHistory:practitioner];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText=@"Correct Pin Entered,Logging In...";
    hud.margin = 10.f;
    hud.delegate =self;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        hud.yOffset=280;
    }
    else
    {
        hud.yOffset=400;
    }
    
    hud.yOffset=300;
    [hud hide:YES afterDelay:1];
    
    [_pinPopoverController dismissPopoverAnimated:YES completion:^{
        [APICallManager sharedNetworkSingleton].cachePractitioners = practitioner;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        ChilderenViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChilderenViewController"];
        self.navigationController.navigationBar.hidden=YES;
        controller.randNumber=[NSString stringWithFormat:@"%d",arc4random_uniform(512)];
        for(UIView *view in self.view.subviews)
        {
            if([view isKindOfClass:[MBProgressHUD class]])
            {
                MBProgressHUD *hud=(MBProgressHUD *)view;
                [hud removeFromSuperview];
                hud=nil;
                
            }
        }
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
}

// Update Settings Methods

- (void)updateSettings:(UIButton *)sender
{
    if (!self.popover)
    {
        self.popoverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
        self.popoverViewController.delegate = self;
        self.popoverViewController.cellType=KCellTypeGroup;
        
        
    }
    self.popoverViewController.dataArray=[NSArray arrayWithObjects:@"Update Settings", nil];
    _popover = [[WYPopoverController alloc] initWithContentViewController:self.popoverViewController];
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
    self.popover.theme.arrowBase = 10.0f;
    self.popover.theme.arrowHeight = 10.0f;
    self.popover.theme.outerShadowBlurRadius = 5.0f;
    self.popover.theme.outerCornerRadius = 0.0f;
    self.popover.theme.minOuterCornerRadius = 0.0f;
    self.popover.theme.innerShadowBlurRadius = 0.0f;
    self.popover.theme.innerCornerRadius = 0.0f;
    self.popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popover.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.wantsDefaultContentAppearance = NO;
    self.popover.popoverContentSize = CGSizeMake(130, 50);
    self.popover.theme.arrowHeight = 0.0f;
    self.popover.theme.arrowBase = 20;
    self.popoverViewController.tableView.scrollEnabled=YES;
      
    CGRect rect =self.navigationItem.rightBarButtonItem.customView.frame ;
    rect.origin.y +=self.navigationController.navigationBar.frame.size.height+20;
    rect.origin.x +=self.navigationItem.rightBarButtonItem.customView.frame.size.width;
    [self resetCellWithIndexPath:lastPathIndex];
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}



-(void)getSettings
{
    UIViewController *topVC = self.navigationController;
    AppDelegate *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hud.labelText=@"Updating Settings..";
    
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/installation",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [manager apiKey],@"api_key",
                             [manager apiPassword], @"api_password",
                             nil];
    
    NSURLSessionDataTask *postDataTask = [[manager getSession] dataTaskWithRequest:[manager getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  
                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  
                                                  return;
                                              }
                                              [self parseSettingsData:data];
                                              //[self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                              
                                          }];
    [postDataTask resume];
}
- (void)storeSettingsWithCompletion:(void (^)(BOOL success))completion
{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
         dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([DiaryEntity deleteInContext:[AppDelegate context]]);
           
            
            
        });
    });

}
- (void)storeEthnicityWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        completion([Ethnicity deleteAllHistoryRecords:[AppDelegate context]]);
            
            
            
        });
    });

   }
-(void)parseSettingsData:(NSData *)data
{
    @try
    {
        NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Installation Data : %@", jsonDict);
        
        if (jsonDict == nil) {
            [self getInstallation];
            return;
        }
        
        [self storeEthnicityWithCompletion:^(BOOL success){
            
            if(success)
            {
        if([Ethnicity fetchAllRecords:[AppDelegate context]].count==0)
        {
            
            NSMutableArray *ethnicityArray=[[jsonDict objectForKey:@"children"] objectForKey:@"ethnicity"];
            
            for (int i=0; i<ethnicityArray.count; i++) {
                NSDictionary *dict=[ethnicityArray objectAtIndex:i];
                
                [Ethnicity createInContext:[AppDelegate context] withethnicityDesc:[dict objectForKey:@"ethnicity"] withethnicityId:[NSNumber numberWithInteger:[[dict objectForKey:@"ethnicity_id"]integerValue]] withparent:[NSNumber numberWithInteger:[[dict objectForKey:@"parent"]integerValue]]withEthnicityChildid:[NSNumber numberWithInteger:[[dict objectForKey:@"ethnicitychildid"] integerValue]]];
                [[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"NewEthnicity"];
                
                
            }
        }
            }
              }];
        
        baseObject=[[INBaseClass alloc]initWithDictionary:jsonDict];
        
        if([NSKeyedArchiver archiveRootObject:baseObject toFile:[Utils getLabelPath]])
        {
            NSLog(@"Base Object Archived");
        }
        //settingObject.elg
        [APICallManager sharedNetworkSingleton].baseClass=baseObject;
        practitionerList=[baseObject.practitioners.data mutableCopy];
        __block NSMutableDictionary *settingDictionary=[[NSMutableDictionary alloc]init];
        NSMutableArray *mutableArray=[baseObject.settings mutableCopy];
        [mutableArray enumerateObjectsUsingBlock:^(INSettings *setting, NSUInteger idx, BOOL *stop)
         {
             [settingDictionary setObject:setting.value forKey:setting.key];
         }];
        
        if([settingDictionary writeToFile: [Utils getSettingPath] atomically:YES])
        {
            NSLog(@"Setting saved correctly");
            
            [[NSUserDefaults standardUserDefaults] setObject:@"updated" forKey:@"UpdateSettingsVersion2.1.0"];
            
        }
        
        
        [APICallManager sharedNetworkSingleton].settingObject=[[Setting alloc]initWithSettingDictionary:[NSDictionary dictionaryWithContentsOfFile:[Utils getSettingPath]]];
        
        
        if([APICallManager sharedNetworkSingleton].settingObject.dailyDiary==1)
        {
             [self storeSettingsWithCompletion:^(BOOL success){
                 if(success)
                 {
                     
                     
                     if([DiaryEntity fetchAllRecords:[AppDelegate context]].count==0)
                         
                     {
                         EYL_AppData *objEYL_AppData = [EYL_AppData sharedEYL_AppData];
                         [objEYL_AppData.array_SegmentControlTitle removeAllObjects];
                         [objEYL_AppData.array_SegmentControlTitle addObjectsFromArray:[[jsonDict valueForKey:@"diary_fields"] allKeys]];
                         [objEYL_AppData.array_WhatIateTodayStatic removeAllObjects];
                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"array_WhatIateTodayStatic"];
                         [objEYL_AppData.array_WhatIateToday removeAllObjects];
                         [objEYL_AppData.array_Comments removeAllObjects];
                         [objEYL_AppData.array_IHadMyBottle removeAllObjects];
                         [objEYL_AppData.array_nappiesRash  removeAllObjects];
                         [objEYL_AppData.array_Notes removeAllObjects];
                         [objEYL_AppData.array_Registry removeAllObjects];
                         [objEYL_AppData.array_SleepTimes removeAllObjects];
                         [objEYL_AppData.array_Toileting removeAllObjects];
                         [objEYL_AppData.array_Notes removeAllObjects];
                         [objEYL_AppData.array_Observations removeAllObjects];
                         
                         NSString *currentDate = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
                         
                         for (NSString *str_Key in objEYL_AppData.array_SegmentControlTitle)
                         {
                             //                    if ([str_Key isEqualToString:@"observationfields"])
                             //                    {
                             //                        // Ignore this tag from Webservice. Not to save in database
                             //                    }
                             //                    else
                             //                    {
                             NSDictionary *dict_Registry = [NSDictionary dictionaryWithObject:[[jsonDict valueForKey:@"diary_fields"] valueForKey:str_Key] forKey:str_Key];
                             
                             [DiaryEntity createEYL_DiaryEntityContext:[AppDelegate context] withDictionary:dict_Registry forEntityName:str_Key];
                             // }
                         }
                         
                         NSLog(@"Done Now");
                     }
                     
                     
                     dispatch_group_t group = dispatch_group_create();
                     
                     
                     if([APICallManager sharedNetworkSingleton].settingObject.coel)
                     {
                         dispatch_group_enter(group);
                         [self updateCoeLWithCompletion:^(BOOL success) {
                             [self getCoelWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                                 
                             }];
                         }];
                         
                     }
                     if([APICallManager sharedNetworkSingleton].settingObject.ecat)
                     {
                         dispatch_group_enter(group);
                         [self updateEcatWithCompletion:^(BOOL success) {
                             [self getEcatWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                                 
                             }];
                         }];
                         
                     }
                     if([APICallManager sharedNetworkSingleton].settingObject.montessori)
                     {
                         dispatch_group_enter(group);
                         [self updateMontesoryWithCompletion:^(BOOL success) {
                             [self getMontessoryWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                             }];
                         }];
                         
                     }
                     if([APICallManager sharedNetworkSingleton].settingObject.childInvolvement)
                     {
                         dispatch_group_enter(group);
                         [self updateLeuvenScaleWithCompletion:^(BOOL success) {
                             [self getleuvenScaleWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                                 
                             }];
                         }];
                         
                     }
                     if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"eyfs"])
                     {
                         dispatch_group_enter(group);
                         [self updateEYFSWithCompletion:^(BOOL success) {
                             [self getEyfsWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                                 
                             }];
                         }];
                         
                     }
                     else
                     {
                         dispatch_group_enter(group);
                         
                         [self updateCFEWithCompletion:^(BOOL success) {
                             [self getCFEWithCompletion:^(BOOL success) {
                                 dispatch_group_leave(group);
                                 
                             }];
                         }];
                         
                         
                     }
                     
                     
                     //
                     dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UIViewController *topVC = self.navigationController;
                             [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
                         });
                         
                         
                     });
                     
                     
                 }
             }];

             
            
        }
        
        
        UIViewController *topVC = self.navigationController;
        [MBProgressHUD hideAllHUDsForView:topVC.view animated:YES];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Catched %@",exception);
        [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
        
    }
    
    // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
}

- (void)updateCoeLWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion([Framework deleteAllHistoryRecords:[AppDelegate context]withFrameWork:KFrameworkCOEL]&&[Statement deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCOEL]&&[Aspect deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCOEL]);
            
                       
        });
    });
    
}
- (void)updateEYFSWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        completion([Framework deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkEYFS] &&[Eyfs deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkEYFS] &&[Age deleteAllHistoryRecords:[AppDelegate context] withFrameWork:@"Eyfs"]&&[Aspect deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkEYFS]&&[Statement deleteAllHistoryRecords:[AppDelegate context] withFrameWork:@"Eyfs"]&&[Assessment deleteAllHistoryRecords:[AppDelegate context]]);
            
            
            
        });
    });
    
}
- (void)updateCFEWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([CfeFramework deleteAllHistoryRecords:[AppDelegate context]withFrameWork:KFrameworkCFE]&&[Cfe deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]&&[CfeAssesmentDataBase deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]&&[CfeLevelOne deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]&&[CfeLevelTwo deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]&&[CfeLevelThree deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]&&[CfeLevelFour deleteAllHistoryRecords:[AppDelegate context] withFrameWork:KFrameworkCFE]);
            
            
            
        });
    });
    
}
- (void)updateMontesoryWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([MontessoriFramework deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkMontessori]&&[LevelFour deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkMontessori]&&[LevelThree deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkMontessori]&&[LevelTwo deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkMontessori]&&[LevelOne deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkMontessori]);
            
            
            
        });
    });
    
}
- (void)updateLeuvenScaleWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([LeuvenScale deleteAllHistoryRecords:[AppDelegate context]]);
            
            
            
        });
    });
    
}
- (void)updateEcatWithCompletion:(void (^)(BOOL success))completion

{
    // Store Data Processing...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([EcatFramework deleteAllHistoryRecords:[AppDelegate context]withFrameWork:kFrameworkEcat]&&[Ecat deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkEcat]&&[EcatArea deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkEcat]&&[EcatAspect deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkEcat]&&[EcatStatement deleteAllHistoryRecords:[AppDelegate context] withFrameWork:kFrameworkEcat]);
            
            
            
        });
    });
    
}
-(void)loadNotificationsHistory :(Practitioners *)practitioner
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        @autoreleasepool {
            
              if ([[APICallManager sharedNetworkSingleton] isNetworkReachable]) {
            NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
            
            NSString *urlString=[NSString stringWithFormat:@"%@api/nurserynotifications",serverURL];
            NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [[APICallManager sharedNetworkSingleton] apiKey],@"api_key",
                                     [[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",@"1",@"page",@"10",@"per_page",nil];
            
            [mapData setObject:practitioner.eylogUserId forKey:@"eylog_user_id"];
                  
            NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                  {
                                                     
                                                      if(error)
                                                      {
                                                          [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                        
                                                          return;
                                                      }
                                                      else
                                                      {
                                                          if(!appDelegate.becameActiveAfterNotication)
                                                          {
                                                              
                                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"batchCount"];
                                                          }
                                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DataForNotification"];
                                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pageNumber"];
                                                          
                                                          NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                          
                                                          NSMutableArray *arrayForNotification=[NSMutableArray new];
                                                          
                                                          if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
                                                          {
                                                              NSArray *arrayData=[jsonDict objectForKey:@"data"];
                                                              if(!appDelegate.becameActiveAfterNotication)
                                                              {
                                                              [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:@"batchcount"] forKey:@"batchCount"];
                                                              }
                                                              
                                                              for(int i=0;i<arrayData.count;i++)
                                                              {
                                                                  NotificationModel *model=[NotificationModel new];
                                                                  NSDictionary *dict=[arrayData objectAtIndex:i];
                                                                  model.childID=[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]];
                                                                  model.type=[dict objectForKey:@"notificationType"];
                                                                  model.tableID=[NSNumber numberWithInteger:[[dict objectForKey:@"notificationTableId"] integerValue]];
                                                                  model.dateStr=[dict objectForKey:@"date_added"];
                                                                  model.isRead=[[dict objectForKey:@"isRead"] integerValue];
                                                                  model.notificationId=[dict objectForKey:@"id"];
                                                                  
                                                                  NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]]];
                                                                  Child *child=[childArray lastObject];
                                                                  
                                                                 
                                                                  if([[dict objectForKey:@"notificationType"] isEqualToString:@"ddNotes"])
                                                                  {
                                                                      if(child)
                                                                      {
                                                                      model.title=@"Note added in Daily diary";
                                                                      model.content=[[[@"Note added in Dialy diary of " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                      }
                                                                  }
                                                                  else if([[dict objectForKey:@"notificationType"] isEqualToString:@"comment"])
                                                                      
                                                                  {
                                                                      if(child)
                                                                      {
                                                                      model.title=@"New comment on observation";
                                                                      model.content=[[[@"One new comment added by parent for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                      }
                                                                  }
                                                                  else
                                                                      
                                                                  {
                                                                      if(child)
                                                                      {
                                                                      model.title=@"New observation published";
                                                                      model.content=[[[@"New observation published for " stringByAppendingString:child.firstName] stringByAppendingString:@" "] stringByAppendingString:child.lastName];
                                                                      }
                                                                      
                                                                  }
                                                                  
                                                                  if(child)
                                                                  {
                                                                  [arrayForNotification addObject:model];
                                                                  }
                                                              }
                                                              
                                                              NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                                                              NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayForNotification];
                                                              [userDefault setObject:myEncodedObject forKey:@"DataForNotification"];
                                                              //[NSString stringWithFormat:@"%d",[[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId integerValue]]
                                                              
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationForBatch" object:nil];
                                                          }
                                                          

                                                      }
                                                      
                                                      
                                                  }];
            [postDataTask resume];
 
              }
            
            
        }
        
    });

}
-(void)saveNotificationHistoryData:(NSData *)data
{
  }
@end
