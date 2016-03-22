//
//  NewObservationViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NewObservationViewController.h"
#import "MediaObservationCell.h"
#import "ObservationListCell.h"
#import "ObservationAddCell.h"
#import "CellButton.h"
#import "Theme.h"
#import "ChildView.h"
#import "GridViewController.h"
#import "WYPopoverController.h"
#import "MontessoryViewController.h"
#import "EcatViewController.h"
#import "MediaViewController.h"
#import "Media.h"
#import "NewObservationAttachment.h"
#import "AppDelegate.h"
#import "APICallManager.h"
#import "NewObservation.h"
#import "EYFSAssessmentViewController.h"
#import "COELViewController.h"
#import "InvolvementViewController.h"
#import "ChildrenPopupViewController.h"
#import "Child.h"
#import "Practitioners.h"
#import "Utils.h"
#import "Statement.h"
#import "Age.h"
#import "Aspect.h"
#import "Eyfs.h"
#import "Framework.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "Assessment.h"
#import "EYLNewObservationAttachment.h"
#import "DocumentFileHandler.h"
#import "INObservation.h"
#import "INEcat.h"
#import "OBCoel.h"
#import "EYLAgeBand.h"
#import "MontessoriFramework.h"
#import "EcatFramework.h"
#import "Setting.h"
#import "Utils.h"
#import "UIView+Toast.h"
#import "CfeFramework.h"
#import "OBCfe.h"
#import "CfeFramework.h"
#import "Cfe.h"
#import "CfeFramework.h"
#import "CfeLevelTwo.h"
#import "CfeLevelThree.h"
#import "CfeLevelFour.h"
#import "CfeLevel2.h"
#import "CfeLevel4.h"
#import "CfeLevel3.h"
#import "CfeLevel.h"
#import "FrameworkBtnsCollectionViewCell.h"
#import "UIView+Toast.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

NSString* const KMedia=@"Media";
NSString* const KObservation=@"Observation";
NSString *const KAnalysis=@"Analysis";
NSString *const KNextSteps=@"NextSteps";
NSString *const KAdditionalNotes=@"AdditionalNotes";
NSString *const KEYFSAssessment=@"EYFS Assessment";
NSString *const KInvolvement=@"Involvement";
NSString *const KCoel=@"Coel";
NSString *const kMontessory = @"Montessory";
NSString *const kCfe = @"Cfe";
NSString *const KChildrenSelection=@"ChildrenSelection";
NSString *const KEcat=@"Ecat";
NSString *const KFrameworkAssessment=@"Framework Assessment";

BOOL AlertClick;
BOOL isObservationEdited;

@interface EYAlertView : UIAlertView;
@property(strong, nonatomic) NSIndexPath *indexpath;
@end

AppDelegate *appDelegate;
NSString *frameworkType;

@implementation EYAlertView


@end
@interface NewObservationViewController ()<ecatPopOverDelegate,montessoryPopOverDelegate,observationPopOverDelegate,observationListDelegate,involvementPopoverDelegate,coelPopoverDelegate,eyfsPopOverDelegate, ChildrenSelectionPopoverDelegate, UIAlertViewDelegate, WYPopoverControllerDelegate,ChildrenPopupViewDelegate,MediaObservationCellDatasource,ThemeDelegate,MBProgressHUDDelegate>
{
    Theme *theme;
    NSDictionary *addObservationCellButtonText;
    NSDictionary *topLabelDict;
    NSDictionary *topImageDict;
    NSArray *keyArray;
    ChildView *containerView;
    MediaViewController *mediaViewController;
    NSString *currentCellInstanceClick;
    NSMutableArray *indexArray;
    NSNumber *childId;
    NSNumber *practitionerId;
    NSArray *observationAttachments;
    BOOL partiallySaved;
    Practitioners *cachedPractitioner;
    NSMutableArray *cachedChildren;
    NSString *tempOrientationChange;
    NSDate *creteateDate;
    NSString *stringCountEcat;
      NSString *stringCountMon;
      NSString *stringCountInvol;
      NSString *stringCountWell;
      NSString *stringCountCoel;
    Child *mainChild;
    
    NSNumber *observerID;
    
    NSNumber * isSpontaneous;
    BOOL isGreaterThanTwenty;
    BOOL showAlertOnlyOnce;
    BOOL isEYFSContainerVisible;
    BOOL isEcatVisible;
    BOOL  isMontessoaryVisible;
    BOOL  isCfeVisible;
    UIView *transParentView;
    BOOL isRotated;
    NSArray *tempAgeBandArray;
    BOOL isCancel;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSArray * montessoriArray;
    NSArray *cfeArray;
    NSArray * ecatArray;
    BOOL alreadyPopover;
    NSMutableArray *tagsArray;
    MBProgressHUD *hud;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) ChildrenPopupViewController *gridViewController;
@property (strong, nonatomic) IBOutlet UILabel *spontaneosObservation;

@property (strong,nonatomic) ObservationViewController *nextStepViewController;
@property (strong,nonatomic) ObservationViewController *analysisViewController;
@property (strong,nonatomic) ObservationViewController *additionalNotesViewController;
@property (strong,nonatomic) EYFSAssessmentViewController *eyfsAssessmentViewController;
@property (strong,nonatomic) COELViewController *coelViewController;
@property (strong,nonatomic) MontessoryViewController *montessoryViewController;
@property (strong,nonatomic) EcatViewController *ecatViewController;
@property (strong,nonatomic) InvolvementViewController *involvementViewController;
@property (strong,nonatomic)CFEAssessmentViewController *cfeViewController;
@property (strong,nonatomic) WYPopoverController *observationPopOver;
@property (strong,nonatomic) WYPopoverController *nextStepPopOver;
@property (strong,nonatomic) WYPopoverController *analysisPopOver;
@property (strong,nonatomic) WYPopoverController *additionalNotesPopOver;
@property (strong,nonatomic) WYPopoverController *eyfsAssessmentPopOver;
@property (strong,nonatomic) WYPopoverController *cfeAssessmentPopOver;
@property (strong,nonatomic) WYPopoverController *coelPopOver;
@property (strong,nonatomic) WYPopoverController *involvementPopOver;
@property (strong,nonatomic) WYPopoverController *childSelectionPopOver;
@property (strong,nonatomic) WYPopoverController *montessoryPopOver;
@property (strong,nonatomic) WYPopoverController *montessoryTablePopUp;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *mantessoriView;
@property (strong, nonatomic) IBOutlet UIView *eCatView;
@property (strong, nonatomic) IBOutlet UIView *coelView;
@property (strong, nonatomic) IBOutlet UIView *wellbeingView;
@property (strong, nonatomic) IBOutlet NSMutableArray *frameworksArray;
- (IBAction)mediaAddAction:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *MediaNewButton;


@end

@implementation NewObservationViewController



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
   


   // NSArray * array = [NewObservation fetchALLObservationsInContext:[AppDelegate context]];
}

-(void)loadObservation
{
    if (!self.isEditView) {
        childId = [APICallManager sharedNetworkSingleton].cacheChild.childId;
        mainChild=[APICallManager sharedNetworkSingleton].cacheChild;
    }
    else{
        if (!self.isUploadQueue) {
        //    observation=[[NewObservation fetchObservationInContext:[AppDelegate childContext] withPractitionerId:practitionerId withChildId:childId withObservationid:self.observationIdParam] lastObject];
        //    self.spontaneousObservation.on = observation.quickObservation == [NSNumber numberWithInt:1]? YES : NO;
        }
        else
        {
//             observation=[[NewObservation fetchObservationInContext:[AppDelegate childContext] withPractitionerId:practitionerId withChildId:childId withDeviceUUID:self.deviceUUID] lastObject];
//            self.spontaneousObservation.on = observation.quickObservation == [NSNumber numberWithInt:1]? YES : NO;
        }
    }

//
//
//    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [cell loadObservationAttachment];
//    [cell.collectionView reloadData];
}

-(void)refreshMediaCell
{
    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell loadObservationAttachment];
    [cell.collectionView reloadData];

    NSLog(@"Reloaded media cell");
}

