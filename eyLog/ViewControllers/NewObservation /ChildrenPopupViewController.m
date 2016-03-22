//
//  ChildrenPopupViewController.m
//  eyLog
//
//  Created by MDS_Abhijit on 19/11/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "ChildrenPopupViewController.h"
#import "GridViewController.h"
#import "APICallManager.h"
#import "NewObservation.h"
#import "NewObservationAttachment.h"
#import "AppDelegate.h"

@interface ChildrenPopupViewController () <UITextFieldDelegate,GridViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ChildrenPopupViewController
{
    NSArray *childrenListForTableView;
    NSMutableSet *originalSelection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    originalSelection = [[NSMutableSet alloc] initWithArray:[APICallManager sharedNetworkSingleton].cacheChildren];

    GridViewController *gridViewController =  ((GridViewController *)[self.childViewControllers objectAtIndex:0]);
    gridViewController.delegate = self;
    gridViewController.tableView.hidden=YES;
    gridViewController.isPopUp = YES;
    [gridViewController.collectionViewController reloadData];

    self.doneButton.layer.cornerRadius = 10.0;

    if(originalSelection.count >= 1)
    {
        [self.doneButton setHidden:NO];
    }
    else
    {
    [self.doneButton setHidden:YES];
    }
    
}
-(void)didselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([APICallManager sharedNetworkSingleton].cacheChildren.count == 0) {
        self.doneButton.hidden = YES;
    }
    else{
        [self.doneButton setHidden:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonClicked:(id)sender {


    [self.delegate doneBtnClicked:sender forChildrenPopupViewController:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
//        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    else
    {
        [self searchChild:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
//        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    else
    {
        [self searchChild:textField.text];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==1 && [string isEqualToString:@""])
    {
//        [self groupDidSelected:self.groupButton.titleLabel.text withCellType:KCellTypeGroup];
    }
    return YES;
}



-(void)searchChild:(NSString *)practitionerString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@", practitionerString];
    NSArray *currentGroup = [[APICallManager sharedNetworkSingleton].childArray mutableCopy];


    NSArray *filteredArray = [currentGroup filteredArrayUsingPredicate:predicate];
    if(filteredArray.count>0)
    {
        childrenListForTableView=[filteredArray mutableCopy];
        NSDictionary *viewData=@{@"data": childrenListForTableView};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
    }
    else
    {
        childrenListForTableView=@[];
        NSDictionary *viewData=@{@"data": childrenListForTableView};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectionView" object:nil userInfo:viewData];
    }
}



@end
