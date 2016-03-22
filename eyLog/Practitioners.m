//
//  Practitioners.m
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Practitioners.h"


@implementation Practitioners

@dynamic active;
@dynamic allowSubmit;
@dynamic eylogUserId;
@dynamic firstName;
@dynamic groupId;
@dynamic groupLeader;
@dynamic groupName;
@dynamic lastName;
@dynamic photo;
@dynamic pin;
@dynamic userRole;
@synthesize name = _name;

+ (Practitioners *) createPractitionersInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Practitioners"
                                         inManagedObjectContext:a_context];
}



+ (Practitioners *) createPractitionersInContext:(NSManagedObjectContext *)a_context
                          withFirstName:(NSString *)a_firstName
                            withGroupId:(NSNumber *)a_groupId
                        withGroupLeader:(NSNumber *)a_groupLeader
                          withGroupName:(NSString *)a_groupName
                           withLastName:(NSString *)a_lastName
                          withPhotoName:(NSString *)a_photoName
                                withPin:(NSString *)a_pin
                           withUserRole:(NSString *)a_userRole
                             withActive:(NSNumber *)a_active
                        withAllowSubmit:(NSNumber *)a_allowSubmit
                        withEylogUserId:(NSNumber *)a_eylogUserId
                         withPhotoUrl:(NSString *)a_photoUrl


{
    Practitioners *_practitioners;
    NSError *_savingError = nil;
    
    _practitioners = [Practitioners createPractitionersInContext:a_context];
    if(_practitioners == nil) {
        //Couldn't create the data base entry
        NSLog(@"Practitioner : Couldn't create Practitioner in context %s", "");
    }
    _practitioners.firstName = a_firstName;
    _practitioners.groupId = a_groupId;
    _practitioners.groupLeader = a_groupLeader;
    _practitioners.groupName=a_groupName;
    _practitioners.lastName=a_lastName;
    _practitioners.photo=a_photoName;
    _practitioners.pin=a_pin;
    _practitioners.userRole=a_userRole;
    _practitioners.active=a_active;
    _practitioners.allowSubmit=a_allowSubmit;
    _practitioners.eylogUserId=a_eylogUserId;
    _practitioners.photourl=a_photoUrl;
    
    
    if( [a_context save:&_savingError] )
    {
        //Saved the new practitioner
        NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_practitioners firstName]);
        return _practitioners;
    }
    else
    {
        //Saved failed
        NSLog(@"Practitioner : Saved practitioner with practitioners Name %@", [_practitioners firstName]);
        return nil;
    }
}


+(NSArray *) fetchALLPractitionersInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(NSArray *) fetchPractitionersInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"eylogUserId = %@",a_practitionerId]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}

+(BOOL) deletePractitionersInContext:(NSManagedObjectContext *)a_context
{
    NSError *_savingError = nil;
    NSArray *observation = [Practitioners fetchALLPractitionersInContext:a_context];
    
    if (observation.count > 0) {
        for (Practitioners *practitioner in observation) {
            [a_context deleteObject:practitioner];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        //Saved the new nursery
        NSLog(@"Practitioners : Successfully Deleted Practitioners.");
        return true;
    } else
    {
        //Saved failed
        NSLog(@"Practitioners : Deleting Practitioners Failed.");
        return false;
    }
}

/*
+ (BOOL) deleteCategory:( *)_practitioners inContext: (NSManagedObjectContext *)_context
{
    NSError *_error = nil;
    
    //notify the database of the delete
    [_context deleteObject:_practitioners];
    
    
    
    //remove the case from the database
    if([_context save:&_error]) {
        return YES;
    }
 else
 {
        NSLog(@"Category - Couldn't Delete The Category Name %@ From The Database", _practitioners.p);
        return NO;
    }
}
*/

- (NSString *)name {
    if (!_name) {
        
        _name = [NSString string];
        if (self.firstName) {
            _name = [_name stringByAppendingString:[self.firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        if (self.lastName) {
            _name = [_name stringByAppendingFormat:@" %@", [self.lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
    return _name;
}


@end
