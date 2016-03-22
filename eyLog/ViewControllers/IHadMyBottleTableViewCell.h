//
//  IHadMyBottleTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 23/06/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IHadMyBottleTableViewCell;

extern NSString * const kIHadMyBottleTableViewCell;

@protocol IHadMyBottleTableViewCellDelegate

- (void) btnAction :(UIButton *) button forTableVIewCell : (IHadMyBottleTableViewCell *) cell atIndexPath : (NSIndexPath *) indexPath;

-(void)textfieldDidEndEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath : (NSIndexPath *) indexPath
;
-(void)textfieldDidBeginEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath : (NSIndexPath *) indexPath
;
-(BOOL)textFieldShouldBeginEditing:(UITextField *)field andCell:(IHadMyBottleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;

@end


@interface IHadMyBottleTableViewCell : UITableViewCell<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (nonatomic, strong) IBOutlet UIButton *btn_At;
@property (nonatomic, strong) IBOutlet UIButton *btn_Drank;
@property (nonatomic, strong) IBOutlet UIButton *btn_Add;
@property (nonatomic, strong) IBOutlet UIButton *btn_Delete;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <IHadMyBottleTableViewCellDelegate> delegate;

- (IBAction)buttonAction:(UIButton *)sender;

@end
