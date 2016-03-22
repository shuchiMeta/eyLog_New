//
//  EcatViewController.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 11/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatViewController.h"
#import "EcatDetailsTableViewCell.h"
#import "EcatFramework.h"
#import "Ecat.h"
#import "EcatArea.h"
#import "EcatAspect.h"
#import "EcatStatement.h"
#import "EcatAreaClass.h"
#import "EcatAspectClass.h"
#import "EcatStatementClass.h"
#import "AppDelegate.h"
#import "APICallManager.h"
#import "OBEcat.h"
@interface EcatViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *ecatAspectDictionary;
    NSMutableDictionary *ecatStatementDictionary;
    NSArray *statementArray;
    NSNumber *currentAspectIdentifier;
    NSIndexPath *selectedIndexPath;
    NSMutableArray * currentEcatAssesmentArray;
    NSMutableDictionary *currentEcatAssesmentDictionary;
    NSMutableDictionary *currentEcatColorAssesmentDictionary;
    NSNumber *lastSelectedChildForEcatAssesment;
}
@property (nonatomic, assign) BOOL showEcatAssessment;
@end

@implementation EcatViewController


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
    // Do any additional setup after loading the view.
    [self.detailTable registerNib:[UINib nibWithNibName:NSStringFromClass([EcatDetailsTableViewCell class]) bundle:nil] forCellReuseIdentifier:ecatTableViewCellId];
    self.detailTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    ecatAspectDictionary=[[NSMutableDictionary alloc]init];
    ecatStatementDictionary=[[NSMutableDictionary alloc]init];
    statementArray=[[NSArray alloc]init];
    selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    for(Ecat *ecat in _ecatArray){
        NSArray *level2Array=[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withLevelOneIdentifier:ecat.levelOneIdentifier withFramework:@"Ecat"];
        for (EcatAspect *levelTwoData in level2Array) {
            NSArray *tempLevel3Array=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withlevelTwoIdentifier:levelTwoData.levelTwoIdentifier withFramework:@"Ecat"];
            if(tempLevel3Array){
                [ecatStatementDictionary setObject:tempLevel3Array forKey:levelTwoData.levelTwoIdentifier];
            }
        }
        [ecatAspectDictionary setObject:level2Array forKey:ecat.levelOneIdentifier];
    }

    NSArray *aspectArray = [ecatAspectDictionary objectForKey:((Ecat *)[self.ecatArray objectAtIndex:0]).levelOneIdentifier];
    currentAspectIdentifier = ((EcatAspect *)aspectArray[0]).levelTwoIdentifier;
    statementArray=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withlevelTwoIdentifier:currentAspectIdentifier withFramework:@"Ecat"];
    _btnCancel.layer.cornerRadius=5;
    _btnCancel.layer.masksToBounds=true;
    _btndone.layer.cornerRadius=5;
    _btndone.layer.masksToBounds=true;
    self.ecatSegment.selectedSegmentIndex=[self.selectedLevel integerValue];
  
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        [self.btnShowCurrentAssesment setUserInteractionEnabled:NO];
        [self.btnShowCurrentAssesment setHidden:YES];
    }
    else
    {
        [self.btnShowCurrentAssesment setUserInteractionEnabled:YES];
        [self.btnShowCurrentAssesment setHidden:NO];
        self.btnShowCurrentAssesment.layer.borderColor=[UIColor grayColor].CGColor;
        self.btnShowCurrentAssesment.layer.borderWidth=1.0f;
        self.btnShowCurrentAssesment.layer.cornerRadius=4.5f;
    }

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if(lastSelectedChildForEcatAssesment && [APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
    {
        if(![lastSelectedChildForEcatAssesment isEqualToNumber:[APICallManager sharedNetworkSingleton].cacheChild.childId])
        {
            self.showEcatAssessment = NO;
            currentEcatAssesmentArray = nil;
            [_btnShowCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
            [self.btnShowCurrentAssesment setUserInteractionEnabled:YES];
            //[self.assessmentSelectionLabel setHidden:YES];
            [self.btnShowCurrentAssesment setHidden:NO];
            [self reloadTableData];
        }
    }
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        lastSelectedChildForEcatAssesment = nil;
        self.btnShowCurrentAssesment = NO;
        [self.btnShowCurrentAssesment setUserInteractionEnabled:NO];
        // [self.assessmentSelectionLabel setHidden:YES];
        [self.btnShowCurrentAssesment setHidden:YES];
        [self reloadTableData];
    }
    else
    {
        [self.btnShowCurrentAssesment setUserInteractionEnabled:YES];
        [self.btnShowCurrentAssesment setHidden:NO];
     }

    if (_showEcatAssessment) {
        [_btnShowCurrentAssesment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        // [self.assessmentSelectionLabel setHidden:NO];
    }
    else{
        [_btnShowCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        //[self.assessmentSelectionLabel setHidden:YES];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==1) {
        return _ecatArray.count;
    }else{
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        Ecat *ecat = [self.ecatArray objectAtIndex:section];
        return ((NSArray *)[ecatAspectDictionary objectForKey:ecat.levelOneIdentifier]).count;

    }else{

        return statementArray.count;
    }

    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag==1) {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.numberOfLines=2;
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        Ecat *ecat = [self.ecatArray objectAtIndex:indexPath.section];
        NSArray *levelTwArray = [ecatAspectDictionary objectForKey:ecat.levelOneIdentifier];
        EcatAspect *ecatAspect=[levelTwArray objectAtIndex:indexPath.row];
        cell.textLabel.text= ecatAspect.levelTwoDescription;
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithRed:193.0f/255.0f green:196.0/255.0f blue:84.0/255.0f alpha:1]];
        [cell setSelectedBackgroundView:bgColorView];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"levelTwoIdentifier == %@",ecatAspect.levelTwoIdentifier];
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
                cell.textLabel.text= ecatAspect.levelTwoDescription;
            }
        }
        else if ([selectedIndexPath isEqual:indexPath]){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 22,10, 22,22)];
            imv.image=[UIImage imageNamed:@"right_arrow.png"];
            [cell addSubview:imv];
            cell.accessoryView = nil;
            cell.textLabel.text= ecatAspect.levelTwoDescription;
        }
        return cell;
    }else{
        EcatDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ecatTableViewCellId];
        [cell.btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];

        EcatStatement *state=(EcatStatement *)[statementArray objectAtIndex:indexPath.row];
        cell.lblDescription.text=state.levelThreeDescription;
        if ([[[UIDevice currentDevice] systemVersion]floatValue]<8.0) {

        }else{
            [cell.lblDescription sizeToFit];}

        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectedBackgroundView:bgColorView];
        [cell.btnSelected addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ecatFrameworkItemId == %@ OR ecatFrameworkItemId == %@",state.levelThreeIdentifier,state.levelThreeIdentifier.stringValue];
        OBEcat * obEcat = [[self.tempArray filteredArrayUsingPredicate:predicate] firstObject];
        if (obEcat) {
            cell.isRowSelected=YES;
            [cell.btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        }
        else{
            cell.isRowSelected=NO;
            [cell.btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        }
        if (self.showEcatAssessment && currentEcatAssesmentDictionary.count>0) {
            NSLog(@"priting object in currentAssesment %@ and key =%@",[currentEcatAssesmentDictionary valueForKey:state.levelThreeIdentifier.stringValue],state.levelThreeIdentifier.stringValue);
            NSNumber *count = [currentEcatAssesmentDictionary valueForKey:state.levelThreeIdentifier.stringValue];
            NSLog(@"%@",count);
            cell.lblAssesment.text = [NSString stringWithFormat:@"%@",(count?count:@"")];

            if (count > 0) {
                cell.lblAssesment.layer.cornerRadius= cell.lblAssesment.frame.size.width/2;
                cell.lblAssesment.layer.masksToBounds=YES;
                cell.lblAssesment.backgroundColor=yellowColor;
                [[cell.lblAssesment layer] setBorderWidth:0.5f];
                [[cell.lblAssesment layer] setBorderColor:[UIColor blackColor].CGColor];
            }
            else{
                cell.lblAssesment.backgroundColor=[UIColor clearColor];
                [[cell.lblAssesment layer] setBorderWidth:0.5f];
                [[cell.lblAssesment layer] setBorderColor:[UIColor  clearColor].CGColor];
            }
        }
        else{
            cell.lblAssesment.text = @"";
            cell.lblAssesment.backgroundColor=[UIColor clearColor];
            [[cell.lblAssesment layer] setBorderWidth:0.5f];
            [[cell.lblAssesment layer] setBorderColor:[UIColor  clearColor].CGColor];
        }


        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1){
        selectedIndexPath =indexPath;
        NSArray *aspectArray = [ecatAspectDictionary objectForKey:((Ecat *)[self.ecatArray objectAtIndex:indexPath.section]).levelOneIdentifier];
        currentAspectIdentifier = ((EcatAspect *)aspectArray[indexPath.row]).levelTwoIdentifier;
        statementArray=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withlevelTwoIdentifier:currentAspectIdentifier withFramework:@"Ecat"];
        [self.detailTable setContentOffset:CGPointZero animated:YES];
        [self reloadTableData];
    }else if(tableView.tag == 2){
          EcatDetailsTableViewCell *cell = (EcatDetailsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
          [self selectEcatDetailsTableCell:cell];
     }
}
-(void)selectedBtnClicked:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self selectEcatDetailsTableCell:[[[btn superview] superview] superview]];
    }
    else{
        [self selectEcatDetailsTableCell:[[btn superview] superview]];
    }
}


