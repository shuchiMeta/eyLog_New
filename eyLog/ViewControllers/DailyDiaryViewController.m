  //
//  DailyDiaryViewController.m
//  eyLog
//
//  Created by Arpan Dixit on 26/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "DailyDiaryViewController.h"
#import "ChildView.h"
#import "Theme.h"
#import  "APICallManager.h"
#import "ChildrenPopupViewController.h"
// Sumit Sharma
#import "EYL_AppData.h"
#import "RegistryCustomTableViewCell.h"
#import "RegistryCustomTableViewHeader.h"
#import "RegistryDataModal.h"
#import "WhatIateTodayTableViewCell.h"
#import "WhatIateTodayTableViewHeader.h"
#import "WhatIateTodayModal.h"
#import "SleepTimesTableViewCell.h"
#import "SleepTimesTableViewHeader.h"
#import "SleepTimesDataModal.h"
#import "SleepTimesFooterView.h"
#import "IHadMyBottleViewHeader.h"
#import "IHadMyBottleTableViewCell.h"
#import "IHadMyBottleDataModal.h"
#import "IHadMyBottleViewFooter.h"
#import "NappiesCustomTableViewCell.h"
#import "NappiesDataModal.h"
#import "NappiesRashTableViewHeader.h"
#import "ToiletingDataModal.h"
#import "ToiletingCustomTableViewCell.h"
#import "ToiletingCustomTableViewHeader.h"
#import "AppDelegate.h"
#import "DiaryEntity.h"
#import "DiaryFields.h"
#import "DFEntity.h"
#import "NSDate+EYL_Date.h"
#import "UIView+Toast.h"
#import "NotesModal.h"
#import "DDCollectionViewCell.h"
#import "DDCommentsModal.h"
#import "ChildInOutTime.h"
#import "CustomBarButton_InOut.h"
#import "APICallManager.h"
#import "Utils.h"
#import "GridViewController.h"
#import "Child.h"
#import "ObservationsModal.h"
#import "ObservationsDailyDiaryCustomHeader.h"
#import "ObservationsDailyDiaryCellTableViewCell.h"
#import "RegistryFlagsTableViewHeader.h"


#define dateChangeAlert 888;


NSString *const checkNULL = @"<null>";

AppDelegate *appDelegate;

@interface DailyDiaryViewController ()<ThemeDelegate,ChildrenSelectionPopoverDelegate, UITableViewDelegate,UITableViewDataSource,RegistryCustomTableViewCellDelegate, UIPopoverControllerDelegate, WhatIateTodayTableViewCellDelegate, SleepTimesTableViewCellDelegate, IHadMyBottleTableViewCellDelegate, NappiesCustomTableViewCellDelegate, ToiletingCustomTableViewCellDelegate, UITextViewDelegate, LibraryActionsDelegate, MBProgressHUDDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate,CustomBarButton_InOutDelegate,WYPopoverControllerDelegate,ChildrenPopupViewDelegate,RegistryFlagsTableViewCellDelegate>
{
     ChildView *containerView;
     Theme *theme;
    UIAlertView *NoNetworkalert;
    UILabel *lblPlaceHoldaer;
    UIPopoverController *popoverController;
    UIDatePicker *datePicker;

    NSIndexPath *currentIndexPath;
    RegistryCustomTableViewCell *currentCell;
     RegistryFlagsTableViewCell *currentFlagCell;
    UIButton *currentButton;
    NSArray *array_ate;

    EYL_AppData *eyl_AppDaya;
    MBProgressHUD *hud;
    BOOL isLandscape;

    NSIndexPath *zerothIndexPath;
    NSInteger selectedIndex;
    BOOL deselectFirstIndex;

    BOOL saveTextFromParents;
    BOOL isEditingEnable;
    NSDate *selectedDate;
    BOOL isAlertFromBack;
    NSString *avoidWrinting;
    NSMutableArray *mainArray_segmentControl;
    
    

}
@property (strong,nonatomic) WYPopoverController *childSelectionPopOver;
@property (strong,nonatomic) ChildrenPopupViewController *gridViewController;
// UICollectionView Selection Index
@property (nonatomic, strong) NSIndexPath *collectionViewIndexPath;


- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (assign, nonatomic) UITableViewCell * memberCell;

@property (nonatomic) NSInteger collectionViewSelectiveIndex;

@property (nonatomic, strong) NSMutableArray *array_SegmentControl;

@property (nonatomic, strong) NSMutableArray * keyArray;
@property (nonatomic, strong) NSMutableArray *array_Picker;

@property (nonatomic, weak) IBOutlet UIView *collectionViewContainerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *tempArray;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewConstraints;

// Swipe Gesture
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRight;
@property (nonatomic, strong) UISwipeGestureRecognizer *textViewLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *textViewRight;
@property (nonatomic, assign) NSInteger swipeIndex;
@end

@implementation DailyDiaryViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    theme = [Theme getTheme];
    theme.themeDelegate = self;
    [theme addToolbarItemsToViewCaontroller:self];
    //theme.delegate=self;

}
-(void)saveAudioInDirectory:(NSURL *)url
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    mainArray_segmentControl=[NSMutableArray new];
    

    for( UIView *view in self.navigationController.navigationBar.subviews)
    {
        
        if([view isKindOfClass:[ChildView class]])
        {
            
            [view removeFromSuperview];
        }
        
        
    }

    
     NSArray *arr = [ChildInOutTime fetchAllRecords:[AppDelegate context]];
     NSLog(@"%@", arr);

    self.isDailyDiaryPublished=FALSE;
    // Initialize Instance Variables and Load Views
    [self initializeIVars];

    [self fetchAllRecords];
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPostDailyDiary) name:kReachabilityChangedNotification object:nil];

    [self initializeCustomTableViewCells];
    if(!_isComeFromNotesNotifcation)
    {
    selectedDate= self.strCurrentDate;
    }

    [self requestDailyDiaryForDate:self.strCurrentDate];
    

}

- (void) initializeIVars
{
    eyl_AppDaya = [EYL_AppData sharedEYL_AppData];
    self.localRegistryObjects = [[NSMutableArray alloc] init];
    
    if(!_isComeFromNotesNotifcation)
    {
    self.strCurrentDate = [eyl_AppDaya getDateFromNSDate:[NSDate date]];
    }
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.ObservationFlag=1;

    self.array_Picker = [[NSMutableArray alloc] initWithObjects:
                         @"1",@"2",@"3",@"4",@"5",
                         @"6",@"7",@"8",@"9",@"10",
                         @"11",@"12",@"13",@"14",@"15",
                         @"16",@"17",@"18",@"19",@"20",nil];


    array_ate = [[NSArray alloc] initWithObjects:@"breakfast",@"snack_am",@"pudding_am", @"lunch", @"snack_pm",@"pudding_pm",@"tea",nil];

    zerothIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];

    // Navigation Items
    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;
    containerView=[[[NSBundle mainBundle]loadNibNamed:@"ChildView" owner:self options:nil] objectAtIndex:0];
    containerView.childDropDown.hidden=YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.collectionViewContainerView.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = ~UIViewAutoresizingNone;
    [self.collectionViewContainerView addSubview:self.collectionView];
    layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView setShowsHorizontalScrollIndicator:FALSE];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView reloadData];
    [self registerNib];
    isEditingEnable=YES;

    _keyArray = [[NSMutableArray alloc] init];
    DFEntity * entity = [DFEntity new];
    entity.keyN = @"registry";
    entity.keyV = @"array_Registry";
    [_keyArray addObject:entity];
    entity = [DFEntity new];
    entity.keyN = @"what_i_ate_today";
    entity.keyV = @"array_WhatIateToday";
    [_keyArray addObject:entity];
    entity = [DFEntity new];
    entity.keyN = @"sleep_times";
    entity.keyV = @"array_SleepTimes";
    [_keyArray addObject:entity];
    entity = [DFEntity new];
    entity.keyN = @"i_had_my_bottle";
    entity.keyV = @"array_IHadMyBottle";
    [_keyArray addObject:entity];
    entity = [DFEntity new];
    entity.keyN = @"nappies";
    entity.keyV = @"array_nappiesRash";
    [_keyArray addObject:entity];
    entity = [DFEntity new];
    entity.keyN = @"toileting_today_1";
    entity.keyV = @"array_Toileting";
    [_keyArray addObject:entity];
    
    entity = [DFEntity new];
    entity.keyN = @"observationEyfs";
    entity.keyV = @"array_Observations";
    [_keyArray addObject:entity];
    
    isLandscape=false;
   [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DDCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kDDCollectionViewCellReuseId];
    if(_isComeFromNotesNotifcation)
    {
        if(self.array_SegmentControl.count>0)
        {
        NSInteger inte=self.array_SegmentControl.count-1;
            selectedIndex=inte;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.array_SegmentControl.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
    }
    else
    {
    selectedIndex=0;
    }
    

}

- (void)registerNib {
    }

- (void) initializeCustomTableViewCells
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RegistryCustomTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kRegistryCustomTableViewCell];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RegistryFlagsTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kRegistryFlagsTableViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WhatIateTodayTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kWhatIateTodayTableViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SleepTimesTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSleepTimesTableViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IHadMyBottleTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kIHadMyBottleTableViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NappiesCustomTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kNappiesCustomTableViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ToiletingCustomTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kToiletingCustomTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ObservationsDailyDiaryCellTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kObservationsDailyDiaryCellTableViewCell];
}

-(void) clearAllArrays
{
    
    isNappiesFilled = FALSE;
    isToiletingFilled = FALSE;
    isIHadMyBottleFilled = FALSE;
    isSleepTimesFilled = FALSE;
    isNotesToParentsFilled = FALSE;
    isRegistryFilled = FALSE;
    isWhatIateToday = FALSE;

    [eyl_AppDaya.array_Comments removeAllObjects];
    isComentsAdded=NO;
    
    [eyl_AppDaya.array_IHadMyBottle removeAllObjects];
    [eyl_AppDaya.array_nappiesRash  removeAllObjects];
    [eyl_AppDaya.array_Notes removeAllObjects];
    [eyl_AppDaya.array_Registry removeAllObjects];
    [eyl_AppDaya.array_SleepTimes removeAllObjects];
    [eyl_AppDaya.array_Toileting removeAllObjects];
    [eyl_AppDaya.array_registryStatus removeAllObjects];
    
    //[eyl_AppDaya.array_WhatIateToday removeAllObjects];
    [eyl_AppDaya.array_Notes removeAllObjects];
    [eyl_AppDaya.array_Observations removeAllObjects];
    self.textView_Parents.text=nil;

    for (int k=0; k<[eyl_AppDaya.array_WhatIateToday count]; k++)
    {
        WhatIateTodayModal *obj = [eyl_AppDaya.array_WhatIateToday objectAtIndex:k];
        [obj setIndex:0];
        obj=nil;
    }
}


- (void) fetchAllRecords
{
    NSDictionary *savedDict=[NSDictionary new];
    
    NSString *str=@"registry";
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.keyN==%@",str];
    
    NSArray *array=[self.array_SegmentControl filteredArrayUsingPredicate:predicate];
    
    NSDictionary *dict=[array firstObject];
    
    if([[dict objectForKey:@"isEmpty"]isEqualToString:@"True"])
    {
        savedDict=[NSDictionary dictionaryWithDictionary:dict];
        
    }
    __block BOOL isAdditionalNotesAtLastIndex = FALSE;
    self.array_SegmentControl = [[NSMutableArray alloc] init];
     NSArray *arr = [DiaryEntity fetchAllRecords:[AppDelegate context]];
    NSMutableArray * mutArray=[NSMutableArray arrayWithArray:arr];
  
    [arr enumerateObjectsUsingBlock:^(DiaryEntity *objDiary , NSUInteger idx, BOOL *stop)
    {
         DiaryEntity *obj=[arr objectAtIndex:idx];
        if(objDiary.visibility)
        {
       
        NSArray *fieldsArray = obj.fields.allObjects;
        if([obj.name isEqualToString:@"observationEyfs"]||[obj.name isEqualToString:@"observationfields"])
        {
        
            NSMutableDictionary * dict = [NSMutableDictionary new];
            [dict setValue:@"observationEyfs" forKey:@"keyN"];
            [dict setValue:@"observationEyfs" forKey:@"keyV"];
            [dict setValue:@"False" forKey:@"isEmpty"];
            if(obj)
            [self.array_SegmentControl addObject:dict];
        }
        for (int k=0; k< [fieldsArray count]; k++)
        {
            NSLog(@"%@", obj.name);
            DiaryFields *objDF = [fieldsArray objectAtIndex:k];
            NSLog(@"%@ %@ ", objDF.keyName, objDF.keyValue);
           
            if ([obj.name isEqualToString:objDF.keyName])
            {
                NSMutableDictionary * dict = [NSMutableDictionary new];
                [dict setValue:objDF.keyName forKey:@"keyN"];
                [dict setValue:objDF.keyValue forKey:@"keyV"];
                [dict setValue:@"False" forKey:@"isEmpty"];
                if ([objDF.keyName isEqualToString:@"additionalnotes"])
                    isAdditionalNotesAtLastIndex =  TRUE;
                if (isAdditionalNotesAtLastIndex)
                {
                    [self.array_SegmentControl insertObject:dict atIndex:self.array_SegmentControl.count-1];
                    isAdditionalNotesAtLastIndex=NO;
                }

                else
                {
                    if([objDiary.age_group isEqualToString:@"Between"])
                    {
                        if([[APICallManager sharedNetworkSingleton].cacheChild.ageMonths integerValue]<=[objDiary.age_group_end integerValue]&&[[APICallManager sharedNetworkSingleton].cacheChild.ageMonths integerValue]>=[objDiary.age_group_start integerValue])
                        {
                        [self.array_SegmentControl addObject:dict];
                        }
                        else
                        {
                        [mutArray removeObject:obj];
                        }
                    
                    }
                    else
                    {
                        
                        if([objDF.keyName isEqualToString:@"registry"])
                        {
                            
                        if(savedDict.count>0)
                        {
                            [self.array_SegmentControl addObject:savedDict];
                        }
                        else
                        {
                        [self.array_SegmentControl addObject:dict];
                        }
                            
                        }
                        else
                        {
                        [self.array_SegmentControl addObject:dict];
                        }
                    }
                }
               
                
                dict=nil;
            }
            if ([objDF.keyName isEqualToString:@"registry"])
            {
                int changeIndex = (int)self.array_SegmentControl.count-1;
                [self.array_SegmentControl exchangeObjectAtIndex:0 withObjectAtIndex:changeIndex];
            }
           
        }

//
        }
        else
        {
        [mutArray removeObject:obj];
        }
        if (mutArray.count == self.array_SegmentControl.count)
            
        {
            NSMutableArray *newMut=[NSMutableArray arrayWithArray:self.array_SegmentControl];
            
            for(NSDictionary *dictionary in newMut)
            {
                
                //
                if([[dictionary objectForKey:@"keyN"]isEqualToString:@"observationfields"]||[[dictionary objectForKey:@"keyN"]isEqualToString:@"observationEyfs"])
                {
                    [self.array_SegmentControl exchangeObjectAtIndex:[self.array_SegmentControl indexOfObject:self.array_SegmentControl.lastObject]-1 withObjectAtIndex:[self.array_SegmentControl indexOfObject:dictionary]];
                    
                }
                if([[dictionary objectForKey:@"keyN"]isEqualToString:@"additionalnotes"])
                    
                {
                    [self.array_SegmentControl exchangeObjectAtIndex:[self.array_SegmentControl indexOfObject:self.array_SegmentControl.lastObject] withObjectAtIndex:[self.array_SegmentControl indexOfObject:dictionary]];
                    
                }
                
            }

           [self.collectionView reloadData];
        }
        
        
    }];
    mainArray_segmentControl=self.array_SegmentControl;
    

}

-(void)viewDidDisappear:(BOOL)animated{
    [containerView removeFromSuperview];
}
-(void)viewWillDisappear:(BOOL)animated
{
     
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"UIKeyboardWillShowNotification" object:nil];

   // [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"UIKeyboardDidHideNotification" object:nil];//UIKeyboardWillHideNotification
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"UIKeyboardWillHideNotification" object:nil];
 
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    CGRect frame=self.view.frame;
    frame.origin.y=1;
    [self.view setFrame:frame];
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{

      [self addKeyboardNotification];
       containerView.delegate = self;
       containerView.isComeFromDailyDiary=YES;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        appDelegate.ObservationFlag=1;
        NSLog(@"landscape");
        isLandscape=YES;
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-955, 0, 950, 40);
            containerView.hidden=NO;
        }];
    }
    else
    {
        NSLog(@"portrait");
        isLandscape=NO;
        appDelegate.ObservationFlag=1;
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-720, 0, 715, 40);
            containerView.hidden=NO;
        }];
    }

    
    
    //  containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count  ];
    if([APICallManager sharedNetworkSingleton].cacheChildren.count <= 1)
    {
        containerView.childNotificationLabel.text = nil;
        [containerView.childNotificationLabel setHidden:YES];
    }
    else
    {
        [containerView.childNotificationLabel setHidden:NO];
        containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count  ];
    }
    [theme resetTargetViewController:self];

    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
    {
        [self.navigationController.navigationBar addSubview:containerView];
    }
   
}

-(void)showDateTimePicker:(id)sender toolbar:(UIToolbar *)toolbar
{
    UIDatePicker *picker = (UIDatePicker *)sender;
//    if(_eylNewObservation.observationCreatedAt)
//        [picker setDate:_eylNewObservation.observationCreatedAt];
    [self.view addSubview:picker];
    [self.view addSubview:toolbar];
}


-(void) requestDailyDiaryForDate :(NSString *) dateString
{
    [self clearAllArrays];
    [eyl_AppDaya.array_Notes removeAllObjects];
    [eyl_AppDaya.array_Comments removeAllObjects];
    isComentsAdded=NO;
    
    [eyl_AppDaya.array_IHadMyBottle removeAllObjects];
    [eyl_AppDaya.array_nappiesRash removeAllObjects];
    [eyl_AppDaya.array_Registry removeAllObjects];
    [eyl_AppDaya.array_SleepTimes removeAllObjects];
  //[eyl_AppDaya.array_WhatIateToday removeAllObjects];
    [eyl_AppDaya.array_Toileting removeAllObjects];
      [eyl_AppDaya.array_Observations removeAllObjects];
    [eyl_AppDaya.array_registryStatus removeAllObjects];

    [self addRowToRegistry:NO];
    [self addRowToNotes];
    [self addComments];
   
    [self addRowsToSleepTimes:NO];
    [self addRowsToWhatIateToday];
    [self addRowsToNappiesRash:NO];
    [self addRowsToToileting:NO];
    [self addRowsToIHadMyBottle:NO];
    if(_isComeFromNotesNotifcation)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Loading Daily Dairy and Registry";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;
        [self getDailyDiaryAfterNotification:_diaryID];
         [self getRegistry:self.strCurrentDate];
        
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Loading Daily Dairy and Registry";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;

    [self getDailyDiary:dateString];
    [self getRegistry:dateString];
        
    }
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(WYPopoverController *)setPopoverProperties:(WYPopoverController *)popover
{
    
    popover.theme.tintColor = [UIColor clearColor];
    popover.theme.fillTopColor = [UIColor clearColor];
    popover.theme.fillBottomColor = [UIColor clearColor];
    popover.theme.glossShadowColor = [UIColor clearColor];
    popover.theme.outerShadowColor = [UIColor clearColor];
    popover.theme.outerStrokeColor = [UIColor clearColor];
    popover.theme.innerShadowColor = [UIColor clearColor];
    popover.theme.innerStrokeColor = [UIColor clearColor];
    popover.theme.overlayColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:0.6f];
    popover.delegate=self;
    popover.theme.glossShadowBlurRadius = 0.0f;
    popover.theme.borderWidth = 0.0f;
    popover.theme.arrowBase = 0.0f;
    popover.theme.arrowHeight = 0.0f;
    popover.theme.outerShadowBlurRadius = 0.0f;
    popover.theme.outerCornerRadius = 0.0f;
    popover.theme.minOuterCornerRadius = 0.0f;
    popover.theme.innerShadowBlurRadius = 0.0f;
    popover.theme.innerCornerRadius = 0.0f;
    popover.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    popover.theme.viewContentInsets = UIEdgeInsetsMake(80, 0, 0, 0);
    popover.wantsDefaultContentAppearance = NO;
    
    popover.theme.arrowHeight = 0.0f;
    popover.theme.arrowBase = 0;
    return popover;
}

-(void)doneBtnClicked:(id)sender forChildrenPopupViewController:(ChildrenPopupViewController *)viewController{
   // [self.childSelectionPopOver dismissPopoverAnimated:YES];
  
}
// Navigation Child's delegates
-(void)showPopOverChildrenSelection:(id)sender{
//    if (!self.childSelectionPopOver)
//    {
//        self.gridViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"childrenPopUpViewControllerID"];
//        _childSelectionPopOver = [[WYPopoverController alloc] initWithContentViewController:self.gridViewController];
//        self.childSelectionPopOver=[self setPopoverProperties:self.childSelectionPopOver];
//    }
//    self.gridViewController.delegate = self;
//       self.gridViewController.deviceUUID = [[NSUUID UUID] UUIDString];
//    self.childSelectionPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
//    CGRect rect=CGRectMake(0,0,0,0);
//   
//    [self.childSelectionPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];

}


