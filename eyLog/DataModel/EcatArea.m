//
//  EcatArea.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatArea.h"

@implementation EcatArea
@dynamic frameworkType;
@dynamic levelOneDescription;
@dynamic levelOneIdentifier;

+ (EcatArea *)createEcatAreaInContext:(NSManagedObjectContext *)a_context{
    return [NSEntityDescription insertNewObjectForEntityForName:@"EcatArea" inManagedObjectContext:a_context];
}

+ (EcatArea *)createEcatAreaInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFrameworkIdentifier:(NSString *)a_frameworkType withLevelOneDescription:(NSString *)a_levelOneDescription{

    EcatArea *_ecatArea;
    NSError *_savingError = nil;
    _ecatArea = [EcatArea createEcatAreaInContext:a_context];


    if(_ecatArea == nil){
        NSLog(@" ");
    }
    _ecatArea.levelOneIdentifier =a_levelOneIdentifier;
    _ecatArea.frameworkType = a_frameworkType;
    _ecatArea.levelOneDescription = a_levelOneDescription;

    if([a_context save:&_savingError]){
        return _ecatArea;
    }else{
        return nil;
    }
}

+(NSArray *)fetchAllEcatAreaInContext:(NSManagedObjectContext *)a_context{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError =nil;
    NSArray *result = [a_context executeFetchRequest:request error:&fetchError];
    if(result.count > 0){
        return result;
    }
    return nil;
}

+(NSArray *)fetchEcatAreaInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity: [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *identifierPredicate = [NSPredicate predicateWithFormat:@"levelOneIdentifier=%@",a_levelOneIdentifier];
    NSPredicate *frameworkPredicate = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[identifierPredicate,frameworkPredicate]]];
    NSError *fetchError = nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
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
