//
//  ObservationWithComentsViewController.m
//  eyLog
//
//  Created by Shuchi on 29/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ObservationWithComentsViewController.h"
#import "Theme.h"
#import "MBProgressHUD.h"
#import "APICallManager.h"
#import "LearningJourneyModel.h"
#import "LJCollectionViewCell.h"
#import "ComentsViewController.h"
#import "Comments.h"


NSString* const ObsLJObservation=@"Observation";
NSString *const ObsLJAnalysis=@"Analysis";
NSString *const ObsLJNextSteps=@"Next Steps";
NSString *const ObsLJAdditionalNotes=@"Additional Notes";
@interface ObservationWithComentsViewController ()
{
    MBProgressHUD *hud;
    LearningJourneyModel *ljModel;
}

@end

@implementation ObservationWithComentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.observationCollectionView registerNib:[UINib nibWithNibName:@"LJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LJCollectionViewCellID];
    
    
    [self.frameworkCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self loadLearningJourney];
    
        
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadLearningJourney
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading";
    
    NSString *serverURL=[APICallManager sharedNetworkSingleton].serverURL;
    NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/observations/%d/list",serverURL,[self.observationID integerValue]];
    
    NSLog(@"DraftList URL : %@", urlString);
    
    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[APICallManager sharedNetworkSingleton] apiKey],@"api_key",[[APICallManager sharedNetworkSingleton] apiPassword], @"api_password",practitionerPin,@"practitioner_pin",practitionerId,@"practitioner_id", nil];
//    [mapData setObject:[[APICallManager sharedNetworkSingleton] cacheChild].childId forKey:@"child_id"];
    //mapData setObject:@""draft,pending_review,processing"" forKey:<#(nonnull id<NSCopying>)#>
    
  
