//
//  NSDate+EYL_Date.m
//  eyLog
//
//  Created by Arpan Dixit on 29/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NSDate+EYL_Date.h"

@implementation NSDate (EYL_Date)


+(NSString *) getTimeDifferenceFromStartTime :(NSDate *) startTime andEndTime : (NSDate *) endTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:startTime];
    NSDate *dateStart = [dateFormatter dateFromString:dateString];
    
    NSString *dateStringEnd = [dateFormatter stringFromDate:endTime];
    NSDate *dateEnd = [dateFormatter dateFromString:dateStringEnd];
    
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [c components:NSHourCalendarUnit fromDate:dateStart toDate:dateEnd options:0];
    NSDateComponents *components1 = [c components:NSMinuteCalendarUnit fromDate:dateStart toDate:dateEnd options:0];
    NSInteger remainingMinute = components1.minute - components.hour *60;
//    NSLog(@"Hour : Min  %.2d : %.2d", components.hour , remainingMinute);
    return [NSString stringWithFormat:@"%.2d:%.2d", components.hour,remainingMinute];
}

+(NSString *) getStringFromNSDate : (NSDate *) incomingDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"HH:mm"];

    return [formatter stringFromDate:incomingDate];
}

+(NSString *) getFormattedDateString :(NSString *) inputString
{
    if ([inputString isKindOfClass:[NSNull class]] || [inputString isEqualToString:@""])
        return @"00:00";
    else
     return [inputString substringToIndex:5];
}

@end
