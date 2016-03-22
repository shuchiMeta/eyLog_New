//
//  ObservationViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ObservationViewController.h"
#import "PopupTableViewCell.h"
#import "AppDelegate.h"
#import "NewObservationAttachment.h"
#import "APICallManager.h"
#import "EYFSAssessmentViewController.h"
#import "WYPopoverController.h"
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

NSString* const kMontessoriPop=@"Montessori";
NSString* const kEYFSPop=@"EYFS";
NSString* const kCfePop=@"Cfe";
@interface ObservationViewController ()<UITableViewDataSource,UITableViewDelegate, eyfsPopOverDelegate, WYPopoverControllerDelegate,montessoryPopOverDelegate,cfePopOverDelegate>
{
    NSArray *attachmentArray;
    NSArray *thumbnailNames;
    NSString *currentInstance;
    NSMutableArray *montessoriArray;
    NSMutableArray *cfeArray;
    NSMutableArray *selectedMontessoriArray;
    NSMutableArray *selectedCfeArray;

    NSMutableArray *selectedEYFS;
}

@property (strong,nonatomic) EYFSAssessmentViewController *eyfsAssessmentVC;
@property (strong,nonatomic) CFEAssessmentViewController *cfeAssessmentVC;

@property (strong,nonatomic) MontessoryViewController *monteAssesmentVC;
@property (strong,nonatomic) WYPopoverController *eyfsAssessmentPopOverVC;
@property (strong,nonatomic) WYPopoverController *monteAssesmentPopOverVC;

@end

@implementation ObservationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib
{
//   [self loadObservationAttachment];
}

- (void)viewDidLoad
{
    self.textView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.textView.layer.borderWidth=1.0f;
    self.button.layer.cornerRadius=10.0f;
    self.closeButton.layer.cornerRadius = 10.0f;
    self.eyfsAssessmentButton.layer.cornerRadius = 10.0f;
    self.eyfsAssessmentButton.hidden = !self.showEYFS;
    self.montessoriButton.layer.cornerRadius=10.0f;
    self.montessoriButton.hidden=!self.showMontessori;
    selectedMontessoriArray=[[NSMutableArray alloc]init];
    selectedCfeArray=[[NSMutableArray alloc]init];

  
    if([[[APICallManager sharedNetworkSingleton] settingObject].frameworkType isEqualToString:@"cfe"])
    {
        [self.eyfsAssessmentButton setTitle:@"CFE Assessment" forState:UIControlStateNormal];
    }
    else
    {
        [self.eyfsAssessmentButton setTitle:@"EYFS Assessment" forState:UIControlStateNormal];

    }
    
    [super viewDidLoad];
      montessoriArray = [MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withFramework:@"Montessori"];
       cfeArray = [CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withFramework:@"Cfe"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadObservationAttachment];
}

-(void)loadObservationAttachment
{
    NSNumber *childId=[APICallManager sharedNetworkSingleton].cacheChild.childId;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    attachmentArray = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate childContext] withPractitionerId:practitionerId withChildId:childId withObservationId:self.deviceUUID];
    
    if (self.isDraft) {
        NSError *error;
        NSString *thumbnailPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[Utils getDraftMediaImages],self.deviceUUID]];
        thumbnailNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:thumbnailPath error:&error];
    }
    
    NSLog(@"%lu Attachments Loaded for deviceUUID : %@", (unsigned long)[attachmentArray count], self.deviceUUID);
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setEylNewObservationAttachmentArray:(NSMutableArray *)eylNewObservationAttachmentArray{
    _eylNewObservationAttachmentArray = eylNewObservationAttachmentArray;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _eylNewObservationAttachmentArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *popupTableViewCellId = @"PopupTableViewCellId";
    PopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popupTableViewCellId];
    
    EYLNewObservationAttachment * attachment = [_eylNewObservationAttachmentArray objectAtIndex:indexPath.row];
    cell.imageView.image = attachment.eylMedia.image;
//    if ([attachment.attachmentType isEqualToString:kUTTypeImageType]) {
//        cell.playIcon.hidden = YES;
//        cell.playIcon.image = nil;
//    }
//    else{
        cell.playIcon.hidden = NO;
        cell.playIcon.image = [UIImage imageNamed:@"play"];
   // }
    
    return cell;
}


