//
//  MontessoryBaseClass.h
//  eyLog
//
//  Created by Shobhit on 23/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MontessoryBaseClass : NSObject<NSObject,NSCoding>

@property(nonatomic,strong) NSArray *level1;
@property(nonatomic,strong) NSArray *assessment;

+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end
