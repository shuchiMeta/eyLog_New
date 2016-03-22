//
//  EYFSAssessmentViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYFSAssessmentViewController.h"
#import "Eyfs.h"
#import "Aspect.h"
#import "AppDelegate.h"
#import "Age.h"
#import "Statement.h"
#import "EyfsDetailTableViewCell.h"
#import "Framework.h"
#import "Assessment.h"
#import "APICallManager.h"
#import "Utils.h"
#import "EYLAgeBand.h"
#import "DZNSegmentedControl.h"
#import "EYFSCollectionCell.h"

@interface EYFSAssessmentViewController ()<UITableViewDataSource,UITableViewDelegate, DZNSegmentedControlDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    DZNSegmentedControl *segmentedControl;
    DZNSegmentedControl  * segmentedControlELG;
    
    NSArray *eyfsArray;
    NSMutableDictionary *aspectDictionary;
    NSMutableDictionary * tempAgeDict;
    NSMutableDictionary * tempStatementDict;

    NSNumber *currentAspectIdentifier;
    NSArray *ageArray;
    NSMutableDictionary *statementDictionary;
    NSArray *assessmentsArray;
    NSIndexPath *selectedIndexPath;
    NSIndexPath *lastPathIndex;

    NSMutableDictionary *currentAssessmentDictionary;
    NSMutableDictionary *currentAssessmentColorDictionary;
    NSArray * assesmentArray;
    NSMutableArray * ageBandAssesmentArray;

    NSDictionary * segControlAgeDict;
    NSMutableArray * currentAssesmentArray;
     NSMutableArray * currentAssesmentUpdatedArray;
    NSNumber *lastSelectedChildForEyfsAssesment;
}
@property (strong, nonatomic) IBOutlet DZNSegmentedControl *ageSegmentControl;
@property (strong, nonatomic) IBOutlet DZNSegmentedControl *ageColorControl;
@property (strong, nonatomic, readwrite) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UIButton *currentAssessmentButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) BOOL showAssessment;
@property (strong, nonatomic) NSMutableArray * tempArray;
@property (strong, nonatomic) UILabel *assessmentSelectionLabel;
@property (strong, nonatomic) IBOutlet UICollectionView * collectionView;
@end

@implementation EYFSAssessmentViewController

-(NSMutableArray *)selectedList
{
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}
-(NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [self.selectedList mutableCopy];
    }
    return _tempArray;
}
-(NSMutableArray *)selectedAgeBandAssessmentList
{
    if (!_selectedAgeBandAssessmentList) {
        _selectedAgeBandAssessmentList = [NSMutableArray array];
    }
    return _selectedAgeBandAssessmentList;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)ageBandAssesmentArrayData{

    if (self.selectedAgeBandAssessmentList.count == 0) {
        for (OBEyfs * obEyfs in self.selectedList) {
            Assessment * assesment = [[Assessment fetchAssessmentInContext:[AppDelegate context] withLevelValue:obEyfs.assessmentLevel] firstObject];
            Age * age = [[Age fetchAgeInContext:[AppDelegate context] withAgeStart:assesment.ageStart withAgeEnd:assesment.ageEnd] firstObject];
            if (age) {
                EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
                eylAgeBand.ageIdentifier = age.ageIdentifier;
                eylAgeBand.levelNumber = obEyfs.assessmentLevel;
                NSArray *colors = [assesment.color componentsSeparatedByString:@","];
                UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                eylAgeBand.backgroundColor = color;
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
                NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
                if (array.count == 0) {
                    [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
                }
            }
        }
    }
}

-(void)addCollectionView{

    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EYFSCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"EYFSCollectionCellID"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView reloadData];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EYFSCollectionCellID" forIndexPath:indexPath];
    Age *age = [ageArray objectAtIndex:indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
    EYLAgeBand *eylageBandSeg = [[self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate] firstObject];
    EYLAgeBand *eylageBand;
    NSArray * tempArray;
    if (self.showAssessment) {
       predicate = [NSPredicate predicateWithFormat:@"SELF.ageIdentifier == %@ AND SELF.levelNumber == %@",age.ageIdentifier.stringValue,[[NSNumber numberWithInt:3]stringValue]];

        tempArray = [currentAssesmentUpdatedArray filteredArrayUsingPredicate:predicate];
        if (!eylageBandSeg) {
          eylageBand = [tempArray firstObject];

        }
    }
    
    if (eylageBandSeg) {
        if (eylageBandSeg && eylageBandSeg.levelNumber.integerValue != 0) {
                cell.backgroundColor = eylageBandSeg.backgroundColor;
        }
        else{
            if (tempArray.count>0) {
                eylageBand=[tempArray firstObject];
                cell.backgroundColor=eylageBand.rgbColor;
            }else{
                cell.backgroundColor = [UIColor whiteColor];}
        }

    }else{
        if (eylageBand && eylageBand.levelNumber.integerValue != 0) {
            if (self.showAssessment) {
                cell.backgroundColor=eylageBand.rgbColor;
            }else{
                cell.backgroundColor = eylageBand.backgroundColor;
            }
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
        }

        
    }
   
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    CGFloat autosizedWidth = CGRectGetWidth(segmentedControl.bounds);
    // iOS7 only?!
    autosizedWidth -= (segmentedControl.numberOfSegments - 1); // ignore the 1pt. borders between segments
    
    CGFloat width = 0.0;
    NSInteger numberOfAutosizedSegmentes = 0;
    NSMutableArray *segmentWidths = [NSMutableArray arrayWithCapacity:segmentedControl.numberOfSegments];
    for (NSInteger i = 0; i < segmentedControl.numberOfSegments; i++) {
        width =segmentedControl.width/segmentedControl.numberOfSegments;
        if (width == 0.0f) {
            // auto sized
            numberOfAutosizedSegmentes++;
            [segmentWidths addObject:[NSNull null]];
        }
        else {
            // manually sized
            autosizedWidth -= width;
            [segmentWidths addObject:@(width)];
        }
    }

     width = self.collectionView.frame.size.width / ageArray.count;
    NSLog(@"width %f",width);
    return CGSizeMake(width, 10.0f);
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
  

    self.showAssessment = NO;
    self.assessmentSelectionLabel =[[UILabel alloc] initWithFrame:CGRectMake(290, 110, 95, 29)];
    self.assessmentSelectionLabel.layer.borderColor = [yellowColor CGColor];
    self.assessmentSelectionLabel.layer.borderWidth = 1.0f;
    self.assessmentSelectionLabel.layer.cornerRadius = 4;
    self.assessmentSelectionLabel.clipsToBounds = YES;
    self.assessmentSelectionLabel.textAlignment = NSTextAlignmentCenter;
    self.assessmentSelectionLabel.font = [UIFont systemFontOfSize:15];
    [self.assessmentSelectionLabel setHidden:YES];
    [self.view addSubview:self.assessmentSelectionLabel];
    aspectDictionary=[[NSMutableDictionary alloc]init];
    tempAgeDict = [[NSMutableDictionary alloc]init];
    tempStatementDict = [[NSMutableDictionary alloc]init];
     eyfsArray=[Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:@"EYFS"];
    for(Eyfs *eyfs in eyfsArray)
    {
        NSArray *aspectArray=[Aspect fetchAspectInContext:[AppDelegate context] withAreaIdentifier:eyfs.areaIdentifier withFrameWork:@"EYFS"];
        for (Aspect * aspect in aspectArray) {
            NSArray *tempAgeArray = [Age fetchAgeInContext:[AppDelegate context] withAspectIdentifier:aspect.aspectIdentifier withFrameWork:NSStringFromClass([Eyfs class])];
            if (tempAgeArray) {
                [tempAgeDict setObject:tempAgeArray forKey:aspect.aspectIdentifier];
                for (Age * age in tempAgeArray) {
                    NSArray * tempStatementArray = [Statement fetchStatementInContext:[AppDelegate context] withAgeIdentifier:age.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])];
                    if (tempStatementArray) {
                        [tempStatementDict setObject:tempStatementArray forKey:age.ageIdentifier];
                    }
                }
            }
        }
        [aspectDictionary setObject:aspectArray forKey:eyfs.areaIdentifier];
    }

    NSArray *aspectArray=[aspectDictionary objectForKey:((Eyfs *)[eyfsArray objectAtIndex:0]).areaIdentifier];

    currentAspectIdentifier=((Aspect *)aspectArray[0]).aspectIdentifier;

    [self getDataForDetailTable];

    [self addAgeSegmentView:ageArray];
    Age *initialAge = ageArray[0];

    assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:initialAge.ageStart withEndAge:initialAge.ageEnd];

    if (!segmentedControl && !_isFromNextSteps) {
        segmentedControl=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"None",((Assessment *)assessmentsArray[0]).levelDescription, ((Assessment *)assessmentsArray[1]).levelDescription, ((Assessment *)assessmentsArray[2]).levelDescription, nil]];
    }
    segmentedControl.frame = CGRectMake(395, 110, 345, 29);
    segmentedControl.showsCount = NO;
    segmentedControl.isAgeBand = NO;
