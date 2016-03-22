//
//  CfeAssesmentDatabase.m
//  eyLog
//
//  Created by shuchi on 04/09/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CfeAssesmentDatabase.h"

@implementation CfeAssesmentDataBase

@dynamic levelId;
@dynamic levelDescription;
@synthesize color = _color;
@synthesize assesmentCfeColor = _assesmentCfeColor;

+(CfeAssesmentDataBase *)createCfeAssesmentInContext:(NSManagedObjectContext *)a_context{
    return [NSEntityDescription insertNewObjectForEntityForName:@"CfeAssesmentDataBase" inManagedObjectContext:a_context];
}

+(CfeAssesmentDataBase *)createCfeAssessmentInContext:(NSManagedObjectContext *)a_context withLevelId:(NSNumber *)a_levelId withLevelDescription:(NSString *)a_levelDescription withColor:(NSString *)a_color{
    CfeAssesmentDataBase *_assesment;
    NSError *_savingError = nil;
    _assesment = [CfeAssesmentDataBase createCfeAssesmentInContext:a_context];
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
+(NSArray *) fetchAllCfeAssessmentInContext:(NSManagedObjectContext *)a_context{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0){
        return results;
    }
    return nil;
}
+(NSArray *)fetchCfeAssessmentInContext:(NSManagedObjectContext *)a_context withlevelId:(NSNumber *)a_levelId{
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
-(UIColor *)assesmentCfeColor{
    
    NSArray *colors = [self.color componentsSeparatedByString:@","];
    _assesmentCfeColor = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
    return _assesmentCfeColor;
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
