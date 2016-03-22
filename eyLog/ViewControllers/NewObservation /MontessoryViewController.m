//
//  MontessoryViewController.m
//  eyLog
//
//  Created by Shobhit on 20/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryViewController.h"
#import "MontessoriFramework.h"
#import "AppDelegate.h"
#import "Montessori.h"
#import "LevelOne.h"
#import "LevelTwo.h"
#import "LevelThree.h"
#import "LevelFour.h"
#import "MontessoriAssesmentDataBase.h"
#import "DZNSegmentedControl.h"
#import "MBProgressHUD.h"
#import "MontessoryBand.h"
#import "APICallManager.h"
#import "OBMontessori.h"
#import "MontessoryPopUpTableController.h"

@interface MontessoryViewController () <montessoryPopUpTabel,UITableViewDelegate,UITableViewDataSource,WYPopoverControllerDelegate,DZNSegmentedControlDelegate,assesmentPopoverDelegate,UIGestureRecognizerDelegate>
{
    NSIndexPath *selectedIndexPath;
    NSMutableDictionary *levelOneDataDictionary;

    NSMutableDictionary *levelThreeDataDictionary;
    NSMutableDictionary *levelFourDataDictionary;
    NSNumber *currentLevelTwoIdentifier;
    NSArray *levelThreeArray;
    NSArray *levelTwoArray;
    NSArray *levelFourArray;
    NSArray *assesmentMontessoryArray;
    NSArray *segmemntControlArray;
    NSMutableArray * currentMontessoryAssesmentArray;
    NSNumber *lastSelectedChildForMontessoriAssesment;
    NSMutableDictionary *currentMontessoriAssesmentDictionary;
    NSMutableDictionary *currentMontessoriColorAssesmentDictionary;
    NSString *segValue;
    NSMutableArray *color;
    NSArray *montessoryDetailTableViewArray;
   // NSMutableDictionary *savedAssesmentValues;
    //NSMutableArray *assesmentValues;
    NSArray *assesmentPrperties;
    NSIndexPath  * assesmentselectedIndexPath;
    BOOL isMontessoryHeaderBtnAssesmentSelected;
    NSInteger headerAssesmentSection;
}
@property (strong, nonatomic) IBOutlet DZNSegmentedControl *levelThreeSegmentControl;
@property (nonatomic, assign) BOOL showMontessoryAssessment;
@property(atomic,strong) NSMutableDictionary *levelTwoDataDictionary;
@property(atomic,strong) NSMutableDictionary *levelFDataDictionary;
@property (strong, nonatomic) NSMutableArray * tempArray;
@property (strong, nonatomic) NSArray * masterTableData;
@property (strong, nonatomic) NSArray * detailTableData;

@end

@implementation MontessoryViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];


