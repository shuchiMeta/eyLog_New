//
//  EcatFramework.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatFramework.h"

@implementation EcatFramework
@dynamic levelOneIdentifier;
@dynamic levelOneDescription;
@dynamic frameworkType;

+ (EcatFramework *) createFrameworkInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"EcatFramework"
                                         inManagedObjectContext:a_context];
}



+(EcatFramework *)createEcatFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFrameworkType:(NSString *)a_frameworkType withLevelDescription:(NSString *)a_levelDescription
{
    EcatFramework *_ecatFramework;
    NSError *_savingError = nil;
    
    _ecatFramework = [EcatFramework createFrameworkInContext:a_context];
    
    if(_ecatFramework == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    
    _ecatFramework.levelOneIdentifier = a_levelIdentifier;
    _ecatFramework.frameworkType=a_frameworkType;
    _ecatFramework.levelOneDescription=a_levelDescription;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _ecatFramework;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}

+(NSArray *)fetchEcatFrameworkInContext:(NSManagedObjectContext *)a_context withFramework:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    
    NSPredicate *frameworkType=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[frameworkType]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}



+(NSArray *)fetchEcatFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFramework:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *statementPredicate=[NSPredicate predicateWithFormat:@"levelOneIdentifier=%@",a_levelIdentifier];
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
