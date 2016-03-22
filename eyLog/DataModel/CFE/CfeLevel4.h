//
//  CfeLevel4.h
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CfeLevel4 : NSObject <NSCoding,NSCopying>

@property (nonatomic,assign) double fourthLevelIdentifier;
@property(nonatomic,strong) NSString *fourthLevelDescription;
@property (nonatomic,strong)NSString *fourthLevelGroup;



+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end
