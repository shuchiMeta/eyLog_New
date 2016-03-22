                                                                             //
//  GridViewController.m
//  eyLog
//
//  Created by Qss on 8/20/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "GridViewController.h"
#import "ListViewCell.h"
#import "APICallManager.h"
#import "INChildren.h"
#import "Utils.h"
#import "ListTableViewCell.h"
#import "Theme.h"
#import "Child.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "ChilderenViewController.h"
#import "ChildInfoTableViewCell.h"
#import "ChildInfoDataModal.h"
#import "EYL_AppData.h"
#import "ChildInOutTime.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "Ethnicity.h"
#import <Crashlytics/Crashlytics.h>


NSString *const kUSER_ROLE_MANAGER=@"nursery_manager";
NSString *const KUSER_ROLE_PRACTITIONER=@"practitioner";
@interface GridViewController () <ListViewCellDelegate, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate, CustomBarButton_InOutDelegate, UINavigationControllerDelegate>
{
    UIRefreshControl *refresControl;
    UIRefreshControl *refresControlTableView;
    BOOL isShowingLandscapeView;
    Child *currentChildren;
    NSArray *profileOptions;
    NSMutableDictionary *notConnectedData;
   }
@property(nonatomic,strong) NSIndexPath *indexpathCurrent;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIPopoverController *popOver;

@property (nonatomic, strong) EYL_AppData *appData;
@property (nonatomic, weak) IBOutlet UIView *childDetailInfo_PopupView;
@property (nonatomic, weak) IBOutlet UIImageView *childDetailInfo_ImageView;
@property (nonatomic, weak) IBOutlet UITableView *childDetailInfo_TableView;
@property (nonatomic, weak) IBOutlet UIButton *childDetailInfo_btnSelectImage;
@property (nonatomic, strong) NSMutableArray *childDetailInfo_Array;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIButton *currentButton;

-(IBAction)btnCloseAction:(UIButton *) button;

@end

@implementation GridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetSelectedChildren) name:@"kResetSelectedChildren" object:nil];
   
    [self.collectionViewController registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellWithReuseIdentifier:@"listViewCell"];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ChildrenNewData"])
    {
        [self getRegistryINOUT];
        
    }
    self.array_childIDs = [[NSMutableArray alloc] init];
    self.parentVC = (ChilderenViewController *)[self.parentViewController parentViewController];
    self.tableView.hidden=YES;
    self.collectionViewController.alwaysBounceVertical = YES;
    self.appData = [EYL_AppData sharedEYL_AppData];
    
    refresControl = [[UIRefreshControl alloc] init];
    [refresControl addTarget:self action:@selector(collectionViewDidRefreshed:) forControlEvents:UIControlEventValueChanged];
    [self.collectionViewController addSubview:refresControl];
    // Do any additional setup after loading the view.
    [self.childDetailInfo_TableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChildInfoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChildInfoTableViewCellIdentifier];

    self.childDetailInfo_Array = [[NSMutableArray alloc] init];
//   [[APICallManager sharedNetworkSingleton] fetchAllInOutTime];
    profileOptions=[NSArray arrayWithObjects:@"Name:",@"Date of Birth:",@"Gender:",@"Ethnicity:",@"Dietary Requirement:",@"Group:",@"Key Person:",@"English as an Additional Language:",@"Special Educational Needs(SEN):",@"Looked After Child(LAC)",@"Funded 2 year old:",@"Funded 3-4 year old:",@"Pupil Premium:",@"Notes:",nil];
    
    [self checkLastUpdate];
    NSString *practitionerGroupName=[APICallManager sharedNetworkSingleton].cachePractitioners.groupName;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSLog(@"Checking Practitioner %@",[APICallManager sharedNetworkSingleton].cachePractitioners.userRole);
    
    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_ROLE_PRACTITIONER] == NSOrderedSame ) {
        
        if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
        {
            childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
        }
        else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
        {
            childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:practitionerGroupName] mutableCopy];
        }
        else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
        {
            childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
        }
    }
    else
    {
        childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
    }
    for (INData *children in childrenList)
    {
    
        [self.array_childIDs addObject:children.childId];
        
    }
    
    //[self.appData showProgressWithMessage:@"Loading"];
    //[self getRegistryINOUT];
    
    [APICallManager sharedNetworkSingleton].childArray=childrenList;
    _childrenListForTableView=[childrenList copy];
    selectedChildrenList=[[NSMutableArray alloc]init];
    for (Child *child in [APICallManager sharedNetworkSingleton].cacheChildren) {
        NSInteger indexOfChild = [childrenList indexOfObject:child];
        [selectedChildrenList addObject:[NSIndexPath indexPathForRow:indexOfChild inSection:0]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView:) name:@"UpdateCollectionView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelectedObject) name:@"ClearAction" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendDataToWeb) name:kReachabilityChangedNotification object:nil];
//    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotoChild"] isEqualToString:@"completed"])
//    {
//        [self saveAllChildrenPhotosAtBackground];
//        
//    }
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendDataToWeb) name:@"NetworkUnreachable" object:nil];
    [self.collectionViewController reloadData];
}
-(void)saveAllChildrenPhotosAtBackground
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *aary=[Child fetchALLChildInContext:[AppDelegate context]];
        
        for(int i= 0;i<aary.count;i++)
        {
            Child *chiild=[aary objectAtIndex:i];
            
                BOOL isDirectory = NO;
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:[Utils getChildrenImages] isDirectory:&isDirectory];
            if (directoryExists) {
                //NSLog(@"isDirectory: %d", isDirectory);
            } else {
                NSError *error = nil;
                BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[Utils getChildrenImages] withIntermediateDirectories:NO attributes:nil error:&error];
                if (!success) {
                    NSLog(@"Failed to create directory with error: %@", [error description]);
                }
            }
            
            
            NSString *filePath = [[Utils getChildrenImages] stringByAppendingPathComponent:chiild.photo];
            NSError *error = nil;
            UIImage *practitionerImage=[UIImage imageWithContentsOfFile:filePath];
            if(practitionerImage == nil)
            {
                NSURL *url;
                url=[NSURL URLWithString:chiild.photourl];
                if(url)
                {
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
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if( [self.collectionViewController.indexPathsForVisibleItems containsObject:[NSIndexPath indexPathForItem:i inSection:0]])
                {
                    if(chiild.photo)
                    {
                    [self.collectionViewController reloadItemsAtIndexPaths:[NSMutableArray arrayWithObjects:[NSIndexPath indexPathForItem:i inSection:0], nil]];
                    }
                }
            });

            if(i== aary.count-1)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"completed" forKey:@"PhotoChild"];
                
            }
            
        }
        
        
    });
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
}

-(void) checkLastUpdate
{
  NSString *response = [Child fetchALLChildandUpdateINOUTTime:[AppDelegate context]];
    
    if ([response isEqualToString:@"Records Already Updated"])
    {
        // Database already updated with latest record
        
    }
    else if ([response isEqualToString:@"No Record Found"])
    {
        // Database has no record
    }
    else if ([response isEqualToString:@"Records Updated Successfully"])
    {
        // // Database updated with latest record
        [self.collectionViewController reloadData];
    }
}


