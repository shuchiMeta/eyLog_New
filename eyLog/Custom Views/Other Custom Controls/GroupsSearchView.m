//
//  GroupsSearchView.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 26/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "GroupsSearchView.h"
#import "Theme.h"
#import "AppDelegate.h"
#import "ChilderenViewController.h"
AppDelegate *appDelegate;
@implementation GroupsSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [imageView setImage:[UIImage imageNamed:@"Groups_Search"]];
    self.searchBar.leftView = imageView;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"Group_Search_Cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setFrame:CGRectMake(0, 0, 25, 25)];
    self.searchBar.rightView = cancelButton;
    [self.searchBar.rightView setUserInteractionEnabled:YES];
    
    self.searchBar.leftViewMode = UITextFieldViewModeAlways;
    self.searchBar.rightViewMode = UITextFieldViewModeAlways;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.searchBar setFont:[UIFont fontWithName:kSystemFontRobotoCondensedR size:17]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)searchButtonClicked:(UIButton *)sender {
   
    if(appDelegate.HomesearchFlag==1)
    {
        appDelegate.searchClicked=1;
        appDelegate.HomesearchFlag=0;
    }
   [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearAction" object:nil];
    [sender setHidden:YES];
    [self.searchBar setHidden:NO];
    self.backgroundColor = UIColorFromRGM(239, 240, 115);
    [self.searchBar becomeFirstResponder];
}

- (void)cancelButtonClicked:(UIButton *)sender
{
    [self.searchBar setText:[NSString string]];
    [self.searchBar resignFirstResponder];
    [self.searchBar setHidden:YES];
    [self.searchButton setHidden:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDraftList" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil];
}
@end
