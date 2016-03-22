//
//  MontessoriAssesmentDataBase.m
//  eyLog
//
//  Created by Shobhit on 27/04/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "MontessoriAssesmentDataBase.h"


@implementation MontessoriAssesmentDataBase

@dynamic levelId;
@dynamic levelDescription;
@synthesize color = _color;
@synthesize assesmentColor = _assesmentColor;

+(MontessoriAssesmentDataBase *)createMontessoriAssesmentInContext:(NSManagedObjectContext *)a_context{
    return [NSEntityDescription insertNewObjectForEntityForName:@"MontessoriAssesmentDataBase" inManagedObjectContext:a_context];
}

+(MontessoriAssesmentDataBase *)createMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context withLevelId:(NSNumber *)a_levelId withLevelDescription:(NSString *)a_levelDescription withColor:(NSString *)a_color{
      MontessoriAssesmentDataBase *_assesment;
    NSError *_savingError = nil;
    _assesment = [MontessoriAssesmentDataBase createMontessoriAssesmentInContext:a_context];
    if(_assesment == nil){
        NSLog(@"");
    }
    _assesment.levelId=a_levelId;
    _assesment.levelDescription= a_levelDescription;
    _assesment.color=a_color;
    
    if([a_context save:&_savingError]){
        NSLog(@"Assesment Successfully Saved");
        return nil;
    }
    else{
        NSLog(@"Assesment Failed To Save");
        return nil;
    }
}
+(NSArray *) fetchAllMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0){
        return results;
    }
    return nil;
}
+(NSArray *)fetchMontessoriAssessmentInContext:(NSManagedObjectContext *)a_context withlevelId:(NSNumber *)a_levelId{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSPredicate *levelTwoIdentifier = [NSPredicate predicateWithFormat:@"levelId = %@",a_levelId];
    [request setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[levelTwoIdentifier]]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count > 0)
    {
        return results;
    }
    return nil;
}
-(UIColor *)assesmentColor{
    NSArray *colors = [self.color componentsSeparatedByString:@","];
    _assesmentColor = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
    return _assesmentColor;
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