-(void)backButtonClick
{
 if (!self.isDailyDiaryPublished)
 {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to save this daily diary as draft before you leave ?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Cancel", @"Yes",nil];
  alert.delegate=self;
  [alert show];
 }
    else
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - UItableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    
    DDCollectionViewCell *ccCell = (DDCollectionViewCell *)[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex];

    [self.textView_Notes setText:@""];
    // Set the Comments Section Hidden
    [self.textView_Notes setHidden:FALSE];
    self.tableViewConstraints.constant = 177.0;

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array1 = [_keyArray filteredArrayUsingPredicate:predicate];
    if ([@"registry" isEqualToString:strName])
    {
        
        if(indexPath.section == 0)
        {
             RegistryFlagsTableViewCell *cell = (RegistryFlagsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kRegistryFlagsTableViewCell forIndexPath:indexPath];
            if(self.isDailyDiaryPublished)
            {
                cell.userInteractionEnabled=FALSE;
            }
            else
            {
                cell.userInteractionEnabled=TRUE;
            }
            
            cell.delegate=self;
            cell.indexPath=indexPath;
            
            [cell.btn_Absent setSelected:FALSE];
            [cell.btn_Holiday setSelected:FALSE];
            [cell.btn_Sick setSelected:FALSE];
            [cell.btn_NoBooks setSelected:FALSE];
            NSArray *array;
            if(eyl_AppDaya.array_registryStatus.count>0)
            {
                array  = eyl_AppDaya.array_registryStatus;
            }
            
            self.tempArray = array;
            if(array.count>0)
            {
            RegistryDataModal *obj = [array objectAtIndex:indexPath.row];

            switch (obj.index)
            {
                case 1: [cell.btn_Absent setSelected:TRUE]; break;
                case 2: [cell.btn_Holiday setSelected:TRUE]; break;
                case 3: [cell.btn_Sick setSelected:TRUE]; break;
                case 4: [cell.btn_NoBooks setSelected:TRUE]; break;
                default: break;
            }
            }
            [self.textView_Notes setHidden:NO];
//            self.tableViewConstraints.constant = 40.0;
//            [self.view setNeedsUpdateConstraints];
            
          //  DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
           // [self.textView_Notes setText:objDD.strRegistryComments];
           // objDD = nil;
            DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
            [self.textView_Notes setText:objDD.strRegistryComments];
            return cell;
            
        }
        if(indexPath.section == 1)
        {
            RegistryCustomTableViewCell *cell = (RegistryCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kRegistryCustomTableViewCell forIndexPath:indexPath];
            if(self.isDailyDiaryPublished)
            {
                cell.userInteractionEnabled=FALSE;
            }
            else
            {
                cell.userInteractionEnabled=TRUE;
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            NSArray *array = [eyl_AppDaya valueForKey:[[array1 firstObject] valueForKey:@"keyV"]];
            self.tempArray = array;
            RegistryDataModal *obj = [array objectAtIndex:indexPath.row];
            [cell.btn_CameIn setTitle:obj.strCameAt forState:UIControlStateNormal];
            [cell.btn_LeftAt setTitle:obj.strLeftAt forState:UIControlStateNormal];
            
            
            if (indexPath.row==eyl_AppDaya.array_Registry.count-1) {
                [cell.btn_Delete setHidden:TRUE];
                [cell.btn_Add setHidden:FALSE];
            }
            else{
                [cell.btn_Delete setHidden:FALSE];
                [cell.btn_Add setHidden:TRUE];
            }
            
            obj=nil;
            [self.textView_Notes setHidden:NO];
//            self.tableViewConstraints.constant = 40.0;
//            [self.view setNeedsUpdateConstraints];
            
//            DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
//            [self.textView_Notes setText:objDD.strRegistryComments];
//            objDD = nil;
            DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
            [self.textView_Notes setText:objDD.strRegistryComments];
            NSLog(@"Testing %@",objDD.strRegistryComments);
            
            return cell;
            

        }
       
        // Set the Comments Section Hidden
      
      
    }
    else if ([@"what_i_ate_today" isEqualToString:strName]){
        // 1 - What I ate Today
        WhatIateTodayTableViewCell *cell = (WhatIateTodayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kWhatIateTodayTableViewCell forIndexPath:indexPath];
        if(self.isDailyDiaryPublished)
        {
            cell.userInteractionEnabled=FALSE;
        }
        else
        {
            cell.userInteractionEnabled=TRUE;
        }
        cell.ateDelegate = self;
        cell.indexPath=indexPath;

        self.tempArray = eyl_AppDaya.array_WhatIateToday;

        WhatIateTodayModal *obj = [eyl_AppDaya.array_WhatIateToday objectAtIndex:indexPath.row];
       // [cell.lblName setText:[obj.strName capitalizedString]];
        [cell.lblName setText:obj.strName];
        
        
        [cell.btn_None setSelected:FALSE];
        [cell.btn_na setSelected:FALSE];
        [cell.btn_All setSelected:FALSE];
        [cell.btn_Most setSelected:FALSE];
        [cell.btn_Some setSelected:FALSE];

        DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
        [self.textView_Notes setText:objDD.strWhatIateTodayComments];
        objDD = nil;

        switch (obj.index)
        {
            case 1: [cell.btn_None setSelected:TRUE]; break;
            case 2: [cell.btn_Some setSelected:TRUE]; break;
            case 3: [cell.btn_Most setSelected:TRUE]; break;
            case 4: [cell.btn_All setSelected:TRUE]; break;
            case 5: [cell.btn_na setSelected:TRUE]; break;
            default: break;
        }
        return cell;
    }
    else if ([@"sleep_times" isEqualToString:strName]){
        // 2 - Sleep Times
        SleepTimesTableViewCell *cell = (SleepTimesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kSleepTimesTableViewCell forIndexPath:indexPath];
        if(self.isDailyDiaryPublished)
        {
            cell.userInteractionEnabled=FALSE;
        }
        else
        {
            cell.userInteractionEnabled=TRUE;
        }
        cell.delegate=self;
        cell.indexPath=indexPath;

        if (indexPath.row==eyl_AppDaya.array_SleepTimes.count-1)
        {
            [cell.btn_AddRow setHidden:FALSE];
            [cell.btn_DeleteRow setHidden:TRUE];
        }
        else
        {
            [cell.btn_AddRow setHidden:TRUE];
            [cell.btn_DeleteRow setHidden:FALSE];
        }
        NSArray *array = eyl_AppDaya.array_SleepTimes;
        self.tempArray = array;

        SleepTimesDataModal *obj = [array objectAtIndex:indexPath.row];

        [cell.btn_FellAsleep setTitle:obj.strFellAsleep forState:UIControlStateNormal];
        [cell.btn_WokeUp setTitle:obj.strWokeUp  forState:UIControlStateNormal];
        NSInteger hour_total=0, minute_total=0;
        hour_total += [[[obj.strSleptMins componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
        minute_total += [[[obj.strSleptMins componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];

        //[NSString stringWithFormat:@"Total Sleep Time :  %02d:%02d", hour_total,minute_total]
        [cell.btn_SleeptMins setTitle:[NSString stringWithFormat:@"%02d:%02d", hour_total,minute_total] forState:UIControlStateNormal];

        DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
        [self.textView_Notes setText:objDD.strSleepTimesComments];
        objDD = nil;

        obj=nil;

        return cell;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName]){
        // 3 - I had my Bottle
        IHadMyBottleTableViewCell *cell = (IHadMyBottleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIHadMyBottleTableViewCell forIndexPath:indexPath];
        if(self.isDailyDiaryPublished)
        {
            cell.userInteractionEnabled=FALSE;
        }
        else
        {
            cell.userInteractionEnabled=TRUE;
        }
        cell.indexPath = indexPath;
        cell.delegate=self;
        NSArray *array = eyl_AppDaya.array_IHadMyBottle;
        self.tempArray = array;

        if (indexPath.row==array.count-1)
        {
            [cell.btn_Add setHidden:FALSE];
            [cell.btn_Delete setHidden:TRUE];
        }
        else
        {
            [cell.btn_Add setHidden:TRUE];
            [cell.btn_Delete setHidden:FALSE];
        }

        IHadMyBottleDataModal *obj = [array objectAtIndex:indexPath.row];
        [cell.btn_At setTitle:obj.strDateAt forState:UIControlStateNormal];
        [cell.btn_Drank setTitle:obj.strDrank forState:UIControlStateNormal];
        cell.textfield.text=obj.strDrank;
        
        DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
        [self.textView_Notes setText:objDD.strIHadMyBottleComments];
        objDD = nil;

        obj=nil;

        return cell;
    }
    else if ([@"nappies" isEqualToString:strName]){
        // 4 - Nappies

        NappiesCustomTableViewCell *cell = (NappiesCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kNappiesCustomTableViewCell forIndexPath:indexPath];
        if(self.isDailyDiaryPublished)
        {
            cell.userInteractionEnabled=FALSE;
        }
        else
        {
            cell.userInteractionEnabled=TRUE;
        }
        cell.indexPath = indexPath;
        cell.delegate=self;
        NSArray *array = eyl_AppDaya.array_nappiesRash;
        self.tempArray = array;

        if (indexPath.row==array.count-1)
        {
            [cell.btn_Add setHidden:FALSE];
            [cell.btn_Delete setHidden:TRUE];
        }
        else
        {
            [cell.btn_Add setHidden:TRUE];
            [cell.btn_Delete setHidden:FALSE];
        }

        NappiesDataModal *obj = [array objectAtIndex:indexPath.row];

        [cell.btn_When setTitle:obj.strWhen forState:UIControlStateNormal];

        [cell.btn_Dry setSelected:FALSE];
        [cell.btn_Wet setSelected:FALSE];
        [cell.btn_Soiled setSelected:FALSE];
        [cell.btn_CreamApplied setSelected:FALSE];
        [cell.btn_Soiled setSelected:FALSE];

        DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
        [self.textView_Notes setText:objDD.strNappiesComments];
        objDD = nil;

        switch (obj.index)
        {
            case 1: [cell.btn_Dry setSelected:TRUE]; break;
            case 2: [cell.btn_Wet setSelected:TRUE]; break;
            case 3: [cell.btn_Soiled setSelected:TRUE]; break;
            default: break;
        }
        [cell.btn_NappyRash setSelected:(obj.nappyRash ? TRUE : FALSE)];
        [cell.btn_CreamApplied setSelected:(obj.creamApplied) ? TRUE : FALSE];

        obj=nil;

        return cell;
    }
    else if ([@"toileting_today_1" isEqualToString:strName]){
        // 5 - Toileting

        ToiletingCustomTableViewCell *cell = (ToiletingCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kToiletingCustomTableViewCell forIndexPath:indexPath];
        if(self.isDailyDiaryPublished)
        {
            cell.userInteractionEnabled=FALSE;
        }
        else
        {
            cell.userInteractionEnabled=TRUE;
        }
        cell.indexPath = indexPath;
        cell.delegate=self;
        NSArray *array = eyl_AppDaya.array_Toileting;
        
        self.tempArray = array;

        if (indexPath.row==array.count-1)
        {
            [cell.btn_Add setHidden:FALSE];
            [cell.btn_Delete setHidden:TRUE];
        }
        else
        {
            [cell.btn_Add setHidden:TRUE];
            [cell.btn_Delete setHidden:FALSE];
        }

        ToiletingDataModal *obj = [array objectAtIndex:indexPath.row];
        [cell.btn_When setTitle:obj.str_When forState:UIControlStateNormal];

        [cell.btn_WentOnThePotty setSelected:FALSE];
        [cell.btn_WentOnTheToilet setSelected:FALSE];
        [cell.btn_ITried setSelected:FALSE];

        DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
        [self.textView_Notes setText:objDD.strToiletingTodayComments];
        objDD = nil;

        switch (obj.index)
        {
            case 1: [cell.btn_WentOnThePotty setSelected:TRUE]; break;
            case 2: [cell.btn_WentOnTheToilet setSelected:TRUE]; break;
            case 3: [cell.btn_ITried setSelected:TRUE]; break;
            default: break;
        }

        obj=nil;
        return cell;
    }
     else if ([@"observationEyfs" isEqualToString:strName]){
         
         ObservationsDailyDiaryCellTableViewCell *cell = (ObservationsDailyDiaryCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kObservationsDailyDiaryCellTableViewCell forIndexPath:indexPath];
         if(self.isDailyDiaryPublished)
         {
             cell.userInteractionEnabled=FALSE;
         }
         else
         {
         cell.userInteractionEnabled=TRUE;
         }
         cell.backgroundColor=[UIColor clearColor];
         
         NSArray *array = eyl_AppDaya.array_Observations;
         self.tempArray = array;
         ObservationsModal *obj = [array objectAtIndex:indexPath.row];
         cell.observation_text.text=obj.observation_text;
         cell.area_accessed.text=obj.areas_assessed;
         
         NSDateFormatter *dateFormatter=[NSDateFormatter new];
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         //2015-11-05 11:43:07

         NSDate *dateFromString = [dateFormatter dateFromString:obj.date_time];
         
         dateFormatter=[NSDateFormatter new];
         [dateFormatter setDateFormat:@"MMM dd, yyyy , HH:mm "];
         
         NSString *str=[dateFormatter stringFromDate:dateFromString];
         
          cell.date_timeLabel.text=[[str stringByAppendingString:@"By "] stringByAppendingString:obj.observer_name];
         
         
       return cell;
         
     }
   
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array1 = [_keyArray filteredArrayUsingPredicate:predicate];
    if ([@"registry" isEqualToString:strName])
    {
        return 2;
        
    }
    else
    {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array1 = [_keyArray filteredArrayUsingPredicate:predicate];
    if ([@"registry" isEqualToString:strName])
    {
        if(section==0)
        {
            return 1;
        }
        else
        {
             NSArray *array = [eyl_AppDaya valueForKey:[[array1 firstObject] valueForKey:@"keyV"]];
            return array.count;
        }
    }
    if([@"observationEyfs" isEqualToString:strName])
    {
        NSArray *array = [eyl_AppDaya valueForKey:[[array1 firstObject] valueForKey:@"keyV"]];
        return array.count;
    }
   else if ([[[array1 firstObject] valueForKey:@"keyN"] isEqualToString:strName])
   {
        NSArray *array = [eyl_AppDaya valueForKey:[[array1 firstObject] valueForKey:@"keyV"]];
        return array.count;
    }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array = [_keyArray filteredArrayUsingPredicate:predicate];
   
    if ([@"registry" isEqualToString:strName])
    {
        
        if(section==0)
       {
           
            RegistryFlagsTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"RegistryFlagsTableViewHeader" owner:self options:nil] objectAtIndex:0];
           
           
            //[header.absentLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [header.holidayLabl setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [header.sickLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [header.notBookedLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//            [header.notBookedLbl setFrame:header.holidayLabl.frame];
//            [header.sickLbl setFrame:header.absentLbl.frame];
//            [header.absentLbl setFrame:header.cameInLabel.frame];
//            [header.holidayLabl setFrame:header.leftAtLabel.frame];
//            
//          //
//            
//            [header.absentLbl setTranslatesAutoresizingMaskIntoConstraints:YES];
//            [header.holidayLabl setTranslatesAutoresizingMaskIntoConstraints:YES];
//            [header.sickLbl setTranslatesAutoresizingMaskIntoConstraints:YES];
//            [header.notBookedLbl setTranslatesAutoresizingMaskIntoConstraints:YES];
            return header;
            
        }
        else
        {
            RegistryCustomTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"RegistryCustomTableViewHeader" owner:self options:nil] objectAtIndex:0];
            
            NSArray *arr = [DiaryEntity fetchAllRecords:[AppDelegate context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name==%@",@"registry"];
            
            NSArray *found=[arr filteredArrayUsingPredicate:predicate];
            
            DiaryEntity *entity=[found lastObject];
            
            header.cameInLabel.text=entity.cameInVariableName;
            header.leftAtLabel.text=entity.leftAtVariableName;
  
//            [header.cameInLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [header.leftAtLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//            
//            [header.cameInLabel setFrame:CGRectMake(header.cameInLabel.frame.origin.x, header.cameInLabel.frame.origin.y, 110, header.cameInLabel.frame.size.height)];
//            
//             [header.leftAtLabel setFrame:CGRectMake(header.leftAtLabel.frame.origin.x, header.leftAtLabel.frame.origin.y, 110, header.leftAtLabel.frame.size.height)];
            
//            [header.cameInLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
//            [header.leftAtLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
            
            
             [header.absentLbl setHidden:YES];
             [header.holidayLabl setHidden:YES];
             [header.sickLbl setHidden:YES];
             [header.notBookedLbl setHidden:YES];
             return header;
            
        }
       
        
       
    }
    else if ([@"what_i_ate_today" isEqualToString:strName])
    {
        WhatIateTodayTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"WhatIateTodayTableViewHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }
    else if ([@"sleep_times" isEqualToString:strName])
    {
        SleepTimesTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"SleepTimesTableViewHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName]){
        IHadMyBottleViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"IHadMyBottleViewHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }
    else if ([@"nappies" isEqualToString:strName])
    {
        NappiesRashTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"NappiesRashTableViewHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }
    else if ([@"toileting_today_1" isEqualToString:strName])
    {
        ToiletingCustomTableViewHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"ToiletingCustomTableViewHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }
    else if ([@"observationEyfs" isEqualToString:strName])
    {
        ObservationsDailyDiaryCustomHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"ObservationsDailyDiaryCustomHeader" owner:self options:nil] objectAtIndex:0];
        return header;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array = [_keyArray filteredArrayUsingPredicate:predicate];
    
 
    if ([@"i_had_my_bottle" isEqualToString:strName]){

        IHadMyBottleViewFooter *header2 = [[[NSBundle mainBundle] loadNibNamed:@"IHadMyBottleViewFooter" owner:self options:nil] objectAtIndex:0];

        NSInteger sum=0;
        for (id odk in eyl_AppDaya.array_IHadMyBottle)
        {
            IHadMyBottleDataModal *obj = odk;
            sum += [obj.strDrank integerValue];
        }

        [header2.lbl_NetQuantity setText:[NSString stringWithFormat:@"Total Quantity (ml) :  %d", sum]];

        return header2;
    }
    else if ([@"sleep_times" isEqualToString:strName]){
        
        SleepTimesFooterView *sleepFooter = [[[NSBundle mainBundle] loadNibNamed:@"SleepTimesFooterView" owner:self options:nil] objectAtIndex:0];
        
        NSInteger hour_total=0, minute_total=0;
        for (id odk in eyl_AppDaya.array_SleepTimes)
        {
            SleepTimesDataModal *obj = odk;
            hour_total += [[[obj.strSleptMins componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
            minute_total += [[[obj.strSleptMins componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
            
        }
        if (minute_total>59) {
            int addHours = minute_total/60;
            int remainingMinutes = minute_total%60;
            hour_total +=addHours;
            minute_total = remainingMinutes;
        }

        [sleepFooter.lblTotalSleepTimes setText:[NSString stringWithFormat:@"Total Sleep Time :  %02d:%02d", hour_total,minute_total]];
        
        return sleepFooter;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];

    if ([@"i_had_my_bottle" isEqualToString:strName] || [@"sleep_times" isEqualToString:strName])
        return 60.0;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    if ([@"observationEyfs" isEqualToString:strName])
    {
        return UITableViewAutomaticDimension;
        
    }
    
    return 60.0;
}


#pragma mark - RegistryCustomTableViewCellDelegate
-(void)clickedBtn:(UIButton *)btn forRegistryFlagsTableViewCell:(RegistryFlagsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=@"00:00";
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELf.strCameAt !=%@ OR SELF.strLeftAt !=%@",str,str];
    
    NSArray *array=[eyl_AppDaya.array_Registry filteredArrayUsingPredicate:predicate];
    
    //![obj.strCameAt isEqualToString:@"00:00"]||![obj.strLeftAt isEqualToString:@"00:00"]
    RegistryDataModal *obj = [eyl_AppDaya.array_Registry objectAtIndex:indexPath.row];
    currentFlagCell = cell;
    currentIndexPath= indexPath;
    currentButton=btn;
      switch (btn.tag) {
              
          case RegistryAbsent:
              if(array.count>0)
              {
                  [self.view makeToast:@"Cannot edit if child has came in and left." duration:1.0f position:CSToastPositionBottom];
              }
              else
              {
                  [self updateCellAtIndex:indexPath forButton:btn];
              }
              break;
          case RegistryHoliday:
              if(array.count>0)
              {
                  [self.view makeToast:@"Cannot edit if child has came in and left." duration:1.0f position:CSToastPositionBottom];
              }
              else
              {
                  [self updateCellAtIndex:indexPath forButton:btn];
              }
              break;
          case RegistrySick:
              if(array.count>0)
              {
                  [self.view makeToast:@"Cannot edit if child has came in and left." duration:1.0f position:CSToastPositionBottom];
              }
              else
              {
                  [self updateCellAtIndex:indexPath forButton:btn];
              }
              break;
          case RegistryNoBooks:
              if(array.count>0)
              {
                  [self.view makeToast:@"Cannot edit if child has came in and left." duration:1.0f position:CSToastPositionBottom];
              }
              else
              {
                  [self updateCellAtIndex:indexPath forButton:btn];
              }
            
                      break;
          default:
              break;
      }

    
}
-(void)clickedBtn:(UIButton *)btn forRegistryCustomTableViewCell:(RegistryCustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //[self disableUI];
    RegistryDataModal *obj = [eyl_AppDaya.array_Registry objectAtIndex:indexPath.row];
    currentCell = cell;
    currentIndexPath= indexPath;
    currentButton=btn;

    switch (btn.tag) {
        case RegistryCameIn:
        {
            if(eyl_AppDaya.array_registryStatus.count>0)
            {
            RegistryDataModal *modal=[eyl_AppDaya.array_registryStatus firstObject];
            
               if(modal.index==1||modal.index==2||modal.index==3||modal.index==4)
            
               {
                 [self.view makeToast:@"Cannot edit time" duration:1.0f position:CSToastPositionBottom];
               }
               else
                   
               {
                   [self showDatePicker:cell withDate:obj.date_CameAt];

               }
            }
            else
            {
             [self showDatePicker:cell withDate:obj.date_CameAt];
            }
            
            break;
        }
        case RegistryLeftAt:
                {
                    if(eyl_AppDaya.array_registryStatus.count>0)
                    {
                        RegistryDataModal *modal=[eyl_AppDaya.array_registryStatus firstObject];
                        

                    if(modal.index==1||modal.index==2||modal.index==3||modal.index==4)
                    {
                        [self.view makeToast:@"Cannot edit time" duration:1.0f position:CSToastPositionBottom];
                    }
                    else
                    {
                    if ([obj.strCameAt isEqualToString:@"00:00"])
                        [self.view makeToast:@"Please select Came in time first." duration:1.0f position:CSToastPositionBottom];
                    else
                        [self showDatePicker:cell withDate:obj.date_LeftAt];
                    }
                    }
                    else
                    {
                        if ([obj.strCameAt isEqualToString:@"00:00"])
                            [self.view makeToast:@"Please select Came in time first." duration:1.0f position:CSToastPositionBottom];
                        else
                            [self showDatePicker:cell withDate:obj.date_LeftAt];
                    
                    }
                    break;
            
                }
               case RegistryAdd:{
                   if(eyl_AppDaya.array_registryStatus.count>0)
                   {
                       RegistryDataModal *modal=[eyl_AppDaya.array_registryStatus firstObject];
                        if(modal.index==1||modal.index==2||modal.index==3||modal.index==4)
                       {
                           [self.view makeToast:@"Cannot add More" duration:1.0f position:CSToastPositionBottom];
                       }
                       else
                       {
                           
                                       [self addRowToRegistry:YES];
                           
                       }
                   }
                   else
                   {
                            [self addRowToRegistry:YES];
                   }

            
        }break;
        case RegistryDelete:
        {
            // Delete Row
            [self disableUI];
            
            [eyl_AppDaya.array_registryDeleted addObject:[eyl_AppDaya.array_Registry objectAtIndex:indexPath.row]];
            
            [eyl_AppDaya.array_Registry removeObjectAtIndex:indexPath.row];
            [self deleteRowAndUpdateTableViewAtIndepath:indexPath];
            
            for (int i=0; i<eyl_AppDaya.array_Registry.count; i++)
            {
                RegistryDataModal *objRDM = [eyl_AppDaya.array_Registry objectAtIndex:i];
                
                if (![objRDM.strCameAt isEqualToString:@"00:00"]) {
                    isRegistryFilled=TRUE;
                    break;
                }
                else if (objRDM.index>1)
                {
                    isRegistryFilled=TRUE;
                    break;
                }
                else
                    isRegistryFilled=FALSE;
                
                objRDM=nil;
            }
            
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
                {
                    if (isRegistryFilled)
                        
                        if([dict valueForKey:@"isEmpty"])
                        {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                        }
                    else
                        if([dict valueForKey:@"isEmpty"])
                        {
                        [dict setValue:@"False" forKey:@"isEmpty"];
                        }
                }
            }
            [self.collectionView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - WhatIateTodayDelegate Method

- (void) buttonAction:(UIButton *)button forWhatIateTodayIndexPath:(WhatIateTodayTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WhatIateTodayModal *obj = [eyl_AppDaya.array_WhatIateToday objectAtIndex:indexPath.row];

    switch (button.tag)
    {
        case 401: [obj setIndex:1]; break;
        case 402: [obj setIndex:2]; break;
        case 403: [obj setIndex:3]; break;
        case 404: [obj setIndex:4]; break;
        case 405: [obj setIndex:5]; break;
        default: break;
    }
    [self updateTableViewCellAtIndexPath:indexPath];
    
    for (NSMutableDictionary *dict in self.array_SegmentControl)
    {
        if ([[dict valueForKey:@"keyN"] isEqualToString:@"what_i_ate_today"])
        {
            [dict setValue:@"True" forKey:@"isEmpty"];
        }
    }
    [self.collectionView reloadData];
}

-(void) updateCellAtIndex :(NSIndexPath *) indexPath forButton :(UIButton *) button
{
    if(eyl_AppDaya.array_registryStatus.count==0)
    {
        RegistryDataModal *obj=[[RegistryDataModal alloc] init];
         [obj setClientTimeStamp:@""];
        [eyl_AppDaya.array_registryStatus addObject:obj];
      
        
    }
    RegistryDataModal *obj = [eyl_AppDaya.array_registryStatus firstObject];

    switch (button.tag)
    {
        case 703:
            if([button isSelected])
            {
             [obj setIndex:0];
                 _isHideOtherTabs=NO;
            }
            else
            {
                [obj setIndex:1];
                _isHideOtherTabs=YES;
                

            }
            break;
        case 704:  if([button isSelected])
        {
            [obj setIndex:0];
             _isHideOtherTabs=NO;
        }
        else
        {
            [obj setIndex:2];
             _isHideOtherTabs=YES;
            
        } break;
        case 705:  if([button isSelected])
        {
            [obj setIndex:0];
             _isHideOtherTabs=NO;
        }
        else
        {
            [obj setIndex:3];
             _isHideOtherTabs=YES;
            
        } break;
        case 706:  if([button isSelected])
        {
            [obj setIndex:0];
             _isHideOtherTabs=NO;
        }
        else
        {
            [obj setIndex:4];
             _isHideOtherTabs=YES;
            
        } break;
        default: break;
    }
    [self updateTableViewCellAtIndexPath:indexPath];
    
    
    if (obj.index>=1)
        isRegistryFilled=TRUE;
    else
        isRegistryFilled=FALSE;
    
    for (NSMutableDictionary *dict in self.array_SegmentControl)
    {
        if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
        {
            if (isRegistryFilled)
                [dict setValue:@"True" forKey:@"isEmpty"];
            else
                [dict setValue:@"False" forKey:@"isEmpty"];
        }
    }
    
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
   
    
    
}


#pragma mark -
#pragma mark - SleepTimes Button Action

- (void)clickedButton:(UIButton *)btn forSleepTimesTableViewCell:(SleepTimesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    SleepTimesDataModal *obj = [eyl_AppDaya.array_SleepTimes objectAtIndex:indexPath.row];

    currentButton = btn;
    currentIndexPath=indexPath;
    switch (btn.tag) {
        case SleepTimesFeelAsleep:
            [self showDatePicker:cell withDate:obj.date_FellAsleep];break;
        case SleepTimesWokeUp:
            [self showDatePicker:cell withDate:obj.date_WokeUp];break;
        case SleepTimeSleptMins://[self showDatePicker:cell];
            break;
        case SleepTimesAdd:
            [self addRowsToSleepTimes:YES];break;
        case SleepTimesDelete:
        {
            // Delete Row
            [self disableUI];
            [eyl_AppDaya.array_SleepTimes removeObjectAtIndex:indexPath.row];
            [self deleteRowAndUpdateTableViewAtIndepath:indexPath];
            
            for (int i=0; i<eyl_AppDaya.array_SleepTimes.count; i++)
            {
                SleepTimesDataModal *objSTDM = [eyl_AppDaya.array_SleepTimes objectAtIndex:i];
                
                if (![objSTDM.strFellAsleep isEqualToString:@"00:00"])
                {
                    isSleepTimesFilled =TRUE;
                    break;
                }
                else
                    isSleepTimesFilled=FALSE;
                
                objSTDM=nil;
            }
            
            for (NSMutableDictionary *dict in self.array_SegmentControl)
              {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"sleep_times"])
                 {
                    if (isSleepTimesFilled)
                       [dict setValue:@"True" forKey:@"isEmpty"];
                    else
                       [dict setValue:@"False" forKey:@"isEmpty"];
                 }
              }

            [self.collectionView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - IHadMyBottle
-(void)textfieldDidBeginEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath : (NSIndexPath *) indexPath
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath
{

    IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:indexpath.row];
    
    if ([obj.strDateAt isEqualToString:@"00:00"])
    {
        [self.view makeToast:@"Please select Time first." duration:1.0f position:CSToastPositionBottom];
        field.text=@"";
        return NO;
    }
    else
    {
        return YES;
        
    }

}
-(void)textfieldDidEndEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:indexPath.row];
    
    if ([obj.strDateAt isEqualToString:@"00:00"])
    {
//        [self.view makeToast:@"Please select Time first." duration:1.0f position:CSToastPositionBottom];
//         field.text=@"";
    }
    
    else
    {
        
        IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:indexPath.row];

        obj.strDrank = field.text;
        
        obj=nil;
        
        [self.tableView reloadData];

    }

}
- (void) btnAction :(UIButton *) button forTableVIewCell : (IHadMyBottleTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath
{
    [self.tableView endEditing:YES];
    
    IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:indexPath.row];

    currentButton= button;
    currentIndexPath=indexPath;
    switch (button.tag) {
        case IHadMyBottleAt:
            [self showDatePicker:cell withDate:obj.date_DateAt];break;
        case IHadMyBottleDrank:
        {
           
        }
        case IHadMyBottleAdd:
            [self addRowsToIHadMyBottle:YES];break;
        case IHadMyBottleDelete:
        {
            // Delete Row
            [self disableUI];
            [eyl_AppDaya.array_IHadMyBottle removeObjectAtIndex:indexPath.row];
            [self deleteRowAndUpdateTableViewAtIndepath:indexPath];
            
            for (int i=0; i<eyl_AppDaya.array_IHadMyBottle.count; i++)
            {
                IHadMyBottleDataModal *objDD = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:i];
                if (![objDD.strDateAt isEqualToString:@"00:00"]) {
                    isIHadMyBottleFilled=TRUE;
                    break;
                }
                else
                    isIHadMyBottleFilled = FALSE;
                
            }
            
            // This is used to update collection View
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"i_had_my_bottle"])
                {
                    if (isIHadMyBottleFilled)
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    else
                        [dict setValue:@"False" forKey:@"isEmpty"];
                }
            }
            [self.collectionView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Show ItemPicker for I Had My Bottle
-(void) showItemPicker
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor whiteColor];

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 160, 44);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:UIColorFromRGM(164, 164, 81)];
    [popoverView addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(dismissItemPicker) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOk.frame = CGRectMake(160, 0, 160, 44);
    [btnOk setTitle:@"OK" forState:UIControlStateNormal];
    [btnOk setBackgroundColor:UIColorFromRGM(87, 88, 16)];
    [popoverView addSubview:btnOk];
    [btnOk addTarget:self action:@selector(btnOkItemPicker) forControlEvents:UIControlEventTouchUpInside];

    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame=CGRectMake(0,44,320, 216);
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [popoverView addSubview:pickerView];

    popoverContent.view = popoverView;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverController.delegate=self;
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
}

-(void) dismissItemPicker
{
    IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:currentIndexPath.row];

    if (currentButton.tag==602)
        obj.strDrank = @"0";

    obj=nil;

    [self.tableView reloadData];
    [popoverController dismissPopoverAnimated:YES];
    CGRect frame=self.view.frame;
    frame.origin.y=1;
    [self.view setFrame:frame];
}

-(void) btnOkItemPicker
{
    [popoverController dismissPopoverAnimated:YES];
    CGRect frame=self.view.frame;
    frame.origin.y=1;
    [self.view setFrame:frame];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [self.array_Picker count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  self.array_Picker[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:currentIndexPath.row];

    if (currentButton.tag==602)
        obj.strDrank = self.array_Picker[row];

    obj=nil;

    [self.tableView reloadData];
}


#pragma mark -
#pragma mark - Nappies
- (void) buttonAction : (UIButton *) button onNappiesCustomTableViewCell : (NappiesCustomTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath
{

    NappiesDataModal *obj = [eyl_AppDaya.array_nappiesRash objectAtIndex:indexPath.row];

    currentButton = button;
    currentIndexPath = indexPath;
    switch (button.tag) {
        case NappiesWhen:
            [self showDatePicker:cell withDate:obj.date_When];break;
        case NappiesDry:
            [self updateNappies:button atIndexPath:indexPath];break;
        case NappiesWet:
            [self updateNappies:button atIndexPath:indexPath];break;
        case NappiesSoiled:
            [self updateNappies:button atIndexPath:indexPath];break;
        case NappiesNappyRash:
            [self updateNappies:button atIndexPath:indexPath];break;
        case NappiesCreamApplied:
            [self updateNappies:button atIndexPath:indexPath];break;
        case NappiedAdd:
            [self addRowsToNappiesRash:YES];break;
        case NappiesDelete:
        {
            // Delete Row
            [self disableUI];
            [eyl_AppDaya.array_nappiesRash removeObjectAtIndex:indexPath.row];
            [self deleteRowAndUpdateTableViewAtIndepath:indexPath];
            
            for (int i=0; i<eyl_AppDaya.array_nappiesRash.count; i++)
            {
                
                NappiesDataModal *objNDM = [eyl_AppDaya.array_nappiesRash objectAtIndex:i];
                
                if (![objNDM.strWhen isEqualToString:@"00:00"])
                {
                    isNappiesFilled=TRUE;
                    break;
                }
                else if (objNDM.index>1)
                {
                    isNappiesFilled =TRUE;
                    break;
                }
                else if (objNDM.nappyRash || objNDM.creamApplied)
                {
                    isNappiesFilled = TRUE;
                    break;
                }
                else
                    isNappiesFilled=FALSE;

            }

            for (NSMutableDictionary *dict in self.array_SegmentControl)
              {
                 if ([[dict valueForKey:@"keyN"] isEqualToString:@"nappies"])
                  {
                     if (isNappiesFilled)
                        [dict setValue:@"True" forKey:@"isEmpty"];
                        else
                        [dict setValue:@"False" forKey:@"isEmpty"];
                    }
              }
            [self.collectionView reloadData];

        }
            break;
        default:
            break;
    }
}

-(void) updateNappies :(UIButton *) button atIndexPath :(NSIndexPath *) indexPath
{
    // Update Row
    NappiesDataModal *obj = [eyl_AppDaya.array_nappiesRash objectAtIndex:indexPath.row];

    switch (button.tag)
    {
        case NappiesDry: [obj setIndex:1]; break;
        case NappiesWet: [obj setIndex:2]; break;
        case NappiesSoiled: [obj setIndex:3]; break;
        case NappiesNappyRash:
        {
            if (obj.nappyRash)
                [obj setNappyRash:FALSE];
            else
                [obj setNappyRash:TRUE];
        }
            break;
        case NappiesCreamApplied:
        {
            if (obj.creamApplied)
                [obj setCreamApplied:FALSE];
            else
                [obj setCreamApplied:TRUE];

        }
            break;

        default:
            break;
    }
    [self updateTableViewCellAtIndexPath:indexPath];
    
    
    
    for (int i=0; i<eyl_AppDaya.array_nappiesRash.count; i++)
    {
        NappiesDataModal *objNR = [eyl_AppDaya.array_nappiesRash objectAtIndex:i];
        
        if (![objNR.strWhen isEqualToString:@"00:00"])
        {
            isNappiesFilled=TRUE;
            break;
        }
        else if (objNR.index>=1)
        {
            isNappiesFilled=TRUE;
            break;
        }
        else if (objNR.nappyRash || objNR.creamApplied)
        {
            isNappiesFilled=TRUE;
            break;
        }
        else
            isNappiesFilled=FALSE;
    }
    
        // This is used to update collection View
        for (NSMutableDictionary *dict in self.array_SegmentControl)
        {
            if ([[dict valueForKey:@"keyN"] isEqualToString:@"nappies"])
            {
                [dict setValue:@"True" forKey:@"isEmpty"];
            }
        }
        [self.collectionView reloadData];
    
}

#pragma mark -
#pragma mark - Toileting
- (void) buttonAction :(UIButton *) button forToiletingCustomTableViewCell : (ToiletingCustomTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath
{
    ToiletingDataModal *obj = [eyl_AppDaya.array_Toileting objectAtIndex:indexPath.row];

    currentButton = button;
    currentIndexPath = indexPath;
    switch (button.tag)
    {
        case ToiletingWhen:
            [self showDatePicker:cell withDate:obj.date_When];break;
        case ToiletingWentOnThePotty:
            [self updateCellForButton:button atIndexPath:indexPath];break;
        case ToiletingWentOntheToilet:
            [self updateCellForButton:button atIndexPath:indexPath];break;
        case ToiletingITried:
            [self updateCellForButton:button atIndexPath:indexPath];break;
        case ToiletingAdd:
            [self addRowsToToileting:YES];break;
        case ToiletingDelete:
        {
            // Delete Row
            [self disableUI];
            [eyl_AppDaya.array_Toileting removeObjectAtIndex:indexPath.row];
            [self deleteRowAndUpdateTableViewAtIndepath:indexPath];
            
            
            for (int i=0; i<eyl_AppDaya.array_Toileting.count; i++)
            {
                ToiletingDataModal *objTDM = [eyl_AppDaya.array_Toileting objectAtIndex:i];
                if (objTDM.index>1)
                {
                    isToiletingFilled=TRUE;
                    break;
                }
                else
                    isToiletingFilled=FALSE;
                
            }
            
            for (NSMutableDictionary *dict in self.array_SegmentControl)
              {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"toileting_today_1"])
                  {
                     if (isToiletingFilled)
                        [dict setValue:@"True" forKey:@"isEmpty"];
                      else
                        [dict setValue:@"False" forKey:@"isEmpty"];
                  }
              }
            [self.collectionView reloadData];
        }
            break;
        default:
            break;
    }
}
-(void) updateCellForButton : (UIButton *)button atIndexPath : (NSIndexPath *) indexPath
{
    ToiletingDataModal *obj = [eyl_AppDaya.array_Toileting objectAtIndex:indexPath.row];

    switch (button.tag)
    {
        case ToiletingWentOnThePotty:
            [obj setIndex:1]; break;
        case ToiletingWentOntheToilet:
            [obj setIndex:2]; break;
        case ToiletingITried:
            [obj setIndex:3]; break;
        default: break;
    }
    [self updateTableViewCellAtIndexPath:indexPath];
    
    
    if (!isToiletingFilled)
    {
        if (obj.index>1)
            isToiletingFilled=TRUE;
        
        for (NSMutableDictionary *dict in self.array_SegmentControl)
        {
            if ([[dict valueForKey:@"keyN"] isEqualToString:@"toileting_today_1"])
            {
                [dict setValue:@"True" forKey:@"isEmpty"];
            }
        }
        [self.collectionView reloadData];
    }
}

#pragma mark -
#pragma mark - UIPopover Delegate Methods

- (void) showDatePicker: (UITableViewCell *) cell withDate :(NSDate *) displayDate
{

    [self enableUI];
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];

    if ([@"registry" isEqualToString:strName])
    {
        RegistryDataModal *obj = [eyl_AppDaya.array_Registry objectAtIndex:currentIndexPath.row];
        if (currentButton.tag==702 && !obj.strCameAt ){
        [self.view makeToast:@"Please select Came in at time first." duration:1.0f position:CSToastPositionBottom];
            return;
        }
        obj=nil;
    }
    else if ([@"sleep_times" isEqualToString:strName])
    {
        SleepTimesDataModal *obj = [eyl_AppDaya.array_SleepTimes objectAtIndex:currentIndexPath.row];
        if (currentButton.tag==502 && [obj.strFellAsleep isEqualToString:@"00:00"])
        {
            [self.view makeToast:@"Please select Fell Asleep time first." duration:1.0f position:CSToastPositionBottom];
            return;
        }
        obj=nil;
    }


    self.memberCell = cell;
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController

    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor whiteColor];

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 160, 44);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:UIColorFromRGM(164, 164, 81)];
    [popoverView addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOk.frame = CGRectMake(160, 0, 160, 44);
    [btnOk setTitle:@"OK" forState:UIControlStateNormal];
    [btnOk setBackgroundColor:UIColorFromRGM(87, 88, 16)];
    [popoverView addSubview:btnOk];
    [btnOk addTarget:self action:@selector(btnOKAction) forControlEvents:UIControlEventTouchUpInside];

    datePicker=[[UIDatePicker alloc]init];//Date picker
    datePicker.frame=CGRectMake(0,44,320, 216);
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.timeZone= [NSTimeZone systemTimeZone];
    //datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    if (displayDate)
        [datePicker setDate:displayDate];
    else
        [datePicker setDate:[NSDate date]];

    //datePicker.maximumDate=[NSDate date];
    [datePicker setMinuteInterval:5];
    [datePicker setTag:10];
    [datePicker addTarget:self action:@selector(result) forControlEvents:UIControlEventValueChanged];
    [popoverView addSubview:datePicker];

    popoverContent.view = popoverView;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverController.delegate=self;
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
}

- (void) dismissPopover
{
    
    [popoverController dismissPopoverAnimated:YES];
    CGRect frame=self.view.frame;
    frame.origin.y=1
;
    [self.view setFrame:frame];
//    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
//
//    if ([[_keyArray[0] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//        RegistryDataModal *obj = [eyl_AppDaya.array_Registry objectAtIndex:currentIndexPath.row];
//
//        if (currentButton.tag==701)
//            obj.strCameAt = @"00:00";
//        else if (currentButton.tag==702)
//             obj.strLeftAt = @"00:00";
//
//        obj=nil;
//    }
//    else if ([[_keyArray[1] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//
//    }
//    else if ([[_keyArray[2] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//        SleepTimesDataModal *obj = [eyl_AppDaya.array_SleepTimes objectAtIndex:currentIndexPath.row];
//
//        if (currentButton.tag==501)
//        {
//            obj.strFellAsleep = @"00:00";
//            obj.date_FellAsleep = datePicker.date;
//        }
//        else if (currentButton.tag==502)
//        {
//            obj.strWokeUp = @"00:00";
//            obj.date_WokeUp= datePicker.date;
//            obj.strSleptMins = [NSDate getTimeDifferenceFromStartTime:obj.date_FellAsleep andEndTime:obj.date_WokeUp];
//        }
//        obj=nil;
//    }
//    else if ([[_keyArray[3] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//        IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:currentIndexPath.row];
//
//        if (currentButton.tag==601)
//            obj.strDateAt = @"00:00";
//
//        obj=nil;
//
//    }else if ([[_keyArray[4] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//        NappiesDataModal *obj = [eyl_AppDaya.array_nappiesRash objectAtIndex:currentIndexPath.row];
//
//        if (currentButton.tag==301) obj.strWhen = @"00:00";
//        obj=nil;
//    }else if ([[_keyArray[5] valueForKey:@"keyN"] isEqualToString:strName])
//    {
//        ToiletingDataModal *obj = [eyl_AppDaya.array_Toileting objectAtIndex:currentIndexPath.row];
//
//        if (currentButton.tag==801)
//            obj.str_When = @"00:00";
//        obj=nil;
//    }
//       [self.tableView reloadData];
}

-(void) btnOKAction
{
  
    [self setChangedValues];
    [popoverController dismissPopoverAnimated:YES];
    CGRect frame=self.view.frame;
    frame.origin.y=1;
    [self.view setFrame:frame];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[formatter setDateFormat:@"HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   // NSString *startTimeString = [formatter stringFromDate:datePicker.date];
}

-(void) result
{


}

-(void)setChangedValues{
    // Formatted Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"HH:mm"];

    NSString *strTime = [formatter stringFromDate:datePicker.date];
    
    // NSDate *gotDate=datePicker.date;
    //gotDate=[gotDate dateByAddingTimeInterval:60];
  //  NSString *StrOneMinuteMoreTime=[formatter stringFromDate:[datePicker.date dateByAddingTimeInterval:60]];

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];

    if ([@"registry"  isEqualToString:strName])
    {
        // Registry Date Picker Action
        
        RegistryDataModal *obj = [eyl_AppDaya.array_Registry objectAtIndex:currentIndexPath.row];

        if (currentButton.tag==701)
        {
            if ([obj.strLeftAt isEqualToString:@"00:00"])
            {
                obj.strCameAt = strTime;
                obj.date_CameAt = datePicker.date;
               // obj.strLeftAt=StrOneMinuteMoreTime;
                //obj.date_LeftAt=[datePicker.date dateByAddingTimeInterval:60];
                [self.view makeToast:@"Left time can not be less then Came in time."];
                
            }
            else
            {
                obj.strCameAt = strTime;
                obj.date_CameAt = datePicker.date;
                
            }
            
//            obj.strCameAt = strTime;
//            obj.date_CameAt = datePicker.date;
//            obj.strLeftAt=StrOneMinuteMoreTime;
//            obj.date_LeftAt=[datePicker.date dateByAddingTimeInterval:60];
//            [self.view makeToast:@"Left time can not be less then Came in time."];
            
            
            isRegistryFilled=TRUE;
            NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
            
            for (NSDictionary *dict in array)
            {
                NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
                
                if ([[mut valueForKey:@"keyN"] isEqualToString:@"registry"])
                {
                    if([mut objectForKey:@"isEmpty"])
                    {
                    [mut setValue:@"True" forKey:@"isEmpty"];
                    }
                }
                [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
                
            }
            [self.collectionView reloadData];
            
        }
        else if (currentButton.tag==702)
        {
            if (obj.strCameAt)
            {
                
                NSDate *inDate = [eyl_AppDaya getTimeFormatFromNSString:obj.strCameAt];
                NSDate *outDate = [eyl_AppDaya getTimeFormatFromNSDate:datePicker.date];
                
                
                NSComparisonResult result = [inDate compare:outDate];
                if(result == NSOrderedDescending)
                {
                    NSLog(@"inDate is later than outDate");
                    [self.view makeToast:@"Left time can not be less than Came in time."];
                    
                }
                else if(result == NSOrderedAscending)
                {
                    NSLog(@"outDate is later than inDate");
                    
                    if ([obj.strCameAt isEqualToString:strTime])
                    {
                        [self.view makeToast:@"Left time can not be same as Came in time."];
                        return;
                    }
                    
                    obj.strLeftAt = strTime;

                    
                    NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
                    
                    for (NSDictionary *dict in array)
                    {
                        NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
                        
                        if ([[mut valueForKey:@"keyN"] isEqualToString:@"registry"])
                        {
                            if([mut objectForKey:@"isEmpty"])
                            {
                                [mut setValue:@"True" forKey:@"isEmpty"];
                            }
                        }
                        [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
                    }
                    [self.collectionView reloadData];
                }
                else
                {
                    NSLog(@"inDate is equal to outDate");
                    [self.view makeToast:@"Left time can not be same as Came in time."];
                }
                
//                NSDate *cameAtDate = [eyl_AppDaya getNSDateFromHourMin:obj.strCameAt andDate:datePicker.date];
//
//                if ([Theme isDateGreaterThanDate:cameAtDate and:datePicker.date]) {
//                    obj.strLeftAt =strTime;
//                    obj.date_LeftAt = datePicker.date;
//                    
//                    for (NSDictionary *dict in self.array_SegmentControl)
//                    {
//                        if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
//                        {
//                            [dict setValue:@"True" forKey:@"isEmpty"];
//                        }
//                    }
//                    [self.collectionView reloadData];
//
//                }
//                else
//                {
//                    obj.strLeftAt=[formatter stringFromDate:[obj.date_CameAt dateByAddingTimeInterval:60]];
//                    obj.date_LeftAt=[obj.date_CameAt dateByAddingTimeInterval:60];
//                    [self.view makeToast:@"Left time can not be less then Came in time."];
//                }
            }
        }
        obj=nil;
    }
    else if ([@"what_i_ate_today" isEqualToString:strName])
    {

    }
    else if ([@"sleep_times" isEqualToString:strName])
    {
        
        // Sleep Times
        SleepTimesDataModal *obj = [eyl_AppDaya.array_SleepTimes objectAtIndex:currentIndexPath.row];

        if (currentButton.tag==501)
        {
            obj.date_FellAsleep = datePicker.date;
            obj.strFellAsleep = strTime;
           // obj.strWokeUp=StrOneMinuteMoreTime;
            //obj.date_WokeUp=[datePicker.date dateByAddingTimeInterval:60];
            obj.strSleptMins = [NSDate getTimeDifferenceFromStartTime:obj.date_FellAsleep andEndTime:obj.date_WokeUp];
            //[self.view makeToast:@"Woke Up time can not be less then Fell Asleep time."];
            
            NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
            
            for (NSDictionary *dict in array)
            {
                 NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
                
                if ([[mut valueForKey:@"keyN"] isEqualToString:@"sleep_times"])
                {
                    if([mut objectForKey:@"isEmpty"])
                    {
                        [mut setValue:@"True" forKey:@"isEmpty"];
                    }
                }
                [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
            }
        
            
            [self.collectionView reloadData];
        }
        else if (currentButton.tag==502)
        {
            if (obj.date_FellAsleep) {
                
                if ([Theme isDateGreaterThanDate:datePicker.date and:obj.date_FellAsleep]) {
                    obj.strWokeUp =strTime;
                    obj.date_WokeUp = datePicker.date;
                    obj.strSleptMins = [NSDate getTimeDifferenceFromStartTime:obj.date_FellAsleep andEndTime:obj.date_WokeUp];
                }else{
                    //  obj.strWokeUp=[formatter stringFromDate:[obj.date_FellAsleep dateByAddingTimeInterval:60]];
                    //   obj.date_WokeUp=[obj.date_FellAsleep dateByAddingTimeInterval:60];
                    [self.view makeToast:@"Woke Up time can not be less then Fell Asleep time."];
                    
                }
            }
            else
            {

              [self.view makeToast:@"Woke Up time can not be less then Fell Asleep time."];
            }
        }
      
        
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
        
        for (NSDictionary *dict in array)
        {
            NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
            
            if ([[mut valueForKey:@"keyN"] isEqualToString:@"sleep_times"])
            {
                if([mut objectForKey:@"isEmpty"])
                {
                    [mut setValue:@"True" forKey:@"isEmpty"];
                }
            }
            [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
        }
        
        [self.collectionView reloadData];
    [eyl_AppDaya.array_SleepTimes replaceObjectAtIndex:currentIndexPath.row withObject:obj];
        obj=nil;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName])
    {
        IHadMyBottleDataModal *obj = [eyl_AppDaya.array_IHadMyBottle objectAtIndex:currentIndexPath.row];

        if (currentButton.tag==601)
        {
            obj.strDateAt = strTime;
            obj.date_DateAt = datePicker.date;
        }
        // This is used to update collection View
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
        
        for (NSDictionary *dict in array)
        {
            NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
            
            if ([[mut valueForKey:@"keyN"] isEqualToString:@"i_had_my_bottle"])
            {
                if([mut objectForKey:@"isEmpty"])
                {
                    [mut setValue:@"True" forKey:@"isEmpty"];
                }
            }
            [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
        }
        
            
         
        
        [self.collectionView reloadData];

        obj=nil;

    }else if ([@"nappies" isEqualToString:strName])
    {
        NappiesDataModal *obj = [eyl_AppDaya.array_nappiesRash objectAtIndex:currentIndexPath.row];

        if (currentButton.tag==301)
        {
            obj.strWhen = strTime;
            obj.date_When = datePicker.date;
        }
        // This is used to update collection View
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
        
        for (NSDictionary *dict in array)
        {
            NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
            
            if ([[mut valueForKey:@"keyN"] isEqualToString:@"nappies"])
            {
                if([mut objectForKey:@"isEmpty"])
                {
                    [mut setValue:@"True" forKey:@"isEmpty"];
                }
            }
            [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
        }
        

          
        
        [self.collectionView reloadData];

        obj=nil;
    }else if ([@"toileting_today_1" isEqualToString:strName])
    {
        ToiletingDataModal *obj = [eyl_AppDaya.array_Toileting objectAtIndex:currentIndexPath.row];

        if (currentButton.tag==801)
        {
            obj.str_When = strTime;
            obj.date_When= datePicker.date;
        }
        
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.array_SegmentControl];
        
        for (NSDictionary *dict in array)
        {
           
            
            NSMutableDictionary *mut=[NSMutableDictionary dictionaryWithDictionary:dict];
            
            if ([[mut valueForKey:@"keyN"] isEqualToString:@"toileting_today_1"])
            {
                if([mut objectForKey:@"isEmpty"])
                {
                    [mut setValue:@"True" forKey:@"isEmpty"];
                }
            }
            [self.array_SegmentControl replaceObjectAtIndex:[self.array_SegmentControl indexOfObject:dict] withObject:mut];
        }
        
            

            [self.collectionView reloadData];

        obj=nil;
    }

    formatter=nil;
    strTime=nil;

    [self.tableView reloadData];
}

-(NSString *) getTimeDifferenceFromStartTime :(NSDate *) startTime andEndTime : (NSDate *) endTime
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSHourCalendarUnit fromDate:startTime toDate:endTime options:0];
    NSDateComponents *components1 = [c components:NSMinuteCalendarUnit fromDate:startTime toDate:endTime options:0];

    NSInteger remainingMinute = components1.minute - components.hour *60;

    return [NSString stringWithFormat:@"%.2ld:%.2ld", (long)components.hour, (long)remainingMinute];
}

#pragma mark -
#pragma mark - Add Empty Row and Reload TableView

-(void) addRowToRegistry :(BOOL) withAnimation
{

        RegistryDataModal *obj = [RegistryDataModal new];
        [obj setStrCameAt:[NSDate getFormattedDateString:@""]];
        [obj setStrLeftAt:[NSDate getFormattedDateString:@""]];
        [obj setIndex:0];

        [eyl_AppDaya.array_Registry addObject:obj];
        obj= nil;

        if (!withAnimation) return;
        [self addEmptyRowandReloadTableView:eyl_AppDaya.array_Registry];
}

-(void) addRowsToWhatIateToday
{
  
    if ([eyl_AppDaya.array_WhatIateToday count]) return;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:@"array_WhatIateTodayStatic"];
    
    for (int i=0; i<[array count]; i++)
    {
        WhatIateTodayModal *obj = [WhatIateTodayModal new];
        [obj setStrKey:[array objectAtIndex:i]];
        [obj setStrName:[eyl_AppDaya getObjectForKey:[array objectAtIndex:i]]];
        [obj setIndex:0];
        [eyl_AppDaya.array_WhatIateToday addObject:obj];
        obj=nil;
    }
    // This array can not be nil because after viewDidLoad this method is again called in ParseDailyDiary Data
//    array_ate =nil;
}

-(void) addRowsToSleepTimes : (BOOL) withAnimation
{
        SleepTimesDataModal *obj = [SleepTimesDataModal new];
        [obj setStrFellAsleep:[NSDate getFormattedDateString:@""]];
        [obj setStrWokeUp:[NSDate getFormattedDateString:@""]];
        [obj setStrSleptMins:[NSDate getFormattedDateString:@""]];

        [eyl_AppDaya.array_SleepTimes addObject:obj];
        obj= nil;

        if (!withAnimation) return;
        [self addEmptyRowandReloadTableView:eyl_AppDaya.array_SleepTimes];
}

- (void) addRowsToIHadMyBottle : (BOOL) withAnimation
{
        IHadMyBottleDataModal *obj = [IHadMyBottleDataModal new];
        [obj setStrDateAt:[NSDate getFormattedDateString:@""]];
        [obj setStrDrank:@"0"];
        [eyl_AppDaya.array_IHadMyBottle addObject:obj];
        obj=nil;

        if (!withAnimation) return;
        [self addEmptyRowandReloadTableView:eyl_AppDaya.array_IHadMyBottle];
}

- (void) addRowsToNappiesRash :(BOOL) withAnimation
{
        NappiesDataModal *obj = [NappiesDataModal new];
        [obj setStrWhen:[NSDate getFormattedDateString:@""]];
        [obj setIndex:0];
        [obj setNappyRash:FALSE];
        [obj setCreamApplied:FALSE];
        [eyl_AppDaya.array_nappiesRash addObject:obj];
        obj=nil;

        if (!withAnimation) return;
        [self addEmptyRowandReloadTableView:eyl_AppDaya.array_nappiesRash];
}

- (void) addRowsToToileting :(BOOL) withAnimation
{

    ToiletingDataModal *obj = [ToiletingDataModal new];
    [obj setStr_When:[NSDate getFormattedDateString:@""]];
    [eyl_AppDaya.array_Toileting addObject:obj];
    obj=nil;

    if (!withAnimation) return;
    [self addEmptyRowandReloadTableView:eyl_AppDaya.array_Toileting];
}

-(void) addRowToNotes
{
    NotesModal *obj = [[NotesModal alloc] init];
    obj.str_NotesToParents = @"";
    obj.str_NotesFromParents = @"";
    [eyl_AppDaya.array_Notes addObject:obj];
    obj=nil;
}

-(void) addComments
{
    DDCommentsModal *objDDC = [[DDCommentsModal alloc] init];
    [objDDC setStrRegistryComments:@""];
    [objDDC setStrToiletingTodayComments:@""];
    [objDDC setStrSleepTimesComments:@""];
    [objDDC setStrIHadMyBottleComments:@""];
    [objDDC setStrWhatIateTodayComments:@""];
    [objDDC setStrNappiesComments:@""];

     eyl_AppDaya = [EYL_AppData sharedEYL_AppData];
    [eyl_AppDaya.array_Comments addObject:objDDC];
    objDDC=nil;
    isComentsAdded=YES;
    
}

#pragma mark -
#pragma mark - Add Empty Row to TableView and Update

-(void) addEmptyRowandReloadTableView :(NSMutableArray *) array
{

    [self disableUI];
    [self.tableView beginUpdates];
    NSArray *paths;
    if([[array firstObject] isKindOfClass:[RegistryDataModal class]])
    {
     paths= [NSArray arrayWithObject:[NSIndexPath indexPathForRow:array.count-1 inSection:1]];
    }
    else
    {
    paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:array.count-1 inSection:0]];
    }
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self enableUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self enableUI];
    });
}

#pragma mark -
#pragma mark - Update TableView Cell after user perform some activity

- (void) updateTableViewCellAtIndexPath : (NSIndexPath *) indexPath
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}
#pragma mark -
#pragma mark - Delete Row after user tap on delete button

-(void) deleteRowAndUpdateTableViewAtIndepath :(NSIndexPath *) indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self enableUI];

    });
    
    
}

