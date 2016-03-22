//
//  MontessoryLevel2.h
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MontessoryLevel2 : NSObject <NSCoding,NSCopying>

@property (nonatomic,assign) double secondLevelIdentifier;
@property(nonatomic,strong) NSString *secondLevelDescription;
@property (nonatomic,strong)NSString *secondLevelGroup;
@property(nonatomic,strong) NSArray *secondLevelItem;


+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end
