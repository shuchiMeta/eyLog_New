//
//  ChildInOutTime.m
//  eyLog
//
//  Created by Arpan Dixit on 27/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChildInOutTime.h"
#import "AppDelegate.h"


@implementation ChildInOutTime

@dynamic childID;
@dynamic currentDate;
@dynamic inTime;
@dynamic outTime;
@dynamic uploadFlag;
@dynamic uniqueTabletOID;
@synthesize timeDifference;

+ (instancetype) createChildInOutTimeContext:(NSManagedObjectContext *) context
{

    return [NSEntityDescription insertNewObjectForEntityForName:@"ChildInOutTime"
                                         inManagedObjectContext:context];
}


+ (instancetype) createChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary
{
    NSLog(@"dictionary is %@", dictionary);
    ChildInOutTime *obj;
    NSError *_savingError = nil;
    obj = [ChildInOutTime createChildInOutTimeContext:context];

    if(obj == nil)
    { //Couldn't create the data base entry
        NSLog(@"EYL_DiaryEntity : Couldn't create Ecat in context %s", "");
    }

    // Check if record Exists
    obj.childID = [NSNumber numberWithInt:[[dictionary valueForKey:@"childid"] intValue]];
    obj.currentDate = [dictionary valueForKey:@"date"];
    obj.inTime = [dictionary valueForKey:@"intime"];
    obj.outTime = [dictionary valueForKey:@"outtime"];
   // obj.uploadFlag = [NSNumber numberWithBool:[[dictionary valueForKey:@"uploadedflag"] intValue]];
    obj.uploadFlag = [NSNumber numberWithInteger:0];
    obj.uniqueTabletOID=[dictionary objectForKey:@"uniqueTableID"];
    obj.timeDifference = [dictionary objectForKey:@"timedifference"];
    
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return obj;
    }
    return nil;
}
+ (instancetype) updateOrCreateChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forChild :(NSNumber *) childID withDate:(NSString *)dateString
{
    ChildInOutTime *object;
    NSError *_savingError = nil;

    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"ChildInOutTime"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"childID=%@ AND currentDate=%@ ",childID,dateString]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
    // ChildInOutTime *objChild = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if(result.count>0)
    {
        object=[ChildInOutTime updateChildInOutTimeContext:context withDictionary:dictionary forChild:childID withDate:dateString];
        
        
    }
    else
    {
        object= [self createChildInOutTimeContext:context withDictionary:dictionary];
        
    }
    
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return object;
    }
    return nil;
}

+ (instancetype) updateChildInOutTimeContext:(NSManagedObjectContext *) context withDictionary :(NSDictionary *) dictionary forChild :(NSNumber *) childID withDate:(NSString *)dateString
{
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"ChildInOutTime"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"childID=%@ AND currentDate=%@ ",childID,dateString]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
   // ChildInOutTime *objChild = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    ChildInOutTime *objChild=[result lastObject];
    
    
    objChild.currentDate = [dictionary valueForKey:@"date"];
    objChild.inTime = [dictionary valueForKey:@"intime"];
    objChild.outTime = [dictionary valueForKey:@"outtime"];
    objChild.uploadFlag = [NSNumber numberWithBool:[[dictionary valueForKey:@"uploadedflag"] intValue]];
    objChild.uniqueTabletOID=[dictionary objectForKey:@"uniqueTableID"];
    objChild.timeDifference = [dictionary objectForKey:@"timedifference"];

    [context save:nil];
    NSError *_savingError = nil;
    
//    // new code
//    NSLog(@"dictionary is %@", dictionary);
//    ChildInOutTime *obj;
//    NSError *_savingError = nil;
//    obj = [ChildInOutTime createChildInOutTimeContext:context];
//    
//    if(obj == nil)
//    { //Couldn't create the data base entry
//        NSLog(@"EYL_DiaryEntity : Couldn't create Ecat in context %s", "");
//    }
//    
//    // Check if record Exists
//    obj.childID = [NSNumber numberWithInt:[[dictionary valueForKey:@"childid"] intValue]];
//    obj.currentDate = [dictionary valueForKey:@"date"];
//    obj.inTime = [dictionary valueForKey:@"intime"];
//    obj.outTime = [dictionary valueForKey:@"outtime"];
//    obj.uploadFlag = [NSNumber numberWithBool:[[dictionary valueForKey:@"uploadedflag"] intValue]];
//    obj.uniqueTabletOID=[dictionary objectForKey:@"uniqueTableID"];
//    obj.timeDifference = [dictionary objectForKey:@"timedifference"];
    
    if([context save:&_savingError])
    {
        //Saved the new practitioner
        return objChild;
    }
    return nil;
}

