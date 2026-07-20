//
//  WeatherCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import "AllCityWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const AirQualityCellIdentifier = @"AirQualityCell";
static NSString *const SunCellIdentifier = @"SunCell";
static NSString *const MoonCellIdentifier = @"MoonCell";
@interface WeatherCardCell : UITableViewCell
- (void)updateWithAirData:(CityWeatherModel *) data;
- (void)updateWithSunData:(CityWeatherModel *) data;
- (void)updateWithMoonData:(CityWeatherModel *) data;
@end

NS_ASSUME_NONNULL_END
