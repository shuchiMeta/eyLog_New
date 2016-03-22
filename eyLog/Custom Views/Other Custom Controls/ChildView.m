 //
//  ChildView.m
//  eyLog
//
//  Created by Qss on 9/18/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChildView.h"
#import "Utils.h"
#import "NewObservationViewController.h"
#import "AppDelegate.h"
#import "DateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DraftLIstCell.h"
#import "DailyDiaryViewController.h"
#import "EYL_AppData.h"

AppDelegate *appDelegate;
BOOL firstTime;
@implementation ChildView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [NSNotificationCenter defaultCenter];
        NSNotification* notification = [NSNotification notificationWithName:@"UpdateDatePicker" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (resetDate:) name:@"UpdateDatePicker" object:nil];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        [self.childImage setBackgroundColor:[UIColor whiteColor]];
   // self.dateButton.layer.borderWidth=0.6f;
    self.dateButton.layer.cornerRadius=8.0f;
    
    //self.dateLabel.layer.borderWidth=0.6f;
    self.dateLabel.layer.cornerRadius=8.0f;
    
    
    self.practionerImage.image=[Utils getPractionerImgae];
    self.childImage.image=[Utils getChildImage];
    
    if([Utils getChildImage]==nil)
    {
        self.childImage.image=[UIImage imageNamed:@"eylog_Logo"];
    
        
        //[containerView.childImage setBackgroundColor:[UIColor blackColor]];
        NSLog(@"%@",containerView.childImage);
        
        //im,g
    }
    else
    {
        self.childImage.image=[Utils getChildImage];
    }

    self.practitionerName.text=[Utils getPractionerName];
    
//    self.childName.text=@"";
//    self.childGroup.text=@"";
    
    self.childName.text=[Utils getChildName];
    
    
    self.childGroup.text=[Utils getChildGroupName];
    self.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];
    self.childGroup.font = [UIFont systemFontOfSize:10.0f];
    
    //self.practitionerGroup.text=[Utils getPractitionerGroupName];
    self.practitionerGroup.text =[Utils getPractitionerGroupName];
    
    if(self.childName.text.length==1||self.childName.text==0)
    {
        self.childName.text=[Utils getChildName];
        self.childGroup.text=[Utils getChildGroupName];
        self.childGroup.text=  [NSString stringWithFormat:@"%@%@",[Utils getMonthsString:[APICallManager sharedNetworkSingleton].cacheChild.ageMonths],[Utils getChildGroupName].length>0?[NSString stringWithFormat:@", %@",[Utils getChildGroupName]]:@""];
        self.childGroup.font = [UIFont systemFontOfSize:10.0f];
        
        //self.practitionerGroup.text=[Utils getPractitionerGroupName];
        self.practitionerGroup.text =[Utils getPractitionerGroupName];
        
    }

    
    if(_isComeFromDailyDiary)
    {
        if ([self.dateLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0)
        {
            NSDateFormatter *formatter;
            NSString   *dateString;
           
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd-MMM-yyyy"];
           
            
            dateString = [formatter stringFromDate:[NSDate date]];
            self.dateLabel.text =dateString;
            
            [EYL_AppData sharedEYL_AppData].savePickerDate = dateString;
            
        }

    }
    else
    {
        
        
        if (appDelegate.ObservationFlag==1)
        {
            if ([self.dateLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0)
            {
                NSDateFormatter *formatter;
                NSString   *dateString;
                if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
                {
                    formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                }
                else
                {
                    formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                }
                
                dateString = [formatter stringFromDate:[NSDate date]];
                self.dateLabel.text =dateString;
                
                [EYL_AppData sharedEYL_AppData].savePickerDate = dateString;
                
            }
        }
        else{
            
            self.dateLabel.hidden =YES;
        }
    }
    
    self.childNotificationLabel.layer.cornerRadius=9.0f;
    [self.practionerImage.layer setCornerRadius:14.0f];
    self.childImage.layer.cornerRadius=14.0f;
    self.childImage.clipsToBounds = YES;
    self.practionerImage.clipsToBounds=YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)childImageClicked:(id)sender
{
    NSLog(@"Child Image Clicked");
    [self.delegate showPopOverChildrenSelection:sender];
}

- (IBAction)DatePick:(id)sender
{
    _dateButton.enabled=NO;
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(300, 100, 400, 400)];
    //[self.datePicker setMaximumDate:[NSDate date]];
    
    //[datePicker setDate:[NSDate dateFromString]];
    

    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.datePicker addTarget:self action:@selector(updateText:) forControlEvents:UIControlEventValueChanged];
    
    
    toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(300, 60, 400, 40)];
    
    [toolbar setBarTintColor:[UIColor colorWithRed:165.0f/255.0f green:168.0f/255.0f blue:23.0f/255.0f alpha:1.0]];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:
                                      
                                      UIBarButtonItemStyleBordered target:self action:@selector(removeDatePicker)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:
                                      
                                      UIBarButtonItemStyleBordered target:self action:@selector(hideDatePicker)];

    toolbar.items = [[NSArray alloc] initWithObjects:barButtonDone,flexibleItem,barButtonCancel, nil];
    barButtonDone.tintColor=[UIColor whiteColor];
    barButtonCancel.tintColor = [UIColor whiteColor];
    
    NSDateFormatter *formattor;
    formattor =[[NSDateFormatter alloc]init];
      formattor.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    
    NSString *str =_dateLabel.text;
    NSLog(@" %@",str);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    
    if(_isComeFromDailyDiary)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
          dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        
    }

    else
    {
        if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
              dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            self.datePicker.datePickerMode = UIDatePickerModeDate;
        }
        else
        {
            dateFormatter = [[NSDateFormatter alloc] init];
              dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
    NSDate *dateFromString = [dateFormatter dateFromString:str];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone]; //set here the timezone you want
 
    
    [dateFormatter setTimeZone:timeZone];
    dateFromString = dateFromString?:[NSDate date];
    self.lastPickerDate = dateFromString;
    [self.datePicker setDate:dateFromString];    
    [self.delegate showDateTimePicker:self.datePicker toolbar:toolbar];
}