-(void)selectEcatDetailsTableCell:(EcatDetailsTableViewCell *)cell{

    NSIndexPath * indexPath = [self.detailTable indexPathForCell:cell];
    if(cell.isRowSelected){
        cell.isRowSelected = NO;
        [cell.btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    }else{
        cell.isRowSelected=YES;
        [cell.btnSelected setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
    }

    EcatStatement *state=(EcatStatement *)[statementArray objectAtIndex:indexPath.row];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ecatFrameworkItemId == %@ OR ecatFrameworkItemId == %@",state.levelThreeIdentifier,state.levelThreeIdentifier.stringValue];
    NSArray * array = [self.tempArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        [self.tempArray removeObjectsInArray:array];
        //[cell.btnAssesment setTitle:@"" forState:UIControlStateNormal];
        //        [cell.btnAssesment setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        OBEcat * obEcat = [[OBEcat alloc]init];
        obEcat.ecatFrameworkItemId = state.levelThreeIdentifier;
        obEcat.ecatFrameworkLevelNumber = @(0);
        obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
        [self.tempArray addObject:obEcat];
       // predicate = [NSPredicate predicateWithFormat:@"levelId == %@ OR levelId == %@",obEcat.ecatFrameworkLevelNumber,@(obEcat.ecatFrameworkLevelNumber.integerValue)];

    }
    NSLog(@"array Count %d",self.tempArray.count);
    _ecatNotification = self.tempArray.count;
    [self reloadTableData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        return 50;
    }else{
        return 70;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        return 50;
    }else{
        return 1;
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
        Ecat *ecat = [self.ecatArray objectAtIndex:section];
        [label setText:ecat.levelOneDescription];
        [view addSubview:label];
        return view;

    }else{

    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showCurrent:(id)sender {
    _showEcatAssessment = !_showEcatAssessment;
    if (_showEcatAssessment) {

        currentEcatAssesmentArray = [NSMutableArray array];
        [_btnShowCurrentAssesment setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
        [_btnShowCurrentAssesment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnShowCurrentAssesment.backgroundColor=yellowColor;
    }
    else{
        currentEcatAssesmentArray = nil;
        [_btnShowCurrentAssesment setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        _btnShowCurrentAssesment.backgroundColor=[UIColor clearColor];
        [_btnShowCurrentAssesment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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

    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"ecat",@"type",childID,@"child_id",nil];

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
                                              lastSelectedChildForEcatAssesment = childID;
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
        currentEcatAssesmentDictionary = [[NSMutableDictionary alloc] init];
        currentEcatColorAssesmentDictionary = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in json[@"data"]) {
            [currentEcatAssesmentDictionary setValue:dict[@"count"] forKey:[dict[@"statement"] stringValue]];
            EcatStatement *fourthLevel=[[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:dict[@"statement"] withFramework:@"Ecat"] firstObject];
       //     EcatStatement *fourthLevel = [[EcatStatement fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:dict[@"framework_item_id"] withFrameWork:@"Ecat"]firstObject];
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
//                    MontessoryBand *monteBand = [[MontessoryBand alloc]init];
//                    monteBand.levelIdentifier = fourthLevel.levelFourIdentifier;
//                    monteBand.levelNumber = dict[@"level_number"];
//                    monteBand.rgbColor = rgbColor;
//                    [currentEcatAssesmentArray addObject:monteBand];
                }
                else{
                }
            }
            if (dict[@"color"] != [NSNull null]) {
                [currentEcatColorAssesmentDictionary setObject:dict[@"color"] forKey:dict[@"statement"]];
            }
            else
            {
                [currentEcatColorAssesmentDictionary setObject:@"#ffffff00" forKey:dict[@"statement"]];
            }
        }
        NSLog(@"%@", currentEcatAssesmentDictionary);
        NSLog(@"%@", currentEcatColorAssesmentDictionary);
        [self.detailTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

    [self.table reloadData];
    [self.detailTable reloadData];
}

- (IBAction)actionBtnCancel:(id)sender {
    [self.delegate closeButtonAction:sender];
}

- (IBAction)actionBtnDone:(id)sender {
    self.selectedList = self.tempArray;
    self.selectedLevel=[NSNumber numberWithInteger:self.ecatSegment.selectedSegmentIndex];
    [self.delegate doneButtonAction:sender];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void) orientationChanged:(NSNotification *)note
{

    UIDevice * device = note.object;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
          //  self.view.frame=CGRectMake(10, 80, screenWidth-40, screenHeight-150);
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
          //  self.view.frame=CGRectMake(10, 80, screenWidth-40, screenHeight-150);
            break;
        case UIDeviceOrientationLandscapeLeft:
          //  self.view.frame=CGRectMake(10, 80, screenWidth-40, screenHeight-150);
            break;
        case UIDeviceOrientationLandscapeRight:
            break;
         //  self.view.frame=CGRectMake(10, 80, screenWidth-40, screenHeight-150);

        default:
            break;
    };
    [self reloadTableData];

}
- (IBAction)segmentValuechanged:(id)sender {
}
@end
