//
//  GroupsSearchView.h
//  eyLog
//
//  Created by Lakshaya Chhabra on 26/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupsSearchView : UIView
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *searchBar;

- (IBAction)searchButtonClicked:(UIButton *)sender;
@end
