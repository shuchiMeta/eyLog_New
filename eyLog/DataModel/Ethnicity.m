//
//  Ethnicity.m
//  eyLog
//
//  Created by shuchi on 14/10/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Ethnicity.h"

@implementation Ethnicity

@dynamic ethnicityDesc;
@dynamic ethnicityId;
@dynamic parent;
@dynamic ethnicitychildid;


+ (Ethnicity *) createInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Ethnicity"
                                         inManagedObjectContext:a_context];
}
+ (Ethnicity *) createInContext:(NSManagedObjectContext *)a_context
                 withethnicityDesc:(NSString *)ethnicityDesc
                   withethnicityId:(NSNumber *)ethnicityId
                        withparent:(NSNumber *)parent
           withEthnicityChildid:(NSNumber *)ethnicitychildid
{

    Ethnicity *_Ethnicity;
    NSError *_savingError = nil;
    _Ethnicity = [Ethnicity createInContext:a_context];
    
    if(_Ethnicity == nil)
    {
       
    }
    _Ethnicity.ethnicityDesc = ethnicityDesc;
    _Ethnicity.ethnicityId=ethnicityId;
    _Ethnicity.parent=parent;
    _Ethnicity.ethnicitychildid=ethnicitychildid;
    
    
    if([a_context save:&_savingError])
    {
        return _Ethnicity;
    }
    else
    {
        
        return nil;
    }

}
+(Ethnicity *) fetchInContext:(NSManagedObjectContext *)a_context withethnicitychildid:(NSNumber *)ethnicitychildid {
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelOnePredicate=[NSPredicate predicateWithFormat:@"ethnicitychildid=%@",ethnicitychildid];
     [request setPredicate:levelOnePredicate];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return [results firstObject];
    return nil;
}
+(Ethnicity *) fetchInContext:(NSManagedObjectContext *)a_context withethnicityId:(NSNumber *)ethnicityId {
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelOnePredicate=[NSPredicate predicateWithFormat:@"ethnicityId=%@",ethnicityId];
    [request setPredicate:levelOnePredicate];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return [results firstObject];
    return nil;
}
+(NSArray *) fetchAllRecords:(NSManagedObjectContext *) context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"Ethnicity" inManagedObjectContext:context]];
    NSError *fetchError=nil;
    NSArray *results=[context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"Ethnicity" inManagedObjectContext:a_context]];
     NSError *error = nil;
     NSArray *result = [a_context executeFetchRequest:request error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [a_context deleteObject:managedObject];
        }
        //Save context to write to store
        
    }
    if( [a_context save:&error])
    {
        //Saved the new nursery
        NSLog(@"Deleted now");
        
        return true;
    } else
    {
        //Saved failed
        return false;
    }

    
}

@end