-(void)notifyMediaDelete
{
    isObservationEdited = TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_isComeFromNotification)
    {
        _isEditingAllowed=YES;
        self.isEditView=YES;
        childId=self.notificationChild.childId;
        self.childIdParam=childId;
        
        
        [[APICallManager sharedNetworkSingleton].cacheChildren addObject:self.notificationChild];
        [APICallManager sharedNetworkSingleton].cacheChild=self.notificationChild;
        
        
        containerView.childName.text= [[_notificationChild.firstName stringByAppendingString:@" "] stringByAppendingString:_notificationChild.lastName];
        containerView.childGroup.text= _notificationChild.groupName;
        containerView.childImage.image= [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],_notificationChild.photo]];
        
        if([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],_notificationChild.photo]]==nil)
        {
            containerView.childImage.image=[UIImage imageNamed:@"eylog_Logo"];
            //[containerView.childImage setBackgroundColor:[UIColor blackColor]];
            NSLog(@"%@",containerView.childImage);
            
        }
        else
        {
            containerView.childImage.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],_notificationChild.photo]];
        }
        
        
    }

    theme = [Theme getTheme];
    theme.themeDelegate = self;
    [appDelegate.window.rootViewController.view setAlpha:1.0f];
    
    for(UIView *view in appDelegate.window.rootViewController.view.subviews)
    {
        if([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud1=(MBProgressHUD *)view;
            [hud1 removeFromSuperview];
            hud1=nil;
            
        }
    }
    
    if(_isProcessingMedia)
    {
        [_spontaneousObservation setEnabled:NO];
    }
    else{
        [_spontaneousObservation setEnabled:YES];                                                     
    }
   if(self.isEditView)
   {
       theme.observerID=self.observerID;
     
        childId=[APICallManager sharedNetworkSingleton].cacheChild.childId;
       mainChild=[APICallManager sharedNetworkSingleton].cacheChild;
       [APICallManager sharedNetworkSingleton].cacheChildren = [NSMutableArray arrayWithObject:[APICallManager sharedNetworkSingleton].cacheChild];
   }
    
    
    [theme addToolbarItemsToViewCaontroller:self];
    theme.delegate=self;
    isObservationEdited = false;
    
    
    [self.frameworkBtnsCollectionView registerNib:[UINib nibWithNibName:@"FrameworkBtnsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FrameworkBtnsCollectionViewCellID"];
    [self.frameworkBtnsCollectionView setBackgroundColor:[UIColor clearColor]];
    
    self.mantessoriNotificationLabel.hidden = YES;

   //    else
//    {
    
        if (!_eylNewObservation) {
            _eylNewObservation = [self createNewObservation];
        }
        if (!_isUploadQueue) {
            _eylNewObservation.newwObservation.isEditing = YES;
            NSError * error = nil;
            [[AppDelegate context] save:&error];
            NSInteger monteValue = [(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.montessori] count];
            stringCountMon=[NSString stringWithFormat:@"%ld",(long)monteValue];
            
            if (monteValue > 0) {
                self.mantessoriNotificationLabel.hidden = NO;
                self.mantessoriNotificationLabel.text = [NSString stringWithFormat:@"%ld",(long)monteValue];
                
                
            }
            else{
                self.mantessoriNotificationLabel.hidden = YES;
            }
            
            _eylNewObservation.newwObservation.isEditing=YES;
            [[AppDelegate context] save:&error];
            NSInteger ecatValue=[(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.ecat] count];
            stringCountEcat=[NSString stringWithFormat:@"%ld",(long)ecatValue];
            
            if (ecatValue > 0) {
                self.ecatNotificationLabel.hidden=NO;
                self.ecatNotificationLabel.text=[NSString stringWithFormat:@"%ld",(long)ecatValue];
            }else{
                self.ecatNotificationLabel.hidden=YES;
            }
        }
        
        NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];
        stringCountCoel=[NSString stringWithFormat:@"%lu",(unsigned long)coelSelectedArray.count];
        if([_eylNewObservation.scaleInvolvement integerValue]>0)
        {
            stringCountInvol= [NSString stringWithFormat:@"%ld",(long)[_eylNewObservation.scaleInvolvement integerValue]];
        }
        if([ _eylNewObservation.scaleWellBeing integerValue]>0)
        {
            stringCountWell= [NSString stringWithFormat:@"%ld",(long)[ _eylNewObservation.scaleWellBeing integerValue]];
        }
   // }

    montessoriArray = [MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withFramework:@"Montessori"];
    ecatArray = [EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withFramework:@"Ecat"];
    cfeArray=[CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withFramework:@"Cfe"];

    isCancel = YES;
    //[self showEYFSWithMode:NO];
    //[self.eyfsAssessmentViewController doneAction:nil];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.ObservationFlag=1;

    UIBarButtonItem *backbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_backButtonWithLogo"] style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    backbutton.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_backButtonWithLogo"]];
    self.navigationItem.leftBarButtonItem=backbutton;
    containerView=[[[NSBundle mainBundle]loadNibNamed:@"ChildView" owner:self options:nil] objectAtIndex:0];

    INObservation * inObservation = [APICallManager sharedNetworkSingleton].baseClass.label.observation;
   //inObservation.labelAssessment
    NSString *string;
    
    if([[APICallManager sharedNetworkSingleton].settingObject.frameworkType isEqualToString:@"cfe"])
    {
        string=@"CFE Assessment";
        
    }
    else
    {
        string=@"EYFS Assessment";

    }
    
    addObservationCellButtonText=@{KNextSteps: inObservation.labelNextSteps,KAdditionalNotes:inObservation.labelComment,KFrameworkAssessment:string,KObservation:inObservation.labelObservation,KAnalysis:inObservation.labelAnalysis};
    self.spontaneosObservation.text = inObservation.quickObservationTagLabel;

    topLabelDict=@{KMedia : @"Media",
                   KObservation : [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelObservation,
                   KAnalysis : [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelAnalysis,
                   KNextSteps : [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelNextSteps,
                   KAdditionalNotes : [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelComment,
                   KFrameworkAssessment:string};
    //KEYFSAssessment : [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelAssessment
    //KFrameworkAssessment:[APICallManager sharedNetworkSingleton].frameworkType
    topImageDict=@{KMedia:@"icon_media",KObservation:@"icon_observationbox",KAnalysis:@"icon_analysisNew",KNextSteps:@"icon_next-steps",KAdditionalNotes:@"icon_additionalNotes",KFrameworkAssessment:@"icon_eyfsAssessmentNew"};

    keyArray=@[KMedia,KObservation,KAnalysis,KNextSteps,KAdditionalNotes,KFrameworkAssessment];
    if([APICallManager sharedNetworkSingleton].settingObject.frameworkType.length==0)
    {
    frameworkType=@"eyfs";
    }
    else
    {
    frameworkType=[APICallManager sharedNetworkSingleton].settingObject.frameworkType;
    }
   
    [self setEdgesForExtendedLayout];

    [self.InvolvementButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    [self.wellBeingButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    [self.coelButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    [self.ecatButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    [self.mantessori.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    [self.selectOptionButton.titleLabel setFont:[UIFont fontWithName:kSystemFontRobotoR size:14.0f]];
    self.selectOptionButton.layer.borderWidth=0.6f;
    self.selectOptionButton.layer.cornerRadius=8.0f;
    self.selectOptionButton.layer.backgroundColor=(__bridge CGColorRef)(yellowColor);

    self.involvementNotificationLabel.layer.cornerRadius=12.0f;
    self.wellBeingNotificationLabel.layer.cornerRadius=12.0f;
    self.coelNotificationLabel.layer.cornerRadius=12.0f;
    self.ecatNotificationLabel.layer.cornerRadius=12.0f;
    self.involvementNotificationLabel.layer.cornerRadius=12.0f;
    self.mantessoriNotificationLabel.layer.cornerRadius=12.0f;

    self.involvementNotificationLabel.hidden = YES;
    self.wellBeingNotificationLabel.hidden = YES;
    self.coelNotificationLabel.hidden = YES;
   // self.ecatNotificationLabel.hidden = YES;
    self.frameworksArray=[NSMutableArray new];
    if ([APICallManager sharedNetworkSingleton].settingObject.childInvolvement){
        [self.frameworksArray addObject:@"Involvement | Well Being"];
        
    }
    if ([APICallManager sharedNetworkSingleton].settingObject.coel){
          [self.frameworksArray addObject:@"CoEL"];
    }
     if ([APICallManager sharedNetworkSingleton].settingObject.ecat){
          [self.frameworksArray addObject:@"ECaT"];
     }
     if ([APICallManager sharedNetworkSingleton].settingObject.montessori){
          [self.frameworksArray addObject:@"Montessori"];
     }


    NSLog(@"check ecat enable or disabled %ld",(long)[APICallManager sharedNetworkSingleton].settingObject.ecat);
    // Disabling Under Development Frameworks
    //NSLog(@"checking values of settings %ld and %ld",(long)DISPLAY_ECAT,(long)DISPLAY_MONTESSORI);
    if ([APICallManager sharedNetworkSingleton].settingObject.ecat){
        [self.ecatButton setUserInteractionEnabled:YES];
        [self.ecatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.ecatButton setUserInteractionEnabled:NO];
        [self.ecatButton setHidden:YES];
        [self.ecatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
//    CGFloat origin = 20.0f;
//    if ([APICallManager sharedNetworkSingleton].settingObject.childInvolvement == 0) {
//        self.InvolvementButton.hidden = YES;
//        self.wellBeingButton.hidden = YES;
//        self.involvementNotificationLabel.hidden = YES;
//        self.wellBeingNotificationLabel.hidden = YES;
//        self.wellbeingView.hidden = YES;
//    }
//    else{
//        CGRect frame = self.involvementNotificationLabel.frame;
//        self.involvementNotificationLabel.frame = CGRectMake(origin, frame.origin.y, frame.size.width, frame.size.height);
//        origin += frame.size.width;
//    }

     // [self.mantessori setUserInteractionEnabled:NO];
   // [self.mantessori setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if ([APICallManager sharedNetworkSingleton].settingObject.montessori) {
        [self.mantessori setUserInteractionEnabled:YES];
        [self.mantessori setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.mantessori setUserInteractionEnabled:NO];
        [self.mantessori setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mantessori setHidden:YES];
    }
    

    mediaViewController=[[MediaViewController alloc]initWithNibName:NSStringFromClass([mediaViewController class]) bundle:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusUpdate:) name:@"RefreshSelectedStatus" object:nil];

//    self.observationData = [[NSMutableDictionary alloc] init];

    partiallySaved = NO;

    if (!self.isEditView) {
        self.deviceUUID = [[NSUUID UUID] UUIDString];
        NSLog(@"Unique Device ID : %@",self.deviceUUID);
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    [self updateUpperFrame];

    showAlertOnlyOnce = true;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    theme.onlyView=NO;
    appDelegate.ObservationFlag=1;
    if (!self.isEditView) {
        childId=[APICallManager sharedNetworkSingleton].cacheChild.childId;
        practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        _eylNewObservation.practitionerId = practitionerId;
    }
    else
    {
        childId = self.childIdParam;
        practitionerId = self.practitionerIdParam;

        cachedPractitioner = [APICallManager sharedNetworkSingleton].cachePractitioners;
        cachedChildren = [APICallManager sharedNetworkSingleton].cacheChildren;

//        [APICallManager sharedNetworkSingleton].cacheChildren = [NSMutableArray arrayWithObjects:[[Child fetchChildInContext:[AppDelegate context] withChildId:childId] lastObject], nil] ;
        Practitioners * pract = [[Practitioners fetchPractitionersInContext:[AppDelegate context] withPractitionerId:practitionerId] lastObject];
        if (pract) {
            [APICallManager sharedNetworkSingleton].cachePractitioners = pract;
        }
        [self loadObservation];

        if (!self.isUploadQueue) {
            [APICallManager sharedNetworkSingleton].editingUploadQueue = YES;
        }
    }

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

    {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2+250 , -10, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"internalNotes"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPopoverForInternalNotes) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:btn];

       // appDelegate.ObservationFlag=1;
        NSLog(@"landscape");
        [UIView animateWithDuration:0.0 animations:^{

             containerView.frame=CGRectMake(self.view.frame.size.width-955, 0, 950, 40);
             containerView.hidden=NO;
        }];
    }
    else
    {
       btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2+120 , -10, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"internalNotes"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPopoverForInternalNotes) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addSubview:btn];

        NSLog(@"portrait");
        //appDelegate.ObservationFlag=1;
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-720, 0, 715, 40);

            containerView.hidden=NO;
        }];
    }
   [containerView.dateLabel setHidden:NO];
    containerView.delegate = self;
//    containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count  ];
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
if(_isProcessingMedia)
{
    containerView.childDropDown.hidden=YES;
    [containerView.childDropDown setEnabled:NO];
    
}
  
    

    [theme resetTargetViewController:self];
    NSLog(@"%@",self.navigationController.navigationBar.subviews);
    
    if(![self.navigationController.navigationBar.subviews containsObject:containerView])
    {
        [self.navigationController.navigationBar addSubview:containerView];
    }
    [self.navigationController.navigationBar insertSubview:btn aboveSubview:containerView];
    
}
-(void)updateUpperFrame{

    self.involvementNotificationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.ecatNotificationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.coelNotificationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.mantessoriNotificationLabel.translatesAutoresizingMaskIntoConstraints = YES;

    CGFloat origin = 20.0f;
    if ([APICallManager sharedNetworkSingleton].settingObject.childInvolvement == 0) {
        self.InvolvementButton.hidden = YES;
        self.wellBeingButton.hidden = YES;
        self.involvementNotificationLabel.hidden = YES;
        self.wellBeingNotificationLabel.hidden = YES;
        self.wellbeingView.hidden = YES;
    }
    else{
        CGRect frame = self.involvementNotificationLabel.frame;
        self.involvementNotificationLabel.frame = CGRectMake(origin, frame.origin.y, frame.size.width, frame.size.height);
        origin += frame.size.width;
    }

    //CGRect frame = self.coelNotificationLabel.frame
    //self.coelNotificationLabel.frame = CGRectMake(origin, frame.origin.y, frame.size.width, frame.size.height);
    //origin += frame.size.width;

    if ([APICallManager sharedNetworkSingleton].settingObject.ecat == 0) {

        self.ecatButton.hidden = YES;
        self.ecatNotificationLabel.hidden = YES;
        self.eCatView.hidden = YES;
    }
    else{
        CGRect frame = self.ecatNotificationLabel.frame;
        self.ecatNotificationLabel.frame = CGRectMake(origin, frame.origin.y, frame.size.width, frame.size.height);
        origin += frame.size.width;
    }
    if ([APICallManager sharedNetworkSingleton].settingObject.montessori == 0) {
        self.mantessori.hidden = YES;
        self.mantessoriNotificationLabel.hidden = YES;
        self.mantessoriView.hidden = YES;
    }
    else{
        CGRect frame = self.mantessoriNotificationLabel.frame;
        self.mantessoriNotificationLabel.frame = CGRectMake(origin, frame.origin.y, frame.size.width, frame.size.height);
        origin += frame.size.width;
    }
    //[self updateViewConstraints];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    [self showInvolvementWellbeing];

    if(self.isEditingAllowed)
    {
        self.spontaneousObservation.userInteractionEnabled=YES;
        
    }
    else
    {
       self.spontaneousObservation.userInteractionEnabled=NO;
    }
    self.spontaneousObservation.on = [_eylNewObservation.quickObservation integerValue] == 1? YES : NO;

    //containerView.dateLabel.text = [Utils getDateStringFromDate:_eylNewObservation.observationCreatedAt?:[NSDate date]];

    [super viewDidAppear:animated];
     appDelegate.ObservationFlag=1;

    // For disabling the drop down button when the observation is opened from draft list
//    [containerView.childImageButton setUserInteractionEnabled:!self.isEditView];
//    [containerView.childDropDown setUserInteractionEnabled:!self.isEditView];
//    [containerView.childDropDown setEnabled:!self.isEditView];
//    [containerView.childImageButton setEnabled:!self.isEditView];

    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
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
            //containerView.frame=CGRectMake(self.view.frame.size.width-700, 0, 715, 40);
            containerView.frame =CGRectMake(self.view.frame.size.width-720, 0, 715, 40);
            containerView.hidden=NO;
        }];
        }
    
    }
-(void)showInvolvementWellbeing{

        NSInteger involvementValue = [_eylNewObservation.scaleInvolvement integerValue];
        NSInteger welBeingValue = [_eylNewObservation.scaleWellBeing integerValue];

        if (involvementValue > 0) {
            self.involvementNotificationLabel.hidden = NO;
            self.involvementNotificationLabel.text = [NSString stringWithFormat:@"%ld",(long)involvementValue];
        }
        else{
            self.involvementNotificationLabel.hidden = YES;
        }
        if (welBeingValue > 0) {
            self.wellBeingNotificationLabel.hidden = NO;
            self.wellBeingNotificationLabel.text = [NSString stringWithFormat:@"%ld",(long)welBeingValue];
        }
        else{
            self.wellBeingNotificationLabel.hidden = YES;
        }

        // Added by ankit khetrapal to show coel notificaion on view load
        NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];

        if ([coelSelectedArray count] > 0) {
        self.coelNotificationLabel.hidden = NO;
        self.coelNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[coelSelectedArray count]];
        }
        else{
        self.coelNotificationLabel.hidden = YES;
        }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [containerView.dateLabel setHidden:YES];
    [btn removeFromSuperview];
    [containerView removeFromSuperview];

    if (self.isEditView) {
        [APICallManager sharedNetworkSingleton].cachePractitioners = cachedPractitioner;
        [APICallManager sharedNetworkSingleton].cacheChildren = cachedChildren;
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
  [APICallManager sharedNetworkSingleton].isFromDraftList=NO;
//    if([APICallManager sharedNetworkSingleton].cacheChildren.count==1)
//    {
//        [[APICallManager sharedNetworkSingleton].cacheChildren removeAllObjects];
//
//    }
    
    
    
}
-(void)statusUpdate:(NSNotification *)notification
{
//    containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count];
    if([APICallManager sharedNetworkSingleton].cacheChildren.count<=1)
    {
        containerView.childNotificationLabel.text = nil;
        [containerView.childNotificationLabel setHidden:YES];
    }
    else
    {
        [containerView.childNotificationLabel setHidden:NO];
        containerView.childNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[APICallManager sharedNetworkSingleton].cacheChildren.count  ];
    }

    containerView.childImage.image=[Utils getChildImage];
    containerView.childName.text=[Utils getChildName];
    containerView.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];

}


