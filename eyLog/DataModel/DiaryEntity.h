//
//  DiaryEntity.h
//
//
//  Created by Arpan Dixit on 25/06/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DiaryFields;

@interface DiaryEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *fields;
@property(nonatomic,assign)BOOL visibility;
@property(nonatomic,strong)NSString *age_group;
@property(nonatomic,strong)NSString *age_group_start;
@property(nonatomic,strong)NSString *age_group_end;
@property(nonatomic,strong)NSString *cameInVariableName;
@property(nonatomic,strong)NSString *leftAtVariableName;


@end

@interface DiaryEntity (CoreDataGeneratedAccessors)

- (void)addFieldsObject:(DiaryFields *)value;
- (void)removeFieldsObject:(DiaryFields *)value;
- (void)addFields:(NSSet *)values;
- (void)removeFields:(NSSet *)values;


+ (instancetype) createEYL_DiaryEntityInContext:(NSManagedObjectContext *) context;

+ (instancetype) createEYL_DiaryEntityContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forEntityName : (NSString *) entityName;

// To fetch The results

+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context;
+(BOOL) deleteInContext:(NSManagedObjectContext *)a_context;

@end
