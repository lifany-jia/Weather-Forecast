//
//  HourWeatherCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HourWeatherCardCell : UICollectionViewCell
- (void)updateWithData:(HourWeather *) data;
@end

NS_ASSUME_NONNULL_END
