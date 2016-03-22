//
//  GroupsViewController.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 25/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupsViewCell.h"
#import "FrameWorkViewCell.h"
#import "APICallManager.h"
@import QuartzCore;

@interface GroupsViewController () <UITableViewDataSource, UITableViewDelegate>
{

}

@end

@implementation GroupsViewController

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
    // Do any additional setup after loading the view.
   // self.dataArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Groups" ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.cellType isEqualToString:KCellTypeGroup])
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.cellType isEqualToString:KCellTypeGroup])
    {
        if(section==0)
        {
            return self.dataArray.count;
        }
        else
        {
            return 0;
        }
    }

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.cellType isEqualToString:KCellTypeGroup])
    {
        static NSString *cellId = @"GroupsCellID";
        GroupsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupsViewCell" owner:self options:nil] lastObject];
        }
        [cell.imageview setHidden:YES];
        
      
        if(indexPath.section==0)
        {
            cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        }
        else
        {
            //cell.titleLabel.text=@"Test";
        }
        return cell;
    }
    else if([self.cellType isEqualToString:KCellTypeFrame])
    {
        static NSString *cellId = @"frameworkCellID";
        FrameWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FrameWorkViewCell" owner:self options:nil] lastObject];
        }

        cell.titleLabel.text=[self.dataArray objectAtIndex:indexPath.row];
        if(self.dataSoruce!=nil)// && self.dataArray.count==((NSDictionary *)self.dataSoruce).count)
        {
            cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
        }

         // Temporary HACK needed to be fixed later
        NSString *temp = [self.dataArray objectAtIndex:indexPath.row];
        if( [temp isEqualToString:@"Planning Sheet"])
        {
//            if([APICallManager sharedNetworkSingleton].cacheChildren.count == 0)
//            {
                [cell.titleLabel setTextColor:[UIColor blackColor]];
                [cell setUserInteractionEnabled:YES];
                cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
//            }
//            else
//            {
//                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
//                [cell setUserInteractionEnabled:NO];
//                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
//            }
        }
        else if([temp isEqualToString:@"EYFS Check"])
        {
            if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
            {
                [cell.titleLabel setTextColor:[UIColor blackColor]];
                [cell setUserInteractionEnabled:YES];
                cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
            }
            else
            {
                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
                [cell setUserInteractionEnabled:NO];
                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
            }
        }
        else if([temp isEqualToString:@"Montessori Tracker"])
        {
            if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
            {
                [cell.titleLabel setTextColor:[UIColor blackColor]];
                [cell setUserInteractionEnabled:YES];
                cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
            }
            else
            {
                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
                [cell setUserInteractionEnabled:NO];
                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
            }
        }
        else if([temp isEqualToString:@"ECaT Summary"])
        {
            
             // Ecat to be enabled every time whether a child/multiple children/no child is selected.
//            if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
//            {
                [cell.titleLabel setTextColor:[UIColor blackColor]];
                [cell setUserInteractionEnabled:YES];
                cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
//            }
//            else
//            {
//                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
//                [cell setUserInteractionEnabled:NO];
//                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
//            }
        }
        else if([self.cellType isEqualToString:KCellTypeTag])
        {
            static NSString *cellId = @"frameworkCellID";
            FrameWorkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FrameWorkViewCell" owner:self options:nil] lastObject];
            }
            
            cell.titleLabel.text=[self.dataArray objectAtIndex:indexPath.row];
            if(self.dataSoruce!=nil)// && self.dataArray.count==((NSDictionary *)self.dataSoruce).count)
            {
                [cell.frameworkImageView setHidden:YES];
                [cell.tagLabel setHidden:NO];
                [cell.tagLabel setText:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
                [cell.tagLabel setTextColor:[UIColor blackColor]];
                
                [cell.tagLabel setBackgroundColor:[UIColor greenColor]];
                
            }
            
        }
        else if([temp isEqualToString:@"CoEL Summary"])
        {
            
            // Ecat to be enabled every time whether a child/multiple children/no child is selected.
            //            if([APICallManager sharedNetworkSingleton].cacheChildren.count == 1)
            //            {
            [cell.titleLabel setTextColor:[UIColor blackColor]];
            [cell setUserInteractionEnabled:YES];
            cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
            //            }
            //            else
            //            {
            //                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
            //                [cell setUserInteractionEnabled:NO];
            //                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
            //            }
        }

        else if([temp isEqualToString:@"Summative Reports"])
        {
//            if([APICallManager sharedNetworkSingleton].cacheChildren.count <= 1)
//            {
                [cell.titleLabel setTextColor:[UIColor blackColor]];
                [cell setUserInteractionEnabled:YES];
                cell.frameworkImageView.image=[UIImage imageNamed:[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]]];
          //  }
