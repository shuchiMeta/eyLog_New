//
//  NotificationsViewController.m
//  eyLog
//
//  Created by Shuchi on 02/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationModel.h"
#import "Child.h"
#import "AppDelegate.h"
#import "Utils.h"



@interface NotificationsViewController ()
{
    NSNumber *pagenumber;
    
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setBackgroundColor:[UIColor clearColor]];
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"] integerValue] != 1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]!=nil)
//    {
//        pagenumber=[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"];
//        
//    }
//    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]==nil)
//    {
//         pagenumber=[NSNumber numberWithInt:1];
//    }
//    else
//    {
//     
//    }
    
    [self.tableview registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:NotificationTableViewCellID];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"] integerValue] != 1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]!=nil)
    {
        pagenumber=[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]==nil)
    {
        pagenumber=[NSNumber numberWithInt:1];
    }
      [[NSUserDefaults standardUserDefaults] setObject:pagenumber forKey:@"pageNumber"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
[[NSUserDefaults standardUserDefaults] setObject:pagenumber forKey:@"pageNumber"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSString *)dateDifferenceStringFromString:(NSString *)dateString

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
   
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if(time < 1) {
        return dateString;
    } else if (time < 60) {
        return @"less than a minute ago";
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return [NSString stringWithFormat:@"1 minute ago"];
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return [NSString stringWithFormat:@"1 hour ago"];
        return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return [NSString stringWithFormat:@"yesterday"];
        if (diff == 7)
            return [NSString stringWithFormat:@"last week"];
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else  if(time < 2419200 ){
        int diff = round(time / 60 / 60 / 24 / 7);
        if (diff == 1)
            return [NSString stringWithFormat:@"last week"];
        if(diff == 3)
        {
            
        return [NSString stringWithFormat:@"%d weeks ago", diff];
        }
        
        return [NSString stringWithFormat:@"1 month ago"];
    }
   
    return @"";
    
}
//-(NSString *)dateDiff:(NSString *)origDate {
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *convertedDate = [df dateFromString:origDate];
//    
//    NSDate *todayDate = [NSDate date];
//    double ti = [convertedDate timeIntervalSinceDate:todayDate];
//    ti = ti * -1;
//    if(ti < 1) {
//        return @"never";
//    } else 	if (ti < 60) {
//        return @"less than a minute ago";
//    } else if (ti < 3600) {
//        int diff = round(ti / 60);
//        return [NSString stringWithFormat:@"%d minutes ago", diff];
//    } else if (ti < 86400) {
//        int diff = round(ti / 60 / 60);
//        return[NSString stringWithFormat:@"%d hours ago", diff];
//    } else if (ti < 2629743) {
//        int diff = round(ti / 60 / 60 / 24);
//        return[NSString stringWithFormat:@"%d days ago", diff];
//    } else {
//        return @"never";
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NotificationTableViewCellID forIndexPath:indexPath];
    if(cell==nil)
    {
       cell=[(NotificationTableViewCell *)[UITableViewCell alloc] init];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.indexpath=indexPath;
    
    NotificationModel *model=[self.dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=model.title;
    cell.descLabel.text=model.content;
    cell.dateLabel.text=[self dateDifferenceStringFromString:model.dateStr];
    //cell.imageview.layer.cornerRadius = 22;
    cell.imageview.layer.masksToBounds = YES;
    cell.imageview.layer.borderWidth = 0;
    
    NSArray *array=[Child fetchChildInContext:[AppDelegate context] withChildId:model.childID];
    
    Child *child=[array lastObject];
    
    if([child.photo isEqualToString:@"child.png"])
    {
        cell.imageview.image=[UIImage imageNamed:@"eylog_Logo"];
        //        if (cell.childImage.bounds.size.width > [UIImage imageNamed:@"eylog_Logo"].size.width && cell.childImage.bounds.size.height > [UIImage imageNamed:@"eylog_Logo"].size.height) {
        cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
        //        }
    }
    else
    {
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],child.photo];
        UIImage *childrenImage= [UIImage imageWithContentsOfFile:imagePath];
        
        if(childrenImage==nil)
        {
            cell.imageview.image=[UIImage imageNamed:@"eylog_Logo"];
            //        if (cell.childImage.bounds.size.width > [UIImage imageNamed:@"eylog_Logo"].size.width && cell.childImage.bounds.size.height > [UIImage imageNamed:@"eylog_Logo"].size.height) {
            cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
            //        }
            
        }
        else
        {
            cell.imageview.image=childrenImage;
            
            if (cell.imageview.bounds.size.width > childrenImage.size.width && cell.imageview.bounds.size.height > childrenImage.size.height) {
                cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
            }
            if(cell.imageview.bounds.size.width < childrenImage.size.width)
            {
                
                cell.imageview.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
        
    }

    
    //cell.imageview.image
    

    if(model.isRead)
    {
        cell.backgroundColor=[UIColor whiteColor];
        
    }
    else
    {
        //255,249,196
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:196.0/255.0 alpha:1.0f];
        
    }
    
//    if (indexPath.row == [self.dataArray count] - 1)
//    {
//        
//        
//        
//    }
 
    return cell;
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        
        if(!_noMoreData)
        {
        UIActivityIndicatorView *spinner =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.tableview.tableFooterView = spinner;
            [self.tableview setScrollEnabled:NO];
            
        [self launchMore];
        }
        //[self methodThatAddsDataAndReloadsTableView];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
      cell.backgroundColor=[UIColor whiteColor];
    
     NotificationModel *model= [self.dataArray objectAtIndex:indexPath.row];

     model.status=@"seen";
    
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    
    [self.delegate rowSelectedForCell:cell andID:model.tableID andModel:model andArray:self.dataArray];
    

}
-(void)launchMore
{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"] integerValue] != 1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]!=nil)
    {
        pagenumber=[[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pageNumber"]==nil)
    {
        pagenumber=[NSNumber numberWithInt:1];
    }

    int inte=[pagenumber integerValue];
    inte ++;
    
    pagenumber =[NSNumber numberWithInt:inte];
    [[NSUserDefaults standardUserDefaults] setObject:pagenumber forKey:@"pageNumber"];
    [self.delegate launchMore:pagenumber];
    
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
