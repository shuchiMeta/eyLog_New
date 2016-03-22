//  AFNetworkSingleton.m
//  TradeStone
//
//  Created by Qss on 7/25/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "APICallManager.h"
#import "SSZipArchive.h"
#import "Utils.h"
#import "NewObservation.h"
#import "NewObservationAttachment.h"
#import "AppDelegate.h"
#import "DocumentFileHandler.h"
#import "EYLAgeBand.h"
#import "NSURL+Parameters.h"
#import "OBEcat.h"
#import "EYL_AppData.h"
#import "OBCfe.h"
#import "UIView+Toast.h"
#import "GridViewController.h"
#import "eyLogNavigationViewController.h"
#import "ContainerViewController.h"
#import "ChilderenViewController.h"

NSString *const KAPIServerURL=@"server_url";
NSString *const KAPIMessage=@"message";
NSString *const KAPIStatus=@"status";
NSString *const KAPINurseryId=@"nursery_id";
NSString *const KAPISuccess=@"success";



@implementation APICallManager
@synthesize serverURL,nurseryId,frameworkType;
static APICallManager *manager = nil;
static NSURLSessionConfiguration *configuration;
static dispatch_once_t onceToken;


+ (APICallManager *)sharedNetworkSingleton
{
    if (!manager)
    {
        dispatch_once(&onceToken, ^{
            manager=[[APICallManager alloc]init];
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            [manager initReachibility];
        });
    }
    return manager;
}
-(void)initReachibility{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkReachibilityStatus];
    });
}

//-(instancetype) init
//{
//    if(self = [super init])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self runTempDirectoryCleaner];
//        });
//    }
//
//    return  self;
//
//}


-(void)checkReachibilityStatus{

    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {
        NSLog(@"not reachable");
         NSArray *array=[RegistryDataEntity fetchAllEntriesInEntityWithContext:[AppDelegate context]];
        
        for(int i=0;i<array.count;i++)
        {
            RegistryDataEntity *reg=[array objectAtIndex:i];
            reg.isUploading=NO;
        }
        NSArray *array1= [InOutSeparateManagementEntity fetchAllDataInContext:[AppDelegate context]];
        for(int i=0;i<array.count;i++)
        {
            InOutSeparateManagementEntity * entity=[array1 objectAtIndex:i];
            entity.isInUploading=NO;
            entity.isOutUploading=NO;
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkUnreachable" object:nil];
    }
    else{
        NSLog(@"Reachable");
        [self invokeBackgroundSessionCompletionHandler];
        if(self.apiKey)
        {
        [self insertInTimeRecord];
        //[self insertRegistryData];
            
        }
        
        
    }
}

//-(void)checkReachibilityStatus{
//
//    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//    if(remoteHostStatus == NotReachable) {
//        NSLog(@"not reachable");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkUnreachable" object:nil];
//    }
//    else{
//        NSLog(@"Reachable");
//        if (!_newwObservationEntity.uniqueTabletOID) {
//            //if(!self.uploadTask)
//            [self fetchRandomObservation];
//        }
//        else{
//            if (self.uploadTask.state == NSURLSessionTaskStateCompleted) {
//                self.uploadTask = nil;
//                if(_newwObservationEntity.uniqueTabletOID)
//                    [self fetchRandomObservation];
//            }else {
//                [self.uploadTask resume];
//            }
//        }
//    }
//}

-(BOOL)isNetworkReachable{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}
- (void)networkChanged:(NSNotification *)notification
{
    [self checkReachibilityStatus];
}

-(NSMutableDictionary *)responsesData
{
    if (!_responsesData) {
        _responsesData = [[NSMutableDictionary alloc] init];
    }
    return _responsesData;
}

-(NSMutableArray *)cacheChildren
{
    if (!_cacheChildren) {
        _cacheChildren = [[NSMutableArray alloc] init];
    }
    return _cacheChildren;
}
-(NSMutableArray *)tabIdarray
{
    if (!tabIdarray) {
        tabIdarray = [[NSMutableArray alloc] init];
    }
    return tabIdarray;
    
}


-(NSString *)basicAuthorization
{
  return [NSString stringWithFormat:@"Basic %@",[[[NSString stringWithFormat:@"%@:%@",@"1234567890123456",@"eylog"] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
}

-(NSString *)apiPassword
{
//    return [[@"eylog" dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    return [[@"ZXlsb2c=" dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    return @"ZXlsb2c=";
    return _apiPassword;
}

-(NSString *)apiKey
{
//    return @"1234567890123456";
//    return @"ey-trunk-5";
    return _apiKey;
}


-(NSMutableURLRequest *)getMutableRequestWithParamDictionary:(NSDictionary *)paramDictionary withURL:(NSString *)urlStirng
{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStirng] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[self basicAuthorization] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:5*60];
    
     NSError *error=nil;

    NSData *postData = [NSJSONSerialization dataWithJSONObject:paramDictionary options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    return request;
}

-(NSMutableURLRequest *)getMutableDeleteRequestWithParamDictionary:(NSDictionary *)paramDictionary withURL:(NSString *)urlStirng
{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStirng] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[self basicAuthorization] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    NSError *error=nil;

    NSData *postData = [NSJSONSerialization dataWithJSONObject:paramDictionary options:0 error:&error];
    [request setHTTPBody:postData];
    return request;
}

-(NSURLSession *)getSession
{
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
   // configuration.HTTPAdditionalHeaders=@{@"Authorization":[self basicAuthorization]};
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue: nil];
      session.configuration.timeoutIntervalForResource = 120;
      session.configuration.timeoutIntervalForRequest = 120;
    return session;
}

- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = nil;
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.mds.eyLog.BackgroundSession"];
            //configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        else{
           configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.mds.eyLog.BackgroundSession"];
            //configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }

        configuration.timeoutIntervalForRequest = 60.0;
        configuration.timeoutIntervalForResource = 6000.0;

        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

-(void)showHudMessageOnUniversalWindow:(NSString *)message
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    MBProgressHUD *hud=[MBProgressHUD  showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText= @"Observation Upload Failed";
    hud.userInteractionEnabled=YES;
    hud.detailsLabelText = [NSString stringWithFormat:@"Reason : %@",message];
    hud.margin = 10.f;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
    {
        hud.yOffset=280;
    }
    else
    {
        hud.yOffset=400;
    }
    [hud hide:YES afterDelay:2];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }

    NSLog(@"All tasks are finished");
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    
      //just to make sure if thebHi re is any unwanted exception it is handeled
//    if(!currentObservation)
//    {
//        [self invokeBackgroundSessionCompletionHandler];
//        return;
//    }

    if (error == nil)
    {
        // server gave failure
        NSLog(@"Task: %@ completed successfully", task);
        double progress = (double)task.countOfBytesReceived / (double)task.countOfBytesExpectedToReceive;
        NSLog(@"Upload Progess : %lf",progress);

        NSMutableData *responseData = self.responsesData[@(task.taskIdentifier)];
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        if (jsonDict) {
            NSLog(@"response = %@", jsonDict);
            
            NSString *observationID =[jsonDict objectForKey:@"unique_tablet_id"];
            NewObservation *currentObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:observationID];
            currentObservation.isProccessed=NO;
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                NSString *status = [jsonDict objectForKey:@"status"];
                //NSString *tempID = [jsonDict objectForKey:@"unique_tablet_id"];
                if ([status isEqualToString:@"success"])
                {
                    NSString *dataFilePath = [observationID stringByAppendingPathExtension:@"NSData"];
                    NSString *filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:@"UploadData"] stringByAppendingPathComponent:dataFilePath];//dat
                    BOOL isDeletedDataFile = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                    if (isDeletedDataFile) {
                        NSLog(@"Deleted Successfully");
                        
                    }else {
                        NSLog(@"Not Deleted");
                        
                    }
 
                    currentObservation.isUploaded = YES;
                    NSArray *observationAttachments = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withObservationId:currentObservation.uniqueTabletOID];

                    for (NewObservationAttachment * attachment in observationAttachments) {
                            NSString * filePath = [DocumentFileHandler setDocumentDirectoryforPath:attachment.attachmentPath];
                            filePath = [filePath stringByAppendingPathComponent:attachment.attachmentName];
                            [DocumentFileHandler removeItemAtPath:filePath];

                    }
                    if (observationAttachments) {
                        [NewObservationAttachment deleteObservationAttachmentInContext:[AppDelegate context] withObject:observationAttachments];
                    }
                    BOOL isDeleted = NO;
                    if (currentObservation) {
                        // UserDefault to save info about Current observation hold by upload taks
                        // removing Userdefault value
                        [[NSUserDefaults standardUserDefaults] setObject:@"removed" forKey:@"uploadEntity"];
                        isDeleted = [NewObservation deleteObservationInContext:[AppDelegate context] withObject:@[currentObservation]];
                    }
                    if (isDeleted) {
                        [self performSelectorOnMainThread:@selector(sendRefreshCall) withObject:nil waitUntilDone:YES];
                        currentObservation = nil;
                        //self.uploadTask = nil;
                    }

                    if ([self isNetworkReachable])
                    {
//                        if(!_newwObservationEntity.uniqueTabletOID)
//                            [self fetchRandomObservation];
                        [self invokeBackgroundSessionCompletionHandler];
                            return;
                    }
                }
                else
                {
                    NSString *message = [jsonDict objectForKey:@"message"];
                    [self performSelectorOnMainThread:@selector(showHudMessageOnUniversalWindow:) withObject:message waitUntilDone:YES];
                    currentObservation.isUploaded = NO;
                    currentObservation.isUploading = NO;
                    currentObservation.readyForUpload = YES;
                    currentObservation = nil;
                   //[self.responsesData removeObjectForKey:@(task.taskIdentifier)];

                }
            }

        }
        else
        {
            // server returned inappropriate json
            
            
             //[[NSUserDefaults standardUserDefaults] setObject:<#(nullable id)#> forKey:@"UniqueTabId"];
            NSString *observationID = task.originalRequest.URL[@"unique_tablet_id"];
            NewObservation *currentObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:observationID];
           
            currentObservation.isUploaded = NO;
            currentObservation.isUploading = NO;
            currentObservation.readyForUpload = YES;
            currentObservation = nil;
            NSLog(@"responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        }

        [self.responsesData removeObjectForKey:@(task.taskIdentifier)];

    } else
    {
        // call failed
        NSString *observationID = task.originalRequest.URL[@"unique_tablet_id"];
        NewObservation *currentObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withUniqueTabletOID:observationID];
        currentObservation.isUploaded = NO;
        currentObservation.isUploading = NO;
        currentObservation.readyForUpload = YES;
        currentObservation = nil;
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }

    [[AppDelegate context]save:nil];
    //[self invokeBackgroundSessionCompletionHandler];

