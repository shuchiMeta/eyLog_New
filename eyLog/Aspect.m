//
//  Aspect.m
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Aspect.h"


@implementation Aspect

@dynamic aspectIdentifier;
@dynamic aspectDesc;
@dynamic shortDesc;
@dynamic statements;
@dynamic areaIdentifier;
@dynamic frameworkType;


+ (Aspect *) createAspectInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Aspect"
                                         inManagedObjectContext:a_context];
}



+ (Aspect *)createAspectInContext:(NSManagedObjectContext *)a_context
              withAspectIdentifier:(NSNumber *)a_aspectIdentifier
                withAreaIdentifier:(NSNumber *)a_areaIdentifier
                    withAspectDesc:(NSString *)a_aspectDesc
                    withStatements:(NSString *)a_statements
                 withFrameworkType:(NSString *)a_frameworkType
{
    Aspect *_aspect;
    NSError *_savingError = nil;
    _aspect = [Aspect createAspectInContext:a_context];
    
    if(_aspect == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _aspect.aspectIdentifier = a_aspectIdentifier;
    _aspect.areaIdentifier = a_areaIdentifier;
    _aspect.aspectDesc = a_aspectDesc;
    _aspect.statements=a_statements;
    _aspect.frameworkType=a_frameworkType;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _aspect;
    }
    else
    {
        //Saved failed
       // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_aspect level]);
        return nil;
    }
}

+(NSArray *) fetchAspectInContext:(NSManagedObjectContext *)a_context withAreaIdentifier:(NSNumber *)a_areaIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"areaIdentifier = %@",a_areaIdentifier];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchAspectInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"aspectIdentifier = %@",a_aspectIdentifier];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId]]];
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