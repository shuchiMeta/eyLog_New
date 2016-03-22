//
//  Age.m
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Age.h"


@implementation Age

@dynamic ageIdentifier;
@dynamic ageStart;
@dynamic shortDesc;
@dynamic ageEnd;
@dynamic ageDesc;
@dynamic aspectIdentifier;
@dynamic frameworkType;



+ (Age *) createAgeInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Age"
                                         inManagedObjectContext:a_context];
}



+ (Age *) createAgeInContext:(NSManagedObjectContext *)a_context
                     withAgeIdentifier:(NSNumber *)a_ageIdentifier
                       withAgeStart:(NSNumber *)a_ageStart
                           withShortDesc:(NSString *)a_shortDesc
                           withAgeEnd:(NSNumber *)a_ageEnd
                        withFrameworkType:(NSString *)a_frameworkType
                           withAgeDesc:(NSString *)a_ageDesc
                  withAspectIdentifier:(NSNumber *)a_aspectIdentifier
{
    Age *_age;
    NSError *_savingError = nil;
    _age = [Age createAgeInContext:a_context];
    
    if(_age == nil)
    {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _age.ageIdentifier = a_ageIdentifier;
    _age.ageStart = a_ageStart;
    _age.ageDesc = a_ageDesc;
    _age.shortDesc=a_shortDesc;
    _age.frameworkType=a_frameworkType;
    _age.ageEnd=a_ageEnd;
    _age.aspectIdentifier=a_aspectIdentifier;
    
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return _age;
    }
    else
    {
        //Saved failed
        // NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_age level]);
        return nil;
    }
}
+(NSArray *) fetchALLAgeInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"aspectIdentifier = %@",a_aspectIdentifier];
//    NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAgeIdentifier:(NSNumber *)a_ageIdentifier withFrameWork:(NSString *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"ageIdentifier = %@",a_ageIdentifier];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"frameworkType = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAgeStart:(NSNumber *)a_aspectIdentifier withAgeEnd:(NSNumber *)a_framework
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *practitionerId=[NSPredicate predicateWithFormat:@"ageStart = %@",a_aspectIdentifier];
    NSPredicate *childId=[NSPredicate predicateWithFormat:@"ageEnd = %@",a_framework];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerId,childId]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;

}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ageIdentifier forKey:@"ageIdentifier"];
    [mutableDict setValue:self.ageStart forKey:@"ageStart"];
    [mutableDict setValue:self.shortDesc forKey:@"shortDesc"];
    [mutableDict setValue:self.ageEnd forKey:@"ageEnd"];
    [mutableDict setValue:self.ageDesc forKey:@"ageDesc"];
    [mutableDict setValue:self.aspectIdentifier forKey:@"aspectIdentifier"];
    [mutableDict setValue:self.frameworkType forKey:@"frameworkType"];
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