-(void)backButtonClick
{

    if(isObservationEdited)
    {
       if(self.isEditingAllowed)
       {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to save this observation as draft before you leave ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Cancel", @"Yes",nil];

        [alert show];
       }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    else
    {
        [self goBack];
    }

}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    // For Housekeeping
    [self manageData];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView==self.frameworkBtnsCollectionView)
    {
    NSString *str = [self.frameworksArray objectAtIndex:indexPath.row];
    CGSize calCulateSizze =[str sizeWithAttributes:NULL];
    NSLog(@"%f     %f",calCulateSizze.height, calCulateSizze.width);
    if([str isEqualToString:@"ECaT"]||[str isEqualToString:@"CoEL"])
    {
    calCulateSizze.height = 64;

     calCulateSizze.width = calCulateSizze.width+30;
    }
    else
    {
        
          calCulateSizze.height = 64;
        calCulateSizze.width = calCulateSizze.width+50;
   }
    
       return calCulateSizze;
    }
     CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
    return defaultSize;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==self.frameworkBtnsCollectionView)
    {
        return self.frameworksArray.count;
        
    }
    else
    {
    return 6;

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==self.frameworkBtnsCollectionView)
    {
        FrameworkBtnsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"FrameworkBtnsCollectionViewCellID" forIndexPath:indexPath];
        [cell.nameLabel setTitle:[self.frameworksArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
      //self.mantessoriNotificationLabel.text
                cell.firstNotificationLabel.hidden=YES;
        
        if([cell.nameLabel .currentTitle isEqualToString:@"Montessori"])
           {
               if(stringCountMon!=nil&&![stringCountMon isEqualToString:@"0"])
               {
               cell.seconNotificationLabel.text=stringCountMon;
               cell.seconNotificationLabel.hidden=NO;
               }
               else
               {
                   cell.seconNotificationLabel.hidden=YES;

               }
           }
        if([cell.nameLabel .currentTitle isEqualToString:@"Involvement | Well Being"])
        {
            if(stringCountInvol!=nil&&![stringCountInvol isEqualToString:@"0"])
            {
                cell.seconNotificationLabel.text=stringCountInvol;
                cell.seconNotificationLabel.hidden=NO;

            }
            else
            {
                cell.seconNotificationLabel.hidden=YES;
                
            }

          
            if(stringCountWell!=nil&&![stringCountWell isEqualToString:@"0"])
            {
            cell.firstNotificationLabel.text=stringCountWell;
                 cell.firstNotificationLabel.hidden=NO;
            }
           
        }
      
        if([cell.nameLabel .currentTitle isEqualToString:@"ECaT"]||[cell.nameLabel .currentTitle isEqualToString:@"CoEL"])
        {
            CGRect rect1=CGRectMake(0, 15,  cell.frame.size.width-100,  cell.frame.size.height);
            [cell.nameLabel setFrame:rect1];
            CGRect rect=cell.seconNotificationLabel.frame;
            [cell.seconNotificationLabel removeFromSuperview];
            
            cell.seconNotificationLabel = [[UILabel alloc] init];
            cell.seconNotificationLabel.hidden=YES;
            cell.firstNotificationLabel.hidden=YES;
            [cell.seconNotificationLabel setTextAlignment:NSTextAlignmentCenter];
            
            [cell.seconNotificationLabel setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:191.0/255.0 alpha:1.0f]];
            
            [cell.seconNotificationLabel setFrame:CGRectMake(35, rect.origin.y, 26, 26)];
            [cell addSubview:cell.seconNotificationLabel];
            if([cell.nameLabel .currentTitle isEqualToString:@"ECaT"])
            {
                if(stringCountEcat!=nil&&![stringCountEcat isEqualToString:@"0"])
                {
                cell.seconNotificationLabel.text=stringCountEcat;
                cell.seconNotificationLabel.hidden=NO;
                }
                else
                {
                    cell.seconNotificationLabel.hidden=YES;
                    
                }


            }
            if([cell.nameLabel .currentTitle isEqualToString:@"CoEL"])
            {
                if(stringCountCoel!=nil&&![stringCountCoel isEqualToString:@"0"])
                {
                cell.seconNotificationLabel.text=stringCountCoel;
                cell.seconNotificationLabel.hidden=NO;
                }
                else
                {
                    cell.seconNotificationLabel.hidden=YES;
                    
                }


            }
            
            
        }
        else
        {
        CGRect rect=CGRectMake(0, 15,  cell.frame.size.width-50,  cell.frame.size.height);
        [cell.nameLabel setFrame:rect];
        }
//        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 14, 1, cell.frame.size.height-22)];
//        seperatorView.backgroundColor = [UIColor grayColor];
//        [collectionView addSubview:seperatorView];
//        [collectionView bringSubviewToFront:seperatorView];
        return cell;
        
    }
    else
    {
    static NSString *cellIdentifier = @"ObservationMediaCell";
    static NSString *cellListIdentifier=@"ObservationListCell";
    static NSString *cellAddIdentifier=@"ObservationAddCell";
       
    if(indexPath.row==0)
    {
        MediaObservationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
        NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
        [cell setThumbnailsArray:[NSMutableArray arrayWithArray:array]];
        cell.cellDatasource = self;
        cell.topLabel.font = [UIFont fontWithName:kSystemFontRobotoR size:14.0f];
        cell.isEditView = self.isEditView;
        cell.controller = self;
        [cell.addPlusClicked addTarget:self action:@selector(MediaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        if(_isProcessingMedia)
        {
            cell.isProcessingMedia=YES;
            [cell hideSubViews];
            
            
        }
        
        
        cell.deviceUUID = self.deviceUUID;
        if (self.isEditView) {
            cell.childIdParam = self.childIdParam;
            cell.practitionerIdParam = self.practitionerIdParam;

            if (!self.isUploadQueue) {
                cell.isDraft = YES;
            }
        }
        return cell;
    }
    else
    {
        ObservationListCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellListIdentifier forIndexPath:indexPath];
           if(indexPath.row==1){
            if (_eylNewObservation.observation.length >0) {
                [cell.plusBtn setHidden:YES];
                [cell.plusLabel setHidden:YES];
            }
            else{
                [cell.plusBtn setHidden:NO];
                [cell.plusLabel setHidden:NO];
            }
            cell.textView.text=_eylNewObservation.observation;

        }
        else if(indexPath.row==2){
          
           
                if (_eylNewObservation.analysis.length >0) {
                    [cell.plusBtn setHidden:YES];
                    [cell.plusLabel setHidden:YES];
                }
                else{
                    [cell.plusBtn setHidden:NO];
                    [cell.plusLabel setHidden:NO];
                    
                }
            
            cell.textView.text=_eylNewObservation.analysis;

        }
        else if(indexPath.row==3){
            if (_eylNewObservation.nextSteps.length >0) {
                [cell.plusBtn setHidden:YES];
                [cell.plusLabel setHidden:YES];
            }
            else{
                [cell.plusBtn setHidden:NO];
                [cell.plusLabel setHidden:NO];

            }
            cell.textView.text=_eylNewObservation.nextSteps;
        }
        else if(indexPath.row==4){
            if (_eylNewObservation.additionalNotes.length >0) {
                [cell.plusBtn setHidden:YES];
                [cell.plusLabel setHidden:YES];
            }
            else{
                [cell.plusBtn setHidden:NO];
                [cell.plusLabel setHidden:NO];

            }
            cell.textView.text=_eylNewObservation.additionalNotes;
        }
        else if(indexPath.row==5)
        {
             NSString *textStatement = @"";
            if([frameworkType isEqualToString:@"cfe"])
            {
                NSArray *selectedList = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
                cell.textView.text=nil;
            
                for (OBCfe *obCfe in selectedList) {
                    BOOL isLevelThree;
                 
                    CfeLevelFour *lvlfour=[[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:obCfe.cfeFrameworkItemId withFrameWork:NSStringFromClass([Cfe class])]lastObject];
                    CfeLevelThree *lvlThree;
                    if (lvlfour) {
                        isLevelThree=NO;
                        lvlThree=[[CfeLevelThree fetchCfeLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:lvlfour.levelThreeIdentifier withFramework:NSStringFromClass([Cfe class])] lastObject];
                    }else{
                        isLevelThree=YES;
                        lvlThree=[[CfeLevelThree fetchCfeLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:obCfe.cfeFrameworkItemId withFramework:NSStringFromClass([Cfe class])] lastObject];
                    }
                    
                    
                    CfeLevelTwo *lvlTwo=[[CfeLevelTwo fetchCfeLevelTwoInContext:[AppDelegate context] withlevelTwoIdentifier:lvlThree.levelTwoIdentifier withFramework:NSStringFromClass([Cfe class])] lastObject];
                    
                    CfeFramework *lvlOne=[[CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withLevelIdentifier:lvlTwo.levelOneIdentifier withFramework:NSStringFromClass([Cfe class])]lastObject];
                    
                    if (isLevelThree) {
                        textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
                    }else{
                        textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
                    }
//                    NSMutableArray *SavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
//                    OBCfe *dict=[SavedArray firstObject];
                    if(obCfe.cfeFrameworkLevelNumber!=[NSNumber numberWithInteger:0])
                    {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,[NSNumber numberWithInteger:obCfe.cfeFrameworkLevelNumber.integerValue]];
                        //OR assessmentLevel == %@",obEyfs.assessmentLevel,[NSNumber numberWithInteger:obEyfs.assessmentLevel.integerValue]
                    NSArray *array=[CfeAssesmentDataBase fetchAllCfeAssessmentInContext:[AppDelegate context]];
                    CfeAssesmentDataBase * database = [[array filteredArrayUsingPredicate:predicate]firstObject];
                    textStatement=  [textStatement stringByAppendingString:[NSString stringWithFormat:@"--->%@\n\n",database.levelDescription]];
                    }
                    else
                    {
                    textStatement=  [textStatement stringByAppendingString:@"\n"];
                    }
                    
                    
                }
                if (textStatement.length>0) {
                    cell.textView.text=[NSString stringWithFormat:@"\n%@\n%@",cell.textView.text,textStatement];
                    [cell.plusLabel setHidden:YES];
                    [cell.plusBtn setHidden:YES];
                }
                else
                {
                    [cell.plusLabel setHidden:NO];
                    [cell.plusBtn setHidden:NO];
                    
                }
                 cell.textView.text = textStatement;

            }
            else   if([frameworkType isEqualToString:@"eyfs"])
            {
                            NSArray *selectedList = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsStatement];
                            NSMutableArray *ageBandArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsAgeBand];
                
                            NSString *textStatement = @"";
                
                            for (OBEyfs *obEyfs in selectedList) {
                
                                NSString *assesmentType = @"";
                                Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
                                NSNumber *ageIdentifier = nil;
                                if (statement) {
                                    ageIdentifier = statement.ageIdentifier;
                                }
                                else{
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assessmentLevel == %@ OR assessmentLevel == %@",obEyfs.assessmentLevel,[NSNumber numberWithInteger:obEyfs.assessmentLevel.integerValue]];
                                    NSArray *array = [selectedList filteredArrayUsingPredicate:predicate];
                                    if (array.count > 1) {
                                        predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",obEyfs.frameworkItemId];
                                        NSArray *array = [ageBandArray filteredArrayUsingPredicate:predicate];
                                        [ageBandArray removeObjectsInArray:array];
                                        continue;
                                    }
                                    ageIdentifier = @(obEyfs.frameworkItemId.integerValue);
                                }
                                Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
                
                                for (EYLAgeBand *eylAgeBand in ageBandArray) {
                                   // if (eylAgeBand.levelNumber.integerValue == obEyfs.assessmentLevel.integerValue && eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue) {
                                    if (eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue){
                                        [ageBandArray removeObject:eylAgeBand];
                                        break;
                                    }
                                }
                
                                Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
                
                                Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
                                if((!age && !aspect && !eyfs ))
                                    continue;
                                textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc];
                                if (statement) {
                                    textStatement = [textStatement stringByAppendingString:[NSString stringWithFormat:@"\n--->%@%@\n\n",statement.statementDesc,assesmentType]];
                                }
                                else{
                                    textStatement = [textStatement stringByAppendingString:@"\n\n"];
                                }
                            }
                            for (EYLAgeBand *eylAgeBand in ageBandArray) {
                                if (eylAgeBand.levelNumber.integerValue != 0) {
                                    Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:eylAgeBand.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
                                    Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
                
                                    Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
                                    if(!age && !aspect && !eyfs )
                                        continue;
                                    textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc];
                                }
                            }
                          textStatement = [textStatement stringByReplacingOccurrencesOfString:@"(null)" withString:[NSString string]];
                            if (textStatement.length >0) {
                                [cell.plusLabel setHidden:YES];
                                [cell.plusBtn setHidden:YES];
                            }
                            else{
                                [cell.plusLabel setHidden:NO];
                                [cell.plusBtn setHidden:NO];
                            }
                        cell.textView.text = textStatement;
            
            
            }
            
             }
        if([isSpontaneous integerValue]==1 && cell.textView.text.length==0 &&indexPath.row!=1)
        {
            [cell.plusBtn setHidden:YES];
            [cell.plusLabel setHidden:YES];
             [cell.textView setBackgroundColor:[UIColor blackColor]];
            [cell.textView setAlpha:0.25];
            
        }
        else
        {
            [cell.textView setBackgroundColor:[UIColor clearColor]];
            [cell.textView setAlpha:1.0f];
            
        }
        cell.plusLabel.text=[addObservationCellButtonText objectForKey:[keyArray objectAtIndex:indexPath.row]];
        cell.plusLabel.font=[UIFont fontWithName:kSystemFontRobotoR size:20.0f];
        cell.delegate=self;
        cell.indexPath=indexPath;
        cell.topLabel.font=[UIFont fontWithName:kSystemFontRobotoR size:14.0f];
        cell.topImageView.image=[UIImage imageNamed:[topImageDict objectForKey:[keyArray objectAtIndex:indexPath.row]]];
        cell.topLabel.text=[topLabelDict objectForKey:[keyArray objectAtIndex:indexPath.row]];
        
        return cell;
        
    }
    return nil;
    }
}

