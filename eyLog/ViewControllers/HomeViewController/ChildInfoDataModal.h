//
//  ChildInfoDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 22/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildInfoDataModal : NSObject

@property (nonatomic, strong) NSNumber *childId;
//@property (nonatomic, strong) NSString *strDescription;
@property(nonatomic,strong)NSMutableArray *registryArray;

+(instancetype) initWithChildID :(NSNumber *)chidID andRegistryArray:(NSMutableArray *)registryArray;
@end
