//
//  Utils.h
//  eyLog
//
//  Created by Qss on 9/9/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)checkNetwork;
+(NSString *)getPractionerImages;
+(NSString *)getDocumentDirectory;
+(NSString *)getChildrenImages;
+(NSString *)getDraftMediaImages;
+(NSString *)getSettingPath;
+(NSString *)getLabelPath;
+(NSString *)getNurseryDetailPath;
+(NSString *)getInstallationData;

//+(NSData *)AES128EncryptWithKey:(NSString *)key withData:(NSData *)dTextIn;
//+(NSData *)AES128DecryptWithKey:(NSString *)key withData:(NSData *)dTextIn;
+(NSDate *)getDateFromStringInHHMMSS:(NSString *)string;
+(NSDate *)getDateFromStringInHHMM:(NSString *)string;
+(NSString *)getPractionerName;
+(NSString *)getChildName;
+(UIImage *)getChildImage;
+(UIImage *)getChildImageSubmative;
+(UIImage *)getPractionerImgae;
+(NSString *)getAudioGallery;
+(NSString *)getRecordedAudio;
+(NSString *)getClickedImages;
+(NSString *)getClickedVideos;
+(NSString *)getTempDirectory;
+(NSString *)getDraftMediawithObservationID:(NSString *)observationId;

+(NSString *)getChildGroupName;
+(NSString *)getPractitionerGroupName;

+(UIColor *) colorFromHexString:(NSString *) hexString;
+(UIImage *)generateThumbImage : (NSURL *)url;
+(NSDate *)getDateFromString:(NSString *)string;
+(NSDate *)getDateFromStringInYYYYmmDD:(NSString *)string;
+(NSString *)getDateStringFromDateInYYYYMMDD:(NSDate *)date;
+(NSString *)dateWithTimeInterval:(NSTimeInterval)timeInterval;
+(NSString *)getDateStringFromDate:(NSDate *)date;
+(NSString *)getValidDateString:(NSString *)dateString;
+(NSString *)monthsFromDOB:(NSDate *)dob;
+(NSString *)getMonthsString:(NSString *)dob;
+(NSString *) randomStringWithLength: (int) len;

@end
