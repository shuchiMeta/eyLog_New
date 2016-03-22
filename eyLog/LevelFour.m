//
//  LevelFour.m
//  eyLog
//
//  Created by Shobhit on 24/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LevelFour.h"


@implementation LevelFour

@dynamic levelFourIdentifier;
@dynamic levelThreeIdentifier;
@dynamic levelTwoIdentifier;
@dynamic frameworkType;
@dynamic levelFourDescription;
@dynamic levelFourGroup;




+(LevelFour *)createLevelThreeInContext:(NSManagedObjectContext *)a_context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"LevelFour" inManagedObjectContext:a_context];
}


+(LevelFour *)createLevelFourInContext:(NSManagedObjectContext *)a_context
                withLevelTwoidentifier:(NSNumber *)a_levelTwoIdentifier
                     withFrameworkType:(NSString *)a_frameworkType
              withLevelFourDescription:(NSString *)a_levelFourDescription
                    withLevelFourGroup:(NSString *)a_levelFourGroup
              withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier
               withLevelFourIdentifier:(NSNumber *)a_levelFourIdentifier
{
    LevelFour *_levelFour;
    NSError *_savingError = nil;
    _levelFour = [LevelFour createLevelThreeInContext:a_context];
    
    if(_levelFour == nil){
        NSLog(@"");
    }
    _levelFour.levelTwoIdentifier =a_levelTwoIdentifier;
    _levelFour.frameworkType = a_frameworkType;
    _levelFour.levelFourDescription = a_levelFourDescription;
    _levelFour.levelFourGroup =a_levelFourGroup;
    _levelFour.levelThreeIdentifier=a_levelThreeIdentifier;
    _levelFour.levelFourIdentifier= a_levelFourIdentifier;
    
    if([a_context save:&_savingError]){
        return _levelFour;
    }else{
        return nil;
    }
}

+(NSArray *) fetchLevelTwoInContext:(NSManagedObjectContext *)a_context withLevelTwoIdentifier:(NSNumber *)a_LevelTwoIdentifier withFrameWork:(NSString *)a_framework{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoIdentifier = [NSPredicate predicateWithFormat:@"levelTwoIdentifier =%@",a_LevelTwoIdentifier];
    NSPredicate *levelTwoFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelTwoIdentifier,levelTwoFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
    {
        return results;
    }
    return nil;
}
+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_LevelThreeIdentifier withFrameWork:(NSString *)a_framework{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelThreeIdentifier = [NSPredicate predicateWithFormat:@"levelThreeIdentifier = %@",a_LevelThreeIdentifier];
    NSPredicate *levelThreeFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelThreeIdentifier,levelThreeFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
    {
        return results;
    }
    return nil;
}

+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withlevelFourIdentifier:(NSNumber *)a_levelFourIdentifier withFrameWork:(NSString *)a_framework{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelFourIdentifier = [NSPredicate predicateWithFormat:@"levelFourIdentifier =%@",a_levelFourIdentifier];
    NSPredicate *levelFourFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@ ",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelFourIdentifier,levelFourFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
    {
        return results;
    }
    return nil;
}

+(NSArray *) fetchLevelFourInContext:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework{

    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
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
