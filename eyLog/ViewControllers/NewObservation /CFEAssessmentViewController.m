//
//  CFEAssessmentViewController.m
//  eyLog
//
//  Created by shuchi on 03/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CFEAssessmentViewController.h"
#import "WYPopoverController.h"

#import "CfeFramework.h"
#import "AppDelegate.h"
#import "Cfe.h"
#import "CfeLevelOne.h"
#import "CfeLevelTwo.h"
#import "CfeLevelThree.h"
#import "CfeLevelFour.h"
#import "CfeAssesmentDataBase.h"
#import "DZNSegmentedControl.h"
#import "CfeTableViewCell.h"
#import "MBProgressHUD.h"
//#import "MontessoryBand.h"
#import "APICallManager.h"
#import "OBCfe.h"
#import "CfeBand.h"
//#import "OBMontessori.h"
//#import "MontessoryPopUpTableController.h"


@interface CFEAssessmentViewController ()<UITableViewDelegate,UITableViewDataSource,WYPopoverControllerDelegate>
{
    
    NSIndexPath *selectedIndexPath;
    NSMutableDictionary *levelOneDataDictionary;
    
    NSMutableDictionary *levelThreeDataDictionary;
    NSMutableDictionary *levelFourDataDictionary;
    NSNumber *currentLevelTwoIdentifier;
    NSArray *levelThreeArray;
    NSArray *levelTwoArray;
    NSArray *levelFourArray;
    NSArray *assesmentCfeArray;
    NSArray *segmemntControlArray;
    NSMutableArray * currentCfeAssesmentArray;
    NSNumber *lastSelectedChildForCfeAssesment;
    NSMutableDictionary *currenCfeAssesmentDictionary;
    NSMutableDictionary *currentCfeColorAssesmentDictionary;
    NSString *segValue;
    NSMutableArray *color;
    NSArray *CfeDetailTableViewArray;
    // NSMutableDictionary *savedAssesmentValues;
    //NSMutableArray *assesmentValues;
    NSArray *assesmentPrperties;
    NSIndexPath  * assesmentselectedIndexPath;
    BOOL isCfeHeaderBtnAssesmentSelected;
    NSInteger headerAssesmentSection;
    
   

}
@property (strong, nonatomic) IBOutlet DZNSegmentedControl *levelThreeSegmentControl;
@property (nonatomic, assign) BOOL showCfeAssessment;
@property(atomic,strong) NSMutableDictionary *levelTwoDataDictionary;
@property(atomic,strong) NSMutableDictionary *levelFDataDictionary;
@property (strong, nonatomic) NSMutableArray * tempArray;
@property (strong, nonatomic) NSArray * masterTableData;
@property (strong, nonatomic) NSArray * detailTableData;
@end

