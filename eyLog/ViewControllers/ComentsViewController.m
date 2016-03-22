//
//  ComentsViewController.m
//  eyLog
//
//  Created by Shuchi on 11/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ComentsViewController.h"
#import "ComentsTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "APICallManager.h"
#import "Comments.h"
#import "LJHeaderView.h"
#import "Utils.h"

@interface ComentsViewController ()<ComentsCellDelegate>
{
    
    MBProgressHUD *hud;
    LJHeaderView *lJView;
    BOOL isEditingComents;
    Comments *comentToEdit;
    Comments *comentToDelete;
    ComentsTableViewCell *comentsEditCell;
    
}

@end

@implementation ComentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ComentsTableViewCell" bundle:nil] forCellReuseIdentifier:ComentsTableViewCellReuseID];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
    if(_isComeFromObservationWithComments)
    {
        [self.cancelBtn setHidden:YES];
        [self.tableView setScrollEnabled:NO];
        
        
    }
    if(_comentsArray==nil)
    {
    _comentsArray=[NSMutableArray new];

    [self loadComents];
    }
    else
    {
        CGFloat height=0.0;
        
        for(int i=0;i<_comentsArray.count;i++)
        {
        Comments *coment=[_comentsArray objectAtIndex:i];
        
        NSString *text=coment.comment;
        
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(302, 1000.0f)];
         height=textSize.height+60+height;
            
        }
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = height;
        self.tableView.frame = tableFrame;
        [self.tableView reloadData];
    }
        // Do any additional setup after loading the view from its nib.
}
-(void)loadComents
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading comments";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSString *urlString;
    
    if(_isComeFromObservationWithComments)
    {
        urlString=[NSString stringWithFormat:@"%@api/observations/%d/comments",serverURL,[self.obserID integerValue]];
    }
    else
    {
   urlString=[NSString stringWithFormat:@"%@api/observations/%d/comments",serverURL,[self.model.observation_id integerValue]];
    }
    NSLog(@"Coments URL : %@", urlString);
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            
            
            return;
        }
        [self backgroundLoadDataComents:data];
        
    }];
    
    [postDataTask resume];


}
-(void)deleteComment:(Comments *)coment
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSString *str=@"Delete";
    
    NSString *urlString;
    
    if(_isComeFromObservationWithComments)
    {
        urlString=[NSString stringWithFormat:@"%@api/observations/%d/comments/%d",serverURL,[self.obserID integerValue],[coment.comment_id integerValue]];
    }
    else
    {
    
   urlString=[NSString stringWithFormat:@"%@api/observations/%d/comments/%d",serverURL,[self.model.observation_id integerValue],[coment.comment_id integerValue]];
    }
    NSLog(@"Coments URL : %@", urlString);
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",str,@"Type", nil];
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableDeleteRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            
            
            return;
        }
        [self loadDeleteResponse:data];
        
    }];
    
    [postDataTask resume];
    
    
}
-(void)upDateComments:(Comments *)coment
{

   
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Loading";
        
        NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
        NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
        NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
        
    NSString *urlString;
    
    if(_isComeFromObservationWithComments)
    {
        urlString=[NSString stringWithFormat:@"%@api/observations/comments/update/%d",serverURL,[coment.comment_id integerValue]];
    }
    else
    {
    urlString=[NSString stringWithFormat:@"%@api/observations/comments/update/%d",serverURL,[coment.comment_id integerValue]];
    }
        NSLog(@"Coments URL : %@", urlString);
        
        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",self.textfield.text,@"comment",nil];
        
        NSLog(@"DraftList Parameters : %@",mapData);
    NSString *BoundaryConstant = @"----WebKitFormBoundarykbWBAArkKj99P6kw";
    
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
  
    [request setHTTPMethod:@"POST"];
    
    
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n%@", [[APICallManager sharedNetworkSingleton] apiKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_password\"\r\n\r\n%@",[[APICallManager sharedNetworkSingleton] apiPassword]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_pin\"\r\n\r\n%@",practitionerPin] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_id\"\r\n\r\n%@", practitionerId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n%@", self.textfield.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // add image data
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    NSError *error;
    NSData *returnData = [NSURLConnection  sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if(returnString.length>0)
    {
        
        [self loadUpdateResponse:returnData];
        
    }

        
    

}