//    if ([self isNetworkReachable])
//    {
//        if(!_newwObservationEntity.uniqueTabletOID)
//            [self fetchRandomObservation];
//    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    if(error.code ==  NSURLErrorTimedOut)
    {
        NSLog(@"Call time out");
    }
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (task == self.uploadTask) {
        double progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
        _newwObservationEntity.isUploading = YES;
        
        NSLog(@"UploadTask: %@ progress: %lf", task, progress);
        NSMutableDictionary * dict;
        if (!dict) {
            dict = [NSMutableDictionary dictionary];
        }
        [dict setValue:@(progress) forKey:@"progress"];
        [dict setValue:_newwObservationEntity forKey:@"NewObservationEntity"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadingPercentage" object:dict];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = progress;
//        });
    }
}

- (void)sendRefreshCall {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUploadQueueAfterUploadedObservation" object:nil];
}

#pragma mark - NSURLSessionDataTaskDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if (!data) {
        NSLog(@"Data is Null");
    }

    NSMutableData *responseData = self.responsesData[@(dataTask.taskIdentifier)];
    if (!responseData) {
        responseData = [NSMutableData dataWithData:data];
        self.responsesData[@(dataTask.taskIdentifier)] = responseData;
    } else {
        [responseData appendData:data];
    }
}

#pragma mark - eyLog Data API

-(void)getServerUrlWithKey:(NSString *)apiKey andPassword:(NSString *)apiPassword fromController:(UIViewController *)controller
{
    if ([Utils checkNetwork]) {
        //https://eylog.co.uk/api/validate
        
         NSString *url=@"https://eylog.co.uk/api/validate";
        
        
        //NSString *url=@"https://demo.eylog.co.uk/api/validate";
        
        //NSString *url=@"http://134.213.98.244/api/validate";

        NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:apiKey ,@"api_key",
                                 apiPassword, @"api_password",
                                 nil];

        UIViewController *topVC = controller.navigationController;
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
        hud.labelText=@"Validating Key and Password...";
    
        NSURLSessionDataTask *datatask=[[self getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:mapData withURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                        {
                                            @try
                                            {
                                                NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                NSLog(@"Validation API : %@",jsonDict);

                                                if([[jsonDict objectForKey:KAPIStatus] isEqualToString:KAPISuccess])
                                                {
                                                    serverURL=[jsonDict objectForKey:KAPIServerURL];
// serverURL = @"http://192.168.0.187/eylogwebapp/";
                                                  // serverURL=@"https://eylog.co.uk/ey-demo/";
                                                    nurseryId=[jsonDict objectForKey:KAPINurseryId];
                                                    self.apiKey = apiKey;
                                                    self.apiPassword = apiPassword;

                                                    NSMutableDictionary *installationData = [[NSMutableDictionary alloc] init];

                                                    [installationData setObject:apiKey forKey:@"apiKey"];
                                                    [installationData setObject:apiPassword forKey:@"apiPassword"];
                                                    [installationData setObject:serverURL forKey:@"serverURL"];
                                                    [installationData setObject:nurseryId forKey:@"nurseryId"];
                                                    
                                                    [NSKeyedArchiver archiveRootObject: installationData toFile:[Utils getInstallationData]];

                                                    NSFileManager *fileManager=[[NSFileManager alloc]init];
                                                    NSError *childError;

                                                    long childrenCount = [fileManager contentsOfDirectoryAtPath:[Utils getChildrenImages] error:&childError].count;

                                                    if( childrenCount > 0)
                                                    {
                                                        NSLog(@"%ld Children Images already Exits.", childrenCount);
                                                    }
                                                    else
                                                    {
                                                        //[self performSelectorInBackground:@selector(getAllChildrenImages) withObject:nil];
                                                        // [self getAllChildrenImages];
                                                    }

                                                    NSError *parentError;

                                                    long practitionerCount = [fileManager contentsOfDirectoryAtPath:[Utils getChildrenImages] error:&parentError].count;

                                                    if( practitionerCount > 0)
                                                    {
                                                        NSLog(@"%ld Practitioner Images already Exits.", practitionerCount);
                                                    }
                                                    else
                                                    {
                                                        //[self performSelectorInBackground:@selector(getTeacherImage) withObject:nil];
                                                    }

                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        UIViewController *topVC = controller.navigationController;
                                                        [MBProgressHUD hideHUDForView:topVC.view animated:YES];

                                                        [controller performSegueWithIdentifier:@"HomeViewControllerSegueID" sender:controller];
                                                    });

                                                }
                                                else
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        UIViewController *topVC = controller.navigationController;
                                                        [MBProgressHUD hideHUDForView:topVC.view animated:YES];

                                                        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
                                                        hud.mode = MBProgressHUDModeText;
                                                        hud.labelText=@"Unable to Validate Credentials.";
                                                        hud.margin = 10.f;
                                                        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
                                                        {
                                                            hud.yOffset=280;
                                                        }
                                                        else
                                                        {
                                                            hud.yOffset=400;
                                                        }

                                                        [hud hide:YES afterDelay:3];
                                                    });

                                                }
                                            }
                                            @catch (NSException *exception) {

                                                NSLog(@"Expection Cateched %@",exception);
                                            }


                                        }];

        [datatask resume];
    }

    [self checkReachibilityStatus];
}