//            else
//            {
//                [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
//                [cell setUserInteractionEnabled:NO];
//                cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
//            }
        }
        // Completely Disabling Ecat for now
        else if( [temp isEqualToString:@"ECaT Summary"])
        {
            [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
            [cell setUserInteractionEnabled:NO];
            cell.frameworkImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled",[self.dataSoruce objectForKey:[self.dataArray objectAtIndex:indexPath.row]] ]];
        }
        return cell;
    }
    else if([self.cellType isEqualToString:KCellTypePractitioner])
    {
        static NSString *cellId = @"GroupsCellID";
        GroupsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupsViewCell" owner:self options:nil] lastObject];
        }
        cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;

    }
    else if([self.cellType isEqualToString:KCellTypeObservationBy])
    {
        static NSString *cellId = @"GroupsCellID";
        GroupsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupsViewCell" owner:self options:nil] lastObject];
        }
        cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        return cell;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_isInRequired)
    {
        if([self.cellType isEqualToString:KCellTypeGroup])
        {
            if(section==1)
            {
            if([APICallManager sharedNetworkSingleton].settingObject.dailyDiary==1)
            {
                return 45;
            }
            }
            else
            {
             return 0;
            }
            
            return 0;
            
        }
    }

    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if([self.cellType isEqualToString:KCellTypeGroup])
//    {
//        if(section==0)
//        {
//            return @"Filter option";
//        }
//        else if(section==1)
//        {
//            return @"Sorting option";
//        }
//    }
//    return @"";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
       return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
      
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
  
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-45, 45)];
    label.text=@"  IN";
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(label.frame.size.width, 10, 25, 25)];
    
    [btn setImage:[UIImage imageNamed:@"checkround"] forState:UIControlStateSelected];
    
    [btn setImage:[UIImage imageNamed:@"uncheckround"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction:)];
    [view addGestureRecognizer:tap];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"selection"])
    {
        [btn setSelected:YES];
        
    }

    [view setUserInteractionEnabled:YES];
    [view addSubview:label];
    [view addSubview:btn];
    
    return view;
    }
    return [UIView new];
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if([self.cellType isEqualToString:KCellTypeGroup] && indexPath.section==1)
    {
        return;
    }
    [self.delegate groupDidSelected:[self.dataArray objectAtIndex:indexPath.row] withCellType:self.cellType];
    
   
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   }
-(void)btnAction:(id)sender
{
    if([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer *view=(UITapGestureRecognizer *)sender;
        
        for(UIView *views in view.view.subviews)
        {
        if([views isKindOfClass:[UIButton class]])
        {
            UIButton *btn=(UIButton*)views;
            if([btn isSelected])
            {
                [btn setSelected:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selection"];

                
            }
            else
            {
                [btn setSelected:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"select" forKey:@"selection"];
            }
            
            [self.delegate btnAction:btn];

        
        }
        
        }
    }
    else
    {
    
    UIButton *btn=(UIButton*)sender;
    if([btn isSelected])
    {
        [btn setSelected:NO];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selection"];
        
    }
    else
    {
        [btn setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"select" forKey:@"selection"];
    }
    
    [self.delegate btnAction:sender];
    }
    
}
@end
