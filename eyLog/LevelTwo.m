//
//  LevelTwo.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LevelTwo.h"


@implementation LevelTwo

@dynamic levelOneIdentifier;
@dynamic levelTwoDescription;
@dynamic levelTwoGroup;
@dynamic levelTwoIdentifier;
@dynamic frameworkType;


+(LevelTwo *)createLevelTwoInContext:(NSManagedObjectContext *)a_context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"LevelTwo" inManagedObjectContext:a_context];
}

+ (LevelTwo *)createLevelTwoInContext:(NSManagedObjectContext *)a_context
               withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
               withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                    withlevelTwoGroup:(NSString *)a_levelTwoGroup
              withlevelTwoDescription:(NSString *)a_levelTwoDescription
                    withFrameWorkType:(NSString *)a_frameworkType{
    LevelTwo *_levelTwo;
    NSError *_savingError = nil;
    _levelTwo = [LevelTwo createLevelTwoInContext:a_context];
    if(_levelTwo == nil){
        NSLog(@"");
    }
    _levelTwo.levelOneIdentifier =a_levelOneIdentifier;
    _levelTwo.frameworkType = a_frameworkType;
    _levelTwo.levelTwoDescription = a_levelTwoDescription;
    _levelTwo.levelTwoGroup =a_levelTwoGroup;
    _levelTwo.levelTwoIdentifier=a_levelTwoIdentifier;
    
    if([a_context save:&_savingError]){
        return _levelTwo;
    }else{
        return nil;
    }
}

+(NSArray *)fetchLvelTwoInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelOneIdentifier = [NSPredicate predicateWithFormat:@"levelOneIdentifier = %@",a_levelOneIdentifier];
    NSPredicate *levelTwoFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelOneIdentifier,levelTwoFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
    {
        return results;
    }
    return nil;
}

+(NSArray *)fetchLevelTwoInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework{

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoIdentifier = [NSPredicate predicateWithFormat:@"levelTwoIdentifier = %@",a_levelTwoidentifier];
    NSPredicate *levelTwoFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelTwoIdentifier,levelTwoFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count)
    {
        return results;
    }
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
