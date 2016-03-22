//
//  EYL_AppData.h
//  eyLog
//
//  Created by Arpan Dixit on 24/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define KGREENCOLOR                   [UIColor colorWithRed:192.0/255.0 green:193.0/255.0 blue:93.0/255.0 alpha:1.0];



@interface EYL_AppData : NSObject 
@property (nonatomic, strong) NSMutableArray *array_registryDeleted;
@property (nonatomic, strong) NSMutableArray *array_registryStatus;
@property (nonatomic, strong) NSMutableArray *array_Registry;
@property (nonatomic, strong) NSMutableArray *array_WhatIateToday;
@property (nonatomic, strong) NSMutableArray *array_SleepTimes;
@property (nonatomic, strong) NSMutableArray *array_IHadMyBottle;
@property (nonatomic, strong) NSMutableArray *array_nappiesRash;
@property (nonatomic, strong) NSMutableArray *array_Toileting;
@property (nonatomic, strong) NSMutableArray *array_Observations;
@property (nonatomic, strong) NSMutableArray *array_Notes;
@property (nonatomic, strong) NSMutableArray *array_Comments;

@property (nonatomic, strong) NSMutableArray *array_WhatIateTodayStatic;

@property (nonatomic, strong) NSMutableArray *array_SegmentControlTitle;

@property (nonatomic, strong) NSNumber *selectedChild;
@property (nonatomic, strong) NSNumber *what_i_ate_today_visible;
@property (nonatomic, strong) NSNumber *nappies_visible;
@property (nonatomic, strong) NSNumber *i_had_my_bottle_visible;
@property (nonatomic, strong) NSNumber *toileting_today_visible;
@property (nonatomic, strong) NSNumber *sleep_times_visible;



@property (nonatomic, strong) NSString *child_CameIN;
@property (nonatomic, strong) NSString *child_LeftAT;

@property (nonatomic, strong) NSMutableDictionary *childInfoDict;

@property (nonatomic, strong) NSString *savePickerDate;


+(instancetype) sharedEYL_AppData;

// Get Hours and Minute in HH:mm Format
- (NSString *) getMinuteAndHoursFromNSDate :(NSDate *) date;
- (NSString *) getMinuteAndHoursFromNSDateofSameLocale :(NSDate *) date;

// Get Current Date in this format yyyy-MM-dd
- (NSString *) getDateFromNSDate : (NSDate *) date;


- (NSDate *) getNSDateFromHourMin :(NSString *) inputString andDate : (NSDate *) inputDate;

- (void) showAlertWithOneButton : (NSString *)alertMessage;
- (void) showAlertWithTwoButton : (NSString *)alertMessage;

- (NSDate *) getTimeFormatFromNSDate : (NSDate *) date;
- (NSDate *) getTimeFormatFromNSString : (NSString *) inputString;

// Save Data in DocumentDirectory

- (void) saveObject : (NSString *) value forKey :(NSString *) key;
- (NSString *) getObjectForKey :(NSString *) key;


// Show Progress HUD

-(MBProgressHUD *) showProgressWithMessage :(NSString *) titleMessage;

- (void) dismissGlobalHUD;
@end
