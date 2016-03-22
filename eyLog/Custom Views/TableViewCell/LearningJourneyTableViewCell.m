//
//  LearningJourneyTableViewCell.m
//  eyLog
//
//  Created by Shuchi on 31/12/15.
//  Copyright © 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "LearningJourneyTableViewCell.h"
#import "Statement.h"
#import "Age.h"
#import "AppDelegate.h"
#import "Statement.h"
#import "Age.h"
#import "Aspect.h"
#import "Framework.h"
#import "Eyfs.h"
#import "Utils.h"
#import "MontessoryViewController.h"
#import "MontessoriFramework.h"
#import "OBCfe.h"
#import "CfeFramework.h"
#import "AppDelegate.h"
#import "Cfe.h"
#import "CfeLevelOne.h"
#import "CfeLevelTwo.h"
#import "CfeLevelThree.h"
#import "CfeLevelFour.h"
#import "CfeAssesmentDataBase.h"
#import "Montessori.h"
#import "MontessoriFramework.h"
#import "LevelTwo.h"
#import "LevelThree.h"
#import "LevelFour.h"
#import "MontessoryLevel2.h"
#import "MontessoryLevel4.h"
#import "MontesoryLevel3.h"
#import "MontesdsoryLevel.h"
#import "CFEAssessmentViewController.h"
#import "CfeFramework.h"
#import "LeuvenScale.h"
#import "Ecat.h"
#import "EcatStatement.h"
#import "EcatFramework.h"
#import "EcatArea.h"
#import "EcatAspect.h"
#import "EcatAreaClass.h"
#import "EcatAspectClass.h"
#import "EcatStatementClass.h"
#import "Framework.h"
#import "Aspect.h"
#import "Statement.h"
#import "COBaseClass.h"
#import "OBCoel.h"
#import "APICallManager.h"
#import "LJCollectionViewCell.h"


NSString* const KLJObservation=@"Observation";
NSString *const KLJAnalysis=@"Analysis";
NSString *const KLJNextSteps=@"Next Steps";
NSString *const KLJAdditionalNotes=@"Additional Notes";


NSString* const LearningJourneyTableViewCellReuseID = @"LearningJourneyTableViewCellReuseID";
@implementation LearningJourneyTableViewCell

