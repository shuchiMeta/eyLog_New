//
//  Setting.h
//  eyLog
//
//  Created by Qss on 10/29/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NURSERYOBSERVATIONPOLICY) {

    KeyChildren=1,
    Group,
    ALL,
};
typedef NS_ENUM(NSInteger, MONTESSORI_ZERO_TO_THREE) {
    
   DISABLE_ZERO_TO_3=0,
   ENABLE_ZERO_TO_3=1,
};

typedef NS_ENUM(NSInteger, OBSERVATIONDATEFORMAT) {

    DDMMYYYY=1,
    DDMMYYYHHMMSS,
};

typedef NS_ENUM(NSInteger, MONTESSORI)
{
    HIDE_MONTESSORI=0,
    DISPLAY_MONTESSORI,
};

typedef NS_ENUM(NSInteger, ELG) {

    HIDE_ELG=0,
    DISPLAY_ELG,
};

typedef NS_ENUM(NSInteger, ECAT)
{
    HIDE_ECAT=0,
    DISPLAY_ECAT,
};

typedef NS_ENUM(NSInteger, DAILYDIARY) {
    HIDE_DIALY_DIARY=0,
    DISPLAY_DAILY_DIARY,
};

typedef NS_ENUM(NSInteger, CHILDMINDER)
{
    HIDE_CHILD_MINDER=0,
    DISPLAY_CHILD_MINDER,
};

typedef NS_ENUM(NSInteger, CHILDINVOLVEMENT){
    HIDE_CHILD_INVOLVEMENT=0,
    DISPLAY_CHILD_INVOLVEMENT,
};

@interface Setting : NSObject

@property(nonatomic,assign) NSInteger childInvolvement;
@property(nonatomic,assign) NSInteger childMinder;
@property(nonatomic,assign) NSInteger dailyDiary;
@property(nonatomic,assign) NSInteger ecat;
@property(nonatomic,assign) NSInteger elg;
@property(nonatomic,assign) NSInteger montessori;
@property(nonatomic,assign) NSInteger coel;
@property(nonatomic,assign) NSInteger nurseryObservationPolicy;
@property(nonatomic,assign) NSInteger observationDateFormat;
@property(nonatomic,assign) NSInteger montesoori_enable_Zero_to_three;
@property (nonatomic, strong) NSString *frameworkType;


@property(nonatomic,assign) NURSERYOBSERVATIONPOLICY nurseryobservationpolicy;
@property(nonatomic,assign) OBSERVATIONDATEFORMAT dateFormatType;
@property(nonatomic,assign) MONTESSORI montessoriType;
@property(nonatomic,assign) ECAT ecatType;
@property(nonatomic,assign) ELG elgType;
@property(nonatomic,assign) DAILYDIARY dailyDiaryType;
@property(nonatomic,assign) CHILDMINDER childMinderType;
@property(nonatomic,assign) CHILDINVOLVEMENT childInvolvementType;
@property(nonatomic,assign) MONTESSORI_ZERO_TO_THREE zero_to_three;

- (id)initWithSettingDictionary:(NSDictionary *)dict;
@end


