//
//  Nursery.m
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "Nursery.h"


@implementation Nursery

@dynamic nurseryChain;
@dynamic nurseryChainName;
@dynamic nurseryId;
@dynamic nuseryName;



+ (Nursery *) createNurseryInContext:(NSManagedObjectContext *)a_context
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"Nursery"
                                         inManagedObjectContext:a_context];
}



+ (Nursery *) createNurseryInContext:(NSManagedObjectContext *)a_context
                                     withNurseryChain:(NSNumber *)a_nurseryChain
                                 withNurseryChainName:(NSString *)a_nurseryChainName
                                   withNurseryId:(NSNumber *)a_nurseryId
                                    withNurseryName:(NSString *)a_nurseryName
{
    
    Nursery *_nursery;
    NSError *_savingError = nil;
    
    _nursery = [Nursery createNurseryInContext:a_context];
    if(_nursery == nil) {
        //Couldn't create the data base entry
        NSLog(@"Nursery : Couldn't create Nursery in context %s", "");
    }
    _nursery.nurseryChain = a_nurseryChain;
    _nursery.nurseryChainName = a_nurseryChainName;
    _nursery.nurseryId = a_nurseryId;
    _nursery.nuseryName=a_nurseryName;
    
    if( [a_context save:&_savingError] ) {
        //Saved the new nursery
        NSLog(@"Nursery : Saved nursery with Nursery Id %@", [_nursery nurseryId]);
        return _nursery;
    } else {
        //Saved failed
        NSLog(@"Nursery : Saved nursery with Nursery Id %@", [_nursery nurseryId]);
        return nil;
    }
}
@end