-(void)showSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    
    if(_isProcessingMedia)
    {
        if(indexPath.row==0)
        {
               [self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
            
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"This Observation is under proccessing so cannot be edited" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            
        }
        else
        {
            [self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"This observation cannot be edited" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
        }
        
    }
    else{
    if(self.isEditingAllowed)
    {
    isObservationEdited = TRUE;
    if (alreadyPopover) {
        return;
    }
    alreadyPopover=YES;
    if(indexPath.row==1)
    {
        currentCellInstanceClick=KObservation;
        [self showPopOverObservation];
    }
    else if(indexPath.row==2)
    {
        currentCellInstanceClick=KAnalysis;
        [self showPopOverAnalysis];
    }
    else if (indexPath.row==3)
    {
        currentCellInstanceClick=KNextSteps;
        [self showPopOverNextStep];
    }
    else if(indexPath.row==4)
    {
        currentCellInstanceClick=KAdditionalNotes;
        [self showPopOverAdditionalNotes];
    }
    else if (indexPath.row==5)
   {
       
       if([frameworkType isEqualToString:@"cfe"])
       {
                currentCellInstanceClick=kCfe;
                [self showCfeAssessment];

       }
       else  if([frameworkType isEqualToString:@"eyfs"])
       {
            currentCellInstanceClick=KEYFSAssessment;
             [self showEYFSAssessment];
       
       }
       
       
    }
    }
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView ==self.frameworkBtnsCollectionView)
    {
        NSString *str=[self.frameworksArray objectAtIndex:indexPath.row];
     
        if([str isEqualToString:@"Involvement | Well Being"])
        {
        
            isObservationEdited = TRUE;
            currentCellInstanceClick=KInvolvement;
            [self showInvolvementPopOver];
            

            
        }
        if([str isEqualToString:@"CoEL"])
        {
            isObservationEdited = TRUE;
            currentCellInstanceClick=KCoel;
            [self showPopOverCOEL];

            
        }
        if([str isEqualToString:@"ECaT"])
        {
             [self ecatpopover];
        }
        if([str isEqualToString:@"Montessori"])
        {
            [self montessoryPopover];
        }
   
    }
    else
    {
        if(_isProcessingMedia)
        {
            if(indexPath.row==0)
            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Media is under Processing State" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
                [self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
                
            }
            else
            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"This observation cannot be edited" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
            [self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
            }
            
        }
        else{

        
    switch (indexPath.row) {
        case 0:
        {
            if(self.isEditingAllowed)
            {
            MediaObservationCell * cell = (MediaObservationCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [self MediaButtonClicked:cell.addPlusClicked];
            }
        }
            break;
        default:{
            if(self.isEditingAllowed)
            {
            [self showSelectedWithIndexPath:indexPath];
            }

        }
            break;
    }
        }
    }
}

-(void)editButtonClicked:(ObservationListCell *)object
{
    [self showSelectedWithIndexPath:object.indexPath];
}

-(void)addObservationButtonClicked:(ObservationAddCell *)object
{
    [self showSelectedWithIndexPath:object.indexPath];
}

-(IBAction)coelAction:(id)sender
{
    isObservationEdited = TRUE;
    currentCellInstanceClick=KCoel;
    [self showPopOverCOEL];
}

-(IBAction)involvementAndWelBeingAction:(id)sender
{
    isObservationEdited = TRUE;
    currentCellInstanceClick=KInvolvement;
    [self showInvolvementPopOver];
}

-(void)showInvolvementPopOver
{
    if (!self.involvementPopOver)
    {
        self.involvementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"involvementViewControllerId"];
        _involvementPopOver = [[WYPopoverController alloc] initWithContentViewController:self.involvementViewController];
        self.involvementViewController.delegate=self;
        self.involvementViewController.eylNewObservation=self.eylNewObservation;
        self.involvementPopOver=[self setPopoverProperties:self.involvementPopOver];
        if (self.isEditView) {
            self.involvementViewController.selectedInvolvementIndex = _eylNewObservation.scaleInvolvement.integerValue -1;
            self.involvementViewController.selectedWellBeingIndex = _eylNewObservation.scaleWellBeing.integerValue -1;
        }
        else
        {
            self.involvementViewController.selectedInvolvementIndex = -1;
            self.involvementViewController.selectedWellBeingIndex = -1;
        }
    }
    
    self.involvementPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.involvementPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}

-(void)showPopOverCOEL
{
    // Edited By : Ankit Khetrapal
    //Reason : As we need to reload the pop over if the earlier changes were not saved
    //if (!self.coelPopOver)
    //{

        NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];

        NSLog(@"Loaded Array of Selected COEL: %@", coelSelectedArray);

        self.coelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coelViewControllerId"];
        _coelPopOver = [[WYPopoverController alloc] initWithContentViewController:self.coelViewController];
        self.coelViewController.delegate=self;
        self.coelPopOver=[self setPopoverProperties:self.coelPopOver];
        self.coelViewController.isEditView = self.isEditView;
        self.coelViewController.isUploadQueue = self.isUploadQueue;

        // Edited By : Ankit Khetrapal
        //Reason : As the selected list has to be shown even in the case of one observation
        //if (self.isEditView) {
            self.coelViewController.selectedList = coelSelectedArray;
        //}
    //}

    self.coelPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.coelPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}
-(void)showPopoverForInternalNotes
{

    if (!self.observationPopOver)
    {
        self.observationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"observationViewControllerId"];
        _observationPopOver = [[WYPopoverController alloc] initWithContentViewController:self.observationViewController];
        self.observationViewController.delegate=self;
        self.observationViewController.deviceUUID = self.deviceUUID;
        [self.observationViewController.tableView setHidden:YES];
        
        self.observationPopOver=[self setPopoverProperties:self.observationPopOver];
        if (self.isEditView && !self.isUploadQueue) {
            self.observationViewController.isDraft = YES;
        }
    }
     [self.observationViewController setEylNewObservationAttachmentArray:nil];
    
    self.observationViewController.topLabel.text =@"Internal Notes";   //@"Observation";
    self.observationViewController.textView.text=   _eylNewObservation.internalNotes;
    self.observationPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.observationPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];

}
-(void)showPopOverObservation
{
    if (!self.observationPopOver)
    {
        self.observationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"observationViewControllerId"];
        _observationPopOver = [[WYPopoverController alloc] initWithContentViewController:self.observationViewController];
        self.observationViewController.delegate=self;
        self.observationViewController.deviceUUID = self.deviceUUID;
        self.observationPopOver=[self setPopoverProperties:self.observationPopOver];
        if (self.isEditView && !self.isUploadQueue) {
            self.observationViewController.isDraft = YES;
        }
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSMutableArray * array = (NSMutableArray *)[_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    [self.observationViewController setEylNewObservationAttachmentArray:array];
    self.observationViewController.topLabel.text = [topLabelDict objectForKey:currentCellInstanceClick];   //@"Observation";
    self.observationViewController.textView.text=   _eylNewObservation.observation;
    self.observationPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.observationPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}
-(void)showEYFSAssessment {
    [self showEYFSWithMode:YES];
}
-(void)showCfeAssessment
{
    [self showCfeWithMode:YES];


}
- (void)showCfeWithMode:(BOOL)mode {
    self.cfeViewController = [[CFEAssessmentViewController alloc] initWithNibName:@"CFEAssessmentViewController" bundle:nil];
    self.cfeViewController.delegate=self;
    currentCellInstanceClick=kCfe;
   
    //NSMutableArray *montessoryArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.montessori];
   // NSLog(@"Loaded montessoryArray %@", montessoryArray);
   // self.cfeViewController.selectedList = montessoryArray;
    if(self.cfeViewController.cfeArray.count==0)
    {
    self.cfeViewController.cfeArray = [NSMutableArray arrayWithArray:cfeArray];
    }
   
  NSMutableArray *SavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
    self.cfeViewController.selectedList=SavedArray;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
   // _montessoryViewController.delegate=self;
    isCfeVisible=YES;
    
    [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^
     {
         
         if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
             if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
                 self.cfeViewController.view.frame = CGRectMake(20,80,screenHeight-50,screenWidth-150);
             }else{
                 self.cfeViewController.view.frame = CGRectMake(20,80,screenWidth-50,screenHeight-200);
             }
         }else{
             self.cfeViewController.view.frame = CGRectMake(20,80,screenWidth-50,screenHeight-200);
         }
         transParentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screenWidth+500 ,screenHeight+500)];
         transParentView.backgroundColor=[UIColor whiteColor];
         transParentView.alpha=0.8;
         [self.navigationController.view addSubview:transParentView];
         [self.navigationController.view addSubview:self.cfeViewController.view];
         [self.navigationController.view bringSubviewToFront:self.cfeViewController.view];
        [self.cfeViewController filterDataBaseOnSegment];
         
     }completion:^(BOOL finished){
         
     }];
}

- (void)showEYFSWithMode:(BOOL)mode {
    currentCellInstanceClick=KEYFSAssessment;
    if (!self.eyfsAssessmentPopOver)
    {
        self.eyfsAssessmentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EYFSAssessmentViewControllerId"];
        _eyfsAssessmentPopOver = [[WYPopoverController alloc] initWithContentViewController:self.eyfsAssessmentViewController];
        self.eyfsAssessmentViewController.delegate=self;
        self.eyfsAssessmentPopOver=[self setPopoverProperties:self.eyfsAssessmentPopOver];
        isRotated = NO;
    }
    if (isRotated == FALSE) {
        NSMutableArray *eyfsSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsStatement];
        NSLog(@"Loaded eyfsAgeArray of Selected eyfsStatement: %@", eyfsSelectedArray);
        self.eyfsAssessmentViewController.selectedList = eyfsSelectedArray;

        NSMutableArray *eyfsAgeArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsAgeBand];
        if (!eyfsAgeArray) {
            eyfsAgeArray = [NSMutableArray array];
        }
        if (eyfsAgeArray.count == 0) {
            for (OBEyfs *obEyfs in eyfsSelectedArray) {
                NSNumber *ageIdentitfier = nil;
                Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] firstObject];
                if (statement) {
                    ageIdentitfier = statement.ageIdentifier;
                }
                else{
                    ageIdentitfier = [NSNumber numberWithInteger:obEyfs.frameworkItemId.integerValue];
                }
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",ageIdentitfier];
                NSArray *array = [eyfsAgeArray filteredArrayUsingPredicate:predicate];
                if (array.count == 0 || array == nil) {
                    EYLAgeBand *eylAgeBand = [[EYLAgeBand alloc]init];
                    eylAgeBand.ageIdentifier = ageIdentitfier;
                    eylAgeBand.levelNumber = obEyfs.assessmentLevel;
                    Assessment *assesment = [[Assessment fetchAssessmentInContext:[AppDelegate context] withLevelValue:eylAgeBand.levelNumber] firstObject];
                    if (assesment) {
                        NSArray *colors = [assesment.color componentsSeparatedByString:@","];
                        UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                        eylAgeBand.backgroundColor = color;
                    }
                    [eyfsAgeArray addObject:eylAgeBand];
                }
            }
        }
        NSLog(@"Loaded eyfsAgeArray of Selected eyfsAgeBand: %@", eyfsAgeArray);
        self.eyfsAssessmentViewController.selectedAgeBandAssessmentList = eyfsAgeArray;
        tempAgeBandArray = eyfsAgeArray;

        [self.eyfsAssessmentViewController reloadTableData];
        self.eyfsAssessmentViewController.topLabel.text = [topLabelDict objectForKey:currentCellInstanceClick];  //@"EYFS Assessment";
        self.eyfsAssessmentViewController.textView.text= _eylNewObservation.observation;
    }
    self.eyfsAssessmentPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    if (mode) {
        [self.eyfsAssessmentPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
    }
    // NSLog(@"hellllo");
}

-(void)showPopOverAdditionalNotes
{
    if (!self.additionalNotesPopOver)
    {
        self.additionalNotesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"observationViewControllerId"];
        _additionalNotesPopOver = [[WYPopoverController alloc] initWithContentViewController:self.additionalNotesViewController];
        self.additionalNotesViewController.delegate=self;
        self.additionalNotesViewController.deviceUUID = self.deviceUUID;
        self.additionalNotesPopOver=[self setPopoverProperties:self.additionalNotesPopOver];
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSMutableArray * array = (NSMutableArray *)[_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    [self.additionalNotesViewController setEylNewObservationAttachmentArray:array];
    self.additionalNotesViewController.topLabel.text = [topLabelDict objectForKey:currentCellInstanceClick];  //@"Additional Notes";
    self.additionalNotesViewController.textView.text= _eylNewObservation.additionalNotes;
    self.additionalNotesPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.additionalNotesPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}

-(void)showPopOverAnalysis
{
    if (!self.analysisPopOver)
    {
        self.analysisViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"observationViewControllerId"];

        _analysisPopOver = [[WYPopoverController alloc] initWithContentViewController:self.analysisViewController];
        self.analysisViewController.delegate=self;
        self.analysisViewController.deviceUUID = self.deviceUUID;
        self.analysisPopOver=[self setPopoverProperties:self.analysisPopOver];
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSMutableArray * array = (NSMutableArray *)[_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    [self.analysisViewController setEylNewObservationAttachmentArray:array];
    self.analysisViewController.topLabel.text = [topLabelDict objectForKey:currentCellInstanceClick];
    self.analysisViewController.textView.text= _eylNewObservation.analysis;
    self.analysisPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);

    [self.analysisPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}

-(void)showPopOverNextStep
{
    
    NSMutableArray *montessoryArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.montessori];
    NSMutableArray *eyfsSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsStatement];
     NSMutableArray *cfeFrameworkArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
    NSLog(@"Loaded eyfsAgeArray of Selected eyfsStatement: %@", eyfsSelectedArray);
    NSMutableArray *eyfsAgeArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsAgeBand];
    if (!self.nextStepPopOver)
    {
        self.nextStepViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"observationViewControllerId"];
        _nextStepPopOver = [[WYPopoverController alloc] initWithContentViewController:self.nextStepViewController];
        self.nextStepViewController.delegate=self;
        self.nextStepViewController.deviceUUID = self.deviceUUID;
       
        self.nextStepViewController.showEYFS = YES;
        
        if ([APICallManager sharedNetworkSingleton].settingObject.montessori) {
            self.nextStepViewController.showMontessori=YES;
        }
        self.nextStepPopOver=[self setPopoverProperties:self.nextStepPopOver];
    }
    self.nextStepViewController.cfeData = cfeFrameworkArray;

    self.nextStepViewController.montessoriData = montessoryArray;
    self.nextStepViewController.eyfsData=eyfsSelectedArray;
    self.nextStepViewController.eyfsAgeData=eyfsAgeArray;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSMutableArray * array = (NSMutableArray *)[_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    [self.nextStepViewController setEylNewObservationAttachmentArray:array];
    self.nextStepViewController.textView.text= _eylNewObservation.nextSteps;
    self.nextStepViewController.topLabel.text = [topLabelDict objectForKey:currentCellInstanceClick];   //@"Next Step";
    self.nextStepPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.nextStepPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}

-(void)showDateTimePicker:(id)sender toolbar:(UIToolbar *)toolbar;
{
    isObservationEdited = TRUE;
    UIDatePicker *picker = (UIDatePicker *)sender;
    if(_eylNewObservation.observationCreatedAt)
        [picker setDate:_eylNewObservation.observationCreatedAt];
    [self.view addSubview:picker];
    [self.view addSubview:toolbar];
}

- (void)setDate:(NSDate *)date {
    _eylNewObservation.observationCreatedAt = date;
    creteateDate = date;
    [[APICallManager sharedNetworkSingleton] saveDate:creteateDate withID:self.deviceUUID];
}