-(INBaseClass *)getInstallation
{
    //serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *urlString=[NSString stringWithFormat:@"%@api/installation",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [self apiKey],@"api_key",
                             [self apiPassword], @"api_password",
                             nil];

    __block INBaseClass *baseObject;

    NSURLSessionDataTask *postDataTask = [[self getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {

                     //   NSString *jsonString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        NSLog(@"Installation API : %@", jsonDict);
                        baseObject=[[INBaseClass alloc]initWithDictionary:jsonDict];
                       
            
        }];

    [postDataTask resume];
    return baseObject;
}
- (void) getRegistryINOUTTime
{
    NSMutableArray *array_childId=[NSMutableArray new];
    
    for (INData *children in self.childArray)
    {
        
        [array_childId addObject:children.childId];
        
    }
    
    NSString *theStr = [array_childId componentsJoinedByString:@","];
    NSString *urlString=[NSString stringWithFormat:@"%@api/api/registry/getAllChildrenRegistry",[APICallManager sharedNetworkSingleton].serverURL ];
    APICallManager *objManager = [APICallManager sharedNetworkSingleton];
    
    //  NSString *practitionerPin=[APICallManager sharedNetworkSingleton].cachePractitioners.pin;
    //NSNumber *practitionerId=[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId;
    // practitionerId,@"practitioner_id",
    //   practitionerPin,@"practitioner_pin",
    
    NSDictionary *inputDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     objManager.apiKey,@"api_key",
                                     objManager.apiPassword,@"api_password",
                                     theStr,@"child_id",
                                     [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]], @"date",
                                     nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            NSLog(@"Unable to get Registry ");
            
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@" Response%@", jsonDict);
            [[NSUserDefaults standardUserDefaults] setObject:@"registry" forKey:@"FirstTimeRegistry"];
//            NSArray *tempArray = [[jsonDict valueForKey:@"data"] allKeys];
//            
//            for (int i=0; i<[tempArray count]; i++)
//            {
//                NSArray *registryCout = [[[jsonDict valueForKey:@"data"] valueForKey:tempArray[i]] valueForKey:@"registry"];
//                NSInteger inte=[tempArray[i] integerValue];
//                NSNumber *num=[NSNumber numberWithInteger:inte];
//                
//                if(registryCout )
//                [Child updateRegistryArrayForChild:num :[NSMutableArray arrayWithArray:registryCout]  forContext:[AppDelegate context]];
//                 NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSMutableArray arrayWithArray:registryCout],[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]], nil];
//                [Child updateDictionaryDataForInoutTime:dictionary :num forContext:[AppDelegate context]];
//                
//                if (registryCout)
//                {
//                    if(registryCout.count>0)
//                    {
//                        NSDictionary *childDict = [registryCout lastObject];
//                        if(childDict.count>0&&[childDict valueForKey:@"came_in_at"]!=nil&&[childDict valueForKey:@"left_at"]!=nil)
//                        {
//                            [Child updateChild:tempArray[i] inTime:[childDict valueForKey:@"came_in_at"] andOutTime:[childDict valueForKey:@"left_at"] forContext:[AppDelegate context]];
//                        }
//                    }
//                    
//                }
//                
//            }
            
            NSArray *tempArray = [[jsonDict valueForKey:@"data"] allKeys];
            
            for (int i=0; i<[tempArray count]; i++)
            {
                NSDictionary *registryCout = [[jsonDict valueForKey:@"data"] valueForKey:tempArray[i]];
                NSInteger inte=[tempArray[i] integerValue];
                
                NSNumber *num=[NSNumber numberWithInteger:inte];
                
//                [Child updateRegistryArrayForChild:num :[NSMutableArray arrayWithArray:registryCout]  forContext:[AppDelegate context]];
//                NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSMutableArray arrayWithArray:registryCout],[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]], nil];
//                [Child updateDictionaryDataForInoutTime:dictionary :num forContext:[AppDelegate context]];
                
                
                if (registryCout)
                {
                    if(registryCout.count>0)
                    {
                        NSDictionary *childDict = [NSDictionary dictionaryWithDictionary:registryCout];
                        if(childDict.count>0&&[childDict valueForKey:@"came_in_at"]!=nil&&[childDict valueForKey:@"left_at"]!=nil)
                        {
                            NSString *leftAtStr= [childDict objectForKey:@"left_at"];
                            NSString *cameINStr=[childDict objectForKey:@"came_in_at"];
                            
                            if ([[childDict objectForKey:@"registrystatus"] integerValue]!=0)
                            {
                                
                            [Child updateChild:num inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:[NSNumber numberWithInteger:[[childDict objectForKey:@"registrystatus"] integerValue]]  forContext:[AppDelegate context]];
                            }
                            else
                            {

                            if(cameINStr.length>0&& leftAtStr.length>0 )
                            {
                                [Child updateChild:num inTime:[childDict objectForKey:@"came_in_at"] andOutTime:[childDict objectForKey:@"left_at"] andRegistryStatus:nil forContext:[AppDelegate context]];
                                
//                                NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
//                                NSNumber *num=[NSNumber numberWithInteger:[uniqueTabletOIID integerValue]] ;
//                                
//                                [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]] withDate:nil withChildId:num withInTime:[childDict objectForKey:@"came_in_at"] withOutTime:[childDict objectForKey:@"left_at"] withisInUploaded:YES withIsOutUploaded:YES withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[childDict objectForKey:@"clienttimestamp"]];
                            }
                              if(cameINStr.length>0&& leftAtStr.length==0)
                                
                            {
                                [Child updateChild:num inTime:[childDict objectForKey:@"came_in_at"] andOutTime:@"" andRegistryStatus:nil  forContext:[AppDelegate context]];
                                
                                NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[[NSDate date] timeIntervalSince1970] * 1000.0];
                                NSNumber *num=[NSNumber numberWithDouble:[uniqueTabletOIID doubleValue]] ;
                                
                                [InOutSeparateManagementEntity createInRowContext:[AppDelegate context] withUid:num withDateStr:[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]] withDate:nil withChildId:num withInTime:[childDict objectForKey:@"came_in_at"] withOutTime:@"00:00" withisInUploaded:YES withIsOutUploaded:NO withPractitionerPin:nil withPractitionerId:nil withtimeStamp:[childDict objectForKey:@"clienttimestamp"]];
                            }
                           
                            }
                            
                            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                            [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
                            NSString *string = [dateFormatter2 stringFromDate:[NSDate date]];
                            
                            [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:childDict forChild:num withDate:string];
                        }
                    }
                    
                }
                
            }

            
        });
        
    }];
    [postDataTask resume];
}