- (void)resetSelectedChildren {
    [selectedChildrenList removeAllObjects];
    [[APICallManager sharedNetworkSingleton].cacheChildren removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kResetSelectedChildren" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{

    NSLog(@"%@", self.lastCameIN);
    NSLog(@"%@", self.lastLeftAT);
    // [self.collectionViewController reloadData];
 // [[APICallManager sharedNetworkSingleton] fetchAllInOutTime];
//    if (self.isPopUp) {
//        selectedChildrenPopover = [[NSMutableArray alloc] init];
//        [selectedChildrenPopover addObjectsFromArray:[APICallManager sharedNetworkSingleton].cacheChildren];
   
}

-(void)removeSelectedObject
{
    [[APICallManager sharedNetworkSingleton].cacheChildren removeAllObjects];
    [selectedChildrenList removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectedStatus" object:[NSString stringWithFormat:@"%d",0]];

   // [self.tableView reloadData];
    [self.collectionViewController reloadData];
}

-(void)reloadCollectionView:(NSNotification *)notification
{
    _childrenListForTableView=[notification.userInfo objectForKey:@"data"];
    [self.collectionViewController reloadData];
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CollectionView
- (void)collectionViewDidRefreshed:(UIRefreshControl *)sender
{
    if ([Utils checkNetwork])
    {
        _isRefreshedFromPullToRefresh=YES;
        [self refreshChildren];
        
        
      
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [refresControl endRefreshing];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _childrenListForTableView.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell *cell;
    Child *children=[_childrenListForTableView objectAtIndex:indexPath.row];
    
    if ([APICallManager sharedNetworkSingleton].settingObject.dailyDiary==0)
    {
        static NSString *cellIdentifier = @"listViewCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        //cell.childImage.image=[UIImage imageNamed:@"eylog_Logo"];
        
    }
    else
    {
    static NSString *cellIdentifier = @"gridViewCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
       // cell.childImage.image=[UIImage imageNamed:@"eylog_Logo"];

        [cell.btnIN setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [cell.btnOUT setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        if(children.registryStatus!=nil && children.registryStatus !=[NSNumber numberWithInteger:0])
        {
            [cell.btnIN setHidden:YES];
            [cell.btnOUT setHidden:YES];
            [cell.registryStatusBtn setHidden:NO];
            
            NSString *str;
            
            if([children.registryStatus integerValue]==1)
            {
                str=@"Absent";
                
            }
            else if ([children.registryStatus integerValue]==2)
            {
                str=@"Holiday";
                
            }
            else if ([children.registryStatus integerValue]==3)
            {
                str=@"Sick";
                
            }
            else if ([children.registryStatus integerValue]==4)
            {
                str=@"Not Booked";
                
            }
            else if ([children.registryStatus integerValue]==-1)
            {
                str=@"Published";
                
            }
            else
            {
            //str=@"Not found";
                [cell.btnIN setHidden:NO];
                [cell.btnOUT setHidden:NO];
                [cell.registryStatusBtn setHidden:YES];
                
                if(children.inTime.length>0)
                {
                    [cell.btnIN setTitle:[@"IN " stringByAppendingString:[children.inTime substringToIndex:5]] forState:UIControlStateNormal];
                }
                if(children.outTime.length>0)
                {
                    [cell.btnOUT setTitle:[@"OUT " stringByAppendingString:[children.outTime substringToIndex:5]] forState:UIControlStateNormal];
                }
                if (([children.outTime isEqualToString:@"00:00"] || [children.outTime isEqualToString:@"00:00:00"]) && ![children.inTime isEqualToString:@"00:00"])
                {
                    cell.btnIN.backgroundColor = KGREENCOLOR;
                    cell.btnOUT.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
                    
                    [cell.btnIN setSelected:YES];
                    [cell.btnOUT setSelected:NO];
                    
                    
                    //[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0f];
                }
                else
                {
                    [cell.btnIN setSelected:NO];
                    [cell.btnOUT setSelected:NO];
                    
                    
                    
                    cell.btnIN.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
                    cell.btnOUT.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
                }

                
            }
            [cell.registryStatusBtn setTitle:str forState:UIControlStateNormal];
            
        }
        else
        {
            [cell.btnIN setHidden:NO];
            [cell.btnOUT setHidden:NO];
            [cell.registryStatusBtn setHidden:YES];
            
        if(children.inTime.length>0)
        {
            [cell.btnIN setTitle:[@"IN " stringByAppendingString:[children.inTime substringToIndex:5]] forState:UIControlStateNormal];
        }
        if(children.outTime.length>0)
        {
            [cell.btnOUT setTitle:[@"OUT " stringByAppendingString:[children.outTime substringToIndex:5]] forState:UIControlStateNormal];
        }
        if (([children.outTime isEqualToString:@"00:00"] || [children.outTime isEqualToString:@"00:00:00"]) && ![children.inTime isEqualToString:@"00:00"])
        {
            cell.btnIN.backgroundColor = KGREENCOLOR;
            cell.btnOUT.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
            
            [cell.btnIN setSelected:YES];
            [cell.btnOUT setSelected:NO];
            
            
            //[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0f];
        }
        else
        {
            [cell.btnIN setSelected:NO];
            [cell.btnOUT setSelected:NO];
        
        

            cell.btnIN.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
            cell.btnOUT.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
        }

    }
    }
  
    cell.childName.text= [NSString stringWithFormat:@"%@ %@",children.firstName, children.lastName];
    cell.childAgecategory.text=[NSString stringWithFormat:@"%@ months",children.ageMonths];
    cell.childGroup.text=[NSString stringWithFormat:@"%@",children.groupName];
    cell.checkImageView.hidden=([selectedChildrenList containsObject:indexPath])?NO:YES;
    cell.indexPath= indexPath;
    cell.delegate=self;


    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.childImage];
    
    cell.childImage.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    cell.childImage.showActivityIndicator=YES;
    
        
        NSString *filePath = [[Utils getChildrenImages] stringByAppendingPathComponent:children.photo];
        NSError *error = nil;
        UIImage *practitionerImage=[UIImage imageWithContentsOfFile:filePath];
    
    

            //dispatch_async(dispatch_get_main_queue(), ^{
                
    if(practitionerImage == nil)
    {
        
         cell.childImage.image=nil;
        UIActivityIndicatorView *view=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.center = CGPointMake(cell.childImage.bounds.size.width/2.0, cell.childImage.bounds.size.height / 2.0);
        // view.center=cell.childImage.center;
        [view startAnimating];
        
        if(cell.childImage.subviews.count==0)
        {
            [cell.childImage addSubview:view];
        }
        else
        {
        for (id object in cell.childImage.subviews) {
            if ([object isKindOfClass:[UIActivityIndicatorView class]]) {
                
            }
            else
            {
                [cell.childImage addSubview:view];
            }
        }
        }
    }
    else
    {
        
                for(UIActivityIndicatorView *view in cell.childImage.subviews)
                {
                    [view stopAnimating];
                    
                    
                }
       
        
                cell.childImage.image=practitionerImage;
                if (cell.childImage.bounds.size.width > practitionerImage.size.width && cell.childImage.bounds.size.height > practitionerImage.size.height) {
                    cell.childImage.contentMode = UIViewContentModeScaleAspectFit;
                }
                if(cell.childImage.bounds.size.width < practitionerImage.size.width)
                {
                    
                    cell.childImage.contentMode = UIViewContentModeScaleAspectFit;
                }
    }
           // });
            
    
    [[AsyncImageLoader defaultCache] removeAllObjects];
    
    children=nil;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell * cell = (ListViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    Child *children=[_childrenListForTableView objectAtIndex:indexPath.row];
    [EYL_AppData sharedEYL_AppData].selectedChild = children.childId;


        if([selectedChildrenList containsObject:indexPath])
        {
            
            if([APICallManager sharedNetworkSingleton].isFromDraftList)
            {
              if([[APICallManager sharedNetworkSingleton].mainSelectedChild.childId integerValue] != [children.childId integerValue])
              {
                  cell.checkImageView.hidden = YES;
                  [selectedChildrenList removeObject:indexPath];
                  [[APICallManager sharedNetworkSingleton].cacheChildren removeObject:[_childrenListForTableView objectAtIndex:indexPath.row]];
              }
            }
            else
            {
                cell.checkImageView.hidden = YES;
                [selectedChildrenList removeObject:indexPath];
                [[APICallManager sharedNetworkSingleton].cacheChildren removeObject:[_childrenListForTableView objectAtIndex:indexPath.row]];
            }
          
        }
        else
        {
            cell.checkImageView.hidden = NO;

            [selectedChildrenList addObject:indexPath];
            [[APICallManager sharedNetworkSingleton].cacheChildren addObject:[_childrenListForTableView objectAtIndex:indexPath.row]];
        }

    NSString *str;
    
//    for(Child *child in [APICallManager sharedNetworkSingleton].cacheChildren)
//    {
//    str 
//    }
//    
        // [CrashlyticsKit setUserEmail:<#(nullable NSString *)#>]
    
        [APICallManager sharedNetworkSingleton].cacheChild=(Child *)[_childrenListForTableView objectAtIndex:((NSIndexPath *)[selectedChildrenList lastObject]).row];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectedStatus" object:[NSString stringWithFormat:@"%lu",(unsigned long)selectedChildrenList.count]];

        [self.delegate didselectItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{


//    CGSize mElementSize = CGSizeMake(162, 185);
     CGSize mElementSize = CGSizeMake(145, 200);

    if (self.isPopUp) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            //        NSLog(@"Setting Landscape Size for Item at Index %ld", (long)indexPath.row);
            mElementSize = CGSizeMake(140, 165);

        }
        else
        {
            //        NSLog(@"Setting Portrait Size for Item at Index %ld", (long)indexPath.row);
            mElementSize = CGSizeMake(158, 180);

        }
    }
    else
    {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            //        NSLog(@"Setting Landscape Size for Item at Index %ld", (long)indexPath.row);
            mElementSize = CGSizeMake(145, 200);

        }
        else
        {
            //        NSLog(@"Setting Portrait Size for Item at Index %ld", (long)indexPath.row);
            mElementSize = CGSizeMake(162, 200);//162
        }
    }
    return mElementSize;
}


//TableView
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==701) {
        return profileOptions.count;
    }
    else
    return _childrenListForTableView.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag==701)
    {
        ChildInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChildInfoTableViewCellIdentifier forIndexPath:indexPath];

//        ChildInfoDataModal *obj = [self.childDetailInfo_Array objectAtIndex:indexPath.row];
               switch (indexPath.row) {
            case 0:
                   {
                       cell.lblName.text = [profileOptions objectAtIndex:indexPath.row];
                       cell.lblDescription.text = [NSString stringWithFormat:@"%@ %@",currentChildren.firstName,currentChildren.lastName];
                   }
                break;
            case 1:
                   {
                       cell.lblName.text = [profileOptions objectAtIndex:indexPath.row];
                       NSString *dobString;
                       if (currentChildren.dob) {
                           dobString=[Utils getDateStringFromDateInYYYYMMDD:currentChildren.dob];
                       }else{
                           dobString=@"";
                       }
                       cell.lblDescription.text = [NSString stringWithFormat:@"%@",dobString];
                   }
               break;
            case 2:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *gender=currentChildren.gender;
                       if (gender && [gender isEqualToString:@"F"]) {
                           gender=@"Female";
                       }else if (gender && [gender isEqualToString:@"M"]){
                           gender=@"Male";
                       }else{
                           gender=@"";
                       }
                       cell.lblDescription.text=gender;
                   }
               break;

            case 3:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *ethinicity;
                       if (![currentChildren.ethnicity isEqualToNumber:[NSNumber numberWithInt:0]]) {
                        Ethnicity *ethnicty=[Ethnicity fetchInContext:[AppDelegate context] withethnicitychildid:[NSNumber numberWithInteger:[currentChildren.ethnicity integerValue]]];
                           
                        Ethnicity *new=[Ethnicity fetchInContext:[AppDelegate context] withethnicityId:[NSNumber numberWithInteger:[ethnicty.parent integerValue]]];
                        
                           ethinicity=[[new.ethnicityDesc stringByAppendingString:@"-->"] stringByAppendingString:ethnicty.ethnicityDesc];
                           
                       }else{
                          ethinicity=@"";
                       }
                       cell.lblDescription.text = ethinicity;
                   }
               break;
            case 4:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *diet;
                       if (currentChildren.dietaryRequirment) {
                           diet=[NSString stringWithFormat:@"%@",currentChildren.dietaryRequirment];
                       }else{
                           diet=@"";
                       }
                       cell.lblDescription.text =diet;
                   }
                       break;
            case 5:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *group;
                       if (currentChildren.groupName) {
                           group=[NSString stringWithFormat:@"%@",currentChildren.groupName];
                       }else{
                           group=@"";
                       }
                       cell.lblDescription.text =group;
                   }
                       break;
            case 6:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *keyPerson;
                       if (currentChildren.practitionerId) {
                          NSArray *pract=[Practitioners fetchPractitionersInContext:[AppDelegate context] withPractitionerId:currentChildren.practitionerId];
                           Practitioners *obj=[pract firstObject];
                           keyPerson=obj.name;
                       }

                       cell.lblDescription.text =keyPerson;
                   }
                       break;
            case 7:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *engAdditinalLag;
                       if ([currentChildren.englistAdditionalLanguage integerValue] && [currentChildren.englistAdditionalLanguage integerValue]==1) {
                           engAdditinalLag=@"YES";
                       }else{
                           engAdditinalLag=@"NO";

                       }
                       cell.lblDescription.text =engAdditinalLag;
                   }
                       break;
            case 8:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *specialLanguage;
                       if ([currentChildren.specialEducationalNeeds integerValue] && [currentChildren.specialEducationalNeeds integerValue]==1) {
                           specialLanguage=@"YES";
                       }else{
                           specialLanguage=@"NO";

                       }
                       cell.lblDescription.text =specialLanguage;
                   }
                       break;
            case 9:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *lookedAfterChild;

                       if ([currentChildren.slt integerValue] && [currentChildren.slt integerValue]==1) {
                           lookedAfterChild=@"YES";
                       }else{
                           lookedAfterChild=@"NO";

                       }
                       cell.lblDescription.text =lookedAfterChild;
                   }
                       break;
            case 10:
                   {
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *funded2Year;

                       if ([currentChildren.twoYearFunding integerValue] && [currentChildren.twoYearFunding integerValue]==1) {
                           funded2Year=@"YES";
                       }else{
                           funded2Year=@"NO";

                       }
                       cell.lblDescription.text =funded2Year;
                   }
                       break;
            case 11:

                   { // Needs TO be UPDATED As funded 3-4 year is not Available in DB
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *funded34Year;;

                       if ([currentChildren.twoYearFunding integerValue] && [currentChildren.twoYearFunding integerValue]==1) {
                           funded34Year=@"YES";
                       }else{
                           funded34Year=@"NO";

                       }
                       cell.lblDescription.text =funded34Year;
                   }
                       break;
                   case 12:
                   {
                       // Needs TO be UPDATED As No notes available in DB for Child
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                       NSString *pupilPremium;;
                       //  NSString *Notes;
                       if ([currentChildren.pupilPremium integerValue] && [currentChildren.pupilPremium integerValue]==1) {
                           pupilPremium=@"YES";
                       }else{
                           pupilPremium=@"NO";
                           
                       }
                       cell.lblDescription.text =pupilPremium;
                       
                   }
                       break;

            case 13:
                   {
                       // Needs TO be UPDATED As No notes available in DB for Child
                       cell.lblName.text=[profileOptions objectAtIndex:indexPath.row];
                     //  NSString *Notes;
                       cell.lblDescription.text =@"NA";

                   }
                       break;


            default:
                break;
        }

        return cell;

    }
    else
    {
        static NSString *cellId = @"ListViewCellIdentifier";
        ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        }
        Child *children=[_childrenListForTableView objectAtIndex:indexPath.row];
        if([children.practitionerId intValue] >0)
        {
            Practitioners *practitioners=[[Practitioners fetchPractitionersInContext:[AppDelegate context] withPractitionerId:children.practitionerId] lastObject];
            cell.practitionerName.text=practitioners.firstName;
        }

        NSString *detailText = @"";

        if (children.englistAdditionalLanguage == [NSNumber numberWithInt:1]) {
            detailText = [NSString stringWithFormat:@"EAL, "];
        }
        if (children.specialEducationalNeeds == [NSNumber numberWithInt:1]) {
            detailText = [NSString stringWithFormat:@"%@SEN, ",detailText];
        }
        if (children.twoYearFunding == [NSNumber numberWithInt:1]) {
            detailText = [NSString stringWithFormat:@"%@Funded 2 year,  ",detailText];
        }

        //  cell.practitionerName.text=[NSString stringWithFormat:@"%@",children.practitionerId];
        cell.detail.text=children.dietaryRequirment;

        if (children.dob) {
            NSDate *startDate = children.dob;
            NSDate *endDate = [NSDate date];

            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                                fromDate:startDate
                                                                  toDate:endDate
                                                                 options:0];

            cell.childAgecategory.text= [NSString stringWithFormat:@"%ld months, %@",(long)[components month],children.groupName];
        }
        else
        {
            cell.childAgecategory.text= children.groupName;
        }

        cell.childName.text = [NSString stringWithFormat:@"%@ %@",children.firstName, children.lastName];

        cell.detail.text = detailText;
        cell.customView.backgroundColor=([selectedChildrenList containsObject:indexPath])?yellowColor:[UIColor whiteColor];
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],children.photo];
        UIImage *childrenImage=[UIImage imageWithContentsOfFile:imagePath];
        cell.childImage.image=childrenImage;

        return cell;
    }

    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==701) {

    }
    else
    {
        if([selectedChildrenList containsObject:indexPath])
        {
            [selectedChildrenList removeObject:indexPath];
            [[APICallManager sharedNetworkSingleton].cacheChildren removeObject:[_childrenListForTableView objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectedChildrenList addObject:indexPath];
            [[APICallManager sharedNetworkSingleton].cacheChildren addObject:[_childrenListForTableView objectAtIndex:indexPath.row]];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectedStatus" object:[NSString stringWithFormat:@"%lu",(unsigned long)selectedChildrenList.count]];

        [APICallManager sharedNetworkSingleton].cacheChild=(Child *)[_childrenListForTableView objectAtIndex:((NSIndexPath *)[selectedChildrenList lastObject]).row];

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([selectedChildrenList containsObject:indexPath])
    {
        [selectedChildrenList removeObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionViewController reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

-(void)refreshChildren
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading children data";
    

    NSString *urlString=[NSString stringWithFormat:@"%@api/children/lists",[APICallManager sharedNetworkSingleton].serverURL];

    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password", nil];

    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];

                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                    [refresControl endRefreshing];
                                                    [refresControlTableView endRefreshing];


                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  return;
                                              }

                                              [self loadChildrenData:data];
                                          }];

    [postDataTask resume];
}

