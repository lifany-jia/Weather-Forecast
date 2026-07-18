//
//  CityWeatherViewController.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityWeatherViewController : UIViewController
- (instancetype)initWithCityData:(CityWeather *) cityData;
@end

NS_ASSUME_NONNULL_END
