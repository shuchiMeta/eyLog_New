//
//  INBaseClass.m
//
//  Created by Qss  on 11/13/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "INBaseClass.h"
#import "INChildren.h"
#import "INLabel.h"
#import "INDiaryFields.h"
#import "INSettings.h"
#import "INPractitioners.h"


NSString *const kINBaseClassChildren = @"children";
NSString *const kINBaseClassNurseryName = @"nursery_name";
NSString *const kINBaseClassNurseryChainName = @"nursery_chain_name";
NSString *const kINBaseClassNurseryChainId = @"nursery_chain_id";
NSString *const kINBaseClassLabel = @"label";
NSString *const kINBaseClassDiaryFields = @"diary_fields";
NSString *const kINBaseClassSettings = @"settings";
NSString *const kINBaseClassPractitioners = @"practitioners";
NSString *const kINBaseClassNurseryId = @"nursery_id";
NSString *const kINBaseClassFramework = @"framework_type";


@interface INBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation INBaseClass

@synthesize children = _children;
@synthesize nurseryName = _nurseryName;
@synthesize nurseryChainName = _nurseryChainName;
@synthesize nurseryChainId = _nurseryChainId;
@synthesize label = _label;
@synthesize diaryFields = _diaryFields;
@synthesize settings = _settings;
@synthesize practitioners = _practitioners;
@synthesize nurseryId = _nurseryId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.children = [INChildren modelObjectWithDictionary:[dict objectForKey:kINBaseClassChildren]];
            self.nurseryName = [self objectOrNilForKey:kINBaseClassNurseryName fromDictionary:dict];
            self.nurseryChainName = [self objectOrNilForKey:kINBaseClassNurseryChainName fromDictionary:dict];
            self.nurseryChainId = [self objectOrNilForKey:kINBaseClassNurseryChainId fromDictionary:dict];
            self.label = [INLabel modelObjectWithDictionary:[dict objectForKey:kINBaseClassLabel]];
        
          //  self.diaryFields = [INDiaryFields modelObjectWithDictionary:[dict objectForKey:kINBaseClassDiaryFields]];
        
        self.dict_DiaryFields = [dict objectForKey:kINBaseClassDiaryFields];
        
    NSObject *receivedINSettings = [dict objectForKey:kINBaseClassSettings];
    NSMutableArray *parsedINSettings = [NSMutableArray array];
    if ([receivedINSettings isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedINSettings) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedINSettings addObject:[INSettings modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedINSettings isKindOfClass:[NSDictionary class]]) {
       [parsedINSettings addObject:[INSettings modelObjectWithDictionary:(NSDictionary *)receivedINSettings]];
    }

           self.settings = [NSArray arrayWithArray:parsedINSettings];
            self.practitioners = [INPractitioners modelObjectWithDictionary:[dict objectForKey:kINBaseClassPractitioners]];
            self.nurseryId = [self objectOrNilForKey:kINBaseClassNurseryId fromDictionary:dict];
        //kINBaseClassFramework
              }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.children dictionaryRepresentation] forKey:kINBaseClassChildren];
    [mutableDict setValue:self.nurseryName forKey:kINBaseClassNurseryName];
    [mutableDict setValue:self.nurseryChainName forKey:kINBaseClassNurseryChainName];
    [mutableDict setValue:self.nurseryChainId forKey:kINBaseClassNurseryChainId];
    [mutableDict setValue:[self.label dictionaryRepresentation] forKey:kINBaseClassLabel];
    [mutableDict setValue:[self.diaryFields dictionaryRepresentation] forKey:kINBaseClassDiaryFields];
    NSMutableArray *tempArrayForSettings = [NSMutableArray array];
    for (NSObject *subArrayObject in self.settings) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSettings addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSettings addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSettings] forKey:kINBaseClassSettings];
    [mutableDict setValue:[self.practitioners dictionaryRepresentation] forKey:kINBaseClassPractitioners];
    [mutableDict setValue:self.nurseryId forKey:kINBaseClassNurseryId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.children = [aDecoder decodeObjectForKey:kINBaseClassChildren];
    self.nurseryName = [aDecoder decodeObjectForKey:kINBaseClassNurseryName];
    self.nurseryChainName = [aDecoder decodeObjectForKey:kINBaseClassNurseryChainName];
    self.nurseryChainId = [aDecoder decodeObjectForKey:kINBaseClassNurseryChainId];
    self.label = [aDecoder decodeObjectForKey:kINBaseClassLabel];
    self.diaryFields = [aDecoder decodeObjectForKey:kINBaseClassDiaryFields];
    self.settings = [aDecoder decodeObjectForKey:kINBaseClassSettings];
    self.practitioners = [aDecoder decodeObjectForKey:kINBaseClassPractitioners];
    self.nurseryId = [aDecoder decodeObjectForKey:kINBaseClassNurseryId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_children forKey:kINBaseClassChildren];
    [aCoder encodeObject:_nurseryName forKey:kINBaseClassNurseryName];
    [aCoder encodeObject:_nurseryChainName forKey:kINBaseClassNurseryChainName];
    [aCoder encodeObject:_nurseryChainId forKey:kINBaseClassNurseryChainId];
    [aCoder encodeObject:_label forKey:kINBaseClassLabel];
    [aCoder encodeObject:_diaryFields forKey:kINBaseClassDiaryFields];
    [aCoder encodeObject:_settings forKey:kINBaseClassSettings];
    [aCoder encodeObject:_practitioners forKey:kINBaseClassPractitioners];
    [aCoder encodeObject:_nurseryId forKey:kINBaseClassNurseryId];
}

- (id)copyWithZone:(NSZone *)zone
{
    INBaseClass *copy = [[INBaseClass alloc] init];
    
    if (copy) {

        copy.children = [self.children copyWithZone:zone];
        copy.nurseryName = [self.nurseryName copyWithZone:zone];
        copy.nurseryChainName = [self.nurseryChainName copyWithZone:zone];
        copy.nurseryChainId = [self.nurseryChainId copyWithZone:zone];
        copy.label = [self.label copyWithZone:zone];
        copy.diaryFields = [self.diaryFields copyWithZone:zone];
        copy.settings = [self.settings copyWithZone:zone];
        copy.practitioners = [self.practitioners copyWithZone:zone];
        copy.nurseryId = [self.nurseryId copyWithZone:zone];
    }
    
    return copy;
}


@end