- (void)awakeFromNib {
    

    [self.observationCollectioView registerNib:[UINib nibWithNibName:@"LJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LJCollectionViewCellID];
    
    
    [self.frameworksCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //selectedIndexPaths=[NSMutableArray new];
    [_observationTextView setDelegate:self];
    [self.observationCollectioView setBackgroundColor:[UIColor whiteColor]];
    [self.frameworksCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    // Initialization code
}
-(void)dataSetup
{
      NSIndexPath *indexpath=[NSIndexPath indexPathForItem:0 inSection:0];
//    selectedIndexPaths=[NSMutableArray new];
//    selectedIndexpathFramework=[NSMutableArray new];
//    [selectedIndexPaths addObject:indexpath];
//    [selectedIndexpathFramework addObject:indexpath];
    [_frameworksCollectionView setBackgroundColor:[UIColor lightGrayColor]];
    _frameworksCollectionView.layer.borderColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0f].CGColor;
    _frameworksCollectionView.layer.borderWidth=2.0f;
  
}
-(void)clickOnImage
{
    [self.delegate clickOnThumb:self andModel:self.lJModel];
    
}
- (void)viewWillLayoutSubviews
{
    
    [_frameworksCollectionView.collectionViewLayout invalidateLayout];
    [_observationCollectioView.collectionViewLayout invalidateLayout];
}
-(void)layoutSubviews {
 

    UIGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImage)];
    [self.thumbView addGestureRecognizer:tap];
    
    
    isFrameworkHeightCalculated=NO;
    isObservationHeightCalculated=NO;
    
//    [_observationTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_observationCollectioView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_thumbView setTranslatesAutoresizingMaskIntoConstraints:NO];

    if(_frameworkcollectionArray.count==0)
    {
        [_frameworksCollectionView setHidden:YES];
        [_frameworkTextview setHidden:YES];
        
    }
    else
    {
        [_frameworksCollectionView setHidden:NO];
        [_frameworkTextview setHidden:NO];
        

    }
   
    UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRect:self.thumbView.bounds];
    self.thumbView.layer.masksToBounds = NO;
    self.thumbView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.thumbView.layer.shadowOffset = CGSizeMake(-1.0, 2.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    self.thumbView.layer.shadowOpacity = 0.5f;
    self.thumbView.layer.shadowPath = shadowPath2.CGPath;
  
     [self.observationCollectioView setContentOffset:CGPointMake(0, 0)];
    if([_observation isEqualToString:@"Observation"])
    {
        _observationTextView.text=self.lJModel.observation_text;
    }
    if([_observation isEqualToString:@"Analysis"])
    {
        _observationTextView.text=self.lJModel.analysis;
    }
    if([_observation isEqualToString:@"Next Steps"])
    {
        _observationTextView.text=self.lJModel.next_steps;
    }
    if([_observation isEqualToString:@"Additional Notes"])
    {
        _observationTextView.text=self.lJModel.comments;
    }
    
   // [_observationTextView sizeToFit];
    
    if([_framework isEqualToString:@"ECaT"])
    {
        NSString *string =@"";
        
        for (OBEcat *obecat in self.lJModel.ecat) {
            
            NSArray *array=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:obecat.ecatFrameworkItemId withFramework:@"Ecat"];
            EcatStatement *statement=[array lastObject];
            
            NSArray *new=[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withlevelTwoIdentifier:statement.levelTwoIdentifier withFramework:@"Ecat"];
            
            EcatAspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withLevelIdentifier:aspect.levelOneIdentifier withFramework:@"Ecat"];
            
            
            EcatFramework *eact=[ecatarray lastObject];
            
            string=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",string,eact.levelOneDescription,aspect.levelTwoDescription,statement.levelThreeDescription];
            
        }
        _frameworkTextview.text=string;
        
    }
   
    
    
    //  NSIndexPath *newIndexPath=[selectedIndexpathFramework lastObject];
    if([_framework isEqualToString:@"EYFS"])
    {
      
        
        NSString *textStatement = @"";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        for (OBEyfs *obEyfs in self.lJModel.eyfs) {
            
            NSString *assesmentType = @"";
            Statement *statement = [[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obEyfs.frameworkItemId withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            NSNumber *ageIdentifier = nil;
            if (statement) {
                ageIdentifier = statement.ageIdentifier;
            }
            else{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assessmentLevel == %@ OR assessmentLevel == %@",obEyfs.assessmentLevel,[NSNumber numberWithInteger:obEyfs.assessmentLevel.integerValue]];
                NSArray *array = [self.lJModel.eyfs filteredArrayUsingPredicate:predicate];
                if (array.count > 1) {
                    predicate = [NSPredicate predicateWithFormat:@"ageIdentifier == %@",obEyfs.frameworkItemId];
                    // NSArray *array = [ageBandArray filteredArrayUsingPredicate:predicate];
                    //[ageBandArray removeObjectsInArray:array];
                    continue;
                }
                ageIdentifier = @(obEyfs.frameworkItemId.integerValue);
            }
            Age *age = [[Age fetchAgeInContext:[AppDelegate context] withAgeIdentifier:ageIdentifier withFrameWork:NSStringFromClass([Eyfs class])] lastObject];
            
            //                    for (EYLAgeBand *eylAgeBand in ageBandArray) {
            //                        // if (eylAgeBand.levelNumber.integerValue == obEyfs.assessmentLevel.integerValue && eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue) {
            //                        if (eylAgeBand.ageIdentifier.integerValue == ageIdentifier.integerValue){
            //                            [ageBandArray removeObject:eylAgeBand];
            //                            break;
            //                        }
            //                    }
            
            Aspect *aspect = [[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:age.aspectIdentifier withFrameWork:@"EYFS"] lastObject];
            
            Eyfs *eyfs = [[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"EYFS"] lastObject];
            if((!age && !aspect && !eyfs ))
                continue;
            
            Assessment * assesment = [[Assessment fetchAssessmentInContext:[AppDelegate context] withLevelValue:obEyfs.assessmentLevel] firstObject];
            
            NSMutableAttributedString *mut= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", eyfs.areaDesc]
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName: [UIColor blackColor]}];

            
            NSMutableAttributedString *mut1= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"->%@\n", aspect.aspectDesc]
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName: [UIColor blackColor]}];
            NSArray *colors = [assesment.color componentsSeparatedByString:@","];
            UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue]/255.0f green:[colors[1] doubleValue]/255.0f blue:[colors[2] doubleValue]/255.0f alpha:1.0f];
            UIColor *newcolor;
            
            if(colors == nil)
            {
                color=[UIColor whiteColor];
                newcolor=[UIColor blackColor];
                
            }
            else
            {
            
                [UIColor whiteColor];
                newcolor=[UIColor whiteColor];
                
            }
            NSMutableAttributedString *mut2= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"--> %@  ", age.ageDesc]
                                                                                   attributes:@{
                                                                                                NSBackgroundColorAttributeName: color,NSForegroundColorAttributeName :newcolor}];
           
            [attributedString appendAttributedString:mut];
            [attributedString appendAttributedString:mut1];
            [attributedString appendAttributedString:mut2];
            if (statement) {
                
                NSMutableAttributedString *mut3= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n--->%@\n\n", statement.statementDesc]
                                                                                        attributes:@{
                                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]}];
                [attributedString appendAttributedString:mut3];

                //textStatement = [textStatement stringByAppendingString:[NSString stringWithFormat:@"\n--->%@%@\n\n",statement.statementDesc,assesmentType]];
            }
            else{
                
                NSMutableAttributedString *mut4= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n"]];
                 [attributedString appendAttributedString:mut4];
               // textStatement = [textStatement stringByAppendingString:@"\n\n"];
            }


            
