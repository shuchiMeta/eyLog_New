//
//  COStatement.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface COStatement : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double statementIdentifier;
@property (nonatomic, strong) NSString *statementDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