-(void)getTeacherImage
{

   // serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *urlString=[NSString stringWithFormat:@"%@api/staff/photos",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [self apiKey],@"api_key",
                             [self apiPassword], @"api_password",
                             nil];


    NSURLSessionDataTask *postDataTask = [[self getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {

                                              NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff.zip"];
                                              NSString *staffFolder=[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff"];
                                              if([data writeToFile:yourArtPath atomically:YES])
                                              {

                                                  if([SSZipArchive unzipFileAtPath:yourArtPath toDestination:staffFolder])
                                                  {
                                                      NSLog(@"Successfully unarchived Practitioner Images");
                                                  }
                                                  else
                                                  {
                                                     // [self performSelectorInBackground:@selector(getTeacherImage) withObject:nil];
                                                      NSLog(@"Error while unarchiving Practitioner Images");
                                                  }
                                              }
                                          }];

    [postDataTask resume];

}

-(void)getAllChildrenImages
{
    
    

  //  serverURL=@"https://demo.eylog.co.uk/trunk/";
    NSString *urlString=[NSString stringWithFormat:@"%@api/children/photos",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [self apiKey],@"api_key",
                             [self apiPassword], @"api_password",
                             nil];

    NSURLSessionDataTask *postDataTask = [[self getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {

                                              NSString *yourArtPath = [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Children.zip"];
                                              NSString *childrenFolder=[[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Children"];
                                              if([data writeToFile:yourArtPath atomically:YES])
                                              {
                                                  if([SSZipArchive unzipFileAtPath:yourArtPath toDestination:childrenFolder])
                                                  {
                                                      NSLog(@"Successfully unarchived Children Images");
                                                     
                                                     
                                                      
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:nil];

                                                  }
                                                  else
                                                  {
                                                      //[self performSelectorInBackground:@selector(getAllChildrenImages) withObject:nil];
                                                      NSLog(@"Error while unarchiving Children Images");
                                                  }
                                                 
                                                  
                                              }
                                          }];
    [postDataTask resume];
}
-(void)getSummativeReportsListWithSuccessBlock:(void (^)(NSDictionary *dict))success andFailureBlock:(void (^)(NSError * error))failure
{
    // Hack to fix the cache child issue
    if([APICallManager sharedNetworkSingleton].cacheChildren.count == 0)
    {
        [APICallManager sharedNetworkSingleton].cacheChild = nil;
    }

    NSString * practionerPin = self.cachePractitioners.pin;//@"kQFVqzm6jdtobPGwUXT1a9weLuLVtL+QzI8sTiM/Va0=";
    NSString * practionerId = [NSString stringWithFormat:@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId];//@"300";//self.cacheChild.practitionerId


//    NSMutableArray *childIdArray = [[NSMutableArray alloc] init];
//    for(Child* child in  [APICallManager sharedNetworkSingleton].cacheChildren)
//    {
//         [childIdArray addObject:child.childId];
//    }

    NSString *urlString=[NSString stringWithFormat:@"%@api/summative_reports/lists",serverURL];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: [self apiKey],@"api_key",
                             [self apiPassword], @"api_password",
                             practionerPin,@"practitioner_pin",
                             practionerId,@"practitioner_id",
                             [APICallManager sharedNetworkSingleton].cacheChild.childId,@"child_id",
                             nil];

    NSURLSessionDataTask *postDataTask = [[self getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:mapData withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                                if (error) {
                                                  NSLog(@"error %@",error);
                                                  failure(error);
                                              }
                                              else{
                                                  NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  NSLog(@"Summative JSON : %@",jsonDict);
                                                  success(jsonDict);
                                              }

                          }];
    [postDataTask resume];

}
-(UIImage*) resizeImage:(UIImage *)inImage toRect:(CGRect)thumbRect
{
    CGImageRef          imageRef = [inImage CGImage];
    CGBitmapInfo        bitmapInfo = CGImageGetBitmapInfo(imageRef);

    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,       // width
                                                thumbRect.size.height,      // height
                                                CGImageGetBitsPerComponent(imageRef),   // really needs to always be 8
                                                4 * thumbRect.size.width,   // rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                bitmapInfo
                                                );

    // Draw into the context, this scales the image
    CGContextDrawImage(bitmap, thumbRect, imageRef);

    // Get an image from the context and a UIImage
    CGImageRef  ref = CGBitmapContextCreateImage(bitmap);
    UIImage*    result = [UIImage imageWithCGImage:ref];

    CGContextRelease(bitmap);   // ok if NULL
    CGImageRelease(ref);

    return result;
}

//- (void)invokeBackgroundSessionCompletionHandler
//{
//    [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == %i || state == %i", NSURLSessionTaskStateRunning, NSURLSessionTaskStateCanceling];
//        NSArray *temp = [uploadTasks filteredArrayUsingPredicate:predicate];
//        if (temp.count <= 0) {
//            [self fetchRandomObservation];
//        }
//    }];
//}

//-(void)runTempDirectoryCleaner
//{
//    [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks)
//     {
//        if(uploadTasks.count > 0)
//            return;
//
//         NSArray * allObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:YES withUploading:NO withUploaded:NO];
//         if(allObservation.count > 0)
//             return;
//
//         NSArray* temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
//         for (NSString *file in temp) {
//             [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
//         }
//
//     }];
//}

- (void)invokeBackgroundSessionCompletionHandler
{
    [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks)
    {
        // To clear the current temp folder
        if(uploadTasks.count <= 0)
        {
            NSArray * allObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:YES withUploading:NO withUploaded:NO];
            if(allObservation.count <= 0)
            {
                NSArray* temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
                for (NSString *file in temp) {
                    //[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
                }
                return;
            }
        }

        for(NSURLSessionUploadTask *task in uploadTasks)
        {
            if(task.state == NSURLSessionTaskStateRunning || task.state == NSURLSessionTaskStateCanceling)
            {
//                [task cancel];
//                [task suspend];
                [task resume];
                return;
            }
        }

        if ([self isNetworkReachable])
            [self fetchRandomObservation];
    }];
   
}

-(void)fetchRandomObservation{

    NSArray * allObservation = [NewObservation fetchObservationInContext:[AppDelegate context] withReadyForUpload:YES withUploading:NO withUploaded:NO];
    NSLog(@"Total Observations in queue === %lu",(unsigned long)allObservation.count);
    if (allObservation.count >0) {
        _newwObservationEntity = [allObservation objectAtIndex:rand()%allObservation.count];
         _newwObservationEntity.isProccessed=YES;
        
        // Saving Current Observation hold by Upload task so that we can check in upload Queue which observation was hold be Upload task
        [[NSUserDefaults standardUserDefaults] setObject:_newwObservationEntity.uniqueTabletOID forKey:@"uploadEntity"];
        
        //_newwObservationEntity.isUploading = YES;
        //        [self uploadRandomObservation];
        [self performSelectorOnMainThread:@selector(uploadRandomObservation) withObject:nil waitUntilDone:NO];
    }
}

