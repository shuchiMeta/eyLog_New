//
//  ChildInfoTableViewCell.h
//  eyLog
//
//  Created by Arpan Dixit on 22/07/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kChildInfoTableViewCellIdentifier;

@interface ChildInfoTableViewCell : UITableViewCell


@property (nonatomic, strong)IBOutlet UILabel *lblName;
@property (nonatomic, strong)IBOutlet UILabel *lblDescription;


@end