//    MBProgressHUD *hud=[MBProgressHUD  showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText= @"Loading...";


    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MontessoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:montessoryTableCellId];
    levelOneDataDictionary = [NSMutableDictionary dictionary];
     _levelTwoDataDictionary = [NSMutableDictionary dictionary];
     levelThreeDataDictionary = [NSMutableDictionary dictionary];
    levelFourDataDictionary = [NSMutableDictionary dictionary];

    assesmentPrperties=[[NSArray alloc]init];
    color=[[NSMutableArray alloc]init];
    //savedAssesmentValues=[[NSMutableDictionary alloc]init];

    _masterTableData = [NSArray array];
    self.sagmentController.selectedSegmentIndex=1;
    segValue=@"3-6";


    NSArray *level2Array = [_levelTwoDataDictionary objectForKey:((Montessori *)[self.montessoriArray objectAtIndex:0]).levelOneIdentifier];
    currentLevelTwoIdentifier = ((LevelTwo *)level2Array[0]).levelTwoIdentifier;

    _masterTableData = [NSArray array];
    _detailTableData = [NSArray array];
    assesmentMontessoryArray = [MontessoriAssesmentDataBase fetchAllMontessoriAssessmentInContext:[AppDelegate context] ];
    _btnCancel.layer.cornerRadius=5;
    _btnCancel.layer.masksToBounds=true;
    _btnDone.layer.cornerRadius=5;
    _btnDone.layer.masksToBounds=true;

   
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        [self.showCurrentAssesment setUserInteractionEnabled:NO];
        [self.showCurrentAssesment setHidden:YES];
    }
    else
    {
        [self.showCurrentAssesment setUserInteractionEnabled:YES];
        [self.showCurrentAssesment setHidden:NO];
        self.showCurrentAssesment.layer.borderColor=[UIColor grayColor].CGColor;
        self.showCurrentAssesment.layer.borderWidth=1.0f;
        self.showCurrentAssesment.layer.cornerRadius=4.5f;
    }

    // Showing age segment according to setting
    
    if ([APICallManager sharedNetworkSingleton].settingObject.montesoori_enable_Zero_to_three==DISABLE_ZERO_TO_3) {
        self.btnZeroToSix.layer.cornerRadius=8.f;
        
    }else{
        self.btnZeroToSix.hidden=true;
        self.btnZeroToSix.userInteractionEnabled=false;
    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(lastSelectedChildForMontessoriAssesment && [APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
    {
        if(![lastSelectedChildForMontessoriAssesment isEqualToNumber:[APICallManager sharedNetworkSingleton].cacheChild.childId])
        {
            self.showMontessoryAssessment = NO;
            currentMontessoryAssesmentArray = nil;
            [_showCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
            [self.showCurrentAssesment setUserInteractionEnabled:YES];
            //[self.assessmentSelectionLabel setHidden:YES];
            [self.showCurrentAssesment setHidden:NO];
            [self reloadTableData];
        }
    }

    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        lastSelectedChildForMontessoriAssesment = nil;
        self.showMontessoryAssessment = NO;
        [self.showCurrentAssesment setUserInteractionEnabled:NO];
       // [self.assessmentSelectionLabel setHidden:YES];
        [self.showCurrentAssesment setHidden:YES];
        [self reloadTableData];
    }
    else
    {
        [self.showCurrentAssesment setUserInteractionEnabled:YES];
        [self.showCurrentAssesment setHidden:NO];
        self.showCurrentAssesment.layer.borderColor=[UIColor grayColor].CGColor;
        self.showCurrentAssesment.layer.borderWidth=1.0f;
        self.showCurrentAssesment.layer.cornerRadius=4.5f;
    }

    if (_showMontessoryAssessment) {
        [_showCurrentAssesment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
       // [self.assessmentSelectionLabel setHidden:NO];
    }
    else{
        [_showCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        //[self.assessmentSelectionLabel setHidden:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
-(void)filterDataBaseOnSegment{
    selectedIndexPath = nil;

     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"levelOneGroup == %@",segValue];
     NSPredicate *preLevelTwo=[NSPredicate predicateWithFormat:@"levelTwoGroup == %@",segValue];
    NSPredicate *preLevelThree=[NSPredicate predicateWithFormat:@"levelThreeGroup == %@",segValue];
    NSPredicate *preLevelFour=[NSPredicate predicateWithFormat:@"levelFourGroup == %@",segValue];
    _masterTableData=[self.montessoriArray filteredArrayUsingPredicate:predicate];

    for(Montessori *montessori in _masterTableData){
        NSArray *level2Array = [LevelTwo fetchLvelTwoInContext:[AppDelegate context] withLevelOneIdentifier:montessori.levelOneIdentifier withFramework:@"Montessori"];
        for (LevelTwo *levelTwoData in level2Array) {
            NSArray *tempLevelThreeArray = [LevelThree fetchLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:levelTwoData.levelTwoIdentifier withFramework:NSStringFromClass([Montessori class])];

            if(tempLevelThreeArray){
                tempLevelThreeArray=[tempLevelThreeArray filteredArrayUsingPredicate:preLevelThree];
                [levelThreeDataDictionary setObject:tempLevelThreeArray forKey:levelTwoData.levelTwoIdentifier];
            }
            for(LevelThree *lvlThree in tempLevelThreeArray){
                NSArray *tempLevelFourArray = [LevelFour fetchLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:lvlThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Montessori class])];
                if(tempLevelFourArray )
                {
                    tempLevelFourArray=[tempLevelFourArray filteredArrayUsingPredicate:preLevelFour];
                    [levelFourDataDictionary setObject:tempLevelFourArray forKey:lvlThree.levelThreeIdentifier];
                }
            }
        }
        level2Array=[level2Array filteredArrayUsingPredicate:preLevelTwo];
        [_levelTwoDataDictionary setObject:level2Array forKey:montessori.levelOneIdentifier];
    }

    NSArray *level2Array = [_levelTwoDataDictionary objectForKey:((Montessori *)[_masterTableData objectAtIndex:0]).levelOneIdentifier];
     currentLevelTwoIdentifier = ((LevelTwo *)level2Array[0]).levelTwoIdentifier;
    levelThreeArray = [LevelThree fetchLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:currentLevelTwoIdentifier withFramework:NSStringFromClass([Montessori class])];
    levelFourDataDictionary=[[NSMutableDictionary alloc]init];
    for (LevelThree *levelThree in levelThreeArray)
    {
        NSArray *levelForArray=[LevelFour fetchLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:levelThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Montessori class])];
        if(levelForArray.count > 0)
            [levelFourDataDictionary setObject:levelForArray forKey:levelThree.levelThreeIdentifier];
    }

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [self reloadTableData];

}

-(void)getDataForDetailTable
{
    levelThreeArray = [LevelThree fetchLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:currentLevelTwoIdentifier withFramework:NSStringFromClass([Montessori class])];

    levelFourDataDictionary=[[NSMutableDictionary alloc]init];
    for (LevelThree *levelThree in levelThreeArray)
    {
        NSArray *levelForArray=[LevelFour fetchLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:levelThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Montessori class])];
        if(levelForArray.count > 0)
        [levelFourDataDictionary setObject:levelForArray forKey:levelThree.levelThreeIdentifier];
    }
}

