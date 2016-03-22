//
//  CustomBarButton_InOut.m
//  eyLog
//
//  Created by Arpan Dixit on 11/08/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "CustomBarButton_InOut.h"
#import "EYL_AppData.h"
#import "ChildInOutTime.h"
#import "EYL_AppData.h"
#import "AppDelegate.h"



@implementation CustomBarButton_InOut

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(IBAction)btnInOutAction:(UIButton *)sender
{
    
    //[self.childDelegate updateContext];
    EYL_AppData *obj = [EYL_AppData sharedEYL_AppData];
    
    if (self.btnTag==101)
    {
        // IN Button Tapped.
        obj.child_CameIN = [obj getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
        [self.childDelegate setTimeForButtonWithTag:101 andValue:obj.child_CameIN];
    }
    else
    {
        // OUT Button Tapped
        obj.child_LeftAT = [obj getMinuteAndHoursFromNSDateofSameLocale:[NSDate date]];
        [self.childDelegate setTimeForButtonWithTag:102 andValue:obj.child_LeftAT];
    }
    
    
//    NSString *currentDate = [[EYL_AppData sharedEYL_AppData] getDateFromNSDate:[NSDate date]];
//    int num = [ChildInOutTime isChildExist:[EYL_AppData sharedEYL_AppData].selectedChild withDate:currentDate context:[AppDelegate context]];
//    
//    if (num)
//    {
//        // Delete the existing record and insert the new values
//        //[ChildInOutTime deleteRecordForChild:children.childId withDate:currentDate andDetails:dict andContext:context];
//        BOOL isUpdated=[ChildInOutTime updateRecord:[AppDelegate context] withChildID:[EYL_AppData sharedEYL_AppData].selectedChild withDate:currentDate withInTimeValue:[[EYL_AppData sharedEYL_AppData] getMinuteAndHoursFromNSDate:[NSDate date]] withOutTimeValue:nil withUploadFlag:[NSNumber numberWithInt:0]];
//        NSLog(@"%hhd",isUpdated);
//    }
//    else
//    {
//        NSString *uniqueTabletOIID = [NSString stringWithFormat: @"%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
//        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[EYL_AppData sharedEYL_AppData].selectedChild,@"childid",
//                                      currentDate,@"date",
//                                      [[EYL_AppData sharedEYL_AppData] getMinuteAndHoursFromNSDate:[NSDate date]],@"intime",
//                                      @"00:00",@"outtime",
//                                      @"0", @"uploadedflag",
//                                      [NSNumber numberWithInt:[uniqueTabletOIID integerValue]],@"uniqueTableID",nil];
//        
//        // create new entry for that date
//        [ChildInOutTime createChildInOutTimeContext:[AppDelegate context] withDictionary:dict];
//    }
    
}


@end