#pragma mark -
#pragma mark - SegmentIndex Did Change
- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {

    [self.textView_Notes setText:@""];
    [self.view endEditing:TRUE];
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.segmentControl.selectedSegmentIndex] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array = [_keyArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0)
    {
        [self.tableView setHidden:FALSE];
        [self.textView_Notes setHidden:FALSE];
        [self.tableView reloadData];
    }
    else{
        [self.tableView setHidden:TRUE];
        [self.textView_Notes setHidden:TRUE];
        [self.btn_NotesToParents setSelected:TRUE];
        [self.btn_NotesFromParents setSelected:FALSE];

        NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
        [self.textView_Parents setText:obj.str_NotesToParents];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lblPlaceHoldaer.hidden=YES;
    
    
}
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![self.textView_Parents hasText]) {
        lblPlaceHoldaer.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![self.textView_Parents hasText]) {
        lblPlaceHoldaer.hidden = NO;
    }
    else{
        lblPlaceHoldaer.hidden = YES;
    }  
}
- (IBAction)buttonParentsAction:(UIButton *)sender
{
    [self.view endEditing:YES];
   
   
    switch (sender.tag) {
        case ANNotesToParents:
        {
            if (self.isDailyDiaryPublished)
                [self.textView_Parents setUserInteractionEnabled:FALSE];
            else
                [self.textView_Parents setUserInteractionEnabled:TRUE];
            
            if ([self.btn_NotesToParents isSelected])
            {
                lblPlaceHoldaer.text=@"Notes to Parents";
                
                
            }else
            {
                lblPlaceHoldaer.text=@"Notes to Parents";
                [self.btn_NotesToParents setSelected:TRUE];
                [self.btn_NotesFromParents setSelected:FALSE];
            }
            saveTextFromParents= FALSE;

            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            if (isEditingEnable) {
                if (self.textView_Parents.text.length>0)
                {
                    obj.str_NotesFromParents = self.textView_Parents.text;
                    //self.textView_Parents.text=@"";
                    
                }
                [self.textView_Parents setText:obj.str_NotesToParents];

            }else{
                if (obj.str_NotesToParents) {
                    [self.textView_Parents setText:obj.str_NotesToParents];
                }
            }
        }
            if(![self.textView_Parents hasText]) {
                lblPlaceHoldaer.hidden = NO;
            }
            else{
                lblPlaceHoldaer.hidden = YES;
            }
            break;
        case ANNotesFromParents:
        {
            [self.textView_Parents setUserInteractionEnabled:FALSE];

            if ([self.btn_NotesFromParents isSelected]) {
                lblPlaceHoldaer.text=@"Notes from Parents";
               
               
            }else{
                
                
                 lblPlaceHoldaer.text=@"Notes from Parents";
                [self.btn_NotesToParents setSelected:FALSE];
                [self.btn_NotesFromParents setSelected:TRUE];
            }
            saveTextFromParents= TRUE;


            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            if (isEditingEnable) {
                if (self.textView_Parents.text.length>0)
                {
                    obj.str_NotesToParents = self.textView_Parents.text;
                    self.textView_Parents.text=@"";
                  

                }
                [self.textView_Parents setText:obj.str_NotesFromParents];

            }else{
                if (obj.str_NotesFromParents) {
                    [self.textView_Parents setText:obj.str_NotesFromParents];
                }
            }
            if(![self.textView_Parents hasText]) {
                
    
                lblPlaceHoldaer.hidden = NO;
            }
            else{
                
                for(UIView *view in self.textView_Parents.subviews)
                {
                    if([view isKindOfClass:[UILabel class]])
                    {
                        UILabel *lbl=(UILabel *)view;
                        
                        if([lbl.text isEqualToString:@"Notes from Parents"])
                        {
                            [lbl setHidden:YES];
                            
                        }
                        
                    }
                }
                lblPlaceHoldaer.hidden = YES;
            }

        }
            
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark - TextView Delegate Methods

- (void) addKeyboardNotification
{
//     [self.tableView reloadData];
//     [self.collectionView reloadData];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];

   // [[NSNotificationCenter defaultCenter] addObserver:self
                                             //selector:@selector(keyboardDidHide:)
                                           //      name:@"UIKeyboardDidHideNotification"
                                            //   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
  
    //UIKeyboardWillHideNotification
    //UIKeyboardDidShowNotification
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

}
- (void) keyboardWillHide:(NSNotification *)note {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.0 animations:^{
        self.view.frame = frame;
        
        
    }];    DDCommentsModal *obj = [eyl_AppDaya.array_Comments objectAtIndex:0];
    
    
    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    if ([@"registry" isEqualToString:strName])
    {
        obj.strRegistryComments = self.textView_Notes.text;
    }
    else if ([@"what_i_ate_today" isEqualToString:strName]){
        // 1 - What I ate Today
        obj.strWhatIateTodayComments = self.textView_Notes.text;
    }
    else if ([@"sleep_times" isEqualToString:strName]){
        // 2 - Sleep Times
        obj.strSleepTimesComments = self.textView_Notes.text;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName]){
        // 3 - I had my Bottle
        obj.strIHadMyBottleComments = self.textView_Notes.text;
    }
    else if ([@"nappies" isEqualToString:strName]){
        // 4 - Nappies
        obj.strNappiesComments = self.textView_Notes.text;
    }
    else if ([@"toileting_today_1" isEqualToString:strName]){
        // 5 - Toileting
        obj.strToiletingTodayComments = self.textView_Notes.text;
    }
    else
    {
        // This case is for Saving the comments from Parents and To Parents
        if ([self.btn_NotesToParents isSelected])
        {
            NSLog(@"Notes To Parents");
            
            if (self.textView_Parents.text.length==0)
                
                isNotesToParentsFilled=FALSE;
            else
                isNotesToParentsFilled=TRUE;
            
            
            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            obj.str_NotesToParents = self.textView_Parents.text;
            
            // Update the tag here
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"additionalnotes"])
                {
                    if (isNotesToParentsFilled)
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    else
                        [dict setValue:@"False" forKey:@"isEmpty"];
                }
            }
            [self.collectionView reloadData];
            
            
        }
        else if([self.btn_NotesFromParents isSelected])
        {
            NSLog(@"Notes From Parents");
            
            if (self.textView_Parents.text.length==0) return;
            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            obj.str_NotesFromParents = self.textView_Parents.text;
        }
    }
    
    obj=nil;

    
}