//        "child_id": "",
//        "filter_type": "practitioner",
//        "per_page": "20",
//    
//        "type": "draft,pending_review,processing"

    NSLog(@"DraftList Parameters : %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            
            // Displaying Hardcoded Error message for now to be changed later
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                
                
            });
            
            return;
        }
        [self backgroundLoadData:data];
        
    }];
    
    [postDataTask resume];
}
-(void)backgroundLoadData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide:YES];
     
    });
    ComentsViewController *coments=[[ComentsViewController alloc] initWithNibName:@"ComentsViewController" bundle:nil];
    coments.isComeFromObservationWithComments=YES;
    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"Draft List Response JSON : %@", jsonDict);
    
    NSArray *array=[jsonDict objectForKey:@"data"];
    
    if(array.count>0)
    {
           ljModel=[LearningJourneyModel new];
        
            NSDictionary *dict=[array firstObject];
            ljModel.ageNumber =[NSNumber numberWithInteger:[[dict objectForKey:@"age_months"] integerValue]];
            ljModel.analysis=[dict objectForKey:@"analysis"];
            ljModel.child_id=[dict objectForKey:@"child_id"];
            ljModel.comments=[dict objectForKey:@"comments"];
            ljModel.date_time=[dict objectForKey:@"date_time"];
            ljModel.commentsCount=[dict objectForKey:@"commentsCount"];
            
            NSArray *arrayEcat=[dict objectForKey:@"ecat"];
            
            if(arrayEcat.count>0)
            {
                ljModel.ecat=[NSMutableArray new];
                
                for (int j =0; j<arrayEcat.count; j++) {
                    NSDictionary *dict =[arrayEcat objectAtIndex:j];
                    
                    OBEcat * obEcat = [[OBEcat alloc]init];
                    obEcat.ecatFrameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"ecat_id"]integerValue]];
                    [ljModel.ecat addObject:obEcat];
                    
                    //obEcat.ecatFrameworkLevelNumber = @(0);
                    //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                    
                    
                }
            }
            NSArray *arrayMon=[dict objectForKey:@"montessori"];
            
            if(arrayMon.count>0)
            {
                ljModel.montessory=[NSMutableArray new];
                
                for (int j =0; j<arrayMon.count; j++) {
                    NSDictionary *dict =[arrayMon objectAtIndex:j];
                    if(!([[dict objectForKey:@"montessori_framework_item_id"] integerValue]==0&&[[dict objectForKey:@"montessori_assessment"]integerValue]==0))
                    {
                        OBMontessori * obMon = [[OBMontessori alloc]init];
                        obMon.montessoriFrameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"montessori_framework_item_id"]integerValue]];
                        [ljModel.montessory addObject:obMon];
                    }
                    
                    //obEcat.ecatFrameworkLevelNumber = @(0);
                    //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                    
                    
                }
            }
            
            NSArray *arrayEyfs=[dict objectForKey:@"eyfs"];
            
            if(arrayEyfs.count>0)
            {
                ljModel.eyfs=[NSMutableArray new];
                
                for (int j =0; j<arrayEyfs.count; j++) {
                    NSDictionary *dict =[arrayEyfs objectAtIndex:j];
                    
                    if(!([[dict objectForKey:@"framework_item_id"] integerValue]==0&&[[dict objectForKey:@"assessment_level"]integerValue]==0))
                    {
                        OBEyfs * obEyfs = [[OBEyfs alloc]init];
                        obEyfs.frameworkItemId = [NSNumber numberWithInteger:[[dict objectForKey:@"framework_item_id"] integerValue]];
                        obEyfs.assessmentLevel=[NSNumber numberWithInteger:[[dict objectForKey:@"assessment_level"]integerValue]];
                        [ljModel.eyfs addObject:obEyfs];
                    }
                    //obEcat.ecatFrameworkLevelNumber = @(0);
                    //obEcat.levelTwoIdentifier =state.levelTwoIdentifier;
                    
                    
                }
            }
            if([[dict objectForKey:@"mode"] isEqualToString:@"processing"])
            {
                ljModel.media =nil;
                
            }
            else
            {
                
                NSDictionary *dictionary =[dict objectForKey:@"media"];
                
                OBMedia * obMedia = [[OBMedia alloc]initWithDictionary:dictionary];
                //        obMedia.images = [dictionary objectForKey:@"image"];
                //        obMedia.videos=[dictionary objectForKey:@"video"];
                //        obMedia.audios=[dictionary objectForKey:@"audio"];
                ljModel.media = obMedia;
            }
            
            
            
            
            NSArray *arrayCoel=[dict objectForKey:@"coel"];
            
            if(arrayCoel.count>0)
            {
                ljModel.coel=[NSMutableArray new];
                
                for (int j =0; j<arrayCoel.count; j++) {
                    NSDictionary *dict =[arrayCoel objectAtIndex:j];
                    
                    OBCoel * obcoel = [[OBCoel alloc]init];
                    obcoel.coelId = [NSNumber numberWithInteger:[[dict objectForKey:@"coel_id"]integerValue]];
                    
                    [ljModel.coel addObject:obcoel];
                    
                    
                }
            }
            
            ljModel.next_steps=[dict objectForKey:@"next_steps"];
            if ([dict objectForKey:@"observation_by"] == nil || [dict objectForKey:@"observation_by"] == (id)[NSNull null])
            {
                
            }
            else
            {
                ljModel.observation_by=[dict objectForKey:@"observation_by"];
            }
            
            ljModel.observation_id=[NSNumber numberWithInteger:[[dict objectForKey:@"observation_id"] integerValue]];
            ljModel.observation_text=[dict objectForKey:@"observation_text"];
            ljModel.observer_id=[NSNumber numberWithInteger:[[dict objectForKey:@"observer_id"] integerValue]];
            ljModel.quick_observation_tag=[NSNumber numberWithInteger:[[dict objectForKey:@"quick_observation_tag"] integerValue]];
            
            if([[dict objectForKey:@"scale_involvement"] integerValue]!=0)
            {
                ljModel.scale_involvement=[NSNumber numberWithInteger:[[dict objectForKey:@"scale_involvement"] integerValue]];
            }
            if([[dict objectForKey:@"scale_well_being"] integerValue]!=0)
            {
                ljModel.scale_well_being=[NSNumber numberWithInteger:[[dict objectForKey:@"scale_well_being"] integerValue]];
                
            }
            ljModel.unique_tablet_OID=[dict objectForKey:@"unique_tablet_OID"];
            NSArray *comentArray=[dict objectForKey:@"comments_details"];
            NSMutableArray *comentsModelArray=[NSMutableArray new];
        
            if(comentArray.count>0)
            {
               
                
                for(int i=0;i<comentArray.count;i++)
                {
                    NSDictionary *dict=[comentArray objectAtIndex:i];
                    
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
                    [comentsModelArray addObject:coments];
                    
                    
                }
            }
            
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            coments.comentsArray=comentsModelArray;
            [self.commentsView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
            [coments.tableView reloadData];
            
            
             [coments.view setFrame:CGRectMake(0,0,self.view.frame.size.width, coments.tableView.frame.size.height+60)];
            [self.commentsView setFrame:CGRectMake(0, self.commentsView.frame.origin.y,coments.view.frame.size.width, coments.view.frame.size.height+60)];
            [self.commentsView addSubview:coments.view];
            
           // [self.commentsView setTranslatesAutoresizingMaskIntoConstraints:YES];
            [self.observationCollectionView reloadData];
            [self.frameworkCollection reloadData];
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.commentsView.frame.size.height+39*2+self.observationTextview.frame.size.height+self.frameworkTextview.frame.size.height);
            
        });
  
}
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
 
     [self.observationCollectionView setFrame:CGRectMake(self.observationCollectionView.frame.origin.x, self.observationCollectionView.frame.origin.y, self.view.frame.size.width-251, 39)];
     [self.frameworkCollection setFrame:CGRectMake(self.frameworkCollection.frame.origin.x, self.frameworkCollection.frame.origin.y, self.view.frame.size.width, 39)];
    
    [self.observationTextview setFrame:CGRectMake(self.observationTextview.frame.origin.x, self.observationTextview.frame.origin.y, self.view.frame.size.width-251, self.observationTextview.frame.size.height)];
    [self.frameworkTextview setFrame:CGRectMake(self.frameworkTextview.frame.origin.x, self.frameworkTextview.frame.origin.y, self.view.frame.size.width, self.frameworkTextview.frame.size.height)];
    
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //[collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    NSLog(@"contentOffset=(%f, %f)", collectionView.contentOffset.x, collectionView.contentOffset.y);
    
    if(collectionView == _observationCollectionView)
    {
            
        return CGSizeMake(_observationCollectionView.frame.size.width/_observationCollectionArray.count, 50);
    }
    else
    {
        return CGSizeMake(100, 50);
    }
    NSLog(@"contentOffset=(%f, %f)", self.observationCollectionView.contentOffset.x, self.observationCollectionView.contentOffset.y);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView== _observationCollectionView)
    {
        return _observationCollectionArray.count;
    }
    else
    {
        return _frameworkcollectionArray.count;
        
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self.observationCollectionView setContentOffset:CGPointMake(0, 0)];
    
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    if(collectionView == _observationCollectionView)
    {
        
        LJCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:LJCollectionViewCellID forIndexPath:indexPath];
        
        if (cell==nil)
        {
            cell = [[LJCollectionViewCell alloc]init];
        }
        
        NSString *match;
        
        if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:ObsLJObservation])
        {
            cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelObservation;
            match=ObsLJObservation;
            
        }
        if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:ObsLJAnalysis])
        {
            cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelAnalysis;
            match=ObsLJAnalysis;
            
        }
        if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:ObsLJNextSteps])
        {
            cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelNextSteps;
            match=ObsLJNextSteps;
            
        }
        if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:ObsLJAdditionalNotes])
        {
            cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelComment;
            match=ObsLJAdditionalNotes;
            
        }
        
        
        
        cell.label.font=[UIFont systemFontOfSize:13.0f];
        
        
        // NSIndexPath *newIndexPath=[selectedIndexPaths lastObject];
        if([match isEqualToString:_observation])
        {
            cell.label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
            //cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = cell.contentView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor], nil];
            [cell.contentView.layer insertSublayer:gradient atIndex:0];
        }
        else
        {
            cell.contentView.backgroundColor=[UIColor whiteColor];
            cell.label.textColor=[UIColor darkGrayColor];
            NSPredicate *predicate= [NSPredicate predicateWithFormat: @"class == %@", [CAGradientLayer class]];
            
            NSArray *array=[cell.contentView.layer.sublayers filteredArrayUsingPredicate:predicate];
            
            for(CAGradientLayer *layer in [array mutableCopy])
            {
                [layer removeFromSuperlayer];
                
            }
            
        }
        
        return cell;
    }
    
    if(collectionView == _frameworkCollection)
    {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UILabel *label;
        UILabel *labelRound;
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
        if (cell==nil)
        {
            cell = [[UICollectionViewCell alloc]init];
            
        }
        for (UILabel *lbl in cell.contentView.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                [lbl removeFromSuperview];
            }
        }
        
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 100, 50)];
        label.font=[UIFont systemFontOfSize:11.0f];
        label.text=[_frameworkcollectionArray objectAtIndex:indexPath.row];
        
        labelRound=[[UILabel alloc] initWithFrame:CGRectMake(70, 12, 20, 20)];
        labelRound.layer.cornerRadius =10.0;
        labelRound.layer.masksToBounds = YES;
        
        labelRound.font=[UIFont systemFontOfSize:13.0f];
        [labelRound setTextAlignment:NSTextAlignmentCenter];
        
        [labelRound setBackgroundColor:[UIColor colorWithRed:154.0/255.0 green:155.0/255.0 blue:36.0/255.0 alpha:1.0f]];
        if([label.text isEqualToString:@"EYFS"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d", ljModel.eyfs.count];
        }
        if([label.text isEqualToString:@"Montessori"])
        {
            
            labelRound.text=[NSString stringWithFormat:@"%d", ljModel.montessory.count];
        }
        if([label.text isEqualToString:@"Involvement"])
        {
            
            if([ljModel.scale_involvement integerValue]>0)
            {
                labelRound.text=[NSString stringWithFormat:@"%d", [ljModel.scale_involvement integerValue]];
            }
        }
        if([label.text isEqualToString:@"Well Being"])
        {
            if([ljModel.scale_well_being integerValue]>0)
            {
                labelRound.text=[NSString stringWithFormat:@"%d", [ljModel.scale_well_being integerValue]];
            }
        }
        if([label.text isEqualToString:@"ECaT"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d", ljModel.ecat.count ];
            
        }
        if([label.text isEqualToString:@"CoEL"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d",ljModel.coel.count];
            
        }
        
        [cell.contentView addSubview:labelRound];
        
        UILabel *labelLine=[[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-2, 4, 1.5, cell.contentView.frame.size.height-8)];
        [labelLine setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell.contentView addSubview:labelLine];
        if([label.text isEqualToString:_framework])
        {
            label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
            cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
            
        }
        else
        {
            cell.contentView.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor darkGrayColor];
            
            
        }
        [cell.contentView addSubview:label];
        return cell;
    }
    
    
    
    return nil;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d ,%d",indexPath.row,indexPath.section);
    
    if(collectionView ==_observationCollectionView)
    {
        _observation=[_observationCollectionArray objectAtIndex:indexPath.row];
        
        
        
        UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
        // cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
        
        NSArray *viewSubviews =[cell.contentView  subviews];
        for(UIView *v in viewSubviews)
        {
            if([v isKindOfClass:[UILabel class]])
            {
                UILabel *label=(UILabel*)v;
                label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
                
            }
        }
        
        
    }
    else
    {
        _framework=[_frameworkcollectionArray objectAtIndex:indexPath.row];
        
        
        UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
        // cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
        
        NSArray *viewSubviews =[cell.contentView  subviews];
        for(UIView *v in viewSubviews)
        {
            if([v isKindOfClass:[UILabel class]])
            {
                UILabel *label=(UILabel*)v;
                label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
                
            }
        }
               
    }
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