@implementation CFEAssessmentViewController


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
    segValue=[self.segmentedControl titleForSegmentAtIndex:0];
        assesmentCfeArray = [CfeAssesmentDataBase fetchAllCfeAssessmentInContext:[AppDelegate context] ];
    
    //    MBProgressHUD *hud=[MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeText;
    //    hud.labelText= @"Loading...";
    
    
    [self.detailTableview registerNib:[UINib nibWithNibName:NSStringFromClass([CfeTableViewCell class]) bundle:nil] forCellReuseIdentifier:CfeTableCellId];
    levelOneDataDictionary = [NSMutableDictionary dictionary];
    _levelTwoDataDictionary = [NSMutableDictionary dictionary];
    levelThreeDataDictionary = [NSMutableDictionary dictionary];
    levelFourDataDictionary = [NSMutableDictionary dictionary];
    
    assesmentPrperties=[[NSArray alloc]init];
    color=[[NSMutableArray alloc]init];
    //savedAssesmentValues=[[NSMutableDictionary alloc]init];
    
    _masterTableData = [NSArray array];
    
    
    NSArray *level2Array = [_levelTwoDataDictionary objectForKey:((Cfe *)[self.cfeArray objectAtIndex:0]).levelOneIdentifier];
    currentLevelTwoIdentifier = ((CfeLevelTwo *)level2Array[0]).levelTwoIdentifier;
    
    _masterTableData = [NSArray array];
    _detailTableData = [NSArray array];
    assesmentCfeArray
    = [CfeAssesmentDataBase fetchAllCfeAssessmentInContext:[AppDelegate context] ];
    _cancel_btn.layer.cornerRadius=5;
    _cancel_btn.layer.masksToBounds=true;
    _done_btn.layer.cornerRadius=5;
    _done_btn.layer.masksToBounds=true;
    
    
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        [self.showCurrentAssessment setUserInteractionEnabled:NO];
        [self.showCurrentAssessment setHidden:YES];
    }
    else
    {
        [self.showCurrentAssessment setUserInteractionEnabled:YES];
        [self.showCurrentAssessment setHidden:NO];
        self.showCurrentAssessment.layer.borderColor=[UIColor grayColor].CGColor;
        self.showCurrentAssessment.layer.borderWidth=1.0f;
        self.showCurrentAssessment.layer.cornerRadius=4.5f;
    }
    
    // Showing age segment according to setting
       [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(lastSelectedChildForCfeAssesment && [APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
    {
        if(![lastSelectedChildForCfeAssesment isEqualToNumber:[APICallManager sharedNetworkSingleton].cacheChild.childId])
        {
            self.showCfeAssessment = NO;
            currentCfeAssesmentArray = nil;
            [_showCurrentAssessment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
            [self.showCurrentAssessment setUserInteractionEnabled:YES];
            //[self.assessmentSelectionLabel setHidden:YES];
            [self.showCurrentAssessment setHidden:NO];
            [self reloadTableData];
        }
    }
    
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        lastSelectedChildForCfeAssesment = nil;
        self.showCfeAssessment = NO;
        [self.showCurrentAssessment setUserInteractionEnabled:NO];
        // [self.assessmentSelectionLabel setHidden:YES];
        [self.showCurrentAssessment setHidden:YES];
        [self reloadTableData];
    }
    else
    {
        [self.showCurrentAssessment setUserInteractionEnabled:YES];
        [self.showCurrentAssessment setHidden:NO];
        self.showCurrentAssessment.layer.borderColor=[UIColor grayColor].CGColor;
        self.showCurrentAssessment.layer.borderWidth=1.0f;
        self.showCurrentAssessment.layer.cornerRadius=4.5f;
    }
    
    if (_showCfeAssessment) {
        [_showCurrentAssessment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        // [self.assessmentSelectionLabel setHidden:NO];
    }
    else{
        [_showCurrentAssessment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        //[self.assessmentSelectionLabel setHidden:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
-(void)filterDataBaseOnSegment{
    selectedIndexPath = nil;
    //Early Level
    //First Level
    //Second Level
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"levelOneGroup == %@",segValue];
    NSPredicate *preLevelTwo=[NSPredicate predicateWithFormat:@"levelTwoGroup == %@",segValue];
    NSPredicate *preLevelThree=[NSPredicate predicateWithFormat:@"levelThreeGroup == %@",segValue];
    NSPredicate *preLevelFour=[NSPredicate predicateWithFormat:@"levelFourGroup == %@",segValue];
    _masterTableData=[self.cfeArray filteredArrayUsingPredicate:predicate];
    if(_masterTableData.count>0)
    {
    for(Cfe *cfe in _masterTableData){
        NSArray *level2Array = [CfeLevelTwo fetchCfeLvelTwoInContext:[AppDelegate context] withLevelOneIdentifier:cfe.levelOneIdentifier withFramework:@"Cfe"];
        for (CfeLevelTwo *levelTwoData in level2Array) {
            NSArray *tempLevelThreeArray = [CfeLevelThree fetchCfeLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:levelTwoData.levelTwoIdentifier withFramework:NSStringFromClass([Cfe class])];
            
            if(tempLevelThreeArray){
                tempLevelThreeArray=[tempLevelThreeArray filteredArrayUsingPredicate:preLevelThree];
                [levelThreeDataDictionary setObject:tempLevelThreeArray forKey:levelTwoData.levelTwoIdentifier];
            }
            for(CfeLevelThree *lvlThree in tempLevelThreeArray){
                NSArray *tempLevelFourArray = [CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:lvlThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Cfe class])];
                if(tempLevelFourArray )
                {
                    tempLevelFourArray=[tempLevelFourArray filteredArrayUsingPredicate:preLevelFour];
                    [levelFourDataDictionary setObject:tempLevelFourArray forKey:lvlThree.levelThreeIdentifier];
                }
            }
        }
        level2Array=[level2Array filteredArrayUsingPredicate:preLevelTwo];
        [_levelTwoDataDictionary setObject:level2Array forKey:cfe.levelOneIdentifier];
    }
    
    NSArray *level2Array = [_levelTwoDataDictionary objectForKey:((Cfe *)[_masterTableData objectAtIndex:0]).levelOneIdentifier];
    currentLevelTwoIdentifier = ((CfeLevelTwo *)level2Array[0]).levelTwoIdentifier;
    levelThreeArray = [CfeLevelThree fetchCfeLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:currentLevelTwoIdentifier withFramework:NSStringFromClass([Cfe class])];
    levelFourDataDictionary=[[NSMutableDictionary alloc]init];
    for (CfeLevelThree *levelThree in levelThreeArray)
    {
        NSArray *levelForArray=[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:levelThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Cfe class])];
        if(levelForArray.count > 0)
            [levelFourDataDictionary setObject:levelForArray forKey:levelThree.levelThreeIdentifier];
    }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self reloadTableData];
    
}

-(void)getDataForDetailTable
{
    levelThreeArray = [CfeLevelThree fetchCfeLevelThreeInContext:[AppDelegate context] withlevelTwoIdentifier:currentLevelTwoIdentifier withFramework:NSStringFromClass([Cfe class])];
    
    levelFourDataDictionary=[[NSMutableDictionary alloc]init];
    for (CfeLevelThree *levelThree in levelThreeArray)
    {
        NSArray *levelForArray=[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withLevelThreeIdentifier:levelThree.levelThreeIdentifier withFrameWork:NSStringFromClass([Cfe class])];
        if(levelForArray.count > 0)
            [levelFourDataDictionary setObject:levelForArray forKey:levelThree.levelThreeIdentifier];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.showCurrentAssessment.layer.borderColor= [UIColor grayColor].CGColor;
    self.showCurrentAssessment.layer.borderWidth=1.0f;
    self.showCurrentAssessment.layer.cornerRadius=4.5f;
    self.cancel_btn.layer.cornerRadius= 10.0f;
    self.done_btn.layer.cornerRadius= 10.0f;
    
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
        Cfe *cfe = [_masterTableData objectAtIndex:section];
        return ((NSArray *)[_levelTwoDataDictionary objectForKey:cfe.levelOneIdentifier]).count;
        
    }else{
        CfeLevelThree *ThirdLevel = [levelThreeArray objectAtIndex:section];
        NSArray *lavelFourArray = [levelFourDataDictionary objectForKey:ThirdLevel.levelThreeIdentifier];
        return lavelFourArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.numberOfLines =2;
        
        Cfe *cfe = [_masterTableData objectAtIndex:indexPath.section];
        NSArray *levelTwArray = [_levelTwoDataDictionary objectForKey:cfe.levelOneIdentifier];
        CfeLevelTwo *levelSecond=[levelTwArray objectAtIndex:indexPath.row];
        
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
        
        CfeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CfeTableCellId forIndexPath:indexPath];
        [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        //cell.delegate=self;
        //cell.lblStatement.font = [UIFont systemFontOfSize:15.0f];
        cell.isRowSelected=NO;
        
        CfeLevelThree *lThree=[levelThreeArray objectAtIndex:indexPath.section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:lThree.levelThreeIdentifier];
        CfeLevelFour *lFourObject=(CfeLevelFour *)[lFourtArray objectAtIndex:indexPath.row];
        
        [cell.btnAssesment setTitle:@"" forState:UIControlStateNormal];
        //  [cell.btnAssesment setBackgroundColor:[UIColor whiteColor]];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        
        if (self.fromNextStep) {
            
            OBCfe *obcfe=[[_tempSelectedList filteredArrayUsingPredicate:predicate]  firstObject];
            if (obcfe) {
                cell.lblNumber.text=@"1";
                cell.lblNumber.layer.cornerRadius= cell.lblNumber.frame.size.width/2;
                cell.lblNumber.layer.masksToBounds=YES;
                cell.lblNumber.backgroundColor=yellowColor;
                [[cell.lblNumber layer] setBorderWidth:0.5f];
                [[cell.lblNumber layer] setBorderColor:[UIColor blackColor].CGColor];
                 cell.isRowSelected=NO;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                
                NSPredicate  *tempredicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obcfe.cfeFrameworkLevelNumber,@(obcfe.cfeFrameworkLevelNumber.integerValue)];
             CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:tempredicate] firstObject];
                if (database) {
                    [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                    NSArray *colors = [database.color componentsSeparatedByString:@","];
                [cell.btnAssesment setBackgroundColor:[UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f]];
                }
            }else{
                cell.lblNumber.text = @"";
                cell.lblNumber.backgroundColor=[UIColor clearColor];
                [[cell.lblNumber layer] setBorderWidth:0.5f];
                [[cell.lblNumber layer] setBorderColor:[UIColor  clearColor].CGColor];
                [cell.btnAssesment setBackgroundColor:[UIColor clearColor]];
            }
            
            OBCfe * obCfeValue = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
            if (obCfeValue) {
                cell.isRowSelected=YES;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                
            }
            else{
                cell.isRowSelected=NO;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
            }
            
        }else{
            
            OBCfe * obCfe= [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
            if (obCfe) {
                cell.isRowSelected=YES;
                [cell.btnSelectedButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,@(obCfe.cfeFrameworkLevelNumber.integerValue)];
                CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:predicate] firstObject];
                if (database) {
                    [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                    NSArray *colors = [database.color componentsSeparatedByString:@","];
                   [cell.btnAssesment setBackgroundColor: [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f]];
                  
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
            if (assesmentCfeArray.count>1) {
                [cell.btnAssesment addTarget:self action:@selector(openTable:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        
        [cell.btnSelectedButton addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblStatement.text = lFourObject.levelFourDescription;
        NSPredicate *tpredicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        if (self.showCfeAssessment && currenCfeAssesmentDictionary.count>0) {
            NSNumber *count = [currenCfeAssesmentDictionary objectForKey:lFourObject.levelFourIdentifier.stringValue];
            NSString *bcolor=[currentCfeColorAssesmentDictionary objectForKey:lFourObject.levelFourIdentifier.stringValue];
            NSLog(@"%@",count);
            
            OBCfe *obmont=[[_tempSelectedList filteredArrayUsingPredicate:tpredicate]  firstObject];
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
        [tableView reloadData];
        
        Cfe *cfe=[_masterTableData objectAtIndex:indexPath.section];
        NSArray *leve2Array=[_levelTwoDataDictionary objectForKey:cfe.levelOneIdentifier];
        CfeLevelTwo *secondLevel =[leve2Array objectAtIndex:indexPath.row];
        currentLevelTwoIdentifier=secondLevel.levelTwoIdentifier;
        [self getDataForDetailTable];
        [self.detailTableview reloadData];
        [self.detailTableview setContentOffset:CGPointZero animated:YES];
    }else if(tableView.tag == 2){
        CfeTableViewCell *cell = (CfeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self selectCfeTableViewCell:cell];
    }
}
-(void)selectedBtnClicked:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self selectCfeTableViewCell:[[[btn superview] superview] superview]];
    }
    else{
        [self selectCfeTableViewCell:[[btn superview] superview]];
    }
}

-(void)selectCfeTableViewCell:(CfeTableViewCell *)cell{
    
    NSIndexPath * indexPath = [self.detailTableview indexPathForCell:cell];
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
    CfeLevelThree *thirdLevel=[levelThreeArray objectAtIndex:indexPath.section];
    NSArray *lblFourArray=[levelFourDataDictionary objectForKey:thirdLevel.levelThreeIdentifier];
    CfeLevelFour *levelFourObject=(CfeLevelFour *)[lblFourArray objectAtIndex:indexPath.row];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",levelFourObject.levelFourIdentifier,levelFourObject.levelFourIdentifier.stringValue];
    NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.tempArray removeObjectsInArray:array];
        [cell.btnAssesment setTitle:@"" forState:UIControlStateNormal];
        //        [cell.btnAssesment setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        
        
        OBCfe * obCfe = [[OBCfe alloc]init];
        obCfe.cfeFrameworkItemId = levelFourObject.levelFourIdentifier;
        obCfe.cfeFrameworkLevelNumber = @(0);
        obCfe.levelTwoIdentifier = thirdLevel.levelTwoIdentifier;
        [self.tempArray addObject:obCfe];
        predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,@(obCfe.cfeFrameworkLevelNumber.integerValue)];
        CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:predicate] firstObject];
        if (database) {
            [cell.btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
            //[cell.btnAssesment setBackgroundColor:database.assesmentColor];
        }
    }
    NSLog(@"array Count %d",self.tempArray.count);
    //_cfeNotification = self.tempArray.count;
    
    [self reloadTableData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        CfeLevelThree *lThree=[levelThreeArray objectAtIndex:indexPath.section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:lThree.levelThreeIdentifier];
        CfeLevelFour *lFourObject=(CfeLevelFour *)[lFourtArray objectAtIndex:indexPath.row];
        heightTextView.text = lFourObject.levelFourDescription;
        
        CGSize heightSize = [heightTextView sizeThatFits:CGSizeMake(wirdthOrHeight - 120, CGFLOAT_MAX)];
        if (heightSize.height <= 50) {
            return 68;
        }else{
            return heightSize.height+14;
        }
    }

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
        Cfe *cfe = [_masterTableData objectAtIndex:section];
        [label setText:cfe.levelOneDescription];
        [view addSubview:label];
        return view;
        
    }else{
        
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
        [label setFont:[UIFont boldSystemFontOfSize:15.0f]];
        label.numberOfLines=2;
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        CfeLevelThree *levelThird = [levelThreeArray objectAtIndex:section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:levelThird.levelThreeIdentifier];
        if (lFourtArray.count == 0) {
            label.frame = CGRectMake(10, 0, tableView.frame.size.width-194, 44);
            view.tag = section;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cfeHeaderBtnSelected:)];
            tapGesture.delegate = self;
            [view addGestureRecognizer:tapGesture];
            UIButton * btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSelected.frame = CGRectMake(tableView.frame.size.width - 42, 5, 35, 35);
            [btnSelected setImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
            [btnSelected addTarget:self action:@selector(cfeHeaderBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
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
            
            [btnAssesment addTarget:self action:@selector(cfeHeaderBtnAssesmentClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",levelThird.levelThreeIdentifier,levelThird.levelThreeIdentifier.stringValue];
            
            
            
            if (self.fromNextStep) {
                
                OBCfe * obCfe = [[self.tempSelectedList filteredArrayUsingPredicate:predicate] firstObject];
                if (obCfe) {
                    
                    currentAsessment.text=@"1";
                    currentAsessment.backgroundColor=yellowColor;
                    [[currentAsessment layer] setBorderWidth:0.5f];
                    [[currentAsessment layer] setBorderColor:[UIColor blackColor].CGColor];
                    
                    NSPredicate *predicateSel = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,@(obCfe.cfeFrameworkLevelNumber.integerValue)];
                    CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:predicateSel] firstObject];
                    btnAssesment.hidden = NO;
                    btnAssesment.userInteractionEnabled=false;
                    btnSelected.userInteractionEnabled=YES;
                    if (database) {
                        [btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                        [btnAssesment setBackgroundColor:database.assesmentCfeColor];
                        
                    }
                }
                
                OBCfe * obbtnCfe = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
                if (obbtnCfe) {
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                    
                }
                else{
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
                }
                
            }else{
                OBCfe * obCfe = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
                if (obCfe) {
                    [btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
                    predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,@(obCfe.cfeFrameworkLevelNumber.integerValue)];
                    CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:predicate] firstObject];
                    btnAssesment.hidden = NO;
                    
                    if (database) {
                        [btnAssesment setTitle:database.levelDescription forState:UIControlStateNormal];
                        [btnAssesment setBackgroundColor:database.assesmentCfeColor];
                        
                    }
                }
            }
            
            if (self.showCfeAssessment && currenCfeAssesmentDictionary
                .count>0) {
                NSNumber *count = [currenCfeAssesmentDictionary objectForKey:levelThird.levelThreeIdentifier.stringValue];
                NSString *bcolor=[currentCfeColorAssesmentDictionary objectForKey:levelThird.levelThreeIdentifier.stringValue];
                NSLog(@"%@",count);
                
                OBCfe *obcfe=[[_tempSelectedList filteredArrayUsingPredicate:predicate]  firstObject];
                if (obcfe) { count=[NSNumber numberWithInt:([count  integerValue]+[[NSNumber numberWithInt:1] integerValue])];}
                
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
-(void)cfeHeaderBtnSelected:(id)sender{
    
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
    CfeLevelThree *thirdLevel=[levelThreeArray objectAtIndex:section];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",thirdLevel.levelThreeIdentifier,thirdLevel.levelThreeIdentifier.stringValue];
    NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.tempArray removeObjectsInArray:array];
    }
    else{
        OBCfe * obCfe = [[OBCfe alloc]init];
        obCfe.cfeFrameworkItemId = thirdLevel.levelThreeIdentifier;
        obCfe.cfeFrameworkLevelNumber = @(0);
        obCfe.levelTwoIdentifier = thirdLevel.levelTwoIdentifier;
        [self.tempArray addObject:obCfe];
        predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obCfe.cfeFrameworkLevelNumber,@(obCfe.cfeFrameworkLevelNumber.integerValue)];
       CfeAssesmentDataBase * database = [[assesmentCfeArray filteredArrayUsingPredicate:predicate] firstObject];
        if (database) {
            [assesmentBtn setTitle:database.levelDescription forState:UIControlStateNormal];
            [assesmentBtn setBackgroundColor:database.assesmentCfeColor];
            
        }
    }
    _cfeNotification = self.tempArray.count;
    [self reloadTableData];
}
-(void)cfeHeaderBtnAssesmentClicked:(id)sender{
    
    [self.cfeTablePopOver dismissPopoverAnimated:YES];
    isCfeHeaderBtnAssesmentSelected = YES;
    headerAssesmentSection = [(CustomButton *)sender section];
    UIButton * btn = (UIButton *)sender;
    self.cfePopUpTableViewController = [[CfePopUpTableControllerViewController alloc] initWithNibName:NSStringFromClass([CfePopUpTableControllerViewController class]) bundle:nil];
    
    _cfeTablePopOver = [[WYPopoverController alloc]initWithContentViewController:self.self.cfePopUpTableViewController];
    self.cfePopUpTableViewController.delegate=self;
    _cfeTablePopOver.popoverContentSize = CGSizeMake(150,132);
     self.cfePopUpTableViewController.assesmentArray = assesmentCfeArray;
    [self.cfeTablePopOver presentPopoverFromRect:btn.frame inView:[btn superview] permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}
-(void)openTable:(id)sender{
    
    [self.cfeTablePopOver dismissPopoverAnimated:YES];
    isCfeHeaderBtnAssesmentSelected = NO;
    CustomButton * btn = (CustomButton *)sender;
    // NSLog(@"openTable called and Tag is %ld",(long)[sender tag]);
    assesmentselectedIndexPath = btn.indexPath;
      self.cfePopUpTableViewController = [[CfePopUpTableControllerViewController alloc] initWithNibName:NSStringFromClass([CfePopUpTableControllerViewController class]) bundle:nil];
    _cfeTablePopOver = [[WYPopoverController alloc]initWithContentViewController:self.self.cfePopUpTableViewController];
    _cfePopUpTableViewController.delegate=self;
    self.cfeTablePopOver.popoverContentSize = CGSizeMake(150,132);
    self.cfePopUpTableViewController.assesmentArray = assesmentCfeArray;
    [self.cfeTablePopOver presentPopoverFromRect:btn.frame inView:[btn superview] permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

}
- (IBAction)btnShowCurrentAssesment:(id)sender {
    _showCfeAssessment = !_showCfeAssessment; 
    if (_showCfeAssessment) {
        currentCfeAssesmentArray = [NSMutableArray array];
        [_showCurrentAssessment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [_showCurrentAssessment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showCurrentAssessment.backgroundColor=yellowColor;
    }
    else{
        currentCfeAssesmentArray = nil;
        [_showCurrentAssessment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        _showCurrentAssessment.backgroundColor=[UIColor clearColor];
        [_showCurrentAssessment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"scottish",@"type",childID,@"child_id",nil];
    
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
                                              lastSelectedChildForCfeAssesment = childID;
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
        currenCfeAssesmentDictionary = [[NSMutableDictionary alloc] init];
        currentCfeColorAssesmentDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in json[@"data"]) {
            [currenCfeAssesmentDictionary setObject:dict[@"selected_count"] forKey:dict[@"framework_item_id"]];
            CfeLevelFour *fourthLevel = [[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:dict[@"framework_item_id"] withFrameWork:@"Cfe"]firstObject];
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
                    CfeBand *cfeBand = [[CfeBand alloc]init];
                    cfeBand.levelIdentifier = fourthLevel.levelFourIdentifier;
                    cfeBand.levelNumber = dict[@"level_number"];
                    cfeBand.rgbColor = rgbColor;
                    [currentCfeAssesmentArray addObject:cfeBand];
                }
                else{
                }
            }
            if (dict[@"color"] != [NSNull null]) {
                [currentCfeColorAssesmentDictionary setObject:dict[@"color"] forKey:dict[@"framework_item_id"]];
            }
            else
            {
                [currentCfeColorAssesmentDictionary setObject:@"#ffffff00" forKey:dict[@"framework_item_id"]];
            }
        }
        NSLog(@"%@", currenCfeAssesmentDictionary);
        NSLog(@"%@", currentCfeColorAssesmentDictionary);
        [self.detailTableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    
    [self.masterTableview reloadData];
    [self.detailTableview reloadData];
}

-(void)selectedAssesment:(CfeAssesmentDataBase *)database{
    [self.cfeTablePopOver dismissPopoverAnimated:YES];

    if (isCfeHeaderBtnAssesmentSelected) {
        CfeLevelThree *lThree=[levelThreeArray objectAtIndex:headerAssesmentSection];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",lThree.levelThreeIdentifier,lThree.levelThreeIdentifier.stringValue];
        OBCfe * cfe = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
        if (cfe) {
            cfe.cfeFrameworkLevelNumber = database.levelId;
        }
        [self reloadTableData];
    }
    else{
        CfeLevelThree *lThree=[levelThreeArray objectAtIndex:assesmentselectedIndexPath.section];
        NSArray *lFourtArray=[levelFourDataDictionary objectForKey:lThree.levelThreeIdentifier];
        CfeLevelFour *lFourObject=(CfeLevelFour *)[lFourtArray objectAtIndex:assesmentselectedIndexPath.row];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cfeFrameworkItemId == %@ OR cfeFrameworkItemId == %@",lFourObject.levelFourIdentifier,lFourObject.levelFourIdentifier.stringValue];
        OBCfe * Cfe = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
        if (Cfe) {
            Cfe.cfeFrameworkLevelNumber = database.levelId;
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



- (IBAction)showCurrentAssessment:(id)sender {
    
    _showCfeAssessment = !_showCfeAssessment;
    if (_showCfeAssessment) {
        currentCfeAssesmentArray = [NSMutableArray array];
        [_showCurrentAssessment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [_showCurrentAssessment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showCurrentAssessment.backgroundColor=yellowColor;
    }
    else{
        currentCfeAssesmentArray = nil;
        [_showCurrentAssessment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        _showCurrentAssessment.backgroundColor=[UIColor clearColor];
        [_showCurrentAssessment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"scottish",@"type",childID,@"child_id",nil];
    
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
                                              lastSelectedChildForCfeAssesment = childID;
                                              [self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                          }];
    
    [postDataTask resume];

}
- (IBAction)cancel_action:(id)sender {
   [self.delegate closeButtonAction:sender];

}

- (IBAction)segmentedControlAction:(id)sender {
     segValue=[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    [self filterDataBaseOnSegment];
    
}
- (IBAction)done_action:(id)sender {
    self.selectedList = self.tempArray;

     [self.delegate doneButtonAction:sender];
}
@end
