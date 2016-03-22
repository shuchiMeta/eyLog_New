//
//  DiaryFields.h
//
//
//  Created by Arpan Dixit on 25/06/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface DiaryFields : NSManagedObject

@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSString * keyValue;
@property (nonatomic, retain) NSManagedObject *relationship;

+ (instancetype) createEYL_DiaryFieldsInContext:(NSManagedObjectContext *) context;


@end
