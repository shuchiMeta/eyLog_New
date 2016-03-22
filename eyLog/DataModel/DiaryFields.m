//
//  DiaryFields.m
//
//
//  Created by Arpan Dixit on 25/06/15.
//
//

#import "DiaryFields.h"


@implementation DiaryFields

@dynamic keyName;
@dynamic keyValue;
@dynamic relationship;

+ (instancetype) createEYL_DiaryFieldsInContext:(NSManagedObjectContext *) context
{

    return [NSEntityDescription insertNewObjectForEntityForName:@"DiaryFields"
                                         inManagedObjectContext:context];
}

@end
