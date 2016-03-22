//
//  EcatStatement.m
//  eyLog
//
//  Created by Arpan Dixit on 12/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EcatStatement.h"

@implementation EcatStatement


@dynamic levelThreeDescription;
@dynamic levelThreeIdentifier;
@dynamic levelTwoIdentifier;
@dynamic frameworkType;

+(EcatStatement *)createEcatStatementInContext:(NSManagedObjectContext *)a_context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"EcatStatement" inManagedObjectContext:a_context];
}

+ (EcatStatement *)createEcatStatementInContext:(NSManagedObjectContext *)a_context
                 withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier
                   withLevelTwoIdentifier:(NSNumber *)a_levelTwoIdentifier
                withlevelThreeDescription:(NSString *)a_levelThreeDescription
                        withFrameWorkType:(NSString *)a_frameworkType{
    EcatStatement *_ecatStatement;
    NSError *_savingError = nil;
    _ecatStatement = [EcatStatement createEcatStatementInContext:a_context];
    if(_ecatStatement == nil){
        NSLog(@"");
    }
    _ecatStatement.levelTwoIdentifier =a_levelTwoIdentifier;
    _ecatStatement.frameworkType = a_frameworkType;
    _ecatStatement.levelThreeDescription = a_levelThreeDescription;
    _ecatStatement.levelThreeIdentifier=a_levelThreeIdentifier;

    if([a_context save:&_savingError]){
        return _ecatStatement;
    }else{
        return nil;
    }
}

+(NSArray *)fetchEcatStatementInContext:(NSManagedObjectContext *)a_context withlevelTwoIdentifier:(NSNumber *)a_levelTwoidentifier withFramework:(NSString *)a_framework{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoIdentifier = [NSPredicate predicateWithFormat:@"levelTwoIdentifier = %@",a_levelTwoidentifier];
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

+(NSArray *)fetchEcatStatementInContext:(NSManagedObjectContext *)a_context withLevelThreeIdentifier:(NSNumber *)a_levelThreeIdentifier withFramework:(NSString *)a_framework{

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelThreeIdentifier = [NSPredicate predicateWithFormat:@"levelThreeIdentifier = %@ ",a_levelThreeIdentifier];
    NSPredicate *levelTwoFramework = [NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelThreeIdentifier,levelTwoFramework]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count)
    {
        return results;
    }
    return nil;

}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.levelThreeDescription forKey:@"levelThreeDescription"];
    [mutableDict setValue:self.levelThreeIdentifier forKey:@"levelThreeIdentifier"];
    [mutableDict setValue:self.levelTwoIdentifier forKey:@"levelTwoIdentifier"];
    [mutableDict setValue:self.frameworkType forKey:@""];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
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
