//
//  Utils.m
//  eyLog
//
//  Created by Qss on 9/9/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Utils.h"
#import "APICallManager.h"
@import Security;
#import "CommonCrypto/CommonCryptor.h"
#import "CommonCrypto/CommonKeyDerivation.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@implementation Utils

+(BOOL)checkNetwork
{
    if ([Reachability reachabilityForInternetConnection].isReachable)
    {
        return YES;
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"No Data Network Available. Please turn Data Network On and than Try Again Later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
//    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"No Data Network Available. Please turn Data Network On and than Try Again Later";
//    hud.margin = 10.f;
//    hud.removeFromSuperViewOnHide = YES;
//    hud.delegate =nil;
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
//    {
//        hud.yOffset=280;
//    }
//    else
//    {
//        hud.yOffset=400;
//    }
//    [hud hide:YES afterDelay:3];

    return NO;
}
+(NSString *)dateWithTimeInterval:(NSTimeInterval)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString * string = [formatter stringFromDate:date];
    return string;
}
+(NSString *)getDocumentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString *)getPractionerImages
{
    return [[Utils getDocumentDirectory] stringByAppendingPathComponent:@"/Staff"];
}

+(NSString *)getChildrenImages
{
    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/Children"];
}

+(NSString *)getDraftMediaImages
{
    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/DraftMedia"];
}

+(NSString *)getInstallationData
{
    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/Installation.data"];
}

+(NSString *)getDraftMediawithObservationID:(NSString *)observationId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:[NSString stringWithFormat:@"/DraftMedia%@",observationId]] isDirectory:nil]) {
        [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:[NSString stringWithFormat:@"/DraftMedia%@",observationId]] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:[NSString stringWithFormat:@"/DraftMedia%@",observationId]];
}

+(NSString *)getAudioGallery
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/AudioGallery-assets-library"] isDirectory:nil]) {
        [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/AudioGallery-assets-library"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/AudioGallery-assets-library"];

}

+(NSString *)getRecordedAudio
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/RecordedAudio"] isDirectory:nil]) {
        [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/RecordedAudio"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/RecordedAudio"];

}

+(NSString *)getClickedImages
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedImages"] isDirectory:nil]) {
       [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedImages"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedImages"];

}

+(NSString *)getClickedVideos
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedVideos"] isDirectory:nil]) {
        [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedVideos"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/ClickedVideos"];
}

+(NSString *)getTempDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/Temp"] isDirectory:nil]) {
        [fileManager createDirectoryAtPath:[[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/Temp"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"/Temp"];
}

+(NSString *)getSettingPath
{
    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"setting.plist"];
}

+(NSString *)getLabelPath
{
    return [[Utils getDocumentDirectory]stringByAppendingPathComponent:@"label.plist"];
}

+(NSString *)getNurseryDetailPath
{
    return [[Utils getDocumentDirectory]stringByAppendingString:@"nursery.plist"];
}


+(NSString *)getPractionerName
{
    return [NSString stringWithFormat:@"%@ %@", [APICallManager sharedNetworkSingleton].cachePractitioners.firstName, [APICallManager sharedNetworkSingleton].cachePractitioners.lastName];
}

+(NSString *)getChildName
{
    return [NSString stringWithFormat:@"%@ %@", [APICallManager sharedNetworkSingleton].cacheChild.firstName ?: @"" , [APICallManager sharedNetworkSingleton].cacheChild.lastName ?: @""];
}
+(UIImage *)getChildImageSubmative
{
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],[APICallManager sharedNetworkSingleton].cacheChild.photo];
    
    if([UIImage imageWithContentsOfFile:imagePath]==nil)
    {
        return [UIImage imageNamed:@"eylog_Logo"];
        
    }
    else
    {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
}
+(UIImage *)getChildImage
{
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getChildrenImages],[APICallManager sharedNetworkSingleton].cacheChild.photo];
    
    return [UIImage imageWithContentsOfFile:imagePath];
 
}
+(UIImage *)getPractionerImgae
{
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",[Utils getPractionerImages],[APICallManager sharedNetworkSingleton].cachePractitioners.photo];
    return [UIImage imageWithContentsOfFile:imagePath];
}

+(NSString *)getChildGroupName
{
    return [APICallManager sharedNetworkSingleton].cacheChild.groupName;
}
+(NSString *)getPractitionerGroupName
{
    NSLog(@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.groupName);
    return [APICallManager sharedNetworkSingleton].cachePractitioners.groupName;
     NSLog(@"%@",[APICallManager sharedNetworkSingleton].cachePractitioners.groupName);

}

+(UIColor *) colorFromHexString:(NSString *) hexString {
    float red, green, blue, alpha;
    ScanHexColor(hexString, &red, &green, &blue, &alpha);

    NSLog(@"R:%f,G%f,B:%f,A:%f",red,green,blue,alpha);

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

void static ScanHexColor(NSString * hexString, float * red, float * green, float * blue, float * alpha) {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    if (red) { *red = ((baseValue >> 24) & 0xFF)/255.0f; }
    if (green) { *green = ((baseValue >> 16) & 0xFF)/255.0f; }
    if (blue) { *blue = ((baseValue >> 8) & 0xFF)/255.0f; }
    if (alpha) { *alpha = ((baseValue >> 0) & 0xFF)/255.0f; }
}

+(UIImage *)generateThumbImage : (NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    return thumbnail;
}

+(NSDate *)getDateFromString:(NSString *)string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:string];
    return date;
}
+(NSDate *)getDateFromStringInHHMMSS:(NSString *)string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * date = [formatter dateFromString:string];
    return date;
}
+(NSDate *)getDateFromStringInHHMM:(NSString *)string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate * date = [formatter dateFromString:string];
    return date;
}

+(NSDate *)getDateFromStringInYYYYmmDD:(NSString *)string
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:string];
    return date;
}

+(NSString *)getDateStringFromDate:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
+(NSString *)getDateStringFromDateInYYYYMMDD:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}


+(NSString *)getValidDateString:(NSString *)dateString{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateString];
    //If the date is nil it was already in the right format and there is not need on the front end to change this so return the orignal one
    if(!date)
        return dateString;
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString* finalDateString =[formatter stringFromDate:date];
    return finalDateString;

}



+(NSString *)monthsFromDOB:(NSDate *)dob{
    if (!dob) {
        return @"";
    }
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * currentDC = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateComponents * dobDC = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:dob];

    NSInteger yearDiff = [currentDC year] - [dobDC year];
    NSInteger monthDiff = [currentDC month] - [dobDC month];

    NSInteger numberOfMonth = 0;
    if (yearDiff == 0) {
        numberOfMonth = monthDiff;
    }
    else{
        numberOfMonth = yearDiff*12 + monthDiff;
    }
    if (numberOfMonth == 1) {
        return [NSString stringWithFormat:@"%d month",numberOfMonth];
    }
    return [NSString stringWithFormat:@"%d months",numberOfMonth];
}

+(NSString *)getMonthsString:(NSString *)dob{
    if (!dob)
        return @"";

    if([dob integerValue] > 1)
        return [NSString stringWithFormat:@"%@ months",dob];
    else
        return [NSString stringWithFormat:@"%@ month",dob];
}

+(NSString *) randomStringWithLength: (int) len {

    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

@end