-(void)uploadRandomObservation
{

    NSLog(@"Currently Processing observation with id :::::: %@",_newwObservationEntity.uniqueTabletOID);
 //   NSString *urlString=[NSString stringWithFormat:@"%@api/observations?unique_tablet_id=%@",serverURL,_newwObservationEntity.uniqueTabletOID];
    NSString *urlString=[NSString stringWithFormat:@"%@api/observations",serverURL];
    NSURL *url = [NSURL URLWithString:urlString];
   
      
    NSLog(@"Upload URL : %@",urlString);

    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //NSURLRequestReloadIgnoringLocalCacheData

    NSURL * urll = [NSURL URLWithString:urlString];
    [request setURL:urll];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"----WebKitFormBoundarykbWBAArkKj99P6kw";//@"eyLog_Boundary_String";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    // Edited BY ARPAN
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"unique_tablet_OID\"\r\n\r\n%@", _newwObservationEntity.uniqueTabletOID] dataUsingEncoding:NSUTF8StringEncoding]];

    if (_newwObservationEntity.apiKey) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n%@", _newwObservationEntity.apiKey] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.apiPassword) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_password\"\r\n\r\n%@", _newwObservationEntity.apiPassword] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.practitionerPin) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_pin\"\r\n\r\n%@", _newwObservationEntity.practitionerPin] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.practitionerId) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"practitioner_id\"\r\n\r\n%@", _newwObservationEntity.practitionerId] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.observationCreatedAt) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *string = [formatter stringFromDate:_newwObservationEntity.observationCreatedAt];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"date_time\"\r\n\r\n%@", string] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.uniqueTabletOID) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"unique_tablet_OID\"\r\n\r\n%@", _newwObservationEntity.uniqueTabletOID] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.childId) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"child_id[]\"\r\n\r\n%@", _newwObservationEntity.childId] dataUsingEncoding:NSUTF8StringEncoding]];

    }
    if (_newwObservationEntity.observation) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"observation\"\r\n\r\n%@", _newwObservationEntity.observation] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([_newwObservationEntity.observationId integerValue] >0) {
        NSLog(@"Uploading Observation Id : %@", _newwObservationEntity.observationId);

        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"observation_id\"\r\n\r\n%@", _newwObservationEntity.observationId] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.mode) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mode\"\r\n\r\n%@", _newwObservationEntity.mode] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.analysis) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"analysis\"\r\n\r\n%@", _newwObservationEntity.analysis ? _newwObservationEntity.analysis : @""] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.nextSteps) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"next_steps\"\r\n\r\n%@", _newwObservationEntity.nextSteps ? _newwObservationEntity.nextSteps : @""] dataUsingEncoding:NSUTF8StringEncoding]];

    }

    if (_newwObservationEntity.additionalNotes) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comments\"\r\n\r\n%@", _newwObservationEntity.additionalNotes ? _newwObservationEntity.additionalNotes : @""] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.strInternalNotes) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"staff_comments\"\r\n\r\n%@", _newwObservationEntity.strInternalNotes ? _newwObservationEntity.strInternalNotes : @""] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.quickObservation) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"quick_observation\"\r\n\r\n%@", _newwObservationEntity.quickObservation] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([_newwObservationEntity.scaleInvolvement integerValue]>0) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"scale_involvement\"\r\n\r\n%@", _newwObservationEntity.scaleInvolvement] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([_newwObservationEntity.scaleWellBeing integerValue]>0) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"scale_well_being\"\r\n\r\n%@", _newwObservationEntity.scaleWellBeing] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.coel) {
        NSMutableArray *coelArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.coel];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"coel\"\r\n\r\n%@", coelArray.count > 0 ? [coelArray componentsJoinedByString:@","] : @""] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.eyfsStatement) {
        NSMutableArray *eyfsStatementArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.eyfsStatement];
        NSMutableString * string = [NSMutableString string];
        int count = 0;
        for (OBEyfs * obEyfs in eyfsStatementArray) {
            [string appendString:[NSString stringWithFormat:@"%@",obEyfs.frameworkItemId]];
            count++;
            if (!(count == eyfsStatementArray.count)) {
                [string appendString:@","];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"statement\"\r\n\r\n%@", string] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.eyfsAgeBand) {
        NSMutableArray *eyfsAgeBandAssessmentArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.eyfsAgeBand];
        NSMutableString * string = [NSMutableString string];
        int count = 0;
        for (EYLAgeBand * eylAgeBand in eyfsAgeBandAssessmentArray) {
            [string appendString:[NSString stringWithFormat:@"%@-%@",eylAgeBand.ageIdentifier,eylAgeBand.levelNumber]];
            count++;
            if (!(count == eyfsAgeBandAssessmentArray.count)) {
                [string appendString:@","];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"age_band_assessment\"\r\n\r\n%@", string] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.montessori) {
        NSMutableArray *montessoriArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.montessori];
        NSMutableString * firstString = [NSMutableString string];
        NSMutableString * secondString = [NSMutableString string];

        int count = 0;
        for (OBMontessori * montessori in montessoriArray) {
            [firstString appendString:[NSString stringWithFormat:@"%@-%@",montessori.montessoriFrameworkItemId,montessori.montessoriFrameworkLevelNumber]];
            [secondString appendString:[NSString stringWithFormat:@"%@",montessori.montessoriFrameworkItemId]];
            count++;
            if (count < montessoriArray.count) {
                [firstString appendString:@","];
                [secondString appendString:@","];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"montessori\"\r\n\r\n%@", secondString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"montessori_assessment_level\"\r\n\r\n%@", firstString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_newwObservationEntity.cfe) {
        NSMutableArray *cfeArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.cfe];
        NSMutableString * firstString = [NSMutableString string];
        NSMutableString * secondString = [NSMutableString string];
        
        int count = 0;
        for (OBCfe * cfe in cfeArray) {
            [firstString appendString:[NSString stringWithFormat:@"%@-%@",cfe.cfeFrameworkItemId,cfe.cfeFrameworkLevelNumber]];
            [secondString appendString:[NSString stringWithFormat:@"%@",cfe.cfeFrameworkItemId]];
            count++;
            if (count < cfeArray.count) {
                [firstString appendString:@","];
                [secondString appendString:@","];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"scottish\"\r\n\r\n%@", secondString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"scottish_assessment_level\"\r\n\r\n%@", firstString] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (_newwObservationEntity.ecat) {
        NSMutableArray *ecatArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.ecat];
      //  NSMutableString * firstString = [NSMutableString string];
        NSMutableString * secondString = [NSMutableString string];

        int count = 0;
        for (OBEcat * ecat in   ecatArray) {
            //[firstString appendString:[NSString stringWithFormat:@"%@-%@",ecat.ecatFrameworkItemId,ecat.ecatFrameworkLevelNumber]];
            [secondString appendString:[NSString stringWithFormat:@"%@",ecat.ecatFrameworkItemId]];
            count++;
            if (count < ecatArray.count) {
                //[firstString appendString:@","];
                [secondString appendString:@","];
            }
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ecat_assessment\"\r\n\r\n%@", secondString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ecat_assessment_level\"\r\n\r\n%@", [_newwObservationEntity.ecatAssessmentLevel stringValue]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

  //  NSArray *arr=[NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withObservationId:[NSString stringWithFormat:@"%@",_newwObservationEntity.uniqueTabletOID]];
    
    NSArray *mediaFiles = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withPractitionerId:_newwObservationEntity.practitionerId withChildId:_newwObservationEntity.childId withObservationId:[NSString stringWithFormat:@"%@",_newwObservationEntity.uniqueTabletOID] withIsAdded:YES andIsDeleted:NO];
   
    NSString *str;
   if(_newwObservationEntity.isBefore)
   {
       NSArray *myNsArray = [NSKeyedUnarchiver unarchiveObjectWithData:_newwObservationEntity.childIdArray];
       
       NSMutableArray *array=[NSMutableArray new];
       for(int i=0;i<myNsArray.count;i++)
       {
           NSArray* pathURL = [[myNsArray objectAtIndex:i] componentsSeparatedByString: @"/"];
           NSString* pdfFileName = [pathURL lastObject];
           [array addObject:pdfFileName];
           
       }
     
       str=[array componentsJoinedByString:@","];
       
   }


    NSLog(@"MEDIAFILE_COUNT %lu",(unsigned long)mediaFiles.count);

    if((unsigned long)mediaFiles.count > 0)
    {
        if(_newwObservationEntity.checksums)
        {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"checksums\"\r\n\r\n%@", _newwObservationEntity.checksums] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        NSLog(@"CheckSUM %@",_newwObservationEntity.checksums);
    }
    NSLog(@"CheckSUM %@",_newwObservationEntity.checksums);


    for (NewObservationAttachment *attachment in mediaFiles)
    {
        __block NSData *data;

        NSString * fileName = [attachment.attachmentPath stringByAppendingPathComponent:attachment.attachmentName];
        NSString * filePath = [DocumentFileHandler setDocumentDirectoryforPath:fileName];
        NSLog(@"Filename =%@ and filepath =%@",fileName,filePath);
        data = [NSData dataWithContentsOfFile:filePath];

        if ([attachment.attachmentType isEqualToString:kUTTypeImageType])
        {
            NSLog(@"Image : %@", attachment.attachmentName);

            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; filename=\"%@\"\r\n", attachment.attachmentName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"Image Path : %@", attachment.attachmentPath);
            [body appendData:data];
        }
        else if ([attachment.attachmentType isEqualToString:kUTTypeVideoType])
        {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            NSLog(@">>>>>>>> %@", fileURL);
                NSLog(@"Video : %@", attachment.attachmentName);
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; filename=\"%@\"\r\n", attachment.attachmentName] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: video/Mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"Video Path : %@", attachment.attachmentPath);
                [body appendData:data];
        }
        else if ([attachment.attachmentType isEqualToString:kUTTypeAudioType])
        {
            NSLog(@"Audio : %@", attachment.attachmentName);
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; filename=\"%@\"\r\n", attachment.attachmentName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: audio/m4a\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"Audio Path : %@", attachment.attachmentPath);
            [body appendData:data];
        }
    }
    NSArray *deletedFiles = [NewObservationAttachment fetchObservationAttachmentInContext:[AppDelegate context] withPractitionerId:_newwObservationEntity.practitionerId withChildId:_newwObservationEntity.childId withObservationId:[NSString stringWithFormat:@"%@",_newwObservationEntity.uniqueTabletOID] withIsAdded:NO andIsDeleted:YES];

    if (deletedFiles.count >0) {
        NSMutableString * deletedMediaString = [NSMutableString string];

        int i = 0;
        for (NewObservationAttachment *attachment in deletedFiles)
        {
            i++;
            [deletedMediaString appendString:attachment.deletePath];
            if (i != deletedFiles.count) {
                [deletedMediaString appendString:@","];
            }

        }

        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"deleted_media\"\r\n\r\n%@", deletedMediaString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
       
    //old_media_files
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if(str.length>0)
    {
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"old_media_files\"\r\n\r\n%@", str] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSString *dataFilePath = [_newwObservationEntity.uniqueTabletOID stringByAppendingPathExtension:@"NSData"];
    NSString *filePath = [[DocumentFileHandler setTemporaryDirectoryforPath:@"UploadData"] stringByAppendingPathComponent:dataFilePath];//dat
    [body writeToFile:filePath atomically:YES];

    self.uploadTask = [[self backgroundSession] uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath]];
    [self.uploadTask resume];
}

+(void)setManagerNil
{
    manager=nil;
    onceToken=0;

}
- (void)saveDate:(NSDate *)date withID:(NSString *)udid {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"dates.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    if (!date) {
        date = [NSDate date];
    }
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    if (udid) {
        [dict setObject:date forKey:udid];
    }
    [dict writeToFile:plistPath atomically:YES];

}

- (NSDate *)getDateWithUDID:(NSString *)udid {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"dates.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    if (udid) {
        return [dict objectForKey:udid];
    }
    return nil;
}

-(void)fetchAllInOutTime
{
    if(_childInOutEntity != Nil)
        return;

    NSPredicate *recordIDPredicate=[NSPredicate predicateWithFormat:@"uploadFlag = %@",[NSNumber numberWithInt:0]];
    NSArray *records=[ChildInOutTime fetchAllRecordsWithPredicate:recordIDPredicate inContext:[AppDelegate context]];

    if (records.count >0)
    {
        _childInOutEntity = [records objectAtIndex:rand()%records.count];
        [self performSelectorOnMainThread:@selector(fetchRegistryFromServer) withObject:nil waitUntilDone:NO];
    }
}

