//
//  ComentsTableViewCell.h
//  eyLog
//
//  Created by Shuchi on 11/01/16.
//  Copyright © 2016 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments.h"

@protocol ComentsCellDelegate <NSObject>

-(void)editButton:(UIButton *)btn andCell:(UITableViewCell *)cell;
-(void)deleteButton:(UIButton *)btn andCell:(UITableViewCell *)cell;


@end

extern NSString *const ComentsTableViewCellReuseID;


@interface ComentsTableViewCell : UITableViewCell
@property(strong,nonatomic)Comments *coments;
@property(strong,nonatomic)id<ComentsCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *comenterName;
@property (weak, nonatomic) IBOutlet UILabel *comentstring;
@property (weak, nonatomic) IBOutlet UIButton *editButon;
- (IBAction)edit_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
- (IBAction)delete_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