+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"ChildInOutTime" inManagedObjectContext:context]];
    NSError *fetchError=nil;
    NSArray *results=[context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+ (int) isChildExist: (NSNumber *) childID withDate :(NSString *)dateString context :(NSManagedObjectContext *) context
{

    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
    NSPredicate *specificChildID =[NSPredicate predicateWithFormat:@"childID = %@",childID];
    NSPredicate *specificDate=[NSPredicate predicateWithFormat:@"currentDate = %@",dateString];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificDate, specificChildID]]];

    NSError *fetchError=nil;
    NSInteger count = [context countForFetchRequest:request error:&fetchError];

    if (!fetchError){
        return (int)count;
    }
    else
        return -1;
}


+ (void) deleteRecordForChild : (NSNumber *) childID withDate : (NSString *) dateString andDetails : (NSDictionary *) dictionary andContext : (NSManagedObjectContext *) context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];

    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"childID == %@", childID];
    NSPredicate *specificDate = [NSPredicate predicateWithFormat:@"currentDate == %@", dateString];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificDate, specificChildID]]];

    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];

    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [context deleteObject:managedObject];
        }
        //Save context to write to store
        [context save:nil];
    }
}

+(instancetype)fetchChildINOutInfo:(NSManagedObjectContext *)context withChildID:(NSNumber *)childID withDate:(NSString *)dateString{

    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childID=%@",childID];
    NSPredicate *datePredicate=[NSPredicate predicateWithFormat:@"currentDate=%@",dateString];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[childIDPredicate,datePredicate]]];
    NSError *fetchError=nil;
    ChildInOutTime *obj=[[context executeFetchRequest:request error:&fetchError] lastObject];
    
    request=nil;
    childIDPredicate=nil;
    datePredicate=nil;
    
    if (obj) {
        return obj;
    }
    return nil;
}

+(BOOL)updateRecord:(NSManagedObjectContext *)a_context withChildID:(NSNumber *)childID withDate:(NSString *)recordDate withInTimeValue:(NSString *)inTime withOutTimeValue:(NSString *)outTime withUploadFlag:(NSNumber *)uploadFlag{
    NSError *_savingError = nil;
    ChildInOutTime *obj=[self fetchChildINOutInfo:a_context withChildID:childID withDate:recordDate];

    inTime?obj.inTime=inTime :@"";
    outTime?obj.outTime=outTime:@"";
    uploadFlag?obj.uploadFlag=uploadFlag:@"";

    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return YES;
    }
    return false;
}


#pragma Mark Custome Method for uploading & deleteing Records

+(NSArray *)fetchAllRecordsWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)a_context{

    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:predicate];
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"ChildInOutTime"];
    fetchRequest.predicate=predicate;
    // ChildInOutTime *objChild = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    NSArray *array = [a_context executeFetchRequest:fetchRequest error:nil];
   
    
    NSError *fetchError;
       if (array.count>0) {
        return array;
    }
    return nil;
}

+(void)deleteRecordWithUniqueID:(NSNumber *)uniqueID{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSPredicate *specificRecordID = [NSPredicate predicateWithFormat:@"uniqueTabletOID == %@", uniqueID];
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

+(void)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context beforeDate:(NSString*)date{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"currentDate != %@", date];
    NSPredicate *uploadFlag=[NSPredicate predicateWithFormat:@"uploadFlag == 1"];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[datePredicate,uploadFlag]]];

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
//
//+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelOneGroup:(NSString *)a_levelOneGroup withFrameWork:(NSString *)a_framework
//{
//    NSFetchRequest *request=[[NSFetchRequest alloc]init];
//    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
//    NSPredicate *levelOneGroup=[NSPredicate predicateWithFormat:@"levelOneGroup=%@",a_levelOneGroup];
//    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
//    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[levelOneGroup,frameworkPredicate]]];
//    NSError *fetchError=nil;
//    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
//    if(results.count>0)
//        return results;
//    return nil;
//}