//    segmentedControl.tintColor = [UIColor colorWithRed:0 green: blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
    segmentedControl.selectionIndicatorHeight = 4;
    segmentedControl.lineColor = yellowColor;
    segmentedControl.backgroundColor = yellowColor;
    [segmentedControl setSelectedBackGroundColor:yellowColor];
    segmentedControl.hairlineColor = [UIColor clearColor];

    for (NSInteger idx = 0; idx < assessmentsArray.count; idx++) {
        Assessment *assesment = [assessmentsArray objectAtIndex:idx];
        [segmentedControl setTintColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
        [segmentedControl setTitle:assesment.levelDescription forSegmentAtIndex:idx+1];
        [segmentedControl setSelectedBarColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
    }

    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.borderColor = [yellowColor CGColor];
    segmentedControl.clipsToBounds = YES;
    segmentedControl.layer.cornerRadius = 4;

    UIButton *button = [[segmentedControl buttons] firstObject];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [segmentedControl setSelectedBarColor:[UIColor darkGrayColor] forSegmentAtIndex:0];

    self.doneButton.layer.cornerRadius = 10.0f;
    self.closeButton.layer.cornerRadius = 10.0f;

    [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EyfsDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:eyfsDetailTableViewCellId];
//    self.detailTableView.tableHeaderView=segmentedControl;
    if (!_isFromNextSteps) {
        [self.view addSubview:segmentedControl];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedELG"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // logic to check if the current selected child id is the same as child id for which assements were fetched earlier and doing the work accordingly
    if(lastSelectedChildForEyfsAssesment && [APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
    {
        if(![lastSelectedChildForEyfsAssesment isEqualToNumber:[APICallManager sharedNetworkSingleton].cacheChild.childId])
        {
            self.showAssessment = NO;
            currentAssesmentArray = nil;
            [_currentAssessmentButton setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
            [self.currentAssessmentButton setUserInteractionEnabled:YES];
            [self.assessmentSelectionLabel setHidden:YES];
            [self.currentAssessmentButton setHidden:NO];
            [self reloadTableData];
        }
    }

    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        lastSelectedChildForEyfsAssesment = nil;
        self.showAssessment = NO;
        [self.currentAssessmentButton setUserInteractionEnabled:NO];
        [self.assessmentSelectionLabel setHidden:YES];
        [self.currentAssessmentButton setHidden:YES];
        [self reloadTableData];
    }
    else
    {
        [self.currentAssessmentButton setUserInteractionEnabled:YES];
        [self.currentAssessmentButton setHidden:NO];
        self.currentAssessmentButton.layer.borderColor=[UIColor grayColor].CGColor;
        self.currentAssessmentButton.layer.borderWidth=1.0f;
        self.currentAssessmentButton.layer.cornerRadius=4.5f;
    }

    if (_showAssessment) {
        [_currentAssessmentButton setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [self.assessmentSelectionLabel setHidden:NO];
    }
    else{
        [_currentAssessmentButton setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        [self.assessmentSelectionLabel setHidden:YES];
    }
}

-(void)addAgeSegmentView:(NSArray *)array{

    NSMutableArray * items = [NSMutableArray array];
    for (Age *age in array) {
      
//        if ( [age.ageDesc rangeOfString:@"months"].location != NSNotFound) {
//            NSString *new=[age.ageDesc stringByReplacingOccurrencesOfString:@"months" withString:@""];
//           
//            [items addObject:new];
//        }
//        else
//        {
        
        if([age.ageDesc isEqualToString:@"ELG"])
        {
            if ([APICallManager sharedNetworkSingleton].settingObject.elg)
            {
                [items addObject:age.ageDesc];
            }
            
        }
        else
        {
            [items addObject:age.ageDesc];
        }

       // }
        
//        NSString *str = [NSString stringWithFormat:@"%@-%@",age.ageStart,age.ageEnd];
//        if ([age.ageEnd isEqualToNumber:@(60)] && ![age.ageStart isEqualToNumber:age.ageEnd]){
//            str = [NSString stringWithFormat:@"%@+",str];
//        }
//        else if ([age.ageStart isEqualToNumber:age.ageEnd]) {
//            str = @"ELG";
//        }
    }
    
//    if(self.ageColorControl)
//    {
//        [self.ageColorControl  removeFromSuperview];
//    }
//
//    self.ageColorControl = [[DZNSegmentedControl alloc]initWithItems:items];
//    self.ageColorControl.showsCount = NO;
//    self.ageColorControl.isAgeBand = NO;
//    self.ageColorControl.frame = CGRectMake(290, 92, 448, 10);
//    self.ageColorControl.tintColor = [UIColor clearColor];
//    self.ageColorControl.backgroundColor=[UIColor whiteColor];
//    self.ageColorControl.lineColor = [UIColor clearColor];
//    self.ageColorControl.backgroundColor = yellowColor;
//    [self.ageColorControl setSelectedBackGroundColor:yellowColor];
//    self.ageColorControl.hairlineColor = [UIColor clearColor];
//    self.ageColorControl.layer.borderWidth = 1.0f;
//    self.ageColorControl.layer.borderColor = [yellowColor CGColor];
//    self.ageColorControl.clipsToBounds = YES;
//    self.ageColorControl.layer.cornerRadius = 2;



    // Edited by Ankit Khetrapal
    // so that everytime we create a new segment controller the previous one is cleared
    if(self.ageSegmentControl)
    {
        [self.ageSegmentControl removeFromSuperview];
    }
    // once the older one is deleted create a new one
    //if (!self.ageSegmentControl) {
        self.ageSegmentControl=[[DZNSegmentedControl alloc]initWithItems:items];
        self.ageSegmentControl.showsCount = NO;
        self.ageSegmentControl.isAgeBand = YES;
        self.ageSegmentControl.frame = CGRectMake(290, 64, 448, 29);
        self.ageSegmentControl.tintColor = [UIColor whiteColor];
        self.ageSegmentControl.backgroundColor=[UIColor whiteColor];
        self.ageSegmentControl.lineColor = yellowColor;
    
        self.ageSegmentControl.backgroundColor = yellowColor;
        [self.ageSegmentControl setSelectedBackGroundColor:yellowColor];
        self.ageSegmentControl.hairlineColor = [UIColor clearColor];
        [self.ageSegmentControl addTarget:self action:@selector(ageSegment:) forControlEvents:UIControlEventValueChanged];
        self.ageSegmentControl.layer.borderWidth = 1.0f;
        self.ageSegmentControl.layer.borderColor = [yellowColor CGColor];
        self.ageSegmentControl.clipsToBounds = YES;
        self.ageSegmentControl.layer.cornerRadius = 4;
    //}
    [self.view addSubview:self.ageSegmentControl];

    //[self.view addSubview:self.ageColorControl];
    self.ageSegmentControl.selectedSegmentIndex = 0;
    Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
    [self updateSegmentControl:age];
    [self updateEmergingSegmentControl:nil withAge:age];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addCollectionView];  
    segControlAgeDict = [NSMutableDictionary dictionary];
    self.ageSegmentControl.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
    segmentedControl.frame = CGRectMake(self.ageSegmentControl.frame.size.width-60, 110, 345, 29);
    
    [self.collectionView reloadData];
  
    [self ageBandAssesmentArrayData];
    [self.ageSegmentControl layoutSubviews];
   
    
    [segmentedControl layoutSubviews];
   // [segmentedControlELG removeFromSuperview];
    
    [self setSegmentControlColor];


}
- (IBAction)ageSegment:(id)sender
{
    if(_isFromNextSteps)
    {
        self.ageSegmentControl.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
        segmentedControl.frame = CGRectMake(self.ageSegmentControl.frame.size.width-60, 110, 345, 29);
        //self.collectionView.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
        
        Age *age = ageArray[self.ageSegmentControl.selectedSegmentIndex];
        [self updateSegmentControl:age];
        [self updateEmergingSegmentControl:nil withAge:age];
        
        [self.detailTableView reloadData];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
        NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
        if (array.count > 0) {
            return;
        }
        EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
        eylAgeBand.ageIdentifier = age.ageIdentifier;
        eylAgeBand.levelNumber = @(0);
        [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
        [self.collectionView reloadData];

    }
    else
    {
    
     self.ageSegmentControl.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
      segmentedControl.frame = CGRectMake(self.ageSegmentControl.frame.size.width-60, 110, 345, 29);
    self.collectionView.translatesAutoresizingMaskIntoConstraints=YES;
     self.collectionView.frame = CGRectMake(self.ageSegmentControl.frame.origin.x, self.ageSegmentControl.frame.origin.y+29 , self.ageSegmentControl.frame.size.width, 5);
    
    Age *age = ageArray[self.ageSegmentControl.selectedSegmentIndex];
    
    if([age.ageStart integerValue]==60 &[age.ageEnd integerValue]==60)
    {
        if(self.tempArray.count>0)
        {
        
            NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF.ageIdentifier==%@",age.ageIdentifier];
            
            NSArray *new=[self.tempArray filteredArrayUsingPredicate:pred];
            OBEyfs *eyfs;
            if(new.count>0)
            {
            eyfs=[new firstObject];
            }
            
            NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.statementIdentifier.intValue == %d",[eyfs.frameworkItemId intValue]];
            NSArray *selected=[statementArray filteredArrayUsingPredicate:predicate];
            
        
            NSInteger inte;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedELG"];
           if(selected.count>0)
            {
            
            inte=[statementArray indexOfObject:selected[0]];
                
            if(inte==0)
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"first" forKey:@"selectedELG"];
                
            }
            
            else if (inte==1)
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"second" forKey:@"selectedELG"];

            }
               }
            
//            NSUInteger index = [statementArray  indexOfObjectPassingTest:^(Statement *obj, NSUInteger idx, BOOL *stop) {
//                return [predicate evaluateWithObject:obj];
//            }];
            
            
            
            // [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"selectedELG"];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedELG"]isEqualToString:@"second"])
            {
                
               if(segmentedControlELG==nil)
               {
                   assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                   
                   NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[2],nil];
                   [segmentedControl removeFromSuperview];
                   segmentedControl=nil;
                   
                   segmentedControlELG=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                   //[NSArray arrayWithObjects:@"",((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                   
                   
                   segmentedControlELG.frame = CGRectMake(self.view.frame.size.width-130, 110, 100, 29);
                   
                   Assessment *asses=assessmentsArray[2];
                   NSArray *colors = [asses.color componentsSeparatedByString:@","];
                   UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                   
                   segmentedControlELG.isAgeBand=NO;
                   segmentedControlELG.showsCount=NO;
                   segmentedControlELG.layer.borderWidth = 1.0f;
                   segmentedControlELG.layer.borderColor = [yellowColor CGColor];
                   segmentedControlELG.clipsToBounds = YES;
                   segmentedControlELG.layer.cornerRadius = 4;
                   segmentedControlELG.selectionIndicatorHeight = 4;
                   segmentedControlELG.lineColor = yellowColor;
                   segmentedControlELG.backgroundColor = yellowColor;
                   [segmentedControlELG setSelectedBackGroundColor:yellowColor];
                   segmentedControlELG.hairlineColor = [UIColor clearColor];
                   
                   [segmentedControlELG layoutSubviews];
                   [segmentedControlELG setBackgroundColor:color];
                   [segmentedControlELG setTintColor:color];
                   [segmentedControlELG setTitleColor:color forState:UIControlStateNormal];
                   
                   
                   UIButton *btn=[[segmentedControlELG buttons] firstObject];
                   [btn setBackgroundColor:color];
                   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                   btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                   btn.titleLabel.textColor=[UIColor whiteColor];
                 
                   EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
                   eylAgeBand.ageIdentifier = age.ageIdentifier;
                   eylAgeBand.levelNumber = asses.levelValue;
                   //   NSArray *colors = [assessment.color componentsSeparatedByString:@","];
                   //   UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                   eylAgeBand.backgroundColor = color;
                   [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
                   [self.collectionView reloadData];
                   
                   //if (!_isFromNextSteps) {
                       [self.view addSubview:segmentedControlELG];
                  // }
                   
                   
               }
                [segmentedControlELG setHidden:NO];
                [segmentedControl removeFromSuperview];
                segmentedControl=nil;


        }
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedELG"]isEqualToString:@"first"])
            {
        
                assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                [segmentedControl removeFromSuperview];
                [segmentedControlELG removeFromSuperview];
                NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[0],assessmentsArray[1],nil];
                
                segmentedControl=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"None",((Assessment *)assessmentsArray[0]).levelDescription, ((Assessment *)assessmentsArray[1]).levelDescription, nil]];
                segmentedControl.frame = CGRectMake(395, 110, 345, 29);
                segmentedControl.showsCount = NO;
                segmentedControl.isAgeBand = NO;
                //    segmentedControl.tintColor = [UIColor colorWithRed:0 green: blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
                segmentedControl.selectionIndicatorHeight = 4;
                segmentedControl.lineColor = yellowColor;
                segmentedControl.backgroundColor = yellowColor;
                [segmentedControl setSelectedBackGroundColor:yellowColor];
                segmentedControl.hairlineColor = [UIColor clearColor];
                
                
                for (NSInteger idx = 0; idx < newArray.count; idx++) {
                    Assessment *assesment = [newArray objectAtIndex:idx];
                    [segmentedControl setTintColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                    [segmentedControl setTitle:assesment.levelDescription forSegmentAtIndex:idx+1];
                    [segmentedControl setSelectedBarColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                }
                
                segmentedControl.layer.borderWidth = 1.0f;
                segmentedControl.layer.borderColor = [yellowColor CGColor];
                segmentedControl.clipsToBounds = YES;
                segmentedControl.layer.cornerRadius = 4;
                
                UIButton *button = [[segmentedControl buttons] firstObject];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
                [segmentedControl setSelectedBarColor:[UIColor darkGrayColor] forSegmentAtIndex:0];
                
                self.doneButton.layer.cornerRadius = 10.0f;
                self.closeButton.layer.cornerRadius = 10.0f;
                
                [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
                [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EyfsDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:eyfsDetailTableViewCellId];
                //    self.detailTableView.tableHeaderView=segmentedControl;
                //if (!_isFromNextSteps) {
                    [self.view addSubview:segmentedControl];
                //}

                
            }
            else
            {
                [segmentedControlELG setHidden:YES];
                
                [segmentedControl removeFromSuperview];
                segmentedControl=nil;
            
            }

    
        
        }
        else
        {
            [segmentedControlELG setHidden:NO];
            
            [segmentedControl removeFromSuperview];
            segmentedControl=nil;


        }
        
        
        
    }
    else
    {
        [segmentedControlELG setHidden:YES];
         [segmentedControl removeFromSuperview];
         segmentedControl=nil;
        
        [self updateSegmentControl:age];
      
    }
    [self updateEmergingSegmentControl:nil withAge:age];
    

    [self.detailTableView reloadData];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
    NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        return;
    }
    EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
    eylAgeBand.ageIdentifier = age.ageIdentifier;
    eylAgeBand.levelNumber = @(0);
    [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
    [self.collectionView reloadData];
    }
}
-(void)updateSegmentControl:(Age *)age{
    
    assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
    
    if (!segmentedControl) {
        segmentedControl=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"None",((Assessment *)assessmentsArray[0]).levelDescription, ((Assessment *)assessmentsArray[1]).levelDescription, ((Assessment *)assessmentsArray[2]).levelDescription, nil]];
    }
    segmentedControl.frame = CGRectMake(395, 110, 345, 29);
    segmentedControl.showsCount = NO;
    segmentedControl.isAgeBand = NO;
    //    segmentedControl.tintColor = [UIColor colorWithRed:0 green: blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
    segmentedControl.selectionIndicatorHeight = 4;
    segmentedControl.lineColor = yellowColor;
    segmentedControl.backgroundColor = yellowColor;
    [segmentedControl setSelectedBackGroundColor:yellowColor];
    segmentedControl.hairlineColor = [UIColor clearColor];
    for (NSInteger idx = 0; idx < assessmentsArray.count; idx++) {
        NSLog(@"%d",idx);
        
        Assessment *assesment = [assessmentsArray objectAtIndex:idx];
        [segmentedControl setTitle:assesment.levelDescription forSegmentAtIndex:idx+1];
        [segmentedControl setSelectedBarColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
    }
    [self resetSegmentControl];

    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.borderColor = [yellowColor CGColor];
    segmentedControl.clipsToBounds = YES;
    segmentedControl.layer.cornerRadius = 4;

    UIButton *button = [[segmentedControl buttons] firstObject];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [segmentedControl setSelectedBarColor:[UIColor darkGrayColor] forSegmentAtIndex:0];

    for (int i=0; i<assessmentsArray.count; i++) {
        Assessment *assessment = assessmentsArray[i];
        [segmentedControl setTitle:assessment.levelDescription forSegmentAtIndex:i+1];
    }
    [segmentedControl setTitle:@"None" forSegmentAtIndex:0];
    self.ageSegmentControl.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
      segmentedControl.frame = CGRectMake(self.ageSegmentControl.frame.size.width-60, 110, 345, 29);
     [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
    //self.collectionView.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
    self.collectionView.translatesAutoresizingMaskIntoConstraints=YES;
    self.collectionView.frame = CGRectMake(self.ageSegmentControl.frame.origin.x, self.ageSegmentControl.frame.origin.y+29 , self.ageSegmentControl.frame.size.width, 5);
   if(![segmentedControl isDescendantOfView:self.view])
   {
       [self.view addSubview:segmentedControl];
       
   }
    
}
-(void)updateAgeSegmentControl:(Statement *)statement withAge:(Age *)agee{
    
    int i =0;
    for (Age * age in ageArray) {
        if ([age.ageIdentifier isEqualToNumber:agee.ageIdentifier]) {
            self.ageSegmentControl.selectedSegmentIndex = i;
            break;
        }
        i++;
    }
}
-(void)updateEmergingSegmentControl:(OBEyfs *)obEyfs withAge:(Age *)age{

    [segmentedControl setTintColor:yellowColor forSegmentAtIndex:0];
    NSArray * assesmentArry = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
    int i =0;
    NSInteger selectedSegmentIndex = 0;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
    NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
    EYLAgeBand * eylAgeBand = [array firstObject];
    Assessment *selecteAssessment = nil;
    for (Assessment * assesment in assesmentArry) {
        if ((eylAgeBand.levelNumber.integerValue  == assesment.levelValue.integerValue) && array.count != 0) {
            [segControlAgeDict setValue:@"YES" forKey:[NSString stringWithFormat:@"%@",age.ageIdentifier]];
            selectedSegmentIndex = i +1;
            selecteAssessment = assesment;
            break;
        }
        else{
            selectedSegmentIndex = 0;
        }
        i++;
    }
    segmentedControl.selectedSegmentIndex = selectedSegmentIndex;
    [segmentedControl setNeedsDisplay];
    [self.assessmentSelectionLabel setNeedsDisplay];
    if (segmentedControl.selectedSegmentIndex >0)
    {
    [self setSegmentControlColorForSelectedSegmentIndex];
    }
     self.ageSegmentControl.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
      segmentedControl.frame = CGRectMake(self.ageSegmentControl.frame.size.width-60, 110, 345, 29);
    //self.collectionView.frame = CGRectMake(290, 64, self.view.frame.size.width-300, 29);
    self.collectionView.translatesAutoresizingMaskIntoConstraints=YES;
    self.collectionView.frame = CGRectMake(self.ageSegmentControl.frame.origin.x, self.ageSegmentControl.frame.origin.y+29 , self.ageSegmentControl.frame.size.width, 5);

}

-(void)getDataForDetailTable
{
    ageArray=[Age fetchAgeInContext:[AppDelegate context] withAspectIdentifier:currentAspectIdentifier withFrameWork:NSStringFromClass([Eyfs class])];
    [self addAgeSegmentView:ageArray];
    statementDictionary=[[NSMutableDictionary alloc]init];
    for (Age *age in ageArray)
    {
        NSArray *statementArray=[Statement fetchStatementInContext:[AppDelegate context] withAgeIdentifier:age.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])];
        [statementDictionary setObject:statementArray forKey:age.ageIdentifier];
    }

}
-(void)resetSegmentControl{
    for (int i = 0; i < segmentedControl.numberOfSegments; i++) {
        [segmentedControl setTintColor:[UIColor whiteColor] forSegmentAtIndex:i];
    }
    if (segmentedControl.selectedSegmentIndex == 0) {
        [segmentedControl setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    }
    else{
        [segmentedControl setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
}
-(void)setSegmentControlColor{
    Age *age = ageArray[self.ageSegmentControl.selectedSegmentIndex];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
    EYLAgeBand *ageBand = [[self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate] firstObject];
    if (ageBand && ageBand.levelNumber != 0) {
        NSArray * array = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
        Assessment *assessment = [[Assessment fetchAssessmentInContext:[AppDelegate context] withLevelValue:ageBand.levelNumber] firstObject];
        if ([array containsObject:assessment]) {
            NSInteger index = [array indexOfObject:assessment];
            NSArray *colors = [assessment.color componentsSeparatedByString:@","];
            UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
            if (segmentedControl) {
                [segmentedControl setTintColor:color forSegmentAtIndex:index+1];
            }
        }
    }
}
-(void)setSegmentControlColorForSelectedSegmentIndex{
    Assessment *assessment = assessmentsArray[segmentedControl.selectedSegmentIndex -1];
    NSArray *colors = [assessment.color componentsSeparatedByString:@","];
    UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
    [self resetSegmentControl];
    [segmentedControl setTintColor:color forSegmentAtIndex:segmentedControl.selectedSegmentIndex];
}
-(void)segmentedControlHasChangedValue:(DZNSegmentedControl *)sender
{
    [segmentedControl setTitle:@"None" forSegmentAtIndex:0];
    UIButton *button = [[segmentedControl buttons] firstObject];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button setNeedsDisplay];
    Age *age = ageArray[self.ageSegmentControl.selectedSegmentIndex];

    if (segmentedControl.selectedSegmentIndex == 0) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
        NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
        if (array.count > 0) {
            EYLAgeBand * ageBand = [array firstObject];
          //  [self updateOBEyfsObject:ageBand withAssesment:nil];
            ageBand.levelNumber = @(0);
        }
        [self resetSegmentControl];
        [segmentedControl setTintColor:yellowColor forSegmentAtIndex:segmentedControl.selectedSegmentIndex];
        [self.collectionView reloadData];
        NSLog(@"self.selectedAgeBandAssessmentList %@",self.selectedAgeBandAssessmentList);
        return;
    }

    assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
    Assessment *assessment = assessmentsArray[segmentedControl.selectedSegmentIndex -1];
    NSArray *colors = [assessment.color componentsSeparatedByString:@","];
    UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
    [self resetSegmentControl];
    [segmentedControl setTintColor:color forSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
    NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.selectedAgeBandAssessmentList removeObjectsInArray:array];
    }
    EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
    eylAgeBand.ageIdentifier = age.ageIdentifier;
    eylAgeBand.levelNumber = assessment.levelValue;
//   NSArray *colors = [assessment.color componentsSeparatedByString:@","];
//   UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
    eylAgeBand.backgroundColor = color;
    [self.selectedAgeBandAssessmentList addObject:eylAgeBand];

    NSLog(@"self.selectedAgeBandAssessmentList %@",self.selectedAgeBandAssessmentList);
    [self.collectionView reloadData];

}
-(void)updateOBEyfsObject:(EYLAgeBand *)ageBand withAssesment:(Assessment *)assesment{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assessmentLevel == %@",ageBand.levelNumber];
    NSArray * array = [self.selectedList filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        OBEyfs * obEyfs = [array firstObject];
        if (assesment == nil) {
            obEyfs.assessmentLevel = @(0);
        }
        else{
            obEyfs.assessmentLevel = assesment.levelValue;
        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag==1)
    {
        return eyfsArray.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        Eyfs *eyfs=[eyfsArray objectAtIndex:section];
        return ((NSArray *)[aspectDictionary objectForKey:eyfs.areaIdentifier]).count;
    }
    else
    {
        Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
        NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
        return statementArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
    {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.numberOfLines=2;

        Eyfs *eyfs=[eyfsArray objectAtIndex:indexPath.section];
        NSArray *aspectArray=[aspectDictionary objectForKey:eyfs.areaIdentifier];
        Aspect *aspect =[aspectArray objectAtIndex:indexPath.row];
        NSArray * tempAgeArray = [tempAgeDict objectForKey:aspect.aspectIdentifier];

        BOOL isSelected = NO;
        cell.textLabel.text=aspect.aspectDesc;

        if (!selectedIndexPath) {
            if (indexPath.row == 0 && indexPath.section == 0) {
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 22,10, 22,22)];
                imv.image=[UIImage imageNamed:@"right_arrow.png"];
                [cell addSubview:imv];
                cell.accessoryView = nil;
                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else if ([selectedIndexPath isEqual:indexPath]){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 22,10, 22,22)];
            imv.image=[UIImage imageNamed:@"right_arrow.png"];
            [cell addSubview:imv];

            cell.accessoryView = nil;
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryView = nil;

        }
        if([selectedIndexPath isEqual: indexPath])
        {
            cell.contentView.backgroundColor=yellowColor;

            return cell;
        }
        else
        {
            cell.contentView.backgroundColor=[UIColor clearColor];

        }

        for (Age * age in tempAgeArray)
        {
            NSArray *selectedDataArray = [self.selectedAgeBandAssessmentList valueForKeyPath:@"ageIdentifier"];
            __block NSPredicate *compoundPredicate = nil;
            [selectedDataArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@", obj];
                if (compoundPredicate) {
                    compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[compoundPredicate,predicate]];
                }else {
                    compoundPredicate = predicate;
                }
            }];

            NSArray * tempStatementArray = [tempStatementDict objectForKey:age.ageIdentifier];

            if (compoundPredicate) {
                tempStatementArray = [tempStatementArray filteredArrayUsingPredicate:compoundPredicate];
                if (tempStatementArray.count >0) {
                    cell.contentView.backgroundColor=yellowColor;
                    isSelected = YES;
                    break;
                }
                else
                {
                    cell.contentView.backgroundColor=[UIColor clearColor];
                }
            }
            else{
                break;
            }

                    }
        
        
        for (Age * age in tempAgeArray)
        {
     NSArray * tempStatementArray = [tempStatementDict objectForKey:age.ageIdentifier];
        for (Statement * atatement in tempStatementArray)
        {
            if (self.tempArray.count > 0) {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",atatement.statementIdentifier];
                NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
                if (array.count > 0) {
                     cell.contentView.backgroundColor=yellowColor;
                    }
                
              
            }
            else{
                cell.contentView.backgroundColor=[UIColor clearColor];
            }
        }
        if (isSelected) {
            break;
        }
        }


        if (self.tempArray.count == 0 && indexPath.row == 0 && indexPath.section == 0 && !selectedIndexPath) {
            cell.contentView.backgroundColor=yellowColor;
        }
        if (indexPath.row == 0 && indexPath.section == 0 && !selectedIndexPath) {
            cell.contentView.backgroundColor=yellowColor;
        }
    return cell;
    }
    else if(tableView.tag==2)
    {
        EyfsDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:eyfsDetailTableViewCellId forIndexPath:indexPath];

        cell.isSelected=NO;
        Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
        NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
        Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];

        cell.statementTextView.text=statementObject.statementDesc;
        cell.statementTextView.font=[UIFont systemFontOfSize:15.0f];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier];
        NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
        if (array.count == 0) {
            predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier.stringValue];
            array = [self.tempArray filteredArrayUsingPredicate:predicate];
        }
        if (array.count > 0) {
            cell.isSelected=YES;
            
            [self updateAgeSegmentControl:statementObject withAge:age];
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        }
        else{
            cell.isSelected=NO;
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        }
        
        if([age.ageStart integerValue]==60 &[age.ageEnd integerValue]==60)
        {
           if((indexPath.row==0) &cell.isSelected)
              {
                  [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"selectedELG"];
                  
              }
            if((indexPath.row==1)&cell.isSelected)
            {
             [[NSUserDefaults standardUserDefaults] setObject:@"second" forKey:@"selectedELG"];
            }
        }
        
        if (![segControlAgeDict valueForKey:[NSString stringWithFormat:@"%@",age.ageIdentifier]]) {
            [self updateEmergingSegmentControl:(OBEyfs *)[array firstObject] withAge:age];
        }
        cell.selectButton.userInteractionEnabled = NO;

        if(self.isFromNextSteps) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier];
            NSArray * array = [self.tmpSelectedArray filteredArrayUsingPredicate:predicate];
            if (array.count > 0) {
                [self updateAgeSegmentControl:statementObject withAge:age];
                cell.countDisplayLabel.text =@"1";
                cell.countDisplayLabel.layer.cornerRadius= 20.0f;
                cell.countDisplayLabel.layer.backgroundColor=  [yellowColor CGColor];
            }
            else{
                cell.countDisplayLabel.text =@"";
                cell.countDisplayLabel.layer.cornerRadius= 20.0f;
                cell.countDisplayLabel.layer.backgroundColor=  [UIColor clearColor].CGColor;
            }
        }

        
        if (self.showAssessment && currentAssessmentDictionary.count>0) {

            [self showAssesmentSelectionLabelWithAge:age withIndexpath:indexPath];

            NSNumber *count = [currentAssessmentDictionary objectForKey:statementObject.statementIdentifier.stringValue];
            NSLog(@"%@",count);
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier];
            NSArray * array = [self.tmpSelectedArray filteredArrayUsingPredicate:predicate];
            if (array.count>0) {
                count=[NSNumber numberWithInt:([count  integerValue]+[[NSNumber numberWithInt:1] integerValue])];
            }
            
            cell.countDisplayLabel.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
            if (count > 0) {
                cell.countDisplayLabel.layer.cornerRadius= 20.0f;
                // changing default color to yellow from green
                cell.countDisplayLabel.layer.backgroundColor=  [yellowColor CGColor];// [UIColor greenColor].CGColor;// [Utils colorFromHexString:[currentAssessmentColorDictionary objectForKey:statementObject.statementIdentifier.stringValue]].CGColor;

                // To show background color as per the input from the server
                //                cell.countDisplayLabel.layer.backgroundColor=  [[Utils colorFromHexString:[currentAssessmentColorDictionary objectForKey:statementObject.statementIdentifier.stringValue]] CGColor];
            }
            else{
                cell.countDisplayLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
            }
        }
        else
        {
            if (self.isFromNextSteps) {
                
            }else{
                self.assessmentSelectionLabel.text = @"None";
                cell.countDisplayLabel.text = @"";
                cell.countDisplayLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
            }
           
        }

       
        return cell;
    }
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
        [label setFont:[UIFont boldSystemFontOfSize:18]];
        label.numberOfLines=2;

        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        Eyfs *eyfs=[eyfsArray objectAtIndex:section];
        [label setText:eyfs.areaDesc];
        [view addSubview:label];

        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        return 44;
    }else {
        static UITextView *heightTextView = nil;
        if (!heightTextView) {
            heightTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        }
        double wirdthOrHeight = 0.0f;
        heightTextView.font = [UIFont systemFontOfSize:15];
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            wirdthOrHeight = 709;
        }else {
            wirdthOrHeight = 440;
        }

        [heightTextView setFrame:CGRectMake(0, 0, wirdthOrHeight - 120, 0)];
        Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
        NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
        Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];
        heightTextView.text = statementObject.statementDesc;

        CGSize heightSize = [heightTextView sizeThatFits:CGSizeMake(wirdthOrHeight - 120, CGFLOAT_MAX)];
        if (heightSize.height <= 50) {
            return 68;
        }else{
            return heightSize.height+14;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView.tag==1)
    {
        if(_isFromNextSteps)
        {
            selectedIndexPath=indexPath;
            [self.tableView reloadData];
            
            Eyfs *eyfs=[eyfsArray objectAtIndex:indexPath.section];
            NSArray *aspectArray=[aspectDictionary objectForKey:eyfs.areaIdentifier];
            Aspect *aspect =[aspectArray objectAtIndex:indexPath.row];
            currentAspectIdentifier=aspect.aspectIdentifier;
            [self getDataForDetailTable];
            [self.detailTableView reloadData];
            [self.collectionView reloadData];
            [self setSegmentControlColor];
        
        }
        else
        {
        [segmentedControlELG setHidden:YES];
        [segmentedControl removeFromSuperview];
        [segmentedControlELG removeFromSuperview];
        segmentedControl=nil;
        segmentedControlELG=nil;
        selectedIndexPath=indexPath;
        [self.tableView reloadData];

        Eyfs *eyfs=[eyfsArray objectAtIndex:indexPath.section];
        NSArray *aspectArray=[aspectDictionary objectForKey:eyfs.areaIdentifier];
        Aspect *aspect =[aspectArray objectAtIndex:indexPath.row];
        currentAspectIdentifier=aspect.aspectIdentifier;
        
        [self getDataForDetailTable];
        [self.detailTableView reloadData];
        [self.collectionView reloadData];
      
         Age *age = ageArray[self.ageSegmentControl.selectedSegmentIndex];
        [self updateSegmentControl:age];
        [self setSegmentControlColor];
        }
    }
    else if (tableView.tag==2)
    {
        
        if(_isFromNextSteps)
        {
            EyfsDetailTableViewCell *cell = (EyfsDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if(cell.isSelected)
            {
                cell.isSelected=NO;
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                
                Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
                NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
                Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier];
                NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
                if (array.count == 0) {
                    predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier.stringValue];
                    array = [self.tempArray filteredArrayUsingPredicate:predicate];
                }
                [self.tempArray removeObjectsInArray:array];
            }
            else
            {
                cell.isSelected=YES;
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
                NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
                Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];
                OBEyfs * obEyfs = [[OBEyfs alloc]init];
                obEyfs.frameworkItemId = statementObject.statementIdentifier;
                NSArray * array = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                if (segmentedControl.selectedSegmentIndex >0) {
                    Assessment * asses = array[segmentedControl.selectedSegmentIndex -1];
                    obEyfs.assessmentLevel = asses.levelValue;
                }
                else{
                    obEyfs.assessmentLevel = @(0);
                }
                [self.tempArray addObject:obEyfs];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        
        }
        else
        {
        EyfsDetailTableViewCell *cell = (EyfsDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        Age *age=[ageArray objectAtIndex:self.ageSegmentControl.selectedSegmentIndex];
        
        if(cell.isSelected)
        {
            cell.isSelected=NO;
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];

         
            NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
            Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];

            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier];
            NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
            if (array.count == 0) {
                predicate = [NSPredicate predicateWithFormat:@"frameworkItemId == %@",statementObject.statementIdentifier.stringValue];
                array = [self.tempArray filteredArrayUsingPredicate:predicate];
            }
            [self.tempArray removeObjectsInArray:array];
            
            if([age.ageStart integerValue]==60 && [age.ageEnd integerValue]==60)
            {
                [segmentedControlELG removeFromSuperview];
                [segmentedControl removeFromSuperview];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",age.ageIdentifier];
                NSArray * array = [self.selectedAgeBandAssessmentList filteredArrayUsingPredicate:predicate];
                if (array.count > 0) {
                    [self.selectedAgeBandAssessmentList removeObjectsInArray:array];
                }
                
            }
        }
        else
        {
            BOOL iscellSelected;
          
            if([age.ageStart integerValue]==60 && [age.ageEnd integerValue]==60)
            {
                if(self.tempArray.count>0)
                {
                    NSArray *aspectarray=[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"];
                    Aspect *aspect=[aspectarray firstObject];
                    NSPredicate *newPred=[NSPredicate predicateWithFormat:@"SELF.age.aspectIdentifier.intValue==%d",[aspect.aspectIdentifier intValue]];
                 
                    NSArray *final=[self.tempArray filteredArrayUsingPredicate:newPred];
                    if(final.count>0)
                    {
                        
                        iscellSelected=NO;
                    }
                    else
                    {
                    
                        if(indexPath.row==0)
                        {
                            assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                            [segmentedControl removeFromSuperview];
                                 [segmentedControlELG removeFromSuperview];
                            NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[0],assessmentsArray[1],nil];
                            
                            segmentedControl=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"None",((Assessment *)assessmentsArray[0]).levelDescription, ((Assessment *)assessmentsArray[1]).levelDescription, nil]];
                            segmentedControl.frame = CGRectMake(395, 110, 345, 29);
                            segmentedControl.showsCount = NO;
                            segmentedControl.isAgeBand = NO;
                            //    segmentedControl.tintColor = [UIColor colorWithRed:0 green: blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
                            segmentedControl.selectionIndicatorHeight = 4;
                            segmentedControl.lineColor = yellowColor;
                            segmentedControl.backgroundColor = yellowColor;
                            [segmentedControl setSelectedBackGroundColor:yellowColor];
                            segmentedControl.hairlineColor = [UIColor clearColor];
                        
                            
                            for (NSInteger idx = 0; idx < newArray.count; idx++) {
                                Assessment *assesment = [newArray objectAtIndex:idx];
                                [segmentedControl setTintColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                                [segmentedControl setTitle:assesment.levelDescription forSegmentAtIndex:idx+1];
                                [segmentedControl setSelectedBarColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                            }
                            
                            segmentedControl.layer.borderWidth = 1.0f;
                            segmentedControl.layer.borderColor = [yellowColor CGColor];
                            segmentedControl.clipsToBounds = YES;
                            segmentedControl.layer.cornerRadius = 4;
                            
                            UIButton *button = [[segmentedControl buttons] firstObject];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
                            [segmentedControl setSelectedBarColor:[UIColor darkGrayColor] forSegmentAtIndex:0];
                            
                            self.doneButton.layer.cornerRadius = 10.0f;
                            self.closeButton.layer.cornerRadius = 10.0f;
                            
                            [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
                            [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EyfsDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:eyfsDetailTableViewCellId];
                            //    self.detailTableView.tableHeaderView=segmentedControl;
                           // if (!_isFromNextSteps) {
                                [self.view addSubview:segmentedControl];
                           // }
                            
                            
                        }
                        else if(indexPath.row==1)
                        {
                           
                            assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                            
                            NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[2],nil];
                            [segmentedControl removeFromSuperview];
                            segmentedControl=nil;
                            
                            
                            segmentedControlELG=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                            //[NSArray arrayWithObjects:@"",((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                            
                            
                            segmentedControlELG.frame = CGRectMake(self.view.frame.size.width-130, 110, 100, 29);

                            Assessment *asses=assessmentsArray[2];
                            NSArray *colors = [asses.color componentsSeparatedByString:@","];
                            UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                            
                            segmentedControlELG.isAgeBand=NO;
                            segmentedControlELG.showsCount=NO;
                            segmentedControlELG.layer.borderWidth = 1.0f;
                            segmentedControlELG.layer.borderColor = [yellowColor CGColor];
                            segmentedControlELG.clipsToBounds = YES;
                            segmentedControlELG.layer.cornerRadius = 4;
                            segmentedControlELG.selectionIndicatorHeight = 4;
                            segmentedControlELG.lineColor = yellowColor;
                            segmentedControlELG.backgroundColor = yellowColor;
                            [segmentedControlELG setSelectedBackGroundColor:yellowColor];
                            segmentedControlELG.hairlineColor = [UIColor clearColor];
                            
                            [segmentedControlELG layoutSubviews];
                           
                            [segmentedControlELG setBackgroundColor:color];
                            [segmentedControlELG setTintColor:color];
                            [segmentedControlELG setTitleColor:color forState:UIControlStateNormal];
                            
                            
                            UIButton *btn=[[segmentedControlELG buttons] firstObject];
                            [btn setBackgroundColor:color];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                            btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                            btn.titleLabel.textColor=[UIColor whiteColor];
                            
                           // if (!_isFromNextSteps) {
                                [self.view addSubview:segmentedControlELG];
                            //}
                            EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
                            eylAgeBand.ageIdentifier = age.ageIdentifier;
                            eylAgeBand.levelNumber = asses.levelValue;
                            //   NSArray *colors = [assessment.color componentsSeparatedByString:@","];
                            //   UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                            eylAgeBand.backgroundColor = color;
                            [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
                            NSMutableArray *aray=[self.selectedAgeBandAssessmentList mutableCopy];
                            
                            for(EYLAgeBand *eyl in aray)
                            {
                                if([eyl.levelNumber integerValue]==0)
                                {
                                    [self.selectedAgeBandAssessmentList removeObject:eyl];
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        iscellSelected=YES;
                        
                    }
                    
                }
                else
                {
                    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF.ageIdentifier==%@",age.ageIdentifier];
                    
                    NSArray *new=[self.tempArray filteredArrayUsingPredicate:pred];
                    
                    if(new.count>0)
                    {
                        iscellSelected= NO;
                        
                    }
                    else
                    {
                        
                        if(indexPath.row==0)
                        {
                            assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                            [segmentedControl removeFromSuperview];
                            [segmentedControlELG removeFromSuperview];
                            
                               NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[0],assessmentsArray[1],nil];
                            segmentedControl=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"None",((Assessment *)assessmentsArray[0]).levelDescription, ((Assessment *)assessmentsArray[1]).levelDescription, nil]];
                            segmentedControl.frame = CGRectMake(395, 110, 345, 29);
                            segmentedControl.showsCount = NO;
                            segmentedControl.isAgeBand = NO;
                            //    segmentedControl.tintColor = [UIColor colorWithRed:0 green: blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
                            segmentedControl.selectionIndicatorHeight = 4;
                            segmentedControl.lineColor = yellowColor;
                            segmentedControl.backgroundColor = yellowColor;
                            [segmentedControl setSelectedBackGroundColor:yellowColor];
                            segmentedControl.hairlineColor = [UIColor clearColor];
                            
                            for (NSInteger idx = 0; idx < newArray.count; idx++) {
                                Assessment *assesment = [newArray objectAtIndex:idx];
                                [segmentedControl setTintColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                                [segmentedControl setTitle:assesment.levelDescription forSegmentAtIndex:idx+1];
                                [segmentedControl setSelectedBarColor:[UIColor whiteColor] forSegmentAtIndex:idx+1];
                            }
                            
                            segmentedControl.layer.borderWidth = 1.0f;
                            segmentedControl.layer.borderColor = [yellowColor CGColor];
                            segmentedControl.clipsToBounds = YES;
                            segmentedControl.layer.cornerRadius = 4;
                            
                            UIButton *button = [[segmentedControl buttons] firstObject];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
                            [segmentedControl setSelectedBarColor:[UIColor darkGrayColor] forSegmentAtIndex:0];
                            
                            self.doneButton.layer.cornerRadius = 10.0f;
                            self.closeButton.layer.cornerRadius = 10.0f;
                            
                            [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
                            [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([EyfsDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:eyfsDetailTableViewCellId];
                            //    self.detailTableView.tableHeaderView=segmentedControl;
                            //if (!_isFromNextSteps) {
                                [self.view addSubview:segmentedControl];
                            //}
                            
                            
                        }
                        else if(indexPath.row==1)
                        {
                            assessmentsArray = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                            
                            NSArray *newArray=[NSArray arrayWithObjects:assessmentsArray[2],nil];
                            [segmentedControl removeFromSuperview];
                            segmentedControl=nil;

                           
                            segmentedControlELG=[[DZNSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                                //[NSArray arrayWithObjects:@"",((Assessment *)assessmentsArray[2]).levelDescription,nil]];
                            segmentedControlELG.frame = CGRectMake(self.view.frame.size.width-130, 110, 100, 29);
                            Assessment *asses=assessmentsArray[2];
                            NSArray *colors = [asses.color componentsSeparatedByString:@","];
                            UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                            
                            segmentedControlELG.isAgeBand=NO;
                            segmentedControlELG.showsCount=NO;
                            segmentedControlELG.layer.borderWidth = 1.0f;
                            segmentedControlELG.layer.borderColor = [yellowColor CGColor];
                            segmentedControlELG.clipsToBounds = YES;
                            segmentedControlELG.layer.cornerRadius = 4;
                            segmentedControlELG.selectionIndicatorHeight = 4;
                            segmentedControlELG.lineColor = yellowColor;
                            segmentedControlELG.backgroundColor = yellowColor;
                            [segmentedControlELG setSelectedBackGroundColor:yellowColor];
                            segmentedControlELG.hairlineColor = [UIColor clearColor];
                            [segmentedControlELG layoutSubviews];

                            
                            [segmentedControlELG setBackgroundColor:color];
                            [segmentedControlELG setTintColor:color];
                            [segmentedControlELG setTitleColor:color forState:UIControlStateNormal];
                            
                            
                            UIButton *btn=[[segmentedControlELG buttons] firstObject];
                            [btn setBackgroundColor:color];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                            btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
                            btn.titleLabel.textColor=[UIColor whiteColor];
                            
                            //if (!_isFromNextSteps) {
                            [self.view addSubview:segmentedControlELG];
                            //}
                            EYLAgeBand * eylAgeBand = [[EYLAgeBand alloc]init];
                            eylAgeBand.ageIdentifier = age.ageIdentifier;
                            eylAgeBand.levelNumber = asses.levelValue;
                            //   NSArray *colors = [assessment.color componentsSeparatedByString:@","];
                            //   UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
                            eylAgeBand.backgroundColor = color;
                            [self.selectedAgeBandAssessmentList addObject:eylAgeBand];
                            NSMutableArray *aray=[self.selectedAgeBandAssessmentList mutableCopy];
                            
                            for(EYLAgeBand *eyl in aray)
                            {
                            if([eyl.levelNumber integerValue]==0)
                            {
                                [self.selectedAgeBandAssessmentList removeObject:eyl];
                                
                            }
                                
                                
                            }
                            
                        }
                        

                        iscellSelected=YES;
                        
                    }

                    
                }
//
          }
            else
            {
                 [segmentedControlELG removeFromSuperview];
                
                if(self.tempArray.count>0)
                {
                    NSInteger ageStart=60;
                    NSInteger ageEnd=60;
                   NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF.age.ageStart==%d AND SELF.age.ageEnd==%d AND SELF.age.aspectIdentifier.intValue==%d",ageStart,ageEnd,[age.aspectIdentifier intValue]];
                   NSArray *new=[self.tempArray filteredArrayUsingPredicate:pred];
                    if(new.count>0)
                    {
                     iscellSelected= NO;
                    }
                    else
                    {
                        iscellSelected=YES;

                    }
                    
                    
                }
                else
                {
                    iscellSelected=YES;

                }

                
            }
            if(iscellSelected)
            {
                
                // ((Assessment *)assessmentsArray[2]).levelDescription
            
            cell.isSelected=YES;
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
            NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
            Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];
            OBEyfs * obEyfs = [[OBEyfs alloc]init];
            obEyfs.frameworkItemId = statementObject.statementIdentifier;
            obEyfs.age=age;
                NSArray *arry=[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"];
                obEyfs.aspect=[arry firstObject];
                
            NSArray * array = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];
                
                if(segmentedControl==nil)
                {
                
                    //if (segmentedControlELG.selectedSegmentIndex >0) {
                        Assessment * asses = array[segmentedControl.selectedSegmentIndex];
                        obEyfs.assessmentLevel = asses.levelValue;
                    
                    
                    
                }
                else
                {
                    if (segmentedControl.selectedSegmentIndex >0) {
                        Assessment * asses = array[segmentedControl.selectedSegmentIndex -1];
                        obEyfs.assessmentLevel = asses.levelValue;
                    }
                    else{
                        obEyfs.assessmentLevel = @(0);
                    }
                }
            
               
                
            [self.tempArray addObject:obEyfs];
            }
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
    }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
    {

    }
}

- (IBAction)doneAction:(id)sender
{
//    self.selectedList = nil;
    
    if(segmentedControl)
    {
    [segmentedControlELG removeFromSuperview];
    }
    
    self.selectedList = self.tempArray;

    for (EYLAgeBand *eylAgeBand in self.selectedAgeBandAssessmentList) {
        for (OBEyfs *obEyfs in self.selectedList) {
            if (eylAgeBand.levelNumber.integerValue == 0) {
                if (obEyfs.frameworkItemId.integerValue == eylAgeBand.ageIdentifier.integerValue) {
                    [self.selectedList removeObject:obEyfs];
                    break;
                }
            }
            else if (eylAgeBand.ageIdentifier.integerValue == obEyfs.frameworkItemId.integerValue){
                [self.selectedList removeObject:obEyfs];
                break;
            }
        }
    }
    NSMutableArray *removedArray = [NSMutableArray array];
    for (EYLAgeBand *eylAgeBand in self.selectedAgeBandAssessmentList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",eylAgeBand.ageIdentifier];
        NSArray *array = [self.selectedList filteredArrayUsingPredicate:predicate];
        if (array.count == 0 && eylAgeBand.levelNumber.integerValue == 0) {
            [removedArray addObject:eylAgeBand];
        }
    }
    [self.selectedAgeBandAssessmentList removeObjectsInArray:removedArray];
    [self.delegate doneButtonAction:sender];
}

- (IBAction)closeAction:(id)sender
{
    if(segmentedControl)
    {
    [segmentedControlELG removeFromSuperview];
    }
    selectedIndexPath = nil;
    [self.tempArray removeAllObjects];
    self.tempArray = nil;

    Eyfs *eyfs=[eyfsArray objectAtIndex:0];
    NSArray *aspectArray=[aspectDictionary objectForKey:eyfs.areaIdentifier];
    Aspect *aspect =[aspectArray objectAtIndex:0];
    currentAspectIdentifier=aspect.aspectIdentifier;
    //[self getDataForDetailTable];

    [self.delegate closeButtonAction:sender];
}

- (IBAction)showCurrentAssessment:(id)sender {

    _showAssessment = !_showAssessment;

    if (_showAssessment) {
        currentAssesmentArray = [NSMutableArray array];
        currentAssesmentUpdatedArray=[NSMutableArray array];
        
        [_currentAssessmentButton setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [_collectionView reloadData];
    }
    else{
        currentAssesmentArray = nil;
        currentAssesmentUpdatedArray=nil;
        
        [_currentAssessmentButton setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        [self.assessmentSelectionLabel setHidden:YES];
        [self reloadTableData];
        [_collectionView reloadData];
        return;
    }

    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;

    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading..";

    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;

    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/current_assessments",serverURL];

    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"eyfs",@"type",childID,@"child_id",nil];

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

                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                              lastSelectedChildForEyfsAssesment = childID;
                                              [self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                          }];

    [postDataTask resume];
}

-(void)closeAlert
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


+ (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];

    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];

    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}
-(void)backgroundLoadData:(NSData *)data
{
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", json[@"data"]);
    if([json[@"status"] isEqualToString:@"success"])
    {
        currentAssessmentDictionary = [[NSMutableDictionary alloc] init];
        currentAssessmentColorDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in json[@"data"]) {
            [currentAssessmentDictionary setObject:dict[@"selected_count"] forKey:dict[@"framework_item_id"]];

            Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:dict[@"framework_item_id"] withFrameWork:@"Eyfs"] firstObject];

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",statement.ageIdentifier];
            NSArray * array = [currentAssesmentArray filteredArrayUsingPredicate:predicate];
            if (array.count == 0 && statement) {
                NSString *colorString = @"";
                if (dict[@"color"] != [NSNull null]) {
                    colorString = dict[@"color"];
                    UIColor *color = [[self class] colorWithHexString:colorString];
                    CGColorRef colorRef = [color CGColor];

                    int numComponents = CGColorGetNumberOfComponents(colorRef);
                    UIColor *rgbColor = nil;
                    if (numComponents == 4)
                    {
                        const CGFloat *components = CGColorGetComponents(colorRef);
                        CGFloat red = components[0]*255.0f;
                        CGFloat green = components[1]*255.0f;
                        CGFloat blue = components[2]*255.0f;
                        CGFloat alpha = components[3];
                        rgbColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
                    }
                    EYLAgeBand *eylAgeBand = [[EYLAgeBand alloc]init];
                    eylAgeBand.ageIdentifier = statement.ageIdentifier;
                    eylAgeBand.levelNumber = dict[@"level_number"];
                    eylAgeBand.rgbColor = rgbColor;
                    [currentAssesmentArray addObject:eylAgeBand];
                    
                    
                }
                else{
                }
            }
               NSString *colorString1 = @"";
            if (dict[@"color"] != [NSNull null]) {
                colorString1 = dict[@"color"];
                UIColor *color = [[self class] colorWithHexString:colorString1];
                CGColorRef colorRef1 = [color CGColor];
                
                int numComponents = CGColorGetNumberOfComponents(colorRef1);
                UIColor *rgbColor = nil;
                if (numComponents == 4)
                {
                    const CGFloat *components = CGColorGetComponents(colorRef1);
                    CGFloat red = components[0]*255.0f;
                    CGFloat green = components[1]*255.0f;
                    CGFloat blue = components[2]*255.0f;
                    CGFloat alpha = components[3];
                    rgbColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
                }

            EYLAgeBand *eylAgeBand = [[EYLAgeBand alloc]init];
            eylAgeBand.ageIdentifier = dict[@"framework_item_id"];
            eylAgeBand.levelNumber = dict[@"level_number"];
            eylAgeBand.rgbColor = rgbColor;
            [currentAssesmentUpdatedArray addObject:eylAgeBand];
            }

            if (dict[@"color"] != [NSNull null]) {
                [currentAssessmentColorDictionary setObject:dict[@"color"] forKey:dict[@"framework_item_id"]];
            }
            else
            {
                [currentAssessmentColorDictionary setObject:@"#ffffff00" forKey:dict[@"framework_item_id"]];
            }
        }
        NSLog(@"%@", currentAssessmentDictionary);
        NSLog(@"%@", currentAssessmentColorDictionary);

        [self.detailTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assessmentSelectionLabel setHidden:NO];
            [self.collectionView reloadData];
        });
    }
}


