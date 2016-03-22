//
//  CfeLevel.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CfeLevel : NSObject <NSCoding,NSCopying>

@property(nonatomic,assign) double levelIdentifier;
@property(nonatomic,strong) NSArray *levelItem;
@property(nonatomic,strong) NSString * levelDescription;
@property(nonatomic,strong) NSString *levelGroup;


+(instancetype)modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype) initWithDictionary :(NSDictionary *)dict;
-(NSDictionary  *)dictionaryRepresentation;


@end