-(void)showPopOverChildrenSelection:(id)sender
{
    isObservationEdited = TRUE;
    if(self.isEditView)
    {
        [APICallManager sharedNetworkSingleton].isFromDraftList=YES;
        [APICallManager sharedNetworkSingleton].mainSelectedChild=mainChild;
    }
    
    if (!self.childSelectionPopOver)
    {
        self.gridViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"childrenPopUpViewControllerID"];
        _childSelectionPopOver = [[WYPopoverController alloc] initWithContentViewController:self.gridViewController];
        self.childSelectionPopOver=[self setPopoverProperties:self.childSelectionPopOver];
    }
    self.gridViewController.delegate = self;
    self.gridViewController.deviceUUID = self.deviceUUID;
    self.childSelectionPopOver.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    currentCellInstanceClick = KChildrenSelection;
    [self.childSelectionPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];


}
-(void)doneBtnClicked:(id)sender forChildrenPopupViewController:(ChildrenPopupViewController *)viewController{
    [self.childSelectionPopOver dismissPopoverAnimated:YES];
    currentCellInstanceClick = nil;
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


-(void)closeButtonAction:(id)sender
{
    isRotated = FALSE;
    isCancel = TRUE;
    alreadyPopover=NO;
    
    if([self.observationPopOver isPopoverVisible]&&currentCellInstanceClick.length==0)
    {
        [self.observationViewController.textView resignFirstResponder];
        [self.observationPopOver dismissPopoverAnimated:YES];

    }
   
    // so that if text is unchanged we don't need to do anything
    if(self.observationViewController.textView.text.length > 0 && ![self.observationViewController.textView.text isEqualToString:_eylNewObservation.observation] &&currentCellInstanceClick.length>0)
    {
        AlertClick=0;
        EYAlertView *alert = [[EYAlertView alloc] initWithTitle:@"Warning" message:@"Unsaved Changes will be deleted. Do you want to proceed." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }else if (self.additionalNotesViewController.textView.text.length>0 && ![self.additionalNotesViewController.textView.text isEqualToString:_eylNewObservation.additionalNotes])
    {
     //   AlertClick=0;
        EYAlertView *alert = [[EYAlertView alloc] initWithTitle:@"Warning" message:@"Unsaved Changes will be deleted. Do you want to proceed." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    else if (self.analysisViewController.textView.text.length >0 &&  ![self.analysisViewController.textView.text isEqualToString:_eylNewObservation.analysis])
    {
       // AlertClick=0;
        EYAlertView *alert = [[EYAlertView alloc] initWithTitle:@"Warning" message:@"Unsaved Changes will be deleted. Do you want to proceed." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    else if (self.nextStepViewController.textView.text.length>0 && ![self.nextStepViewController.textView.text isEqualToString:_eylNewObservation.nextSteps])
    {
        EYAlertView *alert = [[EYAlertView alloc] initWithTitle:@"Warning" message:@"Unsaved Changes will be deleted. Do you want to proceed." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];
        [alert show];

    }
        else
    {
        if([currentCellInstanceClick isEqualToString:KObservation])
        {
            [self.observationViewController.textView resignFirstResponder];
            [self.observationPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAnalysis])
        {
            [self.analysisViewController.textView resignFirstResponder];
            [self.analysisPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KNextSteps])
        {
            [self.nextStepViewController.textView resignFirstResponder];
            [self.nextStepPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAdditionalNotes])
        {
            [self.additionalNotesViewController.textView resignFirstResponder];
            [self.additionalNotesPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
        {
            [self.eyfsAssessmentViewController.textView resignFirstResponder];
            [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];

        }
        else if ([currentCellInstanceClick isEqualToString:kCfe])

        {
            [self.cfeViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isCfeVisible=NO;
            
        }
        else if([currentCellInstanceClick isEqualToString:KCoel])
        {
            [self.coelPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KInvolvement])
        {
         
            [self.involvementPopOver dismissPopoverAnimated:YES];
            if (_eylNewObservation.scaleInvolvement > 0|| _eylNewObservation.scaleWellBeing > 0) {
              
            }
            else
            {
                
                self.involvementPopOver=nil;
                
            }
            
        }
        else if ([currentCellInstanceClick isEqualToString:kMontessory])
        {
            [self.montessoryViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isMontessoaryVisible=NO;
            // [self.montessoryPopOver dismissPopoverAnimated:YES];

        }else if ([currentCellInstanceClick isEqualToString:KEcat])
        {
            [self.ecatViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isEcatVisible=NO;
        }
        currentCellInstanceClick=@"";

    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void)resetData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kResetSelectedChildren" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectedStatus" object:[NSString stringWithFormat:@"%lu",(unsigned long)0]];
}
-(EYLNewObservation *)populateDataInEylNewObservation:(NewObservation *)newObservation{
    EYLNewObservation * eylNewObservation = [[EYLNewObservation alloc]init];
    [eylNewObservation populateDataWithNewObservation:newObservation];
    return eylNewObservation;
}

-(void)saveObservation:(NSString *)mode
{
    
   
//    NSMutableArray *cfeSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
//    NSMutableArray *Array = [[NSMutableArray alloc]init];
//    if(cfeSelectedArray.count > 0)
//    {
//        NSObject *tempObj;
//        tempObj = [cfeSelectedArray objectAtIndex:0];
//        if([tempObj isKindOfClass:[OBCfe class]])
//        {
//            for(int i = 0 ; i < cfeSelectedArray.count ; i++)
//            {
//                OBCfe *tempObj = [cfeSelectedArray objectAtIndex:i];
//                [Array addObject:tempObj.cfeFrameworkItemId];
//            }
//
//            _eylNewObservation.cfe =[ NSKeyedArchiver archivedDataWithRootObject:Array];
//        }
//    }
    // Edited By Ankit Khetrapal : Temporary hack to change the structure of Data object to one accepted by the server
    // Hack Hack Hack
    
    
    NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if(coelSelectedArray.count > 0)
    {
        NSObject *tempObj;
        tempObj = [coelSelectedArray objectAtIndex:0];
        if([tempObj isKindOfClass:[OBCoel class]])
        {
            for(int i = 0 ; i < coelSelectedArray.count ; i++)
            {
                OBCoel *tempObj = [coelSelectedArray objectAtIndex:i];
               [tempArray addObject:tempObj.coelId];
            }

            _eylNewObservation.coel =[ NSKeyedArchiver archivedDataWithRootObject:tempArray];
        }
    }

    if (isCancel) {
        _eylNewObservation.eyfsAgeBand = [NSKeyedArchiver archivedDataWithRootObject:tempAgeBandArray];
    }


    _eylNewObservation.mode = mode;

    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isAdded == %d && isDeleted == %d",YES,NO];
    NSArray * newAttachmentArray = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"attachmentType == %@", kUTTypeVideoType];
    NSArray *mediaVideo = [newAttachmentArray filteredArrayUsingPredicate:p2];
    if (mediaVideo.count) {
        hud.labelText = @"Compressing Media....";
    }else {
        hud.labelText = @"Loading Data....";
    }

    __block int currentCounter = 0;

    [mediaVideo enumerateObjectsUsingBlock:^(EYLNewObservationAttachment *obj, NSUInteger idx, BOOL *stop)
    {
        float compressPercentage;
        if(mediaVideo.count == 1)
            compressPercentage = 10.0;
        else
            compressPercentage = ((float)currentCounter/(float)mediaVideo.count) * 100.0;

        currentCounter++;

        hud.detailsLabelText = [NSString stringWithFormat: @"Progress : %0.2f%%",compressPercentage];

        if ([obj.attachmentType isEqualToString:kUTTypeVideoType]) {
            NSString *filePath = [DocumentFileHandler getTemporaryDirectory];
            filePath = [filePath stringByAppendingPathComponent:obj.tempPath];
            filePath = [filePath stringByAppendingPathComponent:obj.tempName];
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            AVAsset *video = [AVAsset assetWithURL:fileURL];


            AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:video presetName:AVAssetExportPresetMediumQuality];
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.outputFileType = AVFileTypeMPEG4;

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            basePath = [basePath stringByAppendingPathComponent:@"videos"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
                [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];

            __block NSURL *compressedVideoUrl=nil;
            compressedVideoUrl = [NSURL fileURLWithPath:basePath];
            long CurrentTime = [[NSDate date] timeIntervalSince1970];
            CurrentTime = CurrentTime+arc4random();
            NSString *strImageName = [NSString stringWithFormat:@"%ld",CurrentTime];
            compressedVideoUrl=[compressedVideoUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",strImageName]];
            __block NSMutableData *dataMovie = nil;
            exportSession.outputURL = compressedVideoUrl;
            NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
            __block BOOL isExportingInProgress = YES;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                NSLog(@"done processing video!");
                NSLog(@"%@",compressedVideoUrl);

                if(!dataMovie)
                    dataMovie = [[NSMutableData alloc] init];
                dataMovie = [NSMutableData dataWithContentsOfURL:compressedVideoUrl];
                isExportingInProgress = NO;
            }];
            while (isExportingInProgress && [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:loopUntil])
                loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
            if (dataMovie.length > 0) {
                [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                [dataMovie writeToURL:fileURL atomically:YES];
                dataMovie = nil;
                [[NSFileManager defaultManager] removeItemAtURL:compressedVideoUrl error:nil];
            }
        }

    }];
    if(newAttachmentArray.count > 0)
    {
        _eylNewObservation.checksums = @"";
        for (int i = 0 ; i < newAttachmentArray.count; i++)
        {

            _eylNewObservation.checksums = [_eylNewObservation.checksums stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0],[Utils randomStringWithLength: 7],i < (newAttachmentArray.count -1) ? @",": @""]];
        }
    }

    if (self.isEditView) {
        _eylNewObservation.readyForUpload = YES;
        _eylNewObservation.isEditing = YES;
        _eylNewObservation.isUploaded = NO;
        _eylNewObservation.isUploading = NO;
       
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@" SELF.childId==%@",childId];
        NSArray *array= [[APICallManager sharedNetworkSingleton].cacheChildren filteredArrayUsingPredicate:predicate];
    
        if(array.count==0)
        {
            if(mainChild)
            {
            [[APICallManager sharedNetworkSingleton].cacheChildren addObject:mainChild];
            }
            
        }
        
        
        int counter = 0;
        for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren)
        {
            counter++;
            
            if([child.childId integerValue]==[childId integerValue])
            {
            
                [_eylNewObservation editObservationWithChild:mainChild];
            
            }
            else
            {
              
                
                predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",YES];
                
                NSArray * deletedArray = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
                OBMedia *newMedia=_eylNewObservation.media;
                
                for (EYLNewObservationAttachment * attachment in deletedArray) {
              
                    
                    NSPredicate *pred =[NSPredicate predicateWithFormat:@"SELF.url == %@",attachment.fileURL];
                    NSArray *newarray=[newMedia.images filteredArrayUsingPredicate:pred];
                    NSArray *videoArray=[newMedia.videos filteredArrayUsingPredicate:pred];
                    NSArray *audioarray=[newMedia.audios filteredArrayUsingPredicate:pred];
                    
                    if(newarray.count>0)
                    {
                        NSMutableArray *mut=[newMedia.images mutableCopy];
                        
                        [mut removeObject:[newarray lastObject]];
                        newMedia.images=mut;
                                                
                        
                    }
                    if(videoArray.count>0)
                    {
                        NSMutableArray *mut=[newMedia.videos mutableCopy];
                        
                        [mut removeObject:[videoArray lastObject]];
                       newMedia.videos=mut;
                        
                        
                        
                    }
                    if(audioarray.count>0)
                    {
                        NSMutableArray *mut=[newMedia.audios mutableCopy];
                        
                        [mut removeObject:[audioarray lastObject]];
                       newMedia.audios=mut;
                        
                        
                        
                    }
                    
                }
              
                _eylNewObservation.media=newMedia;
                
                
                [_eylNewObservation saveNewFucntionalityObservationWithChild:child withlastItem:counter <  [APICallManager sharedNetworkSingleton].cacheChildren.count ? NO : YES];
                
            }
            
            //[_eylNewObservation editObservationWithChild:child withlastItem:counter <  [APICallManager sharedNetworkSingleton].cacheChildren.count ? NO : YES];
            //[_eylNewObservation saveNewObservationWithChild:child];
            
            
        }
    }
    else
    {
        int counter = 0;
        
        for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren)
        {
            counter++;
            [_eylNewObservation saveNewObservationWithChild:child withlastItem:counter <  [APICallManager sharedNetworkSingleton].cacheChildren.count ? NO : YES];
            //[_eylNewObservation saveNewObservationWithChild:child];


        
        }
    }
    [newAttachmentArray enumerateObjectsUsingBlock:^(EYLNewObservationAttachment *obj, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [DocumentFileHandler getTemporaryDirectory];
        filePath = [filePath stringByAppendingPathComponent:obj.tempPath];
        filePath = [filePath stringByAppendingPathComponent:obj.tempName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
    }];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)doneButtonAction:(id)sender
{
    if(!_isProcessingMedia)
    {
    
    isRotated = FALSE;
    isCancel = FALSE;
    alreadyPopover=NO;
    [[APICallManager sharedNetworkSingleton] saveDate:creteateDate withID:self.deviceUUID];
        
        if((currentCellInstanceClick.length==0) & [self.observationPopOver isPopoverVisible])
        {
            _eylNewObservation.internalNotes = self.observationViewController.textView.text;
            
            [self.observationViewController.textView resignFirstResponder];
            [self.observationPopOver dismissPopoverAnimated:YES];
        
        }
        if([currentCellInstanceClick isEqualToString:KObservation])
        {
            _eylNewObservation.observation = self.observationViewController.textView.text;

            [self.observationViewController.textView resignFirstResponder];
            [self.observationPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAnalysis])
        {
            _eylNewObservation.analysis = self.analysisViewController.textView.text;

            [self.analysisViewController.textView resignFirstResponder];
            [self.analysisPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KNextSteps])
        {
            _eylNewObservation.nextSteps = self.nextStepViewController.textView.text;
            
        
            [self.nextStepViewController.textView resignFirstResponder];
            [self.nextStepPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAdditionalNotes])
        {
            _eylNewObservation.additionalNotes = self.additionalNotesViewController.textView.text;

            [self.additionalNotesViewController.textView resignFirstResponder];
            [self.additionalNotesPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
        {
            _eylNewObservation.eyfsStatement = [NSKeyedArchiver archivedDataWithRootObject:self.eyfsAssessmentViewController.selectedList];
            _eylNewObservation.eyfsAgeBand = [NSKeyedArchiver archivedDataWithRootObject:self.eyfsAssessmentViewController.selectedAgeBandAssessmentList];
            [self.eyfsAssessmentViewController.textView resignFirstResponder];
            [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];

        }
        else if ([currentCellInstanceClick isEqualToString:kMontessory])
        {
            if(self.isEditingAllowed)
            {
            NSLog(@"Done ON Montessori ");
            NSInteger monteValue = self.montessoryViewController.selectedList.count;
                stringCountMon=[NSString stringWithFormat:@"%ld",(long)monteValue];

            if (monteValue > 0) {
                self.mantessoriNotificationLabel.hidden = NO;
                self.mantessoriNotificationLabel.text = [NSString stringWithFormat:@"%ld",(long)monteValue];
                         }
            else{
                self.mantessoriNotificationLabel.hidden = YES;
            }
            _eylNewObservation.montessori = [NSKeyedArchiver archivedDataWithRootObject:self.montessoryViewController.selectedList];
            }
            [self.montessoryViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isMontessoaryVisible=NO;

            // [self.montessoryPopOver dismissPopoverAnimated:YES];

        }
        else if ([currentCellInstanceClick isEqualToString:kCfe])
        {
            _eylNewObservation.cfe = [NSKeyedArchiver archivedDataWithRootObject:self.cfeViewController.selectedList];
          
            [self.cfeViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isCfeVisible=NO;
            
        }
        else if ([currentCellInstanceClick isEqualToString:KEcat])
        {
            if(self.isEditingAllowed)
            {
            NSLog(@"Done On Ecat");
            NSInteger ecatValue = self.ecatViewController.selectedList.count;
                 stringCountEcat=[NSString stringWithFormat:@"%ld",(long)ecatValue];
            if (ecatValue > 0) {
                self.ecatNotificationLabel.hidden = NO;
                self.ecatNotificationLabel.text = [NSString stringWithFormat:@"%ld",(long)ecatValue];
               
            }
            else{
                self.ecatNotificationLabel.hidden = YES;
            }
            _eylNewObservation.ecat = [NSKeyedArchiver archivedDataWithRootObject:self.ecatViewController.selectedList];
            _eylNewObservation.ecatAssessmentLevel=self.ecatViewController.selectedLevel;
            }
            [self.ecatViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isEcatVisible=NO;
        }
        else if ([currentCellInstanceClick isEqualToString:KInvolvement])
        {
            if(self.isEditingAllowed)
            {
            NSInteger involvementValue = self.involvementViewController.selectedInvolvementIndex +1;
            NSInteger welBeingValue = self.involvementViewController.selectedWellBeingIndex +1;

            _eylNewObservation.scaleInvolvement = @(involvementValue);
            _eylNewObservation.scaleWellBeing = @(welBeingValue);
                if (involvementValue > 0)
                {
                 stringCountInvol=[NSString stringWithFormat:@"%ld",(long)involvementValue];
                }
            if (involvementValue > 0) {
                self.involvementNotificationLabel.hidden = NO;
                self.involvementNotificationLabel.text = [NSString stringWithFormat:@"%d",involvementValue];
             


            }
            else{
                self.involvementNotificationLabel.hidden = YES;
            }
                 if (welBeingValue > 0) {
                 stringCountWell=[NSString stringWithFormat:@"%ld",(long)welBeingValue];
                 }
            if (welBeingValue > 0) {
                self.wellBeingNotificationLabel.hidden = NO;
                self.wellBeingNotificationLabel.text = [NSString stringWithFormat:@"%d",welBeingValue];
               


            }
            else{
                self.wellBeingNotificationLabel.hidden = YES;
            }
            }
            [self.involvementPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KCoel])
        {
            if(self.isEditingAllowed)
            {
            _eylNewObservation.coel =  [NSKeyedArchiver archivedDataWithRootObject:self.coelViewController.selectedList];

            NSMutableArray *coelSelectedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.coel];

            if ([coelSelectedArray count] > 0) {
                self.coelNotificationLabel.hidden = NO;
                self.coelNotificationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[coelSelectedArray count]];
                stringCountCoel=[NSString stringWithFormat:@"%lu",(unsigned long)[coelSelectedArray count]];
                
                            }
            else{
                self.coelNotificationLabel.hidden = YES;
            }
            }
            [self.coelPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KChildrenSelection])
        {
            [self.childSelectionPopOver dismissPopoverAnimated:YES];
        }
    partiallySaved = YES;
    currentCellInstanceClick=@"";
    [self.frameworkBtnsCollectionView reloadData];
    
   // [self loadObservation];
    [self.collectionView reloadData];
    }
    else
    {
        if((currentCellInstanceClick.length==0) & [self.observationPopOver isPopoverVisible])
        {
           
            
            [self.observationViewController.textView resignFirstResponder];
            [self.observationPopOver dismissPopoverAnimated:YES];
            
        }
        if([currentCellInstanceClick isEqualToString:KObservation])
        {
            
            [self.observationViewController.textView resignFirstResponder];
            [self.observationPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAnalysis])
        {
            
            [self.analysisViewController.textView resignFirstResponder];
            [self.analysisPopOver dismissPopoverAnimated:YES];
        }
        
        else if ([currentCellInstanceClick isEqualToString:KNextSteps])
        {
            [self.nextStepViewController.textView resignFirstResponder];
            [self.nextStepPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KAdditionalNotes])
        {
            
            [self.additionalNotesViewController.textView resignFirstResponder];
            [self.additionalNotesPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
        {
            [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];
            
        }
        else if ([currentCellInstanceClick isEqualToString:kMontessory])
        {
            [self.montessoryViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isMontessoaryVisible=NO;
        }
        else if ([currentCellInstanceClick isEqualToString:kCfe])
        {
            [self.cfeViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            isCfeVisible=NO;
        }
        else if ([currentCellInstanceClick isEqualToString:KEcat])
        {
            [self.ecatViewController.view removeFromSuperview];
            [transParentView removeFromSuperview];
            
            isEcatVisible=NO;
        }
        else if ([currentCellInstanceClick isEqualToString:KInvolvement])
        {
            [self.involvementPopOver dismissPopoverAnimated:YES];
        }
        else if ([currentCellInstanceClick isEqualToString:KCoel])
        {
            [self.coelPopOver dismissPopoverAnimated:YES];
            
        }
        else if ([currentCellInstanceClick isEqualToString:KChildrenSelection])
        {
            [self.childSelectionPopOver dismissPopoverAnimated:YES];
        }
        
    }
    
}

- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

- (void)collectionViewDidRefreshed:(UIRefreshControl *)sender
{

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Orientation Changes

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    isRotated = YES;
    /* Don't remove this code until confirmation*/

    if([currentCellInstanceClick isEqualToString:KObservation])
    {
        [self.observationViewController.textView resignFirstResponder];
        [self.observationPopOver dismissPopoverAnimated:YES];
        tempOrientationChange = self.observationViewController.textView.text;
    }
    else if ([currentCellInstanceClick isEqualToString:KAnalysis])
    {
        [self.analysisViewController.textView resignFirstResponder];
        [self.analysisPopOver dismissPopoverAnimated:YES];
        tempOrientationChange = self.analysisViewController.textView.text;
    }
    else if ([currentCellInstanceClick isEqualToString:KNextSteps])
    {
        [self.nextStepViewController.textView resignFirstResponder];
        [self.nextStepPopOver dismissPopoverAnimated:YES];
       tempOrientationChange = self.nextStepViewController.textView.text;
    }
    else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
    {
        [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];
    }
    else if ([currentCellInstanceClick isEqualToString:KInvolvement])
    {
        [self.involvementPopOver dismissPopoverAnimated:YES];
    }
    else if ([currentCellInstanceClick isEqualToString:KCoel])
    {
        [self.coelPopOver dismissPopoverAnimated:YES];
    }
    else if ([currentCellInstanceClick isEqualToString:KChildrenSelection])
    {
        [self.childSelectionPopOver dismissPopoverAnimated:YES];
    }

    containerView.hidden=YES;
    if ([self.eyfsAssessmentPopOver isPopoverVisible]) {
        isEYFSContainerVisible = YES;
        [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    [btn removeFromSuperview];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        
        
    /* Don't remove this code Untill confirmation */
    {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2+250 , -10, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"internalNotes"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showPopoverForInternalNotes) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:btn];
    }
    
    else
    {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width/2+120 , -10, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"internalNotes"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showPopoverForInternalNotes) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:btn];
    }
    

    if([currentCellInstanceClick isEqualToString:KObservation])
    {
        [self showPopOverObservation];
        self.observationViewController.textView.text = tempOrientationChange;
        tempOrientationChange = nil;
    }
    else if ([currentCellInstanceClick isEqualToString:KAnalysis])
    {
        [self showPopOverAnalysis];
        self.analysisViewController.textView.text = tempOrientationChange;
        tempOrientationChange = nil;
    }
    else if ([currentCellInstanceClick isEqualToString:KNextSteps])
    {
        [self showPopOverNextStep];
        self.nextStepViewController.textView.text = tempOrientationChange;
        tempOrientationChange = nil;
    }
    else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
    {
        [self.eyfsAssessmentViewController.detailTableView reloadData];
        [self showEYFSAssessment];
    }
    else if ([currentCellInstanceClick isEqualToString:KInvolvement])
    {
        [self showInvolvementPopOver];
    }
    else if ([currentCellInstanceClick isEqualToString:KCoel])
    {
        [self showPopOverCOEL];
    }
    else if ([currentCellInstanceClick isEqualToString:KChildrenSelection])
    {
        [self showPopOverChildrenSelection:nil];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscape");
         NSLog(@"check width %f and checking Height %f",screenWidth,screenHeight);
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-955, 0, 950, 40);
            containerView.hidden=NO;
            transParentView.frame=CGRectMake(0, 0, screenWidth+500, screenHeight+500);
            if (isEcatVisible) {
                if (SYSTEM_VERSION_LESS_THAN(@"8.0")){
                    self.ecatViewController.view.frame=CGRectMake(25,60,screenHeight-50,screenWidth-120);
                } else { self.ecatViewController.view.frame=CGRectMake(25,60,screenWidth-50,screenHeight-120);}

            }
        }];

      //  NSLog(@"value %f",self.montessoryViewController.detailTableView.frame.origin.x);
    }
    else
    {
        NSLog(@"portrait");
         NSLog(@"check width %f and checking Height %f",screenWidth,screenHeight);
        [UIView animateWithDuration:0.0 animations:^{
            containerView.frame=CGRectMake(self.view.frame.size.width-720, 0, 715, 40);
            containerView.hidden=NO;
         //   if (isMontessoaryVisible) {
                transParentView.frame=CGRectMake(0, 0, screenWidth+500, screenHeight+500);
            if (isEcatVisible) {
                 self.ecatViewController.view.frame=CGRectMake(25, 60,screenWidth-50,screenHeight-120);
            }

           // }
        }];
    }
    if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
    {
        [self.eyfsAssessmentViewController.detailTableView reloadData];
    }
    if ([currentCellInstanceClick isEqualToString:kCfe])
    {
        [self.cfeViewController.detailTableview reloadData];
    }
    if (isEYFSContainerVisible) {
        isEYFSContainerVisible = NO;
        [self showEYFSAssessment];
    }
}

-(void)didFinishPickingMedia:(NSArray *)media
{

}

-(void)saveImageInDirectory:(UIImage *)image{

    isObservationEdited = TRUE;

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    if (array.count > 19) {
        if (isGreaterThanTwenty) {
            return;
        }
        isGreaterThanTwenty = YES;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
        return;
    }
    isGreaterThanTwenty = NO;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;

    EYLNewObservationAttachment * eylNewObservationAttachment = [[EYLNewObservationAttachment alloc]init];
    eylNewObservationAttachment.practitionerId = practitioner.eylogUserId;
    eylNewObservationAttachment.tempName = [DocumentFileHandler getFileNameWithExtension:@"png"];
    eylNewObservationAttachment.attachmentType = kUTTypeImageType;
    eylNewObservationAttachment.tempPath = [DocumentFileHandler getObservationImagesPathForTempChild:@"Temp_Child"];
    [eylNewObservationAttachment saveMediaInTempDirectory:UIImagePNGRepresentation(image)];
    eylNewObservationAttachment.isAdded = YES;
    if (!_eylNewObservation.eylNewObservationAttachmentArray) {
        _eylNewObservation.eylNewObservationAttachmentArray = [NSMutableArray array];
    }
    [_eylNewObservation.eylNewObservationAttachmentArray addObject:eylNewObservationAttachment];
    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setThumbnailsArray:_eylNewObservation.eylNewObservationAttachmentArray];
}

-(void)saveAssestVideoInDirectory:(NSData *)data{

     isObservationEdited = TRUE;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    if (array.count > 19) {
        if (isGreaterThanTwenty) {
            return;
        }
        isGreaterThanTwenty = YES;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
        return;
    }

    isGreaterThanTwenty = NO;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;

    NSString * fileName = [DocumentFileHandler getFileNameWithExtension:@"mp4"];

    EYLNewObservationAttachment * eylNewObservationAttachment = [[EYLNewObservationAttachment alloc]init];
    eylNewObservationAttachment.practitionerId = practitioner.eylogUserId;
    eylNewObservationAttachment.attachmentName = fileName;
    eylNewObservationAttachment.attachmentType = kUTTypeVideoType;
    eylNewObservationAttachment.attachmentPath = [DocumentFileHandler getObservationVideosPathForTempChild:@"Temp_Child"];
    eylNewObservationAttachment.isAdded = YES;
    if (!_eylNewObservation.eylNewObservationAttachmentArray) {
        _eylNewObservation.eylNewObservationAttachmentArray = [NSMutableArray array];
    }
    [_eylNewObservation.eylNewObservationAttachmentArray addObject:eylNewObservationAttachment];

    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setThumbnailsArray:_eylNewObservation.eylNewObservationAttachmentArray];
}

-(void)saveRecordedVideoInDirectory:(NSURL *)url{

//    NSData *data = [NSData dataWithContentsOfURL:url];
//    long size = data.length/ (1024 * 1024);
//    if(size > 20)
//    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please record a smaller video, selected video is too big" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
//        return;
//    }

    isObservationEdited = TRUE;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];

    NSPredicate *videoPredicate = [NSPredicate predicateWithFormat:@"attachmentType == %@", kUTTypeVideoType];
    NSArray *videoArray = [array filteredArrayUsingPredicate:videoPredicate];

    if(videoArray.count >= MAXVIDEOINOBSERVATION)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Cannot add more than three videos in one observation" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];

        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        return;
    }

    if (array.count > 19) {
        if (isGreaterThanTwenty) {
            return;
        }
        isGreaterThanTwenty = YES;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
        return;
    }
    isGreaterThanTwenty = NO;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;

    NSString * fileName = [[[url path] componentsSeparatedByString:@"/"] lastObject];
    NSArray * fileArray = [fileName componentsSeparatedByString:@"."];
    fileName = [NSString stringWithFormat: @"%@-%@",[fileArray firstObject],[DocumentFileHandler getFileNameWithExtension:[fileArray lastObject]]];

    EYLNewObservationAttachment * eylNewObservationAttachment = [[EYLNewObservationAttachment alloc]init];
    eylNewObservationAttachment.practitionerId = practitioner.eylogUserId;
    eylNewObservationAttachment.tempName = fileName;
    eylNewObservationAttachment.attachmentType = kUTTypeVideoType;
    eylNewObservationAttachment.tempPath = [DocumentFileHandler getObservationVideosPathForTempChild:@"Temp_Child"];
    eylNewObservationAttachment.isAdded = YES;


    eylNewObservationAttachment.eylMedia.image = [Utils generateThumbImage:url];
    [eylNewObservationAttachment saveMediaInTempDirectory:[NSData dataWithContentsOfURL:url]];

    if (!_eylNewObservation.eylNewObservationAttachmentArray) {
        _eylNewObservation.eylNewObservationAttachmentArray = [NSMutableArray array];
    }
    [_eylNewObservation.eylNewObservationAttachmentArray addObject:eylNewObservationAttachment];

    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setThumbnailsArray:_eylNewObservation.eylNewObservationAttachmentArray];
    // For Deleting Video from temp directory.
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
}

-(void)saveVideoInDirectory:(NSURL *)url{

    isObservationEdited = TRUE;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];

    NSPredicate *videoPredicate = [NSPredicate predicateWithFormat:@"attachmentType == %@", kUTTypeVideoType];
    NSArray *videoArray = [array filteredArrayUsingPredicate:videoPredicate];

    if(videoArray.count >= MAXVIDEOINOBSERVATION)
    {
        if(showAlertOnlyOnce)
        {
            showAlertOnlyOnce = false;
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Cannot add more than three videos in one observation" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            [self.view makeToast:@"Cannot add more than three videos in one observation" duration:2.0f position:CSToastPositionBottom];
        }
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        return;
    }


    if (array.count > 19) {
        if (isGreaterThanTwenty) {
            return;
        }
        isGreaterThanTwenty = YES;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
        return;
    }
    isGreaterThanTwenty = NO;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;

    NSString * fileName = [[[url path] componentsSeparatedByString:@"/"] lastObject];
    NSArray * fileArray = [fileName componentsSeparatedByString:@"."];
    fileName = [NSString stringWithFormat: @"%@-%@",[fileArray firstObject],[DocumentFileHandler getFileNameWithExtension:[fileArray lastObject]]];

    EYLNewObservationAttachment * eylNewObservationAttachment = [[EYLNewObservationAttachment alloc]init];
    eylNewObservationAttachment.practitionerId = practitioner.eylogUserId;
    //eylNewObservationAttachment.tempName = fileName;
    eylNewObservationAttachment.tempName = [DocumentFileHandler getFileNameWithExtension:@"mp4"];
    eylNewObservationAttachment.attachmentType = kUTTypeVideoType;
    eylNewObservationAttachment.tempPath = [DocumentFileHandler getObservationVideosPathForTempChild:@"Temp_Child"];
    eylNewObservationAttachment.isAdded = YES;


    eylNewObservationAttachment.eylMedia.image = [Utils generateThumbImage:url];

    // Get Video Data from the path URL
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        [eylNewObservationAttachment saveMediaInTempDirectory:data];
    } failureBlock:^(NSError *err) {
        NSLog(@"Error: %@",[err localizedDescription]);
    }];


    if (!_eylNewObservation.eylNewObservationAttachmentArray) {
        _eylNewObservation.eylNewObservationAttachmentArray = [NSMutableArray array];
    }
    [_eylNewObservation.eylNewObservationAttachmentArray addObject:eylNewObservationAttachment];

    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setThumbnailsArray:_eylNewObservation.eylNewObservationAttachmentArray];
}

