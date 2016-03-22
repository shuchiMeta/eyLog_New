//
//  ChildInfoDataModal.m
//  eyLog
//
//  Created by Arpan Dixit on 22/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChildInfoDataModal.h"

@implementation ChildInfoDataModal

+(instancetype) initWithChildID :(NSNumber *)chidID andRegistryArray:(NSMutableArray *)registryArray;
{
    ChildInfoDataModal *obj = [ChildInfoDataModal new];
    obj.childId=chidID;
    obj.registryArray=registryArray;
    
    
    return obj;
}

@end
