//
//  Child.m
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Child.h"

#import "EYL_AppData.h"
#import "AppDelegate.h"


@implementation Child

@dynamic childId;
@dynamic dietaryRequirment;
@dynamic dob;
@dynamic englistAdditionalLanguage;
@dynamic ethnicity;
@dynamic firstName;
@dynamic gender;
@dynamic groupId;
@dynamic groupName;
@dynamic language;
@dynamic lastName;
@dynamic middleName;
@dynamic nationality;
@dynamic practitionerId;
@dynamic religion;
@dynamic shareTwoYearReport;
@dynamic slt;
@dynamic specialEducationalNeeds;
@dynamic startDate;
@dynamic photo;
@dynamic twoYearFunding;
@dynamic ageMonths;
@dynamic inTime;
@dynamic outTime;
@dynamic currentDate;
@dynamic registryArray;
@dynamic pupilPremium;




+ (Child *) createChildInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Child"
                                         inManagedObjectContext:a_context];
}




+ (Child *) createChildInContext:(NSManagedObjectContext *)a_context
                       withChild:(NSNumber *)a_childId
           withDietaryRequirment:(NSString *)a_dietaryRequirment
                         withDob:(NSDate *)a_dob
   withEnglishAdditionalLanguage:(NSNumber *)a_englishAdditionalLanguage
                   withEthnicity:(NSNumber *)a_Ethnicity
                   withFirstName:(NSString *)a_firstName
                      withGender:(NSString *)a_gender
                     withGroupId:(NSNumber *)a_groupId
                   withGroupName:(NSString *)a_groupName
                    withLanguage:(NSString *)a_language
                    withLastName:(NSString *)a_lastName
                  withMiddleName:(NSString *)a_middleName
                 withNationality:(NSString *)a_nationality
              withPractitionerId:(NSNumber *)a_practitionerId
                    withReligion:(NSString *)a_religion
          withShareTwoYearReport:(NSNumber *)a_shareTwoYearReport
                         withSLt:(NSNumber *)a_slt
      withSpecialEductionalNeeds:(NSNumber *)a_specialEducationalNeeds
                   withStartDate:(NSDate *)a_startDate
                       withPhoto:(NSString *)a_photo
              withTwoYearFunding:(NSNumber *)a_twoYearFunding
                   withAgeMonths:(NSString *)age_months
                      withInTime:(NSString *)inTime
                     withOutTime:(NSString *)outTime
                    withCurrentDate:(NSString *)date
                   registryArray:(NSData*)registryArray
                    pupilPremium:(NSNumber *)pupilPremium
                    withphotoUrl:(NSString *)photourl

{
 
    Child *_child;
    NSError *_savingError = nil;
    
    _child = [Child createChildInContext:a_context];
    if(_child == nil) {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }
    _child.childId=a_childId;
    _child.dietaryRequirment=a_dietaryRequirment;
    _child.dob=a_dob;
    _child.englistAdditionalLanguage=a_englishAdditionalLanguage;
    _child.ethnicity=a_Ethnicity;
    _child.firstName=a_firstName;
    _child.gender=a_gender;
    _child.groupId=a_groupId;
    _child.groupName=a_groupName;
    _child.language=a_language;
    _child.lastName=a_lastName;
    _child.middleName=a_middleName;
    _child.nationality=a_nationality;
    _child.practitionerId=a_practitionerId;
    _child.religion=a_religion;
    _child.shareTwoYearReport=a_shareTwoYearReport;
    _child.slt=a_slt;
    _child.specialEducationalNeeds=a_specialEducationalNeeds;
    _child.startDate=a_startDate;
    _child.photo=a_photo;
    _child.twoYearFunding = a_twoYearFunding;
    _child.ageMonths = age_months;
        ;
    _child.childInoutDataWithDateAndChild=[NSMutableDictionary new];
    _child.pupilPremium=pupilPremium;
    _child.photourl=photourl;
    
    
    if(registryArray.length==0)
    {
        registryArray=[NSData new];
        
    }
    _child.registryArray=registryArray;
    
    _child.currentDate=date;
      
    if(inTime.length==0)
    {
        inTime=@"00:00";
           
    }
    if(outTime.length==0)
    {
        outTime=@"00:00";
        
    }
    _child.inTime=inTime;
    _child.outTime=outTime;
    _child.registryStatus=nil;
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Child : Saved child with child Id %@", [_child childId]);
        return _child;
    }
    else
    {
        //Saved failed
        NSLog(@"Child : Saved child with child Id %@", [_child childId]);
        return nil;
    }
}

