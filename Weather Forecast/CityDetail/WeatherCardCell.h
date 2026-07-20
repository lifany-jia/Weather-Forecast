//
//  WeatherCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const AirQualityCellIdentifier = @"AirQualityCell";
static NSString *const SunCellIdentifier = @"SunCell";
static NSString *const MoonCellIdentifier = @"MoonCell";
@interface WeatherCardCell : UITableViewCell
- (void)updateWithAirData:(CityWeather *) data;
- (void)updateWithSunData:(CityWeather *) data;
- (void)updateWithMoonData:(CityWeather *) data;
@end

NS_ASSUME_NONNULL_END
