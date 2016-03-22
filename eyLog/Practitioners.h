//
//  Practitioners.h
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Practitioners : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * allowSubmit;
@property (nonatomic, retain) NSNumber * eylogUserId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSNumber * groupLeader;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * pin;
@property (nonatomic, retain) NSString * userRole;
@property (nonatomic, retain) NSString * photourl;

@property (strong, nonatomic) NSString *name;
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
                                    withPhotoUrl:(NSString *)a_photoUrl;

+(NSArray *) fetchALLPractitionersInContext:(NSManagedObjectContext *)a_context;
+(NSArray *) fetchPractitionersInContext:(NSManagedObjectContext *)a_context withPractitionerId:(NSNumber *)a_practitionerId;
+(BOOL) deletePractitionersInContext:(NSManagedObjectContext *)a_context;

@end