- (void) keyboardDidHide:(NSNotification *)note {

    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.0 animations:^{
        self.view.frame = frame;
        
        
    }];    DDCommentsModal *obj = [eyl_AppDaya.array_Comments objectAtIndex:0];


    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    if ([@"registry" isEqualToString:strName])
    {
        obj.strRegistryComments = self.textView_Notes.text;
    }
    else if ([@"what_i_ate_today" isEqualToString:strName]){
        // 1 - What I ate Today
        obj.strWhatIateTodayComments = self.textView_Notes.text;
    }
    else if ([@"sleep_times" isEqualToString:strName]){
        // 2 - Sleep Times
        obj.strSleepTimesComments = self.textView_Notes.text;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName]){
        // 3 - I had my Bottle
        obj.strIHadMyBottleComments = self.textView_Notes.text;
    }
    else if ([@"nappies" isEqualToString:strName]){
        // 4 - Nappies
        obj.strNappiesComments = self.textView_Notes.text;
    }
    else if ([@"toileting_today_1" isEqualToString:strName]){
        // 5 - Toileting
        obj.strToiletingTodayComments = self.textView_Notes.text;
    }
    else
    {
        // This case is for Saving the comments from Parents and To Parents
        if ([self.btn_NotesToParents isSelected])
        {
            NSLog(@"Notes To Parents");

            if (self.textView_Parents.text.length==0)
                isNotesToParentsFilled=FALSE;
            else
                isNotesToParentsFilled=TRUE;
                

            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            obj.str_NotesToParents = self.textView_Parents.text;
            
            // Update the tag here
            for (NSMutableDictionary *dict in self.array_SegmentControl)
             {
               if ([[dict valueForKey:@"keyN"] isEqualToString:@"additionalnotes"])
                 {
                     if (isNotesToParentsFilled)
                         [dict setValue:@"True" forKey:@"isEmpty"];
                     else
                         [dict setValue:@"False" forKey:@"isEmpty"];
                 }
             }
              [self.collectionView reloadData];
            
            
        }
        else if([self.btn_NotesFromParents isSelected])
        {
            NSLog(@"Notes From Parents");

            if (self.textView_Parents.text.length==0) return;
            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            obj.str_NotesFromParents = self.textView_Parents.text;
        }
    }

    obj=nil;

    // move the view back to the origin
  
}

