//
//  ObservationViewController.h
//  eyLog
//
//  Created by Qss on 8/28/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYLNewObservationAttachment.h"

@protocol observationPopOverDelegate <NSObject>

-(void)closeButtonAction:(id)sender;
-(void)doneButtonAction:(id)sender;


@end
@interface ObservationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property(nonatomic,assign) id<observationPopOverDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (weak,  nonatomic) IBOutlet UIButton *eyfsAssessmentButton;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSMutableArray * eylNewObservationAttachmentArray;
@property (assign, nonatomic) BOOL showEYFS;
@property (assign, nonatomic) BOOL showCFE;
@property (assign, nonatomic)  BOOL showMontessori;
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isDraft;
@property (strong, nonatomic) NSMutableArray *montessoriData;
@property (strong, nonatomic) NSMutableArray *cfeData;
@property (strong, nonatomic) NSMutableArray *eyfsData;
@property (strong, nonatomic) NSMutableArray *eyfsAgeData;
@property (strong,nonatomic) ObservationViewController *observationViewController;
@property (weak, nonatomic) IBOutlet UIButton *montessoriButton;

- (IBAction)doneAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)eyfsAssessmentClicked:(UIButton *)sender;

@end
