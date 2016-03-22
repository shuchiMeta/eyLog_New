//
//  Theme.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 23/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomBarButton_InOut.h"

#define kSystemFontRobotoMI             @"Roboto-MediumItalic"
#define kSystemFontRobotoR              @"Roboto-Regular"
#define kSystemFontRobotoT              @"Roboto-Thin"
#define kSystemFontRobotoM              @"Roboto-Medium"
#define kSystemFontRobotoBl             @"Roboto-Black"
#define kSystemFontRobotoLI             @"Roboto-LightItalic"
#define kSystemFontRobotoBCI            @"Roboto-BoldCondensedItalic"
#define kSystemFontRobotoBI             @"Roboto-BoldItalic"
#define kSystemFontRobotoCI             @"Roboto-CondensedItalic"
#define kSystemFontRobotoBlI            @"Roboto-BlackItalic"
#define kSystemFontRobotoC              @"Roboto-Condensed"
#define kSystemFontRobotoL              @"Roboto-Light"
#define kSystemFontRobotoB              @"Roboto-Bold"
#define kSystemFontRobotoI              @"Roboto-Italic"
#define kSystemFontRobotoTI             @"Roboto-ThinItalic"
#define kSystemFontRobotoBC             @"Roboto-BoldCondensed"
#define kSystemFontRobotoCondensedBI    @"RobotoCondensed-BoldItalic"
#define kSystemFontRobotoCondensedL     @"RobotoCondensed-Light"
#define kSystemFontRobotoCondensedLI    @"RobotoCondensed-LightItalic"
#define kSystemFontRobotoCondensedR     @"RobotoCondensed-Regular"
#define kSystemFontRobotoCondensedB     @"RobotoCondensed-Bold"

#define UIColorFromRGM(R, G, B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define yellowColor [UIColor colorWithRed:193/255.0f green:196/255.0f blue:84/255.0f alpha:1.0f]

#define darkYellowButtonColor [UIColor colorWithRed:102/255.0f green:104/255.0f blue:0/255.0f alpha:1.0f]

#define grayBackgroundColorForTableViewCell [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f]

// You needs to Implement to get the selection Data
// Data may contains Images Audio Video only and you allways get an Array
@protocol LibraryActionsDelegate <NSObject>

@optional

- (void)didFinishPickingMedia:(NSArray *)media;
//-(void)uploadObservations;
-(void)saveImageInDirectory:(UIImage *)image;
-(void)saveVideoInDirectory:(NSURL *)url;
-(void)saveRecordedVideoInDirectory:(NSURL *)url;
-(void)saveAudioInDirectory:(NSURL *)url;
-(void)saveAssestVideoInDirectory:(NSData *)data;
@end
@protocol ThemeDelegate;

@interface Theme : NSObject<UIActionSheetDelegate,CustomBarButton_InOutDelegate>

@property(nonatomic,strong)UILabel *myLabel;
@property (assign, nonatomic) id <LibraryActionsDelegate> delegate;
@property (assign, nonatomic) BOOL saveInGallery;
@property (weak, nonatomic) id <ThemeDelegate> themeDelegate;
@property(strong,nonatomic)NSNumber  *observerID;

@property (strong, nonatomic) CustomBarButton_InOut *IN_button;
@property (strong, nonatomic) CustomBarButton_InOut *OUT_button;


//@property (nonatomic, strong) UIButton *submitButton;
+ (Theme *)getTheme;
- (void)addToolbarItemsToViewCaontroller:(UIViewController *)controller;
- (void)resetTargetViewController:(UIViewController *)controller;
- (void)popOverInView:(UIView *)view withButton:(id)sender;
+ (BOOL)isDateGreaterThanDate:(NSDate*)greaterDate and:(NSDate*)lesserDate;
+ (NSString *)getMinuteAndHoursFromNSDate :(NSDate *) date;
@property (assign,nonatomic) BOOL onlyView;

@end
@protocol ThemeDelegate <NSObject>

@optional
-(void)saveAsDraftInNewObservationVC:(id)sender;
-(void)submitObservationInNewObservationVC:(id)sender;
-(void)saveAsDraftInDailyDiaryVC:(id)sender;
-(void)submitInDailyDiaryVC:(id)sender;

@end
