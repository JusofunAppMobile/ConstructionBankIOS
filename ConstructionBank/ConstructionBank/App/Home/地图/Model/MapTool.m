//
//  MapTool.m
//  ConstructionBank
//
//  Created by JUSFOUN on 2018/8/28.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "MapTool.h"

@implementation MapTool
//已知经纬度，方位角，距离，求另一点经纬度
+ (CLLocationCoordinate2D)getCoordinateWithCenter:(CLLocationCoordinate2D)center distance:(double)distance angle:(double)brng{
    
    /** 长半径a=6378137 */
    double a = 6378137;
    /** 短半径b=6356752.3142 */
    double b = 6356752.3142;
    //** 扁率f=1/298.2572236 */
    double f = 1 / 298.2572236;
    
    double alpha1 = [self rad:brng];//rad(brng)
    double sinAlpha1 = sin(alpha1);
    double cosAlpha1 = cos(alpha1);
    
    double tanU1 = (1 - f) * tan([self rad:center.latitude]);
    double cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
    double sinU1 = tanU1 * cosU1;
    double sigma1 = atan2(tanU1, cosAlpha1);
    double sinAlpha = cosU1 * sinAlpha1;
    double cosSqAlpha = 1 - sinAlpha * sinAlpha;
    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    
    double cos2SigmaM = 0;
    double sinSigma = 0;
    double cosSigma = 0;
    double sigma = distance / (b * A), sigmaP = 2 * M_PI;
    while (fabs(sigma - sigmaP) > 1e-12) {
        cos2SigmaM = cos(2 * sigma1 + sigma);
        sinSigma = sin(sigma);
        cosSigma = cos(sigma);
        double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)
                                                                  - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
        sigmaP = sigma;
        sigma = distance / (b * A) + deltaSigma;
    }
    
    double tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
    double lat2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
                        (1 - f) * sqrt(sinAlpha * sinAlpha + tmp * tmp));
    double lambda = atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
    double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    double L = lambda - (1 - C) * f * sinAlpha
    * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    
    double lon = center.longitude + [self deg:L];
    double lat = [self deg:lat2];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
    
    return coor;
    
}

+ (double)deg:(double)degree{
    return degree*180/M_PI;
    
}
+ (double)rad:(double)radian{
    return radian*M_PI/180.0;
    
}

@end