-(void)viewWillAppear:(BOOL)animated{
  
     self.showCurrentAssesment.layer.borderColor= [UIColor grayColor].CGColor;
     self.showCurrentAssesment.layer.borderWidth=1.0f;
     self.showCurrentAssesment.layer.cornerRadius=4.5f;
     self.btnCancel.layer.cornerRadius= 10.0f;
     self.btnDone.layer.cornerRadius= 10.0f;

   [self performSelectorOnMainThread:@selector(filterDataBaseOnSegment) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag ==1){
        return self.masterTableData.count;
    }
    else{
        return levelThreeArray.count;
//        LevelThree *levelThird = [levelThreeArray objectAtIndex:_levelThreeSegmentControl.selectedSegmentIndex];
//        return ((NSArray *)[levelThreeDataDictionary objectForKey:levelThird.levelThreeIdentifier]).count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        Montessori *montessori = [_masterTableData objectAtIndex:section];
        return ((NSArray *)[_levelTwoDataDictionary objectForKey:montessori.levelOneIdentifier]).count;

    }else{
        LevelThree *ThirdLevel = [levelThreeArray objectAtIndex:section];
        NSArray *lavelFourArray = [levelFourDataDictionary objectForKey:ThirdLevel.levelThreeIdentifier];
        return lavelFourArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView.tag == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.numberOfLines =2;

        Montessori *montessori = [_masterTableData objectAtIndex:indexPath.section];
        NSArray *levelTwArray = [_levelTwoDataDictionary objectForKey:montessori.levelOneIdentifier];
        LevelTwo *levelSecond=[levelTwArray objectAtIndex:indexPath.row];



        cell.textLabel.text= levelSecond.levelTwoDescription;
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithRed:193.0f/255.0f green:196.0/255.0f blue:84.0/255.0f alpha:1]];
        [cell setSelectedBackgroundView:bgColorView];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"levelTwoIdentifier == %@",levelSecond.levelTwoIdentifier];
        NSArray *array = [self.tempArray filteredArrayUsingPredicate:predicate];
        if (array.count > 0) {
            cell.contentView.backgroundColor =yellowColor;
        }
        if([selectedIndexPath isEqual:indexPath]){
            cell.contentView.backgroundColor =yellowColor;
        }
        else if (indexPath.row == 0 && indexPath.section == 0 && !selectedIndexPath && self.tempArray.count == 0) {
            cell.contentView.backgroundColor=yellowColor;
        }
        if(!selectedIndexPath){
            if(indexPath.row == 0 && indexPath.section == 0  && self.tempArray.count == 0){
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 22,10, 22,22)];
                imv.image=[UIImage imageNamed:@"right_arrow.png"];
                [cell addSubview:imv];
                cell.accessoryView = nil;
                cell.textLabel.text= levelSecond.levelTwoDescription;
            }
        }
        else if ([selectedIndexPath isEqual:indexPath]){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 22,10, 22,22)];
            imv.image=[UIImage imageNamed:@"right_arrow.png"];
            [cell addSubview:imv];
            cell.accessoryView = nil;
            cell.textLabel.text= levelSecond.levelTwoDescription;
        }
        return cell;

    }
    else if(tableView.tag == 2){

        MontessoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:montessoryTableCellId forIndexPath:indexPath];
        [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        cell.delegate=self;
        cell.lblStatement.font = [UIFont systemFontOfSize:15.0f];
        cell.isRowSelected=NO;

        LevelThree *lThree=[levelThreeArray objectAtIndex:indexPath.section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:lThree.levelThreeIdentifier];
        LevelFour *lFourObject=(LevelFour *)[lFourtArray objectAtIndex:indexPath.row];

        [cell.btnAssesment setTitle:@"" forState:UIControlStateNormal];
//      [cell.btnAssesment setBackgroundColor:[UIColor whiteColor]];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        
        if (self.fromNextStep) {
            
                OBMontessori *obmont=[[_tempSelectedList filteredArrayUsingPredicate:predicate]  firstObject];
                if (obmont) {
                    cell.lblNumber.text=@"1";
                    cell.lblNumber.layer.cornerRadius= cell.lblNumber.frame.size.width/2;
                    cell.lblNumber.layer.masksToBounds=YES;
                    cell.lblNumber.backgroundColor=yellowColor;
                    [[cell.lblNumber layer] setBorderWidth:0.5f];
                    [[cell.lblNumber layer] setBorderColor:[UIColor blackColor].CGColor];
                    cell.isRowSelected=NO;
                    [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                    
                   NSPredicate  *tempredicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obmont.montessoriFrameworkLevelNumber,@(obmont.montessoriFrameworkLevelNumber.integerValue)];
                    MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:tempredicate] firstObject];
                    if (database) {
                        [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                        [cell.btnAssesment setBackgroundColor:database.assesmentColor];
                    }
                }else{
                    cell.lblNumber.text = @"";
                    cell.lblNumber.backgroundColor=[UIColor clearColor];
                    [[cell.lblNumber layer] setBorderWidth:0.5f];
                    [[cell.lblNumber layer] setBorderColor:[UIColor  clearColor].CGColor];
                    [cell.btnAssesment setBackgroundColor:[UIColor clearColor]];
                }
                
                OBMontessori * obMontessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
                if (obMontessori) {
                    cell.isRowSelected=YES;
                    [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                   
                }
                else{
                    cell.isRowSelected=NO;
                    [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                }
            
        }else{

            OBMontessori * obMontessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
            if (obMontessori) {
                cell.isRowSelected=YES;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obMontessori.montessoriFrameworkLevelNumber,@(obMontessori.montessoriFrameworkLevelNumber.integerValue)];
                MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:predicate] firstObject];
                if (database) {
                    [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                    [cell.btnAssesment setBackgroundColor:database.assesmentColor];
                }
            }
            else{
                cell.isRowSelected=NO;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                cell.lblNumber.text = @"";
                //cell.lblNumber.layer.backgroundColor = [UIColor clearColor].CGColor;
                cell.lblNumber.backgroundColor=[UIColor clearColor];
                [[cell.lblNumber layer] setBorderWidth:0.5f];
                [[cell.lblNumber layer] setBorderColor:[UIColor  clearColor].CGColor];
             }
        }
       
        if (self.fromNextStep) {
            cell.btnAssesment.hidden=NO;
            cell.btnAssesment.userInteractionEnabled=NO;
            
        }else{
            cell.btnAssesment.userInteractionEnabled = YES;
            if (cell.isRowSelected) {
                cell.btnAssesment.hidden = NO;
            }
            else{
                cell.btnAssesment.hidden = YES;
            }
            cell.btnAssesment.indexPath = indexPath;
            if (assesmentMontessoryArray.count>1) {
                [cell.btnAssesment addTarget:self action:@selector(openTable:) forControlEvents:UIControlEventTouchUpInside];

            }
        }
        
        [cell.btnSelectedButton addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblStatement.text = lFourObject.levelFourDescription;
          NSPredicate *tpredicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        if (self.showMontessoryAssessment && currentMontessoriAssesmentDictionary.count>0) {
            NSNumber *count = [currentMontessoriAssesmentDictionary objectForKey:lFourObject.levelFourIdentifier.stringValue];
            NSString *bcolor=[currentMontessoriColorAssesmentDictionary objectForKey:lFourObject.levelFourIdentifier.stringValue];
            NSLog(@"%@",count);
            
            OBMontessori *obmont=[[_tempSelectedList filteredArrayUsingPredicate:tpredicate]  firstObject];
            if (obmont) { count=[NSNumber numberWithInt:([count  integerValue]+[[NSNumber numberWithInt:1] integerValue])];}

            cell.lblNumber.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
            
            NSLog(@"%@ and count %@",bcolor,count);

            if (count > 0) {
                cell.lblNumber.layer.cornerRadius= cell.lblNumber.frame.size.width/2;
                cell.lblNumber.layer.masksToBounds=YES;
               // cell.lblNumber.layer.backgroundColor=[[self class]colorWithHexString:bcolor].CGColor;
                cell.lblNumber.backgroundColor=yellowColor;
                cell.backgroundColor=[[self class]colorWithHexString:bcolor];
                [[cell.lblNumber layer] setBorderWidth:0.5f];
                [[cell.lblNumber layer] setBorderColor:[UIColor blackColor].CGColor];
                //cell.lblNumber.layer.backgroundColor=(__bridge CGColorRef)(band.rgbColor);
            }
            else{
               // cell.lblNumber.layer.backgroundColor = [UIColor clearColor].CGColor;
                cell.lblNumber.backgroundColor=[UIColor clearColor];
                cell.backgroundColor=[UIColor clearColor];
                [[cell.lblNumber layer] setBorderWidth:0.5f];
                [[cell.lblNumber layer] setBorderColor:[UIColor  clearColor].CGColor];
            }
        }
        else{
            if (!self.fromNextStep) {
                cell.lblNumber.text = @"";
                cell.lblNumber.backgroundColor=[UIColor clearColor];}
            //cell.lblNumber.layer.backgroundColor = [UIColor clearColor].CGColor;
            cell.backgroundColor=[UIColor clearColor];
            [[cell.lblNumber layer] setBorderWidth:0.5f];
            [[cell.lblNumber layer] setBorderColor:[UIColor  clearColor].CGColor];
            }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1){
        selectedIndexPath =indexPath;
       [self.tableView reloadData];

        Montessori *montessori=[_masterTableData objectAtIndex:indexPath.section];
        NSArray *leve2Array=[_levelTwoDataDictionary objectForKey:montessori.levelOneIdentifier];
        LevelTwo *secondLevel =[leve2Array objectAtIndex:indexPath.row];
        currentLevelTwoIdentifier=secondLevel.levelTwoIdentifier;
        [self getDataForDetailTable];
        [self.detailTableView reloadData];
        [self.detailTableView setContentOffset:CGPointZero animated:YES];
    }else if(tableView.tag == 2){
        MontessoryTableViewCell *cell = (MontessoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self selectMontessoryTableViewCell:cell];
    }
}
-(void)selectedBtnClicked:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self selectMontessoryTableViewCell:[[[btn superview] superview] superview]];
    }
    else{
        [self selectMontessoryTableViewCell:[[btn superview] superview]];
    }
}

