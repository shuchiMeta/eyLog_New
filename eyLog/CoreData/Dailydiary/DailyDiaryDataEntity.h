//
//  DailyDiaryDataEntity.h
//  eyLog
//
//  Created by Shuchi on 02/03/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface DailyDiaryDataEntity : NSManagedObject


@property(retain,nonatomic)NSNumber *uid;
@property(retain,nonatomic)NSData *jsonDict;
@property(retain,nonatomic)NSString *dateStr;
@property(retain,nonatomic)NSDate *date;
@property(retain,nonatomic)NSNumber *childId;


// Insert code here to declare functionality of your managed object subclass

@end