+ (NSArray *) fetchSimilarRecordsForDate : (NSString *) dateString andChildID :(NSNumber *) childID andContext : (NSManagedObjectContext *) managedObjectcontext
{
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
//    request.predicate = [NSPredicate predicateWithFormat:@"childID == %@ && id == %d", @"Pune", 3];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
//    
//    NSArray *results = [managedObjectcontext executeFetchRequest:request error:nil];
//    return results;
    
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectcontext]];
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childID=%@",childID];
    NSPredicate *datePredicate=[NSPredicate predicateWithFormat:@"currentDate=%@",dateString];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[childIDPredicate,datePredicate]]];
    NSError *fetchError=nil;
    
    NSArray *results = [managedObjectcontext executeFetchRequest:request error:&fetchError];
   
    if (!results) {
        return nil;
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timeDifference" ascending:YES];
    
    
    
    NSArray *sortedResults = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    return sortedResults;

}


+ (void) deleteRecordForChildWithTimeDifference : (NSNumber *) timeDifference andContext : (NSManagedObjectContext *) context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];
    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"timeDifference == %@", timeDifference];
    [request setPredicate:specificChildID];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [context deleteObject:managedObject];
        }
        //Save context to write to store
        [context save:nil];
    }
}


+(instancetype) fetchAllRecordsandUpdate:(NSManagedObjectContext *) context withChildDetails :(NSDictionary *) childInfo
{
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:@"ChildInOutTime"];
    NSPredicate *specificChildID = [NSPredicate predicateWithFormat:@"childID == %@", [childInfo valueForKey:@"childid"]];
    NSPredicate *specificDate = [NSPredicate predicateWithFormat:@"currentDate == %@",[childInfo valueForKey:@"date"]];

    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[specificChildID,specificDate]]];
    
    NSError *fetchError=nil;
    NSArray *results=[context executeFetchRequest:request error:&fetchError];


    if ([results count]==0)
    {
        ChildInOutTime *obj;
        NSError *_savingError = nil;
        obj = [ChildInOutTime createChildInOutTimeContext:context];
        
        if(obj == nil)
        { //Couldn't create the data base entry
            NSLog(@"EYL_DiaryEntity : Couldn't create Ecat in context %s", "");
        }
        
        // Check if record Exists
        obj.childID = [NSNumber numberWithInt:[[childInfo valueForKey:@"childid"] intValue]];
        obj.currentDate = [childInfo valueForKey:@"date"];
        obj.inTime = [childInfo valueForKey:@"intime"];
        obj.outTime = [childInfo valueForKey:@"outtime"];
        if([childInfo valueForKey:@"uploadedflag"]!=nil)
        {
        obj.uploadFlag = [NSNumber numberWithBool:[[childInfo valueForKey:@"uploadedflag"] intValue]];
        }
        else
        {
        obj.uploadFlag = [NSNumber numberWithInteger:0];
        }
        //obj.uploadFlag = [NSNumber numberWithInteger:0];
        obj.uniqueTabletOID=[childInfo objectForKey:@"uniqueTableID"];
        obj.timeDifference = [childInfo objectForKey:@"timedifference"];
        
        if([context save:&_savingError])
        {
            //Saved the new practitioner
            return obj;
        }
        return nil;

    }
    else
    {
        ChildInOutTime *objChild = [results lastObject];
        
        objChild.outTime = [childInfo valueForKey:@"outtime"];
        objChild.uniqueTabletOID=[childInfo objectForKey:@"uniqueTableID"];
        objChild.timeDifference = [childInfo objectForKey:@"timedifference"];
        if([childInfo valueForKey:@"uploadedflag"]!=nil)
        {
        objChild.uploadFlag = [NSNumber numberWithBool:[[childInfo valueForKey:@"uploadedflag"] intValue]];
        }
        else{
            objChild.uploadFlag=[NSNumber numberWithInteger:0];
            
        }

        
        NSError *_savingError = nil;
        if([context save:&_savingError])
        {
            //Saved the new practitioner
            return objChild;
        }
        return nil;
    }
    
    return nil;
}
@end
