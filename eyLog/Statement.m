//
//  Statement.m
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Statement.h"

@implementation Statement
@dynamic ageIdentifier;
@dynamic frameworkType;
@dynamic statementDesc;
@dynamic shortDesc;
@dynamic statementIdentifier;
@dynamic aspectIdentifier;



+ (Statement *) createStatementInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Statement"
                                         inManagedObjectContext:a_context];
}



+ (Statement *) createStatementInContext:(NSManagedObjectContext *)a_context
                       withAgeIdentifier:(NSNumber *)a_ageIdentifier
                       withFrameworkType:(NSString *)a_frameworkType
                       withStatementDesc:(NSString *)a_statementDesc
                           withShortDesc:(NSString *)a_shortDesc
                 withstatementIdentifier:(NSNumber *)a_statementIdentifier
                    withAspectIdentifier:(NSNumber *)a_aspectIdentifier
{
    Statement *_statement;
    NSError *_savingError = nil;
    _statement = [Statement createStatementInContext:a_context];
    
    if(_statement == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _statement.ageIdentifier = a_ageIdentifier;
    _statement.frameworkType=a_frameworkType;
    _statement.statementDesc=a_statementDesc;
    _statement.shortDesc=a_shortDesc;
    _statement.statementIdentifier=a_statementIdentifier;
    _statement.aspectIdentifier=a_aspectIdentifier;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _statement;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
//    NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
//    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[childId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withAgeIdentifier:(NSNumber *)a_ageIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"ageIdentifier = %@",a_ageIdentifier];
   // NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework
{
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *aspectPredicate=[NSPredicate predicateWithFormat:@"aspectIdentifier=%@",a_aspectIdentifier];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[aspectPredicate,frameworkPredicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withStatementIdentifier:(NSNumber *)a_statementIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *statementPredicate=[NSPredicate predicateWithFormat:@"statementIdentifier=%@",a_statementIdentifier];
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
