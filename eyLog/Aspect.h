//
//  Aspect.h
//  eyLog
//
//  Created by Qss on 11/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Aspect : NSManagedObject

@property (nonatomic, retain) NSNumber * aspectIdentifier;
@property (nonatomic, retain) NSString * aspectDesc;
@property (nonatomic, retain) NSString * shortDesc;
@property (nonatomic, retain) NSString * statements;
@property (nonatomic, retain) NSNumber * areaIdentifier;
@property (nonatomic, retain) NSString * frameworkType;

+ (Aspect *) createAspectInContext:(NSManagedObjectContext *)a_context
              withAspectIdentifier:(NSNumber *)a_aspectIdentifier
                withAreaIdentifier:(NSNumber *)a_areaIdentifier
                    withAspectDesc:(NSString *)a_aspectDesc
                    withStatements:(NSString *)a_statements
                 withFrameworkType:(NSString *)a_frameworkType;
+(NSArray *) fetchAspectInContext:(NSManagedObjectContext *)a_context withAreaIdentifier:(NSNumber *)a_areaIdentifier withFrameWork:(NSString *)a_framework;

+(NSArray *) fetchAspectInContext:(NSManagedObjectContext *)a_context withAspectIdentifier:(NSNumber *)a_aspectIdentifier withFrameWork:(NSString *)a_framework;
+(BOOL)deleteAllHistoryRecords:(NSManagedObjectContext *)a_context withFrameWork:(NSString *)a_framework;
@end
