
//
//  Ecat.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Ecat.h"

@implementation Ecat
@dynamic levelOneIdentifier;
@dynamic levelOneDescription;
@dynamic frameworkType;

+ (Ecat *) createEcatInContext:(NSManagedObjectContext *)a_context
{

    return [NSEntityDescription insertNewObjectForEntityForName:@"Ecat"
                                         inManagedObjectContext:a_context];
}

+(Ecat *)createEcatInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameworkType:(NSString *)a_frameworkType withlevelOneDescription:(NSString *)a_levelOneDescription
{
    Ecat *_Ecat;
    NSError *_savingError = nil;
    _Ecat = [Ecat createEcatInContext:a_context];

    if(_Ecat == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Ecat : Couldn't create Ecat in context %s", "");
    }
    _Ecat.levelOneIdentifier = a_levelOneIdentifier;
    _Ecat.frameworkType=a_frameworkType;
    _Ecat.levelOneDescription=a_levelOneDescription;

    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _Ecat;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}

+(NSArray *)fetchALLEcatInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *)fetchEcatInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameWork:(NSString *)a_framework
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