-(void)reloadTableData{
    [self.tableView reloadData];
    [self.detailTableView reloadData];
}
-(void)showAssesmentSelectionLabelWithAge:(Age *)age withIndexpath:(NSIndexPath *)indexPath
{
     NSArray *statementArray=[statementDictionary objectForKey:age.ageIdentifier];
    Statement *statementObject=(Statement *)[statementArray objectAtIndex:indexPath.row];
    NSArray * assesmentArry = [Assessment fetchAssessmentInContext:[AppDelegate context] withStartAge:age.ageStart withEndAge:age.ageEnd];

    self.assessmentSelectionLabel.textColor = [UIColor darkGrayColor];
    //AND levelNumber == %d
    //SELF.name contains[c] %@
    //[[NSNumber numberWithInt:3] intValue]
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.ageIdentifier == %@ AND SELF.levelNumber == %@",age.ageIdentifier.stringValue,[[NSNumber numberWithInt:3]stringValue]];
    NSArray * array = [currentAssesmentUpdatedArray filteredArrayUsingPredicate:predicate];
    EYLAgeBand * eylAgeBand = [array firstObject];
    for (Assessment * assesment in assesmentArry) {
        NSArray *colors = [assesment.color componentsSeparatedByString:@","];
        UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
        if ([eylAgeBand.rgbColor isEqual:color]) {
            self.assessmentSelectionLabel.text = assesment.levelDescription;
            self.assessmentSelectionLabel.backgroundColor = color;
            break;
        }
        else{
            self.assessmentSelectionLabel.text = @"None";
            self.assessmentSelectionLabel.backgroundColor = [UIColor whiteColor];

        }
    }
    [self.collectionView reloadData];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

- (void) orientationChanged:(NSNotification *)note
{
    
    UIDevice * device = note.object;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    segmentedControlELG.frame = CGRectMake(screenRect.size.width-130, 110, 100, 29);
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
    [self reloadTableData];
    
    
}


@end