-(void)InsertComments:(Comments *)coment
{
    
   // dispatch_async(dispatch_get_main_queue(), ^{
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Inserting Comment";
    //  });
    
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    NSString *urlString;
    
   if(_isComeFromObservationWithComments)
   {
    urlString=[NSString stringWithFormat:@"%@api/observations/%d/comment/insert",serverURL,[self.obserID integerValue]];
   }
    else
    {
    urlString=[NSString stringWithFormat:@"%@api/observations/%d/comment/insert",serverURL,[self.model.observation_id integerValue]];
    }
    
    NSLog(@"Coments URL : %@", urlString);
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id",self.textfield.text,@"comment",nil];
    
    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSString *BoundaryConstant = @"----WebKitFormBoundarykbWBAArkKj99P6kw";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"file";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
  
    [request setHTTPMethod:@"POST"];
    
 

    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n%@", [[APICallManager sharedNetworkSingleton] apiKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_password\"\r\n\r\n%@",[[APICallManager sharedNetworkSingleton] apiPassword]] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_pin\"\r\n\r\n%@",practitionerPin] dataUsingEncoding:NSUTF8StringEncoding]];
 
      [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_id\"\r\n\r\n%@", practitionerId] dataUsingEncoding:NSUTF8StringEncoding]];
  
      [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n%@", self.textfield.text] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
   
    
    // add image data
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    NSError *error;
    NSData *returnData = [NSURLConnection  sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if(returnString.length>0)
    {
   
        [self loadInsertResponse:returnData];
        
    }
    

    
}

-(void)loadDeleteResponse:(NSData *)data
{
    [hud hide:YES];
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@" Response JSON : %@", jsonDict);
    
    if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
    {
        
        [self loadComents];
    }
}
-(void)loadUpdateResponse:(NSData *)data
{
    [comentsEditCell setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0f]];
    comentToEdit=nil;
    comentsEditCell=nil;
      [hud hide:YES];
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    NSLog(@" Response JSON : %@", jsonDict);
    
    if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
    {
      
        [self loadComents];
        
    }
    

}
-(void)loadInsertResponse:(NSData *)data
{    AppDelegate *appdel=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    [MBProgressHUD hideAllHUDsForView:appdel.window animated:YES];
    

    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@" Response JSON : %@", jsonDict);
