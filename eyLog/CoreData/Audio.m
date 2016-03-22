//
//  Audio.m
//  eyLog
//
//  Created by Shivank Agarwal on 25/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Audio.h"


@implementation Audio

@dynamic name;
@dynamic path;
@dynamic isDelete;

+ (Audio *) createAudioInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Audio"
                                         inManagedObjectContext:a_context];
}




+ (Audio *) createAudioInContext:(NSManagedObjectContext *)a_context
                       withName:(NSString *)a_name
           withPath:(NSString *)a_path
                   withIsDeleted:(BOOL)isDeleted
{
    
    Audio *_audio;
    NSError *_savingError = nil;
    
    _audio = [Audio createAudioInContext:a_context];
    if(_audio == nil) {
        //Couldn't create the data base entry
        NSLog(@"Case : Couldn't create case in context %s", "");
    }
    _audio.name=a_name;
    _audio.path=a_path;
    _audio.isDelete = isDeleted;
    if( [a_context save:&_savingError] )
    {
        //Saved the new nursery
        NSLog(@"Audio : Saved Audio");
        return _audio;
    } else {
        //Saved failed
        return nil;
    }
}

+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context withName:(NSString *)name
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@",name]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(NSArray *) fetchALLAudioInContext:(NSManagedObjectContext *)a_context withIsDeleted:(BOOL)isDeleted
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:a_context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isDelete = %d",isDeleted]];
    NSError *fetchError=nil;
    NSArray *results=[a_context executeFetchRequest:request error:&fetchError];
    if(results.count>0)
        return results;
    return nil;
}
+(BOOL) deleteAudiosInContext:(NSManagedObjectContext *)a_context withObject:(NSArray *) objects
{
    NSError *_savingError = nil;
    if (objects.count > 0) {
        for (Audio *audio in objects) {
            
            [a_context deleteObject:audio];
        }
    }
    
    if( [a_context save:&_savingError])
    {
        return true;
    } else
    {
        return false;
    }
}

@end
