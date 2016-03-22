//
//  EcatBaseClass.h
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EcatBaseClass : NSObject<NSObject,NSCoding>

@property(nonatomic,strong) NSArray *AreaArray;
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionaryRepresentation;
@end
