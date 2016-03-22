//
//  RegistryDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 18/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistryDataModal : NSObject


@property (nonatomic, strong) NSString *strCameAt;
@property (nonatomic, strong) NSString *strLeftAt;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic ,strong) NSString *clientTimeStamp;


@property (nonatomic, strong) NSDate *date_CameAt;
@property (nonatomic, strong) NSDate *date_LeftAt;

@end
