//
//  INBaseClass.h
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INChildren, INLabel, INDiaryFields, INPractitioners;

@interface INBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) INChildren *children;
@property (nonatomic, strong) NSString *nurseryName;
@property (nonatomic, strong) NSString *nurseryChainName;
@property (nonatomic, strong) NSString *nurseryChainId;
@property (nonatomic, strong) INLabel *label;
@property (nonatomic, strong) INDiaryFields *diaryFields;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) INPractitioners *practitioners;
@property (nonatomic, strong) NSString *nurseryId;

//kINBaseClassFramework
@property (nonatomic, strong) NSMutableDictionary *dict_DiaryFields;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
