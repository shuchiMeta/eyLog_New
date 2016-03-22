//
//  EcatStatementClass.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EcatStatementClass : NSObject<NSCoding,NSCopying>

@property (nonatomic,assign) double thirdLevelIdentifier;
@property(nonatomic,strong) NSString *thirdLevelDescription;

+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;

@end
