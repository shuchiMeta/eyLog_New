//
//  EcatAreaClass.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EcatAreaClass : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign) double levelIdentifier;
@property(nonatomic,strong) NSArray *levelItem;
@property(nonatomic,strong) NSString * levelDescription;


+(instancetype)modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype) initWithDictionary :(NSDictionary *)dict;
-(NSDictionary  *)dictionaryRepresentation;
@end
