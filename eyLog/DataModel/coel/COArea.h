//
//  COArea.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface COArea : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double areaIdentifier;
@property (nonatomic, strong) NSArray *aspect;
@property (nonatomic, strong) NSString *areaDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