- (void) keyboardWillShow:(NSNotification *)note {

    if (self.textView_Parents.isFirstResponder)
        return;
    if(self.textView_Notes.isFirstResponder)
    {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
   
    
    frame.origin.y=0;
    if (isLandscape) {
//        frame.origin.y =-kbSize.width;
        frame.origin.y = -kbSize.height;

    }else{
        frame.origin.y=-kbSize.height;
    }

    [UIView animateWithDuration:0.3 animations:^{
        
        NSLog(@"Before %@",self.view);
        
        [self.view setFrame:frame];
              NSLog(@"After %@",self.view);
        
        
    }];
    }
    else
    {
    
    
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        isLandscape=YES;
    }else{
        isLandscape=NO;
    }
}
- (void) orientationChanged:(NSNotification *)note
{

     [self resignFirstResponder];
    UIDevice * device = note.object;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"check width %f and checking Height %f",screenWidth,screenHeight);
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
        case UIDeviceOrientationLandscapeLeft:

            break;
        case UIDeviceOrientationLandscapeRight:
            break;
        default:
            break;
    };


}

-(void)submitInDailyDiaryVC:(id)sender{

    NSLog(@"Publish Called");
    [self createDiaryDataWithMode:@"submitted"];

}

-(void)saveAsDraftInDailyDiaryVC:(id)sender
{

    DDCommentsModal *obj = [eyl_AppDaya.array_Comments objectAtIndex:0];

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    if ([@"sleep_times" isEqualToString:strName])
    {
        obj.strSleepTimesComments = self.textView_Notes.text;
    }
    [self createDiaryDataWithMode:@"draft"];
}



-(void)createDiaryDataWithMode:(NSString *)mode{

    APICallManager *objManager = [APICallManager sharedNetworkSingleton];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeText;
    
    if([mode isEqualToString:@"draft"])
    {
        hud.labelText = @"Saving Daily Diary";

    }
    else
    {
        hud.labelText = @"Publishing Daily Diary";

    }
      hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate =self;
    
    
    // Insert Last Record of Registry in the local Database
    NSMutableArray *temp_Registry = [[NSMutableArray alloc] init];
    RegistryDataModal *modal=[eyl_AppDaya.array_registryStatus firstObject];
    
    if(modal.index==0)
    {
    
    }
    else
    {
        
    for (RegistryDataModal *obj in eyl_AppDaya.array_Registry)
    {
        
         if ([obj.strCameAt isEqualToString:@"00:00"] && [obj.strLeftAt isEqualToString:@"00:00"]&&obj.index==0)
         {
         
         }
        else
        {
        NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 obj.strCameAt,@"came_in_at",
                                 obj.strLeftAt,@"left_at",
                                 [NSString stringWithFormat:@"%ld",(long)obj.index],@"registry_status",
                                 nil];
        
        [temp_Registry addObject:theDict];
        theDict=nil;
            
        if ( [obj isEqual:[eyl_AppDaya.array_Registry lastObject]])
        {
            
            if ([obj.strCameAt isEqualToString:@"00:00"] && [obj.strLeftAt isEqualToString:@"00:00"])
                break;
            else if (![eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                break;
            
            
            // Calculate the Date Difference
            // Get current date/time
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // display in HH:mm:ss local time zone
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateFormat:@"dd:MM:yy HH:mm:ss z"];
            NSString *currentTime = [dateFormatter stringFromDate:date];
            NSLog(@"Current Date Time:%@",currentTime);
            
            // Get the year, month, day from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            // Create the date
            NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            // display in HH:mm:ss local time zone
            [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
            NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
            NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
            
            
            // Now Calculating the time difference
            NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
            NSDate *newDate = [dateFormatter dateFromString:currentTime];
            NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
            // NSInteger timeDiff = diff;
            // NSLog(@"Time Difference %ld", (long)x);
            
            dateFormatter = nil;
            dateFormatter1=nil;
            
            NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
            NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          objManager.cacheChild.childId,@"childid",
                                          self.strCurrentDate,@"date",
                                          obj.strCameAt,@"intime",
                                          obj.strLeftAt,@"outtime",
                                          @"1", @"uploadedflag",
                                          [NSNumber numberWithInteger:diff],@"timedifference",
                                          num,@"uniqueTableID",nil];
            
            [ChildInOutTime createChildInOutTimeContext:[AppDelegate context] withDictionary:dict];
            
            dict=nil;
        }
    }
    }
}

    NSMutableDictionary *temp_WhatIateToday =[[NSMutableDictionary alloc] init];


    for (WhatIateTodayModal *obj in eyl_AppDaya.array_WhatIateToday)
    {
        if (obj.strKey.length!=0 || obj.strName.length!=0||obj.index!=0)
        {
            NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     
                                     [NSString stringWithFormat:@"%d",obj.index],obj.strKey,nil];
            [temp_WhatIateToday addEntriesFromDictionary:theDict];
            theDict=nil;
        }
        else
        {
        
        
            
        
        }
    }

    // JSON Comments
    DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
    NSDictionary *temp_Comments = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   objDD.strRegistryComments,@"registry_comments",
                                   objDD.strNappiesComments,@"nappies_comments",
                                   objDD.strWhatIateTodayComments,@"what_i_ate_comments",
                                   objDD.strIHadMyBottleComments,@"i_had_my_bottle_comments",
                                   objDD.strToiletingTodayComments,@"toileting_comments",
                                   objDD.strSleepTimesComments,@"sleep_times_comments", nil];

    // JSON Notes
    
    //obj.str_NotesFromParents,@"notes_from_parents",
    NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
    NSDictionary *temp_Notes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:obj.str_NotesToParents,@"notes_to_parents",nil];
    obj=nil;

    NSMutableArray *temp_SleepTimes = [[NSMutableArray alloc] init];
    for (SleepTimesDataModal *obj in eyl_AppDaya.array_SleepTimes)
    {
        if(![obj.strFellAsleep isEqualToString:@"00:00"]||obj.strSleptMins.length==0||![obj.strWokeUp isEqualToString:@"00:00"])
        {
            NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:obj.strFellAsleep,@"fell_asleep",obj.strWokeUp,@"woke_up", nil];
            
            [temp_SleepTimes addObject:theDict];
            theDict=nil;
        }
        else
        {
        // NSString *strFellAsleep;
//        @property (strong, nonatomic) NSString *strWokeUp;
      //  @property (strong, nonatomic) NSDate *date_FellAsleep;
     //  @property (strong, nonatomic) NSDate *date_WokeUp;
       // @property (strong, nonatomic) NSString *strSleptMins;
      
        }
    }

    // I had my bottle
    NSMutableArray *temp_IhadMyBottle = [[NSMutableArray alloc] init];
    for (IHadMyBottleDataModal *obj in eyl_AppDaya.array_IHadMyBottle)
    {
        if(![obj.strDateAt isEqualToString:@"00:00"]||![obj.strDrank isEqualToString:@"0"])
        {
            NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:obj.strDateAt,@"at",obj.strDrank,@"drank", nil];
            
            [temp_IhadMyBottle addObject:theDict];
            theDict=nil;
        }
        else
        {
       
        }
    }

    // Nappies
    NSMutableArray *temp_Nappies= [[NSMutableArray alloc] init];
    for (NappiesDataModal *obj in eyl_AppDaya.array_nappiesRash)
    {
        if(![obj.strWhen isEqualToString:@"00:00"]||obj.nappyRash==YES||obj.creamApplied==YES||obj.index!=0)
        {
            int creamApplied = (obj.creamApplied) ? 1 : 0;
            int nappyRash = (obj.nappyRash) ? 1 : 0;
            
            NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     obj.strWhen,@"nappies_when",
                                     [NSString stringWithFormat:@"%d", nappyRash], @"nappy_rash",
                                     [NSString stringWithFormat:@"%d", creamApplied], @"cream_applied",
                                     [NSString stringWithFormat:@"%d", obj.index], @"nappies_option", nil];
            
            [temp_Nappies addObject:theDict];
            theDict=nil;

        }
        else
        {
       }
    }
    // Toileting
    NSMutableArray *temp_Toileting= [[NSMutableArray alloc] init];
    for (ToiletingDataModal *obj in eyl_AppDaya.array_Toileting)
    {
        if(![obj.str_When isEqualToString:@"00:00"]||obj.index!=0)
        {
            NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     obj.str_When,@"when",
                                     [NSString stringWithFormat:@"%ld",(long)obj.index],@"toilet_option", nil];
            
            [temp_Toileting addObject:theDict];
            theDict=nil;
        }
        else
        {
       
        }
    }
   // NSString *inTime=[[temp_Registry lastObject] objectForKey:@"came_in_at"];
    //NSString *outTime=[[temp_Registry lastObject] objectForKey:@"left_at"];
    
    avoidWrinting=self.strCurrentDate;
    
    NSMutableDictionary *dictionary=[NSMutableDictionary new];
    
    if(_isComeFromNotesNotifcation)
    {
      [dictionary setObject:self.childID forKey:@"child_id"];
    }
    else
    {
    [dictionary setObject:objManager.cacheChild.childId forKey:@"child_id"];
    }
    [dictionary setObject: self.strCurrentDate forKey:@"date_time" ];
    NSString *str1;
    NSString *str2;
    if([[temp_Registry lastObject] objectForKey:@"came_in_at"]==nil)
    {
    str1=@"";
    }
    else
    {
        str1=[[temp_Registry lastObject] objectForKey:@"came_in_at"];
    }
    [dictionary setObject:str1 forKey:@"came_in_at"];
    
    if([[temp_Registry lastObject] objectForKey:@"left_at"]==nil)
    {
        str2=@"";
    }
    else
    {
        str2=[[temp_Registry lastObject] objectForKey:@"left_at"];
    }
    [dictionary setObject:str2 forKey:@"left_at"];
    [dictionary setObject:[NSString stringWithFormat:@"DailyDiary%f", [[NSDate date] timeIntervalSince1970] *1000] forKey:@"uniquediaryid"];
    [dictionary setObject:temp_Registry forKey:@"registry"];
    
    [dictionary setObject:temp_WhatIateToday forKey:@"what_i_ate_today"];
    
    [dictionary setObject:temp_Comments forKey:@"comments"];
    
    [dictionary setObject:temp_Notes forKey:@"notes"];
    
    [dictionary setObject:temp_SleepTimes forKey:@"sleep_times"];
    
    [dictionary setObject:temp_IhadMyBottle forKey:@"i_had_my_bottle"];
    
    [dictionary setObject:temp_Nappies forKey:@"nappies"];
    
    [dictionary setObject:temp_Toileting forKey:@"toileting"];
    
    [dictionary setObject:mode forKey:@"mode"];

    NSMutableDictionary *final_Dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             objManager.apiKey,@"api_key",
                                             objManager.apiPassword,@"api_password",
                                             objManager.cachePractitioners.pin,@"practitioner_pin",
                                             [NSString stringWithFormat:@"%@",objManager.cachePractitioners.eylogUserId],@"practitioner_id",
                                             dictionary,@"data",
                                             nil];


    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:final_Dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    

    
if([[APICallManager sharedNetworkSingleton] isNetworkReachable])
{
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        [self callPostRegistryAndDictionaryForDailyDiary:final_Dictionary];
        [self postDailyDiaryObservations:final_Dictionary];
       
        
    }
}
    else
    {
     [self callPostRegistryAndDictionaryForDailyDiary:final_Dictionary];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *nonMutableArray= [standardUserDefaults objectForKey:@"storedDataForDailyDiary"];
    NSMutableArray *array=[NSMutableArray arrayWithArray:nonMutableArray];
    
    if(array==nil)
    {
     array=[NSMutableArray new];
    }
        
    [array addObject:final_Dictionary];
    [standardUserDefaults setObject:array forKey:@"storedDataForDailyDiary"];
   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
   [appDelegate.window makeToast:@"Daily Diary saved Successfully" duration:1.0 position:CSToastPositionCenter];
   [self.navigationController popViewControllerAnimated:YES];
        

    }
    
    // This String Will convert Dictionary in JSON Object
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}
-(void)callPostDailyDiary
{
    
    NSMutableArray *dummyArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedDataForDailyDiary"]];
    Reachability *reachability;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus !=NotReachable)
    {
        if(dummyArray.count>0)
        {
            for (int i=0; i<dummyArray.count; i++) {
                
                [self postDailyDiaryObservations:[dummyArray objectAtIndex:i]];
                
            }
        }

    }
  }