-(void)getChildrenImages
{
    
    if (refresControl.refreshing) {
        [refresControl endRefreshing];
    }
    if (refresControlTableView.refreshing){
        [refresControlTableView endRefreshing];
    }
    
    //UIViewController *topVC = self.navigationController;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Children Data..";
    //  serverURL=@"https://demo.eylog.co.uk/trunk/";
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
                                                      dispatch_sync(dispatch_get_main_queue(), ^{
                                                        [self refreshChildren];
//                                                          [self.collectionViewController reloadData];
//                                                          [self.tableView reloadData];

                                                      });
                                                     // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  }
                                                  else
                                                  {
                                                    //  [self performSelectorInBackground:@selector(getChildrenImages) withObject:nil];
                                                      NSLog(@"Error while unarchiving Children Images");
                                                  }
                                              }
                                          }];
    [postDataTask resume];
}
//


- (void)storeChildrenData:(void (^)(BOOL success))completion
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completion([Child deleteChildInContext:[AppDelegate context]]);
            
            
            
        });
    });


}

-(void)loadChildrenData:(NSData *)data
{
    [self.array_childIDs removeAllObjects];
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Children Data : %@", jsonDict);
    NSMutableArray *imagesArray=[NSMutableArray new];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: [Utils getChildrenImages]];
    
    for (INData *children in childrenList)
        
    {
        
        [imagesArray addObject:children.photo];
        
    }
    
    
    
    for(NSString *str in directoryContent)
        
    {
        
        
        
        if(![imagesArray containsObject:str])
            
        {
            
            NSString *filePath = [[Utils getChildrenImages] stringByAppendingPathComponent:str]
            
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
    
    
    
    
    
    NSLog(@"%@", documentsDirectory);
    
    

    if (jsonDict == nil) {
        [self refreshChildren];
        return;
    }

    childrenList = [[INPractitioners modelObjectWithDictionary:[jsonDict objectForKey:@"children"]].data mutableCopy];

    
    NSString *currentDate = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
    [self storeChildrenData:^(BOOL success){
        if(success)
        {
       
       NSDateFormatter *dateFormatter;


    for (INData *children in childrenList)
    {
        
        [self.array_childIDs addObject:children.childId];
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd-MM-yyyy"; //very simple format  "8:47:22 AM"
        }

        NSLog(@"Child Id %@",[NSNumber numberWithDouble:children.practitionerId]);
        NSLog(@"Child Id %f",children.practitionerId);
        //NSString *inTime;
        //NSString *outTime;
       // if(children.)

        NSDate *dob=[dateFormatter dateFromString:children.dob];
        NSDate *startDate=[dateFormatter dateFromString:children.startDate];
                 [Child createChildInContext:[AppDelegate context] withChild:[NSNumber numberWithInteger:[children.childId integerValue]] withDietaryRequirment:children.dietaryRequirments withDob:dob withEnglishAdditionalLanguage:[NSNumber numberWithBool:children.englishAdditionalLanguage] withEthnicity:[NSNumber numberWithInteger:[children.ethnicity integerValue]] withFirstName:children.firstName withGender:children.gender withGroupId:[NSNumber numberWithInteger:[children.groupId integerValue]] withGroupName:children.groupName withLanguage:children.language withLastName:children.lastName withMiddleName:children.middleName withNationality:children.nationality withPractitionerId:[NSNumber numberWithDouble:children.practitionerId] withReligion:children.religion withShareTwoYearReport:[NSNumber numberWithBool:children.shareTwoYearReport] withSLt:[NSNumber numberWithBool:children.slt] withSpecialEductionalNeeds:[NSNumber numberWithBool:children.specialEducationalNeeds] withStartDate:startDate withPhoto:children.photo withTwoYearFunding:[NSNumber numberWithBool:children.twoYearFunding] withAgeMonths:children.ageMonths withInTime:@"00:00" withOutTime:@"00:00" withCurrentDate:currentDate registryArray:[NSData new] pupilPremium:[NSNumber numberWithBool:children.pupilPremium] withphotoUrl:children.photoUrl ];
        
    }
            
    [self getRegistryINOUT];
     //[self updateChildrenPhotosInBackground];
     }
   }];

    
}
-(void)updateChildData
{
    NSString *practitionerGroupName=[APICallManager sharedNetworkSingleton].cachePractitioners.groupName;
    
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    
    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_ROLE_PRACTITIONER]==NSOrderedSame) {
        
        if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
        {
            _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:practitionerId] mutableCopy];
        }
        else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
        {
            _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:practitionerGroupName] mutableCopy];
        }
        else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
        {
            _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
        }
    }else{
        
        _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
    }
    
    //    self.childrenListForTableView = [Child fetchALLChildInContext:[AppDelegate context]];
    
    if (!self.parentVC) {
        self.parentVC =  (ChilderenViewController * )[self.parentViewController parentViewController];
    }

}
-(void)updateData
{
    [self updateChildData];
    
    [self resetSelectedChildren];
    
    [self.parentVC performSelectorOnMainThread:@selector(sortDataWithArray:) withObject:_childrenListForTableView waitUntilDone:YES];
    [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
}

- (IBAction)refreshChildData:(id)sender {
   
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/children/childDetailsForPOPup",[APICallManager sharedNetworkSingleton].serverURL];
    
    NSString *str=[NSString stringWithFormat:@"%ld",(long)[currentChildren.childId integerValue]];
    
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",str,@"child_id", nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  
                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [refresControl endRefreshing];
                                                  [refresControlTableView endRefreshing];
                                                  
                                                  
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  return;
                                              }
                                              
                                              [self saveData:data];
                                          }];
    
    [postDataTask resume];


    
}
-(void)saveData:(NSData *)data
{
    NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd"; //very simple format  "8:47:22 AM"
    }
