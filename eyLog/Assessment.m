//
//  Assessment.m
//  eyLog
//
//  Created by Qss on 11/5/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Assessment.h"


@implementation Assessment

@dynamic ageEnd;
@dynamic ageStart;
@dynamic color;
@dynamic levelDescription;
@dynamic levelId;
@dynamic levelValue;
@dynamic weightage;



+ (Assessment *) createAssessmentInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Assessment"
                                         inManagedObjectContext:a_context];
}

+ (Assessment *) createAssessmentInContext:(NSManagedObjectContext *)a_context
                                   withAgeEnd:(NSNumber *)a_ageEnd
                                 withAgeStart:(NSNumber *)a_ageStart
                                    withColor:(NSString *)a_color
                         withLevelDescription:(NSString *)a_levelDescription
                                  withLevelId:(NSNumber *)a_levelId
                               withLevelValue:(NSNumber *)a_levelValue
                                withWeightage:(NSNumber *)a_weightage
{
    Assessment *_assessment;
    NSError *_savingError = nil;
    
    
    _assessment = [Assessment createAssessmentInContext:a_context];
    if(_assessment == nil)
    {
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _assessment.ageEnd = a_ageEnd;
    _assessment.ageStart = a_ageStart;
    _assessment.color = a_color;
    _assessment.levelDescription=a_levelDescription;
    _assessment.levelId=a_levelId;
    _assessment.levelValue=a_levelValue;
    _assessment.weightage=a_weightage;
    
    if([a_context save:&_savingError])
    {
        NSLog(@"Assessment successfully saved");
        return _assessment;
    }
    else
    {
        //Saved failed
        NSLog(@"Assessment failed to save");
        return nil;
    }
}

+(NSArray *) fetchAllAssessmentInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withStartAge:(NSNumber *)a_ageStart withEndAge:(NSNumber *)a_ageEnd
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *ageStart=[NSPredicate predicateWithFormat:@"ageStart = %@",a_ageStart];
    NSPredicate *ageEnd=[NSPredicate predicateWithFormat:@"ageEnd = %@",a_ageEnd];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[ageStart,ageEnd]]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"levelId" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchAssessmentInContext:(NSManagedObjectContext *)a_context withLevelValue:(NSNumber *)a_levelValue
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *ageStart=[NSPredicate predicateWithFormat:@"levelValue = %@",a_levelValue];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[ageStart]]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context 
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
  
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