-(void)callPostRegistryAndDictionaryForDailyDiary:(NSDictionary *)dictionary
{
    NSMutableArray *temp_Registry=[NSMutableArray new];
    NSMutableDictionary * dict;
     NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
    
    NSString *str=@"";
    RegistryDataModal *obj=[eyl_AppDaya.array_registryStatus firstObject];
    [[NSUserDefaults standardUserDefaults] setObject:obj.clientTimeStamp forKey:@"registry_status_timestamp"];
    
    DDCommentsModal *objDD = [eyl_AppDaya.array_Comments objectAtIndex:0];
    
    NSMutableArray *arrayDeleted=[NSMutableArray new];
    for(int i =0;i<eyl_AppDaya.array_registryDeleted.count;i++)
    {
        RegistryDataModal *modal=[eyl_AppDaya.array_registryDeleted objectAtIndex:i];
        if(modal.clientTimeStamp.length>0)
        {
        [arrayDeleted addObject:modal.clientTimeStamp];
        }
        
        
    }

    if(obj.index!=0)
    {
        
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword,@"api_password",[NSString stringWithFormat:@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId],@"practitioner_id",[APICallManager sharedNetworkSingleton].cachePractitioners.pin,@"practitioner_pin",[APICallManager sharedNetworkSingleton].cacheChild.childId,@"child_id",[NSString stringWithFormat:@"%d",obj.index],@"registry_status",self.strCurrentDate,@"date",uniqueTabletOIID,@"tabletuid",nil];
        [dict setObject:obj.clientTimeStamp forKey:@"registry_status_timestamp"];
        [dict setObject:objDD.strRegistryComments forKey:@"notes"];
        if(arrayDeleted.count>0)
        {
            [dict setObject:arrayDeleted forKey:@"delete_registry_timestamp"];

        }
        
      
        
        [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:nil andOutTime:nil andRegistryStatus:[NSNumber numberWithInteger:obj.index] forContext:[AppDelegate context]];
        
    }
    else
    {
        
        for (RegistryDataModal *obj in eyl_AppDaya.array_Registry)
        {
            
            if ([obj.strCameAt isEqualToString:@"00:00"] && [obj.strLeftAt isEqualToString:@"00:00"]&&obj.index==0)
            {
                
            }
            else
            {
                NSString *str;
                if(obj.clientTimeStamp.length>0)
                {
                  str =obj.clientTimeStamp;
                }
                else
                {
                str=@"";
                    
                }
                
                NSDictionary *theDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         obj.strCameAt,@"came_in_at",
                                         obj.strLeftAt,@"left_at",
                                         str,@"clienttimestamp",
                                         nil];
                
                [temp_Registry addObject:theDict];
                theDict=nil;
                
                if ( [obj isEqual:[eyl_AppDaya.array_Registry lastObject]])
                {
                    
                    if ([obj.strCameAt isEqualToString:@"00:00"] && [obj.strLeftAt isEqualToString:@"00:00"])
                        break;
                    
//                    else if (![eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
//                        break;
                    
                    
                    // Calculate the Date Difference
                    // Get current date/time
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    // display in HH:mm:ss local time zone
                    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                    [dateFormatter setDateFormat:@"dd:MM:yy HH:mm:ss z"];
                    NSString *currentTime = [dateFormatter stringFromDate:date];
                    NSLog(@"Current Date Time:%@",currentTime);
                    
                    // Get the year, month, day from the date
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
                    // Set the hour, minute, second to be zero
                    components.hour = 0;
                    components.minute = 0;
                    components.second = 0;
                    // Create the date
                    NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
                    
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    // display in HH:mm:ss local time zone
                    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
                    [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
                    NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
                    NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
                    
                    
                    // Now Calculating the time difference
                    NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
                    NSDate *newDate = [dateFormatter dateFromString:currentTime];
                    NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
                    // NSInteger timeDiff = diff;
                    // NSLog(@"Time Difference %ld", (long)x);
                    
                    dateFormatter = nil;
                    dateFormatter1=nil;
                    
                    
                    [ChildInOutTime createChildInOutTimeContext:[AppDelegate context] withDictionary:dict];
                    
                    
                }
            }
        }
        
       // int inte=0;
        
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[APICallManager sharedNetworkSingleton].apiKey,@"api_key",[APICallManager sharedNetworkSingleton].apiPassword,@"api_password",[NSString stringWithFormat:@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId],@"practitioner_id",[APICallManager sharedNetworkSingleton].cachePractitioners.pin,@"practitioner_pin",[APICallManager sharedNetworkSingleton].cacheChild.childId,@"child_id",temp_Registry,@"registry",self.strCurrentDate,@"date",uniqueTabletOIID,@"tabletuid",[[NSUserDefaults standardUserDefaults] objectForKey:@"registry_status_timestamp"],@"registry_status_timestamp",nil];
        [dict setObject:@""forKey:@"registry_status"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"registry_status_timestamp"]!=nil)
        {
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"registry_status_timestamp"] forKey:@"delete_registry_status_timestamp"];
        }
        
         [dict setObject:objDD.strRegistryComments forKey:@"notes"];
        if(arrayDeleted.count>0)
        {
            [dict setObject:arrayDeleted forKey:@"delete_registry_timestamp"];
            
        }
        
        
        
        NSDictionary *newDictionary=[temp_Registry lastObject];
        
         [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:[newDictionary objectForKey:@"came_in_at"] andOutTime:[newDictionary objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
    }
    
    
//  if(eyl_AppDaya.array_registryStatus.count==0 && eyl_AppDaya.array_Registry.count==0 )
//  {
//      NSLog(@"No change in registry");
//      
//  
//  }
   // else
   // {
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        
        //Internet is Available
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        NSString *urlString=[NSString stringWithFormat:@"%@api/registry/updateregistry",serverURL];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:dict withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to post data on the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [self closeAlert];
                
                if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt andRegistryStatus:nil forContext:[AppDelegate context]];
                    
                    obk=nil;
                }
                
                
                return;
            }
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            if(dictionary!=nil)
            {
                [self postDailyDiaryObservations:dictionary];
                
            }
            [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                {
                [appDelegate.window makeToast:@"Registry saved Successfully" duration:1.0 position:CSToastPositionCenter];
                
                //[containerView clearText];
                // Here Delete the Records from local Database because they are already updated to the server
                
                [self deleteRecordFromLocalDB];
                
                if ([avoidWrinting isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
                    NSDictionary *dic= [[dict objectForKey:@"registry"] lastObject];
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]],@"childid",
                                                  self.strCurrentDate,@"date",
                                                  [dic objectForKey:@"came_in_at"],@"intime",
                                                  [dic objectForKey:@"left_at"],@"outtime",
                                                  @"1", @"uploadedflag",
                                                  [NSNumber numberWithInt:[uniqueTabletOIID intValue]],@"uniqueTableID",nil];
//                    DDCommentsModal *modal=[eyl_AppDaya.array_Comments firstObject];
//                    modal.strRegistryComments=[dict objectForKey:@"notes"];
//                    [eyl_AppDaya.array_Comments replaceObjectAtIndex:0 withObject:modal];
                    
                    
//                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime: [dic objectForKey:@"came_in_at"] andOutTime:[dic objectForKey:@"left_at"] andRegistryStatus:nil  forContext:[AppDelegate context]];
                    
//                    [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] withDate:self.strCurrentDate];
                    obk=nil;
                }
                
                             
                //                if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                //                {
                //                     RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
                //                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt forContext:[AppDelegate context]];
                //                    obk=nil;
                //                }
                
                if (self.loadDailyDiary)
                {
                    [containerView setLabelMenu:@""];
                    self.loadDailyDiary=FALSE;
                    selectedIndex=0;
                    NSString *dateString = [eyl_AppDaya getDateFromNSDate:selectedDate];
                    self.strCurrentDate=dateString;
                    
                   // [self clearAllArrays];
                    [self.collectionView reloadData];
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"Loading Daily Dairy and Registry";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.delegate =self;

                    [self getDailyDiary:dateString];
                    [self getRegistry:dateString];
                    
                    
                }
                else
                {
                
                }
                }
                else
                {
                    NSLog(@"Registry not updated");
                    
                }
                    //[self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
        [postDataTask resume];
    }
    else
    {
      
       
        
        NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dict];
        
        [RegistryDataEntity createRowInContext:[AppDelegate context] withUid:[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] withJsonDict:myData withdateStr:self.strCurrentDate withDate:nil withChildId:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]]];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [appDelegate.window makeToast:@"Registry saved Successfully" duration:1.0 position:CSToastPositionCenter];
       // [self.navigationController popViewControllerAnimated:YES];
    }
   // }

}
-(void)postDailyDiaryObservations : (NSDictionary *) inputDictionary
{
    
//    {
//        
//        "api_key": "ey-trunk-5",
//        
//        "api_password": "ZXlsb2c=",
//        
//        "child_id" : 703,
//        
//        "practitioner_id" : 300,
//        
//        "date":"2016-03-07",
//        
//        "practitioner_pin":"kQFVqzm6jdtobPGwUXT1a9weLuLVtL+QzI8sTiM/Va0=",
//        
//        "registry_status":"2"
//    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    NSLog(@"Current Date Time:%@",currentTime);
    
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    // Set the hour, minute, second to be zero
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // Create the date
    NSDate *dateWithZeroHourandMin = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    // display in HH:mm:ss local time zone
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd:MM:yy HH:mm:ss z"];
    NSString *currentTime1 = [dateFormatter1 stringFromDate:dateWithZeroHourandMin];
    NSLog(@"Today time with Zero Hour and Minute :%@",currentTime1);
    
    
    // Now Calculating the time difference
    NSDate *startDate = [dateFormatter1 dateFromString:currentTime1];
    NSDate *newDate = [dateFormatter dateFromString:currentTime];
    NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
    // NSInteger timeDiff = diff;
    // NSLog(@"Time Difference %ld", (long)x);
    
    dateFormatter = nil;
    dateFormatter1=nil;
    
    NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
    NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        //Internet is Available
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary",serverURL];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to post data on the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
                if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt andRegistryStatus:nil forContext:[AppDelegate context]];
                    
                    obk=nil;
                }
                
                
                return;
            }
            
            [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [appDelegate.window makeToast:@"Daily Diary saved Successfully" duration:1.0 position:CSToastPositionCenter];
                
                //[containerView clearText];
                // Here Delete the Records from local Database because they are already updated to the server
                
                [self deleteRecordFromLocalDB];
                
//                if ([avoidWrinting isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
//                {
//                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
//                    NSDictionary *dic= [[[inputDictionary objectForKey:@"data"]objectForKey:@"registry"] lastObject];
//                    
//                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                                  [NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]],@"childid",
//                                                  self.strCurrentDate,@"date",
//                                                  [dic objectForKey:@"came_in_at"],@"intime",
//                                                  [dic objectForKey:@"left_at"],@"outtime",
//                                                  @"1", @"uploadedflag",
//                                                  [NSNumber numberWithInteger:diff],@"timedifference",
//                                                  [NSNumber numberWithInt:[uniqueTabletOIID intValue]],@"uniqueTableID",nil];
//
//                 
////                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime: [dic objectForKey:@"came_in_at"] andOutTime:[dic objectForKey:@"left_at"] andRegistryStatus:nil  forContext:[AppDelegate context]];
//                    
//                   [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] withDate:self.strCurrentDate];
//                    obk=nil;
             //   }
                
               
                
//                if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
//                {
//                     RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
//                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt forContext:[AppDelegate context]];
//                    obk=nil;
//                }
                
                if (self.loadDailyDiary)
                {
                    [containerView setLabelMenu:@""];
                    self.loadDailyDiary=FALSE;
                    selectedIndex=0;
                    NSString *dateString = [eyl_AppDaya getDateFromNSDate:selectedDate];
                    self.strCurrentDate=dateString;
                    
                    //[self clearAllArrays];
                    [self.collectionView reloadData];
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"Loading Daily Dairy and Registry";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.delegate =self;

                    [self getDailyDiary:dateString];
                    [self getRegistry:dateString];
                    
                }
                else
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
        [postDataTask resume];

    }
    else
    {
        // Internet Not Avaialable
        [[EYL_AppData sharedEYL_AppData] showAlertWithOneButton:@"OOPS, Internet not available"];
    }
}

#pragma mark -
#pragma mark - Date Change Delegate. When user changes the delegate to load Daily diary of some other date

- (void)setDate:(NSDate *)date
{
    
    eyl_AppDaya.savePickerDate = [eyl_AppDaya getDateFromNSDate:date];
    isSaveOtherDateRecord= TRUE;
     self.isDailyDiaryPublished=FALSE;
        //self.swipeIndex=0;
    isAlertFromBack=false;
    if (isEditingEnable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Unsaved changes will be deleted, Do you want to proceed ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
        alert.tag=dateChangeAlert;
        [alert show];
    }
    else
    {
        [self clearAllArrays];
        [self addRowToRegistry:NO];
        [self addRowToNotes];
        [self addComments];
        [self addRowsToSleepTimes:NO];
        [self addRowsToWhatIateToday];
        [self addRowsToNappiesRash:NO];
        [self addRowsToToileting:NO];
        [self addRowsToIHadMyBottle:NO];
        
        [self.collectionView reloadData];
        
        selectedIndex=0;
        self.strCurrentDate=[eyl_AppDaya getDateFromNSDate:date];
        [self getDailyDiary:self.strCurrentDate];
    }
    selectedDate=date;
}
-(void)getRegistry:(NSString *)dateStr
{
    isRegistryFetched=NO;
    
//https://dev-trunk.eylog.co.uk/api/registry/getSingleChildRegistry
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        //When Internet is available
    
        
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        APICallManager *objManager = [APICallManager sharedNetworkSingleton];
        
        NSNumber *strChildId=objManager.cacheChild.childId;
        if(strChildId==nil)
        {
            strChildId= self.childID;
            
        }
        
        NSString *urlString=[NSString stringWithFormat:@"%@api/registry/getSingleChildRegistry",serverURL];
        NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                objManager.apiKey,@"api_key",
                                                objManager.apiPassword,@"api_password",
                                                strChildId,@"child_id",
                                                dateStr,@"date",
                                                nil];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get Daily Dairy" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                alert.tag=400;
                
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
                return;
            }
            [self performSelectorOnMainThread:@selector(parseRegistryData:) withObject:data waitUntilDone:YES];
            //[self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
        }];
        
        [postDataTask resume];
    }
    else
    {
        //When Internet is not available
        // [[EYL_AppData sharedEYL_AppData] showAlertWithOneButton:@"OOPS, Internet not available"];
        NoNetworkalert= [[UIAlertView alloc] initWithTitle:@"Eylog" message:@"OOPS, Internet not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [NoNetworkalert show];
    }

//    {
//        
//        "api_key": "ey-trunk-5",
//        
//        "api_password": "ZXlsb2c=",
//        
//        "child_id" : "33",
//        
//        "date":"2016-02-28"    
//        
//    }
//    

}
-(void)parseRegistryData:(NSData*)data
{
    
    NSLog(@"response from registry");
    self.localRegistryObjects = (NSMutableArray *)[self fetchRegistryDataFromLocalDB];
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    isRegistryFilled = FALSE;
    [eyl_AppDaya.array_Registry removeAllObjects];
    [eyl_AppDaya.array_registryStatus removeAllObjects];

    if ([[jsonDict objectForKey:@"status"] caseInsensitiveCompare:@"success"]==NSOrderedSame)
    {
        NSArray *arrayRegistry = [jsonDict objectForKey:@"data"];
        if(arrayRegistry.count==0)
        {
            
            if ([eyl_AppDaya.array_Registry count]==0)
                [self addRowToRegistry:NO];
            
        }
       
        DDCommentsModal *modal;
        if(eyl_AppDaya.array_Comments.count>0)
        {
          
            modal=[eyl_AppDaya.array_Comments objectAtIndex:0];
        }
        else
        {
            if(!isComentsAdded)
            {
                [self addComments];
            }
            modal=[eyl_AppDaya.array_Comments objectAtIndex:0];
         
            
        }
        modal.strRegistryComments=[jsonDict objectForKey:@"notes"];
        [eyl_AppDaya.array_Comments replaceObjectAtIndex:0 withObject:modal];
        DDCommentsModal *com=[eyl_AppDaya.array_Comments firstObject];
        
        NSLog(@"Testing in table- %@",com.strRegistryComments);
        NSDictionary *dict=[arrayRegistry firstObject];
        
        if([[dict objectForKey:@"registry_status"] isEqualToString:@"0"])
        {
            
     _isHideOtherTabs=NO;
        
    for (NSDictionary *dictionary in arrayRegistry)
    {
        RegistryDataModal *obj = [[RegistryDataModal alloc] init];
        
        if (![[dictionary valueForKey:@"came_in_at"] isEqualToString:checkNULL])
            [obj setStrCameAt:[NSDate getFormattedDateString:[dictionary valueForKey:@"came_in_at"]]];
        else
            [obj setStrCameAt:@"00:00"];
        
        if (![[dictionary valueForKey:@"left_at"] isEqualToString:checkNULL])
            [obj setStrLeftAt:[NSDate getFormattedDateString:[dictionary valueForKey:@"left_at"]]];
        else
            [obj setStrLeftAt:@"00:00"];
        
        if (![[dictionary valueForKey:@"registry_status"] isEqual:[NSNull null]])
            [obj setIndex:[[dictionary valueForKey:@"registry_status"] integerValue]];
        else
            [obj setIndex:0];
        
         if (![[dictionary valueForKey:@"clienttimestamp"] isEqualToString:checkNULL])
             [obj setClientTimeStamp:[dictionary valueForKey:@"clienttimestamp"]];
        else
            [obj setClientTimeStamp:@""];
        //    obj.date_CameAt=[Utils getDateFromStringInHHMMSS:[dictionary valueForKey:@"came_in_at"]];
        //  obj.date_LeftAt=[Utils getDateFromStringInHHMMSS:[dictionary valueForKey:@"left_at"]];
        
        
        [eyl_AppDaya.array_Registry addObject:obj];
        self.tick_Registry = TRUE;
        obj=nil;
        
    }
    //[self addRowToRegistry:YES];
    // This will check is daily diary is published then In.Out Record will not be added
    // New Question : whether we have to delete the previous records or not
    
    //        if (!self.isDailyDiaryPublished)
    //        {
    //            for (int k=0; k<self.localRegistryObjects.count; k++)
    //            {
    //                ChildInOutTime *obj = [self.localRegistryObjects objectAtIndex:k];
    //                RegistryDataModal *objRDM = [[RegistryDataModal alloc] init];
    //                [objRDM setStrCameAt:obj.inTime];
    //                [objRDM setStrLeftAt:obj.outTime];
    //                [objRDM setIndex:0];
    //
    //                [eyl_AppDaya.array_Registry addObject:objRDM];
    //
    //                objRDM=nil;
    //                obj=nil;
    //            }
    //        }
    
    ///////////////Code by shuchi For Adding a by default Row with 00:00 entry////////////////
    //        RegistryDataModal *objRDM = [[RegistryDataModal alloc] init];
    //        [objRDM setStrCameAt:@"00:00"];
    //        [objRDM setStrLeftAt:@"00:00"];
    //        [objRDM setIndex:0];
    //
    //        [eyl_AppDaya.array_Registry addObject:objRDM];
    /////////////////////////////////////////////////////////////////
    
    
    for (int k=0; k<[eyl_AppDaya.array_Registry count]; k++)
    {
        RegistryDataModal *obk = [eyl_AppDaya.array_Registry objectAtIndex:k];
        
        if (![obk.strCameAt isEqualToString:@"00:00"] || ![obk.strLeftAt isEqualToString:@"00:00"])
        {
            isRegistryFilled=TRUE;
            break;
        }
        else if (obk.index>=1)
        {
            isRegistryFilled=TRUE;
            break;
        }
        else
            isRegistryFilled=FALSE;
    }
    
    if (isRegistryFilled)
    {
        for (NSMutableDictionary *dict in self.array_SegmentControl)
        {
            if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
            {
                if (isRegistryFilled)
                    [dict setValue:@"True" forKey:@"isEmpty"];
                else
                    [dict setValue:@"False" forKey:@"isEmpty"];
            }
        }
    }
    else
    {
        for (NSMutableDictionary *dict in self.array_SegmentControl)
        {
            if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
            {
                [dict setValue:@"False" forKey:@"isEmpty"];
            }
        }
    }
        }
       // }
       
        else
        {
             _isHideOtherTabs=YES;
            for (NSDictionary *dictionary in arrayRegistry)
            {
                RegistryDataModal *obj = [[RegistryDataModal alloc] init];
            if (![[dictionary valueForKey:@"registry_status"] isEqual:[NSNull null]])
                [obj setIndex:[[dictionary valueForKey:@"registry_status"] integerValue]];
             
                if (![[dictionary valueForKey:@"clienttimestamp"] isEqualToString:checkNULL])
                    [obj setClientTimeStamp:[dictionary valueForKey:@"clienttimestamp"]];
                else
                    [obj setClientTimeStamp:@""];
                
                [eyl_AppDaya.array_registryStatus addObject:obj];
                self.tick_Registry = TRUE;
                obj=nil;
                        if ([eyl_AppDaya.array_Registry count]==0)
                            [self addRowToRegistry:NO];
 
                
                for (int k=0; k<[eyl_AppDaya.array_registryStatus count]; k++)
                {
                    RegistryDataModal *obk = [eyl_AppDaya.array_registryStatus objectAtIndex:k];
                    
                    
                     if (obk.index>=1)
                    {
                        isRegistryFilled=TRUE;
                        break;
                    }
                    else
                        isRegistryFilled=FALSE;
                }
                
                if (isRegistryFilled)
                {
                    for (NSMutableDictionary *dict in self.array_SegmentControl)
                    {
                        if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
                        {
                            if (isRegistryFilled)
                                [dict setValue:@"True" forKey:@"isEmpty"];
                            else
                                [dict setValue:@"False" forKey:@"isEmpty"];
                        }
                    }
                }
                else
                {
                    for (NSMutableDictionary *dict in self.array_SegmentControl)
                    {
                        if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
                        {
                            [dict setValue:@"False" forKey:@"isEmpty"];
                        }
                    }
                }

            }
            
            
            
            
        }
        arrayRegistry=nil;
        
        [self.collectionView reloadData];
        
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //[self.tableView reloadData];
       
    }
    else if ([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"])
    {
       
        if (![eyl_AppDaya.array_Registry count])
            [self addRowToRegistry:NO];
          _isHideOtherTabs=NO;
      
        //[self.tableView reloadData];
        
    }
    
    if(_isComeFromNotesNotifcation)
    {
        if(self.array_SegmentControl.count>0)
        {
            NSInteger inte=self.array_SegmentControl.count-1;
            selectedIndex=inte;
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.array_SegmentControl.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            
            [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.array_SegmentControl.count-1 inSection:0]];
        }
    }
    else
    {
        selectedIndex=0;
    }
    isRegistryFetched=YES;
    if(isRegistryFetched && isDiaryFetched)
    {
        [self performSelector:@selector(closeAlert) withObject:nil];
        
    }

}
-(void)getDailyDiary:(NSString *)dateString{
    
    isDiaryFetched=NO;
    

    self.strCurrentDate=dateString;
    
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        //When Internet is available
        
       
        
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        APICallManager *objManager = [APICallManager sharedNetworkSingleton];
        
        NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary/childdailydiary",serverURL];
        
        NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                objManager.apiKey,@"api_key",
                                                objManager.apiPassword,@"api_password",
                                                objManager.cachePractitioners.pin,@"practitioner_pin",
                                                [NSString stringWithFormat:@"%@",objManager.cachePractitioners.eylogUserId],@"practitioner_id",
                                                objManager.cacheChild.childId,@"child_id",
                                                dateString,@"date",
                                                nil];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get Daily Dairy" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                alert.tag=400;
                
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
                return;
            }
            [self performSelectorOnMainThread:@selector(parseDiaryData:) withObject:data waitUntilDone:YES];
            //[self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
        }];
        
        [postDataTask resume];
    }
    else
    {
        //When Internet is not available
       // [[EYL_AppData sharedEYL_AppData] showAlertWithOneButton:@"OOPS, Internet not available"];
        NoNetworkalert= [[UIAlertView alloc] initWithTitle:@"Eylog" message:@"OOPS, Internet not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [NoNetworkalert show];
    }
    
}
-(void)getDailyDiaryAfterNotification:(NSNumber *)diaryID{
    
      // self.strCurrentDate=dateString;
    
    if ([[APICallManager sharedNetworkSingleton] isNetworkReachable])
    {
        //When Internet is available
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"Loading...";
//        hud.margin = 10.f;
//        hud.removeFromSuperViewOnHide = YES;
//        hud.delegate =self;
        
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        APICallManager *objManager = [APICallManager sharedNetworkSingleton];
        NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary/childdailydiary",serverURL];
        NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                objManager.apiKey,@"api_key",
                                                objManager.apiPassword,@"api_password",
                                                objManager.cachePractitioners.pin,@"practitioner_pin",
                                                [NSString stringWithFormat:@"%@",objManager.cachePractitioners.eylogUserId],@"practitioner_id",
                                                self.childID,@"child_id",
                                                [NSString stringWithFormat:@"%d", [diaryID integerValue] ],@"diary_id",
                                                nil];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get Daily Dairy" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                alert.tag=400;
                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                return;
            }
            [self performSelectorOnMainThread:@selector(parseDiaryData:) withObject:data waitUntilDone:YES];
            //[self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
        }];
        
        [postDataTask resume];
    }
    else
    {
        //When Internet is not available
        // [[EYL_AppData sharedEYL_AppData] showAlertWithOneButton:@"OOPS, Internet not available"];
        NoNetworkalert= [[UIAlertView alloc] initWithTitle:@"Eylog" message:@"OOPS, Internet not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [NoNetworkalert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView== NoNetworkalert)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(alertView.tag==400)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }

}
-(NSArray *) fetchRegistryDataFromLocalDB
{
    NSLog(@"%@", eyl_AppDaya.selectedChild);
    
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];
    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"childID == %@", eyl_AppDaya.selectedChild];
    NSPredicate *specificDate = [NSPredicate predicateWithFormat:@"currentDate == %@",eyl_AppDaya.savePickerDate];
    
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificChildID,specificDate]]];
    
    NSError *fetchError=nil;
    NSArray *results = [[AppDelegate context] executeFetchRequest:request error:&fetchError];
    
    if ([results count])
        return results;
    else
        return nil;

}

