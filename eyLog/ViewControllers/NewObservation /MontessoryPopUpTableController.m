//
//  MontessoryPopUpTableController.m
//  eyLog
//
//  Created by Shobhit on 23/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoryPopUpTableController.h"
#import "MontessoryAssesment.h"
#import "MontessoriAssesmentDataBase.h"
#import "AppDelegate.h"
#import "MontessoryViewController.h"
@interface MontessoryPopUpTableController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *assesmentDict;
}

@end

@implementation MontessoryPopUpTableController
@synthesize tableView;



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
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];

    MontessoriAssesmentDataBase * database = [self.assesmentArray objectAtIndex:indexPath.row];
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
    MontessoriAssesmentDataBase * database = [self.assesmentArray objectAtIndex:indexPath.row];
    [self.delegate selectedAssesment:database];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
