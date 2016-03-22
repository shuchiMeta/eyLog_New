//
//  DailyDiaryViewController.h
//  eyLog
//
//  Created by Arpan Dixit on 26/05/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChilderenViewController.h"
#import "RegistryFlagsTableViewCell.h"
#import "RegistryDataEntity.h"


typedef NS_ENUM(NSUInteger, RegistrySubItems)
{
    RegistryCameIn = 701,
    RegistryLeftAt,
    RegistryAbsent,
    RegistryHoliday,
    RegistrySick,
    RegistryNoBooks,
    RegistryAdd,
    RegistryDelete,
    
};

typedef NS_ENUM(NSUInteger, NappiesSubItems)
{
    NappiesWhen = 301,
    NappiesDry,
    NappiesWet,
    NappiesSoiled,
    NappiesNappyRash,
    NappiesCreamApplied,
    NappiedAdd,
    NappiesDelete,
};

typedef NS_ENUM(NSUInteger, ToiletingTodaySubItems)
{
    ToiletingWhen=801,
    ToiletingWentOnThePotty,
    ToiletingWentOntheToilet,
    ToiletingITried,
    ToiletingAdd,
    ToiletingDelete,
};

typedef NS_ENUM(NSUInteger, IHadMyBottleSubItems)
{
    IHadMyBottleAt=601,
    IHadMyBottleDrank,
    IHadMyBottleAdd,
    IHadMyBottleDelete,
};

typedef NS_ENUM(NSUInteger, SleepTimesSubItems)
{
    SleepTimesFeelAsleep=501,
    SleepTimesWokeUp,
    SleepTimeSleptMins,
    SleepTimesAdd,
    SleepTimesDelete,
};

typedef NS_ENUM(NSUInteger, AdditionalNotesSubItems)
{
    ANNotesFromParents=98,
    ANNotesToParents,
};


@interface DailyDiaryViewController : UIViewController<UITextViewDelegate>
{
    BOOL isNappiesFilled;
    BOOL isToiletingFilled;
    BOOL isIHadMyBottleFilled;
    BOOL isSleepTimesFilled;
    BOOL isNotesToParentsFilled;
    BOOL isRegistryFilled;
    BOOL isWhatIateToday;
    BOOL isComentsAdded;
    BOOL isSaveOtherDateRecord;
    BOOL isDiaryFetched;
    BOOL isRegistryFetched;
}


@property (nonatomic, strong) NSString *strCurrentDate;

@property (weak, nonatomic) ChilderenViewController *parentVC;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITextView *textView_Parents;
@property (weak, nonatomic) IBOutlet UITextView *textView_Notes;
@property (weak, nonatomic) IBOutlet UIButton *btn_NotesToParents;
@property (weak, nonatomic) IBOutlet UIButton *btn_NotesFromParents;


@property (nonatomic, strong) IBOutlet UIView *transparentView;
@property (nonatomic, weak) IBOutlet UIImageView *transparentImageView;
@property (nonatomic, strong) UIView *viewNav;
@property(nonatomic,assign)BOOL isHideOtherTabs;

@property (nonatomic, strong) NSString *lastSaveDate;


@property (nonatomic) BOOL isDailyDiaryPublished;
// Properties to the checkbox selected

@property (assign ,nonatomic) BOOL tick_Registry;
@property (assign ,nonatomic) BOOL tick_Nappies;
@property (assign ,nonatomic) BOOL tick_WhatIate;
@property (assign ,nonatomic) BOOL tick_Toileting;
@property (assign ,nonatomic) BOOL tick_IHadMyBottle;
@property (assign ,nonatomic) BOOL tick_SleepTimes;
@property (assign ,nonatomic) BOOL tick_AdditionalNotes;
@property (strong, nonatomic) NSMutableArray *localRegistryObjects;
@property (nonatomic, assign) BOOL loadDailyDiary;
@property (nonatomic,assign)  BOOL isComeFromNotesNotifcation;
@property (nonatomic,strong)  NSNumber *diaryID;
@property (nonatomic,strong)  NSNumber *childID;

- (IBAction)buttonParentsAction:(UIButton *)sender;
@end
