//
//  InOutSeparateManagementEntity.m
//  eyLog
//
//  Created by Shuchi on 02/03/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "InOutSeparateManagementEntity.h"
#import "AppDelegate.h"


@implementation InOutSeparateManagementEntity


@dynamic uid;
@dynamic dateStr;
@dynamic date;
@dynamic childId;
@dynamic inTime;
@dynamic outTime;
@dynamic isInUploaded;
@dynamic isOutUploaded;
@dynamic practitionerId;
@dynamic practitionerPin;
@dynamic timeStamp;


+ (InOutSeparateManagementEntity *) createChildInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"InOutSeparateManagementEntity"
                                         inManagedObjectContext:a_context];
}

// Insert code here to add functionality to your managed object subclass
+ (InOutSeparateManagementEntity *) createInRowContext:(NSManagedObjectContext *)a_context
                                               withUid:(NSNumber *)uid
                                           withDateStr:(NSString *)dateStr
                                              withDate:(NSDate *)date
                                           withChildId:(NSNumber *)childId
                                            withInTime:(NSString *)inTime
                                           withOutTime:(NSString *)outTime
                                      withisInUploaded:(BOOL )isInUploaded
                                     withIsOutUploaded:(BOOL )isOutUploaded
                                   withPractitionerPin:(NSString *)practitionerPin
                                    withPractitionerId:(NSNumber *)practitionerId
                                         withtimeStamp:(NSString *)timeStamp
{
    InOutSeparateManagementEntity *_child;
    NSError *_savingError = nil;
    
    _child = [InOutSeparateManagementEntity createChildInContext:a_context];
    if(_child == nil) {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }
    _child.uid=uid;
    _child.dateStr=dateStr;
    _child.date=date;
    _child.childId=childId;
    _child.inTime=inTime;
    _child.outTime=outTime;
    _child.inTime=inTime;
    _child.outTime=outTime;
    
    _child.isInUploaded=isInUploaded;
    _child.isOutUploaded=isOutUploaded;
    _child.practitionerPin=practitionerPin;
    _child.practitionerId=practitionerId;
    _child.timeStamp=timeStamp;
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Child : Saved child with child Id %@", [_child childId]);
        return _child;
    }
    else
    {
        //Saved failed
        NSLog(@"Child : Saved child with child Id %@", [_child childId]);
        return nil;
    }
   
    
}
+(InOutSeparateManagementEntity *)fetchObservationInContext:(NSManagedObjectContext *)a_context withChildId:(NSNumber *)num andClientTimestamp:(NSString *)timestamp andDateStr:(NSString *)str
{

    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"childId = %@ AND dateStr =%@ AND timeStamp=%@",num,str,timestamp];
    
    // NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"readyForUpload == %d",a_isUploaded];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return [results firstObject];
    return nil;

    
}
+(NSArray *) fetchAllDataInContext:(NSManagedObjectContext *)a_context
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context];
    [request setEntity:entity];
    NSError *error;
    NSArray *results = [a_context executeFetchRequest:request error:&error];
    
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded withIsOutUploaded:(BOOL)isOutUploaded andOutTime:(NSString *)outTime
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
  
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isInUploaded == %d AND isOutUploaded == %d AND outTime!=%@",isInUploaded,isOutUploaded,outTime];
        // NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"readyForUpload == %d",a_isUploaded];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isInUploaded == %d",isInUploaded];
    // NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"readyForUpload == %d",a_isUploaded];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSPredicate *specificRecordID = [NSPredicate predicateWithFormat:@"uid == %@", uniqueID];
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
+ (instancetype) updateInContext:(NSManagedObjectContext *) context withisInUploaded :(BOOL ) isInUploaded forChild :(NSNumber *) childID withDate:(NSString *)dateString andClientTimestamp:(NSString *)timestamp andUid:(NSNumber *)uid
{
    InOutSeparateManagementEntity *object;
    NSError *_savingError = nil;
    
    //uid insertion
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"InOutSeparateManagementEntity"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"childId= %@ AND dateStr =%@ AND uid=%@",childID,dateString,uid]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
      NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if(result.count>0)
    {
       
        object=[result firstObject];
        object.isInUploaded=YES;
        object.timeStamp=timestamp;
      
        
    }
    
    
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return object;
    }
    return nil;
}
+(InOutSeparateManagementEntity *) fetchObservationInContext:(NSManagedObjectContext *)a_context withisInUploaded:(BOOL) isInUploaded withChildID:(NSNumber *)childID andDateStr:(NSString *)str andInTime:(NSString *)inTime{
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isInUploaded == %d AND childId = %@ AND dateStr =%@ AND inTime =%@ ",isInUploaded,childID,str,inTime];
        
    // NSPredicate *predicate1=[NSPredicate predicateWithFormat:@"readyForUpload == %d",a_isUploaded];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return [results firstObject];
    return nil;


}
+ (instancetype) updateInContext:(NSManagedObjectContext *) context withInOutSeparateManagementEntity:(InOutSeparateManagementEntity *)entity
{
    InOutSeparateManagementEntity *object;
    NSError *_savingError = nil;
    
    //uid insertion
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"InOutSeparateManagementEntity"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"childId= %@ AND dateStr =%@ AND inTime =%@",entity.childId,entity.dateStr,entity.inTime]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if(result.count>0)
    {
         object=[result firstObject];
        object.outTime=entity.outTime;
        object.isOutUploaded=0;
        
        
    }
    
    
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return object;
    }
    return nil;

}
+(BOOL) deleteInContext:(NSManagedObjectContext *)a_context
{
    NSError *_savingError = nil;
    NSArray *obj = [InOutSeparateManagementEntity fetchAllDataInContext:a_context];
    
    if (obj.count > 0) {
        for (InOutSeparateManagementEntity *inOut in obj) {
            [a_context deleteObject:inOut];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Practitioners : Successfully Deleted Practitioners.");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"Practitioners : Deleting Practitioners Failed.");
        return false;
    }
}

@end
