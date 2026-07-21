//
//  HourWeatherModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import "HourWeatherModel.h"

@implementation HourWeatherModel
- (instancetype)initWithHour:(NSInteger)hour temperature:(CGFloat)hour_temp icon:(NSString *)icon code:(NSInteger)code{
    self = [super init];
    if (self) {
        self.hour = hour;
        self.hour_temp = hour_temp;
        self.hour_temp_icon = icon;
        self.code = code;
    }
    return self;
}
@end