//            textStatement = [NSString stringWithFormat:@"%@%@\n->%@\n-->%@",textStatement,eyfs.areaDesc, aspect.aspectDesc, age.ageDesc];
//            if (statement) {
//                textStatement = [textStatement stringByAppendingString:[NSString stringWithFormat:@"\n--->%@%@\n\n",statement.statementDesc,assesmentType]];
//            }
//            else{
//                textStatement = [textStatement stringByAppendingString:@"\n\n"];
//            }
         
            _frameworkTextview.attributedText=attributedString;
            
        }
    }
    if([_framework isEqualToString:@"CoEL"])
    {
        NSString *string = @"";
        
        
        for (OBCoel *obCoel in self.lJModel.coel) {
            
            NSArray *array=[Statement fetchStatementInContext:[AppDelegate context] withStatementIdentifier:obCoel.coelId withFrameWork:@"COEL"];
            Statement *statement=[array lastObject];
            
            NSArray *new=[Aspect fetchAspectInContext:[AppDelegate context] withAspectIdentifier:statement.aspectIdentifier withFrameWork:@"COEL"];
            
            Aspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[Framework fetchFrameworkInContext:[AppDelegate context] withAreaIdentifier:aspect.areaIdentifier withFrameWork:@"COEL" ];
            
            Framework *eact=[ecatarray lastObject];
            
            string=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",string,eact.areaDesc,aspect.aspectDesc,statement.statementDesc];
            
        }
        _frameworkTextview.text=string;
        
    }
    if([_framework isEqualToString:@"ECaT"])
    {
        NSString *string =@"";
        
        for (OBEcat *obecat in self.lJModel.ecat) {
            
            NSArray *array=[EcatStatement fetchEcatStatementInContext:[AppDelegate context] withLevelThreeIdentifier:obecat.ecatFrameworkItemId withFramework:@"Ecat"];
            EcatStatement *statement=[array lastObject];
            
            NSArray *new=[EcatAspect fetchEcatAspectInContext:[AppDelegate context] withlevelTwoIdentifier:statement.levelTwoIdentifier withFramework:@"Ecat"];
            
            EcatAspect *aspect=[new lastObject];
            
            NSArray *ecatarray=[EcatFramework fetchEcatFrameworkInContext:[AppDelegate context] withLevelIdentifier:aspect.levelOneIdentifier withFramework:@"Ecat"];
            
            
            EcatFramework *eact=[ecatarray lastObject];
            
            string=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",string,eact.levelOneDescription,aspect.levelTwoDescription,statement.levelThreeDescription];
            
        }
        
        _frameworkTextview.text=string;
      ;
        
        
        
        
    }
    if([_framework isEqualToString:@"Montessori"])
    {
        NSString *textstatement=@"";
       
        for (OBMontessori *obMonte in self.lJModel.montessory) {
            BOOL isLevelThree;
            isLevelThree=NO;
            LevelFour *lvlfour=[[LevelFour fetchLevelFourInContext:[AppDelegate context] withlevelFourIdentifier:obMonte.montessoriFrameworkItemId withFrameWork:NSStringFromClass([Montessori class])]lastObject];
            LevelThree *lvlThree;
            if (lvlfour) {
                isLevelThree=NO;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:lvlfour.levelThreeIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            }else{
                isLevelThree=YES;
                lvlThree=[[LevelThree fetchLevelTwoInContext:[AppDelegate context] withLevelThreeIdentifier:obMonte.montessoriFrameworkItemId withFramework:NSStringFromClass([Montessori class])] lastObject];
            }
            
            
            LevelTwo *lvlTwo=[[LevelTwo fetchLevelTwoInContext:[AppDelegate context] withlevelTwoIdentifier:lvlThree.levelTwoIdentifier withFramework:NSStringFromClass([Montessori class])] lastObject];
            
            MontessoriFramework *lvlOne=[[MontessoriFramework fetchMontessoryFrameworkInContext:[AppDelegate context] withLevelIdentifier:lvlTwo.levelOneIdentifier withFramework:NSStringFromClass([Montessori class])]lastObject];
            
            if (isLevelThree) {
                textstatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n\n",textstatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription];
            }else{
                textstatement=[NSString stringWithFormat:@"%@%@\n->%@\n-->%@\n--->%@\n\n",textstatement,lvlOne.levelOneDescription,lvlTwo.levelTwoDescription,lvlThree.levelThreeDescription,lvlfour.levelFourDescription];
            }
            
        }
        
        
        _frameworkTextview.text=textstatement;
        
    }
    if([_framework isEqualToString:@"Involvement"])
    {
        
        if([self.lJModel.scale_involvement integerValue]>0)
        {
         
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"involvement" andLeuvenScale:self.lJModel.scale_involvement];
            LeuvenScale *scale=[array lastObject];
            
            _frameworkTextview.text=scale.signals;
            
        }
        
        
    }
    if([_framework isEqualToString:@"Well Being"])
    {
        if([self.lJModel.scale_well_being integerValue]>0)
        {
            
            NSArray *array=  [LeuvenScale fetchLeuvenInContext:[AppDelegate context] withLeuvenScaleType:@"well_being" andLeuvenScale:self.lJModel.scale_well_being];
            LeuvenScale *scale=[array lastObject];
            
            _frameworkTextview.text=scale.signals;
            
        }
    }

      //[_frameworkTextview sizeToFit];
    [self.observationCollectioView.collectionViewLayout invalidateLayout];
    [self.frameworksCollectionView.collectionViewLayout invalidateLayout];

    
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     //[collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    NSLog(@"contentOffset=(%f, %f)", collectionView.contentOffset.x, collectionView.contentOffset.y);

    if(collectionView == _observationCollectioView)
    {
        width=_observationCollectioView.frame.size.width/_observationCollectionArray.count;
  
            return CGSizeMake(width, 50);
    }
    else
    {
        return CGSizeMake(100, 50);
    }
    NSLog(@"contentOffset=(%f, %f)", self.observationCollectioView.contentOffset.x, self.observationCollectioView.contentOffset.y);

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView== _observationCollectioView)
    {
        return _observationCollectionArray.count;
    }
    else
    {
        return _frameworkcollectionArray.count;
        
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        [self.observationCollectioView setContentOffset:CGPointMake(0, 0)];

    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
   if(collectionView == _observationCollectioView)
   {
       
       LJCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:LJCollectionViewCellID forIndexPath:indexPath];
     
       if (cell==nil)
       {
           cell = [[LJCollectionViewCell alloc]init];
       }

       NSString *match;
       
       if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:KLJObservation])
       {
           cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelObservation;
           match=KLJObservation;
           
       }
       if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:KLJAnalysis])
       {
           cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelAnalysis;
            match=KLJAnalysis;
           
       }
       if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:KLJNextSteps])
       {
           cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelNextSteps;
            match=KLJNextSteps;
           
       }
       if([[_observationCollectionArray objectAtIndex:indexPath.row] isEqualToString:KLJAdditionalNotes])
       {
           cell.label.text= [APICallManager sharedNetworkSingleton].baseClass.label.observation.labelComment;
            match=KLJAdditionalNotes;
           
       }
       
       
       
       cell.label.font=[UIFont systemFontOfSize:13.0f];
       
       
      // NSIndexPath *newIndexPath=[selectedIndexPaths lastObject];
       if([match isEqualToString:_observation])
       {
           cell.label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
           //cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
           CAGradientLayer *gradient = [CAGradientLayer layer];
           gradient.frame = cell.contentView.bounds;
           gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor], nil];
           [cell.contentView.layer insertSublayer:gradient atIndex:0];
       }
       else
       {
          cell.contentView.backgroundColor=[UIColor whiteColor];
           cell.label.textColor=[UIColor darkGrayColor];
                   NSPredicate *predicate= [NSPredicate predicateWithFormat: @"class == %@", [CAGradientLayer class]];
           
                   NSArray *array=[cell.contentView.layer.sublayers filteredArrayUsingPredicate:predicate];
           
                   for(CAGradientLayer *layer in [array mutableCopy])
                   {
                       [layer removeFromSuperlayer];
                       
                   }
           
       }
       
         return cell;
   }
    
    if(collectionView == _frameworksCollectionView)
    {
       
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UILabel *label;
        UILabel *labelRound;
         [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
        if (cell==nil)
        {
            cell = [[UICollectionViewCell alloc]init];
          
        }
        for (UILabel *lbl in cell.contentView.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                [lbl removeFromSuperview];
            }
        }
        
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 100, 50)];
        label.font=[UIFont systemFontOfSize:11.0f];
        label.text=[_frameworkcollectionArray objectAtIndex:indexPath.row];

        labelRound=[[UILabel alloc] initWithFrame:CGRectMake(70, 12, 20, 20)];
        labelRound.layer.cornerRadius =10.0;
        labelRound.layer.masksToBounds = YES;

        labelRound.font=[UIFont systemFontOfSize:13.0f];
        [labelRound setTextAlignment:NSTextAlignmentCenter];
        
        [labelRound setBackgroundColor:[UIColor colorWithRed:154.0/255.0 green:155.0/255.0 blue:36.0/255.0 alpha:1.0f]];
        if([label.text isEqualToString:@"EYFS"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d", self.lJModel.eyfs.count];
        }
        if([label.text isEqualToString:@"Montessori"])
        {
           
            labelRound.text=[NSString stringWithFormat:@"%d", self.lJModel.montessory.count];
        }
        if([label.text isEqualToString:@"Involvement"])
        {
            
            if([self.lJModel.scale_involvement integerValue]>0)
            {
                labelRound.text=[NSString stringWithFormat:@"%d", [self.lJModel.scale_involvement integerValue]];
            }
        }
            if([label.text isEqualToString:@"Well Being"])
            {
                if([self.lJModel.scale_well_being integerValue]>0)
                {
                    labelRound.text=[NSString stringWithFormat:@"%d", [self.lJModel.scale_well_being integerValue]];
                }
            }
        if([label.text isEqualToString:@"ECaT"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d", self.lJModel.ecat.count ];

        }
        if([label.text isEqualToString:@"CoEL"])
        {
            labelRound.text=[NSString stringWithFormat:@"%d",self.lJModel.coel.count];

        }
      
        [cell.contentView addSubview:labelRound];
        
        UILabel *labelLine=[[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-2, 4, 1.5, cell.contentView.frame.size.height-8)];
        [labelLine setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell.contentView addSubview:labelLine];
        if([label.text isEqualToString:_framework])
        {
           label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
           cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
            
        }
        else
        {
            cell.contentView.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor darkGrayColor];
            
            
        }
        [cell.contentView addSubview:label];
        return cell;
    }
  
    
    
    return nil;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d ,%d",indexPath.row,indexPath.section);
    
    if(collectionView ==_observationCollectioView)
    {
     _observation=[_observationCollectionArray objectAtIndex:indexPath.row];
        
  
    
        UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
       // cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];
        
        NSArray *viewSubviews =[cell.contentView  subviews];
        for(UIView *v in viewSubviews)
        {
            if([v isKindOfClass:[UILabel class]])
            {
                UILabel *label=(UILabel*)v;
                label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
                
            }
        }
    

    }
    else
    {
        _framework=[_frameworkcollectionArray objectAtIndex:indexPath.row];
        
        
            UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
          // cell.contentView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:191.0/255.0 alpha:1.0f];

            NSArray *viewSubviews =[cell.contentView  subviews];
            for(UIView *v in viewSubviews)
            {
                if([v isKindOfClass:[UILabel class]])
                {
                    UILabel *label=(UILabel*)v;
                    label.textColor=[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:14.0/255.0 alpha:1.0f];
                    
                }
            }
            
        
    }
    [self calculateHeight];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

}
-(void)calculateHeight
{

    [self.delegate selectionOnFrameWorkCollection:_framework AndSelectionOnObservation:_observation andIndexpath:_indexpath];
    
    
}
    
@end
