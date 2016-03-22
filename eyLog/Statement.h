//
//  Statement.h
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Statement : NSManagedObject

@property (nonatomic, retain) NSNumber * ageIdentifier;
@property (nonatomic, retain) NSString * frameworkType;
@property (nonatomic, retain) NSString * statementDesc;
@property (nonatomic, retain) NSString * shortDesc;
@property (nonatomic, retain) NSNumber * statementIdentifier;
@property (nonatomic, retain) NSNumber * aspectIdentifier;


+ (Statement *) createStatementInContext:(NSManagedObjectContext *)a_context
                       withAgeIdentifier:(NSNumber *)a_ageIdentifier
                       withFrameworkType:(NSString *)a_frameworkType
                       withStatementDesc:(NSString *)a_statementDesc
                           withShortDesc:(NSString *)a_shortDesc
                 withstatementIdentifier:(NSNumber *)a_statementIdentifier
                    withAspectIdentifier:(NSNumber *)a_aspectIdentifier;

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withAgeIdentifier:(NSNumber *)a_ageIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withStatementIdentifier:(NSNumber *)a_statementIdentifier withFrameWork:(NSString *)a_framework;
+(NSArray *) fetchStatementInContext:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