-(void)removeDatePicker
{
    NSLog(@"%@", self.datePicker.date);
     
    [self.delegate setDate:self.datePicker.date];

    [self.datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    _dateButton.enabled=YES;
}

-(void) resetDate :(NSNotification *) notification
{
    NSLog(@"Reset the date");
//    
//    NSString *str =_dateLabel.text;
//    NSLog(@" %@",str);
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
//    NSDate *dateFromString = [dateFormatter dateFromString:str];
//    dateFromString = dateFromString?:[NSDate date];
//    [self.datePicker setDate:dateFromString];
//    
    [self.datePicker setDate:self.lastPickerDate];
  
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
      outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    if(_isComeFromDailyDiary)
    {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd-MMM-yyyy"];
    }

    else
    {
        if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
        {
            outputFormatter = [[NSDateFormatter alloc] init];
              outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [outputFormatter setDateFormat:@"YYYY-MM-dd"];
        }
        else
        {
            outputFormatter = [[NSDateFormatter alloc] init];
              outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [outputFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
    NSString *dateString = [outputFormatter stringFromDate:self.lastPickerDate];
    _dateLabel.text=dateString;

}

-(void)hideDatePicker
{
    [self.datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    _dateButton.enabled=YES;
    
    [self.datePicker setDate:self.lastPickerDate];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
     outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    if(_isComeFromDailyDiary)
    {
        outputFormatter = [[NSDateFormatter alloc] init];
          outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
        [outputFormatter setDateFormat:@"dd-MMM-yyyy"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else
    {
        if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
        {
            outputFormatter = [[NSDateFormatter alloc] init];
              outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [outputFormatter setDateFormat:@"YYYY-MM-dd"];
        }
        else
        {
            outputFormatter = [[NSDateFormatter alloc] init];
              outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [outputFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
    NSString *dateString = [outputFormatter stringFromDate:self.lastPickerDate];
    _dateLabel.text=dateString;
}

-(void)updateText:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
   
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
     outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    if(_isComeFromDailyDiary)
    {
        outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd-MMM-yyyy"];
        
    }
    else
    {
        if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
        {
            outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"YYYY-MM-dd"];
        }
        else
        {
            outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
   //
    

    NSString *str =dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
    if(_isComeFromDailyDiary)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        _dateStringSavedForDD=dateString;
    }
    else
    {
        if([APICallManager sharedNetworkSingleton].settingObject.observationDateFormat==1)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
             dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        }
        else
        {
            dateFormatter = [[NSDateFormatter alloc] init];
             dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
    _dateLabel.text=dateString;

    NSDate *dateFromString = [dateFormatter dateFromString:str];
    NSLog(@"%@" ,dateFromString);
}

//- (void) clearText
//{
//    self.childName.text=@"";
//    self.dateButton.titleLabel.text=@"";
//    self.childGroup.text=@"";
//}

- (void) setLabelMenu :(NSString *) name
{
    self.lbl_MenuOption.text=name;
}
@end