-(void)saveAudioInDirectory:(NSURL *)url{

    isObservationEdited = TRUE;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDeleted == %d",NO];
    NSArray * array = [_eylNewObservation.eylNewObservationAttachmentArray filteredArrayUsingPredicate:predicate];
    if (array.count > 19) {
        if (isGreaterThanTwenty) {
            return;
        }
        isGreaterThanTwenty = YES;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can only select 20 media files." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [self.view makeToast:@"You can only select 20 media files." duration:2.0f position:CSToastPositionBottom];
        return;
    }

    isGreaterThanTwenty = NO;
    Practitioners *practitioner=[APICallManager sharedNetworkSingleton].cachePractitioners;
    NSString * fileName = [[[url path] componentsSeparatedByString:@"/"] lastObject];

    EYLNewObservationAttachment * eylNewObservationAttachment = [[EYLNewObservationAttachment alloc]init];
    eylNewObservationAttachment.practitionerId = practitioner.eylogUserId;
    eylNewObservationAttachment.tempName = fileName;
    eylNewObservationAttachment.attachmentType = kUTTypeAudioType;
    eylNewObservationAttachment.tempPath = [DocumentFileHandler getObservationAudioPathForTempChild:@"Temp_Child"];
    eylNewObservationAttachment.observationId = _eylNewObservation.uniqueTabletOID;
    eylNewObservationAttachment.isAdded = YES;

    eylNewObservationAttachment.eylMedia.image = [UIImage imageNamed:@"mic-9090"];
    [eylNewObservationAttachment saveMediaInTempDirectory:[NSData dataWithContentsOfURL:url]];

    if (!_eylNewObservation.eylNewObservationAttachmentArray) {
        _eylNewObservation.eylNewObservationAttachmentArray = [NSMutableArray array];
    }
    [_eylNewObservation.eylNewObservationAttachmentArray addObject:eylNewObservationAttachment];

    MediaObservationCell *cell =(MediaObservationCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setThumbnailsArray:_eylNewObservation.eylNewObservationAttachmentArray];
}

