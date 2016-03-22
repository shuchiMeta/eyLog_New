//
//  NSDate+EYL_Date.h
//  eyLog
//
//  Created by Arpan Dixit on 29/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EYL_Date)

+(NSString *) getTimeDifferenceFromStartTime :(NSDate *) startTime andEndTime : (NSDate *) endTime;


+(NSString *) getStringFromNSDate : (NSDate *) incomingDate;

+(NSString *) getFormattedDateString :(NSString *) inputString;

@end
