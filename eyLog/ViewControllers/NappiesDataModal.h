//
//  NappiesDataModal.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NappiesDataModal : NSObject

@property (nonatomic, strong) NSString *strWhen;
@property (nonatomic, assign) BOOL nappyRash;
@property (nonatomic, assign) BOOL creamApplied;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSDate *date_When;
@property (nonatomic, assign) BOOL nappies_visible;
@property (nonatomic, assign) NSString *age_group_nappies;
@property(nonatomic,strong)NSString *age_group_nappies_start;
@property(nonatomic,strong)NSString *aage_group_nappies_end;

@end