if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"])
{
  
    [self loadComents];
    
}

}
-(void)backgroundLoadDataComents:(NSData *)data
{
   // [hud hide:YES];
    _comentsArray=[NSMutableArray new];
    
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@" Response JSON : %@", jsonDict);
    
    NSArray *array=[jsonDict objectForKey:@"data"];
    
    for(int i=0;i<array.count;i++)
    {
        NSDictionary *dict=[array objectAtIndex:i];
        Comments *coments=[Comments new];
        coments.comment=[dict objectForKey:@"comment"];
        coments.commentSender=[dict objectForKey:@"commentSender"];
        coments.comment_id=[dict objectForKey:@"comment_id"];
        coments.date_time=[dict objectForKey:@"date_time"];
        coments.eylog_user_id=[dict objectForKey:@"eylog_user_id"];
        coments.last_modified_by=[dict objectForKey:@"last_modified_by"];
        coments.last_modified_date=[dict objectForKey:@"last_modified_date"];
        coments.observation_id=[dict objectForKey:@"observation_id"];
        coments.user_id=[dict objectForKey:@"user_id"];
        coments.user_role=[dict objectForKey:@"user_role"];
        [_comentsArray addObject:coments];
        
    
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [hud hide:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.textfield.text=@"";
        _countComents=[NSNumber numberWithInteger:_comentsArray.count];
        [self.tableView reloadData];
        if(_isComeFromObservationWithComments)
        {
        [self.delegate reloadTable];
        }
        
        
    });
      
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comments *coment=[_comentsArray objectAtIndex:indexPath.row];
    
     NSString *text=coment.comment;
    // NSString *text2=coment.commentSender;
    
     AppDelegate *appdelegate= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
     CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(appdelegate.window.frame.size.width- 500, 1000.0f)];
     //CGSize textSize2 = [text2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(appdelegate.window.frame.size.width- 500, 1000.0f)];

    return textSize.height+40;//textSize2.height+40;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    lJView=[[[NSBundle mainBundle]loadNibNamed:@"LJHeaderView" owner:self options:nil] objectAtIndex:0];
    [lJView setTranslatesAutoresizingMaskIntoConstraints:YES];
    lJView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
    [lJView setFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    lJView.nameLabel.text=self.model.observation_by;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self.model.date_time];
    
    [formatter setDateFormat:@"dd"];
    NSString* day = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MMM yyyy"];
    NSDateFormatter *newFormatter=[NSDateFormatter new];
    
    [newFormatter setDateFormat:@"hh:mm:ss a"];
    NSString *timestr=[newFormatter stringFromDate:date];
    
    
    NSString* monthAndYear = [formatter stringFromDate:date];
    NSString* dateStr = [NSString stringWithFormat:@"%@th %@ at %@", day, monthAndYear,timestr];
    
    lJView.dateLabel.text=dateStr;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *array= [Practitioners fetchPractitionersInContext:[AppDelegate context] withPractitionerId:self.model.observer_id];
        Practitioners *pract=[array lastObject];
        
        
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],pract.photo];
        
        UIImage *practitionerImage=[UIImage imageWithContentsOfFile:imagePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            lJView.iconImage.layer.cornerRadius = 25;
            lJView.iconImage.layer.masksToBounds = YES;
            lJView.iconImage.image =[UIImage imageNamed:@"eylog_Logo"];
            if(practitionerImage!=nil)
            {
                lJView.iconImage.image = practitionerImage;
            }
            
        });
        
    });
    //[lJView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
   
    
    
    return lJView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_isComeFromObservationWithComments)
    {
        return 0;
    }
    return 60;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comentsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComentsTableViewCell *cell=(ComentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ComentsTableViewCellReuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    Comments *coments=[_comentsArray objectAtIndex:indexPath.row];
    cell.comenterName.text=coments.commentSender;
    cell.comentstring.text=coments.comment;
    cell.coments=coments;
    cell.delegate=self;
    
    
    if([coments.eylog_user_id integerValue]!=[[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId integerValue])
    {
        [cell.editButon setHidden:YES];
        [cell.delete_btn setHidden:YES];
    }
    else
    {
        [cell.editButon setHidden:NO];
        [cell.delete_btn setHidden:NO];
    }
    
    
    
    cell.editButon.contentMode   = UIViewContentModeScaleAspectFill;
    cell.editButon.clipsToBounds = YES;
    

    
//    NSString *text=coments.commentSender;
//    AppDelegate *appdelegate= (AppDelegate *)[[UIApplication sharedApplication]delegate];
//
//    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(appdelegate.window.frame.size.width-500, 1000.0f)];
//   [cell.comenterName setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [cell.comenterName setFrame:CGRectMake(cell.comenterName.frame.origin.x, cell.comenterName.frame.origin.y, textSize.width, textSize.height)];
    
    
    
    [cell setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0f]];
//    if(_isComeFromObservationWithComments)
//    {
//        [cell setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0f]];
//        
//    
//    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    NSDate *date = [formatter dateFromString:coments.date_time];
    
    [formatter setDateFormat:@"dd"];
    NSString* day = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MMM yyyy"];
    NSDateFormatter *newFormatter=[NSDateFormatter new];
    
    [newFormatter setDateFormat:@"hh:mm:ss a"];
    NSString *timestr=[newFormatter stringFromDate:date];
    
    
    NSString* monthAndYear = [formatter stringFromDate:date];
    NSString* dateStr = [NSString stringWithFormat:@"%@th %@ at %@", day, monthAndYear,timestr];
    
    cell.dateLabel.text=dateStr;
    
    
    return cell;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
# pragma mark - CommentsCell Delegate Methods
-(void)editButton:(UIButton *)btn andCell:(UITableViewCell *)cell
{
    isEditingComents=YES;
    NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
    
    Comments *coments=[_comentsArray objectAtIndex:indexpath.row];
    [cell.contentView setBackgroundColor: yellowColor];

    self.textfield.text=coments.comment;
    [self.textfield becomeFirstResponder];
    comentToEdit=coments;
    comentsEditCell=(ComentsTableViewCell *)cell;
    

}
-(void)deleteButton:(UIButton *)btn andCell:(UITableViewCell *)cell
{
    NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
    
    Comments *coments=[_comentsArray objectAtIndex:indexpath.row];
    comentToDelete=coments;
    
    [self deleteComment:coments];

}

- (IBAction)sendButton:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.textfield.text stringByTrimmingCharactersInSet:charSet];
    [self.textfield resignFirstResponder];
    
    if(self.textfield.text.length>0 && ![trimmedString isEqualToString:@""])
    {
      AppDelegate *appdel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
       MBProgressHUD *newhud=[MBProgressHUD showHUDAddedTo:appdel.window animated:YES];
        newhud.labelText=@"new";
        
        if(comentToEdit)
        {
            [self upDateComments:comentToEdit];
        }
        else
        {
            [self InsertComments:nil];
            
        }
    }
      });
    
}
- (IBAction)cancelBtn:(id)sender {
    
    [self.delegate CloseButton:sender andTag:self.tag andCount:self.countComents];
    
}
@end
