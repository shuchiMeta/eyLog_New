//
//  IHadMyBottleDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHadMyBottleDataModal : NSObject

@property (nonatomic, retain) NSString *strDateAt;
@property (nonatomic, retain) NSString *strDrank;
@property (nonatomic, assign) BOOL i_had_my_bottle_visible;
@property (nonatomic, assign) NSString *age_group_i_had_my_bottle;
@property(nonatomic,strong)NSString *age_group_i_had_my_bottle_start;
@property(nonatomic,strong)NSString *age_group_i_had_my_bottle_end;

@property (nonatomic, strong) NSDate *date_DateAt;

@end