- (IBAction)MediaButtonClicked:(id)sender {
    if(_isProcessingMedia)
    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Media is under Processing State" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
[self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
        return;
        
    }
if(self.isEditingAllowed)
{
    showAlertOnlyOnce = true;
    [theme popOverInView:self.view withButton:sender];
}
}

- (IBAction)btnEcat:(id)sender {
    [self ecatpopover];
}

-(void)ecatpopover{
    currentCellInstanceClick=KEcat;

    self.ecatViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ecatViewControllerID"];

    NSMutableArray *ecatSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.ecat];
    self.ecatViewController.selectedLevel=[NSNumber numberWithInteger:[_eylNewObservation.ecatAssessment integerValue]];
    NSLog(@"Loaded Assesment %@", _eylNewObservation.ecatAssessment);
    self.ecatViewController.selectedList = ecatSavedArray;
    self.ecatViewController.ecatArray=(NSMutableArray *)ecatArray;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    _ecatViewController.delegate=self;
    isEcatVisible=YES;

    //self.ecatViewController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^
     {

         if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
             if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
                 self.ecatViewController.view.frame = CGRectMake(25,60,screenHeight-50,screenWidth-120);
             }else{
                 self.ecatViewController.view.frame = CGRectMake(25,60,screenWidth-50,screenHeight-120);
             }
             //self.ecatViewController.view.frame=CGRectMake(25, 60,-50,screenHeight-120);
         }else{
             self.ecatViewController.view.frame=CGRectMake(25, 60,screenWidth-50,screenHeight-120);
         }
         transParentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screenWidth+500 ,screenHeight+500)];
         transParentView.backgroundColor=[UIColor whiteColor];
         transParentView.alpha=0.8;

         [self.navigationController.view addSubview:transParentView];
         [self.navigationController.view addSubview:self.ecatViewController.view];
         [self.navigationController.view bringSubviewToFront:self.ecatViewController.view];

     }completion:^(BOOL finished){

     }];


}
- (IBAction)btnMontessotiClick:(id)sender {
    [self montessoryPopover];
   }
-(void)montessoryPopover{

    currentCellInstanceClick=kMontessory;
    self.montessoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"montessoryViewControllerId"];
    NSMutableArray *montessoryArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.montessori];
    NSLog(@"Loaded montessoryArray %@", montessoryArray);
    self.montessoryViewController.selectedList = montessoryArray;
    self.montessoryViewController.montessoriArray = montessoriArray;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    _montessoryViewController.delegate=self;
    isMontessoaryVisible=YES;

    [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^
     {

         if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
             if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
                 self.montessoryViewController.view.frame = CGRectMake(20,80,screenHeight-50,screenWidth-150);
             }else{
                 self.montessoryViewController.view.frame = CGRectMake(20,80,screenWidth-50,screenHeight-200);
             }
         }else{
             self.montessoryViewController.view.frame = CGRectMake(20,80,screenWidth-50,screenHeight-200);
         }
         transParentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screenWidth+500 ,screenHeight+500)];
         transParentView.backgroundColor=[UIColor whiteColor];
         transParentView.alpha=0.8;
         [self.navigationController.view addSubview:transParentView];
         [self.navigationController.view addSubview:self.montessoryViewController.view];
         [self.navigationController.view bringSubviewToFront:self.montessoryViewController.view];
         [self.montessoryViewController filterDataBaseOnSegment];

     }completion:^(BOOL finished){

     }];

}

-(IBAction)selectOptionAction:(id)sender
{

}

- (IBAction)mediaAddAction:(id)sender
{
    if(_isProcessingMedia)
    {
        
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Media is under Processing State" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
[self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
            
    }
    else
    {

    if(self.isEditingAllowed)
    {
   [theme popOverInView:self.view withButton:sender];
    }
    }

}

- (IBAction)spontaneousObservationValueChanged:(UISwitch *)sender
{
    if(_isProcessingMedia)
    {
        [sender setOn:NO];
        
        [self.view makeToast:@"This Observation is under processing so cannot be edited" duration:2.0f position:CSToastPositionBottom];
    }
    else
    {
    isObservationEdited = TRUE;
    isSpontaneous = sender.isOn ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    _eylNewObservation.quickObservation = isSpontaneous;
    [self.collectionView reloadData];
    }
    
    
}


#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==200)
{
    return;
}
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    // Edited by Ankit Khetrapal so that whenever the publish action alert is invoked on clicking the canel button the alert should close and nothing should happen there.
    if(buttonIndex == 0 && [title isEqualToString:@"No"] && alertView.tag == 1)
    {
        return;
    }

    if(buttonIndex == 1 && [title isEqualToString:@"Cancel"] && alertView.tag == 0)
    {
        return;
    }
    if (buttonIndex==0 && [title isEqualToString:@"No"] && alertView.tag==4) {
        return;
    }

    MBProgressHUD *hudLoading = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hudLoading.labelText = @"Processing Data...";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            if([alertView isKindOfClass:[EYAlertView class]])
            {
                if(buttonIndex==0)
                {
                    if([currentCellInstanceClick isEqualToString:KObservation])
                    {
                        [self.observationViewController.textView resignFirstResponder];
                        [self.observationPopOver dismissPopoverAnimated:YES];
                    }
                    else if ([currentCellInstanceClick isEqualToString:KAnalysis])
                    {
                        [self.analysisViewController.textView resignFirstResponder];
                        [self.analysisPopOver dismissPopoverAnimated:YES];
                    }
                    else if ([currentCellInstanceClick isEqualToString:KNextSteps])
                    {
                        [self.nextStepViewController.textView resignFirstResponder];
                         self.nextStepViewController.textView.text=@"";
                        [self.nextStepPopOver dismissPopoverAnimated:YES];
                    }
                    else if ([currentCellInstanceClick isEqualToString:KAdditionalNotes])
                    {
                        [self.additionalNotesViewController.textView resignFirstResponder];
                        [self.additionalNotesPopOver dismissPopoverAnimated:YES];
                    }
                    else if ([currentCellInstanceClick isEqualToString:KEYFSAssessment])
                    {
                        [self.eyfsAssessmentViewController.textView resignFirstResponder];
                        [self.eyfsAssessmentPopOver dismissPopoverAnimated:YES];
                    }
                    else if([currentCellInstanceClick isEqualToString:KCoel])
                    {
                        [self.coelPopOver dismissPopoverAnimated:YES];
                    }
                    else if ([currentCellInstanceClick isEqualToString:KInvolvement])
                    {
                        [self.involvementPopOver dismissPopoverAnimated:YES];
                    }
                    currentCellInstanceClick=@"";

                }
            }
            if(alertView.tag==1)
            {
                NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
                if([title isEqualToString:@"Cancel"])
                {
                    NSLog(@"Nothing to do here");
                    AlertClick=1;
                    return;
                }
                else if([title isEqualToString:@"Yes"])
                {
                    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]==1)
                    {
                        [self saveObservation:@"submitted"];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Observation is being Published.";
                        hud.margin = 10.f;
                        hud.removeFromSuperViewOnHide = YES;
                        hud.delegate =self;
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                        {
                            hud.yOffset=280;
                        }
                        else
                        {
                            hud.yOffset=400;
                        }
                        [hud hide:YES afterDelay:1];
                        [self.navigationController popViewControllerAnimated:YES];
                        // For Housekeeping
                        [self manageData];
                    }
                    else
                    {
                        [self saveObservation:@"pending"];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Observation is Pending for Review.";
                        hud.margin = 10.f;
                        hud.removeFromSuperViewOnHide = YES;
                        hud.delegate =self;
                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                        {
                            hud.yOffset=280;
                        }
                        else
                        {
                            hud.yOffset=400;
                        }
                        [hud hide:YES afterDelay:1];
                        [self.navigationController popViewControllerAnimated:YES];
                        // For Housekeeping
                        [self manageData];
                    }

                }
            }

            NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
            if(alertView.tag == 0 && buttonIndex == 2 && [title isEqualToString:@"Yes"])
            {
                [self saveAsDraftInNewObservationVC:nil];
            }
            
            if (alertView.tag==4 && buttonIndex==1 && [title isEqualToString:@"Yes"]) {
                
                NSLog(@"Yes clicked");
                
                
                MBProgressHUD *hudLoading = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hudLoading.labelText = @"Processing Data...";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self saveObservation:@"draft"];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"Observation is being saved as a draft...";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.delegate =self;
                    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                    {
                        hud.yOffset=280;
                    }
                    else
                    {
                        hud.yOffset=400;
                    }
                    [hud hide:YES afterDelay:1];
                    [hudLoading hide:YES afterDelay:0.1];
                    [self.navigationController popViewControllerAnimated:YES];
                    // For Housekeeping
                    [self manageData];
                });

            }
        }
        @catch (NSException *exception) {}
        @finally {
            [hudLoading hide:YES];
        }
    });
    if ([alertView isKindOfClass:[EYAlertView class]]) {

    }else {
        if (buttonIndex == 0) {
            if(!AlertClick==1)
            {
            [self goBack];
            }
        }
    }

}