//2015-10-01
   
  
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Children Data : %@", jsonDict);
    NSDictionary *dict=[jsonDict objectForKey:@"data"];
      NSDate *dob=[dateFormatter dateFromString:[dict objectForKey:@"dob"]];
    NSDate *startDate=[dateFormatter dateFromString:[dict objectForKey:@"start_date"]];
  
    
    [Child withChild:[NSNumber numberWithInteger:[[dict objectForKey:@"child_id"] integerValue]] withDietaryRequirment:[dict objectForKey:@"dietary_requirments"] withDob:dob withEnglishAdditionalLanguage:[NSNumber numberWithBool:[[dict objectForKey:@"english_additional_language"] integerValue]] withEthnicity:[NSNumber numberWithInteger:[[dict objectForKey:@"ethnicity"] integerValue]] withFirstName:[dict objectForKey:@"first_name"] withGender:[dict objectForKey:@"gender"] withGroupId:[NSNumber numberWithInteger:[[dict objectForKey:@"group_id"] integerValue]] withGroupName:[dict objectForKey:@"group_name"] withLanguage:@"" withLastName:[dict objectForKey:@"last_name"] withMiddleName:[dict objectForKey:@"middle_name"] withNationality:@"" withPractitionerId:[NSNumber numberWithInteger:[[dict objectForKey:@"practitioner_id"] integerValue]] withReligion:@"" withShareTwoYearReport:[NSNumber numberWithBool:[[dict objectForKey:@"share_two_year_report"] integerValue]] withSLt:nil withSpecialEductionalNeeds:[NSNumber numberWithBool:[[dict objectForKey:@"special_educational_needs"] integerValue]] withStartDate:startDate withPhoto:@"" withTwoYearFunding:[NSNumber numberWithBool:[[dict objectForKey:@"two_year_funding"] integerValue]] withAgeMonths:[dict objectForKey:@"age_months"] withInTime:@"" withOutTime:@"" withCurrentDate:@"" registryArray:[NSData new] pupilPremium:nil withPhotoUrl:[dict objectForKey:@"photourl"]  forContext:[AppDelegate context]];
    
    
