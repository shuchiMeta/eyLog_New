//
//  EcatAspectClass.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EcatAspectClass : NSObject<NSCoding,NSCopying>

@property (nonatomic,assign) double secondLevelIdentifier;
@property(nonatomic,strong) NSString *secondLevelDescription;
@property(nonatomic,strong) NSArray *secondLevelItem;


+(instancetype) modelObjectWithDictionary :(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;
@end