+(NSArray *) fetchALLChildInContext:(NSManagedObjectContext *)a_context
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context];
    [request setEntity:entity];
    NSError *error;
    NSArray *results = [a_context executeFetchRequest:request error:&error];
    
//    NSFetchRequest *request=[[NSFetchRequest alloc]init];
//    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
//    NSError *fetchError=nil;
//    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withPractitionerGroupName:(NSString *)practitionerGroupName
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
  //  [request setPredicate:[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"groupId = %@",a_practitionerId]];
    //groupId
    NSPredicate *practitionerIdPredicate=[NSPredicate predicateWithFormat:@"groupId = %@",a_practitionerId];
     NSPredicate *groupPredicate=[NSPredicate predicateWithFormat:@"groupName = %@",practitionerGroupName];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[practitionerIdPredicate,groupPredicate]]];

    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}


+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId withKeyChild:(NSString *)keyChild
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"practitionerId = %@",a_practitionerId]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchChildInContext:(NSManagedObjectContext *)a_context withChildId:(NSNumber *)a_childId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"childId = %@",a_childId]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(BOOL) deleteChildInContext:(NSManagedObjectContext *)a_context
{
    NSError *_savingError = nil;
    NSArray *observation = [Child fetchALLChildInContext:a_context];
    
    if (observation.count > 0) {
        for (Child *child in observation) {
            [a_context deleteObject:child];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Practitioners : Successfully Deleted Children.");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"Practitioners : Deleting Children Failed.");
        return false;
    }
}

+(Child *)updateRegistryArrayForChild :(NSNumber *) childID :(NSMutableArray *)registryArray forContext:(NSManagedObjectContext *)a_context
{
    
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Child"];
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childId=%@",childID];
    
    [request setPredicate:childIDPredicate];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
       Child *obj = [results lastObject];
    if (registryArray != nil && registryArray.count > 0)
    {
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:registryArray];
        obj.registryArray = arrayData;
    }
    
    NSError *_savingError = nil;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return obj;
    }
    return nil;

}
+(Child *)updateDictionaryDataForInoutTime:(NSMutableDictionary*)mutaDict  : (NSNumber *) childID forContext :(NSManagedObjectContext *) a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Child"];
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childId=%@",childID];
    
    [request setPredicate:childIDPredicate];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    
    Child *obj = [results lastObject];
    obj.childInoutDataWithDateAndChild = [mutaDict copy];
    NSError *_savingError = nil;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return obj;
    }
    return nil;


}
// NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Child"];


+(Child *) updateChild : (NSNumber *) childID inTime :(NSString *) inTime andOutTime :(NSString *) outTime andRegistryStatus :(NSNumber *)registryStatus forContext :(NSManagedObjectContext *) a_context
{
    
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Child"];
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childId=%@",childID];

    [request setPredicate:childIDPredicate];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    Child *obj = [results lastObject];
    if(inTime.length==0)
    {
        inTime=@"00:00";
        
    }
    if(outTime.length==0)
    {
        outTime=@"00:00";
        
    }
    if(registryStatus !=nil ||[registryStatus integerValue]!=0)
    {
        obj.registryStatus=registryStatus;
        
    }
    else{
        obj.registryStatus=nil;
        
    }

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    for (NSEntityDescription* entityDescription in  appDelegate.managedObjectModel) {
//        if ([[entityDescription propertiesByName] objectForKey:@"inTime"] == nil||[[entityDescription propertiesByName] objectForKey:@"outTime"] == nil) {
//            
//            
//          [Child createChildInContext:[AppDelegate context] withChild:obj.childId withDietaryRequirment:obj.dietaryRequirment withDob:obj.dob withEnglishAdditionalLanguage:obj.englistAdditionalLanguage withEthnicity:obj.ethnicity withFirstName:obj.firstName withGender:obj.gender withGroupId:obj.groupId withGroupName:obj.groupName withLanguage:obj.language withLastName:obj.lastName withMiddleName:obj.middleName withNationality:obj.nationality withPractitionerId:obj.practitionerId withReligion:obj.religion withShareTwoYearReport:obj.shareTwoYearReport withSLt:obj.slt withSpecialEductionalNeeds:obj.specialEducationalNeeds withStartDate:obj.startDate withPhoto:obj.photo withTwoYearFunding:obj.twoYearFunding withAgeMonths:obj.ageMonths withInTime:inTime withOutTime:outTime withCurrentDate:obj.currentDate registryArray:[NSData new]];
//              [a_context deleteObject:obj];
//            // objects of this entity support the property you're looking for
//        }
//        
//    }
//    
//   [request setPredicate:childIDPredicate];
//    NSError *fetchErrorNew=nil;
//    NSArray *resultsArray = [a_context executeFetchRequest:request error:&fetchErrorNew];
//    
//    Child *objNew = [resultsArray lastObject];
    obj.inTime = inTime;
    obj.outTime=outTime;
    
    NSError *_savingError = nil;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return obj;
    }
    return nil;
}