//    _childrenListForTableView=[NSMutableArray new];
//    
//    if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_ROLE_PRACTITIONER] == NSOrderedSame) {
//        
//        if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
//        {
//            _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[NSNumber numberWithInteger:[[dict objectForKey:@"practitioner_id"] integerValue]]] mutableCopy];
//        }
//        else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
//        {
//            _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[NSNumber numberWithInteger:[[dict objectForKey:@"group_id"] integerValue]] withPractitionerGroupName:[dict objectForKey:@"group_name"]] mutableCopy];
//        }
//        else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
//        {
//            _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
//        }
//    }else{
//        _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
//        
//    }
    
    currentChildren=[_childrenListForTableView objectAtIndex:_indexpathCurrent.row];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.childDetailInfo_TableView reloadData];
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"done" forKey:@"ChildrenNewData"];
}
-(void)closeAlert
{
    UIViewController *topVC = self.navigationController;
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
}


#pragma mark -
#pragma mark - Collection View Cell Delegate Handle here - Display Popup and Date

-(void) btnActionatIndexPath : (NSIndexPath *) indexPath
{
    _indexpathCurrent=indexPath;
    
    [self.collectionViewController setUserInteractionEnabled:NO];
    
    [self.childDetailInfo_Array removeAllObjects];

    [self.childDetailInfo_PopupView setHidden:FALSE];

    //Edited By Arpan
    currentChildren=[_childrenListForTableView objectAtIndex:indexPath.row];

    self.childDetailInfo_TableView.delegate= self;
    self.childDetailInfo_TableView.dataSource= self;

    [self.childDetailInfo_TableView reloadData];
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],currentChildren.photo];
    UIImage *childrenImage= [UIImage imageWithContentsOfFile:imagePath];
    _childDetailInfo_ImageView.contentMode=UIViewContentModeScaleAspectFit;
    if(childrenImage==nil)
    {
      _childDetailInfo_ImageView.image=[UIImage imageNamed:@"eylog_Logo"];
    }
    else
    {
    _childDetailInfo_ImageView.image=childrenImage;
    }
}

-(IBAction)btnCloseAction:(UIButton *) button
{
    [self.collectionViewController setUserInteractionEnabled:YES];

    [self.childDetailInfo_PopupView setHidden:TRUE];
}

- (void) setDateForButton :(UIButton *) button atIndexPath :(NSIndexPath *) indexPath
{
    ListViewCell *cell=(ListViewCell *)[self.collectionViewController cellForItemAtIndexPath:indexPath];
     Child *selectedChild=[_childrenListForTableView objectAtIndex:indexPath.row];
     NSString *string;
    if(selectedChild.firstName!=nil&&selectedChild.lastName!=nil)
    {
        string=[[selectedChild.firstName stringByAppendingString:@" "]stringByAppendingString:selectedChild.lastName];
    }
    else
    {
        string=selectedChild.firstName;
    }

    if([cell.btnIN isSelected])
    {
        
       
                //Would you like to save OUT Time?
       [self showAlertWithTwoButtons:@"Do you want to mark the Child OUT?" andChildName:string];
    }
    else
    {
      
         [self showAlertWithTwoButtons:@"Do you want to mark the Child IN?" andChildName:string];
        
    }
       
    self.currentIndexPath = indexPath;
    self.currentButton = button;
//    switch (button.tag)
//    {
//        case 301:
//        {
//            // Button IN
//            [self showAlertWithTwoButtons:@"Would you like to save IN Time?"];
//            
//        }
//            break;
//        case 302:
//        {
//            // Button OUT
//            [self showAlertWithTwoButtons:@"Would you like to save OUT Time?"];
//        }
//            break;
//
//        default:
//            break;
//    }
}

