//
//  NotificationModel.m
//  eyLog
//
//  Created by Shuchi on 10/02/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel



- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.dateStr forKey:@"dateStr"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.tableID forKey:@"tableID"];
    [encoder encodeObject:self.childID forKey:@"childID"];
    [encoder encodeObject:[NSNumber numberWithBool:_isRead] forKey:@"isRead"];
    [encoder encodeObject:self.notificationId forKey:@"notificationId"];
      
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.dateStr = [decoder decodeObjectForKey:@"dateStr"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.tableID = [decoder decodeObjectForKey:@"tableID"];
        self.childID = [decoder decodeObjectForKey:@"childID"];
        self.isRead=[[decoder decodeObjectForKey:@"isRead"] boolValue];
        self.notificationId= [decoder decodeObjectForKey:@"notificationId"];
               
    }
    return self;
}@end
