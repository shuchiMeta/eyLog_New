//
//  NotificationModel.h
//  eyLog
//
//  Created by Shuchi on 10/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *content;
@property(strong,nonatomic) NSString *dateStr;
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSNumber *tableID;
@property(strong,nonatomic)NSNumber *childID;
@property(nonatomic,assign)BOOL isRead;
@property(nonatomic,strong)NSNumber *notificationId;

//@property(strong,nonatomic)NSDate *dateAdded;



@end
