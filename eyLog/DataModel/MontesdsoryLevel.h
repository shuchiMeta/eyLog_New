//
//  MontesdsoryLevel.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//
//Level1//
#import <Foundation/Foundation.h>

@interface MontesdsoryLevel : NSObject <NSCoding,NSCopying>

@property(nonatomic,assign) double levelIdentifier;
@property(nonatomic,strong) NSArray *levelItem;
@property(nonatomic,strong) NSString * levelDescription;
@property(nonatomic,strong) NSString *levelGroup;


+(instancetype)modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype) initWithDictionary :(NSDictionary *)dict;
-(NSDictionary  *)dictionaryRepresentation;


@end
