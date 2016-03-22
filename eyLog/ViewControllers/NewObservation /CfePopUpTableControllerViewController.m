//
//  CfePopUpTableControllerViewController.m
//  eyLog
//
//  Created by shuchi on 09/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfePopUpTableControllerViewController.h"
#import "CfeAssesment.h"
#import "CfeAssesmentDataBase.h"
#import "AppDelegate.h"
#import "CfeAssessmentViewController.h"
@interface CfePopUpTableControllerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *assesmentDict;
}

@end

@implementation CfePopUpTableControllerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_assesmentArray);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma marl - UITableViewDelegateMethod

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assesmentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    CfeAssesmentDataBase * database = [self.assesmentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = database.levelDescription;
    
    if(indexPath.row== 0){
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else if (indexPath.row ==1){
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else if(indexPath.row ==2){
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }else if (indexPath.row ==3){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CfeAssesmentDataBase * database = [self.assesmentArray objectAtIndex:indexPath.row];
    [self.delegate selectedAssesment:database];
}
@end

