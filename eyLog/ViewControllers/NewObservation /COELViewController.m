//
//  COELViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "COELViewController.h"
#import "COELTableViewCell.h"
#import "Framework.h"
#import "AppDelegate.h"
#import "Aspect.h"
#import "Statement.h"
#import "COBaseClass.h"
#import "APICallManager.h"
#import "Utils.h"
#import "OBCoel.h"


static NSString *kPlayingAndLearning= @"1";// @"Playing and Learning";
static NSString *KActiveLearning=  @"17";// @"Active Learning";
static NSString *KCreatingAndThinkingCritical= @"31";//@"Creating and thinking critically";

@interface COELViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *aspectDictionary;
    NSMutableDictionary *statementDictionary;
    NSArray *frameworkArray;
    NSArray *selectedSegmentArea;
    NSInteger pageNumber;
    
    NSMutableDictionary *currentAssessmentDictionary;
    NSMutableDictionary *currentAssessmentColorDictionary;
}
@property (strong, nonatomic) IBOutlet UIButton *showCurrentAssessmentButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL showAssessment;

@end

@implementation COELViewController

-(NSMutableArray *)selectedList{
    if (!_selectedList) {
        _selectedList = [[NSMutableArray alloc] init];
    }
    return _selectedList;
}

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
    pageNumber=0;
    
    self.showAssessment = NO;
    
    frameworkArray=[Framework fetchframeworkInContext:[AppDelegate context] withFrameWork:@"COEL"];
    aspectDictionary=[[NSMutableDictionary alloc]init];
    statementDictionary=[[NSMutableDictionary alloc]init];
    
    for (Framework *framework in frameworkArray)
    {
        NSArray *aspectArray=[Aspect fetchAspectInContext:[AppDelegate context] withAreaIdentifier:framework.areaIdentifier withFrameWork:@"COEL"];
        for (Aspect *aspect in aspectArray)
        {
            NSArray *statementArray=[Statement fetchStatementInContext:[AppDelegate context] withAspectIdentifier:aspect.aspectIdentifier withFrameWork:@"COEL"];
            [statementDictionary setObject:statementArray forKey:aspect.aspectIdentifier];
        }
        [aspectDictionary setObject:aspectArray forKey:framework.areaIdentifier];
    }
    
    // To disable current assesment button when more than one child is selected
    if([APICallManager sharedNetworkSingleton].cacheChildren.count > 1)
    {
        [self.showCurrentAssessmentButton setUserInteractionEnabled:NO];
        [self.showCurrentAssessmentButton setHidden:YES];
    }
    else
    {
        [self.showCurrentAssessmentButton setUserInteractionEnabled:YES];
        [self.showCurrentAssessmentButton setHidden:NO];
        self.showCurrentAssessmentButton.layer.borderColor=[UIColor grayColor].CGColor;
        self.showCurrentAssessmentButton.layer.borderWidth=1.0f;
        self.showCurrentAssessmentButton.layer.cornerRadius=4.5f;
    }
    
    self.doneButton.layer.cornerRadius = 10.0;
    self.cancelButton.layer.cornerRadius = 10.0;
    
    [self segmentAction:nil];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

-(NSArray *)getSelectedSegmentArrayFromAllCOEL:(NSArray *)coelArray withAreaIdentifierType:(NSString *)areaIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"areaIdentifier == %d", [areaIdentifier integerValue]];
   return [coelArray filteredArrayUsingPredicate:predicate];
}


