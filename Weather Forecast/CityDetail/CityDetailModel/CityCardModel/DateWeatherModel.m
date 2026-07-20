//
//  DateWeatherModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import "DateWeatherModel.h"

@implementation DateWeatherModel
- (instancetype)initWithDate:(NSString *)date max_temp:(CGFloat)max_temp min_temp:(CGFloat)min_temp icon:(NSString *)icon code:(NSInteger)code{
    self = [super init];
    if (self) {
        self.date = date;
        self.max_temp = max_temp;
        self.min_temp = min_temp;
        self.day_temp_icon = icon;
        self.code = code;
    }
    return self;
}
@end
