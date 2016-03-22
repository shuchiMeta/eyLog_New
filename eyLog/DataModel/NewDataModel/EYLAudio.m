//
//  EYLAudio.m
//  eyLog
//
//  Created by Shivank Agarwal on 25/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLAudio.h"
#import "AppDelegate.h"

@implementation EYLAudio

-(void)createAudioInContext:(NSManagedObjectContext *)context{
    [Audio createAudioInContext:context withName:self.name withPath:self.path withIsDeleted:self.isDeleted];
}
-(void)deleteAudio:(NSArray *)objects{
    
    for (EYLAudio * eylAudio in objects) {
        NSArray * array = [Audio fetchALLAudioInContext:[AppDelegate context] withName:eylAudio.name];
        [Audio deleteAudiosInContext:[AppDelegate context] withObject:array];
    }
}
@end