+(NSString *) fetchALLChildandUpdateINOUTTime:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    
    NSString *theCurrentDate =[[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];

    if (!results.count)
        return @"No Record Found";
    
    for (int i=0; i<[results count]; i++)
    {
        Child *obj = [results objectAtIndex:i];
        
        if ([obj.currentDate isEqualToString:theCurrentDate])
            return @"Records Already Updated";
        
        [obj setInTime:@"00:00"];
        [obj setOutTime:@"00:00"];
        [obj setRegistryStatus:nil];
        
        [obj setCurrentDate:theCurrentDate];
        
        obj= nil;
    }
    
    NSError *_savingError = nil;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        //return obj;
        
        NSLog(@"All Record Updated");
        return @"Records Updated Successfully";
    }
    return nil;
}




+(Child *)withChild:(NSNumber *)a_childId
withDietaryRequirment:(NSString *)a_dietaryRequirment
             withDob:(NSDate *)a_dob
withEnglishAdditionalLanguage:(NSNumber *)a_englishAdditionalLanguage
       withEthnicity:(NSNumber *)a_Ethnicity
       withFirstName:(NSString *)a_firstName
          withGender:(NSString *)a_gender
         withGroupId:(NSNumber *)a_groupId
       withGroupName:(NSString *)a_groupName
        withLanguage:(NSString *)a_language
        withLastName:(NSString *)a_lastName
      withMiddleName:(NSString *)a_middleName
     withNationality:(NSString *)a_nationality
  withPractitionerId:(NSNumber *)a_practitionerId
        withReligion:(NSString *)a_religion
withShareTwoYearReport:(NSNumber *)a_shareTwoYearReport
             withSLt:(NSNumber *)a_slt
withSpecialEductionalNeeds:(NSNumber *)a_specialEducationalNeeds
       withStartDate:(NSDate *)a_startDate
           withPhoto:(NSString *)a_photo
  withTwoYearFunding:(NSNumber *)a_twoYearFunding
       withAgeMonths:(NSString *)age_months
          withInTime:(NSString *)inTime
         withOutTime:(NSString *)outTime
     withCurrentDate:(NSString *)date
       registryArray:(NSData*)registryArray
        pupilPremium:(NSNumber *)pupilPremium
withPhotoUrl:(NSString *)photourl forContext:(NSManagedObjectContext *)a_context

{
   
   
    NSPredicate *childIDPredicate=[NSPredicate predicateWithFormat:@"childId=%@",a_childId];
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Child"];

    [request setPredicate:childIDPredicate];
    NSError *fetchError=nil;
    NSArray *results = [a_context executeFetchRequest:request error:&fetchError];
    Child *obj = [results lastObject];
    obj.childId=a_childId;
    obj.firstName=a_firstName;
    obj.middleName=a_middleName;
    obj.lastName=a_lastName;
    obj.ethnicity=a_Ethnicity;
    obj.dietaryRequirment=a_dietaryRequirment;
    obj.gender=a_gender;
    obj.dob=a_dob;
    obj.groupId=a_groupId;
    obj.groupName=a_groupName;
    obj.practitionerId=a_practitionerId;
    obj.englistAdditionalLanguage=a_englishAdditionalLanguage;
    obj.specialEducationalNeeds=a_specialEducationalNeeds;
    obj.shareTwoYearReport=a_shareTwoYearReport;
    obj.twoYearFunding=a_twoYearFunding;
    obj.photourl=photourl;
    
   
    
    
    NSError *_savingError = nil;
    if([a_context save:&_savingError])
    {
        //Saved the new practitioner
        return obj;
    }
    return nil;

}



@end