-(void) fetchRegistryFromServer
{
    /*
     *  This method is used to fetch Registry Data of Daily Diary from the Server
     *  If the response if YES, then these parameter will be added to the upload queue
     */
    NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary/childcurrentregistry",serverURL];
    NSDictionary *inputDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     _apiKey,@"api_key",
                                     _apiPassword,@"api_password",
                                     _cachePractitioners.pin,@"practitioner_pin",
                                     [NSString stringWithFormat:@"%@",_cachePractitioners.eylogUserId],@"practitioner_id",
                                     _childInOutEntity.childID,@"child_id",
                                     _childInOutEntity.currentDate,@"date",nil];
    
    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){ 
        if(error)
        {
            NSLog(@"Fail while Fetching Registry Data from the server");
            NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
            if(remoteHostStatus == NotReachable) {
            }
            else
            {
                NSLog(@"Reachable Again Calling Random InOutEntity Upload");
                _childInOutEntity=nil;
               // [self fetchAllInOutTime];
            }
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
             NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Registry Data fetch for particular child %@", jsonDict);
            
            NSArray *tempArray = [[NSArray alloc] init];
            
            if ([[jsonDict valueForKey:@"message"] isEqualToString:@"Registry Not found."])
            {
                
                [self uploadRandomInOutTimeRecord:tempArray];
            }
            else
            {
                tempArray = [[jsonDict valueForKey:@"data"] valueForKey:@"registry"];
                [self uploadRandomInOutTimeRecord:tempArray];
            }
            
        });
        
    }];
    [postDataTask resume];
}
-(void)insertRegistryData
{
    //[RegistryDataEntity deleteRowAndContext:[AppDelegate context]];
    NSArray *array=[RegistryDataEntity fetchAllEntriesInEntityWithContext:[AppDelegate context]];
    for(int i = 0;i<array.count;i++)
    {
        RegistryDataEntity *entity=[array objectAtIndex:i];
        if(!entity.isUploading)
        {
           
            
        NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:entity.jsonDict];
        NSString *uRL=[APICallManager sharedNetworkSingleton].serverURL;
        NSString *urlString=[NSString stringWithFormat:@"%@api/registry/updateregistry",uRL];
         entity.isUploading=YES;
            NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[[APICallManager sharedNetworkSingleton] getMutableRequestWithParamDictionary:dict withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Failed to post data on the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//                [self performSelectorInBackground:@selector(closeAlert) withObject:nil];
                
//                if ([eyl_AppDaya.savePickerDate isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
//                {
//                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
//                    [Child updateChild:[NSNumber numberWithInt:[eyl_AppDaya.selectedChild intValue]] inTime:obk.strCameAt andOutTime:obk.strLeftAt andRegistryStatus:nil forContext:[AppDelegate context]];
//                    
//                    obk=nil;
//                }
                entity.isUploading=NO;
                
                return;
            }
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            entity.isUploading=NO;

            //[self performSelectorOnMainThread:@selector(closeAlert) withObject:nil waitUntilDone:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                {
                                     EYL_AppData *eyl_AppDaya=[EYL_AppData sharedEYL_AppData];
            //[appDelegate.window makeToast:@"Registry saved Successfully" duration:1.0 position:CSToastPositionCenter];
                
                //[containerView clearText];
                // Here Delete the Records from local Database because they are already updated to the server
                
               // [self deleteRecordFromLocalDB];
                
                if ([entity.dateStr isEqualToString:[eyl_AppDaya getDateFromNSDate:[NSDate date]]])
                {
                    RegistryDataModal *obk = [eyl_AppDaya.array_Registry lastObject];
                    NSDictionary *dic= [[dict objectForKey:@"registry"] lastObject];
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:[entity.childId intValue]],@"childid",
                                                  entity.dateStr,@"date",
                                                  [dic objectForKey:@"came_in_at"],@"intime",
                                                  [dic objectForKey:@"left_at"],@"outtime",
                                                  @"1", @"uploadedflag",
                                                  entity.uid,@"uniqueTableID",nil];
                    
                    
                    [Child updateChild:[NSNumber numberWithInt:[entity.childId intValue]] inTime: [dic objectForKey:@"came_in_at"] andOutTime:[dic objectForKey:@"left_at"] andRegistryStatus:nil  forContext:[AppDelegate context]];
                    
                    [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:[NSNumber numberWithInt:[entity.childId intValue]] withDate:entity.dateStr];
                    obk=nil;
                }
                }
                else
                {
                    if([[jsonDict objectForKey:@"status"]isEqualToString:@"failure"]&&[[jsonDict objectForKey:@"message"]isEqualToString:@"Diary already in submitted mode."])
                    {
                        [RegistryDataEntity deleteRecordWithUniqueID:[NSNumber numberWithDouble:[[jsonDict objectForKey:@"tabletuid"] doubleValue]] andDateStr:entity.dateStr];
                        
                    }
                    NSLog(@"Registry not updated");
                
                }
            });
                
            
        }];
        [postDataTask resume];
        
    }
    }

}
-(void)insertOutTimeRecord
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@api/registry/insertleft_out_at",serverURL];
    
    NSArray *array= [InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withIsOutUploaded:NO andOutTime:@"00:00"];
    
    NSLog(@"arrayCount for Out = %d",array.count);
    
    for(int i = 0;i<array.count;i++)
    {
        InOutSeparateManagementEntity *inOutEntity=[array objectAtIndex:i];
        if([[APICallManager sharedNetworkSingleton]isNetworkReachable])
        {
            if(!inOutEntity.isOutUploading)
            {
             
                
                NSString *timestamp=inOutEntity.timeStamp;
                if(timestamp.length>0)
                {
                    NSMutableDictionary *inputDictionary;
                    if(inOutEntity.practitionerId==nil&&inOutEntity.practitionerPin==nil)
                    {
                        inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           _apiKey,@"api_key",
                                           _apiPassword,@"api_password",
                                           [APICallManager sharedNetworkSingleton].cachePractitioners.pin,@"practitioner_pin",
                                           [NSString stringWithFormat:@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.eylogUserId],@"practitioner_id",
                                           inOutEntity.childId,@"child_id",
                                           inOutEntity.dateStr,@"date",
                                           inOutEntity.outTime,@"left_at",
                                           timestamp,@"clienttimestamp"
                                           ,[NSString stringWithFormat:@"%@",inOutEntity.uid],@"tabletuid",nil];
                        
                    }
                    else
                    {
                        inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           _apiKey,@"api_key",
                                           _apiPassword,@"api_password",
                                           inOutEntity.practitionerPin,@"practitioner_pin",
                                           [NSString stringWithFormat:@"%@",inOutEntity.practitionerId],@"practitioner_id",
                                           inOutEntity.childId,@"child_id",
                                           inOutEntity.dateStr,@"date",
                                           inOutEntity.outTime,@"left_at",
                                           timestamp,@"clienttimestamp"
                                           ,[NSString stringWithFormat:@"%@",inOutEntity.uid],@"tabletuid",nil];
                        
                    }
                    
                    //[NSString stringWithFormat:@"%@",inOutEntity.uid ],@"uniquediaryid"
                    //[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",inOutEntity.uid ] forKey:@"uid"];
                       inOutEntity.isOutUploading=YES;
                    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                        if(error)
                        {
                            NSLog(@"Fail while updating Registry Data from the server");
                              inOutEntity.isOutUploading=NO;
                            return;
                        }
                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        NSLog(@"Response from API In Out : %@", jsonDict);
                        inOutEntity.isOutUploading=NO;
                        if ([[jsonDict valueForKey:@"status"] isEqualToString:@"failure"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              
                                
                                GridViewController *gridController;
                                AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                UIViewController *vc = [(eyLogNavigationViewController *)del.window.rootViewController visibleViewController];
                                if([vc isKindOfClass:[ChilderenViewController class]])
                                {
                                    ChilderenViewController *cont=(ChilderenViewController *)vc;
                                    ContainerViewController *container=cont.containerViewController;
                                    gridController=  ((GridViewController *)[container.childViewControllers objectAtIndex:0]);
                                }
                                
                                if([gridController isKindOfClass:[GridViewController class]])
                                {
                                    NSMutableArray *gridArray=[NSMutableArray arrayWithArray:gridController.childrenListForTableView];
                                    for(Child *child in gridArray)
                                    {
                                        if([inOutEntity.childId integerValue]==[child.childId integerValue])
                                        {
                                            //
                                            child.currentDate = string;
                                            child.registryStatus=[NSNumber numberWithInteger:5];
                                            gridController.childrenListForTableView=[NSArray arrayWithArray:gridArray];
                                            NSIndexPath *indepath=[NSIndexPath indexPathForItem:[gridArray indexOfObject:child] inSection:0];
                                            NSArray *indexpathArray=[NSArray arrayWithObject:indepath];
                                            [gridController.collectionViewController reloadItemsAtIndexPaths:indexpathArray];
                                        }
                                        
                                    }
                                    
                                }
                                [Child updateChild:inOutEntity.childId inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:[NSNumber numberWithInteger:-1]  forContext:[AppDelegate context]];
                                
                                
                                NSString *str=[jsonDict valueForKey:@"message"];
                                if(str.length>0)
                                {
                                    
                                  //  [gridController.view makeToast:str duration:2.0f position:CSToastPositionBottom];
                                    //[del.window makeToast:[jsonDict valueForKey:@"message"] duration:2.0f position:CSToastPositionBottom];
                                }
                            });
                            [InOutSeparateManagementEntity deleteRecordWithUniqueID:[NSNumber numberWithDouble:[[jsonDict objectForKey:@"tabletuid"] doubleValue]]];
                            
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                                {
                                    inOutEntity.isOutUploading=NO;
                                    
                                    
                                    [InOutSeparateManagementEntity deleteRecordWithUniqueID:[NSNumber numberWithDouble:[[jsonDict objectForKey:@"tabletuid"] doubleValue]]];
                                    
                                    
                                    NSLog(@"Record deleted Successfully");
                                }
                                
                                
                                NSLog(@"Response From Server :%@",jsonDict);
                                
                                
                                
                                
                            });
                            
                        }
                    }];
                    
                    [postDataTask resume];
                    
                    
                }
            }
        }
    }
