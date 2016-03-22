//
//  CfeFramework.m
//  eyLog
//
//  Created by shuchi on 03/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeFramework.h"

@implementation CfeFramework

@dynamic levelOneIdentifier;
@dynamic levelOneDescription;
@dynamic levelOneGroup;
@dynamic frameworkType;


+ (CfeFramework *) createFrameworkInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"CfeFramework"
                                         inManagedObjectContext:a_context];
}



+(CfeFramework *)createCfeFrameworkInContext:(NSManagedObjectContext *)a_context
                                      withLevelIdentifier:(NSNumber *)a_levelIdentifier
                                        withFrameworkType:(NSString *)a_frameworkType
                                     withLevelDescription:(NSString *)a_levelDescription
                                           withLevelGroup:(NSString *)a_levelGroup
{
    CfeFramework *_CfeFramework;
    NSError *_savingError = nil;
    
    _CfeFramework = [CfeFramework createFrameworkInContext:a_context];
    
    if(_CfeFramework == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    
    _CfeFramework.levelOneIdentifier = a_levelIdentifier;
    _CfeFramework.frameworkType=a_frameworkType;
    _CfeFramework.levelOneGroup=a_levelGroup;
    _CfeFramework.levelOneDescription=a_levelDescription;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _CfeFramework;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}

+(NSArray *)fetchCfeFrameworkInContext:(NSManagedObjectContext *)a_context withFramework:(NSString *)a_framework
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




+(NSArray *)fetchCfeFrameworkInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelIdentifier withFramework:(NSString *)a_framework
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
