//
//  LSBaseClass.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LSBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *scale;
@property (nonatomic, strong) NSString *signals;
@property (nonatomic, strong) NSString *leuvenScaleType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
