//
//  NSString+SHAHashing.m
//  eyLog
//
//  Created by Qss on 11/14/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NSString+SHAHashing.h"
#include <CommonCrypto/CommonDigest.h>
@implementation NSString (SHAHashing)

- (NSString*) sha256
{
    NSData *bytes = [self dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    const char * text = [bytes bytes];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(text, [bytes length], digest);
    NSData *pwdData=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return [pwdData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

}
@end