- (IBAction)segmentAction:(id)sender
{
    if(self.segmentControl.selectedSegmentIndex==0)
    {
        selectedSegmentArea=[self getSelectedSegmentArrayFromAllCOEL:frameworkArray withAreaIdentifierType:kPlayingAndLearning];
    }
    else if(self.segmentControl.selectedSegmentIndex==1)
    {
        selectedSegmentArea=[self getSelectedSegmentArrayFromAllCOEL:frameworkArray withAreaIdentifierType:KActiveLearning];
    }
    else if (self.segmentControl.selectedSegmentIndex==2)
    {
        selectedSegmentArea=[self getSelectedSegmentArrayFromAllCOEL:frameworkArray withAreaIdentifierType:KCreatingAndThinkingCritical];
    }
    else
    {
        selectedSegmentArea=[self getSelectedSegmentArrayFromAllCOEL:frameworkArray withAreaIdentifierType:kPlayingAndLearning];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ((NSArray *)[aspectDictionary objectForKey:((Framework *)[selectedSegmentArea lastObject]).areaIdentifier]).count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *aspectArray=(NSArray *)[aspectDictionary objectForKey:((Framework *)[selectedSegmentArea lastObject]).areaIdentifier];
    Aspect *aspect=[aspectArray objectAtIndex:section];
    NSArray *statementArray=((NSArray *)[statementDictionary objectForKey:aspect.aspectIdentifier]);;
    return statementArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *popupTableViewCellId = @"COELTableViewCellId";
    
    COELTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popupTableViewCellId forIndexPath:indexPath];
    
    NSArray *aspectArray=(NSArray *)[aspectDictionary objectForKey:((Framework *)[selectedSegmentArea lastObject]).areaIdentifier];
    Aspect *aspect=[aspectArray objectAtIndex:indexPath.section];
    NSArray *statementArray=((NSArray *)[statementDictionary objectForKey:aspect.aspectIdentifier]);;
    
    Statement *statementObject = (Statement *)[statementArray objectAtIndex:indexPath.row];
    cell.CoelLabel.text=statementObject.statementDesc;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if(self.selectedList.count > 0)
    {
        NSObject *tempObj;
        tempObj = [self.selectedList objectAtIndex:0];
        if([tempObj isKindOfClass:[OBCoel class]])
        {
            for(int i = 0 ; i < self.selectedList.count ; i++)
            {
                OBCoel *tempObj = [self.selectedList objectAtIndex:i];
                [tempArray addObject:tempObj.coelId];
            }
        }
        else
        {
            tempArray = self.selectedList;
        }
    }
    else
    {
        tempArray = self.selectedList;
    }
    
    if ([tempArray containsObject:statementObject.statementIdentifier.stringValue]) {
        cell.selection_State=YES;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
    }
    else
    {
        cell.selection_State=NO;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    }
    
    cell.selectionButton.userInteractionEnabled = NO;
    
     NSNumber *count = [currentAssessmentDictionary objectForKey:statementObject.statementIdentifier];
    
    if (self.showAssessment && count>0)
    {
        cell.assessmentNumber.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
        cell.assessmentNumber.layer.cornerRadius= cell.assessmentNumber.frame.size.width/2;
        cell.assessmentNumber.clipsToBounds = YES;
        //cell.assessmentNumber.layer.masksToBounds = YES;
        cell.assessmentNumber.backgroundColor= yellowColor;// [yellowColor CGColor];
    }
    else
    {
        cell.assessmentNumber.text = @"";
        cell.assessmentNumber.backgroundColor= [UIColor clearColor];//[ CGColor];
    }
    
//    if (self.showAssessment && currentAssessmentDictionary.count>0)
//    {
//        NSNumber *count = [currentAssessmentDictionary objectForKey:statementObject.statementIdentifier];
//        cell.assessmentNumber.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
//        if (count > 0) {
//            
//            cell.assessmentNumber.layer.cornerRadius=20.0f;
//            cell.assessmentNumber.layer.backgroundColor= [yellowColor CGColor];//   [Utils colorFromHexString:[currentAssessmentColorDictionary objectForKey:statementObject.statementIdentifier]].CGColor;
//        }
//    }
//    else
//    {
//        cell.assessmentNumber.text = @"";
//        cell.assessmentNumber.layer.backgroundColor= [[UIColor clearColor] CGColor];
//    }
    
    return  cell;
}

