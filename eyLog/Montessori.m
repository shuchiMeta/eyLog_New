//
//  Montessori.m
//  eyLog
//
//  Created by Shobhit on 27/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Montessori.h"


@implementation Montessori

@dynamic frameworkType;
@dynamic levelOneDescription;
@dynamic levelOneGroup;
@dynamic levelOneIdentifier;

+ (Montessori *) createMontessoriInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Montessori"
                                         inManagedObjectContext:a_context];
}



+ (Montessori *) createMontessoriInContext:(NSManagedObjectContext *)a_context
                    withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                         withFrameworkType:(NSString *)a_frameworkType
                         withLevelOneGroup:(NSString *)a_levelgroup
                   withlevelOneDescription:(NSString *)a_levelOneDescription
{
    Montessori *_Montessori;
    NSError *_savingError = nil;
    _Montessori = [Montessori createMontessoriInContext:a_context];
    
    if(_Montessori == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _Montessori.levelOneIdentifier = a_levelOneIdentifier;
    _Montessori.frameworkType=a_frameworkType;
    _Montessori.levelOneDescription=a_levelOneDescription;
    _Montessori.levelOneGroup=a_levelgroup;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _Montessori;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}


+(NSArray *) fetchALLMontessoriInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelOnePredicate=[NSPredicate predicateWithFormat:@"levelOneIdentifier=%@",a_levelOneIdentifier];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[levelOnePredicate,frameworkPredicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelOneGroup:(NSString *)a_levelOneGroup withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelOneGroup=[NSPredicate predicateWithFormat:@"levelOneGroup=%@",a_levelOneGroup];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[levelOneGroup,frameworkPredicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withlevelTwoGroup:(NSNumber *)a_levelTwoGroup withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoGroup=[NSPredicate predicateWithFormat:@"levelTwoGroup=%@",a_levelTwoGroup];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[levelTwoGroup,frameworkPredicate]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchMontessoriInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFrameWork:(NSString *)a_framework{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelThreePredicate=[NSPredicate predicateWithFormat:@"levelThreeIdentifier=%@",a_levelThreeIdentifier];
    NSPredicate *frameworkPredicate=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[levelThreePredicate,frameworkPredicate]]];
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
