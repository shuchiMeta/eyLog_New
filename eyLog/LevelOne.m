//
//  LevelOne.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LevelOne.h"


@implementation LevelOne

@dynamic frameworkType;
@dynamic levelOneDescription;
@dynamic levelOneGroup;
@dynamic levelOneIdentifier;



+ (LevelOne *)createLevelOneInContext:(NSManagedObjectContext *)a_context{
    return [NSEntityDescription insertNewObjectForEntityForName:@"LevelOne" inManagedObjectContext:a_context];
}
+ (LevelOne *)createLevelOneInContext:(NSManagedObjectContext *)a_context
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
              withFrameworkIdentifier:(NSString *)a_frameworkType
              withLevelOneDescription:(NSString *)a_levelOneDescription
                    withLevelOneGroup:(NSString *)a_levelOneGroup{
    LevelOne *_levelOne;
    NSError *_savingError = nil;
    _levelOne = [LevelOne createLevelOneInContext:a_context];
    
    
    if(_levelOne == nil){
        NSLog(@" ");
    }
    _levelOne.levelOneIdentifier =a_levelOneIdentifier;
    _levelOne.frameworkType = a_frameworkType;
    _levelOne.levelOneDescription = a_levelOneDescription;
    _levelOne.levelOneGroup =a_levelOneGroup;
    
    if([a_context save:&_savingError]){
        return _levelOne;
    }else{
        return nil;
    }
}

+(NSArray *)fetchAllLevelOneInContext:(NSManagedObjectContext *)a_context{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError =nil;
    NSArray *result = [a_context executeFetchRequest:request error:&fetchError];
    if(result.count > 0){
        return result;
    }
    return nil;
}

+(NSArray *)fetchLevelOneInContext:(NSManagedObjectContext *)a_context withLevelIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework{
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
