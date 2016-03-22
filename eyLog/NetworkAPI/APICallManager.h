//
//  AFNetworkSingleton.h
//  TradeStone
//
//  Created by Qss on 7/25/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModels.h"
#import "MBProgressHUD.h"
#import "SSZipArchive.h"
#import "Child.h"
#import "Practitioners.h"
#import "Setting.h"
#import "NewObservation.h"
#import "Reachability.h"
#import "ChildInOutTime.h"
@import AVFoundation;
#import "InOutSeparateManagementEntity.h"
#import "Theme.h"
#import "RegistryDataEntity.h"
#import "RegistryDataModal.h"



@interface APICallManager : NSObject <SSZipArchiveDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>
{
    NSString *serverURL;
    NSString *nurseryId;
    NSString *frameworkType;
    Reachability *reachability;
    NSMutableArray *tabIdarray;
}

//Singleton uses only..
@property(nonatomic,strong) NSString *frameworkType;
@property(nonatomic,strong) NSString *nurseryId;
@property(nonatomic,strong) NSString *serverURL;
@property(nonatomic,strong) NSString *apiKey;
@property(nonatomic,strong) NSString *apiPassword;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) NSArray *childArray;
@property(nonatomic,strong) NSMutableArray *cacheChildren;
@property(nonatomic,strong) Child *cacheChild;
@property(nonatomic,strong) Child *mainSelectedChild;
@property(nonatomic,assign) BOOL isFromDraftList;
@property(nonatomic,strong) Practitioners *cachePractitioners;
@property(nonatomic,strong) Setting *settingObject;
@property(nonatomic,strong) INBaseClass *baseClass;
//@property(atomic,assign) BOOL isUploading;
@property(atomic,assign) BOOL editingUploadQueue;
@property (nonatomic) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSString *tmpUploadURL;
@property (strong, nonatomic) NSMutableDictionary *responsesData;
@property (strong, nonatomic) NewObservation * newwObservationEntity;
@property (strong, nonatomic) ChildInOutTime *childInOutEntity;
@property (assign, nonatomic) NSInteger numberOfMediaFilesSelected;
@property(strong,nonatomic)UIViewController *viewController;


//@property(nonatomic,strong) NSArray *selectedCOELArray;

- (void)saveDate:(NSDate *)date withID:(NSString *)udid;
- (NSDate *)getDateWithUDID:(NSString *)udid;
-(BOOL)isNetworkReachable;
+(APICallManager *)sharedNetworkSingleton;
+(void)setManagerNil;
-(INBaseClass *)getInstallation;
//-(void)getServerUrl;
-(void)getServerUrlWithKey:(NSString *)apiKey andPassword:(NSString *)apiPassword fromController:(UIViewController *)controller;
//-(NSString *)apiKey;
-(NSURLSession *)getSession;
//-(NSString *)apiPassword;
-(NSMutableURLRequest *)getMutableRequestWithParamDictionary:(NSDictionary *)paramDictionary withURL:(NSString *)urlStirng;
-(NSMutableURLRequest *)getMutableDeleteRequestWithParamDictionary:(NSDictionary *)paramDictionary withURL:(NSString *)urlStirng;
-(void)getTeacherImage;
-(void)getAllChildrenImages;
-(void)getSummativeReportsListWithSuccessBlock:(void (^)(NSDictionary *dict))success andFailureBlock:(void (^)(NSError * error))failure;

-(UIImage*) resizeImage:(UIImage *)inImage toRect:(CGRect)thumbRect;
-(void)uploadObservations;
//-(void)getDraftMedia:(NSNumber *)observationId;

-(void)checkReachibilityStatus;
-(void)fetchAllInOutTime;
-(void)uploadRandomInOutTimeRecord : (NSArray *) registryArray;
- (void) getRegistryINOUTTime;
-(void)uploadRandomInOutTimeRecord : (NSArray *) registryArray andChildInOut:(ChildInOutTime *)childInout andViewController:(UIViewController *)controller;
-(void)registerForPushNotifications;
-(void)insertInTimeRecord;
-(void)insertOutTimeRecord;
-(void)insertRegistryData;

@end
