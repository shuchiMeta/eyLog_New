//
//  EYLAudio.h
//  eyLog
//
//  Created by Shivank Agarwal on 25/01/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio.h"

@interface EYLAudio : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * path;
@property (nonatomic, assign) BOOL isDeleted;

-(void)createAudioInContext:(NSManagedObjectContext *)context;
-(void)deleteAudio:(NSArray *)objects;

@end