- (void) showAlertWithTwoButtons : (NSString *) message andChildName:(NSString *)name
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.delegate=self;
    [alert show];
}
-(void)SendDataToWeb
{
    NSMutableArray *dummyArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedData"]];
    Reachability *reachability;
    reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus !=NotReachable)
    {
        
        if(dummyArray.count>0)
        {
            for (int i=0; i<dummyArray.count; i++) {
                NSDictionary *dict=[dummyArray objectAtIndex:i];
                NSURL *myObjectURL = [NSURL URLWithString:[dict objectForKey:@"child"]];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

                NSManagedObjectID *myObjectID = [[appDelegate persistentStoreCoordinator] managedObjectIDForURIRepresentation:myObjectURL];
                
                NSError *error = nil;
                ChildInOutTime *myObject = [[AppDelegate context] existingObjectWithID:myObjectID error:&error];
                
                [[APICallManager sharedNetworkSingleton] uploadRandomInOutTimeRecord:[dict objectForKey:@"array"] andChildInOut:myObject andViewController:nil];
                NSMutableArray *array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedData"]];
                
                [array removeObject:dict];
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                [standardUserDefaults setObject:array forKey:@"storedData"];
            }
            
         }
    }


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    notConnectedData=[NSMutableDictionary new];
    
    /*
     *  There are two Alert Views
     *  One Alert View is to upload the child image and other one is child IN/OUT time
     */
    if (alertView.tag==601)
    {
        switch (buttonIndex)
        {
                // This Alert will update child Image
                
           case 0: // Cancel Button Action
                break;
            case 1 :
            {
                // OK Button Action
                // Replace existing image and upload new image
                
                self.childDetailInfo_ImageView.image = [self scaleImage:self.captureImage toSize:CGSizeMake(162.0,200.0)];
                 [self uploadImageOnServer:self.childDetailInfo_ImageView.image];
            }
                break;
            default :
                break;
        }
        
    }
    else
    {
    ListViewCell * cell = (ListViewCell *)[self.collectionViewController cellForItemAtIndexPath:self.currentIndexPath];
        
        NSString *strCurrentTime = [self.appData getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
        // Update Child Table With Latest IN/OUT Time
        Child *selected=[_childrenListForTableView objectAtIndex:self.currentIndexPath.row];
        
        NSString *trimmedINString=selected.inTime;
        
        NSString *trimmedOUTString=selected.outTime;

        Child *children=[_childrenListForTableView objectAtIndex:self.currentIndexPath.row];
        
            
     NSLog(@"%@", children.childId);
    
     NSString *currentDate = [self.appData getDateFromNSDate:[NSDate date]];
    
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
//    NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
        
        NSTimeInterval uniqueTabletOIID = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: uniqueTabletOIID];
        

    switch (buttonIndex)
    {
        case 0:
        {
            //Cancel

        }
            break;
            case 1:
        {
            // OK
            
            ListViewCell *cell=(ListViewCell *)[self.collectionViewController cellForItemAtIndexPath:self.currentIndexPath];
           
            
            if([cell.btnIN isSelected])
            {
                [cell.btnOUT setSelected:YES];
                [cell.btnIN setSelected:NO];
            }
            else
            {
                [cell.btnOUT setSelected:NO];
                [cell.btnIN setSelected:YES];
                
            }

            
            if ([cell.btnIN isSelected])
            {
               
                
                  NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                  NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                
                [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:currentDate withDate:date withChildId:children.childId withInTime:strCurrentTime withOutTime:@"00:00" withisInUploaded:NO withIsOutUploaded:NO withPractitionerPin: [[APICallManager sharedNetworkSingleton] cachePractitioners].pin withPractitionerId:[[APICallManager sharedNetworkSingleton] cachePractitioners].eylogUserId withtimeStamp:@""];
                
                
                [Child updateChild:children.childId inTime:strCurrentTime andOutTime:@"00:00" andRegistryStatus:nil   forContext:[AppDelegate context]];
                               
//                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                                  children.childId,@"childid",
//                                                  currentDate,@"date",
//                                                  strCurrentTime,@"intime",
//                                                  @"00:00",@"outtime",
//                                                  @"0", @"uploadedflag",
//                                                  [NSNumber numberWithInteger:diff],@"timedifference",
//                                                  timeStampObj,@"uniqueTableID",nil];
//                    
//                    // create new entry for that date
//                [ChildInOutTime createChildInOutTimeContext:[AppDelegate context] withDictionary:dict];
                
                [cell.btnIN setTitle:[@"IN " stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
                [cell.btnOUT setTitle:@"OUT 00:00" forState:UIControlStateNormal];
                
                cell.btnIN.backgroundColor = KGREENCOLOR;
             
                cell.btnOUT.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];;
//                NSArray *childArray=[Child fetchChildInContext:[AppDelegate context] withChildId:children.childId];
//                Child * child = [childArray firstObject];
//            
//                NSArray *array=  [child.childInoutDataWithDateAndChild objectForKey:currentDate];
//
//                NSMutableArray * newarray=[NSMutableArray arrayWithArray:array];
//                
//                    if(newarray.count==0)
//                    {
//                        newarray=[NSMutableArray new];
//                    }
//               // AND currentDate= %@
//                    NSPredicate *recordIDPredicate=[NSPredicate predicateWithFormat:@"uploadFlag = %@ AND childID=%@ AND currentDate= %@",[NSNumber numberWithInt:0],child.childId,currentDate];
//                    NSArray *records=[ChildInOutTime fetchAllRecordsWithPredicate:recordIDPredicate inContext:[AppDelegate context]];
//                    ChildInOutTime *childInOut;
//                    if (records.count >0)
//                    {
//                        childInOut = [records lastObject];
//                        NSDictionary *dictionary=[[NSDictionary alloc] initWithObjectsAndKeys:childInOut.inTime,@"came_in_at",childInOut.outTime,@"left_at",@"0",@"registry_status", nil];
//                        [newarray addObject:dictionary];
//                        
//                        Reachability *reachability;
//                        reachability = [Reachability reachabilityForInternetConnection];
//                        NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//                        if(remoteHostStatus ==NotReachable)
//                        {
//                            NSMutableDictionary *dict=[NSMutableDictionary new];
//                            [dict setObject:newarray forKey:@"array"];
//                            NSString *myObjectToStore = [[[childInOut objectID] URIRepresentation] absoluteString];
//                            [dict setObject:myObjectToStore forKey:@"child"];
//                            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//                           
//                            NSArray *nonMutableArray= [standardUserDefaults objectForKey:@"storedData"];
//                            NSMutableArray *array=[NSMutableArray arrayWithArray:nonMutableArray];
//                            if(array==nil)
//                            array=[NSMutableArray new];
//                                
//                         
//                            if(array.count==0)
//                            {
//                                [array insertObject:dict atIndex:0];
//                            }
//                            else
//                            {
//                                
//                                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"child==%@",[dict objectForKey:@"child"]];
//                                NSArray *filter=[array filteredArrayUsingPredicate:predicate];
//                                if(filter.count>0)
//                                {
//                                  NSInteger integer=[array indexOfObject:[filter firstObject]];
//                                 [array replaceObjectAtIndex:integer withObject:dict];
//                                    
//                                }
//                                else
//                                {
//                                
//                                [array insertObject:dict atIndex:array.count];
//                                }
//                                
//                            }
//                        
//                            [standardUserDefaults setObject:array forKey:@"storedData"];
//                            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSMutableArray arrayWithArray:newarray],currentDate, nil];
//                            [Child updateDictionaryDataForInoutTime:dictionary :child.childId forContext:[AppDelegate context]];
//                                                     
                        //}
//                        else
//                        {
//                            [[APICallManager sharedNetworkSingleton] uploadRandomInOutTimeRecord:newarray andChildInOut:childInOut andViewController:self];
//                        }

                [[APICallManager sharedNetworkSingleton] insertInTimeRecord];
                
                           //  }
                

            }
            else
            {
                NSArray *array=[cell.btnIN.currentTitle componentsSeparatedByString:@"IN "];
                
                NSString *time1 =[array objectAtIndex:1];
                NSString *time2 = strCurrentTime;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH:mm"];
                
                NSDate *date1= [formatter dateFromString:time1];
                NSDate *date2 = [formatter dateFromString:time2];
                
                NSComparisonResult result = [date1 compare:date2];
                if(result == NSOrderedAscending)
                {
                    NSLog(@"date1 is later than date2"); 
                

                
                NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
            
                InOutSeparateManagementEntity *outEntity;
                if(![[APICallManager sharedNetworkSingleton]isNetworkReachable])
                {
                    outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                    if(outEntity==nil)
                    {
                    
                   outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:NO withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                    }
                }
                else
                {
                
                 outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                }
                    
                    
                if(outEntity==nil)
                {
                    outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:NO withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];

                }
                    
                outEntity.outTime=strCurrentTime;
               // [InOutSeparateManagementEntity updateInContext:[AppDelegate context] withInOutSeparateManagementEntity:outEntity];
                [Child updateChild:children.childId inTime:trimmedINString andOutTime:strCurrentTime andRegistryStatus:nil   forContext:[AppDelegate context]];
           
                [cell.btnOUT setTitle:[@"OUT " stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
                cell.btnIN.backgroundColor=   [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
                cell.btnOUT.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
                
                [self.view setUserInteractionEnabled:FALSE];

                [self performSelector:@selector(enableUI) withObject:nil afterDelay:1.5];
                [[APICallManager sharedNetworkSingleton] insertOutTimeRecord];
                }
                else if(result == NSOrderedDescending)
                {
                    [self.view makeToast:@"Left Out Time can not be less than Came in Time" duration:2.0f position:CSToastPositionBottom];
                    [cell.btnOUT setSelected:NO];
                    [cell.btnIN setSelected:YES];
                }
                else
                {
                    
                    
                        NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                        NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                        
                        InOutSeparateManagementEntity *outEntity;
                        if(![[APICallManager sharedNetworkSingleton]isNetworkReachable])
                        {
                            outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:NO withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                        }
                        else
                        {
                            
                            outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                        }
                        if(outEntity==nil)
                        {
                            outEntity=[InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:NO withChildID:children.childId andDateStr:currentDate andInTime:[array objectAtIndex:1]];
                            
                        }
                  
                        
                        outEntity.outTime=strCurrentTime;
                        [InOutSeparateManagementEntity updateInContext:[AppDelegate context] withInOutSeparateManagementEntity:outEntity];
                        [Child updateChild:children.childId inTime:trimmedINString andOutTime:strCurrentTime andRegistryStatus:nil   forContext:[AppDelegate context]];
                        
                        //                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        //                                              children.childId,@"childid",
                        //                                              currentDate,@"date",
                        //                                              [cell.btnIN.titleLabel.text substringFromIndex:cell.btnIN.titleLabel.text.length-5],@"intime",
                        //                                              strCurrentTime,@"outtime",
                        //                                              @"0", @"uploadedflag",
                        //                                              [NSNumber numberWithInteger:diff],@"timedifference",
                        //                                              timeStampObj,@"uniqueTableID",nil];
                        //
                        //                [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:children.childId withDate:currentDate];
                    
                    
                        [cell.btnOUT setTitle:[@"OUT " stringByAppendingString:strCurrentTime] forState:UIControlStateNormal];
                        cell.btnIN.backgroundColor=   [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f];
                        cell.btnOUT.backgroundColor=[UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:187.0/255.0 alpha:1.0f];
                        
                        [self.view setUserInteractionEnabled:FALSE];
                        
                        [self performSelector:@selector(enableUI) withObject:nil afterDelay:1.5];
                        [[APICallManager sharedNetworkSingleton] insertOutTimeRecord];
                    
                }

            }

        }
            break;

        default:
            break;
    }
//         NSString *Date = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
        
               //[[APICallManager sharedNetworkSingleton] fetchAllInOutTime];
    
       }
}


-(void)enableUI
{
    [self.view setUserInteractionEnabled:TRUE];
}

- (IBAction)choosePhotoClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select option"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Gallery", @"Camera", nil];
    CGRect rect=[(UIButton *)sender frame];
    rect.origin.y=rect.origin.y+60;
    rect.origin.x=rect.origin.x+20;
    [actionSheet showFromRect:rect inView:self.view
                animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    switch (buttonIndex) {
        case 0:
        {
            // Open Gallery
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            /*
             *  This operation queue is used so that while opening the camera/gallery if
             *  some other process is going on then it will added to the queue
             */
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Place image picker on the screen
             [self presentViewController:self.picker animated:YES completion:nil];
            
            }];

        }
            break;
        case 1:
        {
            // Open Camera
            
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate = self;
            /*
             *  This operation queue is used so that while opening the camera/gallery if
             *  some other process is going on then it will added to the queue
             */
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Place image picker on the screen
                [self presentViewController:self.picker animated:YES completion:nil];
                
            }];
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UIImagePicker Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
//    if (![mediaType isEqualToString:(NSString *)kUTTypeImageType])
//        return;
    
    self.captureImage= [info objectForKey:UIImagePickerControllerOriginalImage];

