//
//  LeuvenScale.m
//  eyLog
//
//  Created by Qss on 11/5/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LeuvenScale.h"


@implementation LeuvenScale
@dynamic leuvenScaleType;
@dynamic scale;
@dynamic signals;

+ (LeuvenScale *) createPractitionersInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"LeuvenScale"
                                         inManagedObjectContext:a_context];
}



+ (LeuvenScale *) createPractitionersInContext:(NSManagedObjectContext *)a_context
                           withLeuvenScaleType:(NSString *)a_leuvenScaleType
                                     withScale:(NSNumber *)a_scale
                                   withSignals:(NSString *)a_signals
{
    LeuvenScale *_leuvenScale;
    NSError *_savingError = nil;
    
    _leuvenScale = [LeuvenScale createPractitionersInContext:a_context];
    if(_leuvenScale == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"LeuvenScale : Couldn't create Practitioner in context %s", "");
    }
    _leuvenScale.leuvenScaleType = a_leuvenScaleType;
    _leuvenScale.scale = a_scale;
    _leuvenScale.signals=a_signals;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _leuvenScale;
    }
    else
    {
        //Saved failed
        return nil;
    }
}

+(NSArray *) fetchAllLeuvenScaleInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchLeuvenInContext:(NSManagedObjectContext *)a_context withLeuvenScaleType:(NSString *)a_LeuvenScaleType
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"leuvenScaleType = %@",a_LeuvenScaleType]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchLeuvenInContext:(NSManagedObjectContext *)a_context withLeuvenScaleType:(NSString *)a_LeuvenScaleType andLeuvenScale:(NSNumber*)scale
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"leuvenScaleType = %@ AND scale =%@",a_LeuvenScaleType,scale]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
  
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