//  NSArray *array1= [InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withIsOutUploaded:NO andOutTime:@"00:00"];
//    if(array1.count>0)
//    {
//        [self insertOutTimeRecord];
//        
//    }

}
-(void)insertInTimeRecord
{
    //[InOutSeparateManagementEntity deleteInContext:[AppDelegate context]];
    
    
  NSString *urlString=[NSString stringWithFormat:@"%@api/registry/insertcame_in_at",serverURL];
    
   NSArray *array= [InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:NO];
     NSLog(@"arrayCount for In = %d",array.count);
    if(array.count==0)
    {
        [self insertOutTimeRecord];
        
    }
    else
    {
    for(int i = 0;i<array.count;i++)
    {
        if([[APICallManager sharedNetworkSingleton]isNetworkReachable])
        {
        InOutSeparateManagementEntity *inOutEntity=[array objectAtIndex:i];
        if(!inOutEntity.isInUploading)
    {
       
        
        
       NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            _apiKey,@"api_key",
                                            _apiPassword,@"api_password",
                                            inOutEntity.practitionerPin,@"practitioner_pin",
                                            [NSString stringWithFormat:@"%@",inOutEntity.practitionerId],@"practitioner_id",
                                            inOutEntity.childId,@"child_id",
                                             inOutEntity.dateStr,@"date",
                                             inOutEntity.inTime,@"came_in_at",
                                             @"",@"clienttimestamp"
                                             ,[NSString stringWithFormat:@"%@",inOutEntity.uid],@"tabletuid",nil];
        
        //[NSString stringWithFormat:@"%@",inOutEntity.uid ],@"uniquediaryid"
        //[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",inOutEntity.uid ] forKey:@"uid"];
        inOutEntity.isInUploading=YES;
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                    if(error)
                    {
                        NSLog(@"Fail while updating Registry Data from the server");
                        inOutEntity.isInUploading=NO;
                        return;
                    }
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"Response from API In Out : %@", jsonDict);
             inOutEntity.isInUploading=NO;
            
            if ([[jsonDict valueForKey:@"status"] isEqualToString:@"failure"]&&[[jsonDict valueForKey:@"message"] isEqualToString:@"Diary already in submitted mode."])
                    {
                        
                                          //childInout=nil;
                        //NSLog(@"Response From Server :%@",jsonDict);
                        //NSLog(@"Error Description :%@",[error description]);
                       // NSLog(@"INput Dictionary :%@",inputDictionary);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
 
                             GridViewController *gridController;
                            AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                            UIViewController *vc = [(eyLogNavigationViewController *)del.window.rootViewController visibleViewController];
                            if([vc isKindOfClass:[ChilderenViewController class]])
                            {
                            ChilderenViewController *cont=(ChilderenViewController *)vc;
                            ContainerViewController *container=cont.containerViewController;
                            gridController=  ((GridViewController *)[container.childViewControllers objectAtIndex:0]);
                            }
            
                        if([gridController isKindOfClass:[GridViewController class]])
                        {
                            NSMutableArray *gridArray=[NSMutableArray arrayWithArray:gridController.childrenListForTableView];
                            for(Child *child in gridArray)
                            {
                                if([inOutEntity.childId integerValue]==[child.childId integerValue])
                                {
                                                  //
                                child.currentDate = string;
                                child.registryStatus=[NSNumber numberWithInteger:5];
                                gridController.childrenListForTableView=[NSArray arrayWithArray:gridArray];
                                NSIndexPath *indepath=[NSIndexPath indexPathForItem:[gridArray indexOfObject:child] inSection:0];
                                NSArray *indexpathArray=[NSArray arrayWithObject:indepath];
                                [gridController.collectionViewController reloadItemsAtIndexPaths:indexpathArray];
                                }
                                
                            }
            
                        }
                            [Child updateChild:inOutEntity.childId inTime:@"00:00" andOutTime:@"00:00" andRegistryStatus:[NSNumber numberWithInteger:-1]  forContext:[AppDelegate context]];
     
                        NSString *str=[jsonDict valueForKey:@"message"];
                        if(str.length>0)
                        {
            
                            [gridController.view makeToast:str duration:2.0f position:CSToastPositionBottom];
                            //[del.window makeToast:[jsonDict valueForKey:@"message"] duration:2.0f position:CSToastPositionBottom];
                        }
                        });
                        [InOutSeparateManagementEntity deleteRecordWithUniqueID:[NSNumber numberWithDouble:[[jsonDict objectForKey:@"tabletuid"] doubleValue]]];
  //[self performSelector:@selector(fetchAllInOutTime) withObject:nil afterDelay:2.0];
            
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
            
                            // [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:num withDate:string];
//                                if ([Theme isDateGreaterThanDate:[Utils getDateFromStringInYYYYmmDD:[Utils getDateStringFromDateInYYYYMMDD:[NSDate date]]] and:[Utils getDateFromStringInYYYYmmDD:inOutEntity.dateStr]])
//                                {
                             inOutEntity.isInUploading=NO;
                            if([[jsonDict objectForKey:@"status"]isEqualToString:@"success"])
                            {
                                [InOutSeparateManagementEntity updateInContext:[AppDelegate context] withisInUploaded:YES forChild:inOutEntity.childId withDate:inOutEntity.dateStr andClientTimestamp:[jsonDict objectForKey:@"result"] andUid:[NSNumber numberWithDouble:[[jsonDict objectForKey:@"tabletuid"] doubleValue]]];
                                
                                   // [InOutSeparateManagementEntity deleteRecordWithUniqueID:inOutEntity.uid];
                                    NSLog(@"Record updated Successfully");
                                
                               

                            }
                            if(i==array.count-1)
                            {
                                NSArray *arrayOut= [InOutSeparateManagementEntity fetchObservationInContext:[AppDelegate context] withisInUploaded:YES withIsOutUploaded:NO andOutTime:@"00:00"];
                                if(arrayOut.count>0)
                                {
                                    [self insertOutTimeRecord];
                                    
                                }
                            }
                               // }
                                NSLog(@"Response From Server :%@",jsonDict);
                            
                           // _childInOutEntity=nil;
                            // [self fetchAllInOutTime];
                         

                        });
                        
                        
                    }
                }];
            
                [postDataTask resume];
        
    }
    }
    }
    }

   }
