//
//  INEcat.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface INEcat : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ecatLevelOne;
@property (nonatomic, strong) id ecatLevelTwo;
@property (nonatomic, strong) NSString *ecatLevelThree;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