-(void) deleteRecordFromLocalDB
{
    
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];
    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"childID == %@", eyl_AppDaya.selectedChild];
    NSPredicate *specificDate = [NSPredicate predicateWithFormat:@"currentDate == %@",avoidWrinting];
    
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificChildID,specificDate]]];
    
    NSError *fetchError=nil;
    NSArray *results = [[AppDelegate context] executeFetchRequest:request error:&fetchError];
    
    //error handling goes here
    for (NSManagedObject *car in results) {
        [[AppDelegate context] deleteObject:car];
    }
    NSError *saveError = nil;
    [[AppDelegate context] save:&saveError];
    //more error handling here
}
-(void)setTickFalse
{
     isNappiesFilled = FALSE;
     isToiletingFilled = FALSE;
     isIHadMyBottleFilled = FALSE;
     isSleepTimesFilled = FALSE;
     isNotesToParentsFilled = FALSE;
     isRegistryFilled = FALSE;
     isWhatIateToday = FALSE;
}

-(void)parseDiaryData:(NSData *)data
{
    NSLog(@"response from daily diary");
    // Remove all objects from the array
    isNappiesFilled = FALSE;
    isToiletingFilled = FALSE;
    isIHadMyBottleFilled = FALSE;
    isSleepTimesFilled = FALSE;
    isNotesToParentsFilled = FALSE;
  
    isWhatIateToday = FALSE;
    
   
    [eyl_AppDaya.array_IHadMyBottle removeAllObjects];
    [eyl_AppDaya.array_nappiesRash  removeAllObjects];
    [eyl_AppDaya.array_Notes removeAllObjects];
 
    [eyl_AppDaya.array_SleepTimes removeAllObjects];
    [eyl_AppDaya.array_Toileting removeAllObjects];
  
    
    //[eyl_AppDaya.array_WhatIateToday removeAllObjects];
    
    [eyl_AppDaya.array_Observations removeAllObjects];
    self.textView_Parents.text=nil;
    
   

    for (int k=0; k<[eyl_AppDaya.array_WhatIateToday count]; k++)
    {
        WhatIateTodayModal *obj = [eyl_AppDaya.array_WhatIateToday objectAtIndex:k];
        [obj setIndex:0];
        obj=nil;
    }

    
    self.localRegistryObjects = (NSMutableArray *)[self fetchRegistryDataFromLocalDB];
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
    if ([[jsonDict objectForKey:@"status"] caseInsensitiveCompare:@"success"]==NSOrderedSame)
    {
        NSMutableDictionary *dataDictionary=[[jsonDict objectForKey:@"data"] objectForKey:@"diary_data"];
        if(_isComeFromNotesNotifcation)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-mm-yyyy"];
            NSDate *dateFromString = [dateFormatter dateFromString:[dataDictionary objectForKey:@"date"]];
            [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
            containerView.dateLabel.text=[dataDictionary objectForKey:@"date"];
            self.strCurrentDate=[dataDictionary objectForKey:@"date"];
            
            
            NSArray *array=[Child fetchChildInContext:[AppDelegate context] withChildId:[dataDictionary objectForKey:@"child_id"]];
            Child *child=[array lastObject];
            containerView.childName.text=[child.firstName stringByAppendingString:[@" " stringByAppendingString:child.lastName]];
            containerView.childGroup.text=child.groupName;
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

            
        }
        eyl_AppDaya.selectedChild = (NSNumber *) [dataDictionary valueForKey:@"child_id"];
        // Set the tick as false
        [self setTickFalse];
        NSString * abc=[dataDictionary valueForKey:@"mode"];
        abc  = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
        NSLog(@"abc = %@",abc);
        
        [containerView setLabelMenu:abc ];
        
        // Checking if Daily Diary is Published
        
        if ([[dataDictionary objectForKey:@"mode"] caseInsensitiveCompare:@"submitted"]==NSOrderedSame)
        {
            self.isDailyDiaryPublished=TRUE;
            [self.view makeToast:@"Diary is already published.You can't edit this Diary" duration:3 position:CSToastPositionBottom];
            [self disableEditing];
        }
        else
        {
            [self enableEditing];
            self.isDailyDiaryPublished=FALSE;
        }
        
        /*
         * Set IN OUT Time of the child
         */
        [theme.IN_button.lblName setText:[NSString stringWithFormat:@"IN Time : %@",[dataDictionary valueForKey:@"came_in_at"]]];
        [theme.OUT_button.lblName setText:[NSString stringWithFormat:@"OUT Time : %@",[dataDictionary valueForKey:@"left_at"]]];

        /*
         *  Parsing Notes Tag
         */

        NotesModal *obj = [NotesModal new];
        obj.str_NotesToParents = [dataDictionary valueForKey:@"notes_to_parents"];
        obj.str_NotesFromParents = [dataDictionary valueForKey:@"notes_from_parents"];
        [eyl_AppDaya.array_Notes addObject:obj];
        
        if (obj.str_NotesFromParents.length || obj.str_NotesToParents.length >0)
        {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"additionalnotes"])
                    {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    }
                    
                }
        }
        else
        {
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"additionalnotes"])
                {
                    [dict setValue:@"False" forKey:@"isEmpty"];
                }
                
            }

        }  
        
        obj=nil;

        /**
         *  Parsing Registry Tag
         */

//        NSArray *arrayRegistry = [dataDictionary valueForKey:@"registry"];
//        
//        
//        for (NSDictionary *dictionary in arrayRegistry)
//        {
//            RegistryDataModal *obj = [[RegistryDataModal alloc] init];
//
//            if (![[dictionary valueForKey:@"came_in_at"] isEqualToString:checkNULL])
//                [obj setStrCameAt:[NSDate getFormattedDateString:[dictionary valueForKey:@"came_in_at"]]];
//            else
//                [obj setStrCameAt:@"00:00"];
//
//            if (![[dictionary valueForKey:@"left_at"] isEqualToString:checkNULL])
//                [obj setStrLeftAt:[NSDate getFormattedDateString:[dictionary valueForKey:@"left_at"]]];
//            else
//                [obj setStrLeftAt:@"00:00"];
//
//            if (![[dictionary valueForKey:@"registry_status"] isEqual:[NSNull null]])
//                [obj setIndex:[[dictionary valueForKey:@"registry_status"] integerValue]];
//            else
//                [obj setIndex:0];
//
//        
//        //    obj.date_CameAt=[Utils getDateFromStringInHHMMSS:[dictionary valueForKey:@"came_in_at"]];
//          //  obj.date_LeftAt=[Utils getDateFromStringInHHMMSS:[dictionary valueForKey:@"left_at"]];
//            
//            
//            [eyl_AppDaya.array_Registry addObject:obj];
//            self.tick_Registry = TRUE;
//            obj=nil;
//        }
//        //[self addRowToRegistry:YES];
//        // This will check is daily diary is published then In.Out Record will not be added
//        // New Question : whether we have to delete the previous records or not
//        
////        if (!self.isDailyDiaryPublished)
////        {
////            for (int k=0; k<self.localRegistryObjects.count; k++)
////            {
////                ChildInOutTime *obj = [self.localRegistryObjects objectAtIndex:k];
////                RegistryDataModal *objRDM = [[RegistryDataModal alloc] init];
////                [objRDM setStrCameAt:obj.inTime];
////                [objRDM setStrLeftAt:obj.outTime];
////                [objRDM setIndex:0];
////                
////                [eyl_AppDaya.array_Registry addObject:objRDM];
////                
////                objRDM=nil;
////                obj=nil;
////            }
////        }
//        
//        ///////////////Code by shuchi For Adding a by default Row with 00:00 entry////////////////
////        RegistryDataModal *objRDM = [[RegistryDataModal alloc] init];
////        [objRDM setStrCameAt:@"00:00"];
////        [objRDM setStrLeftAt:@"00:00"];
////        [objRDM setIndex:0];
////        
////        [eyl_AppDaya.array_Registry addObject:objRDM];
//        /////////////////////////////////////////////////////////////////
//        
//        
//        for (int k=0; k<[eyl_AppDaya.array_Registry count]; k++)
//        {
//            RegistryDataModal *obk = [eyl_AppDaya.array_Registry objectAtIndex:k];
//            
//            if (![obk.strCameAt isEqualToString:@"00:00"] || ![obk.strLeftAt isEqualToString:@"00:00"])
//            {
//                isRegistryFilled=TRUE;
//                break;
//            }
//            else if (obk.index>=1)
//            {
//                isRegistryFilled=TRUE;
//                break;
//            }
//            else
//                isRegistryFilled=FALSE;
//        }
//        
//        if (isRegistryFilled)
//        {
//            for (NSDictionary *dict in self.array_SegmentControl)
//            {
//                if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
//                {
//                    if (isRegistryFilled)
//                        [dict setValue:@"True" forKey:@"isEmpty"];
//                    else
//                        [dict setValue:@"False" forKey:@"isEmpty"];
//                }
//            }
//        }
//        else
//        {
//            for (NSDictionary *dict in self.array_SegmentControl)
//            {
//                if ([[dict valueForKey:@"keyN"] isEqualToString:@"registry"])
//                {
//                   [dict setValue:@"False" forKey:@"isEmpty"];
//                }
//            }
//        }
//        
//        arrayRegistry=nil;
//        
//        if (![eyl_AppDaya.array_Registry count])
//            [self addRowToRegistry:NO];

        /**
         *  Parsing Nappies Tag
         */

        NSArray *arrayNappies = [dataDictionary valueForKey:@"nappies"];

        if (![arrayNappies count])
            [self addRowsToNappiesRash:NO];
       

        for (NSDictionary *dictionary in arrayNappies)
        {
            NappiesDataModal *obj = [[NappiesDataModal alloc] init];

            if (![[dictionary valueForKey:@"n_when"] isEqualToString:checkNULL])
                [obj setStrWhen:[NSDate getFormattedDateString:[dictionary valueForKey:@"n_when"]]];
            else
                [obj setStrWhen:@"00:00"];

            if (![[dictionary valueForKey:@"n_value"] isEqual:[NSNull null]])
                [obj setIndex:[[dictionary valueForKey:@"n_value"] integerValue]];
            else
                [obj setIndex:0];

            NSInteger nap;

            if (![[dictionary valueForKey:@"nappy_rash"] isEqual:[NSNull null]])
               nap = [[dictionary valueForKey:@"nappy_rash"] integerValue];
            else
                nap=0;

            if (nap==1)
                [obj setNappyRash:TRUE];

            int cre;
            if (![[dictionary valueForKey:@"cream_applied"] isEqual:[NSNull null]])
             cre = [[dictionary valueForKey:@"cream_applied"] intValue];
            else
                cre=0;
            if (cre==1)
                [obj setCreamApplied:TRUE];
            NSString *str=[dictionary valueForKey:@"n_when"];
            if(str.length!=0)
            {
            obj.date_When=[Utils getDateFromStringInHHMM:[dictionary valueForKey:@"n_when"]];
            }
         
            [eyl_AppDaya.array_nappiesRash addObject:obj];
            
            
            if (![obj.strWhen isEqualToString:@"00:00"]||obj.creamApplied==YES||obj.nappyRash==YES||obj.index!=0)
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"nappies"])
                    {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    }
                }
            }
            else
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"nappies"])
                    {
                        [dict setValue:@"False" forKey:@"isEmpty"];
                    }
                }
            }
            obj=nil;

        }
        arrayNappies=nil;

        for (int j=0; j<eyl_AppDaya.array_nappiesRash.count; j++)
        {
            NappiesDataModal *obj = [eyl_AppDaya.array_nappiesRash objectAtIndex:j];
            
            if (![obj.strWhen isEqualToString:@"00:00"]||obj.creamApplied==YES||obj.nappyRash==YES||obj.index!=0)
            {
                isNappiesFilled=TRUE;
                break;
            }
            else if (obj.index>=1)
            {
                isNappiesFilled=TRUE;
                break;
            }
            else if (obj.creamApplied || obj.nappyRash)
            {
                isNappiesFilled=TRUE;
                break;
            }
            else
                isNappiesFilled=FALSE;

            obj=nil;
        }
        
        if (isNappiesFilled) {
            
        }


        /**
         *  Parsing Toileting Tag
         */
        NSArray *arrayToileting = [dataDictionary valueForKey:@"toileting"];

        if (![arrayToileting count])
            [self addRowsToToileting:NO];
        
        for (NSDictionary *dictionary in arrayToileting)
        {
            ToiletingDataModal *obj = [[ToiletingDataModal alloc] init];

            if (![[dictionary valueForKey:@"t_when"] isEqualToString:checkNULL])
                [obj setStr_When:[NSDate getFormattedDateString:[dictionary valueForKey:@"t_when"]]];
            else
                [obj setStr_When:@"00:00"];

            if (![[dictionary valueForKey:@"t_value"] isEqual:[NSNull null]])
                [obj setIndex:[[dictionary valueForKey:@"t_value"] integerValue]];
            else
                [obj setIndex:0];
            NSString *str=[dictionary valueForKey:@"t_when"];
            if(str.length!=0)
            {

            obj.date_When=[Utils getDateFromStringInHHMM:[dictionary valueForKey:@"t_when"]];
            }
            [eyl_AppDaya.array_Toileting addObject:obj];
            
            if (obj.index>=1) {
                isToiletingFilled=TRUE;
            }
            else if (![obj.str_When isEqualToString:@"00:00"]||obj.index!=0)
            {
                isToiletingFilled=TRUE;
            }
            else
                isToiletingFilled=FALSE;
            if (isToiletingFilled)
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"toileting_today_1"])
                    {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    }
                }
            }
            else
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"toileting_today_1"])
                    {
                        [dict setValue:@"False" forKey:@"isEmpty"];
                    }
                }
            }
            obj=nil;
        }
        arrayToileting=nil;


        /**
         *  Parsing I had My Bottle Tag
         */

        NSArray *arrayIHadMyBottle = [dataDictionary valueForKey:@"i_had_my_bottle"];

        if (![arrayIHadMyBottle count])
            [self addRowsToIHadMyBottle:NO];
       

        for (NSDictionary *dictionary in arrayIHadMyBottle)
        {
            IHadMyBottleDataModal *obj = [[IHadMyBottleDataModal alloc] init];
            if (![[dictionary valueForKey:@"at"] isEqual:checkNULL])
                [obj setStrDateAt:[NSDate getFormattedDateString:[dictionary valueForKey:@"at"]]];
            else
                [obj setStrDateAt:@"00:00"];

          //  if (![[dictionary valueForKey:@"drank"] isEqualToString:checkNULL])
            NSString *strDrank = [dictionary valueForKey:@"drank"];

            [obj setStrDrank:(strDrank.length) ? strDrank : @"0"];
            NSString *str=[dictionary valueForKey:@"at"];
            if(str.length!=0)
            {
            obj.date_DateAt=[Utils getDateFromStringInHHMM:[dictionary valueForKey:@"at"]];
            }

            [eyl_AppDaya.array_IHadMyBottle addObject:obj];
            
            if (![obj.strDateAt isEqualToString:@"00:00"])
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"i_had_my_bottle"])
                    {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    }
                }
            }
            else
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"i_had_my_bottle"])
                    {
                        [dict setValue:@"False" forKey:@"isEmpty"];
                    }
                }
            }
            obj=nil;
        }
        arrayIHadMyBottle=nil;

        /**
         *  Parsing Sleep Tag
         */

        NSArray *arraySleepTimes = [dataDictionary valueForKey:@"sleep_times"];

        if(![arraySleepTimes count])
            [self addRowsToSleepTimes:NO];
     
        for (NSDictionary *dictionary in arraySleepTimes)
        {
            SleepTimesDataModal *obj = [[SleepTimesDataModal alloc] init];
            
            
            if (![[dictionary valueForKey:@"fell_asleep"] isEqualToString:checkNULL])
                [obj setStrFellAsleep:[NSDate getFormattedDateString:[dictionary valueForKey:@"fell_asleep"]]];
            else
                [obj setStrFellAsleep:@"00:00"];

            if (![[dictionary valueForKey:@"woke_up"] isEqualToString:checkNULL])
                [obj setStrWokeUp:[NSDate getFormattedDateString:[dictionary valueForKey:@"woke_up"]]];
            else
                [obj setStrWokeUp:@"00:00"];

            @try
            {
                NSDate *currentDate = [NSDate date];
                NSArray *arrDate = [[NSString stringWithFormat:@"%@", currentDate] componentsSeparatedByString:@" "];
                NSString *strFirstIndex = [arrDate objectAtIndex:0];

                NSString *strFirstDate = [NSString stringWithFormat:@"%@ %@:00", strFirstIndex,obj.strFellAsleep];
                NSString *strSecondDate;
                if(![obj.strWokeUp isEqualToString:@"00:00"])
                {
                   strSecondDate= [NSString stringWithFormat:@"%@ %@:00", strFirstIndex,obj.strWokeUp];
                }
               
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];

                NSDate *date1 =[formatter dateFromString:strFirstDate];
                NSDate *date2 =[formatter dateFromString:strSecondDate];

                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *components = [gregorianCalendar components:NSMinuteCalendarUnit
                                                                    fromDate:date1
                                                                      toDate:date2
                                                                     options:0];

                int hour = (int)components.minute/60;
                int min = (int)components.minute%60;


                NSString *strHour = [NSString stringWithFormat:@"%d", hour];
                NSString *strMin = [NSString stringWithFormat:@"%d", min];

                NSString *strCompleteDate = [NSString stringWithFormat:@"%@:%@",(strHour.length>0) ? strHour : @"00", (strMin>0) ? strMin : @"00"];
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH:MM"];
                NSString *str=[dictionary valueForKey:@"fell_asleep"];
                if(str.length>0)
                {
                NSDate *datet =[formatter1 dateFromString:[dictionary valueForKey:@"fell_asleep"]];
                obj.date_FellAsleep=datet;
                
                obj.strSleptMins = strCompleteDate;
                }
            }
            @catch (NSException *exception) {

            }
            @finally {

            }
            NSString *str=[dictionary valueForKey:@"fell_asleep"];
            if(str.length!=0)
            {
                  obj.date_FellAsleep=[Utils getDateFromStringInHHMM:[dictionary valueForKey:@"fell_asleep"]];
            }
            NSString *str1=[dictionary valueForKey:@"woke_up"];
            if(str1.length!=0)
            {
                obj.date_WokeUp=[Utils getDateFromStringInHHMM:[dictionary valueForKey:@"woke_up"]];

            }
            
       [eyl_AppDaya.array_SleepTimes addObject:obj];
            
            
            if (![obj.strFellAsleep isEqualToString:@"00:00"])
            {
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"sleep_times"])
                    {
                        [dict setValue:@"True" forKey:@"isEmpty"];
                    }
                }
            }
            else{
                for (NSMutableDictionary *dict in self.array_SegmentControl)
                {
                    if ([[dict valueForKey:@"keyN"] isEqualToString:@"sleep_times"])
                    {
                        [dict setValue:@"False" forKey:@"isEmpty"];
                    }
                }
            }
            obj=nil;
        }
        arraySleepTimes=nil;

        /**
         *    Parsing What I ate Today
         */

        for (int i=0; i<[eyl_AppDaya.array_WhatIateToday count]; i++)
        {
            WhatIateTodayModal *objNew = [eyl_AppDaya.array_WhatIateToday objectAtIndex:i];
            if ([objNew.strKey isEqualToString:@"breakfast"])
                [objNew setIndex:[[dataDictionary valueForKey:@"breakfast"] intValue]];
            else if ([objNew.strKey isEqualToString:@"snack_am"])
                [objNew setIndex:[[dataDictionary valueForKey:@"snack_am"] intValue]];
            else if ([objNew.strKey isEqualToString:@"pudding_am"])
                [objNew setIndex:[[dataDictionary valueForKey:@"pudding_am"] intValue]];
            else if ([objNew.strKey isEqualToString:@"lunch"])
                [objNew setIndex:[[dataDictionary valueForKey:@"lunch"] intValue]];
            else if ([objNew.strKey isEqualToString:@"snack_pm"])
                [objNew setIndex:[[dataDictionary valueForKey:@"snack_pm"] intValue]];
            else if ([objNew.strKey isEqualToString:@"pudding_pm"])
                 [objNew setIndex:[[dataDictionary valueForKey:@"pudding_pm"] intValue]];
            else if ([objNew.strKey isEqualToString:@"tea"])
                [objNew setIndex:[[dataDictionary valueForKey:@"tea"] intValue]];
        }
        
        for (int k=0; k<eyl_AppDaya.array_WhatIateToday.count; k++)
        {
            WhatIateTodayModal *obj = [eyl_AppDaya.array_WhatIateToday objectAtIndex:k];
            if (obj.index>=1)
            {
                isWhatIateToday=TRUE;
                break;
            }
            obj=nil;
        }
        
        if (isWhatIateToday)
        {
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"what_i_ate_today"])
                {
                    [dict setValue:@"True" forKey:@"isEmpty"];
                }
            }
            [self.collectionView reloadData];
        }
        else
        {
            for (NSMutableDictionary *dict in self.array_SegmentControl)
            {
                if ([[dict valueForKey:@"keyN"] isEqualToString:@"what_i_ate_today"])
                {
                    [dict setValue:@"False" forKey:@"isEmpty"];
                }
            }
        }

        if (eyl_AppDaya.array_WhatIateToday.count==0)
            [self addRowsToWhatIateToday];

        /**
         *  Parsing Comments Tag
         */