//-(void)uploadRandomInOutTimeRecord : (NSArray *) registryArray andChildInOut:(ChildInOutTime *)childInout andViewController:(UIViewController *)controller
//{
//
//    // serverURL=@"https://demo.eylog.co.uk/trunk/";
//
//    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:registryArray];
//
//    NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary",serverURL];
//
//    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                            _apiKey,@"api_key",
//                                            _apiPassword,@"api_password",
//                                            _cachePractitioners.pin,@"practitioner_pin",
//                                            [NSString stringWithFormat:@"%@",_cachePractitioners.eylogUserId],@"practitioner_id",
//                                            [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                             childInout.childID,@"child_id",
//                                             childInout.currentDate,@"date_time",
//                                             @"draft",@"mode",
//                                             childInout.inTime,@"came_in_at",
//                                             childInout.outTime,@"left_at",
//                                             newArray,@"registry",
//                                             [NSString stringWithFormat:@"%@",childInout.uniqueTabletOID ],@"uniquediaryid",
//                                             nil],@"data",nil];
//    
//    NSLog(@"Request Dictionary :  %@", inputDictionary );
//    
//    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//        if(error)
//        {
//            NSLog(@"Fail while updating Registry Data from the server");
//            NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
//            if(remoteHostStatus == NotReachable) {
//                 [self uploadRandomInOutTimeRecord:registryArray andChildInOut:childInout andViewController:controller];
//             
//
//            }//
//            else{
//                NSLog(@"Reachable Again Calling Random InOutEntity Upload");
//                _childInOutEntity=nil;
//                [self uploadRandomInOutTimeRecord:registryArray andChildInOut:childInout andViewController:controller];
//            }
//            return;
//        }
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"Response from API In Out : %@", jsonDict);
//     
//        if ([[jsonDict valueForKey:@"status"] isEqualToString:@"failure"])
//        {
//            //childInout=nil;
//            //NSLog(@"Response From Server :%@",jsonDict);
//            //NSLog(@"Error Description :%@",[error description]);
//           // NSLog(@"INput Dictionary :%@",inputDictionary);
//            GridViewController *gridController;
//            if(controller==nil)
//            {
//                 AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//                UIViewController *vc = [(eyLogNavigationViewController *)del.window.rootViewController visibleViewController];
//                ChilderenViewController *cont=(ChilderenViewController *)vc;
//                ContainerViewController *container=cont.containerViewController;
//                gridController=  ((GridViewController *)[container.childViewControllers objectAtIndex:0]);
//                
//            }
//            else
//            {
//             gridController=(GridViewController *)controller;
//            }
//            if([gridController isKindOfClass:[GridViewController class]])
//            {
//                [gridController getRegistryINOUT];
//            
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSString *str=[jsonDict valueForKey:@"message"];
//            if(str.length>0)
//            {
//                
//                [gridController.view makeToast:str duration:2.0f position:CSToastPositionBottom];
//                //[del.window makeToast:[jsonDict valueForKey:@"message"] duration:2.0f position:CSToastPositionBottom];
//            }
//            });
//            //[self performSelector:@selector(fetchAllInOutTime) withObject:nil afterDelay:2.0];
//           
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//              
//                // [ChildInOutTime updateOrCreateChildInOutTimeContext:[AppDelegate context] withDictionary:dict forChild:num withDate:string];
//                BOOL updated=[ChildInOutTime updateRecord:[AppDelegate context] withChildID:childInout.childID withDate:childInout.currentDate withInTimeValue:childInout.inTime withOutTimeValue:childInout.outTime withUploadFlag:[NSNumber numberWithInt:1]];
//                
//                if (updated)
//                {
//                    
//                    if ([Theme isDateGreaterThanDate:[Utils getDateFromStringInYYYYmmDD:[Utils getDateStringFromDateInYYYYMMDD:[NSDate date]]] and:[Utils getDateFromStringInYYYYmmDD:childInout.currentDate]])
//                    {
//                        [ChildInOutTime deleteRecordWithUniqueID:childInout.uniqueTabletOID];
//                        NSLog(@"Record Deleted Successfully");
//                    }
//                    NSLog(@"Response From Server :%@",jsonDict);
//                }
//               // _childInOutEntity=nil;
//                // [self fetchAllInOutTime];
//                
//                
//                
//                
//            });
//            
//        }
//    }];
//    [postDataTask resume];
//    //[del.window hideToastFromView];
//}

-(void)uploadRandomInOutTimeRecord : (NSArray *) registryArray
{
    // serverURL=@"https://demo.eylog.co.uk/trunk/";
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:registryArray];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_childInOutEntity.inTime,@"came_in_at",
                                                                    _childInOutEntity.outTime,@"left_at",
                                                                    @"0",@"registry_status",nil];
    [newArray addObject:dict];
    dict=nil;

    NSString *urlString=[NSString stringWithFormat:@"%@api/daily_diary",serverURL];

    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             _apiKey,@"api_key",
                                             _apiPassword,@"api_password",
                                             _cachePractitioners.pin,@"practitioner_pin",
                                             [NSString stringWithFormat:@"%@",_cachePractitioners.eylogUserId],@"practitioner_id",
                                             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              _childInOutEntity.childID,@"child_id",
                                             _childInOutEntity.currentDate,@"date_time",
                                              @"draft",@"mode",
                                              _childInOutEntity.inTime,@"came_in_at",
                                              _childInOutEntity.outTime,@"left_at",
                                              newArray,@"registry",
                                               [NSString stringWithFormat:@"%@",_childInOutEntity.uniqueTabletOID ],@"uniquediaryid",
                                              nil],@"data",nil];
    
    NSLog(@"Request Dictionary :  %@", inputDictionary );

    NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            NSLog(@"Fail while updating Registry Data from the server");
            NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
            if(remoteHostStatus == NotReachable) {
            }
            else{
                NSLog(@"Reachable Again Calling Random InOutEntity Upload");
                _childInOutEntity=nil;
                //[self fetchAllInOutTime];
            }
            return;
        }

      NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"Response from API 2 : %@", jsonDict);
        
        
        if ([[jsonDict valueForKey:@"status"] isEqualToString:@"failure"])
        {
            _childInOutEntity=nil;
            NSLog(@"Response From Server :%@",jsonDict);
            NSLog(@"Error Description :%@",[error description]);
            NSLog(@"INput Dictionary :%@",inputDictionary);
            // [self performSelector:@selector(fetchAllInOutTime) withObject:nil afterDelay:2.0];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL updated=[ChildInOutTime updateRecord:[AppDelegate context] withChildID:_childInOutEntity.childID withDate:_childInOutEntity.currentDate withInTimeValue:_childInOutEntity.inTime withOutTimeValue:_childInOutEntity.outTime withUploadFlag:[NSNumber numberWithInt:1]];

                if (updated)
                {
                    
                    if ([Theme isDateGreaterThanDate:[Utils getDateFromStringInYYYYmmDD:[Utils getDateStringFromDateInYYYYMMDD:[NSDate date]]] and:[Utils getDateFromStringInYYYYmmDD:_childInOutEntity.currentDate]])
                    {
                        [ChildInOutTime deleteRecordWithUniqueID:_childInOutEntity.uniqueTabletOID];
                        NSLog(@"Record Deleted Successfully");
                    }
                     NSLog(@"Response From Server :%@",jsonDict);
                }
                _childInOutEntity=nil;
               // [self fetchAllInOutTime];

                

                
            });
            
        }
    }];
    [postDataTask resume];
}
-(void)uploadRegistryToServer:(NSArray *)array andDictionary:(NSDictionary *)dict

{

}
-(void)registerForPushNotifications{
    NSString *urlString=[NSString stringWithFormat:@"%@api/registerdevice",serverURL];
    NSString *deviceToken;

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]) {
        deviceToken=[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
        
       // NSString *device_ID=[[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
       
        
        
        NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: _apiKey,@"api_key",
                                                _apiPassword,@"api_password",
                                                @"iOS",@"device_type",
                                                deviceToken,@"device_id",
                                                deviceToken,@"device_token",
                                                nil];
        
        NSURLSessionDataTask *postDataTask = [[[APICallManager sharedNetworkSingleton] getSession] dataTaskWithRequest:[self getMutableRequestWithParamDictionary:inputDictionary withURL:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error)
            {
                NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
                if(remoteHostStatus == NotReachable) {
                }
                else{
                    NSLog(@"Error : %@",[error description]);
                }
                return;
            }
            
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Response From Server :%@",jsonDict);
            
        }];
        [postDataTask resume];

    }
    
}


@end
