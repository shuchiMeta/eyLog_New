//
//  Age.h
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Age : NSManagedObject

@property (nonatomic, retain) NSNumber * ageIdentifier;
@property (nonatomic, retain) NSNumber * ageStart;
@property (nonatomic, retain) NSString * shortDesc;
@property (nonatomic, retain) NSNumber * ageEnd;
@property (nonatomic, retain) NSString * ageDesc;
@property (nonatomic, retain) NSNumber * aspectIdentifier;
@property (nonatomic, retain) NSString * frameworkType;

+ (Age *) createAgeInContext:(NSManagedObjectContext *)a_context
           withAgeIdentifier:(NSNumber *)a_ageIdentifier
                withAgeStart:(NSNumber *)a_ageStart
               withShortDesc:(NSString *)a_shortDesc
                  withAgeEnd:(NSNumber *)a_ageEnd
           withFrameworkType:(NSString *)a_frameworkType
                 withAgeDesc:(NSString *)a_ageDesc
        withAspectIdentifier:(NSNumber *)a_aspectIdentifier;

+(NSArray *) fetchALLAgeInContext:(NSManagedObjectContext *)a_context;

+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAgeIdentifier:(NSNumber *)a_ageIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchAgeInContext:(NSManagedObjectContext *)a_context withAgeStart:(NSNumber *)a_aspectIdentifier withAgeEnd:(NSNumber *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;

@end
