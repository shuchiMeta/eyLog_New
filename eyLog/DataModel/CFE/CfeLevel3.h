//
//  CfeLevel3.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CfeLevel3 : NSObject <NSCoding ,NSCopying>

@property (nonatomic,assign) double thirdLevelIdentifier;
@property(nonatomic,strong) NSString *thirdLevelDescription;
@property (nonatomic,strong)NSString *thirdLevelGroup;
@property(nonatomic,strong) NSArray *thirdLevelItem;


+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;


@end
