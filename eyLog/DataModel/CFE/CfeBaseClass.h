//
//  CfeBaseClass.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CfeBaseClass : NSObject<NSObject,NSCoding>

@property(nonatomic,strong) NSArray *level1;
@property(nonatomic,strong) NSArray *assessment;

+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end
