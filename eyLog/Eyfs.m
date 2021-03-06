//
//  Eyfs.m
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Eyfs.h"


@implementation Eyfs

@dynamic areaDesc;
@dynamic shortDesc;
@dynamic areaIdentifier;
@dynamic frameworkType;



+ (Eyfs *) createEyfsInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Eyfs"
                                         inManagedObjectContext:a_context];
}



+ (Eyfs *) createEyfsInContext:(NSManagedObjectContext *)a_context
                     withAreaIdentifier:(NSNumber *)a_areaIdentifier
                      withFrameworkType:(NSString *)a_frameworkType
                          withShortDesc:(NSString *)a_shortDesc
                           withAreaDesc:(NSString *)a_areaDesc
{
    Eyfs *_eyfs;
    NSError *_savingError = nil;
    _eyfs = [Eyfs createEyfsInContext:a_context];
    
    if(_eyfs == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _eyfs.areaIdentifier = a_areaIdentifier;
    _eyfs.frameworkType=a_frameworkType;
    _eyfs.shortDesc=a_shortDesc;
    _eyfs.areaDesc=a_areaDesc;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _eyfs;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}


+(NSArray *) fetchALLEyfsInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchEyfsInContext:(NSManagedObjectContext *)a_context withAreaIdentifier:(NSNumber *)a_areaIdentifier withFrameWork:(NSString *)a_framework
{    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *statementPredicate=[NSPredicate predicateWithFormat:@"areaIdentifier=%@",a_areaIdentifier];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[statementPredicate,frameworkPredicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
    
}
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:frameworkPredicate];
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
