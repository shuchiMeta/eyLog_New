//
//  Audio.h
//  eyLog
//
//  Created by Shivank Agarwal on 25/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Audio : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (assign, nonatomic) BOOL isDelete;

+ (Audio *) createAudioInContext:(NSManagedObjectContext *)a_context
                        withName:(NSString *)a_name
                        withPath:(NSString *)a_path
                   withIsDeleted:(BOOL)isDeleted;
+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context;
+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context withIsDeleted:(BOOL)isDeleted;
+(BOOL) deleteAudiosInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) objects;
+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context withName:(NSString *)name;

@end
