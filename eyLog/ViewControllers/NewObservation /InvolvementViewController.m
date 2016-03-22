//
//  InvolvementViewController.m
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "InvolvementViewController.h"
#import "InvolvementTableViewCell.h"
#import "LeuvenScale.h"
#import "AppDelegate.h"

@interface InvolvementViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *leuvenScaleArray;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *mTableView;
    BOOL selectedButton;
    NSMutableArray *selectionArray;
}
@end

@implementation InvolvementViewController

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
    selectionArray=[[NSMutableArray alloc]init];
    leuvenScaleArray=[LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"involvement"];
    [super viewDidLoad];
    
    self.doneButton.layer.cornerRadius = 10.0;
    self.cancelButton.layer.cornerRadius = 10.0;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedInvolvementIndex=[_eylNewObservation.scaleInvolvement integerValue]-1;
    self.selectedWellBeingIndex=[_eylNewObservation.scaleWellBeing integerValue]-1;
    [mTableView reloadData];
    
}
-(IBAction)selectionButton:(id)sender
{
      
}

- (IBAction)segmentControl:(id)sender
{
    if(segmentControl.selectedSegmentIndex==1)
    {
        leuvenScaleArray=[LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"well_being"];
    }
    else if (segmentControl.selectedSegmentIndex==0)
    {
        leuvenScaleArray=[LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"involvement"];
    }
    [mTableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return leuvenScaleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *popupTableViewCellId = @"involvementTableViewCellId";
    InvolvementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popupTableViewCellId];
    
    LeuvenScale *leuvenScale=[leuvenScaleArray objectAtIndex:indexPath.row];
    cell.involvementText.text=leuvenScale.signals;
    cell.involvementText.userInteractionEnabled = NO;
    cell.isSelected=NO;
    [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
    cell.selectionButton.userInteractionEnabled = NO;
    
//    NSLog(@"%@", leuvenScale.leuvenScaleType);
//    NSLog(@"%@", leuvenScale.scale);
//    NSLog(@"%@", leuvenScale.signals);
    
    if (segmentControl.selectedSegmentIndex==0)
    {
        if (self.selectedInvolvementIndex == indexPath.row)
        {
            cell.isSelected=YES;
            [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        }
        else
        {
            cell.isSelected=NO;
            [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if (self.selectedWellBeingIndex == indexPath.row)
        {
            cell.isSelected=YES;
            [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        }
        else
        {
            cell.isSelected=NO;
            [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        }
    }
    
/*    if([selectionArray containsObject:indexPath])
    {
        cell.selectionButton.imageView.image=[UIImage imageNamed:@"icon_tick_active"];
    }
    else
    {
        cell.selectionButton.imageView.image=[UIImage imageNamed:@"icon_tick_disabled"];
    }
*/
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvolvementTableViewCell *cell = (InvolvementTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    LeuvenScale *leuvenScale=[leuvenScaleArray objectAtIndex:indexPath.row];
    
    if(cell.isSelected)
    {
        cell.isSelected=NO;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_disabled"] forState:UIControlStateNormal];
        
        if ([leuvenScale.leuvenScaleType isEqualToString:@"involvement"]) {
            self.selectedInvolvementIndex = -1;
        }
        else
        {
            self.selectedWellBeingIndex = -1;
        }
    }
    else
    {
        cell.isSelected=YES;
        [cell.selectionButton setBackgroundImage:[UIImage imageNamed:@"icon_tick_active"] forState:UIControlStateNormal];
        
        if ([leuvenScale.leuvenScaleType isEqualToString:@"involvement"]) {
            self.selectedInvolvementIndex = indexPath.row;
        }
        else
        {
            self.selectedWellBeingIndex = indexPath.row;
        }
    }
    
    [tableView reloadData];
}
- (IBAction)doneAction:(id)sender
{
    [self.delegate doneButtonAction:sender];
}

- (IBAction)closeAction:(id)sender
{
    [self.delegate closeButtonAction:sender];
}
@end