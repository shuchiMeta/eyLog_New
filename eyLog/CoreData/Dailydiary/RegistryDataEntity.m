//
//  RegistryDataEntity.m
//  eyLog
//
//  Created by Shuchi on 02/03/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "RegistryDataEntity.h"
#import "AppDelegate.h"


@implementation RegistryDataEntity


@dynamic childId;
@dynamic date;
@dynamic dateStr;
@dynamic uid;
@dynamic jsonDict;
// Insert code here to add functionality to your managed object subclass
+ (RegistryDataEntity *) createChildInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"RegistryDataEntity"
                                         inManagedObjectContext:a_context];
}


+(RegistryDataEntity *)createRowInContext:(NSManagedObjectContext*)context
                                  withUid:(NSNumber *)num
                             withJsonDict:(NSData *)data
                              withdateStr:(NSString *)datestr
                                 withDate:(NSDate *)date
                              withChildId:(NSNumber *)childId

{
    RegistryDataEntity *entity;
    NSError *_savingError = nil;
    
    entity = [RegistryDataEntity createChildInContext:context];
    if(entity == nil) {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }
    entity.uid=num;
    entity.dateStr=datestr;
    entity.date=date;
    entity.childId=childId;

    entity.jsonDict=data;
    
    
    if( [context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Child : Saved registry with child Id %@", [entity childId]);
        return entity;
    }
    else
    {
        //Saved failed
        NSLog(@"Child : Saved registry with child Id %@", [entity childId]);
        return nil;
    }
    

    

}

+(NSArray *)fetchAllEntriesInEntityWithContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if(results.count>0)
        return results;
    return nil;


    
}
+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID andDateStr:(NSString *)str{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSPredicate *specificRecordID = [NSPredicate predicateWithFormat:@"uid == %@ AND dateStr=%@", uniqueID,str];
    [request setPredicate:specificRecordID];
    
    NSError *error = nil;
    NSArray *result = [[AppDelegate context] executeFetchRequest:request error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [[AppDelegate context] deleteObject:managedObject];
        }
        //Save context to write to store
        [[AppDelegate context] save:nil];
    }
    
}
+(BOOL)deleteRowAndContext:(NSManagedObjectContext *)a_context;
{
    NSError *_savingError = nil;
    NSArray *obj = [RegistryDataEntity fetchAllEntriesInEntityWithContext:a_context];
    
    if (obj.count > 0) {
        for (RegistryDataEntity *entity in obj) {
            [a_context deleteObject:entity];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"RegistryDataEntity : Successfully Deleted RegistryDataEntity.");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"RegistryDataEntity : Deleting Practitioners RegistryDataEntity.");
        return false;
    }

}


@end
