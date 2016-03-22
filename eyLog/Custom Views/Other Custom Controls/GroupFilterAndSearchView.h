//
//  GroupFilterAndSearchView.h
//  eyLog
//
//  Created by MDS_Abhijit on 08/12/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupsPopoverView.h"
#import "GroupsSearchView.h"

@interface GroupFilterAndSearchView : UIView

@property (weak, nonatomic) IBOutlet GroupsSearchView *groupSearch;
@property (weak, nonatomic) IBOutlet GroupsPopoverView *groupPopup;

@end