//    self.childDetailInfo_ImageView.image = [self scaleImage:[info objectForKey:UIImagePickerControllerOriginalImage] toSize:CGSizeMake(110.0,83.0)];
//    self.childDetailInfo_ImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showAlert];

//    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],currentChildren.photo];
//    [self removeExistingImageName:imagePath withNewImage:self.childDetailInfo_ImageView.image];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (!videoPath && error)
    {
        NSLog(@"Error saving video to saved photos roll: %@, %@", error, [error userInfo]);
        // Handle error;
        return;
    }
    NSLog(@"%@", videoPath);
    
    // Video was saved properly. UI may need to be updated here.
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self.picker dismissViewControllerAnimated:YES completion:nil];
}


-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(void) uploadImageOnServer : (UIImage *) image
{
 
    // Show Progress HUD
    [self.appData showProgressWithMessage:@"Uploading Image"];
    // Compress Image
    NSString *base64 = [self encodeToBase64String:image];
     APICallManager *objManager = [APICallManager sharedNetworkSingleton];
    
    NSString *urlString=[[NSString stringWithFormat:@"%@api/children/",[APICallManager sharedNetworkSingleton].serverURL ] stringByAppendingString:[NSString stringWithFormat:@"%@",currentChildren.childId]];
   
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *inputDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            objManager.apiKey,@"api_key",
                                            objManager.apiPassword,@"api_password",
                                            [NSString stringWithFormat:@"png,%@",base64],@"photo", nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            [self.appData dismissGlobalHUD];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to upload image on the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
            
            return;
        }
      //  NSString *str=[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];

        if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [appDelegate.window makeToast:@"Child's image uploaded Successfully" duration:1.0 position:CSToastPositionCenter];
                NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],[jsonDict objectForKey:@"imagename"]];
                [self removeExistingImageName:imagePath withNewImage:self.childDetailInfo_ImageView.image andName:[jsonDict objectForKey:@"imagename"]];
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.childId==%@",currentChildren.childId];
                NSArray *array= [_childrenListForTableView filteredArrayUsingPredicate:predicate];
                Child *child= [array firstObject];
                child.photo=[jsonDict objectForKey:@"imagename"];
                
                NSMutableArray *mutArray=[NSMutableArray arrayWithArray:_childrenListForTableView];
                NSInteger integer=[_childrenListForTableView indexOfObject:currentChildren];
                [mutArray replaceObjectAtIndex:integer withObject:child];
                
                _childrenListForTableView=mutArray;
                
                [self.collectionViewController reloadData];
                [self.appData dismissGlobalHUD];
                
            });
        }
        else
        {
            
        [appDelegate.window makeToast:@"Unable to upload Image" duration:1.0 position:CSToastPositionCenter];
              [self.appData dismissGlobalHUD];
        }
        // NSString *str=[[NSString alloc] initWithData:data encoding:kNilOptions];
        
    }];
    [postDataTask resume];
}


- (void)removeExistingImageName:(NSString *)fileNamePath withNewImage :(UIImage *) newImage andName:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],currentChildren.photo];
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    //NSError *error;
    //BOOL success = [fileManager removeItemAtPath:fileName error:&error];
//    if (success)
//    {
////        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
////        [removeSuccessFulAlert show];
//        
//        NSLog(@"%@", currentChildren.photo);
//        [self saveImageToLocal:newImage withImageName:fileName];
//    }
//    else
//    {
//        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
//        
//        
//    }
    [self saveImageToLocal:newImage withImageName:fileNamePath andName:name];
}

- (void) saveImageToLocal :(UIImage *) image withImageName :(NSString *) imageNamePath andName:(NSString *)name
{
       NSData *imageData = UIImagePNGRepresentation(image);
      NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:imageNamePath])
    {
     
        if(imageNamePath )
            [imageData writeToFile:imageNamePath atomically:YES];

    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Children/%@",name]]; //Add the file name
        [imageData writeToFile:filePath atomically:YES];
    }
  
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //UIImage *image = imageView.image; // imageView is my image from camera
    
}

-(void) showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eylog" message:@"Would you like to save new image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag= 601;
    alert.delegate= self;
    [alert show];
}


#pragma Mark -
#pragma Mark - Get In/OUT of Registry Table

