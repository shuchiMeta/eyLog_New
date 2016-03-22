//
//  Nursery.h
//  eyLog
//
//  Created by Qss on 10/16/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Nursery : NSManagedObject

@property (nonatomic, retain) NSNumber * nurseryChain;
@property (nonatomic, retain) NSString * nurseryChainName;
@property (nonatomic, retain) NSNumber * nurseryId;
@property (nonatomic, retain) NSString * nuseryName;



+ (Nursery *) createNurseryInContext:(NSManagedObjectContext *)a_context
                    withNurseryChain:(NSNumber *)a_nurseryChain
                withNurseryChainName:(NSString *)a_nurseryChainName
                       withNurseryId:(NSNumber *)a_nurseryId
                     withNurseryName:(NSString *)a_nurseryName;
@end
