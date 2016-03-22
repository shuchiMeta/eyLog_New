//
//  CfeAssesment.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CfeAssesment : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign) double levelID;
@property(nonatomic,strong) NSString *levelDescription;
@property(nonatomic,strong) id color;


+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end