- (void) getRegistryINOUT
{
    NSString *theStr = [self.array_childIDs componentsJoinedByString:@","];
    NSString *urlString=[NSString stringWithFormat:@"%@api/registry/getAllChildrenRegistry",[APICallManager sharedNetworkSingleton].serverURL ];
     APICallManager *objManager = [APICallManager sharedNetworkSingleton];
    
    if(theStr.length==0)
    {
        self.array_childIDs=[NSMutableArray new];
        if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_ROLE_PRACTITIONER] == NSOrderedSame ) {
            
            if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
            {
                childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId] mutableCopy];
            }
            else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
            {
                childrenList=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:[APICallManager sharedNetworkSingleton].cachePractitioners.groupName] mutableCopy];
            }
            else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
            {
                childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
            }
        }
        else
        {
            childrenList=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
        }

        for (INData *children in childrenList)
        {
            
            [self.array_childIDs addObject:children.childId];
            
        }
        
    }
  //  NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    //NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    // practitionerId,@"practitioner_id",
 //  practitionerPin,@"practitioner_pin",
    theStr = [self.array_childIDs componentsJoinedByString:@","];
    NSDictionary *inputDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     objManager.apiKey,@"api_key",
                                     objManager.apiPassword,@"api_password",
                                      theStr,@"child_id",
                                     [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]], @"date",
                                     nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            Reachability *reachability;
            reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
            if(remoteHostStatus == NotReachable) {
                [self getRegistryINOUT];
                
            }//
            else{
                NSLog(@"Reachable Again Calling Random InOutEntity Upload");
            
                [self getRegistryINOUT];
            }

            
            [self.appData dismissGlobalHUD];
            UIAlertView *alertFail=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get Registry Date from the Server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertFail show];
            [self updateData ];
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@" Response%@", jsonDict);
            //"status":"failure"
            [[NSUserDefaults standardUserDefaults] setObject:@"done" forKey:@"ChildrenNewData"];

            if([[jsonDict objectForKey:@"status"] isEqualToString:@"failure"])
            {
                [self.view makeToast:@"No Registry Data Found"];
               //self.view showToast:<#(UIView *)#> duration:<#(NSTimeInterval)#> position:<#(id)#>
               // [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                for (INData *children in childrenList)
                {
                    
                    [self.array_childIDs addObject:children.childId];
                    
                }
                for(int i =0;i<self.array_childIDs.count;i++)
                {
                    NSNumber *num=[NSNumber numberWithInteger:[[self.array_childIDs objectAtIndex:i] integerValue]];
                    
                  [Child updateChild:num inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:nil   forContext:[AppDelegate context]];
                }
                if ([[APICallManager sharedNetworkSingleton].cachePractitioners.userRole caseInsensitiveCompare:KUSER_ROLE_PRACTITIONER] == NSOrderedSame ) {
                    
                    if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==KeyChildren)
                    {
                        _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId] mutableCopy];
                    }
                    else if ([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==Group)
                    {
                        _childrenListForTableView=[[Child fetchChildInContext:[AppDelegate context] withPractitionerId:[APICallManager sharedNetworkSingleton].cachePractitioners.groupId withPractitionerGroupName:[APICallManager sharedNetworkSingleton].cachePractitioners.groupName] mutableCopy];
                    }
                    else if([APICallManager sharedNetworkSingleton].settingObject.nurseryObservationPolicy==ALL)
                    {
                        _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
                    }
                }
                else
                {
                    _childrenListForTableView=[[Child fetchALLChildInContext:[AppDelegate context]] mutableCopy];
                }
                
                [self.appData dismissGlobalHUD];
                [self.collectionViewController reloadData];
                [self.tableView reloadData];
                
            }
            else
            {
                for (INData *children in childrenList)
                {
                    
                    [self.array_childIDs addObject:children.childId];
                    
                }
                for(int i =0;i<self.array_childIDs.count;i++)
                {
                    NSNumber *num=[NSNumber numberWithInteger:[[self.array_childIDs objectAtIndex:i] integerValue]];
                    
                    [Child updateChild:num inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:nil   forContext:[AppDelegate context]];
                }

                [self updateEveryChild:[jsonDict valueForKey:@"data"]];
                
            }
            [self updateData];
            if(_isRefreshedFromPullToRefresh)
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [refresControl endRefreshing];
                [refresControlTableView endRefreshing];
               [self saveAllChildrenPhotosAtBackground];
                _isRefreshedFromPullToRefresh=NO;
                
            }

          
        });
        
    }];
    [postDataTask resume];
}
-(void)updateChildrenPhotosInBackground
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *aary=[Child fetchALLChildInContext:[AppDelegate context]];
        
        for(int i= 0;i<aary.count;i++)
        {
            Child *chiild=[aary objectAtIndex:i];
            
            BOOL isDirectory = NO;
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:[Utils getChildrenImages] isDirectory:&isDirectory];
            if (directoryExists) {
                //NSLog(@"isDirectory: %d", isDirectory);
            } else {
                NSError *error = nil;
                BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[Utils getChildrenImages] withIntermediateDirectories:NO attributes:nil error:&error];
                if (!success) {
                    NSLog(@"Failed to create directory with error: %@", [error description]);
                }
            }
            
            
            NSString *filePath = [[Utils getChildrenImages] stringByAppendingPathComponent:chiild.photo];
            BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            
            
            NSError *error = nil;
            if (fileExistsAtPath) {
                [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
                
            }
                NSURL *url;
                url=[NSURL URLWithString:chiild.photourl];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                  [self.collectionViewController reloadItemsAtIndexPaths:[NSMutableArray arrayWithObjects:[NSIndexPath indexPathForItem:i inSection:0], nil]];
            });
            
          
           
            
            if(i== aary.count-1)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"completed" forKey:@"PhotoChild"];
                
            }
            
        }
        
        
    });
    

}

-(void) updateEveryChild :(NSDictionary *) inputDictionary
{
    
    NSArray *tempArray = [inputDictionary allKeys];
    
    for (int i=0; i<[tempArray count]; i++)
    {
        NSDictionary *registryCout = [inputDictionary valueForKey:tempArray[i]];
        NSInteger inte=[tempArray[i] integerValue];
        
        NSNumber *num=[NSNumber numberWithInteger:inte];
        
//        [Child updateRegistryArrayForChild:num :[NSMutableArray arrayWithArray:registryCout]  forContext:[AppDelegate context]];
//        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSMutableArray arrayWithArray:registryCout],[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]], nil];
//        [Child updateDictionaryDataForInoutTime:dictionary :num forContext:[AppDelegate context]];
        
//        
//        if (registryCout)
//        {
//            if(registryCout.count>0)
//            {
//            NSDictionary *childDict = [registryCout lastObject];
//            if(childDict.count>0&&[childDict valueForKey:@"came_in_at"]!=nil&&[childDict valueForKey:@"left_at"]!=nil)
//            {
//            [Child updateChild:tempArray[i] inTime:[childDict valueForKey:@"came_in_at"] andOutTime:[childDict valueForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
//                
//                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//                [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
//                NSString *string = [dateFormatter2 stringFromDate:[NSDate date]];
//                
//            [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:childDict forChild:num withDate:string];
//            }
//            }
//            
//        }
        
        if (registryCout)
        {
            if(registryCout.count>0)
            {
                NSDictionary *childDict = [NSDictionary dictionaryWithDictionary:registryCout] ;
                if(childDict.count>0&&[childDict valueForKey:@"came_in_at"]!=nil&&[childDict valueForKey:@"left_at"]!=nil)
                {
                    NSString *leftAtStr= [childDict objectForKey:@"left_at"];
                    NSString *cameINStr=[childDict objectForKey:@"came_in_at"];
                    
                    if ([[childDict objectForKey:@"registry_status"] integerValue]!=0)
                    {
                        
                        [Child updateChild:num inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:[NSNumber numberWithInteger:[[childDict objectForKey:@"registry_status"] integerValue]]  forContext:[AppDelegate context]];
                    }
                    else
                    {
                        
                        if(cameINStr.length>0&& leftAtStr.length>0 )
                        {
                            [Child updateChild:num inTime:[childDict objectForKey:@"came_in_at"] andOutTime:[childDict objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
                            
                            //                                NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
                            //                                NSNumber *num=[NSNumber numberWithInteger:[uniqueTabletOIID integerValue]] ;
                            //
                            //                                [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]] withDate:nil withChildId:num withInTime:[childDict objectForKey:@"came_in_at"] withOutTime:[childDict objectForKey:@"left_at"] withisInUploaded:YES withIsOutUploaded:YES withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[childDict objectForKey:@"clienttimestamp"]];
                        }
                        if(cameINStr.length>0&& (leftAtStr.length==0||[leftAtStr isEqualToString:@"00:00"]))
                            
                        {
                            [Child updateChild:num inTime:[childDict objectForKey:@"came_in_at"] andOutTime:@"" andRegistryStatus:nil  forContext:[AppDelegate context]];
                            
                            NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                            NSNumber *unique=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                            
                            [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:unique withDateStr:[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]] withDate:nil withChildId:num withInTime:[childDict objectForKey:@"came_in_at"] withOutTime:@"00:00" withisInUploaded:YES withIsOutUploaded:NO withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[childDict objectForKey:@"clienttimestamp"]];
                        }
                        
                    }
                    
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
                    NSString *string = [dateFormatter2 stringFromDate:[NSDate date]];
                    
                    [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:childDict forChild:num withDate:string];
                }
            }
            
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self closeAlert];
        
        [self.appData dismissGlobalHUD];
        [self.collectionViewController reloadData];
        // code here
    });
   
    //[self.tableView reloadData];
    
}

@end
