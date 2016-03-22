//
//  MontesoryLevel3.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MontesoryLevel3 : NSObject <NSCoding ,NSCopying>

@property (nonatomic,assign) double thirdLevelIdentifier;
@property(nonatomic,strong) NSString *thirdLevelDescription;
@property (nonatomic,strong)NSString *thirdLevelGroup;
@property(nonatomic,strong) NSArray *thirdLevelItem;


+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;


@end