if(eyl_AppDaya.array_Comments.count==1)
{
    DDCommentsModal *objDDC=[eyl_AppDaya.array_Comments firstObject];
    
if(objDDC.strRegistryComments.length>0)
{
    objDDC.strWhatIateTodayComments = [dataDictionary valueForKey:@"what_i_ate_cmts"];
    objDDC.strNappiesComments = [dataDictionary valueForKey:@"nappies_cmts"];
    
    objDDC.strToiletingTodayComments =[dataDictionary valueForKey:@"toileting_cmts"];
    objDDC.strSleepTimesComments = [dataDictionary valueForKey:@"sleep_times_cmts"];
    objDDC.strIHadMyBottleComments = [dataDictionary valueForKey:@"i_had_my_bottle_cmts"];
    
    [eyl_AppDaya.array_Comments replaceObjectAtIndex:0 withObject:objDDC];
    
}
    else
    {
        [eyl_AppDaya.array_Comments removeAllObjects];
      
        
        DDCommentsModal *objDDC = [[DDCommentsModal alloc] init];
        objDDC.strWhatIateTodayComments = [dataDictionary valueForKey:@"what_i_ate_cmts"];
        objDDC.strNappiesComments = [dataDictionary valueForKey:@"nappies_cmts"];
        objDDC.strRegistryComments = @"";
        objDDC.strToiletingTodayComments =[dataDictionary valueForKey:@"toileting_cmts"];
        objDDC.strSleepTimesComments = [dataDictionary valueForKey:@"sleep_times_cmts"];
        objDDC.strIHadMyBottleComments = [dataDictionary valueForKey:@"i_had_my_bottle_cmts"];
        
        [eyl_AppDaya.array_Comments addObject:objDDC];

    }
}
    else
    {
        [eyl_AppDaya.array_Comments removeAllObjects];
        isComentsAdded=YES;
        
        DDCommentsModal *objDDC = [[DDCommentsModal alloc] init];
        objDDC.strWhatIateTodayComments = [dataDictionary valueForKey:@"what_i_ate_cmts"];
        objDDC.strNappiesComments = [dataDictionary valueForKey:@"nappies_cmts"];
        objDDC.strRegistryComments = @"";
        objDDC.strToiletingTodayComments =[dataDictionary valueForKey:@"toileting_cmts"];
        objDDC.strSleepTimesComments = [dataDictionary valueForKey:@"sleep_times_cmts"];
        objDDC.strIHadMyBottleComments = [dataDictionary valueForKey:@"i_had_my_bottle_cmts"];
        
        [eyl_AppDaya.array_Comments addObject:objDDC];

        
    }
            obj=nil;
        //// **** Parsing observations
        

        NSArray *array = [dataDictionary valueForKey:@"observationEyfs"];
        
        if ([array count]!=0)
        {
           // [self addRowsToIHadMyBottle:NO];
        
        
        for (NSDictionary *dictionary in array)
        {
            ObservationsModal *obj = [[ObservationsModal alloc] init];
            
            obj.areas_assessed=[dictionary objectForKey:@"areas_assessed"];
            obj.observation_text=[dictionary objectForKey:@"observation_text"];
            obj.date_time=[dictionary objectForKey:@"date_time"];
            obj.eyfs=[dictionary objectForKey:@"eyfs"];
            obj.level_four=[dictionary objectForKey:@"level_four"];
            obj.observer_name=[dictionary objectForKey:@"observer_name"];
         
            [eyl_AppDaya.array_Observations addObject:obj];
            
          
            obj=nil;
        }
        
        for (NSMutableDictionary *dict in self.array_SegmentControl)
        {
            if ([[dict valueForKey:@"keyN"] isEqualToString:@"observationEyfs"])
            {
                [dict setValue:@"True" forKey:@"isEmpty"];
            }
        }
        array=nil;
        }
        else
        {
            NSString *str=@"observationEyfs";
            NSMutableArray *arraySegmentControl=[NSMutableArray arrayWithArray:self.array_SegmentControl];
            
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.keyN == %@ OR SELF.keyV== %@",str,str];
            NSArray *array=[arraySegmentControl filteredArrayUsingPredicate:predicate];
            
            if(array.count>0)
            {
            [arraySegmentControl removeObject:[[arraySegmentControl filteredArrayUsingPredicate:predicate] firstObject]];
            }
            
            self.array_SegmentControl=arraySegmentControl;
            mainArray_segmentControl=self.array_SegmentControl;
            [self.collectionView reloadData];
            
            
        }
       // mainArray_segmentControl=self.array_SegmentControl;
        

    }
    
    else
        
    {
//
//        if (self.localRegistryObjects.count)
//        {
//            for (int k=0; k<self.localRegistryObjects.count; k++)
//            {
//                ChildInOutTime *obj = [self.localRegistryObjects objectAtIndex:k];
//                RegistryDataModal *objRDM = [[RegistryDataModal alloc] init];
//                [objRDM setStrCameAt:obj.inTime];
//                [objRDM setStrLeftAt:obj.outTime];
//                [objRDM setIndex:0];
//                
//                [eyl_AppDaya.array_Registry addObject:objRDM];
//                
//                objRDM=nil;
//                obj=nil;
//            }
//        }
//        else
//
        [self fetchAllRecords];
        
        NSString *str=@"observationEyfs";
        NSMutableArray *arraySegmentControl=[NSMutableArray arrayWithArray:self.array_SegmentControl];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.keyN == %@ OR SELF.keyV== %@",str,str];
        NSArray *array=[arraySegmentControl filteredArrayUsingPredicate:predicate];
        
        if(array.count>0)
        {
            [arraySegmentControl removeObject:[[arraySegmentControl filteredArrayUsingPredicate:predicate] firstObject]];
        }
        
        self.array_SegmentControl=arraySegmentControl;
               // Add Empty Rows to the Cell
        [containerView setLabelMenu:@"New"];
        
        [self addRowsToSleepTimes:NO];
        [self addRowsToIHadMyBottle:NO];
        [self addRowsToNappiesRash:NO];
        [self addRowsToWhatIateToday];
        [self addRowsToToileting:NO];
        [self addRowToNotes];
        if(!isComentsAdded)
        {
        [self addComments];
        }

        [self.view makeToast:[jsonDict objectForKey:@"message"] duration:3 position:CSToastPositionBottom];
        [self enableEditing];
        
//        [containerView setLabelMenu:@"Draft"];
    }

    if(_isComeFromNotesNotifcation)
    {
        NSInteger inte=self.array_SegmentControl.count-1;
        
        selectedIndex=inte;
      //  mainArray_segmentControl=self.array_SegmentControl;

        [self.collectionView reloadData];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:inte inSection:0]];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.array_SegmentControl.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
    else
    {
        selectedIndex=0;
      //  mainArray_segmentControl=self.array_SegmentControl;

        [self.collectionView reloadData];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    isDiaryFetched=YES;
    if(isRegistryFetched && isDiaryFetched)
    {
        [self performSelector:@selector(closeAlert) withObject:nil];
        
    }

}

-(void)disableEditing{
    NSLog(@"Edit mode disabled");
    [containerView setLabelMenu:@"Submitted"];
    isEditingEnable=NO;

    
    //self.tableView.userInteractionEnabled=false;
    
    self.textView_Notes.editable=false;
    self.textView_Parents.userInteractionEnabled=false;
    self.navigationController.toolbar.userInteractionEnabled=false;

    if (self.view.frame.size.height==768)
        [self.transparentImageView setImage:[UIImage imageNamed:@"Published_lan"]];
    else
        [self.transparentImageView setImage:[UIImage imageNamed:@"Published_por"]];


    [self.transparentImageView setHidden:FALSE];

    [self.viewNav setHidden:FALSE];
    [self.viewNav setNeedsDisplay];
}
-(void)enableEditing{
    isEditingEnable=YES;
//    [self.collectionView selectItemAtIndexPath:zerothIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];

    NSLog(@"Edit mode Enabled");
    self.tableView.userInteractionEnabled=true;
    self.textView_Notes.editable=true;
    self.textView_Parents.userInteractionEnabled=true;
    self.navigationController.toolbar.userInteractionEnabled=true;

    [self.transparentImageView setHidden:TRUE];
    [self.viewNav setHidden:TRUE];

}
-(void)closeAlert{
    if(!_isComeFromNotesNotifcation)
    {
      [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    UIViewController *topVC = self.navigationController;
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


#pragma mark -
#pragma mark - Collection View Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDDCollectionViewCellReuseId forIndexPath:indexPath];

    if (selectedIndex==indexPath.row) {
        [cell setSelected:YES];
    }else{
        [cell setSelected:FALSE];
    }
    if (cell.isSelected)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:193/255.0 green:196/255.0 blue:88/255.0 alpha:1.0]];
        [cell.lblName setTextColor:[UIColor whiteColor]];
        [cell.imgView setImage:nil];
    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.lblName setTextColor:[UIColor blackColor]];
        [cell.imgView setImage:nil];
    }
    //@"observationEyfs"
   // @"observationfields"
    if([[[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"keyV"] isEqualToString:@"observationEyfs"]||[[[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"keyV"] isEqualToString:@"observationfields"])
    {
    [cell.lblName setText:@"Observations"];
    }
    else
    {
    
    [cell.lblName setText:[[[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"keyV"] capitalizedString]];
    }
    cell.imgView.image=[UIImage imageNamed:@""];
    
    if ([[[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"isEmpty"] isEqualToString:@"True"])
    {
        cell.imgView.image = [UIImage imageNamed:@"icon_tickWithoutBorder"];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
     NSString *str=@"Registry";
     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.keyV = %@",str];
     NSArray *array=[self.array_SegmentControl filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *mutArray=[NSMutableArray new];
    
    //observationEyfs
    //additionalnotes
    NSString *str1=@"observationEyfs";
    NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"SELF.keyN = %@",str1];
    NSArray *array1=[self.array_SegmentControl filteredArrayUsingPredicate:predicate1];

    
    NSString *str2=@"observationfields";
    NSPredicate *predicate2=[NSPredicate predicateWithFormat:@"SELF.keyN = %@",str2];
    NSArray *array2=[self.array_SegmentControl filteredArrayUsingPredicate:predicate2];
    
    
    NSString *str3=@"additionalnotes";
    NSPredicate *predicate3=[NSPredicate predicateWithFormat:@"SELF.keyN = %@",str3];
    NSArray *array3=[self.array_SegmentControl filteredArrayUsingPredicate:predicate3];
    
    if(array.count>0)
    {
    [mutArray addObject:[array firstObject]];
    }
    if(array1.count>0)
    {
     [mutArray addObject:[array1 firstObject]];
    }
    if(array2.count>0)
    {
     [mutArray addObject:[array2 firstObject]];
    }
    if(array3.count>0)
    {
     [mutArray addObject:[array3 firstObject]];
    }
    
    
    if(_isHideOtherTabs)
    {
        self.array_SegmentControl=[NSMutableArray arrayWithArray:mutArray];
        return self.array_SegmentControl.count;
        
    }
    else
    {
        self.array_SegmentControl=[NSMutableArray arrayWithArray:mainArray_segmentControl];
       return [self.array_SegmentControl count];
    
    }
    
   
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(214, 42
);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets=UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    RegistryDataModal *modal=[eyl_AppDaya.array_registryStatus lastObject];
    if(modal.index==0)
    {
    self.collectionViewIndexPath = indexPath;
    selectedIndex=indexPath.row;

    DDCollectionViewCell *cell = (DDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.view endEditing:TRUE];
    self.collectionViewSelectiveIndex = indexPath.row;
    if(self.array_SegmentControl.count>0)
    {
    NSString *strName = [[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"keyN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
    NSArray * array = [_keyArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0)
    {
        if (saveTextFromParents)
        {
            saveTextFromParents = FALSE;
            NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
            obj.str_NotesFromParents = self.textView_Parents.text;
        }
        [self.textView_Parents setUserInteractionEnabled:FALSE];
        [self.tableView setHidden:FALSE];
        [self.textView_Notes setHidden:FALSE];
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView setHidden:TRUE];
        [self.textView_Notes setHidden:TRUE];
        [self.textView_Parents setHidden:FALSE];
        [self.textView_Parents setUserInteractionEnabled:FALSE];
        [self.btn_NotesFromParents setSelected:TRUE];
        [self.btn_NotesToParents setSelected:FALSE];        

        NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
        lblPlaceHoldaer=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
        lblPlaceHoldaer.textColor=[UIColor lightGrayColor];
        [lblPlaceHoldaer removeFromSuperview];
        
        [self.textView_Parents addSubview:lblPlaceHoldaer];
        lblPlaceHoldaer.text=@"Notes from Parents";
        [self.textView_Parents setText:obj.str_NotesFromParents];
        if(![self.textView_Parents hasText]) {
            lblPlaceHoldaer.hidden = NO;
        }
        else{
            
            for(UIView *view in self.textView_Parents.subviews)
            {
                if([view isKindOfClass:[UILabel class]])
                {
                    UILabel *lbl=(UILabel *)view;
                    
                    if([lbl.text isEqualToString:@"Notes from Parents"])
                    {
                        [lbl setHidden:YES];
                        
                    }
                    
                }
            }

            lblPlaceHoldaer.hidden = YES;
        }
        
    }
    }
    /**
     *  Set Comments for the Cell
     */
    self.textView_Notes.text= @"";
    if(eyl_AppDaya.array_Comments.count>0)
    {
        DDCommentsModal *obj = [eyl_AppDaya.array_Comments objectAtIndex:0];
        if ([cell isKindOfClass:[RegistryCustomTableViewCell class]])
        {
            self.textView_Notes.text = obj.strRegistryComments;
        }
        else if ([cell isKindOfClass:[NappiesCustomTableViewCell class]])
        {
            self.textView_Notes.text = obj.strNappiesComments;
        }
        else if ([cell isKindOfClass:[SleepTimesTableViewCell class]])
        {
            self.textView_Notes.text = obj.strSleepTimesComments;
        }
        
        else if ([cell isKindOfClass:[WhatIateTodayTableViewCell class]])
        {
            self.textView_Notes.text = obj.strWhatIateTodayComments;
        }
        
        else if ([cell isKindOfClass:[IHadMyBottleTableViewCell class]])
        {
            self.textView_Notes.text = obj.strIHadMyBottleComments;
        }
        
        else if ([cell isKindOfClass:[ToiletingCustomTableViewCell class]])
        {
            self.textView_Notes.text = obj.strToiletingTodayComments;
        }
    }
          [self.collectionView reloadData];
        }
    else
    {
        
        DDCollectionViewCell *cell = (DDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.view endEditing:TRUE];
        self.collectionViewIndexPath = indexPath;
        selectedIndex=indexPath.row;

        self.collectionViewSelectiveIndex = indexPath.row;
        if(self.array_SegmentControl.count>0)
        {
            NSString *strName = [[self.array_SegmentControl objectAtIndex:indexPath.row] valueForKey:@"keyN"];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyN == %@",strName];
            NSArray * array = [_keyArray filteredArrayUsingPredicate:predicate];
            if (array.count > 0)
            {
                if (saveTextFromParents)
                {
                    saveTextFromParents = FALSE;
                    NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
                    obj.str_NotesFromParents = self.textView_Parents.text;
                }
                [self.textView_Parents setUserInteractionEnabled:FALSE];
                [self.tableView setHidden:FALSE];
                [self.textView_Notes setHidden:FALSE];
                [self.tableView reloadData];
            }
            else
            {
                [self.tableView setHidden:TRUE];
                [self.textView_Notes setHidden:TRUE];
                [self.textView_Parents setHidden:FALSE];
                [self.textView_Parents setUserInteractionEnabled:FALSE];
                [self.btn_NotesFromParents setSelected:TRUE];
                [self.btn_NotesToParents setSelected:FALSE];
                
                NotesModal *obj = [eyl_AppDaya.array_Notes objectAtIndex:0];
                lblPlaceHoldaer=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
                lblPlaceHoldaer.textColor=[UIColor lightGrayColor];
                [self.textView_Parents addSubview:lblPlaceHoldaer];
                lblPlaceHoldaer.text=@"Notes from Parents";
                
                
                [self.textView_Parents setText:obj.str_NotesFromParents];
                if(![self.textView_Parents hasText]) {
                    lblPlaceHoldaer.hidden = NO;
                }
                else{
                    lblPlaceHoldaer.hidden = YES;
                }
                
                
            }
        }
    
        
       [self.collectionView reloadData];
       [self.tableView reloadData];
        NSString *str=@"";
        
        if(modal.index==1)
        {
            str= @"Absent";
        }
        if(modal.index==2)
        {
            str= @"on Holiday";

        }
        if(modal.index==3)
        {
            str= @"Sick";
 
        }
        if(modal.index==4)
        {
            str= @"Not Booked";

        }
        
        [self.view makeToast:[@"You cannot edit the Daily Diary as the child is " stringByAppendingString:str] duration:2.0f position:CSToastPositionBottom];

               
    
    }
  

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCollectionViewCell *cell = (DDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:FALSE];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.lblName setTextColor:[UIColor blackColor]];

    DDCommentsModal *obj = [eyl_AppDaya.array_Comments objectAtIndex:0];

    NSString *strName = [[self.array_SegmentControl objectAtIndex:self.collectionViewSelectiveIndex] valueForKey:@"keyN"];
    if ([@"registry" isEqualToString:strName])
    {
        obj.strRegistryComments = self.textView_Notes.text;
    }
    else if ([@"what_i_ate_today" isEqualToString:strName]){
        // 1 - What I ate Today
        obj.strWhatIateTodayComments = self.textView_Notes.text;
    }
    else if ([@"sleep_times" isEqualToString:strName]){
        // 2 - Sleep Times
        obj.strSleepTimesComments = self.textView_Notes.text;
    }
    else if ([@"i_had_my_bottle" isEqualToString:strName]){
        // 3 - I had my Bottle
        obj.strIHadMyBottleComments = self.textView_Notes.text;
    }
    else if ([@"nappies" isEqualToString:strName]){
        // 4 - Nappies
        obj.strNappiesComments = self.textView_Notes.text;
    }
    else if ([@"toileting_today_1" isEqualToString:strName]){
        // 5 - Toileting
        obj.strToiletingTodayComments = self.textView_Notes.text;
    }
   
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    DDCollectionViewCell *cell = (DDCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:TRUE];
    [cell setBackgroundColor:[UIColor colorWithRed:193/255.0 green:196/255.0 blue:88/255.0 alpha:1.0]];
    [cell.lblName setTextColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark - Orientation Handling
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.

        if (self.view.frame.size.height==768)
            [self.transparentImageView setImage:[UIImage imageNamed:@"Published_lan"]];
        else
            [self.transparentImageView setImage:[UIImage imageNamed:@"Published_por"]];

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]

    }];
}

-(void)swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer {

    NSLog(@"Swipe Index    %d", self.swipeIndex);
    
    if (self.swipeIndex==6) return;

    [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex inSection:0]];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];


    [self performSelector:@selector(delay_ForOneSecWithincrement) withObject:nil afterDelay:1.0];

}


-(void)swipeHandlerRight :(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"Swipe Index    %d", self.swipeIndex);
    if (self.swipeIndex==0) return;

   [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex inSection:0]];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self performSelector:@selector(delay_ForOneSecWithDecrement) withObject:nil afterDelay:1.0];

}

-(void)textViewLeft :(UISwipeGestureRecognizer *)recognizer
{
    // When moving in right direction
    NSLog(@"Swipe Index    %d", self.swipeIndex);

    [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex inSection:0]];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self performSelector:@selector(delay_ForOneSecWithincrement) withObject:nil afterDelay:1.0];
}

-(void) delay_ForOneSecWithincrement
{
    if (self.swipeIndex==6)return;

    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex+1 inSection:0]];
}

-(void)textViewRight :(UISwipeGestureRecognizer *)recognizer
{
    // When moving in left direction
    NSLog(@"Swipe Index    %d", self.swipeIndex);

    [self collectionView:self.collectionView didDeselectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex inSection:0]];

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];

    [self performSelector:@selector(delay_ForOneSecWithDecrement) withObject:nil afterDelay:1.0];
}

-(void) delay_ForOneSecWithDecrement
{
    if (self.swipeIndex==0) return;
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.swipeIndex-1 inSection:0]];

}
-(void)enableUI{
    //self.view.userInteractionEnabled=YES;
    self.tableView.userInteractionEnabled=YES;
   // [self.view endEditing:YES];
}
-(void)disableUI{
    //self.view.userInteractionEnabled=false;
    self.tableView.userInteractionEnabled=false;
    //[self.view endEditing:YES];
}

#pragma mark AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag==888)
    {
        if (buttonIndex==0)
        {
            // Cancel
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDatePicker" object:nil];
        }
        else
        {
            /*
             * OK
             * Save the previous Daily
             * After Saving, open new Daily Diary
             */
            
            self.loadDailyDiary= TRUE;
            containerView.dateLabel.text=containerView.dateStringSavedForDD;
            [eyl_AppDaya.array_Comments removeAllObjects];
            isComentsAdded=NO;
//              [self clearAllArrays];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Loading Daily Dairy and Registry";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            hud.delegate =self;
            mainArray_segmentControl=[NSMutableArray new];
            [self fetchAllRecords];
          
            [self getDailyDiary: eyl_AppDaya.savePickerDate];
            [self getRegistry:eyl_AppDaya.savePickerDate];
            
           //[self createDiaryDataWithMode:@"draft"];
        }
    }
    else
    {
        
//        if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
//        {
//            RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
//            [eyl_Child:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt forContext:[AppDelegate context]];
//            obk=nil;
//        }
        
        switch (buttonIndex) {
            case 0:// NO
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 1://Cancel
                break;
            case 2:// Yes
            {
                // Save the Data and then exit
                if (self.isDailyDiaryPublished)
                    [self.navigationController popViewControllerAnimated:YES];
                else
                    [self saveAsDraftInDailyDiaryVC:nil];
                
            }
                break;
                
            default:
                break;
        }
    }
}
@end


