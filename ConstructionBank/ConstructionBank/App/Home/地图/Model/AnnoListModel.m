//
//  AnnoListModel.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/9/12.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "AnnoListModel.h"

@implementation AnnoListModel

- (NSString *)topLeftString{
    if (_topLeft) {
        NSString *str = [NSString stringWithFormat:@"%@,%@",_topLeft[@"lat"],_topLeft[@"lon"]];
        return str;
    }
    return nil;
}

- (NSString *)bottomRightString{
    if (_bottomRight) {
        NSString *str = [NSString stringWithFormat:@"%@,%@",_bottomRight[@"lat"],_bottomRight[@"lon"]];
        return str;
    }
    return nil;
}

- (CLLocationCoordinate2D)arcCoordinate{
    if (_topLeft||_bottomRight) {
        
        double lat1 = [_topLeft[@"lat"] doubleValue];
        double lon1 = [_topLeft[@"lon"] doubleValue];
        
        double lat2 = [_bottomRight[@"lat"] doubleValue];
        double lon2 = [_bottomRight[@"lon"] doubleValue];
        
        double lat3 = [self randomFloatBetween:lat2 andLargerFloat:lat1 ];
        double lon3 = [self randomFloatBetween:lon1 andLargerFloat:lon2 ];
        return CLLocationCoordinate2DMake(lat3, lon3);
    }
    
    return CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
}

-(double)randomFloatBetween:(double)num1 andLargerFloat:(double)num2
{
    double delta = (num2 - num1)*((arc4random()%100)/100.0);
    
    return num1+delta;
}

- (CLLocationCoordinate2D)coordinate{
    if (_longitude&&_latitude) {
        return  CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (NSString *)coorString{
    if (_latitude.length&&_longitude.length) {
        return [NSString stringWithFormat:@"%.6f%.6f",[_latitude floatValue],[_longitude floatValue]];
    }
    return @"";
}

- (BOOL)isZeroPoint{
    BOOL value = fabs([_latitude doubleValue])+fabs([_longitude doubleValue]);
    return !value;
}

@end