-(UIImage *)thumbnailFromMovieAtURL:(NSString *)url {
    
    UIImage *image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@.png",[url stringByDeletingPathExtension]]];
    
    return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.textView resignFirstResponder];
}
- (IBAction)doneAction:(id)sender
{
    NSLog(@"Observation Done Called");
    [self.delegate doneButtonAction:sender];
}
- (IBAction)closeAction:(id)sender
{
    NSLog(@"Observation Close Called");
    [self.delegate closeButtonAction:sender];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//        if([title isEqualToString:@"Ok"])
//        {
//          //  [self.delegate closeButtonAction:sender];
//            NSLog(@"Nothing to do here");
//           
//        }
//}


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

- (IBAction)eyfsAssessmentClicked:(UIButton *)sender {
  
    [self.textView resignFirstResponder];
    if([[[APICallManager sharedNetworkSingleton] settingObject].frameworkType isEqualToString:@"cfe"])
    {
        self.eyfsAssessmentPopOverVC=nil;
        if (!self.eyfsAssessmentPopOverVC)
        {
            self.cfeAssessmentVC = [[CFEAssessmentViewController alloc] initWithNibName:@"CFEAssessmentViewController" bundle:nil];
            
            self.eyfsAssessmentPopOverVC = [[WYPopoverController alloc] initWithContentViewController:self.cfeAssessmentVC];
            self.cfeAssessmentVC.fromNextStep=YES;
            self.cfeAssessmentVC.delegate=self;
            self.cfeAssessmentVC.cfeArray = cfeArray;
            self.cfeAssessmentVC.tempSelectedList=[NSMutableArray new];
            NSLog(@"cfe data %lu",(unsigned long)self.cfeData.count);
            self.eyfsAssessmentPopOverVC=[self setPopoverProperties:self.eyfsAssessmentPopOverVC];
        }
        currentInstance=kCfePop;
        if (selectedCfeArray.count>0) {
            self.cfeAssessmentVC.selectedList=[NSMutableArray new];
        }
        self.eyfsAssessmentPopOverVC.popoverContentSize=CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
        CGRect rect=CGRectMake(0, 0, 0, 0);
        [self.eyfsAssessmentPopOverVC presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];

    }
    else
    {
    self.eyfsAssessmentPopOverVC=nil;
    if (!self.eyfsAssessmentPopOverVC)
    {
        self.eyfsAssessmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EYFSAssessmentViewControllerId"];
        self.eyfsAssessmentPopOverVC = [[WYPopoverController alloc] initWithContentViewController:self.eyfsAssessmentVC];
        self.eyfsAssessmentVC.delegate=self;
        self.eyfsAssessmentVC.isFromNextSteps = YES;
        self.eyfsAssessmentPopOverVC=[self setPopoverProperties:self.eyfsAssessmentPopOverVC];
    }
    self.eyfsAssessmentVC.tmpSelectedArray=self.eyfsData;
    self.eyfsAssessmentVC.selectedList=[NSMutableArray new];
    currentInstance=kEYFSPop;
    self.eyfsAssessmentPopOverVC.popoverContentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0,0,0,0);
    [self.eyfsAssessmentPopOverVC presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
    }
    
}
- (IBAction)montessoriAssesment:(id)sender {
    
    [self.textView resignFirstResponder];
    self.monteAssesmentVC=nil;
    if (!self.monteAssesmentVC) {
        _monteAssesmentVC=[self.storyboard instantiateViewControllerWithIdentifier:@"montessoryViewControllerId"];
        _monteAssesmentPopOverVC=[[WYPopoverController alloc] initWithContentViewController:self.monteAssesmentVC];
        self.monteAssesmentVC.delegate=self;
        self.monteAssesmentVC.fromNextStep=YES;
        self.monteAssesmentVC.montessoriArray = montessoriArray;
        self.monteAssesmentVC.tempSelectedList=[NSMutableArray new];
        NSLog(@"Montessori Data paased to Montessori %lu",(unsigned long)self.montessoriData.count);
        self.monteAssesmentPopOverVC=[self setPopoverProperties:self.monteAssesmentPopOverVC];
    }
    currentInstance=kMontessoriPop;
    if (selectedMontessoriArray.count>0) {
        self.monteAssesmentVC.selectedList=[NSMutableArray new];
    }
    self.monteAssesmentPopOverVC.popoverContentSize=CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    CGRect rect=CGRectMake(0, 0, 0, 0);
    [self.monteAssesmentPopOverVC presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionNone animated:YES];
}

-(void)closeButtonAction:(id)sender
{
    [self.eyfsAssessmentVC.textView resignFirstResponder];
    [self.eyfsAssessmentPopOverVC dismissPopoverAnimated:YES];
    [self.monteAssesmentPopOverVC dismissPopoverAnimated:YES];
}

-(void)doneButtonAction:(id)sender
{
    NSString *textStatement = @"";
//    self.textView.text=nil;
    selectedEYFS = self.eyfsAssessmentVC.selectedList;
    selectedMontessoriArray=self.monteAssesmentVC.selectedList;
       selectedCfeArray=self.cfeAssessmentVC.selectedList;

    if (selectedEYFS.count>0) {
        
       // self.textView.text = nil;
        NSArray *selectedList = selectedEYFS;
        
        for (OBEyfs *obEyfs in selectedList) {
            Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:statement.ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
            
            Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
            
            textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc, statement.statementDesc];
        }
        
        if(textStatement.length > 0)
            self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, textStatement];
        
      //  [self.eyfsAssessmentVC.textView resignFirstResponder];
        //[self.eyfsAssessmentPopOverVC dismissPopoverAnimated:YES];
        
    }
    [self.eyfsAssessmentVC.textView resignFirstResponder];
    [self.eyfsAssessmentPopOverVC dismissPopoverAnimated:YES];
    if (selectedMontessoriArray.count>0){
        
       // self.textView.text=nil;
        textStatement=@"";
        for (OBMontessori *obMonte in selectedMontessoriArray) {
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
                 textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
            }else{
                 textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
            }
            
        }
        if (textStatement.length>0) {
            self.textView.text=[NSString stringWithFormat:@"\n%@\n%@",self.textView.text,textStatement];
        }
        NSLog(@"Self Data count %lu and montessori Data Count %lu",(unsigned long)self.montessoriData.count,(unsigned long)self.monteAssesmentVC.selectedList.count);
        //[self.monteAssesmentPopOverVC dismissPopoverAnimated:YES];
    }
    [self.monteAssesmentPopOverVC dismissPopoverAnimated:YES];

    if (selectedCfeArray.count>0){
        
        // self.textView.text=nil;
        textStatement=@"";
        for (OBCfe *obMonte in selectedCfeArray) {
            BOOL isLevelThree;
            isLevelThree=NO;
            CfeLevelFour *lvlfour=[[CfeLevelFour fetchCfeLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:obMonte.cfeFrameworkItemId withFrameWork:NSStringFromClass([Cfe class])]lastObject];
            CfeLevelThree *lvlThree;
            if (lvlfour) {
                isLevelThree=NO;
                lvlThree=[[CfeLevelThree fetchCfeLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:lvlfour.levelThreeIdentifier withFramework:NSStringFromClass([Cfe class])] lastObject];
            }else{
                isLevelThree=YES;
                lvlThree=[[CfeLevelThree fetchCfeLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:obMonte.cfeFrameworkItemId withFramework:NSStringFromClass([Cfe class])] lastObject];
            }
            
            
            CfeLevelTwo *lvlTwo=[[CfeLevelTwo fetchCfeLevelTwoInContext:[AppDelegate context] withlevelTwoIdentifier:lvlThree.levelTwoIdentifier withFramework:NSStringFromClass([Cfe class])] lastObject];
            
            CfeFramework *lvlOne=[[CfeFramework fetchCfeFrameworkInContext:[AppDelegate context] withLevelIdentifier:lvlTwo.levelOneIdentifier withFramework:NSStringFromClass([Cfe class])]lastObject];
            
            if (isLevelThree) {
                textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
            }else{
                textStatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",textStatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
            }
            
        }
        if (textStatement.length>0) {
            self.textView.text=[NSString stringWithFormat:@"\n%@\n%@",self.textView.text,textStatement];
        }
        NSLog(@"Self Data count %lu and montessori Data Count %lu",(unsigned long)self.cfeData.count,(unsigned long)self.cfeAssessmentVC.selectedList.count);
       
    }
     [self.eyfsAssessmentPopOverVC dismissPopoverAnimated:YES];

}

@end