-(void)selectMontessoryTableViewCell:(MontessoryTableViewCell *)cell{

    NSIndexPath * indexPath = [self.detailTableView indexPathForCell:cell];
    if(cell.isRowSelected){
        cell.isRowSelected = NO;
        [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    }else{
        cell.isRowSelected=YES;
        [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
    }
    if (cell.isRowSelected) {
        cell.btnAssesment.hidden = NO;
    }
    else{
        cell.btnAssesment.hidden = YES;
    }
    LevelThree *thirdLevel=[levelThreeArray objectAtIndex:indexPath.section];
    NSArray *lblFourArray=[levelFourDataDictionary objectForKey:thirdLevel.levelThreeIdentifier];
    LevelFour *levelFourObject=(LevelFour *)[lblFourArray objectAtIndex:indexPath.row];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",levelFourObject.levelFourIdentifier,levelFourObject.levelFourIdentifier.stringValue];
    NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.tempArray removeObjectsInArray:array];
        [cell.btnAssesment setTitle:@"" forState:UIControlStateNormal];
//        [cell.btnAssesment setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        
        
        OBMontessori * obMontessori = [[OBMontessori alloc]init];
        obMontessori.montessoriFrameworkItemId = levelFourObject.levelFourIdentifier;
        obMontessori.montessoriFrameworkLevelNumber = @(0);
        obMontessori.levelTwoIdentifier = thirdLevel.levelTwoIdentifier;
        [self.tempArray addObject:obMontessori];
        predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obMontessori.montessoriFrameworkLevelNumber,@(obMontessori.montessoriFrameworkLevelNumber.integerValue)];
        MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:predicate] firstObject];
        if (database) {
            [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
            [cell.btnAssesment setBackgroundColor:database.assesmentColor];
        }
    }
    NSLog(@"array Count %d",self.tempArray.count);
    _montessoryNotification = self.tempArray.count;

    [self reloadTableData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return 50;
    }else{
        return 50;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        return 50;
    }else{
        return 50;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-10, 44)];
        [label setFont:[UIFont boldSystemFontOfSize:18]];
        label.numberOfLines=2;
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        Montessori *montessory = [_masterTableData objectAtIndex:section];
        [label setText:montessory.levelOneDescription];
        [view addSubview:label];
        return view;

    }else{

        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
        [label setFont:[UIFont boldSystemFontOfSize:15.0f]];
        label.numberOfLines=2;
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        LevelThree *levelThird = [levelThreeArray objectAtIndex:section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:levelThird.levelThreeIdentifier];
        if (lFourtArray.count == 0) {
            label.frame = CGRectMake(10, 0, tableView.frame.size.width-194, 44);
            view.tag = section;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(montessoryHeaderBtnSelected:)];
            tapGesture.delegate = self;
            [view addGestureRecognizer:tapGesture];
            UIButton * btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSelected.frame = CGRectMake(tableView.frame.size.width - 42, 5, 35, 35);
            [btnSelected setImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
            [btnSelected addTarget:self action:@selector(montessoryHeaderBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
            btnSelected.tag = section;
            [view addSubview:btnSelected];
            CustomButton * btnAssesment = [CustomButton buttonWithType:UIButtonTypeCustom];
            btnAssesment.frame = CGRectMake(tableView.frame.size.width - btnSelected.frame.size.width - 96 -55, 8, 90, 28);
            btnAssesment.tag = 111;
            btnAssesment.hidden = YES;
            btnAssesment.section = section;
            [btnAssesment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnAssesment.titleLabel.font=[UIFont systemFontOfSize:14];
            UILabel *currentAsessment=[[UILabel alloc]initWithFrame:CGRectMake(btnAssesment.frame.origin.x+btnAssesment.frame.size.width+6, 5, 35, 35)];
            currentAsessment.layer.cornerRadius=currentAsessment.frame.size.width/2;
            currentAsessment.layer.masksToBounds=YES;
            currentAsessment.textAlignment=NSTextAlignmentCenter;

            [btnAssesment addTarget:self action:@selector(montessoryHeaderBtnAssesmentClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",levelThird.levelThreeIdentifier,levelThird.levelThreeIdentifier.stringValue];
            
            
            
            if (self.fromNextStep) {

                OBMontessori * obMontessori = [[self.tempSelectedList filteredArrayUsingPredicate:predicate] firstObject];
                if (obMontessori) {
                    
                    currentAsessment.text=@"1";
                    currentAsessment.backgroundColor=yellowColor;
                    [[currentAsessment layer] setBorderWidth:0.5f];
                    [[currentAsessment layer] setBorderColor:[UIColor blackColor].CGColor];
                    
                   NSPredicate *predicateSel = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obMontessori.montessoriFrameworkLevelNumber,@(obMontessori.montessoriFrameworkLevelNumber.integerValue)];
                    MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:predicateSel] firstObject];
                    btnAssesment.hidden = NO;
                    btnAssesment.userInteractionEnabled=false;
                    btnSelected.userInteractionEnabled=YES;
                    if (database) {
                        [btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                        [btnAssesment setBackgroundColor:database.assesmentColor];
                        
                    }
                }
                
                OBMontessori * obbtnMontessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
                if (obbtnMontessori) {
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                    
                }
                else{
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                }
                
            }else{
                OBMontessori * obMontessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
                if (obMontessori) {
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                    predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obMontessori.montessoriFrameworkLevelNumber,@(obMontessori.montessoriFrameworkLevelNumber.integerValue)];
                    MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:predicate] firstObject];
                    btnAssesment.hidden = NO;
                    
                    if (database) {
                        [btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                        [btnAssesment setBackgroundColor:database.assesmentColor];
                        
                    }
                }
            }
            
            if (self.showMontessoryAssessment && currentMontessoriAssesmentDictionary.count>0) {
                NSNumber *count = [currentMontessoriAssesmentDictionary objectForKey:levelThird.levelThreeIdentifier.stringValue];
                NSString *bcolor=[currentMontessoriColorAssesmentDictionary objectForKey:levelThird.levelThreeIdentifier.stringValue];
                NSLog(@"%@",count);
                
                OBMontessori *obmont=[[_tempSelectedList filteredArrayUsingPredicate:predicate]  firstObject];
                if (obmont) { count=[NSNumber numberWithInt:([count  integerValue]+[[NSNumber numberWithInt:1] integerValue])];}
                
                currentAsessment.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
                
                NSLog(@"%@ and count %@",bcolor,count);
                
                if (count > 0) {
                    // cell.lblNumber.layer.backgroundColor=[[self class]colorWithHexString:bcolor].CGColor;
                    currentAsessment.backgroundColor=yellowColor;
                    view.backgroundColor=[[self class]colorWithHexString:bcolor];
                    [[currentAsessment layer] setBorderWidth:0.5f];
                    [[currentAsessment layer] setBorderColor:[UIColor blackColor].CGColor];
                    //cell.lblNumber.layer.backgroundColor=(__bridge CGColorRef)(band.rgbColor);
                }
                else{
                    // cell.lblNumber.layer.backgroundColor = [UIColor clearColor].CGColor;
                    currentAsessment.backgroundColor=[UIColor clearColor];
                    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
                    [[currentAsessment layer] setBorderWidth:0.5f];
                    [[currentAsessment layer] setBorderColor:[UIColor  clearColor].CGColor];
                }
            }
            else{
                if (!self.fromNextStep) {
                    currentAsessment.text = @"";
                    view.backgroundColor=[UIColor groupTableViewBackgroundColor];}
                //cell.lblNumber.layer.backgroundColor = [UIColor clearColor].CGColor;
                view.backgroundColor=[UIColor groupTableViewBackgroundColor];
                [[currentAsessment layer] setBorderWidth:0.5f];
                [[currentAsessment layer] setBorderColor:[UIColor  clearColor].CGColor];
            }

            
            [view addSubview:btnAssesment];
            [view addSubview:currentAsessment];
        }
        [label setText:levelThird.levelThreeDescription];
        [view addSubview:label];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}
-(void)montessoryHeaderBtnSelected:(id)sender{

    UIView * view = nil;
    UIButton * button = nil;
    CustomButton * assesmentBtn = nil;
    NSInteger section = 0;
    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        NSLog(@"TAG %d",[[sender view] tag]);
        section = [[sender view] tag];
        view = [sender view];
        for (UIView* subView in view.subviews) {
            if (subView.tag == section && [subView isKindOfClass:[UIButton class]]) {
                button = (UIButton *)subView;
                [button setSelected:![button isSelected]];
                if (button.selected) {
                    [button setImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                }
                else{
                    [button setImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                }
            }
            else if (subView.tag == 111 && [subView isKindOfClass:[CustomButton class]]) {
                assesmentBtn = (CustomButton *)subView;
                assesmentBtn.hidden = !button.isSelected;
            }
        }
    }
    else{
        section = [sender tag];
        view = [sender superview];
        for (UIView* subView in view.subviews) {
            if (subView.tag == section && [subView isKindOfClass:[UIButton class]]) {
                button = (UIButton *)subView;
                [button setSelected:![button isSelected]];
                if (button.selected) {
                    [button setImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                }
                else{
                    [button setImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                }
            }
            else if (subView.tag == 111 && [subView isKindOfClass:[CustomButton class]]) {
                assesmentBtn = (CustomButton *)subView;
                assesmentBtn.hidden = !button.isSelected;
            }
        }
    }
    LevelThree *thirdLevel=[levelThreeArray objectAtIndex:section];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",thirdLevel.levelThreeIdentifier,thirdLevel.levelThreeIdentifier.stringValue];
    NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.tempArray removeObjectsInArray:array];
    }
    else{
        OBMontessori * obMontessori = [[OBMontessori alloc]init];
        obMontessori.montessoriFrameworkItemId = thirdLevel.levelThreeIdentifier;
        obMontessori.montessoriFrameworkLevelNumber = @(0);
        obMontessori.levelTwoIdentifier = thirdLevel.levelTwoIdentifier;
        [self.tempArray addObject:obMontessori];
        predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obMontessori.montessoriFrameworkLevelNumber,@(obMontessori.montessoriFrameworkLevelNumber.integerValue)];
        MontessoriAssesmentDataBase * database = [[assesmentMontessoryArray filteredArrayUsingPredicate:predicate] firstObject];
        if (database) {
            [assesmentBtn setTitle:database.levelDescription forState:UIControlStateNormal];
            [assesmentBtn setBackgroundColor:database.assesmentColor];

        }
    }
    _montessoryNotification = self.tempArray.count;
    [self reloadTableData];
}
-(void)montessoryHeaderBtnAssesmentClicked:(id)sender{

    [self.montessoryTablePopOver dismissPopoverAnimated:YES];
    isMontessoryHeaderBtnAssesmentSelected = YES;
    headerAssesmentSection = [(CustomButton *)sender section];
    UIButton * btn = (UIButton *)sender;
    self.montessoryPopUpTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MontessoryPopUpTableControllerId"];
    _montessoryTablePopOver = [[WYPopoverController alloc]initWithContentViewController:self.montessoryPopUpTableViewController];
    _montessoryPopUpTableViewController.delegate=self;
    self.montessoryTablePopOver.popoverContentSize = CGSizeMake(150,175);
    self.montessoryPopUpTableViewController.assesmentArray = assesmentMontessoryArray;
    [self.montessoryTablePopOver presentPopoverFromRect:btn.frame inView:[btn superview] permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}
-(void)openTable:(id)sender{

    [self.montessoryTablePopOver dismissPopoverAnimated:YES];
    isMontessoryHeaderBtnAssesmentSelected = NO;
    CustomButton * btn = (CustomButton *)sender;
   // NSLog(@"openTable called and Tag is %ld",(long)[sender tag]);
    assesmentselectedIndexPath = btn.indexPath;
    self.montessoryPopUpTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MontessoryPopUpTableControllerId"];
    _montessoryTablePopOver = [[WYPopoverController alloc]initWithContentViewController:self.montessoryPopUpTableViewController];
    _montessoryPopUpTableViewController.delegate=self;
    self.montessoryTablePopOver.popoverContentSize = CGSizeMake(150,175);
    self.montessoryPopUpTableViewController.assesmentArray = assesmentMontessoryArray;
    [self.montessoryTablePopOver presentPopoverFromRect:btn.frame inView:[btn superview] permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnCancel:(id)sender {
    [self.delegate closeButtonAction:sender];
}

- (IBAction)btnDone:(id)sender {
    
     self.selectedList = self.tempArray;
    NSLog(@"%@", self.tempArray);
    [self.delegate doneButtonAction:sender];
}

- (IBAction)btnShowCurrentAssesment:(id)sender {
    _showMontessoryAssessment = !_showMontessoryAssessment;
    if (_showMontessoryAssessment) {
        currentMontessoryAssesmentArray = [NSMutableArray array];
        [_showCurrentAssesment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [_showCurrentAssesment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showCurrentAssesment.backgroundColor=yellowColor;
    }
    else{
        currentMontessoryAssesmentArray = nil;
        [_showCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        _showCurrentAssesment.backgroundColor=[UIColor clearColor];
        [_showCurrentAssesment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self reloadTableData];
        return;
    }
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;

     // NSNumber *childID = @32;

    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading..";

    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;

    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/current_assessments",serverURL];

   NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"montessori",@"type",childID,@"child_id",nil];

    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  return;
                                              }
                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                              lastSelectedChildForMontessoriAssesment = childID;
                                              [self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                          }];

    [postDataTask resume];


}
-(void)backgroundLoadData:(NSData *)data
{
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", json[@"data"]);
    if([json[@"status"] isEqualToString:@"success"])
    {
        currentMontessoriAssesmentDictionary = [[NSMutableDictionary alloc] init];
        currentMontessoriColorAssesmentDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in json[@"data"]) {
            [currentMontessoriAssesmentDictionary setObject:dict[@"selected_count"] forKey:dict[@"framework_item_id"]];
            LevelFour *fourthLevel = [[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:dict[@"framework_item_id"] withFrameWork:@"Montessori"]firstObject];
            NSArray *array;
            if (array.count == 0 && fourthLevel) {
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
                    MontessoryBand *monteBand = [[MontessoryBand alloc]init];
                    monteBand.levelIdentifier = fourthLevel.levelFourIdentifier;
                    monteBand.levelNumber = dict[@"level_number"];
                    monteBand.rgbColor = rgbColor;
                    [currentMontessoryAssesmentArray addObject:monteBand];
                }
                else{
                }
            }
            if (dict[@"color"] != [NSNull null]) {
                [currentMontessoriColorAssesmentDictionary setObject:dict[@"color"] forKey:dict[@"framework_item_id"]];
            }
            else
            {
                [currentMontessoriColorAssesmentDictionary setObject:@"#ffffff00" forKey:dict[@"framework_item_id"]];
            }
        }
        NSLog(@"%@", currentMontessoriAssesmentDictionary);
        NSLog(@"%@", currentMontessoriColorAssesmentDictionary);
        [self.detailTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
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
-(void)closeAlert{
    UIViewController *topVC = self.navigationController;
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)reloadTableData{

    [self.tableView reloadData];
    [self.detailTableView reloadData];
}
- (IBAction)btnSagmentSwitch:(id)sender {

//    MBProgressHUD *hud=[MBProgressHUD  showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText= @"Loading...";

    if(self.sagmentController.selectedSegmentIndex==0){
        segValue=@"0-3";
        [self filterDataBaseOnSegment];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        [self.detailTableView setContentOffset:CGPointZero animated:YES];
    }
    else if(self.sagmentController.selectedSegmentIndex==1){
        segValue=@"3-6";
        [self filterDataBaseOnSegment];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        [self.detailTableView setContentOffset:CGPointZero animated:YES];
    }
    [self.tableView reloadData];
}
-(void)selectedAssesment:(MontessoriAssesmentDataBase *)database{
    [self.montessoryTablePopOver dismissPopoverAnimated:YES];
    if (isMontessoryHeaderBtnAssesmentSelected) {
        LevelThree *lThree=[levelThreeArray objectAtIndex:headerAssesmentSection];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",lThree.levelThreeIdentifier,lThree.levelThreeIdentifier.stringValue];
        OBMontessori * montessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
        if (montessori) {
            montessori.montessoriFrameworkLevelNumber = database.levelId;
        }
        [self reloadTableData];
    }
    else{
        LevelThree *lThree=[levelThreeArray objectAtIndex:assesmentselectedIndexPath.section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:lThree.levelThreeIdentifier];
        LevelFour *lFourObject=(LevelFour *)[lFourtArray objectAtIndex:assesmentselectedIndexPath.row];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"montessoriFrameworkItemId == %@ OR montessoriFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        OBMontessori * montessori = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
        if (montessori) {
            montessori.montessoriFrameworkLevelNumber = database.levelId;
        }
        [self reloadTableData];
    }
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

}

- (void) orientationChanged:(NSNotification *)note
{

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
    [self reloadTableData];

}
@end