#pragma mark - MediaObservationCellDatasource

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath forCustomCollectionViewCelll:(CustomCollectionViewCell *)cell{
    switch (indexPath.row) {
        case 0:
        {
            if(self.isEditingAllowed)
            {
                [self MediaButtonClicked:cell.playButton];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ThemeDelegate;
-(void)saveAsDraftInNewObservationVC:(id)sender
{
    
    if(_isProcessingMedia)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"This Observation is under processing so cannot be edited" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=200;
        
        [alert show];
    }
    else
    {
    if(self.isEditingAllowed)
    {
    if(_eylNewObservation.observation == nil || _eylNewObservation.observation.length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Observation Text cannot be Blank.";
        hud.margin = 10.f;
        hud.userInteractionEnabled=YES;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            hud.yOffset=280;
        }
        else
        {
            hud.yOffset=400;
        }
        [hud hide:YES afterDelay:1];
    }else if ([APICallManager sharedNetworkSingleton].cacheChildren.count>1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This is a group observation. Saving it as a draft will create multiple copies of the observation, one per child. After this, the individual observations have to be separately edited. Do you want to proceed? " delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
        alert.tag=4;
        [alert show];
    }
    else
    {

        MBProgressHUD *hudLoading = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hudLoading.labelText = @"Processing Data...";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self saveObservation:@"draft"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Observation is being saved as a draft...";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            hud.delegate =self;
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
            {
                hud.yOffset=280;
            }
            else
            {
                hud.yOffset=400;
            }
            [hud hide:YES afterDelay:1];
            [hudLoading hide:YES afterDelay:0.1];
            [self.navigationController popViewControllerAnimated:YES];
           // For Housekeeping
            [self manageData];
        });
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This observation has already been submitted for Review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    }

}
-(void)submitObservationInNewObservationVC:(id)sender{
    
    if(_isProcessingMedia)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"This Observation is under processing so cannot be edited" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=200;
        
        [alert show];
    }
    else
    {
    
    if(self.isEditingAllowed)
    {
    if(_eylNewObservation.observation == nil || _eylNewObservation.observation.length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Observation Text cannot be Blank.";
        hud.margin = 10.f;
        hud.userInteractionEnabled=YES;
        hud.removeFromSuperViewOnHide = YES;
        hud.delegate =self;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            hud.yOffset=280;
        }
        else
        {
            hud.yOffset=400;
        }
        [hud hide:YES afterDelay:1];
    }
    else
    {
        if(self.isEditView==YES)
        {
            
            if([[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId isEqual:
                _observerID])
            {
                
                if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]==1)
                    
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The observation will now be published and will become part of the child's learning journey.It will not be possible to edit the observation once it is published. Do you want to proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                    alert.tag=1;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to proceed and submit the Observation for review?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                    alert.tag=1;
                    [alert show];
                }

            }
            
            else
            {
                if ([[APICallManager sharedNetworkSingleton].cachePractitioners.groupLeader integerValue]==1)
                    
                {//The observation will now be published to the child's learning journey and cannot be changed anymore from the tablet application.  Do you want to proceed?
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The observation will now be published and will become part of the child's learning journey.It will not be possible to edit the observation once it is published. Do you want to proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                    alert.tag=1;
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to proceed and submit the Observation for review?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                    alert.tag=1;
                    [alert show];
                }

            }

            
        }
        else
        {
            if ([[APICallManager sharedNetworkSingleton].cachePractitioners.allowSubmit integerValue]==1)
                
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The observation will now be published and will become part of the child's learning journey.It will not be possible to edit the observation once it is published. Do you want to proceed?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                alert.tag=1;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to proceed and submit the Observation for review?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil,nil];
                alert.tag=1;
                [alert show];
            }
        
        }
    
    
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This observation has already been submitted for Review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    }
   
}
-(EYLNewObservation *)createNewObservation{

    NSString * observedBy = [NSString stringWithFormat:@"%@ %@",[APICallManager sharedNetworkSingleton].cachePractitioners.firstName, [APICallManager sharedNetworkSingleton].cachePractitioners.lastName];
    NSString * practitionersName = [NSString stringWithFormat:@"%@ %@",[APICallManager sharedNetworkSingleton].cachePractitioners.firstName, [APICallManager sharedNetworkSingleton].cachePractitioners.lastName];
    NSString * apiKey = [APICallManager sharedNetworkSingleton].apiKey;
    NSString * apiPassword = [APICallManager sharedNetworkSingleton].apiPassword;
    NSString * practitionerPin = [APICallManager sharedNetworkSingleton].cachePractitioners.pin;
  //  NSString *uuidString = [[NSUUID UUID] UUIDString];

    EYLNewObservation * temp = [[EYLNewObservation alloc]init];
//    NSString * str = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
  //  temp.observationId = str;
    temp.practitionerId = self.practitionerIdParam;
    temp.childId = self.childIdParam;
    temp.observedBy = observedBy;
    temp.practitionerName = practitionersName;
    temp.apiKey = apiKey;
    temp.apiPassword = apiPassword;
    temp.practitionerPin = practitionerPin;
    temp.readyForUpload = YES;
    temp.isEditing = NO;
    temp.isUploading = NO;
    temp.isUploaded = NO;
   // temp.uniqueTabletOID = str;
    return temp;
}

- (void)manageData {
    // For Housekeeping to delete data from Temperary directory.
    theme.delegate = nil;
//    if (self.fromUpload) {
//        return;
//    }
    if (_eylNewObservation.observationId) {
        NSString *deleteFileAtPath= [NSString stringWithFormat:@"%@%@",[Utils getDraftMediaImages],_eylNewObservation.observationId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deleteFileAtPath isDirectory:nil]) {
            [[NSFileManager defaultManager] removeItemAtPath:deleteFileAtPath error:nil];
        }
        deleteFileAtPath = [[DocumentFileHandler getTemporaryDirectory] stringByAppendingPathComponent:kObservationVideos];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deleteFileAtPath isDirectory:nil]) {
            [[NSFileManager defaultManager] removeItemAtPath:deleteFileAtPath error:nil];
        }
        deleteFileAtPath = [[DocumentFileHandler getTemporaryDirectory] stringByAppendingPathComponent:kObservationImages];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deleteFileAtPath isDirectory:nil]) {
            [[NSFileManager defaultManager] removeItemAtPath:deleteFileAtPath error:nil];
        }
        deleteFileAtPath = [[DocumentFileHandler getTemporaryDirectory] stringByAppendingPathComponent:kObservationVideos];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deleteFileAtPath isDirectory:nil]) {
            [[NSFileManager defaultManager] removeItemAtPath:deleteFileAtPath error:nil];
        }
    }

}
//code for showing EYFS Assessment Data in collectionview text view
//            NSArray *selectedList = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.cfe];
//            NSMutableArray *ageBandArray = [NSKeyedUnarchiver unarchiveObjectWithData:_eylNewObservation.eyfsAgeBand];
//
//            NSString *textStatement = @"";
//
//            for (OBEyfs *obEyfs in selectedList) {
//
//                NSString *assesmentType = @"";
//                Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
//                NSNumber *ageIdentifier = nil;
//                if (statement) {
//                    ageIdentifier = statement.ageIdentifier;
//                }
//                else{
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assessmentLevel == %@ OR assessmentLevel == %@",obEyfs.assessmentLevel,[NSNumber numberWithInteger:obEyfs.assessmentLevel.integerValue]];
//                    NSArray *array = [selectedList filteredArrayUsingPredicate:predicate];
//                    if (array.count > 1) {
//                        predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",obEyfs.frameworkItemId];
//                        NSArray *array = [ageBandArray filteredArrayUsingPredicate:predicate];
//                        [ageBandArray removeObjectsInArray:array];
//                        continue;
//                    }
//                    ageIdentifier = @(obEyfs.frameworkItemId.integerValue);
//                }
//                Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
//
//                for (EYLAgeBand *eylAgeBand in ageBandArray) {
//                   // if (eylAgeBand.levelNumber.integerValue == obEyfs.assessmentLevel.integerValue && eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue) {
//                    if (eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue){
//                        [ageBandArray removeObject:eylAgeBand];
//                        break;
//                    }
//                }
//
//                Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
//
//                Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
//                if((!age && !aspect && !eyfs ))
//                    continue;
//                textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc];
//                if (statement) {
//                    textStatement = [textStatement stringByAppendingString:[NSString stringWithFormat:@"\n--->%@%@\n\n",statement.statementDesc,assesmentType]];
//                }
//                else{
//                    textStatement = [textStatement stringByAppendingString:@"\n\n"];
//                }
//            }
//            for (EYLAgeBand *eylAgeBand in ageBandArray) {
//                if (eylAgeBand.levelNumber.integerValue != 0) {
//                    Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:eylAgeBand.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
//                    Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
//
//                    Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
//                    if(!age && !aspect && !eyfs )
//                        continue;
//                    textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc];
//                }
//            }
//            textStatement = [textStatement stringByReplacingOccurrencesOfString:@"(null)" withString:[NSString string]];
//            if (textStatement.length >0) {
//                [cell.plusLabel setHidden:YES];
//                [cell.plusBtn setHidden:YES];
//            }
//            else{
//                [cell.plusLabel setHidden:NO];
//                [cell.plusBtn setHidden:NO];
//            }
//            cell.textView.text = textStatement;
- (IBAction)tagsBtnAction:(id)sender
{
    tagsArray=[NSMutableArray arrayWithObjects:@"Spontaneous Observation", nil];
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setObject:@"S" forKey:@"Spontaneous Observation"];
    
    self.tagsViewContoller = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupsViewStoryBoardID"];
    self.tagsViewContoller.delegate = self;
    self.tagsViewContoller.cellType=KCellTypeTag;
    self.tagsViewContoller.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tagPopOver = [[WYPopoverController alloc] initWithContentViewController:self.tagsViewContoller];
    self.tagPopOver.theme.tintColor = [UIColor clearColor];
    self.tagPopOver.theme.fillTopColor = [UIColor clearColor];
    self.tagPopOver.theme.fillBottomColor = [UIColor clearColor];
    self.tagPopOver.theme.glossShadowColor = [UIColor clearColor];
    self.tagPopOver.theme.outerShadowColor = [UIColor clearColor];
    self.tagPopOver.theme.outerStrokeColor = [UIColor clearColor];
    self.tagPopOver.theme.innerShadowColor = [UIColor clearColor];
    self.tagPopOver.theme.innerStrokeColor = [UIColor clearColor];
    self.tagPopOver.theme.overlayColor = [UIColor clearColor];
    
    self.tagPopOver.theme.glossShadowBlurRadius = 0.0f;
    self.tagPopOver.theme.borderWidth = 0.0f;
    self.tagPopOver.theme.arrowBase = 0.0f;
    self.tagPopOver.theme.arrowHeight = 0.0f;
    self.tagPopOver.theme.outerShadowBlurRadius = 0.0f;
    self.tagPopOver.theme.outerCornerRadius = 0.0f;
    self.tagPopOver.theme.minOuterCornerRadius = 0.0f;
    self.tagPopOver.theme.innerShadowBlurRadius = 0.0f;
    self.tagPopOver.theme.innerCornerRadius = 0.0f;
    self.tagPopOver.theme.glossShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.tagPopOver.theme.outerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.tagPopOver.theme.innerShadowOffset = CGSizeMake(0.0f, 0.0f);
    self.tagPopOver.theme.viewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tagPopOver.wantsDefaultContentAppearance = NO;
    
    self.tagPopOver.theme.arrowHeight = 10.0f;
    self.tagPopOver.theme.arrowBase = 0;
    int height=0;
    
    self.tagsViewContoller.tableView.scrollEnabled=YES;
    self.tagsViewContoller.dataArray=[tagsArray copy];
    self.tagsViewContoller.dataSoruce=dict;
    
    self.tagPopOver.popoverContentSize = CGSizeMake(230, height);
    
    CGRect rect = ((UIButton *)sender).frame;
    rect.origin.y += 45;
    rect.origin.x += 70;
    [self.tagPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    
}

@end
