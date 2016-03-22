//
//  Comments.h
//  eyLog
//
//  Created by Shuchi on 11/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
@property(strong,nonatomic)NSString *comment;
@property(strong,nonatomic)NSString *commentSender;
@property(strong,nonatomic)NSNumber *comment_id;
@property(strong,nonatomic)NSString *date_time;
@property(strong,nonatomic)NSNumber *eylog_user_id;
@property(strong,nonatomic)NSNumber *last_modified_by;
@property(strong,nonatomic)NSString *last_modified_date;
@property(strong,nonatomic)NSNumber *observation_id;
@property(strong,nonatomic)NSNumber *user_id;
@property(strong,nonatomic)NSString *user_role;


@end
