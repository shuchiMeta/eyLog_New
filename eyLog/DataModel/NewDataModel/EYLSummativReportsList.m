//
//  EYLSummativReportsList.m
//  eyLog
//
//  Created by Shivank Agarwal on 22/02/15.
//  Copyright (c) 2015 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import "EYLSummativReportsList.h"

@implementation EYLSummativReportsList

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.reportId = [aDecoder decodeObjectForKey:@"reportId"];
    self.reportName = [aDecoder decodeObjectForKey:@"reportName"];
    self.reportDate = [aDecoder decodeObjectForKey:@"rgbColor"];
    self.mode = [aDecoder decodeObjectForKey:@"mode"];
    self.childId = [aDecoder decodeObjectForKey:@"childId"];
    self.childName = [aDecoder decodeObjectForKey:@"childName"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_reportId forKey:@"reportId"];
    [aCoder encodeObject:_reportName forKey:@"reportName"];
    [aCoder encodeObject:_reportDate forKey:@"reportDate"];
    [aCoder encodeObject:_mode forKey:@"mode"];
    [aCoder encodeObject:_reportDate forKey:@"reportDate"];
    [aCoder encodeObject:_reportDate forKey:@"reportDate"];

}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.reportId forKey:@"reportId"];
    [mutableDict setValue:self.reportName forKey:@"reportName"];
    [mutableDict setValue:self.reportDate forKey:@"reportDate"];
    [mutableDict setValue:self.mode forKey:@"mode"];
    [mutableDict setValue:self.childId forKey:@"childId"];
    [mutableDict setValue:self.childName forKey:@"childName"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

@end
