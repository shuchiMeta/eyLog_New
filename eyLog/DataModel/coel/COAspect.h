//
//  COAspect.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface COAspect : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double aspectIdentifier;
@property (nonatomic, strong) NSArray *statement;
@property (nonatomic, strong) NSString *aspectDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
