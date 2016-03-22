//
//  EcatAspect.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatAspect.h"

@implementation EcatAspect


@dynamic levelOneIdentifier;
@dynamic levelTwoDescription;
@dynamic levelTwoIdentifier;
@dynamic frameworkType;


+(EcatAspect *)createEcatAspectInContext:(NSManagedObjectContext *)a_context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"EcatAspect" inManagedObjectContext:a_context];
}

+ (EcatAspect *)createEcatAspectInContext:(NSManagedObjectContext *)a_context
                   withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
                   withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier
                  withlevelTwoDescription:(NSString *)a_levelTwoDescription
                        withFrameWorkType:(NSString *)a_frameworkType{

    EcatAspect *_ecatAspect;
    NSError *_savingError = nil;
    _ecatAspect = [EcatAspect createEcatAspectInContext:a_context];
    if(_ecatAspect == nil){
        NSLog(@"");
    }
    _ecatAspect.levelOneIdentifier =a_levelOneIdentifier;
    _ecatAspect.frameworkType = a_frameworkType;
    _ecatAspect.levelTwoDescription = a_levelTwoDescription;
    _ecatAspect.levelTwoIdentifier=a_levelTwoIdentifier;

    if([a_context save:&_savingError]){
        return _ecatAspect;
    }else{
        return nil;
    }
}

+(NSArray *)fetchEcatAspectInContext:(NSManagedObjectContext *)a_context withLevelOneIdentifier:(NSNumber *)a_levelOneIdentifier withFramework:(NSString *)a_framework{
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

+(NSArray *)fetchEcatAspectInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework{

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoIdentifier = [NSPredicate predicateWithFormat:@"levelTwoIdentifier = %@",a_levelTwoidentifier];
    NSPredicate *levelTwoFramework = [NSPredicate predicateWithFormat:@"frameworkType =%@",a_framework];
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
