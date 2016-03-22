//
//  EYL_AppData.m
//  eyLog
//
//  Created by Arpan Dixit on 24/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYL_AppData.h"

@implementation EYL_AppData


+(instancetype) sharedEYL_AppData
{
    static EYL_AppData *sharedEYL_AppData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEYL_AppData = [[self alloc] init];
    });
    return sharedEYL_AppData;
}


- (id)init {
    if (self = [super init])
    {
        self.array_Toileting = [[NSMutableArray alloc] init];
        self.array_Registry = [[NSMutableArray alloc] init];
        self.array_SleepTimes = [[NSMutableArray alloc] init];
        self.array_nappiesRash = [[NSMutableArray alloc] init];
        self.array_IHadMyBottle = [[NSMutableArray alloc] init];
        self.array_WhatIateToday = [[NSMutableArray alloc] init];
        self.array_Notes = [[NSMutableArray alloc] init];
        self.array_Comments = [[NSMutableArray alloc] init];
        self.array_Observations=[NSMutableArray new];
        self.array_registryStatus=[NSMutableArray new];
        self.array_registryDeleted=[NSMutableArray new];
        
        
        self.child_CameIN = [[NSString alloc] init];
        self.child_LeftAT = [[NSString alloc] init];
        

        self.array_WhatIateTodayStatic = [[NSMutableArray alloc] init];
        self.array_SegmentControlTitle = [[NSMutableArray alloc] init];
        
        self.childInfoDict = [[NSMutableDictionary alloc] init];
        
        
        self.savePickerDate = [[NSString alloc] init];
    }
    return self;
}

- (NSString *) getMinuteAndHoursFromNSDate :(NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}
- (NSString *) getMinuteAndHoursFromNSDateofSameLocale :(NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}

- (NSString *) getDateFromNSDate : (NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
- (void) showAlertWithTwoButton : (NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eylog" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) showAlertWithOneButton : (NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eylog" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (NSDate *) getNSDateFromHourMin :(NSString *) inputString andDate : (NSDate *) inputDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate=  [formatter stringFromDate:inputDate];
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *theDate2=  [formatter1 dateFromString:[[theDate stringByAppendingString:@" "] stringByAppendingString:[inputString stringByAppendingString:@":00"]]];

    
   return theDate2;
}

- (NSDate *) getTimeFormatFromNSDate : (NSDate *) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timeStamp = [formatter stringFromDate:date];
    
    formatter = nil;
    

    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm:ss"];

    return [formatter1 dateFromString:timeStamp];
}

- (NSDate *) getTimeFormatFromNSString : (NSString *) inputString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter dateFromString:[inputString stringByAppendingString:@":00"]];
}


#pragma mark -
#pragma mark - Save Data in Document Directory

- (void) saveObject : (NSString *) value forKey :(NSString *) key
{
    [[NSUserDefaults standardUserDefaults]
     setObject:value forKey:key];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getObjectForKey :(NSString *) key
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key])
    {
        return [[NSUserDefaults standardUserDefaults]
                      objectForKey:key];

    }
    else
    {
        return nil;
    }
}


-(MBProgressHUD *) showProgressWithMessage :(NSString *) titleMessage
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = titleMessage;
    return hud;
}


- (void)dismissGlobalHUD
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
@end
