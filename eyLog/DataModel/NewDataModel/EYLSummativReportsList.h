//
//  EYLSummativReportsList.h
//  eyLog
//
//  Created by Shivank Agarwal on 22/02/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYLSummativReportsList : NSObject

@property (strong, nonatomic) NSString *reportId;
@property (strong, nonatomic) NSString *reportName;
@property (strong, nonatomic) NSString *reportDate;
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) NSString *childId;
@property (strong, nonatomic) NSString *childName;

@end
