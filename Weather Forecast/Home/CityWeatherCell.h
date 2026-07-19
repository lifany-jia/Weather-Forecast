//
//  CityWeatherCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface CityWeatherCell : UITableViewCell
- (void)updateWithData:(CityWeather *) data;
@end

NS_ASSUME_NONNULL_END