-(BOOL) checkIfExists:(NSString *)Index
{
    for(int i = 0 ; i < self.selectedList.count ; i++)
    {
        OBCoel *tempObj = [self.selectedList objectAtIndex:i];
        if([tempObj.coelId intValue] == [Index intValue])
        {
            return true;
        }
    }
    return  false;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, tableView.frame.size.width, 20)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSArray *aspectArray=(NSArray *)[aspectDictionary objectForKey:((Framework *)[selectedSegmentArea lastObject]).areaIdentifier];
    Aspect *aspect=[aspectArray objectAtIndex:section];
    [label setText:aspect.aspectDesc];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    //[view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"Selected %d",indexPath.row);
    
    COELTableViewCell *cell = (COELTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if(self.selectedList.count > 0)
    {
        NSObject *tempObj;
        tempObj = [self.selectedList objectAtIndex:0];
        if([tempObj isKindOfClass:[OBCoel class]])
        {
            for(int i = 0 ; i < self.selectedList.count ; i++)
            {
                OBCoel *tempObj = [self.selectedList objectAtIndex:i];
                [tempArray addObject:tempObj.coelId];
            }
        }
        else
        {
            tempArray = self.selectedList;
        }
    }
    else
    {
        tempArray = self.selectedList;
    }
    
    NSArray *aspectArray=(NSArray *)[aspectDictionary objectForKey:((Framework *)[selectedSegmentArea lastObject]).areaIdentifier];
    Aspect *aspect=[aspectArray objectAtIndex:indexPath.section];
    NSArray *statementArray=((NSArray *)[statementDictionary objectForKey:aspect.aspectIdentifier]);;
    Statement *statementObject = (Statement *)[statementArray objectAtIndex:indexPath.row];
    NSNumber *count = [currentAssessmentDictionary objectForKey:statementObject.statementIdentifier];
    
    if (self.showAssessment && count>0)
    {
        cell.assessmentNumber.text = [NSString stringWithFormat:@"%@",(count?count:@"")];
        cell.assessmentNumber.layer.cornerRadius= cell.assessmentNumber.frame.size.width/2;
        cell.assessmentNumber.clipsToBounds = YES;
        //cell.assessmentNumber.layer.masksToBounds = YES;
        cell.assessmentNumber.backgroundColor= yellowColor;// [yellowColor CGColor];
    }
    else
    {
        cell.assessmentNumber.text = @"";
        cell.assessmentNumber.backgroundColor= [UIColor clearColor];//[ CGColor];
    }
    
    if(cell.selection_State)
    {
        cell.selection_State=NO;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        
        [tempArray removeObject:statementObject.statementIdentifier.stringValue];
        self.selectedList = tempArray;
    }
    else
    {
        cell.selection_State=YES;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        
        
        [tempArray addObject:statementObject.statementIdentifier.stringValue];
        self.selectedList = tempArray;
    }
    
    if(self.showAssessment)
        [tableView reloadData];
}


#pragma mark - Navigation
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doneAction:(id)sender
{
//    [APICallManager sharedNetworkSingleton].selectedCOELArray = selectedList;
//    NSLog(@"%@",self.selectedList);
    [self.delegate doneButtonAction:sender];
}

- (IBAction)closeAction:(id)sender
{
    [self.delegate closeButtonAction:sender];
}

- (IBAction)showCurrentAssessment:(id)sender {
    
    self.showAssessment = !self.showAssessment;
    
    if (self.showAssessment)
    {
        [_showCurrentAssessmentButton setTitle:@"Hide Current Assesment" forState:UIControlStateNormal];
    }
    else{
        currentAssessmentDictionary = nil;
        currentAssessmentColorDictionary = nil;
        [_showCurrentAssessmentButton setTitle:@"Show Current Assesment" forState:UIControlStateNormal];
        [self.tableView reloadData];
        return;
    }
    
    
    self.showAssessment = YES;
    
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSNumber *childID = [APICallManager sharedNetworkSingleton].cacheChild.childId;
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading..";
    
//    NSString *serverURL = @"https://demo.eylog.co.uk/trunk/";
     NSString *serverURL = [APICallManager sharedNetworkSingleton].serverURL;
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/current_assessments",serverURL];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",@"coel",@"type",childID,@"child_id",nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                                  
                                                  // Displaying Hardcoded Error message for now to be changed later
                                                  //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  
                                                  
                                                  
                                                  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                                  return;
                                              }
                                              [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                                              [self performSelectorInBackground:@selector(backgroundLoadData:) withObject:data];
                                          }];
    
    [postDataTask resume];
}

-(void)closeAlert
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)backgroundLoadData:(NSData *)data
{
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"%@", json);
    NSLog(@"%@", json[@"data"]);
    
    if([json[@"status"] isEqualToString:@"success"])
    {
        currentAssessmentDictionary = [[NSMutableDictionary alloc] init];
        currentAssessmentColorDictionary = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *dict in json[@"data"]) {
            [currentAssessmentDictionary setObject:dict[@"count"] forKey:dict[@"statement"]];
            [currentAssessmentColorDictionary setObject:dict[@"count"] forKey:dict[@"color"]];
        }
        
        NSLog(@"%@", currentAssessmentDictionary);
        NSLog(@"%@", currentAssessmentColorDictionary);
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
    
    
    //    OBObservation *observation=[[OBObservation alloc]initWithDictionary:jsonDict];
    //
    //    ((OBData *)[observation.data objectAtIndex:0]).observationId;
    //
    //    if([observation.status isEqualToString:@"success"])
    //    {
    //        observationArray=observation.data;
    //        [self.tableView reloadData];
    //    }
}


@end